# syntax=docker/dockerfile:1.4

# Stage 1: Build the project
FROM --platform=$BUILDPLATFORM docker:dind-rootless as builder

ARG TARGETPLATFORM
ENV RUST_MUSL_CROSS_TARGET=$TARGETPLATFORM
ENV CROSS_CONTAINER_IN_CONTAINER=true
ARG target
ARG binary
ARG user

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log

# Determine the cross target based on the architecture
COPY ./platform.sh /platform.sh
RUN /platform.sh && \
    echo $TARGETPLATFORM && \
    cat /.target

#RUN     rustup target add "$(cat /.target)"
RUN     cargo install cross && \
        apt-get update && \
        apt-get install -y \
        pkg-config \
        librust-alsa-sys-dev \
        musl-tools \
        build-essential \
        cmake \
        musl-dev \
        musl-tools \
        libssl-dev \
        docker \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

ENV USER=$user
ENV UID=10001
ENV TARGET=$target
ENV BINARY=$binary

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

WORKDIR /app

COPY ./ .

RUN cross build --bin $BINARY \
    --target $(cat /.target) \
    --release

RUN tree /

# Stage 2: Create the final image
FROM scratch as release

# Copy the built binary from the builder stage
ARG target
ARG binary
ARG user
COPY --from=builder /.target /
RUN export target=$(cat /.target)
COPY --from=builder "/app/target/$target/release/$binary" /app

USER $USER:$USER
ENTRYPOINT ["/app/$binary"]