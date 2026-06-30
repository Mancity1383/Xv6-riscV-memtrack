
user/_memtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
  struct proc_mem pm;

  printf("Starting memory tracking test...\n");
   8:	00001517          	auipc	a0,0x1
   c:	b2850513          	addi	a0,a0,-1240 # b30 <malloc+0x106>
  10:	167000ef          	jal	976 <printf>

  // 1. Initial State
  if (memtrack(&pm) < 0) {
  14:	fc040513          	addi	a0,s0,-64
  18:	5ce000ef          	jal	5e6 <memtrack>
  1c:	02054d63          	bltz	a0,56 <main+0x56>
  20:	f426                	sd	s1,40(sp)
    printf("FAILED: memtrack failed\n");
    exit(1);
  }
  printf("Initial: phys_pages=%ld, mem_reqs=%ld\n", pm.phys_pages, pm.mem_reqs);
  22:	fc843603          	ld	a2,-56(s0)
  26:	fc043583          	ld	a1,-64(s0)
  2a:	00001517          	auipc	a0,0x1
  2e:	b4e50513          	addi	a0,a0,-1202 # b78 <malloc+0x14e>
  32:	145000ef          	jal	976 <printf>
  
  uint64 initial_pages = pm.phys_pages;
  36:	fc043483          	ld	s1,-64(s0)
  if (pm.mem_reqs != 0) {
  3a:	fc843583          	ld	a1,-56(s0)
  3e:	c985                	beqz	a1,6e <main+0x6e>
  40:	f04a                	sd	s2,32(sp)
  42:	ec4e                	sd	s3,24(sp)
    printf("FAILED: mem_reqs should be 0 initially, got %ld\n", pm.mem_reqs);
  44:	00001517          	auipc	a0,0x1
  48:	b5c50513          	addi	a0,a0,-1188 # ba0 <malloc+0x176>
  4c:	12b000ef          	jal	976 <printf>
    exit(1);
  50:	4505                	li	a0,1
  52:	4f4000ef          	jal	546 <exit>
  56:	f426                	sd	s1,40(sp)
  58:	f04a                	sd	s2,32(sp)
  5a:	ec4e                	sd	s3,24(sp)
    printf("FAILED: memtrack failed\n");
  5c:	00001517          	auipc	a0,0x1
  60:	afc50513          	addi	a0,a0,-1284 # b58 <malloc+0x12e>
  64:	113000ef          	jal	976 <printf>
    exit(1);
  68:	4505                	li	a0,1
  6a:	4dc000ef          	jal	546 <exit>
  }

  // 2. Eager sbrk growth
  printf("Allocating 1 page eagerly...\n");
  6e:	00001517          	auipc	a0,0x1
  72:	b6a50513          	addi	a0,a0,-1174 # bd8 <malloc+0x1ae>
  76:	101000ef          	jal	976 <printf>
  char *p1 = sbrk(4096);
  7a:	6505                	lui	a0,0x1
  7c:	496000ef          	jal	512 <sbrk>
  if (p1 == SBRK_ERROR) {
  80:	57fd                	li	a5,-1
  82:	04f50963          	beq	a0,a5,d4 <main+0xd4>
    printf("FAILED: sbrk failed\n");
    exit(1);
  }

  if (memtrack(&pm) < 0) {
  86:	fc040513          	addi	a0,s0,-64
  8a:	55c000ef          	jal	5e6 <memtrack>
  8e:	04054e63          	bltz	a0,ea <main+0xea>
  92:	f04a                	sd	s2,32(sp)
  94:	ec4e                	sd	s3,24(sp)
    printf("FAILED: memtrack failed\n");
    exit(1);
  }
  printf("After eager sbrk: phys_pages=%ld, mem_reqs=%ld\n", pm.phys_pages, pm.mem_reqs);
  96:	fc843603          	ld	a2,-56(s0)
  9a:	fc043583          	ld	a1,-64(s0)
  9e:	00001517          	auipc	a0,0x1
  a2:	b7250513          	addi	a0,a0,-1166 # c10 <malloc+0x1e6>
  a6:	0d1000ef          	jal	976 <printf>

  if (pm.mem_reqs != 1) {
  aa:	fc843583          	ld	a1,-56(s0)
  ae:	4785                	li	a5,1
  b0:	04f59863          	bne	a1,a5,100 <main+0x100>
    printf("FAILED: mem_reqs should be 1 after eager sbrk, got %ld\n", pm.mem_reqs);
    exit(1);
  }
  if (pm.phys_pages != initial_pages + 1) {
  b4:	fc043603          	ld	a2,-64(s0)
  b8:	00148913          	addi	s2,s1,1
  bc:	05260b63          	beq	a2,s2,112 <main+0x112>
    printf("FAILED: phys_pages should be %ld, got %ld\n", initial_pages + 1, pm.phys_pages);
  c0:	85ca                	mv	a1,s2
  c2:	00001517          	auipc	a0,0x1
  c6:	bb650513          	addi	a0,a0,-1098 # c78 <malloc+0x24e>
  ca:	0ad000ef          	jal	976 <printf>
    exit(1);
  ce:	4505                	li	a0,1
  d0:	476000ef          	jal	546 <exit>
  d4:	f04a                	sd	s2,32(sp)
  d6:	ec4e                	sd	s3,24(sp)
    printf("FAILED: sbrk failed\n");
  d8:	00001517          	auipc	a0,0x1
  dc:	b2050513          	addi	a0,a0,-1248 # bf8 <malloc+0x1ce>
  e0:	097000ef          	jal	976 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	460000ef          	jal	546 <exit>
  ea:	f04a                	sd	s2,32(sp)
  ec:	ec4e                	sd	s3,24(sp)
    printf("FAILED: memtrack failed\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	a6a50513          	addi	a0,a0,-1430 # b58 <malloc+0x12e>
  f6:	081000ef          	jal	976 <printf>
    exit(1);
  fa:	4505                	li	a0,1
  fc:	44a000ef          	jal	546 <exit>
    printf("FAILED: mem_reqs should be 1 after eager sbrk, got %ld\n", pm.mem_reqs);
 100:	00001517          	auipc	a0,0x1
 104:	b4050513          	addi	a0,a0,-1216 # c40 <malloc+0x216>
 108:	06f000ef          	jal	976 <printf>
    exit(1);
 10c:	4505                	li	a0,1
 10e:	438000ef          	jal	546 <exit>
  }

  // 3. Lazy sbrk growth
  printf("Allocating 1 page lazily...\n");
 112:	00001517          	auipc	a0,0x1
 116:	b9650513          	addi	a0,a0,-1130 # ca8 <malloc+0x27e>
 11a:	05d000ef          	jal	976 <printf>
  char *p2 = sbrklazy(4096);
 11e:	6505                	lui	a0,0x1
 120:	408000ef          	jal	528 <sbrklazy>
 124:	89aa                	mv	s3,a0
  if (p2 == SBRK_ERROR) {
 126:	57fd                	li	a5,-1
 128:	04f50563          	beq	a0,a5,172 <main+0x172>
    printf("FAILED: sbrklazy failed\n");
    exit(1);
  }

  if (memtrack(&pm) < 0) {
 12c:	fc040513          	addi	a0,s0,-64
 130:	4b6000ef          	jal	5e6 <memtrack>
 134:	04054863          	bltz	a0,184 <main+0x184>
    printf("FAILED: memtrack failed\n");
    exit(1);
  }
  printf("After lazy sbrk: phys_pages=%ld, mem_reqs=%ld\n", pm.phys_pages, pm.mem_reqs);
 138:	fc843603          	ld	a2,-56(s0)
 13c:	fc043583          	ld	a1,-64(s0)
 140:	00001517          	auipc	a0,0x1
 144:	ba850513          	addi	a0,a0,-1112 # ce8 <malloc+0x2be>
 148:	02f000ef          	jal	976 <printf>

  if (pm.mem_reqs != 2) {
 14c:	fc843583          	ld	a1,-56(s0)
 150:	4789                	li	a5,2
 152:	04f59263          	bne	a1,a5,196 <main+0x196>
    printf("FAILED: mem_reqs should be 2 after lazy sbrk, got %ld\n", pm.mem_reqs);
    exit(1);
  }
  if (pm.phys_pages != initial_pages + 1) {
 156:	fc043603          	ld	a2,-64(s0)
 15a:	04c90763          	beq	s2,a2,1a8 <main+0x1a8>
    printf("FAILED: phys_pages should still be %ld after lazy allocation, got %ld\n", initial_pages + 1, pm.phys_pages);
 15e:	85ca                	mv	a1,s2
 160:	00001517          	auipc	a0,0x1
 164:	bf050513          	addi	a0,a0,-1040 # d50 <malloc+0x326>
 168:	00f000ef          	jal	976 <printf>
    exit(1);
 16c:	4505                	li	a0,1
 16e:	3d8000ef          	jal	546 <exit>
    printf("FAILED: sbrklazy failed\n");
 172:	00001517          	auipc	a0,0x1
 176:	b5650513          	addi	a0,a0,-1194 # cc8 <malloc+0x29e>
 17a:	7fc000ef          	jal	976 <printf>
    exit(1);
 17e:	4505                	li	a0,1
 180:	3c6000ef          	jal	546 <exit>
    printf("FAILED: memtrack failed\n");
 184:	00001517          	auipc	a0,0x1
 188:	9d450513          	addi	a0,a0,-1580 # b58 <malloc+0x12e>
 18c:	7ea000ef          	jal	976 <printf>
    exit(1);
 190:	4505                	li	a0,1
 192:	3b4000ef          	jal	546 <exit>
    printf("FAILED: mem_reqs should be 2 after lazy sbrk, got %ld\n", pm.mem_reqs);
 196:	00001517          	auipc	a0,0x1
 19a:	b8250513          	addi	a0,a0,-1150 # d18 <malloc+0x2ee>
 19e:	7d8000ef          	jal	976 <printf>
    exit(1);
 1a2:	4505                	li	a0,1
 1a4:	3a2000ef          	jal	546 <exit>
  }

  // 4. Accessing lazy page (triggering page fault)
  printf("Writing to lazy page to fault it in...\n");
 1a8:	00001517          	auipc	a0,0x1
 1ac:	bf050513          	addi	a0,a0,-1040 # d98 <malloc+0x36e>
 1b0:	7c6000ef          	jal	976 <printf>
  p2[0] = 'a'; // this should trigger fault and map page
 1b4:	06100793          	li	a5,97
 1b8:	00f98023          	sb	a5,0(s3)

  if (memtrack(&pm) < 0) {
 1bc:	fc040513          	addi	a0,s0,-64
 1c0:	426000ef          	jal	5e6 <memtrack>
 1c4:	02054b63          	bltz	a0,1fa <main+0x1fa>
    printf("FAILED: memtrack failed\n");
    exit(1);
  }
  printf("After faulting in lazy page: phys_pages=%ld, mem_reqs=%ld\n", pm.phys_pages, pm.mem_reqs);
 1c8:	fc843603          	ld	a2,-56(s0)
 1cc:	fc043583          	ld	a1,-64(s0)
 1d0:	00001517          	auipc	a0,0x1
 1d4:	bf050513          	addi	a0,a0,-1040 # dc0 <malloc+0x396>
 1d8:	79e000ef          	jal	976 <printf>

  if (pm.phys_pages != initial_pages + 2) {
 1dc:	fc043603          	ld	a2,-64(s0)
 1e0:	00248593          	addi	a1,s1,2
 1e4:	02b60463          	beq	a2,a1,20c <main+0x20c>
    printf("FAILED: phys_pages should be %ld, got %ld\n", initial_pages + 2, pm.phys_pages);
 1e8:	00001517          	auipc	a0,0x1
 1ec:	a9050513          	addi	a0,a0,-1392 # c78 <malloc+0x24e>
 1f0:	786000ef          	jal	976 <printf>
    exit(1);
 1f4:	4505                	li	a0,1
 1f6:	350000ef          	jal	546 <exit>
    printf("FAILED: memtrack failed\n");
 1fa:	00001517          	auipc	a0,0x1
 1fe:	95e50513          	addi	a0,a0,-1698 # b58 <malloc+0x12e>
 202:	774000ef          	jal	976 <printf>
    exit(1);
 206:	4505                	li	a0,1
 208:	33e000ef          	jal	546 <exit>
  }

  // 5. Deallocating memory
  printf("Deallocating 1 page...\n");
 20c:	00001517          	auipc	a0,0x1
 210:	bf450513          	addi	a0,a0,-1036 # e00 <malloc+0x3d6>
 214:	762000ef          	jal	976 <printf>
  if (sbrk(-4096) == SBRK_ERROR) {
 218:	757d                	lui	a0,0xfffff
 21a:	2f8000ef          	jal	512 <sbrk>
 21e:	57fd                	li	a5,-1
 220:	04f50563          	beq	a0,a5,26a <main+0x26a>
    printf("FAILED: sbrk shrink failed\n");
    exit(1);
  }

  if (memtrack(&pm) < 0) {
 224:	fc040513          	addi	a0,s0,-64
 228:	3be000ef          	jal	5e6 <memtrack>
 22c:	04054863          	bltz	a0,27c <main+0x27c>
    printf("FAILED: memtrack failed\n");
    exit(1);
  }
  printf("After shrink: phys_pages=%ld, mem_reqs=%ld\n", pm.phys_pages, pm.mem_reqs);
 230:	fc843603          	ld	a2,-56(s0)
 234:	fc043583          	ld	a1,-64(s0)
 238:	00001517          	auipc	a0,0x1
 23c:	c0050513          	addi	a0,a0,-1024 # e38 <malloc+0x40e>
 240:	736000ef          	jal	976 <printf>

  if (pm.mem_reqs != 2) {
 244:	fc843583          	ld	a1,-56(s0)
 248:	4789                	li	a5,2
 24a:	04f59263          	bne	a1,a5,28e <main+0x28e>
    printf("FAILED: mem_reqs should remain 2 after shrinking, got %ld\n", pm.mem_reqs);
    exit(1);
  }
  if (pm.phys_pages != initial_pages + 1) {
 24e:	fc043603          	ld	a2,-64(s0)
 252:	04c90763          	beq	s2,a2,2a0 <main+0x2a0>
    printf("FAILED: phys_pages should decrease to %ld, got %ld\n", initial_pages + 1, pm.phys_pages);
 256:	85ca                	mv	a1,s2
 258:	00001517          	auipc	a0,0x1
 25c:	c5050513          	addi	a0,a0,-944 # ea8 <malloc+0x47e>
 260:	716000ef          	jal	976 <printf>
    exit(1);
 264:	4505                	li	a0,1
 266:	2e0000ef          	jal	546 <exit>
    printf("FAILED: sbrk shrink failed\n");
 26a:	00001517          	auipc	a0,0x1
 26e:	bae50513          	addi	a0,a0,-1106 # e18 <malloc+0x3ee>
 272:	704000ef          	jal	976 <printf>
    exit(1);
 276:	4505                	li	a0,1
 278:	2ce000ef          	jal	546 <exit>
    printf("FAILED: memtrack failed\n");
 27c:	00001517          	auipc	a0,0x1
 280:	8dc50513          	addi	a0,a0,-1828 # b58 <malloc+0x12e>
 284:	6f2000ef          	jal	976 <printf>
    exit(1);
 288:	4505                	li	a0,1
 28a:	2bc000ef          	jal	546 <exit>
    printf("FAILED: mem_reqs should remain 2 after shrinking, got %ld\n", pm.mem_reqs);
 28e:	00001517          	auipc	a0,0x1
 292:	bda50513          	addi	a0,a0,-1062 # e68 <malloc+0x43e>
 296:	6e0000ef          	jal	976 <printf>
    exit(1);
 29a:	4505                	li	a0,1
 29c:	2aa000ef          	jal	546 <exit>
  }

  printf("SUCCESS: All memtrack tests passed!\n");
 2a0:	00001517          	auipc	a0,0x1
 2a4:	c4050513          	addi	a0,a0,-960 # ee0 <malloc+0x4b6>
 2a8:	6ce000ef          	jal	976 <printf>
  exit(0);
 2ac:	4501                	li	a0,0
 2ae:	298000ef          	jal	546 <exit>

00000000000002b2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 2ba:	d47ff0ef          	jal	0 <main>
  exit(r);
 2be:	288000ef          	jal	546 <exit>

00000000000002c2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2c8:	87aa                	mv	a5,a0
 2ca:	0585                	addi	a1,a1,1
 2cc:	0785                	addi	a5,a5,1
 2ce:	fff5c703          	lbu	a4,-1(a1)
 2d2:	fee78fa3          	sb	a4,-1(a5)
 2d6:	fb75                	bnez	a4,2ca <strcpy+0x8>
    ;
  return os;
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	cb91                	beqz	a5,2fc <strcmp+0x1e>
 2ea:	0005c703          	lbu	a4,0(a1)
 2ee:	00f71763          	bne	a4,a5,2fc <strcmp+0x1e>
    p++, q++;
 2f2:	0505                	addi	a0,a0,1
 2f4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	fbe5                	bnez	a5,2ea <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2fc:	0005c503          	lbu	a0,0(a1)
}
 300:	40a7853b          	subw	a0,a5,a0
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <strlen>:

