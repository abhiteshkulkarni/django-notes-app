# ------------------------------
# Stage 1: Builder
# ------------------------------
FROM python:3.9 AS builder

WORKDIR /app/backend

# Install system packages needed to build mysqlclient
RUN apt-get update \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies into a temporary folder
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir --prefix=/install mysqlclient \
    && pip install --no-cache-dir --prefix=/install -r requirements.txt


# ------------------------------
# Stage 2: Final Slim Image
# ------------------------------
FROM python:3.9-slim AS final

WORKDIR /app/backend

# Install runtime MySQL library (smaller than dev package)
RUN apt-get update \
    && apt-get install -y default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy already-built Python packages from builder image
COPY --from=builder /install /usr/local

# Copy application code
COPY . .

EXPOSE 8000

CMD ["python", "app.py"]

#RUN python manage.py migrate
#RUN python manage.py makemigrations
