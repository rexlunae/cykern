cdef extern from "stddef.h":
    ctypedef void wchar_t

cdef extern from 'efi.h':
    ctypedef CHAR16
cdef extern from 'efilib.h':
    void Print(wchar_t * fmt...)
    void *AllocatePool(size_t)
    void FreePool(void *ptr)

cdef extern from 'efidef.h':
    ctypedef enum EFI_MEMORY_TYPE:
        pass

cdef inline void rawprint(s):
    cdef bytes py_bytes = s.encode('utf_16')
    cdef char *c_string = py_bytes

    Print(c_string)

cdef int initialized = 0
cdef extern void Py_Initialize():

    Print('I\00n\00i\00t\00i\00a\00l\00i\00z\00e\00d\00.\00\n\00')
    rawprint('This is the real test!!!\n')
    initialized = 1


# We need malloc and free to support the compiler.  Fortunately, UEFI makes that fairly painless.
# XXX - We'll eventually need to support ending boot services.
cdef extern void *malloc(size_t size):
    return AllocatePool(size)
cdef extern void free(void *buffer):
    FreePool(buffer)

cdef extern Is_Initialized():
    return initialized


class CyKern():
    def __init__():
        print('Kernel loaded.  Lets do this.')


if __name__ == '__main__':
    kernel = CyKern()
    kernel.run()
