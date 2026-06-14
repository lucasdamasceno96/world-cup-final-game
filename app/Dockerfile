# Multi-stage build for a minimal and secure production image
FROM python:3.11-slim as builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.11-slim
WORKDIR /app

# Copy installed dependencies from builder stage
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# Run as non-root user for security best practices
USER nobody

# Copy application code
COPY . .

# Expose port 8080 (standard requirement for Google Cloud Run)
EXPOSE 8080

# Start Uvicorn server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]