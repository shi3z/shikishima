// isa_patch: assemble Xe2 ISA text with libiga and splice it into a zebin's .text.<kernel> section.
//   isa_patch [-a] in.zebin kernel_name kernel.asm out.zebin        (-a: assemble with IGA auto dependency (SWSB) generation; also: isa_patch -d in.zebin kernel_name > out.asm)
#include <iga/iga.h>
#include <elf.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
static std::vector<char> rd(const char* p) { FILE* f = fopen(p, "rb"); if (!f) { perror(p); exit(1); } fseek(f, 0, SEEK_END); long n = ftell(f); fseek(f, 0, SEEK_SET); std::vector<char> v(n); if (fread(v.data(), 1, n, f) != (size_t)n) exit(1); fclose(f); return v; }
int main(int argc, char** argv) {
  bool dis = argc > 1 && !strcmp(argv[1], "-d"); bool autodep = argc > 1 && !strcmp(argv[1], "-a"); int a = (dis || autodep) ? 2 : 1;
  if (argc < a + 2) { fprintf(stderr, "usage\n"); return 1; }
  auto z = rd(argv[a]); std::string sec = std::string(".text.") + argv[a + 1];
  auto* eh = (Elf64_Ehdr*)z.data(); auto* sh = (Elf64_Shdr*)(z.data() + eh->e_shoff);
  const char* strt = z.data() + sh[eh->e_shstrndx].sh_offset; int idx = -1;
  for (int i = 0; i < eh->e_shnum; i++) if (sec == strt + sh[i].sh_name) idx = i;
  if (idx < 0) { fprintf(stderr, "section %s not found\n", sec.c_str()); return 1; }
  iga_context_options_t co = IGA_CONTEXT_OPTIONS_INIT(IGA_XE2); iga_context_t ctx;
  if (iga_context_create(&co, &ctx) != IGA_SUCCESS) { fprintf(stderr, "ctx\n"); return 1; }
  if (dis) {
    iga_disassemble_options_t dopt = IGA_DISASSEMBLE_OPTIONS_INIT(); char* txt;
    auto st = iga_context_disassemble(ctx, &dopt, z.data() + sh[idx].sh_offset, (uint32_t)sh[idx].sh_size, nullptr, nullptr, &txt);
    if (st != IGA_SUCCESS) { fprintf(stderr, "dis fail %s\n", iga_status_to_string(st)); return 1; }
    fputs(txt, stdout); return 0;
  }
  auto txt = rd(argv[a + 2]); txt.push_back(0);
  iga_assemble_options_t ao = IGA_ASSEMBLE_OPTIONS_INIT(); void* bin; uint32_t bn;
  ao.encoder_opts = IGA_ENCODER_OPT_AUTO_COMPACT; if (autodep) { ao.encoder_opts |= IGA_ENCODER_OPT_AUTO_DEPENDENCIES; ao.sbid_count = 32; }
  auto st = iga_context_assemble(ctx, &ao, txt.data(), &bin, &bn);
  if (st != IGA_SUCCESS) {
    fprintf(stderr, "assemble: %s\n", iga_status_to_string(st));
    const iga_diagnostic_t* d; uint32_t n;
    if (iga_get_errors(ctx, &d, &n) == IGA_SUCCESS) for (uint32_t i = 0; i < n; i++) fprintf(stderr, "  line %u col %u: %s\n", d[i].line, d[i].column, d[i].message);
    return 1;
  }
  size_t off = (z.size() + 63) & ~size_t(63); z.resize(off + bn); memcpy(z.data() + off, bin, bn);
  eh = (Elf64_Ehdr*)z.data(); sh = (Elf64_Shdr*)(z.data() + eh->e_shoff);
  sh[idx].sh_offset = off; sh[idx].sh_size = bn;
  // update symbol sizes for the kernel symbol
  for (int i = 0; i < eh->e_shnum; i++) if (sh[i].sh_type == SHT_SYMTAB) {
    auto* sy = (Elf64_Sym*)(z.data() + sh[i].sh_offset); int ns = sh[i].sh_size / sizeof(Elf64_Sym); const char* ss = z.data() + sh[sh[i].sh_link].sh_offset;
    for (int k = 0; k < ns; k++) if (!strcmp(ss + sy[k].st_name, argv[a + 1])) sy[k].st_size = bn;
  }
  FILE* f = fopen(argv[a + 3], "wb"); fwrite(z.data(), 1, z.size(), f); fclose(f);
  fprintf(stderr, "patched %s: %u bytes\n", sec.c_str(), bn); return 0;
}
