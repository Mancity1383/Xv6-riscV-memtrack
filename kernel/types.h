typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int  uint32;
typedef unsigned long uint64;

typedef uint64 pde_t;

struct proc_mem {
  uint64 phys_pages; // number of physical pages occupied
  uint64 mem_reqs;   // number of times process requested memory (sbrk with n > 0)
};