uint
strlen(const char *s)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 310:	00054783          	lbu	a5,0(a0)
 314:	cf91                	beqz	a5,330 <strlen+0x26>
 316:	0505                	addi	a0,a0,1
 318:	87aa                	mv	a5,a0
 31a:	86be                	mv	a3,a5
 31c:	0785                	addi	a5,a5,1
 31e:	fff7c703          	lbu	a4,-1(a5)
 322:	ff65                	bnez	a4,31a <strlen+0x10>
 324:	40a6853b          	subw	a0,a3,a0
 328:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  for(n = 0; s[n]; n++)
 330:	4501                	li	a0,0
 332:	bfe5                	j	32a <strlen+0x20>

0000000000000334 <memset>:

void*
memset(void *dst, int c, uint n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 33a:	ca19                	beqz	a2,350 <memset+0x1c>
 33c:	87aa                	mv	a5,a0
 33e:	1602                	slli	a2,a2,0x20
 340:	9201                	srli	a2,a2,0x20
 342:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 346:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 34a:	0785                	addi	a5,a5,1
 34c:	fee79de3          	bne	a5,a4,346 <memset+0x12>
  }
  return dst;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <strchr>:

char*
strchr(const char *s, char c)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 35c:	00054783          	lbu	a5,0(a0)
 360:	cb99                	beqz	a5,376 <strchr+0x20>
    if(*s == c)
 362:	00f58763          	beq	a1,a5,370 <strchr+0x1a>
  for(; *s; s++)
 366:	0505                	addi	a0,a0,1
 368:	00054783          	lbu	a5,0(a0)
 36c:	fbfd                	bnez	a5,362 <strchr+0xc>
      return (char*)s;
  return 0;
 36e:	4501                	li	a0,0
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
  return 0;
 376:	4501                	li	a0,0
 378:	bfe5                	j	370 <strchr+0x1a>

