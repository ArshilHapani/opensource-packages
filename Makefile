GH_USERNAME := arshilhapani
REGISTRY := ghcr.io/$(GH_USERNAME)


# images
PG_CRON_IMAGE := $(REGISTRY)/pg-with-cron:16

build-pg-cron:
	docker build -t $(PG_CRON_IMAGE) -f pg-cron/pg.Dockerfile pg-cron/
	docker push $(PG_CRON_IMAGE)