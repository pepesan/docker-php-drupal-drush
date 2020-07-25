# How to use

<h3>With <code>docker-compose</code></h3>
<p>Create a <code>docker-compose.yml</code> file in the root folder of project using this as a template:</p>

<pre><code>
  app:
    image: fabdelgado/drupal:latest
    container_name: app
    restart: always
    volumes:
      # modules
      - $PWD/modules/:/var/www/html/drupal/web/modules/:rw
      # themes
      - $PWD/themes/:/var/www/html/drupal/web/themes/:rw
      - ./logs:/var/log/logs
    environment:
      APACHE_DOCUMENT_ROOT: "/var/www/html/drupal/web"
</code></pre>

<h3>If you use this <a href="https://hub.docker.com/r/jwilder/nginx-proxy/">jwilder/nginx-proxy</a></h3>

Add this line to environment by using your domain.
<pre><code>
      VIRTUAL_HOST: "domain.com"
</code></pre>