CC := clang
FLAGS := -O2 -Wall -g
TARGET := -target bpf

NETIF := docker0
SELECTED_OBJ := tcp_drop.o
VERBOSE := #verbose

.PHONY: help
help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_%-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

%.o: %.c
	$(CC) $(FLAGS) $(TARGET) -c $< -o $@

.PHONY: drun
drun: ## Run docker
	docker run -d -p 80:80 --name=nginx-xdp nginx:alpine

.PHONY: xdpon
xdpon: $(SELECTED_OBJ) ## Attach xdp
	ip link set dev $(NETIF) xdp obj $(SELECTED_OBJ) section xdp $(VERBOSE)

.PHONY: xdpoff
xdpoff: ## Detach xdp
	ip link set dev $(NETIF) xdp off

.PHONY: clean ## Clean *.o
clean:
	rm *.o
