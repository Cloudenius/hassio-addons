ARG BUILD_FROM
FROM $BUILD_FROM

# Setup base
RUN apk add --no-cache \
        openssl \
    && apk add --no-cache --virtual .build-dependencies \
        g++ musl-dev openssl-dev \
    && apk del .build-dependencies

# Copy data
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]