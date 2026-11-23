//! safetensors reader (mmap) — only the pieces the engine needs.
use memmap2::Mmap;
use std::{fs::File, path::Path};

pub struct Tensor {
    pub name: String,
    pub dtype: String,
    pub shape: Vec<usize>,
    pub start: usize,
    pub end: usize,
}

pub struct Safetensors {
    pub map: Mmap,
    pub tensors: Vec<Tensor>,
    base: usize,
}

impl Safetensors {
    pub fn open(path: &Path) -> Result<Self, String> {
        let f = File::open(path).map_err(|e| format!("{}: {e}", path.display()))?;
        let map = unsafe { Mmap::map(&f) }.map_err(|e| e.to_string())?;
        let n = u64::from_le_bytes(map[..8].try_into().unwrap()) as usize;
        let h: serde_json::Value = serde_json::from_slice(&map[8..8 + n]).map_err(|e| e.to_string())?;
        let mut tensors = vec![];
        for (k, v) in h.as_object().ok_or("bad header")? {
            if k == "__metadata__" {
                continue;
            }
            let off = v["data_offsets"].as_array().ok_or("offsets")?;
            tensors.push(Tensor {
                name: k.clone(),
                dtype: v["dtype"].as_str().unwrap_or("").to_string(),
                shape: v["shape"].as_array().map(|a| a.iter().map(|x| x.as_u64().unwrap() as usize).collect()).unwrap_or_default(),
                start: off[0].as_u64().unwrap() as usize,
                end: off[1].as_u64().unwrap() as usize,
            });
        }
        tensors.sort_by_key(|t| t.start);
        Ok(Self { map, tensors, base: 8 + n })
    }
    pub fn bytes(&self, t: &Tensor) -> &[u8] {
        &self.map[self.base + t.start..self.base + t.end]
    }
}
