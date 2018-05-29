# Exporting Production Data for Local Development Environment

THIS IS A WORK IN PROGRESS.

This is a sample of how I (Seth Carstens) implimented the sample data set for local development of fansided.dev, which now comes pre-packaged into the local provision script. The below should be used as a reference to setup sample data of another site, or to update the sample data on fansided.dev. There is an example exports zip file that shows what to expect as results for each step.

[localdev-fansided-site-example-exports](assets/dev-assets/setup-files/localdev-fansided-site-example-exports.zip)

#### STEP 0: Trancate and Admin User
- Truncate all data in all tables (do not delete the tables)
- Add the admin user back manually since wp cli doesn't allow username `admin`
```
INSERT INTO `wp_users` (`ID`, `user_login`, `user_pass`, `user_nicename`, `user_email`, `user_url`, `user_registered`, `user_activation_key`, `user_status`, `display_name`, `spam`, `deleted`)
VALUES
    (1, 'admin', '$P$BTZ3q2QL1LpFXF5a4Ku7g2AulxTF30.', 'admin', 'admin@vvv.dev', '', '2015-12-08 02:08:49', '', 0, 'FanSided Local', 0, 0);
```
- Import CSV File with all admin usermeta so its a user on all sites
[LOCAL ADMIN USER META CSV](assets/dev-assets/setup-files/s0b-fansided.com-wp_229-usermeta-localadmin.csv)

#### STEP 1a: export posts query to csv

```
SELECT * FROM wp_229_posts WHERE (post_type LIKE "post" AND post_status NOT LIKE "auto-draft") ORDER BY ID DESC LIMIT 500;
```

#### STEP 1b: get all related meta for exported posts  

```
SELECT p.meta_id, p.post_id, p.meta_key, p.meta_value FROM wp_229_postmeta as p INNER JOIN 
  (SELECT ID FROM wp_229_posts WHERE (post_type LIKE "post" AND post_status NOT LIKE "auto-draft") ORDER BY ID DESC LIMIT 500) as p2
ON p.post_id = p2.ID ORDER BY p2.ID ASC;
```
  
#### STEP 2a: Export post attachments related as featured images
```
SELECT * FROM wp_229_posts as p3 WHERE ID IN ( 
  SELECT meta_value as ID FROM wp_229_postmeta as p INNER JOIN 
    (SELECT ID FROM wp_229_posts WHERE (post_type LIKE "post" AND post_status NOT LIKE "auto-draft") ORDER BY ID DESC LIMIT 500) as p2
    ON p.post_id = p2.ID WHERE meta_key = '_thumbnail_id' ORDER BY p2.ID ASC
  ) ORDER BY ID DESC LIMIT 5000;
```

#### STEP 2b: Export post attachments meta data
```
SELECT p.meta_id, p.post_id, p.meta_key, p.meta_value FROM wp_229_postmeta as p INNER JOIN 
  (
    SELECT ID FROM wp_229_posts as p3 WHERE ID IN ( 
      SELECT meta_value as ID FROM wp_229_postmeta as p INNER JOIN 
        (SELECT ID FROM wp_229_posts WHERE (post_type LIKE "post" AND post_status NOT LIKE "auto-draft") ORDER BY ID DESC LIMIT 500) as p2
      ON p.post_id = p2.ID WHERE meta_key = '_thumbnail_id' ORDER BY p2.ID ASC
    ) ORDER BY ID DESC LIMIT 5000
  ) as p2
ON p.post_id = p2.ID ORDER BY p2.ID ASC;
```

#### STEP 3a: export all non-post post types like menus, fandoms etc
```
SELECT * FROM wp_229_posts WHERE (post_type NOT LIKE "post" AND post_type NOT LIKE "draft" AND post_type NOT LIKE "hub" AND post_type NOT LIKE "revision" AND post_type NOT LIKE "attachment" AND post_type NOT LIKE "wpseo_crawl_issue" ) ORDER BY ID DESC LIMIT 10000;
```

#### STEP 3b: export all non-post post types like menus, fandoms etc meta data
```
SELECT p.meta_id, p.post_id, p.meta_key, p.meta_value FROM wp_229_postmeta as p INNER JOIN 
  (
    SELECT ID FROM wp_229_posts 
    WHERE (post_type NOT LIKE "post" AND post_type NOT LIKE "draft" AND post_type NOT LIKE "hub" AND post_type NOT LIKE "revision" AND post_type NOT LIKE "attachment" AND post_type NOT LIKE "wpseo_crawl_issue" ) 
    ORDER BY ID DESC LIMIT 10000
  ) as p2
ON p.post_id = p2.ID ORDER BY p2.ID ASC;
```

#### STEP 4a: export all users related to exported posts
```
SELECT DISTINCT u.ID, u.user_login, u.user_pass, u.user_nicename, u.user_email, u.user_url, u.user_registered, u.user_activation_key, u.user_status, u.display_name, u.spam, u.deleted FROM wp_users as u INNER JOIN 
  ( SELECT post_author FROM wp_229_posts WHERE (post_type LIKE "post" AND post_status NOT LIKE "auto-draft") ORDER BY ID DESC LIMIT 500 ) as p2
  ON p2.post_author = u.ID;
```

#### STEP 4b: export all post author meta
```
SELECT DISTINCT u.umeta_id, u.user_id, u.meta_key, u.meta_value FROM wp_usermeta as u INNER JOIN 
  ( SELECT post_author FROM wp_229_posts WHERE (post_type LIKE "post" AND post_status NOT LIKE "auto-draft") ORDER BY ID DESC LIMIT 500 ) as p2
  ON p2.post_author = u.user_id;
```
 
#### STEP 5: Full Table SQL exports 
wp_229_options and terms (and terms relationships taxonomy and meta) - full export

#### STEP 6: WP CLI replace text - 
`vagrant ssh -c "cd /srv/www/fansidedblogs.dev/htdocs && wp search-replace '//fansided.com' '//fansided.dev' --network"`

#### STEP 7: WP CLI add vagrant user- 
`vagrant ssh -c "cd /srv/www/fansidedblogs.dev/htdocs && wp user create vagrant vagrant@vvv.dev --user_pass=vagrant; wp super-admin add vagrant"`
