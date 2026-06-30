# Walkthrough of memtrack Implementation

We have successfully implemented the `memtrack` system call to track process memory behavior in xv6-riscv.

## Changes Made

### 1. Structure Definition
- **[types.h](file:///d:/xv6-riscv-riscv/kernel/types.h):** Defined `struct proc_mem` to pack tracking stats (`phys_pages` and `mem_reqs`) and return them to user space.

### 2. Process Statistics Tracking
- **[proc.h](file:///d:/xv6-riscv-riscv/kernel/proc.h):** Added `uint64 mem_reqs;` counter to `struct proc`.
- **[proc.c](file:///d:/xv6-riscv-riscv/kernel/proc.c):** Initialized `p->mem_reqs = 0;` inside `freeproc()`.
- **[exec.c](file:///d:/xv6-riscv-riscv/kernel/exec.c):** Reset `p->mem_reqs = 0;` during `kexec()` when committing to a new program binary.
- **[sysproc.c](file:///d:/xv6-riscv-riscv/kernel/sysproc.c):** Incremented `p->mem_reqs` inside `sys_sbrk` on successful memory growth requests (`n > 0`).

### 3. Physical Page Count
- **[vm.c](file:///d:/xv6-riscv-riscv/kernel/vm.c):** Implemented `count_phys_pages(struct proc *p)` which walks the process's page table for valid (`PTE_V`) user pages (`PTE_U`) within the size boundary `[0, p->sz)` and returns the count.
- **[defs.h](file:///d:/xv6-riscv-riscv/kernel/defs.h):** Exported `count_phys_pages(struct proc *);` so it is accessible to other kernel source files.

### 4. System Call Dispatch & Exposing to Userspace
- **[syscall.h](file:///d:/xv6-riscv-riscv/kernel/syscall.h):** Assigned `SYS_memtrack` system call number (22).
- **[syscall.c](file:///d:/xv6-riscv-riscv/kernel/syscall.c):** Registered `sys_memtrack` in the syscall dispatch table.
- **[sysproc.c](file:///d:/xv6-riscv-riscv/kernel/sysproc.c):** Implemented `sys_memtrack()` handler which collects stats and uses `copyout` to safely copy them to the user space structure address.
- **[user.h](file:///d:/xv6-riscv-riscv/user/user.h):** Exposed `int memtrack(struct proc_mem *pm);` to user space programs.
- **[usys.pl](file:///d:/xv6-riscv-riscv/user/usys.pl):** Added entry for `memtrack` to generate the assembly stub.

### 5. Verification Program
- **[Makefile](file:///d:/xv6-riscv-riscv/Makefile):** Added `_memtest` to `UPROGS` to build the test program automatically.
- **[memtest.c](file:///d:/xv6-riscv-riscv/user/memtest.c):** Created a comprehensive test program that verifies:
  1. Initial stats (0 memory requests).
  2. Eager allocation increases both request count and page count.
  3. Lazy allocation increases request count, but page count remains unchanged.
  4. Accessing the lazy memory page faults it in and increases the physical page count.
  5. Memory shrinkage decreases page count, but leaves request count unchanged.

---

## How to Verify and Run

To compile the code and run the test in QEMU:

1. Build and run the emulator:
   ```bash
   make qemu
   ```
2. Once the xv6 shell starts, run the verification program:
   ```bash
   memtest
   ```
3. The program will print step-by-step progress and verification of physical page count and request count, culminating in:
   ```
   SUCCESS: All memtrack tests passed!
   ```
