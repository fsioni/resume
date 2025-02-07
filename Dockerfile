FROM nginx:alpine
ARG GITHUB_REPOSITORY
LABEL org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}"
COPY resume/main.pdf /usr/share/nginx/html/cv.pdf
COPY resume/main.pdf /usr/share/nginx/html/index.html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]