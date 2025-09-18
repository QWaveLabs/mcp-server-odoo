FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Install uv first
RUN pip install uv

# Copy the entire application
COPY . .

# Install dependencies
RUN uv pip install --system -e .

# Create a non-root user
RUN useradd --create-home --shell /bin/bash app \
    && chown -R app:app /app
USER app

# Expose the port (Railway will override this with $PORT)
EXPOSE 8000

# Command to run the application with HTTP transport using Railway's PORT env var
CMD ["sh", "-c", "python -m mcp_server_odoo --transport streamable-http --host 0.0.0.0 --port ${PORT:-8000}"]