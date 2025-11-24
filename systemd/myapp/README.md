# Simple app

Ways to run the app:

```sh
uv run app.py
uv run -m fastapi dev app.py
uv run -m uvicorn --factory src.main:create_app --host=0.0.0.0
```
