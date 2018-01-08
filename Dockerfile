FROM debian:stretch-slim

MAINTAINER Chihab ASRIH <chihab.asrih@gmail.com>

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y wget gnupg1

RUN set -x \
    && wget http://nginx.org/keys/nginx_signing.key \
    && apt-key add nginx_signing.key \
    && echo "deb http://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list \
    && echo "deb-src http://nginx.org/packages/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y nginx

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# Clean up
RUN apt-get remove --purge --auto-remove -y gnupg1 wget \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get autoremove -y \
    && apt-get clean

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]