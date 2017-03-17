#!/bin/bash
# Requirements:
# http://brew.sh/
# https://github.com/bradp/vv
# GIT
# COMPOSER

site="localwp.dev"
livesite=""

while getopts ":s:l:g:" opt; do
  case $opt in
    s)
      echo "-s sets site parameter: $OPTARG" >&2
      site=$OPTARG
      ;;
    l)
      echo "-l sets livesite parameter: $OPTARG" >&2
      livesite=$OPTARG
      ;;
    g)
      echo "-g sets site parameter: $OPTARG" >&2
      gh_token=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Set git to use the osxkeychain credential helper
git config --global credential.helper osxkeychain

if [ -z ${gh_token+x} ]; then
	read -s -p "Guthub Access Token: " gh_token
fi
echo "site set to ${site}"
echo "livesite set to ${livesite}"
#echo "gh_token set to ${gh_token}"

# PREPARE INSTALLATION
if ! $(vagrant plugin list | grep -q 'vagrant-hostsupdater'); then
  vagrant plugin install vagrant-hostsupdater
fi
if ! $(vagrant plugin list | grep -q 'vagrant-triggers'); then
	vagrant plugin install vagrant-triggers
fi
if ! $(vagrant plugin list | grep -q 'vagrant-vbguest'); then
  vagrant plugin install vagrant-vbguest
fi

mkdir ~/Sites && cd ~/Sites/
git clone https://github.com/Varying-Vagrant-Vagrants/VVV.git

# If VV is not configured it will ask to autoconfigure VV config
cd ~/Sites/VVV && echo 'Y' | vv --version

# DOWNLOAD VV BLUEPRINTS OPTIONAL
#cd ~/Sites/VVV/
#bp_url='https://api.github.com/repos/fansided/fansided-knowledge-base/contents/assets/dev-assets/setup-files/vv-blueprints.json'
#echo "$bp_url"
#curl -H "Authorization: token ${gh_token}" -H 'Accept: application/vnd.github.v3.raw' -O -L "${bp_url}"

# SETUP XDEBUG CONFIG
touch config/homebin/vagrant_up_custom
chmod 775 config/homebin/vagrant_up_custom
> config/homebin/vagrant_up_custom
echo "install -m 777 /dev/null /tmp/xdebug.bak
sed 's/^.*xdebug\.remote_port\ \=\ 9000.*$/xdebug.remote_port = 9003/' /etc/php/7.0/mods-available/xdebug.ini >/tmp/xdebug.bak 
sudo mv /tmp/xdebug.bak /etc/php/7.0/mods-available/xdebug.ini" > config/homebin/vagrant_up_custom

# Make sure config file doesn't already exist
rm config/nginx-config/sites/localwp.dev.conf
# BUILD VVV SITE USING VV
echo "y" | \
vv \
 create \
 -d ${site} -n ${site} -u ${livesite} \
 -i -x -m subdomain \
 -rd \
 -wv "4.7.2" \
 -f \
 -db "none" \
 -sc \
 -gr false \
 -b "localwp"

function customvup(){
	cd ~/Sites/VVV
	vagrant up --provision
}
pwd
customvup
echo "finished vagrant provision"

function customvhalt(){
	vagrant halt
}
customvhalt

# DOWNLOAD SQL SAMPLE FILE
#cd ~/Sites/VVV/database/backups
#db_bu_url='raw.githubusercontent.com/fansided/fansided-knowledge-base/master/assets/dev-assets/setup-files/localwp.dev.sql.zip'
#echo "$db_bu_url"
#curl -O -L "https://${gh_token}@${db_bu_url}"
#unzip -o localwp.dev.sql.zip && rm localwp.dev.sql.zip

customvup

