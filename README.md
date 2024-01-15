# luaonbeans

A tiny [redbean](https://redbean.dev/) MVC Lua framework [![CircleCI](https://dl.circleci.com/status-badge/img/circleci/WNgXuxBoP6PPsRmbqkSY4Q/GzWFpN9LomjWyZqBGsVQMp/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/circleci/WNgXuxBoP6PPsRmbqkSY4Q/GzWFpN9LomjWyZqBGsVQMp/tree/main)

[![CircleCI](https://dl.circleci.com/status-badge/img/circleci/WNgXuxBoP6PPsRmbqkSY4Q/GzWFpN9LomjWyZqBGsVQMp/tree/main.svg?style=svg&circle-token=6573c35ff19389928a46ff68a0c04e24c3257e8d)](https://dl.circleci.com/status-badge/redirect/circleci/WNgXuxBoP6PPsRmbqkSY4Q/GzWFpN9LomjWyZqBGsVQMp/tree/main)
## Getting started

First clone the repository

```sh
git clone https://github.com/solisoft/luaonbeans.git --depth=1
```

You need then to configure arangoDB (using brew or docker) and create a new database :

Then configure the `config/database.json` file

Then run `./redbean.com -D .` ; You should be able to open : [http://localhost:8080](http://localhost:8080)


Create a `beans` alias for your favorite shell

```sh
alias beans="./luaonbeans.org -i beans"
```

then once your shell is reloaded simply run

```sh
beans specs
```

Shoud return somthing similar

```text
Setup test DB
Running migrations ...
[PASS] arangodb driver | Aql | run request
[PASS] arangodb driver | Aql | fail running request
[PASS] arangodb driver | CreateDocument | create document
[PASS] arangodb driver | GetDocument | get document
[PASS] arangodb driver | UpdateDocument | update document
[PASS] arangodb driver | DeleteDocument | delete document
[PASS] arangodb driver | Create and delete Collection | create and delete collection
[PASS] arangodb driver | GetAllIndexes | get all indexes
[PASS] arangodb driver | CreateIndex | create index
[PASS] arangodb driver | DeleteIndex | delete index
[PASS] arangodb driver | Create and Delete Database | create and delete database
[SKIP] arangodb driver | GetQueryCacheEntries | get query cache
[SKIP] arangodb driver | GetQueryCacheConfiguration | get query cache configuration
[SKIP] arangodb driver | UpdateCacheConfiguration | update query cache configuration
[SKIP] arangodb driver | DeleteQueryCache | delete query cache configuration
[SKIP] arangodb driver | RefreshToken | refresh auth token
[====] arangodb driver | 11 successes / 5 skipped / 0.056264 seconds
[PASS] luaonbeans | welcome#index | load page
[====] luaonbeans | 1 successes / 0.017907 seconds
[PASS] utilities | table.keys
[PASS] utilities | table.append
[PASS] utilities | table.contains
[PASS] utilities | table.merge
[PASS] utilities | string.split
[PASS] utilities | string.to_slug
[PASS] utilities | Pluralize
[PASS] utilities | Singularize
[PASS] utilities | Capitalize
[PASS] utilities | Camelize
[====] utilities | 10 successes / 0.000343 seconds
22 successes / 5 skipped / 0 failures / 0.077219 seconds
```

## Beans commands

```sh
beans create controller posts
beans create model post
beans create scaffold posts
beans create migration add_indexes_to_posts

beans db:setup
beans db:migrate
beans db:rollback

beans specs
```

## TODO

- Add specs for controllers & models from templates
- File Upload
- Oauth2

!!! This project is under development !!!
