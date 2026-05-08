# installation guideline ref: https://github.com/openssl/openssl/blob/master/README-FIPS.md

FROM debian:bookworm AS openssl-fips

ARG OPENSSL_VERSION=3.1.2

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    perl \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Download OpenSSL
RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
    && tar -xf openssl-3.1.2.tar.gz \
    && rm openssl-3.1.2.tar.gz

WORKDIR /tmp/openssl-${OPENSSL_VERSION}

# Build OpenSSL with FIPS
RUN ./Configure enable-fips \
    --prefix=/opt/openssl-fips \
    --openssldir=/opt/openssl-fips/ssl \
    --libdir=/opt/openssl-fips/lib \
    && make -j$(nproc) \
    && make install

# Generate FIPS module config
RUN /opt/openssl-fips/bin/openssl fipsinstall \
    -module /opt/openssl-fips/lib/ossl-modules/fips.so \
    -out /opt/openssl-fips/ssl/fipsmodule.cnf

# Create FIPS-enabled config
RUN cat > /opt/openssl-fips/ssl/openssl.cnf <<'EOF'
openssl_conf = openssl_init

.include /opt/openssl-fips/ssl/fipsmodule.cnf

[openssl_init]
providers = provider_sect

[provider_sect]
fips = fips_sect
base = base_sect

[fips_sect]
activate = 1

[base_sect]
activate = 1
EOF

# Clean build artifacts
RUN rm -rf /tmp/openssl-${OPENSSL_VERSION}*

# Default env (optional but useful)
ENV OPENSSL_CONF=/opt/openssl-fips/ssl/openssl.cnf
ENV OPENSSL_MODULES=/opt/openssl-fips/lib/ossl-modules
ENV PATH=/opt/openssl-fips/bin:$PATH