000000000000037a <gets>:

char*
gets(char *buf, int max)
{
 37a:	711d                	addi	sp,sp,-96
 37c:	ec86                	sd	ra,88(sp)
 37e:	e8a2                	sd	s0,80(sp)
 380:	e4a6                	sd	s1,72(sp)
 382:	e0ca                	sd	s2,64(sp)
 384:	fc4e                	sd	s3,56(sp)
 386:	f852                	sd	s4,48(sp)
 388:	f456                	sd	s5,40(sp)
 38a:	f05a                	sd	s6,32(sp)
 38c:	ec5e                	sd	s7,24(sp)
 38e:	1080                	addi	s0,sp,96
 390:	8baa                	mv	s7,a0
 392:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 394:	892a                	mv	s2,a0
 396:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 398:	4aa9                	li	s5,10
 39a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 39c:	89a6                	mv	s3,s1
 39e:	2485                	addiw	s1,s1,1
 3a0:	0344d663          	bge	s1,s4,3cc <gets+0x52>
    cc = read(0, &c, 1);
 3a4:	4605                	li	a2,1
 3a6:	faf40593          	addi	a1,s0,-81
 3aa:	4501                	li	a0,0
 3ac:	1b2000ef          	jal	55e <read>
    if(cc < 1)
 3b0:	00a05e63          	blez	a0,3cc <gets+0x52>
    buf[i++] = c;
 3b4:	faf44783          	lbu	a5,-81(s0)
 3b8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3bc:	01578763          	beq	a5,s5,3ca <gets+0x50>
 3c0:	0905                	addi	s2,s2,1
 3c2:	fd679de3          	bne	a5,s6,39c <gets+0x22>
    buf[i++] = c;
 3c6:	89a6                	mv	s3,s1
 3c8:	a011                	j	3cc <gets+0x52>
 3ca:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3cc:	99de                	add	s3,s3,s7
 3ce:	00098023          	sb	zero,0(s3)
  return buf;
}
 3d2:	855e                	mv	a0,s7
 3d4:	60e6                	ld	ra,88(sp)
 3d6:	6446                	ld	s0,80(sp)
 3d8:	64a6                	ld	s1,72(sp)
 3da:	6906                	ld	s2,64(sp)
 3dc:	79e2                	ld	s3,56(sp)
 3de:	7a42                	ld	s4,48(sp)
 3e0:	7aa2                	ld	s5,40(sp)
 3e2:	7b02                	ld	s6,32(sp)
 3e4:	6be2                	ld	s7,24(sp)
 3e6:	6125                	addi	sp,sp,96
 3e8:	8082                	ret

