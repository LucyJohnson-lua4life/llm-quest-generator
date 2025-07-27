FROM ubuntu:22.04

ENV QUICKLISP_HOME=/root/quicklisp
ENV PROJECT_DIR=/app

# Install dependencies, including glibc 2.33+ and necessary build tools
RUN apt-get update && apt-get install -y \
    sbcl \
    curl \
    bzip2 \
    build-essential \
    libc6 \
    && rm -rf /var/lib/apt/lists/*

# Install Quicklisp
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp && \
    sbcl --non-interactive \
         --load quicklisp.lisp \
         --eval '(quicklisp-quickstart:install :path "'${QUICKLISP_HOME}'")' \
         --eval '(quit)'

ENV QUICKLISP_SETUP=$QUICKLISP_HOME/setup.lisp

# Add your Lisp project
WORKDIR $PROJECT_DIR
COPY . $PROJECT_DIR

# Build the executable
#RUN sbcl --load $QUICKLISP_SETUP \
#         --load build.lisp
RUN sbcl --script build.lisp

# Expose Hunchentoot port
EXPOSE 4242

CMD ["./main"]
