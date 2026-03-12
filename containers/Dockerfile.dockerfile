# 构建时
FROM docker.io/library/alpine:latest AS builder
ARG REPO
# eg. amd64 | arm64
ARG ARCH
# eg. x86_64 | aarch64
ARG CPU_ARCH
ARG TAG
# eg. latest
ARG IMAGE_VERSION
ENV REPO=$REPO \
     ARCH=$ARCH \
     CPU_ARCH=$CPU_ARCH \
     TAG=$TAG \
     IMAGE_VERSION=$IMAGE_VERSION
RUN apk add --no-cache --virtual .build-deps \
                git \
                build-base \
                autoconf \
                cmake \
                libtool \
                python3 \
                openssl-dev \
                clang \
                linux-headers

WORKDIR /source/
COPY source-src/ ./
RUN ./x.py build --compiler=clang -DENABLE_OPENSSL=ON -DENABLE_STATIC_LINK=ON -DPORTABLE=1 -DCMAKE_BUILD_TYPE=Release -j $(nproc)

# 运行时
FROM busybox AS runtime
COPY source-src/kvrocks.conf /var/lib/kvrocks/
COPY --from=builder /kvrocks/build/kvrocks /bin/