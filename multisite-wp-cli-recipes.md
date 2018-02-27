# Multisite WP-CLI Recipes

If you use a recipe you think others might benefit from, consider contributing here.

### Get CSV of all Sites in Multisite, relevant dates, as well as their status

```bash
wp site list --format=csv --fields=blog_id,url,last_updated,registered,public,archived,deleted,spam,mature
```

### Get all Sites subdomain names in Multisite
Remember to replace domain.dev with your primary domain.
```bash
wp site list --format=csv --fields=url | sed -rn 's/http:\/\/(.*)\.domain.dev\//\1/gp'
```

### Get All Posts in Category & Assign a Post Format
```bash
wp post list --field=ID --cat=3578 --url=winteriscoming.net | xargs -n1 -I {} sh -c 'wp post term set {} post_format post-format-event-preview --url=winteriscoming.net; echo {};'
```

### Update all Term Meta Tables

```bash
wp search-replace 'linked_brand' 'linked_site' wp_*_termmeta
```
### Add user to all sites in multisite 
REMEMBER: to change the USERID to the ID of the user you want to add. And change the role if you don't want this user to be an administrator. 

```bash
for url in $(wp site list --format=csv --fields=url | tail -n +2); do   echo "$url:";   wp user set-role USERID administrator; done
```
#### TIPS
* `--format` is a powerful modifier that changes default `table`
