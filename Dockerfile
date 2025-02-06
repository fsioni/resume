# Build stage
FROM texlive/texlive:latest as builder
WORKDIR /app

# Installation des outils nécessaires
RUN apt-get update && \
    apt-get install -y locales && \
    sed -i 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG=fr_FR.UTF-8
ENV LC_ALL=fr_FR.UTF-8
ENV LANGUAGE=fr_FR.UTF-8

# Copier les fichiers
COPY . .

# Créer un fichier de configuration LaTeX
RUN echo '$pdflatex = "pdflatex -file-line-error -synctex=1 -interaction=nonstopmode %O %S";' > .latexmkrc && \
    echo '$pdf_mode = 1;' >> .latexmkrc && \
    echo '$max_repeat = 5;' >> .latexmkrc && \
    echo '$clean_ext = "synctex.gz synctex.gz(busy) run.xml tex.bak bbl bcf fdb_latexmk run tdo pdfsync out aux";' >> .latexmkrc

# Se placer dans le répertoire resume
WORKDIR /app/resume

# Génération du PDF avec mode diagnostic
RUN mkdir -p output && \
    TEXINPUTS=".:" pdflatex -diagnostic -output-directory=output main.tex

# Production stage
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/resume/output/main.pdf ./cv.pdf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]