FROM debian as builder

# this is the version of lzbench to build into a container
ARG VERSION=1.8.1

WORKDIR /app

RUN apt-get update &&\
  apt-get install -y --no-install-recommends build-essential wget ca-certificates

RUN wget https://github.com/inikep/lzbench/archive/v${VERSION}.tar.gz &&\
  tar -xzf v${VERSION}.tar.gz && \
  cd lzbench-${VERSION} && \
  make BUILD_STATIC=1


FROM scratch

# this is the version of lzbench to build into a container
ARG VERSION=1.8.1
COPY --from=builder /app/lzbench-${VERSION}/lzbench .

VOLUME [ "/data/" ]


ENTRYPOINT [ "./lzbench" ]
CMD ["-r", "/data"]