00000000000003ea <stat>:

int
stat(const char *n, struct stat *st)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	e04a                	sd	s2,0(sp)
 3f2:	1000                	addi	s0,sp,32
 3f4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f6:	4581                	li	a1,0
 3f8:	18e000ef          	jal	586 <open>
  if(fd < 0)
 3fc:	02054263          	bltz	a0,420 <stat+0x36>
 400:	e426                	sd	s1,8(sp)
 402:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 404:	85ca                	mv	a1,s2
 406:	198000ef          	jal	59e <fstat>
 40a:	892a                	mv	s2,a0
  close(fd);
 40c:	8526                	mv	a0,s1
 40e:	160000ef          	jal	56e <close>
  return r;
 412:	64a2                	ld	s1,8(sp)
}
 414:	854a                	mv	a0,s2
 416:	60e2                	ld	ra,24(sp)
 418:	6442                	ld	s0,16(sp)
 41a:	6902                	ld	s2,0(sp)
 41c:	6105                	addi	sp,sp,32
 41e:	8082                	ret
    return -1;
 420:	597d                	li	s2,-1
 422:	bfcd                	j	414 <stat+0x2a>

0000000000000424 <atoi>:

int
atoi(const char *s)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 42a:	00054683          	lbu	a3,0(a0)
 42e:	fd06879b          	addiw	a5,a3,-48
 432:	0ff7f793          	zext.b	a5,a5
 436:	4625                	li	a2,9
 438:	02f66863          	bltu	a2,a5,468 <atoi+0x44>
 43c:	872a                	mv	a4,a0
  n = 0;
 43e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 440:	0705                	addi	a4,a4,1
 442:	0025179b          	slliw	a5,a0,0x2
 446:	9fa9                	addw	a5,a5,a0
 448:	0017979b          	slliw	a5,a5,0x1
 44c:	9fb5                	addw	a5,a5,a3
 44e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 452:	00074683          	lbu	a3,0(a4)
 456:	fd06879b          	addiw	a5,a3,-48
 45a:	0ff7f793          	zext.b	a5,a5
 45e:	fef671e3          	bgeu	a2,a5,440 <atoi+0x1c>
  return n;
}
 462:	6422                	ld	s0,8(sp)
 464:	0141                	addi	sp,sp,16
 466:	8082                	ret
  n = 0;
 468:	4501                	li	a0,0
 46a:	bfe5                	j	462 <atoi+0x3e>

000000000000046c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 46c:	1141                	addi	sp,sp,-16
 46e:	e422                	sd	s0,8(sp)
 470:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 472:	02b57463          	bgeu	a0,a1,49a <memmove+0x2e>
    while(n-- > 0)
 476:	00c05f63          	blez	a2,494 <memmove+0x28>
 47a:	1602                	slli	a2,a2,0x20
 47c:	9201                	srli	a2,a2,0x20
 47e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 482:	872a                	mv	a4,a0
      *dst++ = *src++;
 484:	0585                	addi	a1,a1,1
 486:	0705                	addi	a4,a4,1
 488:	fff5c683          	lbu	a3,-1(a1)
 48c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 490:	fef71ae3          	bne	a4,a5,484 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 494:	6422                	ld	s0,8(sp)
 496:	0141                	addi	sp,sp,16
 498:	8082                	ret
    dst += n;
 49a:	00c50733          	add	a4,a0,a2
    src += n;
 49e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a0:	fec05ae3          	blez	a2,494 <memmove+0x28>
 4a4:	fff6079b          	addiw	a5,a2,-1
 4a8:	1782                	slli	a5,a5,0x20
 4aa:	9381                	srli	a5,a5,0x20
 4ac:	fff7c793          	not	a5,a5
 4b0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4b2:	15fd                	addi	a1,a1,-1
 4b4:	177d                	addi	a4,a4,-1
 4b6:	0005c683          	lbu	a3,0(a1)
 4ba:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4be:	fee79ae3          	bne	a5,a4,4b2 <memmove+0x46>
 4c2:	bfc9                	j	494 <memmove+0x28>

00000000000004c4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e422                	sd	s0,8(sp)
 4c8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ca:	ca05                	beqz	a2,4fa <memcmp+0x36>
 4cc:	fff6069b          	addiw	a3,a2,-1
 4d0:	1682                	slli	a3,a3,0x20
 4d2:	9281                	srli	a3,a3,0x20
 4d4:	0685                	addi	a3,a3,1
 4d6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4d8:	00054783          	lbu	a5,0(a0)
 4dc:	0005c703          	lbu	a4,0(a1)
 4e0:	00e79863          	bne	a5,a4,4f0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4e4:	0505                	addi	a0,a0,1
    p2++;
 4e6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4e8:	fed518e3          	bne	a0,a3,4d8 <memcmp+0x14>
  }
  return 0;
 4ec:	4501                	li	a0,0
 4ee:	a019                	j	4f4 <memcmp+0x30>
      return *p1 - *p2;
 4f0:	40e7853b          	subw	a0,a5,a4
}
 4f4:	6422                	ld	s0,8(sp)
 4f6:	0141                	addi	sp,sp,16
 4f8:	8082                	ret
  return 0;
 4fa:	4501                	li	a0,0
 4fc:	bfe5                	j	4f4 <memcmp+0x30>

00000000000004fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4fe:	1141                	addi	sp,sp,-16
 500:	e406                	sd	ra,8(sp)
 502:	e022                	sd	s0,0(sp)
 504:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 506:	f67ff0ef          	jal	46c <memmove>
}
 50a:	60a2                	ld	ra,8(sp)
 50c:	6402                	ld	s0,0(sp)
 50e:	0141                	addi	sp,sp,16
 510:	8082                	ret

