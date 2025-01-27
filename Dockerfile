FROM registry.gitlab.com/islandoftex/images/texlive:latest as builder
WORKDIR /app
COPY . .
RUN mkdir -p output && \
    latexmk -pdf -output-directory=output main.tex

# Serve stage
FROM nginx:alpine
COPY --from=builder /app/output /usr/share/nginx/html