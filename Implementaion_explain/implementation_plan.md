# Memory Behavior Tracking System Call

This plan describes how to implement the `memtrack` system call in xv6-riscv to retrieve the following memory tracking statistics for a process:
1. The total number of physical pages currently occupied by the process.
2. The number of times the process has requested additional memory (i.e. successful calls to `sbrk` where `n > 0`).

---

## User Review Required

> [!NOTE]
> - **Scope of Memory Requests:** We only increment the memory request counter when a process successfully grows its memory size (i.e., `sbrk(n)` with `n > 0`). Shrinking memory (`n < 0`) or querying the heap limit (`n = 0`) are not counted as requests for memory.
> - **Lazy Page Handling:** The physical page count counts pages in the virtual range `[0, p->sz)` that have been successfully mapped to physical frames (meaning the page table entry is valid `PTE_V` and user-accessible `PTE_U`). Lazily allocated pages will only be counted *after* they are actually accessed (triggering a page fault that allocates a physical page).
> - **Reset on Exec:** When a process executes a new binary via `exec`, its memory statistics are reset to `0` so that the new program starts with a clean tracking history.

---

## Open Questions

None. The system call requirements are clear and align perfectly with xv6's page allocation design.

---

## Proposed Changes

### Kernel Component

#### [MODIFY] [types.h](file:///d:/xv6-riscv-riscv/kernel/types.h)
- Define `struct proc_mem` containing `phys_pages` and `mem_reqs` to be shared between kernel space and user space.

```c
struct proc_mem {
  uint64 phys_pages; // number of physical pages occupied
  uint64 mem_reqs;   // number of times process requested memory (sbrk with n > 0)
};
```

#### [MODIFY] [proc.h](file:///d:/xv6-riscv-riscv/kernel/proc.h)
- Add `uint64 mem_reqs` tracking field to `struct proc`.

#### [MODIFY] [proc.c](file:///d:/xv6-riscv-riscv/kernel/proc.c)
- Reset `p->mem_reqs = 0;` inside `freeproc()`. This ensures newly allocated processes start with 0 requests.

#### [MODIFY] [exec.c](file:///d:/xv6-riscv-riscv/kernel/exec.c)
- Reset `p->mem_reqs = 0;` inside `kexec()` before committing to user space. This resets statistics for the newly executed program.

#### [MODIFY] [sysproc.c](file:///d:/xv6-riscv-riscv/kernel/sysproc.c)
- Modify `sys_sbrk` to increment `myproc()->mem_reqs` when `n > 0` and the request succeeds.
- Implement the handler `sys_memtrack(void)` that extracts the user pointer, counts physical pages using a new helper, copies the values into a `struct proc_mem` and sends it back to user space using `copyout()`.

#### [MODIFY] [vm.c](file:///d:/xv6-riscv-riscv/kernel/vm.c)
- Implement `count_phys_pages(struct proc *p)`:
```c
uint64
count_phys_pages(struct proc *p)
{
  uint64 count = 0;
  for(uint64 va = 0; va < p->sz; va += PGSIZE){
    pte_t *pte = walk(p->pagetable, va, 0);
    if(pte != 0 && (*pte & PTE_V) && (*pte & PTE_U)){
      count++;
    }
  }
  return count;
}
```

#### [MODIFY] [defs.h](file:///d:/xv6-riscv-riscv/kernel/defs.h)
- Export `uint64 count_phys_pages(struct proc *);` in the `// vm.c` section.

#### [MODIFY] [syscall.h](file:///d:/xv6-riscv-riscv/kernel/syscall.h)
- Define `SYS_memtrack` system call number (22).

#### [MODIFY] [syscall.c](file:///d:/xv6-riscv-riscv/kernel/syscall.c)
- Declare `extern uint64 sys_memtrack(void);` and add it to the `syscalls` function pointer array.

---

### User Component

#### [MODIFY] [user.h](file:///d:/xv6-riscv-riscv/user/user.h)
- Expose the user space system call signature: `int memtrack(struct proc_mem *pm);`

#### [MODIFY] [usys.pl](file:///d:/xv6-riscv-riscv/user/usys.pl)
- Add system call entry: `entry("memtrack");`

#### [MODIFY] [Makefile](file:///d:/xv6-riscv-riscv/Makefile)
- Add `$U/_memtest\` to the `UPROGS` list.

#### [NEW] [memtest.c](file:///d:/xv6-riscv-riscv/user/memtest.c)
- Write a user space test program to verify that `memtrack` registers memory allocation requests and page count changes correctly, specifically testing:
  - Initial stats (0 memory requests).
  - Growth using eager `sbrk()` (increments physical page count and request count).
  - Growth using lazy `sbrklazy()` (increments request count, but physical page count remains same).
  - Faulting in the lazy page by writing to it (increments physical page count).
  - Shrinking memory using negative `sbrk()` (decreases physical page count, request count remains unchanged).

---

## Verification Plan

### Automated Tests
We will build the xv6 kernel and run the newly added user program to confirm correct functionality.

```powershell
# Build and run the test in qemu
make qemu
# In the xv6 shell:
memtest
```

### Manual Verification
Verify that the outputs match the expected transitions:
1. `initial: phys_pages=X, mem_reqs=0`
2. `after eager sbrk: phys_pages=X+1, mem_reqs=1`
3. `after lazy sbrk: phys_pages=X+1, mem_reqs=2` (page count unchanged)
4. `after writing lazy page: phys_pages=X+2, mem_reqs=2` (page count increased)
5. `after shrinking: phys_pages=X+1, mem_reqs=2` (page count decreased, request count unchanged)
