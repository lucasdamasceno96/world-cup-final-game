from fastapi import FastAPI

app = FastAPI(
    title="World Cup Final Ticketing API",
    description="High-concurrency ticketing system",
    version="1.0.0"
)

@app.get("/health")
def health_check():
    """
    Health check endpoint used by the Global Load Balancer 
    to verify service readiness and liveness during massive traffic spikes.
    """
    return {"status": "healthy", "service": "ticketing-api"}