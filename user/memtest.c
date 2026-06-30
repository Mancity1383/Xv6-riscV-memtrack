#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  struct proc_mem pm;

  printf("Starting memory tracking test...\n");

  // 1. Initial State
  if (memtrack(&pm) < 0) {
    printf("FAILED: memtrack failed\n");
    exit(1);
  }
  printf("Initial: phys_pages=%ld, mem_reqs=%ld\n", pm.phys_pages, pm.mem_reqs);
  
  uint64 initial_pages = pm.phys_pages;
  if (pm.mem_reqs != 0) {
    printf("FAILED: mem_reqs should be 0 initially, got %ld\n", pm.mem_reqs);
    exit(1);
  }

  // 2. Eager sbrk growth
  printf("Allocating 1 page eagerly...\n");
  char *p1 = sbrk(4096);
  if (p1 == SBRK_ERROR) {
    printf("FAILED: sbrk failed\n");
    exit(1);
  }

  if (memtrack(&pm) < 0) {
    printf("FAILED: memtrack failed\n");
    exit(1);
  }
  printf("After eager sbrk: phys_pages=%ld, mem_reqs=%ld\n", pm.phys_pages, pm.mem_reqs);

  if (pm.mem_reqs != 1) {
    printf("FAILED: mem_reqs should be 1 after eager sbrk, got %ld\n", pm.mem_reqs);
    exit(1);
  }
  if (pm.phys_pages != initial_pages + 1) {
    printf("FAILED: phys_pages should be %ld, got %ld\n", initial_pages + 1, pm.phys_pages);
    exit(1);
  }

  // 3. Lazy sbrk growth
  printf("Allocating 1 page lazily...\n");
  char *p2 = sbrklazy(4096);
  if (p2 == SBRK_ERROR) {
    printf("FAILED: sbrklazy failed\n");
    exit(1);
  }

  if (memtrack(&pm) < 0) {
    printf("FAILED: memtrack failed\n");
    exit(1);
  }
  printf("After lazy sbrk: phys_pages=%ld, mem_reqs=%ld\n", pm.phys_pages, pm.mem_reqs);

  if (pm.mem_reqs != 2) {
    printf("FAILED: mem_reqs should be 2 after lazy sbrk, got %ld\n", pm.mem_reqs);
    exit(1);
  }
  if (pm.phys_pages != initial_pages + 1) {
    printf("FAILED: phys_pages should still be %ld after lazy allocation, got %ld\n", initial_pages + 1, pm.phys_pages);
    exit(1);
  }

  // 4. Accessing lazy page (triggering page fault)
  printf("Writing to lazy page to fault it in...\n");
  p2[0] = 'a'; // this should trigger fault and map page

  if (memtrack(&pm) < 0) {
    printf("FAILED: memtrack failed\n");
    exit(1);
  }
  printf("After faulting in lazy page: phys_pages=%ld, mem_reqs=%ld\n", pm.phys_pages, pm.mem_reqs);

  if (pm.phys_pages != initial_pages + 2) {
    printf("FAILED: phys_pages should be %ld, got %ld\n", initial_pages + 2, pm.phys_pages);
    exit(1);
  }

  // 5. Deallocating memory
  printf("Deallocating 1 page...\n");
  if (sbrk(-4096) == SBRK_ERROR) {
    printf("FAILED: sbrk shrink failed\n");
    exit(1);
  }

  if (memtrack(&pm) < 0) {
    printf("FAILED: memtrack failed\n");
    exit(1);
  }
  printf("After shrink: phys_pages=%ld, mem_reqs=%ld\n", pm.phys_pages, pm.mem_reqs);

  if (pm.mem_reqs != 2) {
    printf("FAILED: mem_reqs should remain 2 after shrinking, got %ld\n", pm.mem_reqs);
    exit(1);
  }
  if (pm.phys_pages != initial_pages + 1) {
    printf("FAILED: phys_pages should decrease to %ld, got %ld\n", initial_pages + 1, pm.phys_pages);
    exit(1);
  }

  printf("SUCCESS: All memtrack tests passed!\n");
  exit(0);
}