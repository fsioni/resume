FROM nginx:alpine
ARG GITHUB_REPOSITORY
LABEL org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}"

RUN echo 'server { \n\
    listen 80; \n\
    server_name localhost; \n\
    location / { \n\
        types { \n\
            application/pdf pdf; \n\
        } \n\
        default_type application/pdf; \n\
        add_header Content-Disposition inline; \n\
        try_files $uri $uri/ /cv.pdf; \n\
    } \n\
}' > /etc/nginx/conf.d/default.conf

COPY resume/main.pdf /usr/share/nginx/html/cv.pdf
COPY resume/main.pdf /usr/share/nginx/html/index.html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]