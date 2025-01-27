# Build stage
FROM registry.gitlab.com/islandoftex/images/texlive:latest as builder
WORKDIR /app
COPY . .
RUN cd resume && \
    mkdir -p output && \
    latexmk -pdf -output-directory=output main.tex

# Production stage
FROM nginx:alpine
COPY --from=builder /app/resume/output/*.pdf /usr/share/nginx/html/