0000000000000512 <sbrk>:

char *
sbrk(int n) {
 512:	1141                	addi	sp,sp,-16
 514:	e406                	sd	ra,8(sp)
 516:	e022                	sd	s0,0(sp)
 518:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 51a:	4585                	li	a1,1
 51c:	0b2000ef          	jal	5ce <sys_sbrk>
}
 520:	60a2                	ld	ra,8(sp)
 522:	6402                	ld	s0,0(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret

0000000000000528 <sbrklazy>:

char *
sbrklazy(int n) {
 528:	1141                	addi	sp,sp,-16
 52a:	e406                	sd	ra,8(sp)
 52c:	e022                	sd	s0,0(sp)
 52e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 530:	4589                	li	a1,2
 532:	09c000ef          	jal	5ce <sys_sbrk>
}
 536:	60a2                	ld	ra,8(sp)
 538:	6402                	ld	s0,0(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret

000000000000053e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 53e:	4885                	li	a7,1
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <exit>:
.global exit
exit:
 li a7, SYS_exit
 546:	4889                	li	a7,2
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <wait>:
.global wait
wait:
 li a7, SYS_wait
 54e:	488d                	li	a7,3
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 556:	4891                	li	a7,4
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <read>:
.global read
read:
 li a7, SYS_read
 55e:	4895                	li	a7,5
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <write>:
.global write
write:
 li a7, SYS_write
 566:	48c1                	li	a7,16
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <close>:
.global close
close:
 li a7, SYS_close
 56e:	48d5                	li	a7,21
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <kill>:
.global kill
kill:
 li a7, SYS_kill
 576:	4899                	li	a7,6
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <exec>:
.global exec
exec:
 li a7, SYS_exec
 57e:	489d                	li	a7,7
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <open>:
.global open
open:
 li a7, SYS_open
 586:	48bd                	li	a7,15
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 58e:	48c5                	li	a7,17
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 596:	48c9                	li	a7,18
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 59e:	48a1                	li	a7,8
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <link>:
.global link
link:
 li a7, SYS_link
 5a6:	48cd                	li	a7,19
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ae:	48d1                	li	a7,20
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b6:	48a5                	li	a7,9
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <dup>:
.global dup
dup:
 li a7, SYS_dup
 5be:	48a9                	li	a7,10
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c6:	48ad                	li	a7,11
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5ce:	48b1                	li	a7,12
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5d6:	48b5                	li	a7,13
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5de:	48b9                	li	a7,14
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <memtrack>:
.global memtrack
memtrack:
 li a7, SYS_memtrack
 5e6:	48d9                	li	a7,22
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ee:	1101                	addi	sp,sp,-32
 5f0:	ec06                	sd	ra,24(sp)
 5f2:	e822                	sd	s0,16(sp)
 5f4:	1000                	addi	s0,sp,32
 5f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5fa:	4605                	li	a2,1
 5fc:	fef40593          	addi	a1,s0,-17
 600:	f67ff0ef          	jal	566 <write>
}
 604:	60e2                	ld	ra,24(sp)
 606:	6442                	ld	s0,16(sp)
 608:	6105                	addi	sp,sp,32
 60a:	8082                	ret

000000000000060c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 60c:	715d                	addi	sp,sp,-80
 60e:	e486                	sd	ra,72(sp)
 610:	e0a2                	sd	s0,64(sp)
 612:	f84a                	sd	s2,48(sp)
 614:	0880                	addi	s0,sp,80
 616:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 618:	c299                	beqz	a3,61e <printint+0x12>
 61a:	0805c363          	bltz	a1,6a0 <printint+0x94>
  neg = 0;
 61e:	4881                	li	a7,0
 620:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 624:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 626:	00001517          	auipc	a0,0x1
 62a:	8ea50513          	addi	a0,a0,-1814 # f10 <digits>
 62e:	883e                	mv	a6,a5
 630:	2785                	addiw	a5,a5,1
 632:	02c5f733          	remu	a4,a1,a2
 636:	972a                	add	a4,a4,a0
 638:	00074703          	lbu	a4,0(a4)
 63c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 640:	872e                	mv	a4,a1
 642:	02c5d5b3          	divu	a1,a1,a2
 646:	0685                	addi	a3,a3,1
 648:	fec773e3          	bgeu	a4,a2,62e <printint+0x22>
  if(neg)
 64c:	00088b63          	beqz	a7,662 <printint+0x56>
    buf[i++] = '-';
 650:	fd078793          	addi	a5,a5,-48
 654:	97a2                	add	a5,a5,s0
 656:	02d00713          	li	a4,45
 65a:	fee78423          	sb	a4,-24(a5)
 65e:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
 662:	02f05a63          	blez	a5,696 <printint+0x8a>
 666:	fc26                	sd	s1,56(sp)
 668:	f44e                	sd	s3,40(sp)
 66a:	fb840713          	addi	a4,s0,-72
 66e:	00f704b3          	add	s1,a4,a5
 672:	fff70993          	addi	s3,a4,-1
 676:	99be                	add	s3,s3,a5
 678:	37fd                	addiw	a5,a5,-1
 67a:	1782                	slli	a5,a5,0x20
 67c:	9381                	srli	a5,a5,0x20
 67e:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 682:	fff4c583          	lbu	a1,-1(s1)
 686:	854a                	mv	a0,s2
 688:	f67ff0ef          	jal	5ee <putc>
  while(--i >= 0)
 68c:	14fd                	addi	s1,s1,-1
 68e:	ff349ae3          	bne	s1,s3,682 <printint+0x76>
 692:	74e2                	ld	s1,56(sp)
 694:	79a2                	ld	s3,40(sp)
}
 696:	60a6                	ld	ra,72(sp)
 698:	6406                	ld	s0,64(sp)
 69a:	7942                	ld	s2,48(sp)
 69c:	6161                	addi	sp,sp,80
 69e:	8082                	ret
    x = -xx;
 6a0:	40b005b3          	neg	a1,a1
    neg = 1;
 6a4:	4885                	li	a7,1
    x = -xx;
 6a6:	bfad                	j	620 <printint+0x14>

