FROM alpine:3.11

ARG DDCLIENT_VERSION="v3.9.1"
LABEL maintainer="Ismael Peral"

RUN apk add --no-cache --virtual=build-dependencies \
	bzip2 \
	gcc \
	make \
	tar \
	wget && \
	apk add --no-cache \
	curl \
	jq \
	perl \
	perl-digest-sha1 \
	perl-io-socket-inet6 \
	perl-io-socket-ssl \
	perl-json && \
	curl -L http://cpanmin.us | perl - App::cpanminus && \
	cpanm \
	Data::Validate::IP \
	JSON::Any && \
	mkdir -p /tmp/ddclient && \
	curl -o	/tmp/ddclient.tar.gz -L \
	"https://github.com/ddclient/ddclient/archive/${DDCLIENT_VERSION}.tar.gz" && \
	tar xf /tmp/ddclient.tar.gz -C \
	/tmp/ddclient --strip-components=1 && \
	install -Dm755 /tmp/ddclient/ddclient /usr/bin/ && \
	mkdir -p /var/cache/ddclient && \
	mkdir -p /var/run/ddclient && \
	apk del --purge \
	build-dependencies && \
	rm -rf \
	/config/.cpanm \
	/root/.cpanm \
	/tmp/*

ENTRYPOINT [ "/usr/bin/ddclient" ]
