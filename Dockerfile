# Build stage
FROM registry.gitlab.com/islandoftex/images/texlive:latest as builder
WORKDIR /app
COPY cv/ .
RUN mkdir -p output && \
    latexmk -pdf -output-directory=output main.tex

# Production stage
FROM nginx:alpine
COPY --from=builder /app/output/main.pdf /usr/share/nginx/html/pdf/cv.pdf