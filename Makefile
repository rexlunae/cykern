ARCH            = $(shell uname -m | sed s,i[3456789]86,ia32,)

OBJS            = boot.o cykern.o
#OBJS            = boot.o
TARGET          = cykern.efi

CYTHON         = cython3
PYINC          = /usr/include/python3.5/
#PYINC          = /usr/lib/pypy/include/
PYINCS         = -I$(PYINC)
EFIINC          = /usr/include/efi
EFIINCS         = -I$(EFIINC) -I$(EFIINC)/$(ARCH) -I$(EFIINC)/protocol
LIB             = /usr/local/lib
EFILIB          = $(LIB)
EFI_CRT_OBJS    = $(EFILIB)/crt0-efi-$(ARCH).o
EFI_LDS         = $(EFILIB)/elf_$(ARCH)_efi.lds

CFLAGS          = $(EFIINCS) $(PYINCS) -fno-stack-protector -fpic \
		  -fshort-wchar -mno-red-zone -Wall 
ifeq ($(ARCH),x86_64)
  CFLAGS += -DEFI_FUNCTION_WRAPPER
endif

LDFLAGS         = -nostdlib -znocombreloc -T $(EFI_LDS) -shared \
		  -Bsymbolic -L $(EFILIB) -L $(LIB) $(EFI_CRT_OBJS) 

all: $(TARGET)

cykern.c: cykern.pyx
	# --embed creates a main() function
	$(CYTHON) --embed cykern.pyx

%.so: $(OBJS)
	ld $(LDFLAGS) $(OBJS) -o $@ -lefi -lgnuefi

%.efi: %.so
	objcopy -j .text -j .sdata -j .data -j .dynamic \
		-j .dynsym  -j .rel -j .rela -j .reloc \
		--target=efi-app-$(ARCH) $^ $@

install: $(TARGET)
	install -m 0755 $^ /boot/efi/EFI/ubuntu

clean:
	rm -f *.o *.so *.efi cykern.c
