include .env
export DBNAME
export PASSWORD
export DBUSER
export JWT_SECRET_KEY
export SECRET_KEY
export POSTGRES_PORT

# export DUMP_DiR

# source ../.env

# API_URL =http://localhost:8000

.PHONY: create_network
create_network:
	docker network create fullstack_network 

.PHONY: build_db
build_db:
	docker build \
		-t postgress_db_real_world \
		-f BE/fastapi-realworld-backend/Dockerfile.postgress \
		.

# .PHONY: run_db_dump
# run_db_dump:
# 	docker exec -it postgress_db psql -U ${DBUSER} -d ${DBNAME} -f "/postgresql/dump.sql"

.PHONY: run_db
run_db:
	docker run --rm --name postgress_db_real_world_cont \
		--network fullstack_network \
		-e POSTGRES_USER=${DBUSER} \
		-e POSTGRES_PASSWORD=${PASSWORD} \
		-e POSTGRES_DB=${DBNAME} \
		-p 5432:5432 \
		postgress_db_real_world

.PHONY: build_fastapi
build_fastapi:
	docker build \
		-t fastapi_real_world \
		-f BE/fastapi-realworld-backend/Dockerfile.BE \
		.

.PHONY: run_fastapi
run_fastapi:
	docker run --rm --name fastapi_real_world_cont \
		--network fullstack_network \
		-v "${PWD}/BE/fastapi-realworld-backend/conduit":/app \
		-p 8000:8000 \
		- e SECRET_KEY=${SECRET_KEY}\
		-e POSTGRES_HOST='postgress_db_real_world_cont' \
		-e POSTGRES_DB=${DBNAME}\
		-e POSTGRES_USER=${DBUSER}\
		-e POSTGRES_PASSWORD=${PASSWORD}\
		-e POSTGRES_PORT=${POSTGRES_PORT}\
		-e JWT_SECRET_KEY=${JWT_SECRET_KEY}\
		fastapi_real_world

.PHONY: build_client
build_client:
	DOCKER_BUILDKIT=1 docker build \
		-t client_real_world \
		-f FE/react-recoil-realworld-example-app/Dockerfile.FE \
		.

.PHONY: run_client
run_client:
	cd my-react-app && \
	docker run --rm --name client_real_world_cont \
		--network fullstack_network \
		-p 3000:3000 \
		-v "${PWD}/FE/react-recoil-realworld-example-app":/app \
		client_real_world


.PHONY: cleanup
cleanup:
	-docker rm -f postgress_db_real_world_cont fastapi_real_world_cont client_real_world_cont
	-docker network rm fullstack_network

.PHONY: up down

up:
	docker compose up --build

down:
	docker compose down