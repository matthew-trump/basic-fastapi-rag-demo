from __future__ import annotations

from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

from app.rag.settings import settings
from app.rag.schema import Base

engine = create_engine(settings.database_url, pool_pre_ping=True)
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)

def init_db() -> None:
    # Ensure pgvector extension exists (no-op if already created)
    with engine.begin() as conn:
        conn.execute(text("CREATE EXTENSION IF NOT EXISTS vector;"))
    Base.metadata.create_all(bind=engine)

    # Attempt to create an IVFFLAT index (safe to fail in constrained envs)
    # Requires: SET ivfflat.probes at query-time for tuning (optional).
    with engine.begin() as conn:
        try:
            conn.execute(text("""
                DO $$
                BEGIN
                    IF NOT EXISTS (
                        SELECT 1 FROM pg_class c
                        JOIN pg_namespace n ON n.oid = c.relnamespace
                        WHERE c.relname = 'idx_chunks_embedding_ivfflat'
                    ) THEN
                        CREATE INDEX idx_chunks_embedding_ivfflat
                        ON chunks USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
                    END IF;
                END $$;
            """))
        except Exception:
            # It's fine if this fails (e.g., small demo DB, permissions, etc.)
            pass
