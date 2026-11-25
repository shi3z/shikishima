#!/usr/bin/env python3
"""Remove SWSB annotations ({$n}, {I@n}, {F@n}, ...) and sync instructions from IGA text so that isa_patch -a regenerates the dependencies."""
import re, sys
out = []
for l in open(sys.argv[1]).read().split('\n'):
    if re.match(r'\s*sync\.', l): continue
    m = re.search(r'\{([^}]*)\}\s*(//.*)?$', l)
    if m:
        toks = [t.strip() for t in m.group(1).split(',')]
        keep = [t for t in toks if not re.match(r'^(\$\d+(\.(src|dst))?|[IFAMSL]@\d+|Compacted|NoCompact|@\d+)$', t)]
        l = l[:m.start()] + ('{' + ','.join(keep) + '}' if keep else '') + ('  ' + m.group(2) if m.group(2) else '')
    out.append(l.rstrip())
open(sys.argv[2], 'w').write('\n'.join(out) + '\n')
