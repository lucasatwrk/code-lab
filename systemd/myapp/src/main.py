from fastapi import FastAPI
from contextlib import asynccontextmanager

import logging
from .router import router
from .config import load_config

@asynccontextmanager
async def lifespan(app: FastAPI):
    logging.info("[lifespan] server started")
    yield
    logging.info("[lifespan] server exit...")

def create_app(test_config=None):
    app = FastAPI(lifespan=lifespan)
    app.include_router(router)

    config = load_config() if test_config is None else test_config
    app.state.config = config

    @app.get("/healthz")
    def healthz():
        return {"status": "ok"}
    
    return app
