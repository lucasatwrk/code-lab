from pydantic_settings import BaseSettings, SettingsConfigDict

class ApiServerConfig(BaseSettings):
    data_path: str = "memo.md"

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

def load_config(config_file=None):
    if config_file is None:
        return ApiServerConfig()
    return ApiServerConfig(_env_file=config_file)
