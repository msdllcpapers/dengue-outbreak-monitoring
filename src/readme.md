# Dengue Outbreak DB

## Installations
- [Docker](https://docs.docker.com/engine/install/)


## Run Local Postgres database and apply Dengue Outbreak DB dump 

[Dengue Outbreak DB dump](./dengue_outbreak_article_db_dump.sql)

### In Docker (locally): 

```bash
    ./start-env.sh
```

| **Connection parameter** | **Connection value** |
|--------------------------|----------------------|
| Host                     | `localhost:7432`     |
| Database                 | `article_db`         |
| User                     | `article`            |
| Password                 | `article`            |

**Note:** on Windows install [git bash](https://gitforwindows.org/) or [cygwin](https://www.cygwin.com/)

### On remote Postgres server:

- Connect to remote Postgres server
- Create database: `psql -U <SQL_USER_NAME> postgres -c "create database dengue_db"`
- Apply dump: `psql -U <SQL_USER_NAME> dengue_db -f ./dengue_outbreak_article_db_dump.sql`


### Dengue Outbreak view

In is recomended to use `dengue_outbreak_view` to access data

```sql
    -- get only valid dengue outbreak records 
    select * from dengue_outbreak_view 
    where validation_error is null 
    order by pub_date 
    limit 10;
```