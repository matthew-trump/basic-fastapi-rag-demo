from __future__ import annotations

from app.rag.settings import settings
from app.rag.openai_client import get_openai_client
from app.rag.prompts import SYSTEM_INSTRUCTIONS

def generate_answer(question: str, context: str) -> str:
    if settings.mode == "mock":
        return (
            "MOCK MODE ANSWER\n"
            f"Question: {question}\n\n"
            "Context preview:\n"
            + (context[:800] + ("..." if len(context) > 800 else ""))
        )

    client = get_openai_client()
    # Use the Responses API (recommended for new projects)
    response = client.responses.create(
        model=settings.openai_model,
        instructions=SYSTEM_INSTRUCTIONS,
        input=f"Context:\n{context}\n\nQuestion:\n{question}",
    )
    return response.output_text
