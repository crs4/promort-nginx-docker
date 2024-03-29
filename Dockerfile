# Builder (stage 0)
ARG PROMORT_VERSION=0.10.1

FROM crs4/promort-web:${PROMORT_VERSION}

RUN python manage.py collectstatic --noinput

# Production
FROM nginx:1.19.10
LABEL maintainer="luca.lianas@crs4.it"

COPY --from=0 /home/promort/app/DigitalPathologyPlatform/promort/static/ /opt/promort/nginx/static/

RUN mkdir /etc/nginx/sites-enabled/

COPY conf_files/nginx.conf /etc/nginx/nginx.conf
COPY conf_files/*.template /etc/nginx/conf.d/
COPY conf_files/promort.location /etc/nginx/apps/
COPY resources/wait-for-it.sh \
     resources/entrypoint.sh \
     /usr/local/bin/

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
