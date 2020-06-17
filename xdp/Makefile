CC := clang
FLAGS := -O2 -Wall -g
TARGET := -target bpf

NETIF := docker0
SELECTED_OBJ := tcp_drop.o
VERBOSE := #verbose

%.o: %.c
	$(CC) $(FLAGS) $(TARGET) -c $< -o $@

.PHONY: dockerrun
dockerrun:
	docker run -d -p 80:80 --name=nginx-xdp nginx:alpine

.PHONY: attachxdp
attachxdp: $(SELECTED_OBJ)
	ip link set dev $(NETIF) xdp obj $(SELECTED_OBJ) section xdp $(VERBOSE)

.PHONY: detachxdp
detachxdp:
	ip link set dev $(NETIF) xdp off

.PHONY: clean
clean:
	rm *.o
