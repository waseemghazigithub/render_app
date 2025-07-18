FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg2 unixodbc unixodbc-dev apt-transport-https

# Add Microsoft SQL ODBC driver 13 repo
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql13

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . /app
WORKDIR /app

# Streamlit settings
ENV STREAMLIT_PORT=8000
EXPOSE 8000

CMD ["streamlit", "run", "cropinfo.py", "--server.port=8000", "--server.address=0.0.0.0"]
