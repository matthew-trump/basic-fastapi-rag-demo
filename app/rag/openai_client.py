from __future__ import annotations

from openai import OpenAI
from app.rag.settings import settings

_client: OpenAI | None = None

def get_openai_client() -> OpenAI:
    global _client
    if _client is None:
        # OPENAI_API_KEY is read automatically by the SDK when env var is set,
        # but we pass it explicitly for clarity.
        _client = OpenAI(api_key=settings.openai_api_key)
    return _client
