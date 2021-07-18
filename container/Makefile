all: build run 
build:
	@echo "Starting image build..."
	@docker build -t ledn:latest .
run:
	@echo "Starting Docker container"
	@docker run --name ledn-take-home -p 8080:80 -p 2222:22 -d ledn:latest
stop:
	@echo "Stopping container..."
	@docker stop ledn-take-home || true 
	@echo "Removing container..."
	@docker rm ledn-take-home || true
clean: stop
	@echo "Removing images..."
	@docker rmi ledn
