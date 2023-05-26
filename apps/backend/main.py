import os
import requests
import logging
from fastapi import FastAPI, Response
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

logging.basicConfig()
logging.root.setLevel(logging.INFO)
logger = logging.getLogger(__name__)

class Prompt(BaseModel):
    prompt: str
    temperature: float | None = 0.5
    max_tokens: int | None = 100
    model: str | None = "gpt-3.5-turbo-0301"

app = FastAPI()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

api_endpoint = "https://api.openai.com/v1/chat/completions"
api_key = os.getenv("API_KEY")
headers = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {api_key}"
}

@app.post("/prompt/")
async def send_prompt(prompt: Prompt):

    data = {
        "messages": [{"role": "user", "content": prompt.prompt}],
        "temperature": prompt.temperature,
        "max_tokens": prompt.max_tokens,
        "model": prompt.model
    }
  
    response = requests.post(api_endpoint, headers=headers, json=data).json()
    logger.info(str(response))
    choices = response.get("choices")
    response_description = "No response received from ChatGPT API"
    status_code = 404

    if choices:
        response_description = ""
        for choice in choices:
            message=choice["message"]["content"].strip()
            response_description = f"{response_description}{message}"
        
        status_code = 200
    elif response.get("error"):
        response_description=response.get("error").get("message")
    
    json_compatible_item_data = jsonable_encoder({"response": response_description})
    return JSONResponse(content=json_compatible_item_data, status_code=status_code)
    