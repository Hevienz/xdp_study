CC := clang
FLAGS := -O2 -Wall -g
TARGET := -target bpf

NETIF := docker0
SELECTED_OBJ := tcp_drop.o
DIRECTION := egress

VERBOSE := #verbose


.PHONY: help
help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_%-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

%.o: %.c
	$(CC) $(FLAGS) $(TARGET) -c $< -o $@

.PHONY: drun
drun: ## Run docker
	docker run -d -p 80:80 --name=nginx-xdp nginx:alpine

.PHONY: tcon
tcon: $(SELECTED_OBJ) ## Attach tc
	tc qdisc show dev $(NETIF) clsact
	tc qdisc add dev $(NETIF) clsact
	tc qdisc show dev $(NETIF) clsact
	tc filter show dev $(NETIF) $(DIRECTION)
	tc filter add dev $(NETIF) $(DIRECTION) bpf da obj $(SELECTED_OBJ) sec tc
	tc filter show dev $(NETIF) $(DIRECTION)

.PHONY: tcoff
tcoff: ## Detach tc
	tc filter show dev $(NETIF) $(DIRECTION)
	tc filter del dev $(NETIF) $(DIRECTION)
	tc filter show dev $(NETIF) $(DIRECTION)
	tc qdisc show dev $(NETIF) clsact
	tc qdisc del dev $(NETIF) clsact
	tc qdisc show dev $(NETIF) clsact

.PHONY: clean ## Clean *.o
clean:
	rm *.o
