ARG DIST=buster
FROM debian:${DIST} AS builder

RUN apt-get update ; apt-get install -y --no-install-suggests packaging-dev

RUN git clone -q -- https://github.com/verdammelt/tnef /code
WORKDIR /code
ARG CHECKOUT=master
RUN git checkout -q "${CHECKOUT}"

RUN autoreconf && ./configure && make --quiet check


FROM ruby:2.5 AS packager
ARG TARGETARCH
ARG DIST

RUN gem install --no-document fpm
WORKDIR /dist
COPY --from=builder /code/src/tnef /dist/

RUN PACKAGE_VERSION="$(./tnef -V 2>&1 | head -n1 | cut -d' ' -f2)" && \
  fpm -s dir -t deb -n tnef \
  -v "${PACKAGE_VERSION}-${DIST}1" \
  -a "${TARGETARCH}" \
  -m "na-qc@equisoft.com" \
  --vendor "Equisoft Inc." \
  --description "tnef packaged for debian ${DIST}" \
  --deb-dist "${DIST}" \
  --url "https://github.com/kronostechnologies/tnef" \
  --prefix /usr/local/bin .

FROM scratch
COPY --from=packager /dist/*.deb /