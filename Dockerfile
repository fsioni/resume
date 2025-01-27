# Build stage
FROM registry.gitlab.com/islandoftex/images/texlive:latest as builder
WORKDIR /app
COPY . .
ENV LANG=fr_FR.UTF-8
ENV LC_ALL=fr_FR.UTF-8
RUN cd resume && \
    latexmk -pdf -interaction=nonstopmode -output-directory=output main.tex

# Production stage
FROM nginx:alpine
COPY --from=builder /app/resume/output/*.pdf /usr/share/nginx/html/