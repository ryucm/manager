FROM python:3.11.4-slim-buster

RUN apt-get update && apt-get install -y \
    build-essential \
    libmariadb-dev-compat \
    libmariadb-dev \
    pkg-config

RUN pip install --no-cache-dir poetry

WORKDIR /app

COPY pyproject.toml poetry.lock* ./

RUN poetry config virtualenvs.create false
RUN poetry install --no-root --no-interaction --no-ansi

COPY . .

ENV AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=mysql://root:admin@mysql-service.k8s-system:3306/airflowdb
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
