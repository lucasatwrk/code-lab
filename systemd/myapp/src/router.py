from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import RedirectResponse
import aiohttp
import logging

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/api")

@router.get("/")
def api_root():
    return RedirectResponse(router.url_path_for("status"))

@router.get("/status")
def status(request: Request):
    return {
        "status": "running",
        "config": request.app.state.config
    }

@router.get("/uuid")
async def uuid():
    async with aiohttp.ClientSession() as session:
        logging.info("[uuid] request uuid")
        async with session.get("https://httpbin.org/uuid") as response:
            logging.info("[uuid] status: %s, content type: %s", response.status, response.headers["content-type"])
            if response.status != 200:
                raise HTTPException(
                    status_code=response.status,
                    detail=response.reason,
                    headers={"X-Error": "Something went wrong"},
                )
            else:
                uuid_json = await response.json()
                return uuid_json
