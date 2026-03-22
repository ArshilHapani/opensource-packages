generate-certs:
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout tls.key \
		-out tls.crt \
		-subj "/CN=mongo.127.0.0.1.nip.io/O=mongo"

generate-and-print-b64-certs:
	@bash -c '\
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout >(base64 | tr -d "\n" > key.b64) \
		-out >(base64 | tr -d "\n" > crt.b64) \
		-subj "/CN=mongo.127.0.0.1.nip.io/O=mongo"; \
	wait; \
	echo "tls.crt: $$(cat crt.b64)"; \
	echo "tls.key: $$(cat key.b64)"; \
	rm crt.b64 key.b64'

start-kind-cluster:
	kind create cluster --config kind-cluster.yml

apply-manifests:
	kubectl apply -f secrets.yml
	kubectl apply -f config-maps.yml
	kubectl apply -f mongo-certs.yml

	kubectl apply -f ingress.yml
	
	kubectl apply -f mongo.yml
	kubectl apply -f mongo-admin.yml
	kubectl apply -f ingress-mongo-admin.yml
