NAME="mumble"
VERSION="1.0"
IMAGE_NAME="vvicaretti/mumble"
IMAGE_VERSION="1.2.18"

default: install

build:
	docker build -t ${IMAGE_NAME}:latest -t ${IMAGE_NAME}:${IMAGE_VERSION} .
	docker push ${IMAGE_NAME}

run:
	@if [ ! -d /var/mumble ]; then mkdir /var/mumble; fi
	@docker run -d \
		-p 64738:64738 \
		-v /var/mumble:/data \
		-v /etc/letsencrypt/live/<YOUR_URL>:/data/ssl \
		-v /etc/letsencrypt/archive/<YOUR_URL>:/archive/<YOUR_URL> \
		--name mumble \
		${IMAGE_NAME}
	docker logs mumble 2>&1 | grep SUPERUSER_PASSWORD

systemd:
	cp -f systemd/docker-mumble.service /etc/systemd/system
	cp -f systemd/mumble-ssl.service /etc/systemd/system
	cp -f systemd/mumble-ssl.timer /etc/systemd/system
	cp -f nginx/mumble.conf /etc/nginx/site-enabled/mumble.conf
	systemctl daemon-reload
	systemctl enable docker-mumble.service
	systemctl enable mumble-ssl.timer
	systemctl start docker-mumble.service
	systemctl start mumble-ssl.timer

install: build run systemd
