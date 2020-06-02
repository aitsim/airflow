# airflow

## Introduction


This repository complete my blog about airflow , which is hosted at:

https://www.obytes.com/blog/getting-started-with-apache-airflow


## Build and Run

```

docker-coompose build
docker-coompose up -d 


```

## Usage

By default, docker-airflow runs Airflow with **SequentialExecutor**  you can use  CeleryExecutor by setting an env variable :
`AIRFLOW__CORE__EXECUTOR=CeleryExecutor`


NB : If you want to have DAGs example loaded (default=False), you've to set the following environment variable :

`AIRFLOW__CORE__LOAD_EXAMPLES=True`


If you want to use Ad hoc query, make sure you've configured connections:
Go to Admin -> Connections and Edit "postgres_default" set this values (equivalent to values in docker-compose*.yml) :

- Host : airflow_db
- Schema : airflow
- Login : postgres
- Password : postgres

For encrypted connection passwords (in Local or Celery Executor), you must have the same fernet_key. By default airflow generates the fernet_key at startup, you have to set an environment variable in the docker-compose env file  
`AIRFLOW__CORE__FERNET_KEY=fernet_key`

```
docker exec -ti container_id python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)"

```

## Configuring Airflow

It's possible to set any configuration value for Airflow from environment variables, which are used over values from the airflow.cfg.

The general rule is the environment variable should be named `AIRFLOW__<section>__<key>`, for example `AIRFLOW__CORE__SQL_ALCHEMY_CONN` sets the `sql_alchemy_conn` config option in the `[core]` section.
`AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgres://postgres:postgres@airflow_db:5432/airflow`  for a connection hook called "sql_alchemy_conn"

Check out the [Airflow documentation](http://airflow.readthedocs.io/en/latest/howto/set-config.html#setting-configuration-options) for more details


## UI Links

- Airflow: [localhost:8080](http://localhost:8080/)

## Running other airflow commands

If you want to run other airflow sub-commands, such as `list_dags` or `clear` you can do so like this:

    docker run --rm -ti container_id airflow list_dags

or with your docker-compose set up like this:

    docker-compose run --rm airflow_webserver airflow list_dags

You can also use this to run a bash shell or any other command in the same environment that airflow would be run in:

    docker run --rm -ti container_id bash
    docker run --rm -ti container_id ipython

## Simplified SQL database configuration using PostgreSQL

If the executor type is set to anything else than *SequentialExecutor* you'll need an SQL database.
Here is a list of PostgreSQL configuration variables and their default values. They're used to compute
the `AIRFLOW__CORE__SQL_ALCHEMY_CONN` and `AIRFLOW__CELERY__RESULT_BACKEND` 

You can also use those variables to adapt your compose file to match an existing PostgreSQL instance managed elsewhere.

Here's an important thing to consider:

> When specifying the connection as URI (in AIRFLOW_CONN_* variable) you should specify it following the standard syntax of DB connections .