00000000000006a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6a8:	711d                	addi	sp,sp,-96
 6aa:	ec86                	sd	ra,88(sp)
 6ac:	e8a2                	sd	s0,80(sp)
 6ae:	e0ca                	sd	s2,64(sp)
 6b0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6b2:	0005c903          	lbu	s2,0(a1)
 6b6:	28090663          	beqz	s2,942 <vprintf+0x29a>
 6ba:	e4a6                	sd	s1,72(sp)
 6bc:	fc4e                	sd	s3,56(sp)
 6be:	f852                	sd	s4,48(sp)
 6c0:	f456                	sd	s5,40(sp)
 6c2:	f05a                	sd	s6,32(sp)
 6c4:	ec5e                	sd	s7,24(sp)
 6c6:	e862                	sd	s8,16(sp)
 6c8:	e466                	sd	s9,8(sp)
 6ca:	8b2a                	mv	s6,a0
 6cc:	8a2e                	mv	s4,a1
 6ce:	8bb2                	mv	s7,a2
  state = 0;
 6d0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6d2:	4481                	li	s1,0
 6d4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6d6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6da:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6de:	06c00c93          	li	s9,108
 6e2:	a005                	j	702 <vprintf+0x5a>
        putc(fd, c0);
 6e4:	85ca                	mv	a1,s2
 6e6:	855a                	mv	a0,s6
 6e8:	f07ff0ef          	jal	5ee <putc>
 6ec:	a019                	j	6f2 <vprintf+0x4a>
    } else if(state == '%'){
 6ee:	03598263          	beq	s3,s5,712 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6f2:	2485                	addiw	s1,s1,1
 6f4:	8726                	mv	a4,s1
 6f6:	009a07b3          	add	a5,s4,s1
 6fa:	0007c903          	lbu	s2,0(a5)
 6fe:	22090a63          	beqz	s2,932 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 702:	0009079b          	sext.w	a5,s2
    if(state == 0){
 706:	fe0994e3          	bnez	s3,6ee <vprintf+0x46>
      if(c0 == '%'){
 70a:	fd579de3          	bne	a5,s5,6e4 <vprintf+0x3c>
        state = '%';
 70e:	89be                	mv	s3,a5
 710:	b7cd                	j	6f2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 712:	00ea06b3          	add	a3,s4,a4
 716:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 71a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 71c:	c681                	beqz	a3,724 <vprintf+0x7c>
 71e:	9752                	add	a4,a4,s4
 720:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 724:	05878363          	beq	a5,s8,76a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 728:	05978d63          	beq	a5,s9,782 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 72c:	07500713          	li	a4,117
 730:	0ee78763          	beq	a5,a4,81e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 734:	07800713          	li	a4,120
 738:	12e78963          	beq	a5,a4,86a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 73c:	07000713          	li	a4,112
 740:	14e78e63          	beq	a5,a4,89c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 744:	06300713          	li	a4,99
 748:	18e78e63          	beq	a5,a4,8e4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 74c:	07300713          	li	a4,115
 750:	1ae78463          	beq	a5,a4,8f8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 754:	02500713          	li	a4,37
 758:	04e79563          	bne	a5,a4,7a2 <vprintf+0xfa>
        putc(fd, '%');
 75c:	02500593          	li	a1,37
 760:	855a                	mv	a0,s6
 762:	e8dff0ef          	jal	5ee <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 766:	4981                	li	s3,0
 768:	b769                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 76a:	008b8913          	addi	s2,s7,8
 76e:	4685                	li	a3,1
 770:	4629                	li	a2,10
 772:	000ba583          	lw	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	e95ff0ef          	jal	60c <printint>
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
 780:	bf8d                	j	6f2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 782:	06400793          	li	a5,100
 786:	02f68963          	beq	a3,a5,7b8 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 78a:	06c00793          	li	a5,108
 78e:	04f68263          	beq	a3,a5,7d2 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 792:	07500793          	li	a5,117
 796:	0af68063          	beq	a3,a5,836 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 79a:	07800793          	li	a5,120
 79e:	0ef68263          	beq	a3,a5,882 <vprintf+0x1da>
        putc(fd, '%');
 7a2:	02500593          	li	a1,37
 7a6:	855a                	mv	a0,s6
 7a8:	e47ff0ef          	jal	5ee <putc>
        putc(fd, c0);
 7ac:	85ca                	mv	a1,s2
 7ae:	855a                	mv	a0,s6
 7b0:	e3fff0ef          	jal	5ee <putc>
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	bf35                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b8:	008b8913          	addi	s2,s7,8
 7bc:	4685                	li	a3,1
 7be:	4629                	li	a2,10
 7c0:	000bb583          	ld	a1,0(s7)
 7c4:	855a                	mv	a0,s6
 7c6:	e47ff0ef          	jal	60c <printint>
        i += 1;
 7ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7cc:	8bca                	mv	s7,s2
      state = 0;
 7ce:	4981                	li	s3,0
        i += 1;
 7d0:	b70d                	j	6f2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7d2:	06400793          	li	a5,100
 7d6:	02f60763          	beq	a2,a5,804 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7da:	07500793          	li	a5,117
 7de:	06f60963          	beq	a2,a5,850 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7e2:	07800793          	li	a5,120
 7e6:	faf61ee3          	bne	a2,a5,7a2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ea:	008b8913          	addi	s2,s7,8
 7ee:	4681                	li	a3,0
 7f0:	4641                	li	a2,16
 7f2:	000bb583          	ld	a1,0(s7)
 7f6:	855a                	mv	a0,s6
 7f8:	e15ff0ef          	jal	60c <printint>
        i += 2;
 7fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fe:	8bca                	mv	s7,s2
      state = 0;
 800:	4981                	li	s3,0
        i += 2;
 802:	bdc5                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 804:	008b8913          	addi	s2,s7,8
 808:	4685                	li	a3,1
 80a:	4629                	li	a2,10
 80c:	000bb583          	ld	a1,0(s7)
 810:	855a                	mv	a0,s6
 812:	dfbff0ef          	jal	60c <printint>
        i += 2;
 816:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 818:	8bca                	mv	s7,s2
      state = 0;
 81a:	4981                	li	s3,0
        i += 2;
 81c:	bdd9                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 81e:	008b8913          	addi	s2,s7,8
 822:	4681                	li	a3,0
 824:	4629                	li	a2,10
 826:	000be583          	lwu	a1,0(s7)
 82a:	855a                	mv	a0,s6
 82c:	de1ff0ef          	jal	60c <printint>
 830:	8bca                	mv	s7,s2
      state = 0;
 832:	4981                	li	s3,0
 834:	bd7d                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 836:	008b8913          	addi	s2,s7,8
 83a:	4681                	li	a3,0
 83c:	4629                	li	a2,10
 83e:	000bb583          	ld	a1,0(s7)
 842:	855a                	mv	a0,s6
 844:	dc9ff0ef          	jal	60c <printint>
        i += 1;
 848:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 84a:	8bca                	mv	s7,s2
      state = 0;
 84c:	4981                	li	s3,0
        i += 1;
 84e:	b555                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 850:	008b8913          	addi	s2,s7,8
 854:	4681                	li	a3,0
 856:	4629                	li	a2,10
 858:	000bb583          	ld	a1,0(s7)
 85c:	855a                	mv	a0,s6
 85e:	dafff0ef          	jal	60c <printint>
        i += 2;
 862:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 864:	8bca                	mv	s7,s2
      state = 0;
 866:	4981                	li	s3,0
        i += 2;
 868:	b569                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 86a:	008b8913          	addi	s2,s7,8
 86e:	4681                	li	a3,0
 870:	4641                	li	a2,16
 872:	000be583          	lwu	a1,0(s7)
 876:	855a                	mv	a0,s6
 878:	d95ff0ef          	jal	60c <printint>
 87c:	8bca                	mv	s7,s2
      state = 0;
 87e:	4981                	li	s3,0
 880:	bd8d                	j	6f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 882:	008b8913          	addi	s2,s7,8
 886:	4681                	li	a3,0
 888:	4641                	li	a2,16
 88a:	000bb583          	ld	a1,0(s7)
 88e:	855a                	mv	a0,s6
 890:	d7dff0ef          	jal	60c <printint>
        i += 1;
 894:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 896:	8bca                	mv	s7,s2
      state = 0;
 898:	4981                	li	s3,0
        i += 1;
 89a:	bda1                	j	6f2 <vprintf+0x4a>
 89c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 89e:	008b8d13          	addi	s10,s7,8
 8a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8a6:	03000593          	li	a1,48
 8aa:	855a                	mv	a0,s6
 8ac:	d43ff0ef          	jal	5ee <putc>
  putc(fd, 'x');
 8b0:	07800593          	li	a1,120
 8b4:	855a                	mv	a0,s6
 8b6:	d39ff0ef          	jal	5ee <putc>
 8ba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8bc:	00000b97          	auipc	s7,0x0
 8c0:	654b8b93          	addi	s7,s7,1620 # f10 <digits>
 8c4:	03c9d793          	srli	a5,s3,0x3c
 8c8:	97de                	add	a5,a5,s7
 8ca:	0007c583          	lbu	a1,0(a5)
 8ce:	855a                	mv	a0,s6
 8d0:	d1fff0ef          	jal	5ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8d4:	0992                	slli	s3,s3,0x4
 8d6:	397d                	addiw	s2,s2,-1
 8d8:	fe0916e3          	bnez	s2,8c4 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 8dc:	8bea                	mv	s7,s10
      state = 0;
 8de:	4981                	li	s3,0
 8e0:	6d02                	ld	s10,0(sp)
 8e2:	bd01                	j	6f2 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8e4:	008b8913          	addi	s2,s7,8
 8e8:	000bc583          	lbu	a1,0(s7)
 8ec:	855a                	mv	a0,s6
 8ee:	d01ff0ef          	jal	5ee <putc>
 8f2:	8bca                	mv	s7,s2
      state = 0;
 8f4:	4981                	li	s3,0
 8f6:	bbf5                	j	6f2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8f8:	008b8993          	addi	s3,s7,8
 8fc:	000bb903          	ld	s2,0(s7)
 900:	00090f63          	beqz	s2,91e <vprintf+0x276>
        for(; *s; s++)
 904:	00094583          	lbu	a1,0(s2)
 908:	c195                	beqz	a1,92c <vprintf+0x284>
          putc(fd, *s);
 90a:	855a                	mv	a0,s6
 90c:	ce3ff0ef          	jal	5ee <putc>
        for(; *s; s++)
 910:	0905                	addi	s2,s2,1
 912:	00094583          	lbu	a1,0(s2)
 916:	f9f5                	bnez	a1,90a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 918:	8bce                	mv	s7,s3
      state = 0;
 91a:	4981                	li	s3,0
 91c:	bbd9                	j	6f2 <vprintf+0x4a>
          s = "(null)";
 91e:	00000917          	auipc	s2,0x0
 922:	5ea90913          	addi	s2,s2,1514 # f08 <malloc+0x4de>
        for(; *s; s++)
 926:	02800593          	li	a1,40
 92a:	b7c5                	j	90a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 92c:	8bce                	mv	s7,s3
      state = 0;
 92e:	4981                	li	s3,0
 930:	b3c9                	j	6f2 <vprintf+0x4a>
 932:	64a6                	ld	s1,72(sp)
 934:	79e2                	ld	s3,56(sp)
 936:	7a42                	ld	s4,48(sp)
 938:	7aa2                	ld	s5,40(sp)
 93a:	7b02                	ld	s6,32(sp)
 93c:	6be2                	ld	s7,24(sp)
 93e:	6c42                	ld	s8,16(sp)
 940:	6ca2                	ld	s9,8(sp)
    }
  }
}
 942:	60e6                	ld	ra,88(sp)
 944:	6446                	ld	s0,80(sp)
 946:	6906                	ld	s2,64(sp)
 948:	6125                	addi	sp,sp,96
 94a:	8082                	ret

