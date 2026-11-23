//! Builds the SYCL kernel library (kernels/build.sh -> build/libxik.so) and links it.
//! Run binaries through scripts/b60run (library path + GPU lock).
use std::path::PathBuf;
use std::process::Command;

fn main() {
    let root = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let out = root.join("build");
    println!("cargo:rerun-if-changed={}", root.join("kernels").display());
    let ok = Command::new("bash").arg(root.join("kernels/build.sh")).arg(&out).status().expect("build.sh").success();
    assert!(ok, "kernels/build.sh failed");
    println!("cargo:rustc-link-search=native={}", out.display());
    println!("cargo:rustc-link-lib=dylib=xik");
}
