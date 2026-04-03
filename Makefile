GH_USERNAME := arshilhapani
REGISTRY := ghcr.io/$(GH_USERNAME)


# images
PG_CRON_IMAGE := $(REGISTRY)/pg-with-cron:16

build-pg-cron:
	docker build -t $(PG_CRON_IMAGE) -f pg-cron/pg.Dockerfile pg-cron/
	docker push $(PG_CRON_IMAGE)

start-nomad-cluster:
	@cd ./learn-nomad-getting-started && sudo nomad agent -dev \
		-bind 0.0.0.0 \
		-network-interface='{{ GetDefaultInterfaces | attr "name" }}' -config=shared/config/nomad.hcl

start-redis-job:
	@cd ./learn-nomad-getting-started/jobs && nomad job run pytechco-redis.nomad.hcl
	@cd ./learn-nomad-getting-started/jobs && nomad job run pytechco-web.nomad.hcl
	@cd ./learn-nomad-getting-started/jobs && nomad job run pytechco-setup.nomad.hcl
	@cd ./learn-nomad-getting-started/jobs && nomad job dispatch -meta budget="200" pytechco-setup