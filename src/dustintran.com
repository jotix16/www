server {
	listen 80 default_server;
	listen [::]:80 default_server ipv6only=on;

	root /var/www/dustintran.com;
	index index.html index.htm index.xml;

	# Make site accessible from http://localhost/
	server_name dustintran.com;

        # Rewrite trailing slash
        rewrite ^/blog/(.*)/$ /blog/$1 permanent;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri.html $uri.xml $uri/ =404;
	}

	error_page 404 /404.html;

	# redirect server error pages to the static page /50x.html
	#
	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
		root /var/www/dustintran.com;
	}

	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	#
	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
	## NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini

		# With php5-cgi alone:
		#fastcgi_pass 127.0.0.1:9000;
		# With php5-fpm:
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
	}

}
