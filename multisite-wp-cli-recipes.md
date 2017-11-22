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

#### TIPS
* `--format` is a powerful modifier that changes default `table`
