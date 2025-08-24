# Build frontend
FROM node:20-alpine AS ui
WORKDIR /ui
ENV CI=true
COPY frontend/package.json ./
COPY frontend/package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY frontend ./
RUN npm run build

# Backend image
FROM python:3.11-slim AS api
WORKDIR /app
# System deps
RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*
COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY backend ./
# Copy built frontend
COPY --from=ui /ui/build ./static
ENV PORT=8000
EXPOSE 8000
CMD ["sh", "-lc", "uvicorn app:app --host 0.0.0.0 --port ${PORT}"]
