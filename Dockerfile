FROM nginx:alpine
LABEL org.opencontainers.image.source="https://github.com/${{ github.repository }}"
COPY resume/main.pdf /usr/share/nginx/html/cv.pdf
COPY resume/main.pdf /usr/share/nginx/html/index.html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]