echo "beggining post vagrant up customizations"
# ADD CUSTOM CONFIGURATIONS
> ~/Sites/VVV/config/nginx-config/sites/localwp.dev.conf
echo '
server {
    listen          80;
    listen          443 ssl;
    server_name     ~^.*\.dev$;
    root            /srv/www/localwp.dev/htdocs;

    #access_log /var/log/custom.log main;

    location /wp-content {
        #access_log /var/log/custom-image.log wpc;
    }

    # Directives to send expires headers and turn off 404 error logging.
   location ~* \.(js|css|png|jpe?g|gif|ico)$ {
        expires 24h;
        log_not_found off;
        #access_log /var/log/custom-image.log wpc;
        try_files $uri $uri/ @production;
    }

    location @production {
        #rewrite_log on;
        resolver 8.8.8.8;
        #access_log /var/log/custom-image.log PROXY;
        #error_log /var/log/custom-error.log debug;
        rewrite ^(.*\/blogs.dir\/.*\/)(getty-images\/.*)$ /wp-content/uploads/$2?$args&fsproxy=true break;
        rewrite ^(.*\/blogs.dir\/[0-9]+\/files\/)sites\/[0-9]+\/(.*)$ $1$2?$args&fsproxy=true break;
        proxy_pass https://cdn.fansided.com;
    }

    location / {
        index index.php index.html;
        try_files $uri $uri/ /index.php?$args;
    }

    # Specify a charset
    charset utf-8;

    # Weird things happened to me when I had gzip on, may need to try
    # again in the future as it could have been related to many other
    # factors - JF
    gzip off;

    # Add trailing slash to */wp-admin requests.
    rewrite /wp-admin$ $scheme://$host$uri/ permanent;

    # this prevents hidden files (beginning with a period) from being served
    location ~ /\. {
        access_log off;
        log_not_found off;
        deny all;
    }

    # Pass uploaded files to wp-includes/ms-files.php.
    rewrite /files/$ /index.php last;

    if ($uri !~ wp-content/plugins) {
        #rewrite /files/(.+)$ /wp-includes/ms-files.php?file=$1 last;
    }

    # Rewrite multisite in a subdirectory
    if (!-e $request_filename) {
        rewrite ^/[_0-9a-zA-Z-]+(/wp-.*) $1 last;
        rewrite ^/[_0-9a-zA-Z-]+.*(/wp-admin/.*\.php)$ $1 last;
        rewrite ^/[_0-9a-zA-Z-]+(/.*\.php)$ $1 last;
    }

    location ~ \.php$ {
        # Try the files specified in order. In our case, try the requested URI and if
        # that fails, try (successfully) to pass a 404 error.
        try_files      $uri =404;

        # Include the fastcgi_params defaults provided by nginx
        include        /etc/nginx/fastcgi_params;

        fastcgi_read_timeout 3600s;
        fastcgi_buffer_size 128k;
        fastcgi_buffers 4 128k;

        # SCRIPT_FILENAME is a required parameter for things to work properly,
        # but was missing in the default fastcgi_params on upgrade to nginx 1.4.
        # We define it here to be sure that it exists.
        fastcgi_param   SCRIPT_FILENAME         $document_root$fastcgi_script_name;

        # Use the upstream defined in the upstream variable.
        fastcgi_pass   $upstream;

        # And get to serving the file!
        fastcgi_index  index.php;
    }

}
' > ~/Sites/VVV/config/nginx-config/sites/localwp.dev.conf

# remove git command added by VV during required defaults settings
vagrant ssh -c 'sed -i "s|git checkout HEAD .||" /srv/www/localwp.dev/vvv-init.sh && echo "removed bad git command"'
# if htdocs doesn't exist, init didn't run, do that now
if [ ! -d "~/Sites/VVV/www/localwp.dev/htdocs/wp-content/" ]; then
  vagrant ssh -c 'cd /srv/www/localwp.dev/ && bash vvv-init.sh && echo "provisioned wordpress install"'
fi

# Custom sunrise file for multi TLD dev domains
tee ~/Sites/VVV/www/localwp.dev/htdocs/wp-content/sunrise.php <<'sunrise' >/dev/null
<?php
if ( ! empty( $_SERVER['HTTP_HOST'] ) ) {
   $site = get_site_by_path( strtolower( $_SERVER['HTTP_HOST'] ), '/');
   define( 'COOKIE_DOMAIN', '.' . $site->domain );
}
sunrise


function add_config_constant {
  cur=$(pwd)
  cd ~/Sites/VVV/www/localwp.dev/htdocs
  search=$(printf $1)
  phpline=$1
  if grep -Fxqs "${phpline}" wp-config.php
  then
    # code if found
    echo "constant already defined in wp-config.php"    
  else
    # code if not found
    awk -v var="$phpline" '/stop\ editing/{print var}1' wp-config.php > tmpawk && mv tmpawk wp-config.php
    echo ${phpline}
  fi
  cd ${cur}
}

add_config_constant "define('SUNRISE',true);"
add_config_constant "define('WP_ALLOW_MULTISITE',true);"
add_config_constant "define('MULTISITE',true);"
add_config_constant "define('SUBDOMAIN_INSTALL',true);"
add_config_constant "define('DOMAIN_CURRENT_SITE','localwp.dev');"
add_config_constant "define('PATH_CURRENT_SITE','/');"
add_config_constant "define('SITE_ID_CURRENT_SITE',1);"
add_config_constant "define('BLOG_ID_CURRENT_SITE',1);"

cd ~/Sites/VVV/www/localwp.dev/htdocs/wp-content/themes/ && \
git clone https://github.com/DivTruth/div-framework.git && \
git clone https://github.com/WordPress-Phoenix/synthetic-unit-tests-theme 

cd ~/Sites/VVV/www/localwp.dev/htdocs/wp-content/plugins/ && \
git clone https://github.com/trepmal/my-sites-search.git && \
git clone https://github.com/wp-premium/wordpress-seo-premium.git && \
git clone https://github.com/wp-premium/gravityforms && \
git clone https://github.com/WordPress-Phoenix/wordpress-rest-cache && \
git clone https://github.com/WordPress-Phoenix/lil-notices && \
git clone https://github.com/WordPress-Phoenix/merge-migration-tool && \
git clone https://github.com/WordPress-Phoenix/wordpress-cloudinary-config-free-cdn-images && \
git clone https://github.com/Automattic/sensei && \
git clone https://github.com/WordPress-Phoenix/wordpress-image-crate

# Put dev MU plugin into MU folder and copy loader file into root mu-plugins folder
#cd ~/Sites/VVV/www/localwp.dev/htdocs/wp-content && mkdir mu-plugins >/dev/null 2>&1; cd mu-plugins; git clone https://github.com/fansided/fansided-dev.git >/dev/null 2>&1; cp fansided-dev/fs-load.php .

# Just in case the provision missed any file copies like the nginx config file
function vprov {
	vagrant provision
}
vprov

echo '>>> END OF SETUP FS VVV SCRIPT <<<'
