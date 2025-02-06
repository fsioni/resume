# Build stage
FROM registry.gitlab.com/islandoftex/images/texlive:latest as builder
WORKDIR /app

# Installation des outils nécessaires
RUN apt-get update && \
    apt-get install -y locales file iconv && \
    sed -i 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=fr_FR.UTF-8
ENV LC_ALL=fr_FR.UTF-8
ENV LANGUAGE=fr_FR.UTF-8

# Copier les fichiers
COPY . .

# Conversion de tous les fichiers en UTF-8
RUN find . -name "*.tex" -o -name "*.sty" | while read file; do \
    if [ "$(file -b --mime-encoding "$file")" != "utf-8" ]; then \
        iconv -f ASCII -t UTF-8 "$file" > "$file.utf8" && mv "$file.utf8" "$file"; \
    fi \
    done

# Vérification des encodages après conversion
RUN find . -name "*.tex" -o -name "*.sty" | xargs file

# Génération du PDF
RUN cd resume && \
    mkdir -p output && \
    latexmk -pdf -interaction=nonstopmode -output-directory=output main.tex

# Production stage
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copier le PDF généré
COPY --from=builder /app/resume/output/main.pdf ./cv.pdf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]