000000000000094c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 94c:	715d                	addi	sp,sp,-80
 94e:	ec06                	sd	ra,24(sp)
 950:	e822                	sd	s0,16(sp)
 952:	1000                	addi	s0,sp,32
 954:	e010                	sd	a2,0(s0)
 956:	e414                	sd	a3,8(s0)
 958:	e818                	sd	a4,16(s0)
 95a:	ec1c                	sd	a5,24(s0)
 95c:	03043023          	sd	a6,32(s0)
 960:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 964:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 968:	8622                	mv	a2,s0
 96a:	d3fff0ef          	jal	6a8 <vprintf>
}
 96e:	60e2                	ld	ra,24(sp)
 970:	6442                	ld	s0,16(sp)
 972:	6161                	addi	sp,sp,80
 974:	8082                	ret

0000000000000976 <printf>:

void
printf(const char *fmt, ...)
{
 976:	711d                	addi	sp,sp,-96
 978:	ec06                	sd	ra,24(sp)
 97a:	e822                	sd	s0,16(sp)
 97c:	1000                	addi	s0,sp,32
 97e:	e40c                	sd	a1,8(s0)
 980:	e810                	sd	a2,16(s0)
 982:	ec14                	sd	a3,24(s0)
 984:	f018                	sd	a4,32(s0)
 986:	f41c                	sd	a5,40(s0)
 988:	03043823          	sd	a6,48(s0)
 98c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 990:	00840613          	addi	a2,s0,8
 994:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 998:	85aa                	mv	a1,a0
 99a:	4505                	li	a0,1
 99c:	d0dff0ef          	jal	6a8 <vprintf>
}
 9a0:	60e2                	ld	ra,24(sp)
 9a2:	6442                	ld	s0,16(sp)
 9a4:	6125                	addi	sp,sp,96
 9a6:	8082                	ret

