#include <efi.h>
#include <efilib.h>

#include <Python.h>

int main(int argc, char **argv);

EFI_STATUS
EFIAPI
efi_main(EFI_HANDLE IH, EFI_SYSTEM_TABLE *ST)
{
	InitializeLib(IH, ST);
	Print(L"Attempting to launch Python code. Press a key...\n");
	Pause();
	Print(L"Execution ended with status %d  Press any key to restart.\n", main(0, NULL));
	Pause();
	return EFI_SUCCESS;
}
