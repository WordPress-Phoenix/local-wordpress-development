# Using xDebug in PhpStorm with VVV

- Intro
- Tools and References
- Enable xDebug
- Path Mapping
- Integrating WordPress
- Setting PHP Server Paths
- Validation & Additional Debugging Port Setting
- Usage

## Intro
This document will show you how to setup and use xDebug with [Varying Vagrant Vagrants](https://github.com/Varying-Vagrant-Vagrants/VVV)

## Tools and References

- PhpStorm
- A PhpStorm Project
- xDebug
- WordPress

More information can be found at [VVV Code-Debugging](https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Code-Debugging)

## Enable xDebug

Both the default and trunk versions of WordPress that ship with VVV have wp_debug turned on. However if you've installed your own version, it needs to be turned.

From command line, change directory to your vagrant install. SSH into vagrant with `vagrant ssh`. Once you've ssh'd into vagrant, turn xdebug by running `xdebug_on`

You should see:
```
php5-fpm stop/waiting
php5-fpm start/running, process #####
```

xDebug is now turned on and you can exit out of ssh.

## Path Mapping

Now PhpStorm needs to know where your vagrant install is serving files from. Essentially giving it a server reference to the actual files. We do this mapping the file paths.

These settings can be found in PhpStorm > Preferences. From here you're going to create a new server.

Depending on your the root of your project, you may need to set additional path maps. In this example, version 5 of the FanSided theme is set to the project root, with WordPress integration enabled.

##### Integrating WordPress
1. In the preferences window, navigate to Languages & Frameworks > WordPress
2. Check the Enable WordPress checkbox.
3. Click the `...` icon and navigate to where you have `wordpress-default` installed.

   Reference: `/Users/username/Sites/fansided-vvv/www/wordpress-default`

![Enable WordPress Integration](https://github.com/fansided/fansided-knowledge-base/blob/master/assets/images/enable-wordpress-integration.png "Enable WordPress Integration")

##### Setting PHP Server Paths
1. In the preferences window, navigate to Languages & Frameworks > PHP > Servers
2. Click the `+` to add a new server
3. Add a name of your choosing.
4. Host with be `fansidedblogs.dev`, Leave port and debugger as 80 and xDebug
5. Check `Use Path Mappings`
6. You should see two entries, Project Files and Include Path. In this example we are using the theme as a project root, so we will need to add the absolute path on the server.
  1. Click in the invisible box next to the directory path in the Absolute Path column.
  2. Type out the server path and press enter - `/srv/www/fansidedblogs/htdocs/wp-content/themes/fansided-v5` (_If you don't press enter, the field will not be set. The current version (10) of PhpStorm doesn't auto set this value for some reason_)
  3. Continue to do the same with the include path. As you step through your debugger, xDebug will show path mapping errors when it tries to look for WordPress core files to reference. With our project root set to a theme, it can't locate outside files on it's own, so you need give it some reference. Map `wordpress-default` to `/srv/www/fansidedblogs/htdocs`


7. Once the paths have been set, click apply to save changes.

![PHP Server Settings](https://github.com/fansided/fansided-knowledge-base/blob/master/assets/images/php-server-settings.png "PHP Server Settings")


##### Validation & Additional Debugging Port Setting
If xdebug still isn't running after following the above steps, you may need to adjust the port set under `Preferences > Languages & Frameworks > PHP > Debug` to `9003`. 

![PHP Debug Settings](https://github.com/fansided/fansided-knowledge-base/blob/master/assets/images/php-debug-settings.png "PHP Debug Settings")

Additionally, you may click the `Validate` link at the top of the above preferences screen to verify that everything has been correctly set. Before running Validation, be sure that the `Path to create validation script` field points to the local root directory of the site you're trying to run xdebug on, and the URL to validation script also points to the root of the local site, ie `http://fansided.dev`.

## Usage
Now we can use xDebug!

1. Set a breakpoint in your code editor by clicking in the left column next to the line you want to debug.
2. Go back to your browser and execute an action or do a page refresh. Once xDebug hits your breakpoint, PhpStorm will be will be shown with the debug panel open.

Learn how to set breakpoints from this [youtube video](https://www.youtube.com/watch?v=4udxLwRpJ3w)

#### Happy Debugging!
