FROM nginx:alpine
ARG GITHUB_REPOSITORY
LABEL org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}"

# Création du fichier de configuration nginx
COPY resume/main.pdf /usr/share/nginx/html/cv.pdf
COPY resume/main.pdf /usr/share/nginx/html/index.html

RUN rm /etc/nginx/conf.d/default.conf && \
    echo 'server {' > /etc/nginx/conf.d/default.conf && \
    echo '    listen 80;' >> /etc/nginx/conf.d/default.conf && \
    echo '    server_name localhost;' >> /etc/nginx/conf.d/default.conf && \
    echo '    location / {' >> /etc/nginx/conf.d/default.conf && \
    echo '        types { application/pdf pdf; }' >> /etc/nginx/conf.d/default.conf && \
    echo '        default_type application/pdf;' >> /etc/nginx/conf.d/default.conf && \
    echo '        add_header Content-Disposition inline;' >> /etc/nginx/conf.d/default.conf && \
    echo '        try_files $uri $uri/ /cv.pdf;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '}' >> /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]