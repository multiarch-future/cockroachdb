FROM --platform=linux/amd64 cockroachdb/builder:20200326-092324 AS builder

ARG TARGETPLATFORM
ARG COMMIT=be8c0a720e98a147263424cc13fc9bfc75f46013

COPY build.sh /build.sh
RUN chmod +x /build.sh

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
