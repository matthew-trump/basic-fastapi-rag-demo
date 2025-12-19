SYSTEM_INSTRUCTIONS = """You are a helpful assistant.
Answer the user's question using ONLY the provided context.
If the context is insufficient, say you don't know.
Cite sources by chunk id in square brackets, like [chunk:123]."""

def build_context_block(chunks: list[dict]) -> str:
    # chunks: [{id, source, content}]
    lines = []
    for ch in chunks:
        lines.append(f"[chunk:{ch['id']}] source={ch['source']}\n{ch['content']}")
    return "\n\n".join(lines)
