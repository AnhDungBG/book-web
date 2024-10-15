# Base image
FROM python:3.12.4

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy entrypoint script
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
# Copy project files
COPY . .

# Run entrypoint script
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]