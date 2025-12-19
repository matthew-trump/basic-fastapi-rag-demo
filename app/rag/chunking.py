from __future__ import annotations

from dataclasses import dataclass

@dataclass(frozen=True)
class ChunkedText:
    index: int
    text: str

def chunk_text(text: str, chunk_size: int, overlap: int) -> list[ChunkedText]:
    text = (text or "").strip()
    if not text:
        return []

    if overlap >= chunk_size:
        overlap = max(0, chunk_size // 4)

    chunks: list[ChunkedText] = []
    start = 0
    idx = 0
    while start < len(text):
        end = min(len(text), start + chunk_size)
        chunk = text[start:end].strip()
        if chunk:
            chunks.append(ChunkedText(index=idx, text=chunk))
            idx += 1
        if end == len(text):
            break
        start = max(0, end - overlap)
    return chunks
