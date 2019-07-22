# Extra theme performance bug report

This is a minimal project running a fresh copy of Wordpress 5.2.2 with the default database as of July 2019. This has been tested with a fresh copy of the `Extra` theme v2.26.3.

What has been added:

* A `test` user with the password `test`.
* 25 main categories, with each one having 10 sub-categories and 5 sub-sub-categories (see `migrations/00013_fill_categories.up.sql`).
* The plugin [Query Monitor](https://wordpress.org/plugins/query-monitor/) has been added to show the performance bugs.
* All other plugins have been deleted
* Only one article is present (the default one when installing Wordpress)

## Running instructions

### Software requirements

* `Docker`
* `docker-compose`

### Extra theme

The `Extra` theme is needed and not provided (for obvious reasons). After copying the `Extra` theme folder into the project, you should have a directory tree looking like this:

This has been tested with a fresh copy of the `Extra` theme v2.26.3.

```
.
├── Extra          <---- Added by you
├── README.md
├── docker-compose.yaml
├── migrations
├── query-monitor
└── run.sh
```

### Running the test site

On Linux or OSX:

```
$ ./run.sh
```

On Windows:

```
docker-compose run --rm wait_for_database
docker-compose run --rm migrations
docker-compose up wordpress
```

After running the commands, you should be able to go to [http://localhost:8080/](http://localhost:8080/).

### bug #1 (frontpage)

1. log in with the `test` user at [http://localhost:8080/wp-admin](http://localhost:8080/wp-admin) (password: test)
2. return back to the website at [http://localhost:8080/](http://localhost:8080/)
3. click on the **Query Monitor** data on the admin bar (the numbers on the right of **Edit layout**):
   ![query monitor](screen_01.png?raw=true "query monitor")
4. open the **Duplicate Queries** tab of **Query Monitor**
5. check the amount of queries made:
   ![query monitor](screen_02.png?raw=true "query monitor")

**Bug #1**: **60 duplicated** mysql calls being made to `WP_Query->get_posts` to render the front page. On my site in production, I have over **2000** duplicated calls and the page takes 15 seconds to render despite being on a dedicated host (dual core) with 2GB of RAM. Adding an object cache does nothing as those queries apparently were not cached.

### bug #2 (categories)

1. log in with the `test` user at [http://localhost:8080/wp-admin](http://localhost:8080/wp-admin) (password: test)
2. return back to the website at [http://localhost:8080/](http://localhost:8080/)
3. click on any category
3. click on the **Query Monitor** data on the admin bar (the numbers on the right of **Edit layout**)
4. open the **Duplicate Queries** tab of **Query Monitor**
5. check the amount of queries made:
   ![query monitor](screen_03.png?raw=true "query monitor")

**Bug #2**: **58 duplicated** mysql calls being made to `WP_Query->get_posts` to render a category (even with no articles in the category). On my site in production, I have over **2000** duplicated calls and the page takes 15 seconds to render despite being on a dedicated host (dual core) with 2GB of RAM. Adding an object cache does nothing as those queries apparently were not cached.

## Conclusion

There is clearly a performance issue regarding categories. This minimal project containing only one article and 25 main categories clearly shows it.
