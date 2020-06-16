CC := clang
TARGET := -target bpf
NETIF := docker0
SELECTED_OBJ := xdp_drop_tcp.o
VERBOSE := #verbose

%.o: %.c
	$(CC) $(TARGET) -c $< -o $@

.PHONY: attachxdp
attachxdp: $(SELECTED_OBJ)
	ip link set dev $(NETIF) xdp obj $(SELECTED_OBJ) section xdp $(VERBOSE)

.PHONY: detachxdp
detachxdp:
	ip link set dev $(NETIF) xdp off

.PHONY: clean
clean:
	rm *.o
