from fastapi import FastAPI, Query
import subprocess

app = FastAPI()

@app.get("/scrape")
def scrape(url: str = Query(..., description="Amazon department page URL to scrape")):
    try:
        result = subprocess.run(f'make scrape URL="{url}"', shell=True, capture_output=True, text=True, timeout=300)
        if result.returncode != 0:
            return {"error": result.stderr}
        return {"message": "Scraping done", "output": result.stdout}
    except subprocess.TimeoutExpired:
        return {"error": "Scraping timed out"}
