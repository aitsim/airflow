FROM python:3.7-alpine3.8

# Create app directory
RUN mkdir -p /opt/app
WORKDIR /opt/app

# Install build deps, then run `pip install`, then remove unneeded build deps all in a single step.
RUN set -ex \
    && apk add libpq shadow \
    && apk add --no-cache --virtual .build-deps \
            gcc \
            tmux \
            make \
            libcurl \
            curl-dev \
            libc-dev \
            musl-dev \
            linux-headers \
            pcre-dev \
            libffi-dev \
            ncurses-dev \
            python3-dev \
            libxslt-dev \
            libxml2-dev \
            postgresql-libs \
            postgresql-dev \
            postgresql-client \
            g++ \
            bash \
            cargo \
            pigz \
    && cargo install --git https://github.com/BurntSushi/xsv --force --version 0.13.0 xsv \
    && rm -rf /var/cache/apk/*

RUN pip install pipenv

COPY Pipfile Pipfile.lock ./
RUN pipenv install --system --deploy --dev --verbose

ENV AIRFLOW_HOME=/opt/app

ADD . ./