00000000000009a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9a8:	1141                	addi	sp,sp,-16
 9aa:	e422                	sd	s0,8(sp)
 9ac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9ae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b2:	00000797          	auipc	a5,0x0
 9b6:	64e7b783          	ld	a5,1614(a5) # 1000 <freep>
 9ba:	a02d                	j	9e4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9bc:	4618                	lw	a4,8(a2)
 9be:	9f2d                	addw	a4,a4,a1
 9c0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9c4:	6398                	ld	a4,0(a5)
 9c6:	6310                	ld	a2,0(a4)
 9c8:	a83d                	j	a06 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9ca:	ff852703          	lw	a4,-8(a0)
 9ce:	9f31                	addw	a4,a4,a2
 9d0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9d2:	ff053683          	ld	a3,-16(a0)
 9d6:	a091                	j	a1a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d8:	6398                	ld	a4,0(a5)
 9da:	00e7e463          	bltu	a5,a4,9e2 <free+0x3a>
 9de:	00e6ea63          	bltu	a3,a4,9f2 <free+0x4a>
{
 9e2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e4:	fed7fae3          	bgeu	a5,a3,9d8 <free+0x30>
 9e8:	6398                	ld	a4,0(a5)
 9ea:	00e6e463          	bltu	a3,a4,9f2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ee:	fee7eae3          	bltu	a5,a4,9e2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9f2:	ff852583          	lw	a1,-8(a0)
 9f6:	6390                	ld	a2,0(a5)
 9f8:	02059813          	slli	a6,a1,0x20
 9fc:	01c85713          	srli	a4,a6,0x1c
 a00:	9736                	add	a4,a4,a3
 a02:	fae60de3          	beq	a2,a4,9bc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a06:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a0a:	4790                	lw	a2,8(a5)
 a0c:	02061593          	slli	a1,a2,0x20
 a10:	01c5d713          	srli	a4,a1,0x1c
 a14:	973e                	add	a4,a4,a5
 a16:	fae68ae3          	beq	a3,a4,9ca <free+0x22>
    p->s.ptr = bp->s.ptr;
 a1a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a1c:	00000717          	auipc	a4,0x0
 a20:	5ef73223          	sd	a5,1508(a4) # 1000 <freep>
}
 a24:	6422                	ld	s0,8(sp)
 a26:	0141                	addi	sp,sp,16
 a28:	8082                	ret

0000000000000a2a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a2a:	7139                	addi	sp,sp,-64
 a2c:	fc06                	sd	ra,56(sp)
 a2e:	f822                	sd	s0,48(sp)
 a30:	f426                	sd	s1,40(sp)
 a32:	ec4e                	sd	s3,24(sp)
 a34:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a36:	02051493          	slli	s1,a0,0x20
 a3a:	9081                	srli	s1,s1,0x20
 a3c:	04bd                	addi	s1,s1,15
 a3e:	8091                	srli	s1,s1,0x4
 a40:	0014899b          	addiw	s3,s1,1
 a44:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a46:	00000517          	auipc	a0,0x0
 a4a:	5ba53503          	ld	a0,1466(a0) # 1000 <freep>
 a4e:	c915                	beqz	a0,a82 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a50:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a52:	4798                	lw	a4,8(a5)
 a54:	08977a63          	bgeu	a4,s1,ae8 <malloc+0xbe>
 a58:	f04a                	sd	s2,32(sp)
 a5a:	e852                	sd	s4,16(sp)
 a5c:	e456                	sd	s5,8(sp)
 a5e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a60:	8a4e                	mv	s4,s3
 a62:	0009871b          	sext.w	a4,s3
 a66:	6685                	lui	a3,0x1
 a68:	00d77363          	bgeu	a4,a3,a6e <malloc+0x44>
 a6c:	6a05                	lui	s4,0x1
 a6e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a72:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a76:	00000917          	auipc	s2,0x0
 a7a:	58a90913          	addi	s2,s2,1418 # 1000 <freep>
  if(p == SBRK_ERROR)
 a7e:	5afd                	li	s5,-1
 a80:	a081                	j	ac0 <malloc+0x96>
 a82:	f04a                	sd	s2,32(sp)
 a84:	e852                	sd	s4,16(sp)
 a86:	e456                	sd	s5,8(sp)
 a88:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a8a:	00000797          	auipc	a5,0x0
 a8e:	58678793          	addi	a5,a5,1414 # 1010 <base>
 a92:	00000717          	auipc	a4,0x0
 a96:	56f73723          	sd	a5,1390(a4) # 1000 <freep>
 a9a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a9c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aa0:	b7c1                	j	a60 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 aa2:	6398                	ld	a4,0(a5)
 aa4:	e118                	sd	a4,0(a0)
 aa6:	a8a9                	j	b00 <malloc+0xd6>
  hp->s.size = nu;
 aa8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 aac:	0541                	addi	a0,a0,16
 aae:	efbff0ef          	jal	9a8 <free>
  return freep;
 ab2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ab6:	c12d                	beqz	a0,b18 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aba:	4798                	lw	a4,8(a5)
 abc:	02977263          	bgeu	a4,s1,ae0 <malloc+0xb6>
    if(p == freep)
 ac0:	00093703          	ld	a4,0(s2)
 ac4:	853e                	mv	a0,a5
 ac6:	fef719e3          	bne	a4,a5,ab8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 aca:	8552                	mv	a0,s4
 acc:	a47ff0ef          	jal	512 <sbrk>
  if(p == SBRK_ERROR)
 ad0:	fd551ce3          	bne	a0,s5,aa8 <malloc+0x7e>
        return 0;
 ad4:	4501                	li	a0,0
 ad6:	7902                	ld	s2,32(sp)
 ad8:	6a42                	ld	s4,16(sp)
 ada:	6aa2                	ld	s5,8(sp)
 adc:	6b02                	ld	s6,0(sp)
 ade:	a03d                	j	b0c <malloc+0xe2>
 ae0:	7902                	ld	s2,32(sp)
 ae2:	6a42                	ld	s4,16(sp)
 ae4:	6aa2                	ld	s5,8(sp)
 ae6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ae8:	fae48de3          	beq	s1,a4,aa2 <malloc+0x78>
        p->s.size -= nunits;
 aec:	4137073b          	subw	a4,a4,s3
 af0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 af2:	02071693          	slli	a3,a4,0x20
 af6:	01c6d713          	srli	a4,a3,0x1c
 afa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 afc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b00:	00000717          	auipc	a4,0x0
 b04:	50a73023          	sd	a0,1280(a4) # 1000 <freep>
      return (void*)(p + 1);
 b08:	01078513          	addi	a0,a5,16
  }
}
 b0c:	70e2                	ld	ra,56(sp)
 b0e:	7442                	ld	s0,48(sp)
 b10:	74a2                	ld	s1,40(sp)
 b12:	69e2                	ld	s3,24(sp)
 b14:	6121                	addi	sp,sp,64
 b16:	8082                	ret
 b18:	7902                	ld	s2,32(sp)
 b1a:	6a42                	ld	s4,16(sp)
 b1c:	6aa2                	ld	s5,8(sp)
 b1e:	6b02                	ld	s6,0(sp)
 b20:	b7f5                	j	b0c <malloc+0xe2>
