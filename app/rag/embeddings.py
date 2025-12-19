from __future__ import annotations

import hashlib
from typing import Iterable

from app.rag.schema import EMBEDDING_DIM
from app.rag.settings import settings
from app.rag.openai_client import get_openai_client

def _hash_embedding(text: str) -> list[float]:
    # Deterministic pseudo-embedding for mock mode.
    # Produces EMBEDDING_DIM floats in [-1, 1].
    h = hashlib.sha256(text.encode("utf-8")).digest()
    out: list[float] = []
    seed = h
    while len(out) < EMBEDDING_DIM:
        seed = hashlib.sha256(seed).digest()
        for b in seed:
            out.append((b / 127.5) - 1.0)
            if len(out) >= EMBEDDING_DIM:
                break
    return out

def embed_texts(texts: Iterable[str]) -> list[list[float]]:
    texts_list = [t if isinstance(t, str) else str(t) for t in texts]
    if settings.mode == "mock":
        return [_hash_embedding(t) for t in texts_list]

    client = get_openai_client()
    resp = client.embeddings.create(
        model=settings.openai_embedding_model,
        input=texts_list,
    )
    return [item.embedding for item in resp.data]
