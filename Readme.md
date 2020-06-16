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
      - $PWD/modules/:/var/www/html/modules/:rw
      # themes
      - $PWD/themes/:/var/www/html/themes/:rw
      - ./logs:/var/log/logs
    environment:
      APACHE_DOCUMENT_ROOT: "/var/www/html"
</code></pre>