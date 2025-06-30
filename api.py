from fastapi import FastAPI, Query
import subprocess

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Welcome to the Scraper API!"}

@app.get("/scrape")
def scrape(url: str = Query(..., description="Amazon department page URL to scrape")):
    try:
        result = subprocess.run(['make', 'scrape', f'URL={url}'], capture_output=True, text=True, timeout=300)
        if result.returncode != 0:
            return {"error": result.stderr}, 500  # 500 Internal Server Error
        return {"message": "Scraping done", "output": result.stdout}
    except subprocess.TimeoutExpired:
        return {"error": "Scraping timed out"}, 504  # 504 Gateway Timeout
