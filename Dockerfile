FROM --platform=linux/amd64 cockroachdb/builder:20200326-092324 AS builder

ARG TARGETPLATFORM
ARG COMMIT=f990441079c686f9eec32d80044c719175a2bee5

COPY build.sh /build.sh

RUN /build.sh

FROM debian:9.8-slim

RUN apt-get update && \
	apt-get -y upgrade && \
	apt-get install -y libc6 ca-certificates tzdata && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /cockroach
COPY --from=builder /cockroach.sh /cockroach /cockroach/

WORKDIR /cockroach/

# Include the directory into the path
# to make it easier to invoke commands
# via Docker
ENV PATH=/cockroach:$PATH

ENV COCKROACH_CHANNEL=official-docker

EXPOSE 26257 8080
ENTRYPOINT ["/cockroach/cockroach.sh"]