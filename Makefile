GH_USERNAME := arshilhapani
REGISTRY := ghcr.io/$(GH_USERNAME)


# images
PG_CRON_IMAGE := $(REGISTRY)/pg-with-cron:16
OPENSSL_FIPS := $(REGISTRY)/openssl-fips:3.1.2

build-and-push-pg-cron:
	docker build -t $(PG_CRON_IMAGE) -f pg-cron/Dockerfile pg-cron/
	docker push $(PG_CRON_IMAGE)

build-and-push-openssl-fips:
	docker build -t $(OPENSSL_FIPS) -f openssl-fips/Dockerfile openssl-fips/
	docker push $(OPENSSL_FIPS)

start-nomad-cluster:
	@cd ./learn-nomad-getting-started && sudo nomad agent -dev \
		-bind 0.0.0.0 \
		-network-interface='{{ GetDefaultInterfaces | attr "name" }}' -config=shared/config/nomad.hcl

start-redis-job:
	@cd ./learn-nomad-getting-started/jobs && nomad job run pytechco-redis.nomad.hcl
	@cd ./learn-nomad-getting-started/jobs && nomad job run pytechco-web.nomad.hcl
	@cd ./learn-nomad-getting-started/jobs && nomad job run pytechco-setup.nomad.hcl
	@cd ./learn-nomad-getting-started/jobs && nomad job dispatch -meta budget="200" pytechco-setup