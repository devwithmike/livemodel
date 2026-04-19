from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    app_env: str = "development"
    cors_origins: list[str] = ["http://localhost:5173"]
    database_url: str = "postgresql://insight:insight@localhost:5432/insight"
    redis_url: str = "redis://localhost:6379/0"

settings = Settings()