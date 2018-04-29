
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 2e 10 80       	mov    $0x80102e80,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 73 10 80       	push   $0x801073c0
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 a5 45 00 00       	call   80104600 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 73 10 80       	push   $0x801073c7
80100097:	50                   	push   %eax
80100098:	e8 53 44 00 00       	call   801044f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 37 45 00 00       	call   80104620 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 99 46 00 00       	call   80104800 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 43 00 00       	call   80104530 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 0d 1f 00 00       	call   80102090 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 73 10 80       	push   $0x801073ce
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 44 00 00       	call   801045d0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 c7 1e 00 00       	jmp    80102090 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 73 10 80       	push   $0x801073df
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 43 00 00       	call   801045d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 43 00 00       	call   80104590 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 10 44 00 00       	call   80104620 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 9f 45 00 00       	jmp    80104800 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 73 10 80       	push   $0x801073e6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 7b 14 00 00       	call   80101700 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 8f 43 00 00       	call   80104620 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002a6:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 c0 ff 10 80       	push   $0x8010ffc0
801002bd:	e8 ce 3a 00 00       	call   80103d90 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(proc->killed){
801002d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002d8:	8b 40 24             	mov    0x24(%eax),%eax
801002db:	85 c0                	test   %eax,%eax
801002dd:	74 d1                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002df:	83 ec 0c             	sub    $0xc,%esp
801002e2:	68 20 a5 10 80       	push   $0x8010a520
801002e7:	e8 14 45 00 00       	call   80104800 <release>
        ilock(ip);
801002ec:	89 3c 24             	mov    %edi,(%esp)
801002ef:	e8 2c 13 00 00       	call   80101620 <ilock>
        return -1;
801002f4:	83 c4 10             	add    $0x10,%esp
801002f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002ff:	5b                   	pop    %ebx
80100300:	5e                   	pop    %esi
80100301:	5f                   	pop    %edi
80100302:	5d                   	pop    %ebp
80100303:	c3                   	ret    
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 40 ff 10 80 	movsbl -0x7fef00c0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 b5 44 00 00       	call   80104800 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 cd 12 00 00       	call   80101620 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a1                	jmp    801002fc <consoleread+0x8c>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 38             	sub    $0x38,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100379:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
8010037f:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100386:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100389:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010038c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010038f:	0f b6 00             	movzbl (%eax),%eax
80100392:	50                   	push   %eax
80100393:	68 ed 73 10 80       	push   $0x801073ed
80100398:	e8 c3 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039d:	58                   	pop    %eax
8010039e:	ff 75 08             	pushl  0x8(%ebp)
801003a1:	e8 ba 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a6:	c7 04 24 2f 7d 10 80 	movl   $0x80107d2f,(%esp)
801003ad:	e8 ae 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b2:	5a                   	pop    %edx
801003b3:	8d 45 08             	lea    0x8(%ebp),%eax
801003b6:	59                   	pop    %ecx
801003b7:	53                   	push   %ebx
801003b8:	50                   	push   %eax
801003b9:	e8 32 43 00 00       	call   801046f0 <getcallerpcs>
801003be:	83 c4 10             	add    $0x10,%esp
801003c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c8:	83 ec 08             	sub    $0x8,%esp
801003cb:	ff 33                	pushl  (%ebx)
801003cd:	83 c3 04             	add    $0x4,%ebx
801003d0:	68 09 74 10 80       	push   $0x80107409
801003d5:	e8 86 02 00 00       	call   80100660 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003da:	83 c4 10             	add    $0x10,%esp
801003dd:	39 f3                	cmp    %esi,%ebx
801003df:	75 e7                	jne    801003c8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003e1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e8:	00 00 00 
801003eb:	eb fe                	jmp    801003eb <panic+0x7b>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 51 5b 00 00       	call   80105f70 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 98 5a 00 00       	call   80105f70 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 8c 5a 00 00       	call   80105f70 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 80 5a 00 00       	call   80105f70 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 e7 43 00 00       	call   80104900 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 22 43 00 00       	call   80104850 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 0d 74 10 80       	push   $0x8010740d
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 38 74 10 80 	movzbl -0x7fef8bc8(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 ec 10 00 00       	call   80101700 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 00 40 00 00       	call   80104620 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 b4 41 00 00       	call   80104800 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 cb 0f 00 00       	call   80101620 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 ee 40 00 00       	call   80104800 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 20 74 10 80       	mov    $0x80107420,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 53 3e 00 00       	call   80104620 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 27 74 10 80       	push   $0x80107427
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 18 3e 00 00       	call   80104620 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100836:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 93 3f 00 00       	call   80104800 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
801008f1:	68 c0 ff 10 80       	push   $0x8010ffc0
801008f6:	e8 35 36 00 00       	call   80103f30 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010090d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100934:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 a4 36 00 00       	jmp    80104020 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 30 74 10 80       	push   $0x80107430
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 4b 3c 00 00       	call   80104600 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
801009b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bc:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009c3:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c6:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009cd:	02 10 80 
  cons.locking = 1;
801009d0:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d7:	00 00 00 

  picenable(IRQ_KBD);
801009da:	e8 51 28 00 00       	call   80103230 <picenable>
  ioapicenable(IRQ_KBD, 0);
801009df:	58                   	pop    %eax
801009e0:	5a                   	pop    %edx
801009e1:	6a 00                	push   $0x0
801009e3:	6a 01                	push   $0x1
801009e5:	e8 66 18 00 00       	call   80102250 <ioapicenable>
}
801009ea:	83 c4 10             	add    $0x10,%esp
801009ed:	c9                   	leave  
801009ee:	c3                   	ret    
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009fc:	e8 7f 21 00 00       	call   80102b80 <begin_op>

  if((ip = namei(path)) == 0){
80100a01:	83 ec 0c             	sub    $0xc,%esp
80100a04:	ff 75 08             	pushl  0x8(%ebp)
80100a07:	e8 44 14 00 00       	call   80101e50 <namei>
80100a0c:	83 c4 10             	add    $0x10,%esp
80100a0f:	85 c0                	test   %eax,%eax
80100a11:	0f 84 9f 01 00 00    	je     80100bb6 <exec+0x1c6>
    end_op();
    return -1;
  }
  ilock(ip);
80100a17:	83 ec 0c             	sub    $0xc,%esp
80100a1a:	89 c3                	mov    %eax,%ebx
80100a1c:	50                   	push   %eax
80100a1d:	e8 fe 0b 00 00       	call   80101620 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a22:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a28:	6a 34                	push   $0x34
80100a2a:	6a 00                	push   $0x0
80100a2c:	50                   	push   %eax
80100a2d:	53                   	push   %ebx
80100a2e:	e8 ad 0e 00 00       	call   801018e0 <readi>
80100a33:	83 c4 20             	add    $0x20,%esp
80100a36:	83 f8 34             	cmp    $0x34,%eax
80100a39:	74 25                	je     80100a60 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a3b:	83 ec 0c             	sub    $0xc,%esp
80100a3e:	53                   	push   %ebx
80100a3f:	e8 4c 0e 00 00       	call   80101890 <iunlockput>
    end_op();
80100a44:	e8 a7 21 00 00       	call   80102bf0 <end_op>
80100a49:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a54:	5b                   	pop    %ebx
80100a55:	5e                   	pop    %esi
80100a56:	5f                   	pop    %edi
80100a57:	5d                   	pop    %ebp
80100a58:	c3                   	ret    
80100a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a67:	45 4c 46 
80100a6a:	75 cf                	jne    80100a3b <exec+0x4b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a6c:	e8 df 62 00 00       	call   80106d50 <setupkvm>
80100a71:	85 c0                	test   %eax,%eax
80100a73:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a79:	74 c0                	je     80100a3b <exec+0x4b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a7b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a82:	00 
80100a83:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a89:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a90:	00 00 00 
80100a93:	0f 84 c5 00 00 00    	je     80100b5e <exec+0x16e>
80100a99:	31 ff                	xor    %edi,%edi
80100a9b:	eb 18                	jmp    80100ab5 <exec+0xc5>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
80100aa0:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aa7:	83 c7 01             	add    $0x1,%edi
80100aaa:	83 c6 20             	add    $0x20,%esi
80100aad:	39 f8                	cmp    %edi,%eax
80100aaf:	0f 8e a9 00 00 00    	jle    80100b5e <exec+0x16e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ab5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100abb:	6a 20                	push   $0x20
80100abd:	56                   	push   %esi
80100abe:	50                   	push   %eax
80100abf:	53                   	push   %ebx
80100ac0:	e8 1b 0e 00 00       	call   801018e0 <readi>
80100ac5:	83 c4 10             	add    $0x10,%esp
80100ac8:	83 f8 20             	cmp    $0x20,%eax
80100acb:	75 7b                	jne    80100b48 <exec+0x158>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100acd:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ad4:	75 ca                	jne    80100aa0 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100ad6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100adc:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ae2:	72 64                	jb     80100b48 <exec+0x158>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ae4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100aea:	72 5c                	jb     80100b48 <exec+0x158>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aec:	83 ec 04             	sub    $0x4,%esp
80100aef:	50                   	push   %eax
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100afc:	e8 0f 65 00 00       	call   80107010 <allocuvm>
80100b01:	83 c4 10             	add    $0x10,%esp
80100b04:	85 c0                	test   %eax,%eax
80100b06:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b0c:	74 3a                	je     80100b48 <exec+0x158>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b0e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b14:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b19:	75 2d                	jne    80100b48 <exec+0x158>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b1b:	83 ec 0c             	sub    $0xc,%esp
80100b1e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b24:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b2a:	53                   	push   %ebx
80100b2b:	50                   	push   %eax
80100b2c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b32:	e8 19 64 00 00       	call   80106f50 <loaduvm>
80100b37:	83 c4 20             	add    $0x20,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 89 5e ff ff ff    	jns    80100aa0 <exec+0xb0>
80100b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b48:	83 ec 0c             	sub    $0xc,%esp
80100b4b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b51:	e8 ea 65 00 00       	call   80107140 <freevm>
80100b56:	83 c4 10             	add    $0x10,%esp
80100b59:	e9 dd fe ff ff       	jmp    80100a3b <exec+0x4b>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b5e:	83 ec 0c             	sub    $0xc,%esp
80100b61:	53                   	push   %ebx
80100b62:	e8 29 0d 00 00       	call   80101890 <iunlockput>
  end_op();
80100b67:	e8 84 20 00 00       	call   80102bf0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b6c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b72:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b75:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7f:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b85:	52                   	push   %edx
80100b86:	50                   	push   %eax
80100b87:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b8d:	e8 7e 64 00 00       	call   80107010 <allocuvm>
80100b92:	83 c4 10             	add    $0x10,%esp
80100b95:	85 c0                	test   %eax,%eax
80100b97:	89 c6                	mov    %eax,%esi
80100b99:	75 2a                	jne    80100bc5 <exec+0x1d5>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b9b:	83 ec 0c             	sub    $0xc,%esp
80100b9e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba4:	e8 97 65 00 00       	call   80107140 <freevm>
80100ba9:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb1:	e9 9b fe ff ff       	jmp    80100a51 <exec+0x61>
  pde_t *pgdir, *oldpgdir;

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bb6:	e8 35 20 00 00       	call   80102bf0 <end_op>
    return -1;
80100bbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bc0:	e9 8c fe ff ff       	jmp    80100a51 <exec+0x61>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bc5:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bcb:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bce:	31 ff                	xor    %edi,%edi
80100bd0:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bd9:	e8 e2 65 00 00       	call   801071c0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bde:	8b 45 0c             	mov    0xc(%ebp),%eax
80100be1:	83 c4 10             	add    $0x10,%esp
80100be4:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bea:	8b 00                	mov    (%eax),%eax
80100bec:	85 c0                	test   %eax,%eax
80100bee:	74 6d                	je     80100c5d <exec+0x26d>
80100bf0:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100bf6:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100bfc:	eb 07                	jmp    80100c05 <exec+0x215>
80100bfe:	66 90                	xchg   %ax,%ax
    if(argc >= MAXARG)
80100c00:	83 ff 20             	cmp    $0x20,%edi
80100c03:	74 96                	je     80100b9b <exec+0x1ab>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c05:	83 ec 0c             	sub    $0xc,%esp
80100c08:	50                   	push   %eax
80100c09:	e8 82 3e 00 00       	call   80104a90 <strlen>
80100c0e:	f7 d0                	not    %eax
80100c10:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c12:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c15:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c16:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c19:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c1c:	e8 6f 3e 00 00       	call   80104a90 <strlen>
80100c21:	83 c0 01             	add    $0x1,%eax
80100c24:	50                   	push   %eax
80100c25:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c28:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c2b:	53                   	push   %ebx
80100c2c:	56                   	push   %esi
80100c2d:	e8 ee 66 00 00       	call   80107320 <copyout>
80100c32:	83 c4 20             	add    $0x20,%esp
80100c35:	85 c0                	test   %eax,%eax
80100c37:	0f 88 5e ff ff ff    	js     80100b9b <exec+0x1ab>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c40:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c47:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c4a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c50:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c53:	85 c0                	test   %eax,%eax
80100c55:	75 a9                	jne    80100c00 <exec+0x210>
80100c57:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c5d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c64:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c66:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c6d:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c71:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c78:	ff ff ff 
  ustack[1] = argc;
80100c7b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c83:	83 c0 0c             	add    $0xc,%eax
80100c86:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c88:	50                   	push   %eax
80100c89:	52                   	push   %edx
80100c8a:	53                   	push   %ebx
80100c8b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c91:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c97:	e8 84 66 00 00       	call   80107320 <copyout>
80100c9c:	83 c4 10             	add    $0x10,%esp
80100c9f:	85 c0                	test   %eax,%eax
80100ca1:	0f 88 f4 fe ff ff    	js     80100b9b <exec+0x1ab>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80100caa:	0f b6 10             	movzbl (%eax),%edx
80100cad:	84 d2                	test   %dl,%dl
80100caf:	74 19                	je     80100cca <exec+0x2da>
80100cb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cb4:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cb7:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cba:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cbd:	0f 44 c8             	cmove  %eax,%ecx
80100cc0:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc3:	84 d2                	test   %dl,%dl
80100cc5:	75 f0                	jne    80100cb7 <exec+0x2c7>
80100cc7:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cca:	50                   	push   %eax
80100ccb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cd1:	6a 10                	push   $0x10
80100cd3:	ff 75 08             	pushl  0x8(%ebp)
80100cd6:	83 c0 70             	add    $0x70,%eax
80100cd9:	50                   	push   %eax
80100cda:	e8 71 3d 00 00       	call   80104a50 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cdf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100ce5:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ceb:	8b 78 04             	mov    0x4(%eax),%edi
  proc->pgdir = pgdir;
  proc->sz = sz;
80100cee:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
80100cf0:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
  proc->tf->eip = elf.entry;  // main
80100cf3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cf9:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100cff:	8b 50 18             	mov    0x18(%eax),%edx
80100d02:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d05:	8b 50 18             	mov    0x18(%eax),%edx
80100d08:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d0b:	89 04 24             	mov    %eax,(%esp)
80100d0e:	e8 ed 60 00 00       	call   80106e00 <switchuvm>
  freevm(oldpgdir);
80100d13:	89 3c 24             	mov    %edi,(%esp)
80100d16:	e8 25 64 00 00       	call   80107140 <freevm>
  return 0;
80100d1b:	83 c4 10             	add    $0x10,%esp
80100d1e:	31 c0                	xor    %eax,%eax
80100d20:	e9 2c fd ff ff       	jmp    80100a51 <exec+0x61>
80100d25:	66 90                	xchg   %ax,%ax
80100d27:	66 90                	xchg   %ax,%ax
80100d29:	66 90                	xchg   %ax,%ax
80100d2b:	66 90                	xchg   %ax,%ax
80100d2d:	66 90                	xchg   %ax,%ax
80100d2f:	90                   	nop

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d36:	68 49 74 10 80       	push   $0x80107449
80100d3b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d40:	e8 bb 38 00 00       	call   80104600 <initlock>
}
80100d45:	83 c4 10             	add    $0x10,%esp
80100d48:	c9                   	leave  
80100d49:	c3                   	ret    
80100d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb 14 00 11 80       	mov    $0x80110014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d59:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d5c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d61:	e8 ba 38 00 00       	call   80104620 <acquire>
80100d66:	83 c4 10             	add    $0x10,%esp
80100d69:	eb 10                	jmp    80100d7b <filealloc+0x2b>
80100d6b:	90                   	nop
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100d79:	74 25                	je     80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d82:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d8c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d91:	e8 6a 3a 00 00       	call   80104800 <release>
      return f;
80100d96:	89 d8                	mov    %ebx,%eax
80100d98:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d9e:	c9                   	leave  
80100d9f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100da0:	83 ec 0c             	sub    $0xc,%esp
80100da3:	68 e0 ff 10 80       	push   $0x8010ffe0
80100da8:	e8 53 3a 00 00       	call   80104800 <release>
  return 0;
80100dad:	83 c4 10             	add    $0x10,%esp
80100db0:	31 c0                	xor    %eax,%eax
}
80100db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100db5:	c9                   	leave  
80100db6:	c3                   	ret    
80100db7:	89 f6                	mov    %esi,%esi
80100db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 10             	sub    $0x10,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dcf:	e8 4c 38 00 00       	call   80104620 <acquire>
  if(f->ref < 1)
80100dd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	85 c0                	test   %eax,%eax
80100ddc:	7e 1a                	jle    80100df8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100de1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100de4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de7:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dec:	e8 0f 3a 00 00       	call   80104800 <release>
  return f;
}
80100df1:	89 d8                	mov    %ebx,%eax
80100df3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df6:	c9                   	leave  
80100df7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100df8:	83 ec 0c             	sub    $0xc,%esp
80100dfb:	68 50 74 10 80       	push   $0x80107450
80100e00:	e8 6b f5 ff ff       	call   80100370 <panic>
80100e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	57                   	push   %edi
80100e14:	56                   	push   %esi
80100e15:	53                   	push   %ebx
80100e16:	83 ec 28             	sub    $0x28,%esp
80100e19:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e21:	e8 fa 37 00 00       	call   80104620 <acquire>
  if(f->ref < 1)
80100e26:	8b 47 04             	mov    0x4(%edi),%eax
80100e29:	83 c4 10             	add    $0x10,%esp
80100e2c:	85 c0                	test   %eax,%eax
80100e2e:	0f 8e 9b 00 00 00    	jle    80100ecf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e34:	83 e8 01             	sub    $0x1,%eax
80100e37:	85 c0                	test   %eax,%eax
80100e39:	89 47 04             	mov    %eax,0x4(%edi)
80100e3c:	74 1a                	je     80100e58 <fileclose+0x48>
    release(&ftable.lock);
80100e3e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e48:	5b                   	pop    %ebx
80100e49:	5e                   	pop    %esi
80100e4a:	5f                   	pop    %edi
80100e4b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e4c:	e9 af 39 00 00       	jmp    80104800 <release>
80100e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e58:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e5c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e5e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e61:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e64:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e6d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e70:	68 e0 ff 10 80       	push   $0x8010ffe0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e78:	e8 83 39 00 00       	call   80104800 <release>

  if(ff.type == FD_PIPE)
80100e7d:	83 c4 10             	add    $0x10,%esp
80100e80:	83 fb 01             	cmp    $0x1,%ebx
80100e83:	74 13                	je     80100e98 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e85:	83 fb 02             	cmp    $0x2,%ebx
80100e88:	74 26                	je     80100eb0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e8d:	5b                   	pop    %ebx
80100e8e:	5e                   	pop    %esi
80100e8f:	5f                   	pop    %edi
80100e90:	5d                   	pop    %ebp
80100e91:	c3                   	ret    
80100e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100e9c:	83 ec 08             	sub    $0x8,%esp
80100e9f:	53                   	push   %ebx
80100ea0:	56                   	push   %esi
80100ea1:	e8 5a 25 00 00       	call   80103400 <pipeclose>
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	eb df                	jmp    80100e8a <fileclose+0x7a>
80100eab:	90                   	nop
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100eb0:	e8 cb 1c 00 00       	call   80102b80 <begin_op>
    iput(ff.ip);
80100eb5:	83 ec 0c             	sub    $0xc,%esp
80100eb8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ebb:	e8 90 08 00 00       	call   80101750 <iput>
    end_op();
80100ec0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ec6:	5b                   	pop    %ebx
80100ec7:	5e                   	pop    %esi
80100ec8:	5f                   	pop    %edi
80100ec9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eca:	e9 21 1d 00 00       	jmp    80102bf0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ecf:	83 ec 0c             	sub    $0xc,%esp
80100ed2:	68 58 74 10 80       	push   $0x80107458
80100ed7:	e8 94 f4 ff ff       	call   80100370 <panic>
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 04             	sub    $0x4,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	ff 73 10             	pushl  0x10(%ebx)
80100ef5:	e8 26 07 00 00       	call   80101620 <ilock>
    stati(f->ip, st);
80100efa:	58                   	pop    %eax
80100efb:	5a                   	pop    %edx
80100efc:	ff 75 0c             	pushl  0xc(%ebp)
80100eff:	ff 73 10             	pushl  0x10(%ebx)
80100f02:	e8 a9 09 00 00       	call   801018b0 <stati>
    iunlock(f->ip);
80100f07:	59                   	pop    %ecx
80100f08:	ff 73 10             	pushl  0x10(%ebx)
80100f0b:	e8 f0 07 00 00       	call   80101700 <iunlock>
    return 0;
80100f10:	83 c4 10             	add    $0x10,%esp
80100f13:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f18:	c9                   	leave  
80100f19:	c3                   	ret    
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f28:	c9                   	leave  
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f30 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 0c             	sub    $0xc,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 60                	je     80100fa8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 41                	je     80100f90 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 5b                	jne    80100faf <fileread+0x7f>
    ilock(f->ip);
80100f54:	83 ec 0c             	sub    $0xc,%esp
80100f57:	ff 73 10             	pushl  0x10(%ebx)
80100f5a:	e8 c1 06 00 00       	call   80101620 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	57                   	push   %edi
80100f60:	ff 73 14             	pushl  0x14(%ebx)
80100f63:	56                   	push   %esi
80100f64:	ff 73 10             	pushl  0x10(%ebx)
80100f67:	e8 74 09 00 00       	call   801018e0 <readi>
80100f6c:	83 c4 20             	add    $0x20,%esp
80100f6f:	85 c0                	test   %eax,%eax
80100f71:	89 c6                	mov    %eax,%esi
80100f73:	7e 03                	jle    80100f78 <fileread+0x48>
      f->off += r;
80100f75:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f78:	83 ec 0c             	sub    $0xc,%esp
80100f7b:	ff 73 10             	pushl  0x10(%ebx)
80100f7e:	e8 7d 07 00 00       	call   80101700 <iunlock>
    return r;
80100f83:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f86:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8b:	5b                   	pop    %ebx
80100f8c:	5e                   	pop    %esi
80100f8d:	5f                   	pop    %edi
80100f8e:	5d                   	pop    %ebp
80100f8f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f90:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f93:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f99:	5b                   	pop    %ebx
80100f9a:	5e                   	pop    %esi
80100f9b:	5f                   	pop    %edi
80100f9c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f9d:	e9 2e 26 00 00       	jmp    801035d0 <piperead>
80100fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fad:	eb d9                	jmp    80100f88 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	68 62 74 10 80       	push   $0x80107462
80100fb7:	e8 b4 f3 ff ff       	call   80100370 <panic>
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 1c             	sub    $0x1c,%esp
80100fc9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fcf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fd6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fdc:	0f 84 aa 00 00 00    	je     8010108c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100fe2:	8b 06                	mov    (%esi),%eax
80100fe4:	83 f8 01             	cmp    $0x1,%eax
80100fe7:	0f 84 c2 00 00 00    	je     801010af <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fed:	83 f8 02             	cmp    $0x2,%eax
80100ff0:	0f 85 d8 00 00 00    	jne    801010ce <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff9:	31 ff                	xor    %edi,%edi
80100ffb:	85 c0                	test   %eax,%eax
80100ffd:	7f 34                	jg     80101033 <filewrite+0x73>
80100fff:	e9 9c 00 00 00       	jmp    801010a0 <filewrite+0xe0>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101008:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010100b:	83 ec 0c             	sub    $0xc,%esp
8010100e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101011:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101014:	e8 e7 06 00 00       	call   80101700 <iunlock>
      end_op();
80101019:	e8 d2 1b 00 00       	call   80102bf0 <end_op>
8010101e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101021:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101024:	39 d8                	cmp    %ebx,%eax
80101026:	0f 85 95 00 00 00    	jne    801010c1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010102c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010102e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101031:	7e 6d                	jle    801010a0 <filewrite+0xe0>
      int n1 = n - i;
80101033:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101036:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010103b:	29 fb                	sub    %edi,%ebx
8010103d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101043:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101046:	e8 35 1b 00 00       	call   80102b80 <begin_op>
      ilock(f->ip);
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	ff 76 10             	pushl  0x10(%esi)
80101051:	e8 ca 05 00 00       	call   80101620 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101056:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101059:	53                   	push   %ebx
8010105a:	ff 76 14             	pushl  0x14(%esi)
8010105d:	01 f8                	add    %edi,%eax
8010105f:	50                   	push   %eax
80101060:	ff 76 10             	pushl  0x10(%esi)
80101063:	e8 78 09 00 00       	call   801019e0 <writei>
80101068:	83 c4 20             	add    $0x20,%esp
8010106b:	85 c0                	test   %eax,%eax
8010106d:	7f 99                	jg     80101008 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 76 10             	pushl  0x10(%esi)
80101075:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101078:	e8 83 06 00 00       	call   80101700 <iunlock>
      end_op();
8010107d:	e8 6e 1b 00 00       	call   80102bf0 <end_op>

      if(r < 0)
80101082:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101085:	83 c4 10             	add    $0x10,%esp
80101088:	85 c0                	test   %eax,%eax
8010108a:	74 98                	je     80101024 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010108f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101094:	5b                   	pop    %ebx
80101095:	5e                   	pop    %esi
80101096:	5f                   	pop    %edi
80101097:	5d                   	pop    %ebp
80101098:	c3                   	ret    
80101099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010a0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010a3:	75 e7                	jne    8010108c <filewrite+0xcc>
  }
  panic("filewrite");
}
801010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a8:	89 f8                	mov    %edi,%eax
801010aa:	5b                   	pop    %ebx
801010ab:	5e                   	pop    %esi
801010ac:	5f                   	pop    %edi
801010ad:	5d                   	pop    %ebp
801010ae:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010af:	8b 46 0c             	mov    0xc(%esi),%eax
801010b2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bc:	e9 df 23 00 00       	jmp    801034a0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010c1:	83 ec 0c             	sub    $0xc,%esp
801010c4:	68 6b 74 10 80       	push   $0x8010746b
801010c9:	e8 a2 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ce:	83 ec 0c             	sub    $0xc,%esp
801010d1:	68 71 74 10 80       	push   $0x80107471
801010d6:	e8 95 f2 ff ff       	call   80100370 <panic>
801010db:	66 90                	xchg   %ax,%ax
801010dd:	66 90                	xchg   %ax,%ax
801010df:	90                   	nop

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010e9:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010f2:	85 c9                	test   %ecx,%ecx
801010f4:	0f 84 85 00 00 00    	je     8010117f <balloc+0x9f>
801010fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101101:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101104:	83 ec 08             	sub    $0x8,%esp
80101107:	89 f0                	mov    %esi,%eax
80101109:	c1 f8 0c             	sar    $0xc,%eax
8010110c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101112:	50                   	push   %eax
80101113:	ff 75 d8             	pushl  -0x28(%ebp)
80101116:	e8 b5 ef ff ff       	call   801000d0 <bread>
8010111b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010111e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101123:	83 c4 10             	add    $0x10,%esp
80101126:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101129:	31 c0                	xor    %eax,%eax
8010112b:	eb 2d                	jmp    8010115a <balloc+0x7a>
8010112d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101130:	89 c1                	mov    %eax,%ecx
80101132:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101137:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010113a:	83 e1 07             	and    $0x7,%ecx
8010113d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010113f:	89 c1                	mov    %eax,%ecx
80101141:	c1 f9 03             	sar    $0x3,%ecx
80101144:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101149:	85 d7                	test   %edx,%edi
8010114b:	74 43                	je     80101190 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114d:	83 c0 01             	add    $0x1,%eax
80101150:	83 c6 01             	add    $0x1,%esi
80101153:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101158:	74 05                	je     8010115f <balloc+0x7f>
8010115a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010115d:	72 d1                	jb     80101130 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	ff 75 e4             	pushl  -0x1c(%ebp)
80101165:	e8 76 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010116a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101171:	83 c4 10             	add    $0x10,%esp
80101174:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101177:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
8010117d:	77 82                	ja     80101101 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	68 7b 74 10 80       	push   $0x8010747b
80101187:	e8 e4 f1 ff ff       	call   80100370 <panic>
8010118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101190:	09 fa                	or     %edi,%edx
80101192:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101195:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101198:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010119c:	57                   	push   %edi
8010119d:	e8 be 1b 00 00       	call   80102d60 <log_write>
        brelse(bp);
801011a2:	89 3c 24             	mov    %edi,(%esp)
801011a5:	e8 36 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011aa:	58                   	pop    %eax
801011ab:	5a                   	pop    %edx
801011ac:	56                   	push   %esi
801011ad:	ff 75 d8             	pushl  -0x28(%ebp)
801011b0:	e8 1b ef ff ff       	call   801000d0 <bread>
801011b5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ba:	83 c4 0c             	add    $0xc,%esp
801011bd:	68 00 02 00 00       	push   $0x200
801011c2:	6a 00                	push   $0x0
801011c4:	50                   	push   %eax
801011c5:	e8 86 36 00 00       	call   80104850 <memset>
  log_write(bp);
801011ca:	89 1c 24             	mov    %ebx,(%esp)
801011cd:	e8 8e 1b 00 00       	call   80102d60 <log_write>
  brelse(bp);
801011d2:	89 1c 24             	mov    %ebx,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011dd:	89 f0                	mov    %esi,%eax
801011df:	5b                   	pop    %ebx
801011e0:	5e                   	pop    %esi
801011e1:	5f                   	pop    %edi
801011e2:	5d                   	pop    %ebp
801011e3:	c3                   	ret    
801011e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801011f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011f8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011fa:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011ff:	83 ec 28             	sub    $0x28,%esp
80101202:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101205:	68 00 0a 11 80       	push   $0x80110a00
8010120a:	e8 11 34 00 00       	call   80104620 <acquire>
8010120f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101215:	eb 1b                	jmp    80101232 <iget+0x42>
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101220:	85 f6                	test   %esi,%esi
80101222:	74 44                	je     80101268 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101224:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010122a:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101230:	74 4e                	je     80101280 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101232:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101235:	85 c9                	test   %ecx,%ecx
80101237:	7e e7                	jle    80101220 <iget+0x30>
80101239:	39 3b                	cmp    %edi,(%ebx)
8010123b:	75 e3                	jne    80101220 <iget+0x30>
8010123d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101240:	75 de                	jne    80101220 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101242:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101245:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101248:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010124a:	68 00 0a 11 80       	push   $0x80110a00

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010124f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101252:	e8 a9 35 00 00       	call   80104800 <release>
      return ip;
80101257:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010125d:	89 f0                	mov    %esi,%eax
8010125f:	5b                   	pop    %ebx
80101260:	5e                   	pop    %esi
80101261:	5f                   	pop    %edi
80101262:	5d                   	pop    %ebp
80101263:	c3                   	ret    
80101264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101268:	85 c9                	test   %ecx,%ecx
8010126a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101273:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
80101279:	75 b7                	jne    80101232 <iget+0x42>
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 2d                	je     801012b1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 00 0a 11 80       	push   $0x80110a00
8010129f:	e8 5c 35 00 00       	call   80104800 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	68 91 74 10 80       	push   $0x80107491
801012b9:	e8 b2 f0 ff ff       	call   80100370 <panic>
801012be:	66 90                	xchg   %ax,%ax

801012c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c6                	mov    %eax,%esi
801012c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012cb:	83 fa 0b             	cmp    $0xb,%edx
801012ce:	77 18                	ja     801012e8 <bmap+0x28>
801012d0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012d3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012d6:	85 c0                	test   %eax,%eax
801012d8:	74 76                	je     80101350 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret    
801012e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012e8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801012eb:	83 fb 7f             	cmp    $0x7f,%ebx
801012ee:	0f 87 83 00 00 00    	ja     80101377 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012f4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012fa:	85 c0                	test   %eax,%eax
801012fc:	74 6a                	je     80101368 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012fe:	83 ec 08             	sub    $0x8,%esp
80101301:	50                   	push   %eax
80101302:	ff 36                	pushl  (%esi)
80101304:	e8 c7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101309:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010130d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101310:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101312:	8b 1a                	mov    (%edx),%ebx
80101314:	85 db                	test   %ebx,%ebx
80101316:	75 1d                	jne    80101335 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101318:	8b 06                	mov    (%esi),%eax
8010131a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010131d:	e8 be fd ff ff       	call   801010e0 <balloc>
80101322:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101325:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101328:	89 c3                	mov    %eax,%ebx
8010132a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010132c:	57                   	push   %edi
8010132d:	e8 2e 1a 00 00       	call   80102d60 <log_write>
80101332:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101335:	83 ec 0c             	sub    $0xc,%esp
80101338:	57                   	push   %edi
80101339:	e8 a2 ee ff ff       	call   801001e0 <brelse>
8010133e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101341:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101344:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101346:	5b                   	pop    %ebx
80101347:	5e                   	pop    %esi
80101348:	5f                   	pop    %edi
80101349:	5d                   	pop    %ebp
8010134a:	c3                   	ret    
8010134b:	90                   	nop
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101350:	8b 06                	mov    (%esi),%eax
80101352:	e8 89 fd ff ff       	call   801010e0 <balloc>
80101357:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135d:	5b                   	pop    %ebx
8010135e:	5e                   	pop    %esi
8010135f:	5f                   	pop    %edi
80101360:	5d                   	pop    %ebp
80101361:	c3                   	ret    
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101368:	8b 06                	mov    (%esi),%eax
8010136a:	e8 71 fd ff ff       	call   801010e0 <balloc>
8010136f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101375:	eb 87                	jmp    801012fe <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101377:	83 ec 0c             	sub    $0xc,%esp
8010137a:	68 a1 74 10 80       	push   $0x801074a1
8010137f:	e8 ec ef ff ff       	call   80100370 <panic>
80101384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010138a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101390 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	56                   	push   %esi
80101394:	53                   	push   %ebx
80101395:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101398:	83 ec 08             	sub    $0x8,%esp
8010139b:	6a 01                	push   $0x1
8010139d:	ff 75 08             	pushl  0x8(%ebp)
801013a0:	e8 2b ed ff ff       	call   801000d0 <bread>
801013a5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013aa:	83 c4 0c             	add    $0xc,%esp
801013ad:	6a 1c                	push   $0x1c
801013af:	50                   	push   %eax
801013b0:	56                   	push   %esi
801013b1:	e8 4a 35 00 00       	call   80104900 <memmove>
  brelse(bp);
801013b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013b9:	83 c4 10             	add    $0x10,%esp
}
801013bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013c2:	e9 19 ee ff ff       	jmp    801001e0 <brelse>
801013c7:	89 f6                	mov    %esi,%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	89 d3                	mov    %edx,%ebx
801013d7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013d9:	83 ec 08             	sub    $0x8,%esp
801013dc:	68 e0 09 11 80       	push   $0x801109e0
801013e1:	50                   	push   %eax
801013e2:	e8 a9 ff ff ff       	call   80101390 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013e7:	58                   	pop    %eax
801013e8:	5a                   	pop    %edx
801013e9:	89 da                	mov    %ebx,%edx
801013eb:	c1 ea 0c             	shr    $0xc,%edx
801013ee:	03 15 f8 09 11 80    	add    0x801109f8,%edx
801013f4:	52                   	push   %edx
801013f5:	56                   	push   %esi
801013f6:	e8 d5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013fb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013fd:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101403:	ba 01 00 00 00       	mov    $0x1,%edx
80101408:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010140b:	c1 fb 03             	sar    $0x3,%ebx
8010140e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101411:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101413:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101418:	85 d1                	test   %edx,%ecx
8010141a:	74 27                	je     80101443 <bfree+0x73>
8010141c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010141e:	f7 d2                	not    %edx
80101420:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101422:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101425:	21 d0                	and    %edx,%eax
80101427:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010142b:	56                   	push   %esi
8010142c:	e8 2f 19 00 00       	call   80102d60 <log_write>
  brelse(bp);
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 a7 ed ff ff       	call   801001e0 <brelse>
}
80101439:	83 c4 10             	add    $0x10,%esp
8010143c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010143f:	5b                   	pop    %ebx
80101440:	5e                   	pop    %esi
80101441:	5d                   	pop    %ebp
80101442:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101443:	83 ec 0c             	sub    $0xc,%esp
80101446:	68 b4 74 10 80       	push   $0x801074b4
8010144b:	e8 20 ef ff ff       	call   80100370 <panic>

80101450 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	53                   	push   %ebx
80101454:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101459:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010145c:	68 c7 74 10 80       	push   $0x801074c7
80101461:	68 00 0a 11 80       	push   $0x80110a00
80101466:	e8 95 31 00 00       	call   80104600 <initlock>
8010146b:	83 c4 10             	add    $0x10,%esp
8010146e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101470:	83 ec 08             	sub    $0x8,%esp
80101473:	68 ce 74 10 80       	push   $0x801074ce
80101478:	53                   	push   %ebx
80101479:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010147f:	e8 6c 30 00 00       	call   801044f0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101484:	83 c4 10             	add    $0x10,%esp
80101487:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
8010148d:	75 e1                	jne    80101470 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
8010148f:	83 ec 08             	sub    $0x8,%esp
80101492:	68 e0 09 11 80       	push   $0x801109e0
80101497:	ff 75 08             	pushl  0x8(%ebp)
8010149a:	e8 f1 fe ff ff       	call   80101390 <readsb>
}
8010149f:	83 c4 10             	add    $0x10,%esp
801014a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014a5:	c9                   	leave  
801014a6:	c3                   	ret    
801014a7:	89 f6                	mov    %esi,%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	57                   	push   %edi
801014b4:	56                   	push   %esi
801014b5:	53                   	push   %ebx
801014b6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014b9:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801014c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014c3:	8b 75 08             	mov    0x8(%ebp),%esi
801014c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014c9:	0f 86 91 00 00 00    	jbe    80101560 <ialloc+0xb0>
801014cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801014d4:	eb 21                	jmp    801014f7 <ialloc+0x47>
801014d6:	8d 76 00             	lea    0x0(%esi),%esi
801014d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801014e0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014e3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801014e6:	57                   	push   %edi
801014e7:	e8 f4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014ec:	83 c4 10             	add    $0x10,%esp
801014ef:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
801014f5:	76 69                	jbe    80101560 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801014f7:	89 d8                	mov    %ebx,%eax
801014f9:	83 ec 08             	sub    $0x8,%esp
801014fc:	c1 e8 03             	shr    $0x3,%eax
801014ff:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101505:	50                   	push   %eax
80101506:	56                   	push   %esi
80101507:	e8 c4 eb ff ff       	call   801000d0 <bread>
8010150c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010150e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101510:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101513:	83 e0 07             	and    $0x7,%eax
80101516:	c1 e0 06             	shl    $0x6,%eax
80101519:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010151d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101521:	75 bd                	jne    801014e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101523:	83 ec 04             	sub    $0x4,%esp
80101526:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101529:	6a 40                	push   $0x40
8010152b:	6a 00                	push   $0x0
8010152d:	51                   	push   %ecx
8010152e:	e8 1d 33 00 00       	call   80104850 <memset>
      dip->type = type;
80101533:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101537:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010153a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010153d:	89 3c 24             	mov    %edi,(%esp)
80101540:	e8 1b 18 00 00       	call   80102d60 <log_write>
      brelse(bp);
80101545:	89 3c 24             	mov    %edi,(%esp)
80101548:	e8 93 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010154d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101550:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101553:	89 da                	mov    %ebx,%edx
80101555:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101557:	5b                   	pop    %ebx
80101558:	5e                   	pop    %esi
80101559:	5f                   	pop    %edi
8010155a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010155b:	e9 90 fc ff ff       	jmp    801011f0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101560:	83 ec 0c             	sub    $0xc,%esp
80101563:	68 d4 74 10 80       	push   $0x801074d4
80101568:	e8 03 ee ff ff       	call   80100370 <panic>
8010156d:	8d 76 00             	lea    0x0(%esi),%esi

80101570 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	56                   	push   %esi
80101574:	53                   	push   %ebx
80101575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010157e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101581:	c1 e8 03             	shr    $0x3,%eax
80101584:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010158a:	50                   	push   %eax
8010158b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010158e:	e8 3d eb ff ff       	call   801000d0 <bread>
80101593:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101595:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101598:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010159c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010159f:	83 e0 07             	and    $0x7,%eax
801015a2:	c1 e0 06             	shl    $0x6,%eax
801015a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015b0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801015c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801015c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801015ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015cd:	6a 34                	push   $0x34
801015cf:	53                   	push   %ebx
801015d0:	50                   	push   %eax
801015d1:	e8 2a 33 00 00       	call   80104900 <memmove>
  log_write(bp);
801015d6:	89 34 24             	mov    %esi,(%esp)
801015d9:	e8 82 17 00 00       	call   80102d60 <log_write>
  brelse(bp);
801015de:	89 75 08             	mov    %esi,0x8(%ebp)
801015e1:	83 c4 10             	add    $0x10,%esp
}
801015e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015e7:	5b                   	pop    %ebx
801015e8:	5e                   	pop    %esi
801015e9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801015ea:	e9 f1 eb ff ff       	jmp    801001e0 <brelse>
801015ef:	90                   	nop

801015f0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	53                   	push   %ebx
801015f4:	83 ec 10             	sub    $0x10,%esp
801015f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015fa:	68 00 0a 11 80       	push   $0x80110a00
801015ff:	e8 1c 30 00 00       	call   80104620 <acquire>
  ip->ref++;
80101604:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101608:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010160f:	e8 ec 31 00 00       	call   80104800 <release>
  return ip;
}
80101614:	89 d8                	mov    %ebx,%eax
80101616:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101619:	c9                   	leave  
8010161a:	c3                   	ret    
8010161b:	90                   	nop
8010161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101620 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101628:	85 db                	test   %ebx,%ebx
8010162a:	0f 84 b4 00 00 00    	je     801016e4 <ilock+0xc4>
80101630:	8b 43 08             	mov    0x8(%ebx),%eax
80101633:	85 c0                	test   %eax,%eax
80101635:	0f 8e a9 00 00 00    	jle    801016e4 <ilock+0xc4>
    panic("ilock");

  acquiresleep(&ip->lock);
8010163b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010163e:	83 ec 0c             	sub    $0xc,%esp
80101641:	50                   	push   %eax
80101642:	e8 e9 2e 00 00       	call   80104530 <acquiresleep>

  if(!(ip->flags & I_VALID)){
80101647:	83 c4 10             	add    $0x10,%esp
8010164a:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
8010164e:	74 10                	je     80101660 <ilock+0x40>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101650:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101653:	5b                   	pop    %ebx
80101654:	5e                   	pop    %esi
80101655:	5d                   	pop    %ebp
80101656:	c3                   	ret    
80101657:	89 f6                	mov    %esi,%esi
80101659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101660:	8b 43 04             	mov    0x4(%ebx),%eax
80101663:	83 ec 08             	sub    $0x8,%esp
80101666:	c1 e8 03             	shr    $0x3,%eax
80101669:	03 05 f4 09 11 80    	add    0x801109f4,%eax
8010166f:	50                   	push   %eax
80101670:	ff 33                	pushl  (%ebx)
80101672:	e8 59 ea ff ff       	call   801000d0 <bread>
80101677:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101679:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010167c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010167f:	83 e0 07             	and    $0x7,%eax
80101682:	c1 e0 06             	shl    $0x6,%eax
80101685:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101689:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010168c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010168f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101693:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101697:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010169b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010169f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801016ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016b1:	6a 34                	push   $0x34
801016b3:	50                   	push   %eax
801016b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016b7:	50                   	push   %eax
801016b8:	e8 43 32 00 00       	call   80104900 <memmove>
    brelse(bp);
801016bd:	89 34 24             	mov    %esi,(%esp)
801016c0:	e8 1b eb ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
801016c5:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
801016c9:	83 c4 10             	add    $0x10,%esp
801016cc:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801016d1:	0f 85 79 ff ff ff    	jne    80101650 <ilock+0x30>
      panic("ilock: no type");
801016d7:	83 ec 0c             	sub    $0xc,%esp
801016da:	68 ec 74 10 80       	push   $0x801074ec
801016df:	e8 8c ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801016e4:	83 ec 0c             	sub    $0xc,%esp
801016e7:	68 e6 74 10 80       	push   $0x801074e6
801016ec:	e8 7f ec ff ff       	call   80100370 <panic>
801016f1:	eb 0d                	jmp    80101700 <iunlock>
801016f3:	90                   	nop
801016f4:	90                   	nop
801016f5:	90                   	nop
801016f6:	90                   	nop
801016f7:	90                   	nop
801016f8:	90                   	nop
801016f9:	90                   	nop
801016fa:	90                   	nop
801016fb:	90                   	nop
801016fc:	90                   	nop
801016fd:	90                   	nop
801016fe:	90                   	nop
801016ff:	90                   	nop

80101700 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101708:	85 db                	test   %ebx,%ebx
8010170a:	74 28                	je     80101734 <iunlock+0x34>
8010170c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010170f:	83 ec 0c             	sub    $0xc,%esp
80101712:	56                   	push   %esi
80101713:	e8 b8 2e 00 00       	call   801045d0 <holdingsleep>
80101718:	83 c4 10             	add    $0x10,%esp
8010171b:	85 c0                	test   %eax,%eax
8010171d:	74 15                	je     80101734 <iunlock+0x34>
8010171f:	8b 43 08             	mov    0x8(%ebx),%eax
80101722:	85 c0                	test   %eax,%eax
80101724:	7e 0e                	jle    80101734 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101726:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101729:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172c:	5b                   	pop    %ebx
8010172d:	5e                   	pop    %esi
8010172e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010172f:	e9 5c 2e 00 00       	jmp    80104590 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101734:	83 ec 0c             	sub    $0xc,%esp
80101737:	68 fb 74 10 80       	push   $0x801074fb
8010173c:	e8 2f ec ff ff       	call   80100370 <panic>
80101741:	eb 0d                	jmp    80101750 <iput>
80101743:	90                   	nop
80101744:	90                   	nop
80101745:	90                   	nop
80101746:	90                   	nop
80101747:	90                   	nop
80101748:	90                   	nop
80101749:	90                   	nop
8010174a:	90                   	nop
8010174b:	90                   	nop
8010174c:	90                   	nop
8010174d:	90                   	nop
8010174e:	90                   	nop
8010174f:	90                   	nop

80101750 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	57                   	push   %edi
80101754:	56                   	push   %esi
80101755:	53                   	push   %ebx
80101756:	83 ec 28             	sub    $0x28,%esp
80101759:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010175c:	68 00 0a 11 80       	push   $0x80110a00
80101761:	e8 ba 2e 00 00       	call   80104620 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101766:	8b 46 08             	mov    0x8(%esi),%eax
80101769:	83 c4 10             	add    $0x10,%esp
8010176c:	83 f8 01             	cmp    $0x1,%eax
8010176f:	74 1f                	je     80101790 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
80101771:	83 e8 01             	sub    $0x1,%eax
80101774:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101777:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
8010177e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101781:	5b                   	pop    %ebx
80101782:	5e                   	pop    %esi
80101783:	5f                   	pop    %edi
80101784:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
80101785:	e9 76 30 00 00       	jmp    80104800 <release>
8010178a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101790:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
80101794:	74 db                	je     80101771 <iput+0x21>
80101796:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
8010179b:	75 d4                	jne    80101771 <iput+0x21>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
8010179d:	83 ec 0c             	sub    $0xc,%esp
801017a0:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801017a3:	8d be 8c 00 00 00    	lea    0x8c(%esi),%edi
801017a9:	68 00 0a 11 80       	push   $0x80110a00
801017ae:	e8 4d 30 00 00       	call   80104800 <release>
801017b3:	83 c4 10             	add    $0x10,%esp
801017b6:	eb 0f                	jmp    801017c7 <iput+0x77>
801017b8:	90                   	nop
801017b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017c0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801017c3:	39 fb                	cmp    %edi,%ebx
801017c5:	74 19                	je     801017e0 <iput+0x90>
    if(ip->addrs[i]){
801017c7:	8b 13                	mov    (%ebx),%edx
801017c9:	85 d2                	test   %edx,%edx
801017cb:	74 f3                	je     801017c0 <iput+0x70>
      bfree(ip->dev, ip->addrs[i]);
801017cd:	8b 06                	mov    (%esi),%eax
801017cf:	e8 fc fb ff ff       	call   801013d0 <bfree>
      ip->addrs[i] = 0;
801017d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801017da:	eb e4                	jmp    801017c0 <iput+0x70>
801017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801017e0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801017e6:	85 c0                	test   %eax,%eax
801017e8:	75 46                	jne    80101830 <iput+0xe0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801017ea:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801017ed:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801017f4:	56                   	push   %esi
801017f5:	e8 76 fd ff ff       	call   80101570 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
801017fa:	31 c0                	xor    %eax,%eax
801017fc:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
80101800:	89 34 24             	mov    %esi,(%esp)
80101803:	e8 68 fd ff ff       	call   80101570 <iupdate>
    acquire(&icache.lock);
80101808:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010180f:	e8 0c 2e 00 00       	call   80104620 <acquire>
    ip->flags = 0;
80101814:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010181b:	8b 46 08             	mov    0x8(%esi),%eax
8010181e:	83 c4 10             	add    $0x10,%esp
80101821:	e9 4b ff ff ff       	jmp    80101771 <iput+0x21>
80101826:	8d 76 00             	lea    0x0(%esi),%esi
80101829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101830:	83 ec 08             	sub    $0x8,%esp
80101833:	50                   	push   %eax
80101834:	ff 36                	pushl  (%esi)
80101836:	e8 95 e8 ff ff       	call   801000d0 <bread>
8010183b:	83 c4 10             	add    $0x10,%esp
8010183e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101841:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101844:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x107>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101853:	39 df                	cmp    %ebx,%edi
80101855:	74 0f                	je     80101866 <iput+0x116>
      if(a[j])
80101857:	8b 13                	mov    (%ebx),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x100>
        bfree(ip->dev, a[j]);
8010185d:	8b 06                	mov    (%esi),%eax
8010185f:	e8 6c fb ff ff       	call   801013d0 <bfree>
80101864:	eb ea                	jmp    80101850 <iput+0x100>
    }
    brelse(bp);
80101866:	83 ec 0c             	sub    $0xc,%esp
80101869:	ff 75 e4             	pushl  -0x1c(%ebp)
8010186c:	e8 6f e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101871:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101877:	8b 06                	mov    (%esi),%eax
80101879:	e8 52 fb ff ff       	call   801013d0 <bfree>
    ip->addrs[NDIRECT] = 0;
8010187e:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101885:	00 00 00 
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	e9 5a ff ff ff       	jmp    801017ea <iput+0x9a>

80101890 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	53                   	push   %ebx
80101894:	83 ec 10             	sub    $0x10,%esp
80101897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010189a:	53                   	push   %ebx
8010189b:	e8 60 fe ff ff       	call   80101700 <iunlock>
  iput(ip);
801018a0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018a3:	83 c4 10             	add    $0x10,%esp
}
801018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801018aa:	e9 a1 fe ff ff       	jmp    80101750 <iput>
801018af:	90                   	nop

801018b0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	8b 55 08             	mov    0x8(%ebp),%edx
801018b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801018b9:	8b 0a                	mov    (%edx),%ecx
801018bb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801018be:	8b 4a 04             	mov    0x4(%edx),%ecx
801018c1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801018c4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801018c8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801018cb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801018cf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801018d3:	8b 52 58             	mov    0x58(%edx),%edx
801018d6:	89 50 10             	mov    %edx,0x10(%eax)
}
801018d9:	5d                   	pop    %ebp
801018da:	c3                   	ret    
801018db:	90                   	nop
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018e0 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	57                   	push   %edi
801018e4:	56                   	push   %esi
801018e5:	53                   	push   %ebx
801018e6:	83 ec 1c             	sub    $0x1c,%esp
801018e9:	8b 45 08             	mov    0x8(%ebp),%eax
801018ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
801018ef:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801018f2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801018f7:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018fa:	8b 7d 14             	mov    0x14(%ebp),%edi
801018fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101900:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101903:	0f 84 a7 00 00 00    	je     801019b0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101909:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010190c:	8b 40 58             	mov    0x58(%eax),%eax
8010190f:	39 f0                	cmp    %esi,%eax
80101911:	0f 82 c1 00 00 00    	jb     801019d8 <readi+0xf8>
80101917:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010191a:	89 fa                	mov    %edi,%edx
8010191c:	01 f2                	add    %esi,%edx
8010191e:	0f 82 b4 00 00 00    	jb     801019d8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101924:	89 c1                	mov    %eax,%ecx
80101926:	29 f1                	sub    %esi,%ecx
80101928:	39 d0                	cmp    %edx,%eax
8010192a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010192d:	31 ff                	xor    %edi,%edi
8010192f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101931:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101934:	74 6d                	je     801019a3 <readi+0xc3>
80101936:	8d 76 00             	lea    0x0(%esi),%esi
80101939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101940:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101943:	89 f2                	mov    %esi,%edx
80101945:	c1 ea 09             	shr    $0x9,%edx
80101948:	89 d8                	mov    %ebx,%eax
8010194a:	e8 71 f9 ff ff       	call   801012c0 <bmap>
8010194f:	83 ec 08             	sub    $0x8,%esp
80101952:	50                   	push   %eax
80101953:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101955:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010195a:	e8 71 e7 ff ff       	call   801000d0 <bread>
8010195f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101964:	89 f1                	mov    %esi,%ecx
80101966:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
8010196c:	83 c4 0c             	add    $0xc,%esp
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
8010196f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101972:	29 cb                	sub    %ecx,%ebx
80101974:	29 f8                	sub    %edi,%eax
80101976:	39 c3                	cmp    %eax,%ebx
80101978:	0f 47 d8             	cmova  %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
8010197b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
8010197f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101980:	01 df                	add    %ebx,%edi
80101982:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101984:	50                   	push   %eax
80101985:	ff 75 e0             	pushl  -0x20(%ebp)
80101988:	e8 73 2f 00 00       	call   80104900 <memmove>
    brelse(bp);
8010198d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101990:	89 14 24             	mov    %edx,(%esp)
80101993:	e8 48 e8 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101998:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010199b:	83 c4 10             	add    $0x10,%esp
8010199e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019a1:	77 9d                	ja     80101940 <readi+0x60>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801019a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019a9:	5b                   	pop    %ebx
801019aa:	5e                   	pop    %esi
801019ab:	5f                   	pop    %edi
801019ac:	5d                   	pop    %ebp
801019ad:	c3                   	ret    
801019ae:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801019b0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801019b4:	66 83 f8 09          	cmp    $0x9,%ax
801019b8:	77 1e                	ja     801019d8 <readi+0xf8>
801019ba:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
801019c1:	85 c0                	test   %eax,%eax
801019c3:	74 13                	je     801019d8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801019c5:	89 7d 10             	mov    %edi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
801019c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019cb:	5b                   	pop    %ebx
801019cc:	5e                   	pop    %esi
801019cd:	5f                   	pop    %edi
801019ce:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801019cf:	ff e0                	jmp    *%eax
801019d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
801019d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019dd:	eb c7                	jmp    801019a6 <readi+0xc6>
801019df:	90                   	nop

801019e0 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 1c             	sub    $0x1c,%esp
801019e9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ec:	8b 75 0c             	mov    0xc(%ebp),%esi
801019ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019f2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801019f7:	89 75 dc             	mov    %esi,-0x24(%ebp)
801019fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019fd:	8b 75 10             	mov    0x10(%ebp),%esi
80101a00:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a03:	0f 84 b7 00 00 00    	je     80101ac0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a0c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a0f:	0f 82 eb 00 00 00    	jb     80101b00 <writei+0x120>
80101a15:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a18:	89 f8                	mov    %edi,%eax
80101a1a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a1c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a21:	0f 87 d9 00 00 00    	ja     80101b00 <writei+0x120>
80101a27:	39 c6                	cmp    %eax,%esi
80101a29:	0f 87 d1 00 00 00    	ja     80101b00 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a2f:	85 ff                	test   %edi,%edi
80101a31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a38:	74 78                	je     80101ab2 <writei+0xd2>
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a40:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a43:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a45:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a4a:	c1 ea 09             	shr    $0x9,%edx
80101a4d:	89 f8                	mov    %edi,%eax
80101a4f:	e8 6c f8 ff ff       	call   801012c0 <bmap>
80101a54:	83 ec 08             	sub    $0x8,%esp
80101a57:	50                   	push   %eax
80101a58:	ff 37                	pushl  (%edi)
80101a5a:	e8 71 e6 ff ff       	call   801000d0 <bread>
80101a5f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a64:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101a67:	89 f1                	mov    %esi,%ecx
80101a69:	83 c4 0c             	add    $0xc,%esp
80101a6c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101a72:	29 cb                	sub    %ecx,%ebx
80101a74:	39 c3                	cmp    %eax,%ebx
80101a76:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101a79:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101a7d:	53                   	push   %ebx
80101a7e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a81:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101a83:	50                   	push   %eax
80101a84:	e8 77 2e 00 00       	call   80104900 <memmove>
    log_write(bp);
80101a89:	89 3c 24             	mov    %edi,(%esp)
80101a8c:	e8 cf 12 00 00       	call   80102d60 <log_write>
    brelse(bp);
80101a91:	89 3c 24             	mov    %edi,(%esp)
80101a94:	e8 47 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a99:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101a9c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101a9f:	83 c4 10             	add    $0x10,%esp
80101aa2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101aa5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101aa8:	77 96                	ja     80101a40 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101aaa:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aad:	3b 70 58             	cmp    0x58(%eax),%esi
80101ab0:	77 36                	ja     80101ae8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ab2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ab5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5f                   	pop    %edi
80101abb:	5d                   	pop    %ebp
80101abc:	c3                   	ret    
80101abd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ac0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ac4:	66 83 f8 09          	cmp    $0x9,%ax
80101ac8:	77 36                	ja     80101b00 <writei+0x120>
80101aca:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101ad1:	85 c0                	test   %eax,%eax
80101ad3:	74 2b                	je     80101b00 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101ad5:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101adb:	5b                   	pop    %ebx
80101adc:	5e                   	pop    %esi
80101add:	5f                   	pop    %edi
80101ade:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101adf:	ff e0                	jmp    *%eax
80101ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101ae8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101aeb:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101aee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101af1:	50                   	push   %eax
80101af2:	e8 79 fa ff ff       	call   80101570 <iupdate>
80101af7:	83 c4 10             	add    $0x10,%esp
80101afa:	eb b6                	jmp    80101ab2 <writei+0xd2>
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b05:	eb ae                	jmp    80101ab5 <writei+0xd5>
80101b07:	89 f6                	mov    %esi,%esi
80101b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b16:	6a 0e                	push   $0xe
80101b18:	ff 75 0c             	pushl  0xc(%ebp)
80101b1b:	ff 75 08             	pushl  0x8(%ebp)
80101b1e:	e8 5d 2e 00 00       	call   80104980 <strncmp>
}
80101b23:	c9                   	leave  
80101b24:	c3                   	ret    
80101b25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	57                   	push   %edi
80101b34:	56                   	push   %esi
80101b35:	53                   	push   %ebx
80101b36:	83 ec 1c             	sub    $0x1c,%esp
80101b39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b41:	0f 85 80 00 00 00    	jne    80101bc7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b47:	8b 53 58             	mov    0x58(%ebx),%edx
80101b4a:	31 ff                	xor    %edi,%edi
80101b4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b4f:	85 d2                	test   %edx,%edx
80101b51:	75 0d                	jne    80101b60 <dirlookup+0x30>
80101b53:	eb 5b                	jmp    80101bb0 <dirlookup+0x80>
80101b55:	8d 76 00             	lea    0x0(%esi),%esi
80101b58:	83 c7 10             	add    $0x10,%edi
80101b5b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101b5e:	76 50                	jbe    80101bb0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b60:	6a 10                	push   $0x10
80101b62:	57                   	push   %edi
80101b63:	56                   	push   %esi
80101b64:	53                   	push   %ebx
80101b65:	e8 76 fd ff ff       	call   801018e0 <readi>
80101b6a:	83 c4 10             	add    $0x10,%esp
80101b6d:	83 f8 10             	cmp    $0x10,%eax
80101b70:	75 48                	jne    80101bba <dirlookup+0x8a>
      panic("dirlink read");
    if(de.inum == 0)
80101b72:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b77:	74 df                	je     80101b58 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101b79:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b7c:	83 ec 04             	sub    $0x4,%esp
80101b7f:	6a 0e                	push   $0xe
80101b81:	50                   	push   %eax
80101b82:	ff 75 0c             	pushl  0xc(%ebp)
80101b85:	e8 f6 2d 00 00       	call   80104980 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101b8a:	83 c4 10             	add    $0x10,%esp
80101b8d:	85 c0                	test   %eax,%eax
80101b8f:	75 c7                	jne    80101b58 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101b91:	8b 45 10             	mov    0x10(%ebp),%eax
80101b94:	85 c0                	test   %eax,%eax
80101b96:	74 05                	je     80101b9d <dirlookup+0x6d>
        *poff = off;
80101b98:	8b 45 10             	mov    0x10(%ebp),%eax
80101b9b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101b9d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101ba1:	8b 03                	mov    (%ebx),%eax
80101ba3:	e8 48 f6 ff ff       	call   801011f0 <iget>
    }
  }

  return 0;
}
80101ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bab:	5b                   	pop    %ebx
80101bac:	5e                   	pop    %esi
80101bad:	5f                   	pop    %edi
80101bae:	5d                   	pop    %ebp
80101baf:	c3                   	ret    
80101bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101bb3:	31 c0                	xor    %eax,%eax
}
80101bb5:	5b                   	pop    %ebx
80101bb6:	5e                   	pop    %esi
80101bb7:	5f                   	pop    %edi
80101bb8:	5d                   	pop    %ebp
80101bb9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101bba:	83 ec 0c             	sub    $0xc,%esp
80101bbd:	68 15 75 10 80       	push   $0x80107515
80101bc2:	e8 a9 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101bc7:	83 ec 0c             	sub    $0xc,%esp
80101bca:	68 03 75 10 80       	push   $0x80107503
80101bcf:	e8 9c e7 ff ff       	call   80100370 <panic>
80101bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101be0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	89 cf                	mov    %ecx,%edi
80101be8:	89 c3                	mov    %eax,%ebx
80101bea:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101bed:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101bf0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101bf3:	0f 84 53 01 00 00    	je     80101d4c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101bf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101bff:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c02:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c05:	68 00 0a 11 80       	push   $0x80110a00
80101c0a:	e8 11 2a 00 00       	call   80104620 <acquire>
  ip->ref++;
80101c0f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c13:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101c1a:	e8 e1 2b 00 00       	call   80104800 <release>
80101c1f:	83 c4 10             	add    $0x10,%esp
80101c22:	eb 07                	jmp    80101c2b <namex+0x4b>
80101c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c28:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c2b:	0f b6 03             	movzbl (%ebx),%eax
80101c2e:	3c 2f                	cmp    $0x2f,%al
80101c30:	74 f6                	je     80101c28 <namex+0x48>
    path++;
  if(*path == 0)
80101c32:	84 c0                	test   %al,%al
80101c34:	0f 84 e3 00 00 00    	je     80101d1d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c3a:	0f b6 03             	movzbl (%ebx),%eax
80101c3d:	89 da                	mov    %ebx,%edx
80101c3f:	84 c0                	test   %al,%al
80101c41:	0f 84 ac 00 00 00    	je     80101cf3 <namex+0x113>
80101c47:	3c 2f                	cmp    $0x2f,%al
80101c49:	75 09                	jne    80101c54 <namex+0x74>
80101c4b:	e9 a3 00 00 00       	jmp    80101cf3 <namex+0x113>
80101c50:	84 c0                	test   %al,%al
80101c52:	74 0a                	je     80101c5e <namex+0x7e>
    path++;
80101c54:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c57:	0f b6 02             	movzbl (%edx),%eax
80101c5a:	3c 2f                	cmp    $0x2f,%al
80101c5c:	75 f2                	jne    80101c50 <namex+0x70>
80101c5e:	89 d1                	mov    %edx,%ecx
80101c60:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101c62:	83 f9 0d             	cmp    $0xd,%ecx
80101c65:	0f 8e 8d 00 00 00    	jle    80101cf8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101c6b:	83 ec 04             	sub    $0x4,%esp
80101c6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101c71:	6a 0e                	push   $0xe
80101c73:	53                   	push   %ebx
80101c74:	57                   	push   %edi
80101c75:	e8 86 2c 00 00       	call   80104900 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101c7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101c7d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101c80:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101c82:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101c85:	75 11                	jne    80101c98 <namex+0xb8>
80101c87:	89 f6                	mov    %esi,%esi
80101c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101c90:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101c93:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101c96:	74 f8                	je     80101c90 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101c98:	83 ec 0c             	sub    $0xc,%esp
80101c9b:	56                   	push   %esi
80101c9c:	e8 7f f9 ff ff       	call   80101620 <ilock>
    if(ip->type != T_DIR){
80101ca1:	83 c4 10             	add    $0x10,%esp
80101ca4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ca9:	0f 85 7f 00 00 00    	jne    80101d2e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101caf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101cb2:	85 d2                	test   %edx,%edx
80101cb4:	74 09                	je     80101cbf <namex+0xdf>
80101cb6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101cb9:	0f 84 a3 00 00 00    	je     80101d62 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101cbf:	83 ec 04             	sub    $0x4,%esp
80101cc2:	6a 00                	push   $0x0
80101cc4:	57                   	push   %edi
80101cc5:	56                   	push   %esi
80101cc6:	e8 65 fe ff ff       	call   80101b30 <dirlookup>
80101ccb:	83 c4 10             	add    $0x10,%esp
80101cce:	85 c0                	test   %eax,%eax
80101cd0:	74 5c                	je     80101d2e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101cd2:	83 ec 0c             	sub    $0xc,%esp
80101cd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101cd8:	56                   	push   %esi
80101cd9:	e8 22 fa ff ff       	call   80101700 <iunlock>
  iput(ip);
80101cde:	89 34 24             	mov    %esi,(%esp)
80101ce1:	e8 6a fa ff ff       	call   80101750 <iput>
80101ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ce9:	83 c4 10             	add    $0x10,%esp
80101cec:	89 c6                	mov    %eax,%esi
80101cee:	e9 38 ff ff ff       	jmp    80101c2b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cf3:	31 c9                	xor    %ecx,%ecx
80101cf5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101cf8:	83 ec 04             	sub    $0x4,%esp
80101cfb:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101cfe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d01:	51                   	push   %ecx
80101d02:	53                   	push   %ebx
80101d03:	57                   	push   %edi
80101d04:	e8 f7 2b 00 00       	call   80104900 <memmove>
    name[len] = 0;
80101d09:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d0f:	83 c4 10             	add    $0x10,%esp
80101d12:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d16:	89 d3                	mov    %edx,%ebx
80101d18:	e9 65 ff ff ff       	jmp    80101c82 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d20:	85 c0                	test   %eax,%eax
80101d22:	75 54                	jne    80101d78 <namex+0x198>
80101d24:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d29:	5b                   	pop    %ebx
80101d2a:	5e                   	pop    %esi
80101d2b:	5f                   	pop    %edi
80101d2c:	5d                   	pop    %ebp
80101d2d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d2e:	83 ec 0c             	sub    $0xc,%esp
80101d31:	56                   	push   %esi
80101d32:	e8 c9 f9 ff ff       	call   80101700 <iunlock>
  iput(ip);
80101d37:	89 34 24             	mov    %esi,(%esp)
80101d3a:	e8 11 fa ff ff       	call   80101750 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d3f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d45:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d47:	5b                   	pop    %ebx
80101d48:	5e                   	pop    %esi
80101d49:	5f                   	pop    %edi
80101d4a:	5d                   	pop    %ebp
80101d4b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101d4c:	ba 01 00 00 00       	mov    $0x1,%edx
80101d51:	b8 01 00 00 00       	mov    $0x1,%eax
80101d56:	e8 95 f4 ff ff       	call   801011f0 <iget>
80101d5b:	89 c6                	mov    %eax,%esi
80101d5d:	e9 c9 fe ff ff       	jmp    80101c2b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	56                   	push   %esi
80101d66:	e8 95 f9 ff ff       	call   80101700 <iunlock>
      return ip;
80101d6b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101d71:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d73:	5b                   	pop    %ebx
80101d74:	5e                   	pop    %esi
80101d75:	5f                   	pop    %edi
80101d76:	5d                   	pop    %ebp
80101d77:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101d78:	83 ec 0c             	sub    $0xc,%esp
80101d7b:	56                   	push   %esi
80101d7c:	e8 cf f9 ff ff       	call   80101750 <iput>
    return 0;
80101d81:	83 c4 10             	add    $0x10,%esp
80101d84:	31 c0                	xor    %eax,%eax
80101d86:	eb 9e                	jmp    80101d26 <namex+0x146>
80101d88:	90                   	nop
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	83 ec 20             	sub    $0x20,%esp
80101d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101d9c:	6a 00                	push   $0x0
80101d9e:	ff 75 0c             	pushl  0xc(%ebp)
80101da1:	53                   	push   %ebx
80101da2:	e8 89 fd ff ff       	call   80101b30 <dirlookup>
80101da7:	83 c4 10             	add    $0x10,%esp
80101daa:	85 c0                	test   %eax,%eax
80101dac:	75 67                	jne    80101e15 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dae:	8b 7b 58             	mov    0x58(%ebx),%edi
80101db1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101db4:	85 ff                	test   %edi,%edi
80101db6:	74 29                	je     80101de1 <dirlink+0x51>
80101db8:	31 ff                	xor    %edi,%edi
80101dba:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dbd:	eb 09                	jmp    80101dc8 <dirlink+0x38>
80101dbf:	90                   	nop
80101dc0:	83 c7 10             	add    $0x10,%edi
80101dc3:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101dc6:	76 19                	jbe    80101de1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dc8:	6a 10                	push   $0x10
80101dca:	57                   	push   %edi
80101dcb:	56                   	push   %esi
80101dcc:	53                   	push   %ebx
80101dcd:	e8 0e fb ff ff       	call   801018e0 <readi>
80101dd2:	83 c4 10             	add    $0x10,%esp
80101dd5:	83 f8 10             	cmp    $0x10,%eax
80101dd8:	75 4e                	jne    80101e28 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101dda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ddf:	75 df                	jne    80101dc0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101de1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101de4:	83 ec 04             	sub    $0x4,%esp
80101de7:	6a 0e                	push   $0xe
80101de9:	ff 75 0c             	pushl  0xc(%ebp)
80101dec:	50                   	push   %eax
80101ded:	e8 fe 2b 00 00       	call   801049f0 <strncpy>
  de.inum = inum;
80101df2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101df5:	6a 10                	push   $0x10
80101df7:	57                   	push   %edi
80101df8:	56                   	push   %esi
80101df9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101dfa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dfe:	e8 dd fb ff ff       	call   801019e0 <writei>
80101e03:	83 c4 20             	add    $0x20,%esp
80101e06:	83 f8 10             	cmp    $0x10,%eax
80101e09:	75 2a                	jne    80101e35 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e0b:	31 c0                	xor    %eax,%eax
}
80101e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e10:	5b                   	pop    %ebx
80101e11:	5e                   	pop    %esi
80101e12:	5f                   	pop    %edi
80101e13:	5d                   	pop    %ebp
80101e14:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e15:	83 ec 0c             	sub    $0xc,%esp
80101e18:	50                   	push   %eax
80101e19:	e8 32 f9 ff ff       	call   80101750 <iput>
    return -1;
80101e1e:	83 c4 10             	add    $0x10,%esp
80101e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e26:	eb e5                	jmp    80101e0d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e28:	83 ec 0c             	sub    $0xc,%esp
80101e2b:	68 15 75 10 80       	push   $0x80107515
80101e30:	e8 3b e5 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e35:	83 ec 0c             	sub    $0xc,%esp
80101e38:	68 0e 7b 10 80       	push   $0x80107b0e
80101e3d:	e8 2e e5 ff ff       	call   80100370 <panic>
80101e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e50 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101e50:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e51:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101e53:	89 e5                	mov    %esp,%ebp
80101e55:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e58:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e5e:	e8 7d fd ff ff       	call   80101be0 <namex>
}
80101e63:	c9                   	leave  
80101e64:	c3                   	ret    
80101e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e70 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101e70:	55                   	push   %ebp
  return namex(path, 1, name);
80101e71:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101e76:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101e7e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101e7f:	e9 5c fd ff ff       	jmp    80101be0 <namex>
80101e84:	66 90                	xchg   %ax,%ax
80101e86:	66 90                	xchg   %ax,%ax
80101e88:	66 90                	xchg   %ax,%ax
80101e8a:	66 90                	xchg   %ax,%ax
80101e8c:	66 90                	xchg   %ax,%ax
80101e8e:	66 90                	xchg   %ax,%ax

80101e90 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101e90:	55                   	push   %ebp
  if(b == 0)
80101e91:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101e93:	89 e5                	mov    %esp,%ebp
80101e95:	56                   	push   %esi
80101e96:	53                   	push   %ebx
  if(b == 0)
80101e97:	0f 84 ad 00 00 00    	je     80101f4a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101e9d:	8b 58 08             	mov    0x8(%eax),%ebx
80101ea0:	89 c1                	mov    %eax,%ecx
80101ea2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101ea8:	0f 87 8f 00 00 00    	ja     80101f3d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101eae:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101eb3:	90                   	nop
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101eb8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101eb9:	83 e0 c0             	and    $0xffffffc0,%eax
80101ebc:	3c 40                	cmp    $0x40,%al
80101ebe:	75 f8                	jne    80101eb8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ec0:	31 f6                	xor    %esi,%esi
80101ec2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ec7:	89 f0                	mov    %esi,%eax
80101ec9:	ee                   	out    %al,(%dx)
80101eca:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101ecf:	b8 01 00 00 00       	mov    $0x1,%eax
80101ed4:	ee                   	out    %al,(%dx)
80101ed5:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101eda:	89 d8                	mov    %ebx,%eax
80101edc:	ee                   	out    %al,(%dx)
80101edd:	89 d8                	mov    %ebx,%eax
80101edf:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101ee4:	c1 f8 08             	sar    $0x8,%eax
80101ee7:	ee                   	out    %al,(%dx)
80101ee8:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101eed:	89 f0                	mov    %esi,%eax
80101eef:	ee                   	out    %al,(%dx)
80101ef0:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101ef4:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ef9:	83 e0 01             	and    $0x1,%eax
80101efc:	c1 e0 04             	shl    $0x4,%eax
80101eff:	83 c8 e0             	or     $0xffffffe0,%eax
80101f02:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f03:	f6 01 04             	testb  $0x4,(%ecx)
80101f06:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f0b:	75 13                	jne    80101f20 <idestart+0x90>
80101f0d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f12:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f13:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f16:	5b                   	pop    %ebx
80101f17:	5e                   	pop    %esi
80101f18:	5d                   	pop    %ebp
80101f19:	c3                   	ret    
80101f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f20:	b8 30 00 00 00       	mov    $0x30,%eax
80101f25:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f26:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f2b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f2e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f33:	fc                   	cld    
80101f34:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f39:	5b                   	pop    %ebx
80101f3a:	5e                   	pop    %esi
80101f3b:	5d                   	pop    %ebp
80101f3c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f3d:	83 ec 0c             	sub    $0xc,%esp
80101f40:	68 2b 75 10 80       	push   $0x8010752b
80101f45:	e8 26 e4 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101f4a:	83 ec 0c             	sub    $0xc,%esp
80101f4d:	68 22 75 10 80       	push   $0x80107522
80101f52:	e8 19 e4 ff ff       	call   80100370 <panic>
80101f57:	89 f6                	mov    %esi,%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f60 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101f66:	68 3d 75 10 80       	push   $0x8010753d
80101f6b:	68 80 a5 10 80       	push   $0x8010a580
80101f70:	e8 8b 26 00 00       	call   80104600 <initlock>
  picenable(IRQ_IDE);
80101f75:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101f7c:	e8 af 12 00 00       	call   80103230 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101f81:	58                   	pop    %eax
80101f82:	a1 80 2d 11 80       	mov    0x80112d80,%eax
80101f87:	5a                   	pop    %edx
80101f88:	83 e8 01             	sub    $0x1,%eax
80101f8b:	50                   	push   %eax
80101f8c:	6a 0e                	push   $0xe
80101f8e:	e8 bd 02 00 00       	call   80102250 <ioapicenable>
80101f93:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f96:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f9b:	90                   	nop
80101f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fa1:	83 e0 c0             	and    $0xffffffc0,%eax
80101fa4:	3c 40                	cmp    $0x40,%al
80101fa6:	75 f8                	jne    80101fa0 <ideinit+0x40>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fa8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101fb2:	ee                   	out    %al,(%dx)
80101fb3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fb8:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fbd:	eb 06                	jmp    80101fc5 <ideinit+0x65>
80101fbf:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80101fc0:	83 e9 01             	sub    $0x1,%ecx
80101fc3:	74 0f                	je     80101fd4 <ideinit+0x74>
80101fc5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101fc6:	84 c0                	test   %al,%al
80101fc8:	74 f6                	je     80101fc0 <ideinit+0x60>
      havedisk1 = 1;
80101fca:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101fd1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fd4:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fd9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101fde:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80101fdf:	c9                   	leave  
80101fe0:	c3                   	ret    
80101fe1:	eb 0d                	jmp    80101ff0 <ideintr>
80101fe3:	90                   	nop
80101fe4:	90                   	nop
80101fe5:	90                   	nop
80101fe6:	90                   	nop
80101fe7:	90                   	nop
80101fe8:	90                   	nop
80101fe9:	90                   	nop
80101fea:	90                   	nop
80101feb:	90                   	nop
80101fec:	90                   	nop
80101fed:	90                   	nop
80101fee:	90                   	nop
80101fef:	90                   	nop

80101ff0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101ff9:	68 80 a5 10 80       	push   $0x8010a580
80101ffe:	e8 1d 26 00 00       	call   80104620 <acquire>
  if((b = idequeue) == 0){
80102003:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102009:	83 c4 10             	add    $0x10,%esp
8010200c:	85 db                	test   %ebx,%ebx
8010200e:	74 34                	je     80102044 <ideintr+0x54>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102010:	8b 43 58             	mov    0x58(%ebx),%eax
80102013:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102018:	8b 33                	mov    (%ebx),%esi
8010201a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102020:	74 3e                	je     80102060 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102022:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102025:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102028:	83 ce 02             	or     $0x2,%esi
8010202b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010202d:	53                   	push   %ebx
8010202e:	e8 fd 1e 00 00       	call   80103f30 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102033:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102038:	83 c4 10             	add    $0x10,%esp
8010203b:	85 c0                	test   %eax,%eax
8010203d:	74 05                	je     80102044 <ideintr+0x54>
    idestart(idequeue);
8010203f:	e8 4c fe ff ff       	call   80101e90 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
80102044:	83 ec 0c             	sub    $0xc,%esp
80102047:	68 80 a5 10 80       	push   $0x8010a580
8010204c:	e8 af 27 00 00       	call   80104800 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102051:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102054:	5b                   	pop    %ebx
80102055:	5e                   	pop    %esi
80102056:	5f                   	pop    %edi
80102057:	5d                   	pop    %ebp
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102060:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102065:	8d 76 00             	lea    0x0(%esi),%esi
80102068:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102069:	89 c1                	mov    %eax,%ecx
8010206b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010206e:	80 f9 40             	cmp    $0x40,%cl
80102071:	75 f5                	jne    80102068 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102073:	a8 21                	test   $0x21,%al
80102075:	75 ab                	jne    80102022 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102077:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010207a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010207f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102084:	fc                   	cld    
80102085:	f3 6d                	rep insl (%dx),%es:(%edi)
80102087:	8b 33                	mov    (%ebx),%esi
80102089:	eb 97                	jmp    80102022 <ideintr+0x32>
8010208b:	90                   	nop
8010208c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102090 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	53                   	push   %ebx
80102094:	83 ec 10             	sub    $0x10,%esp
80102097:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010209a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010209d:	50                   	push   %eax
8010209e:	e8 2d 25 00 00       	call   801045d0 <holdingsleep>
801020a3:	83 c4 10             	add    $0x10,%esp
801020a6:	85 c0                	test   %eax,%eax
801020a8:	0f 84 ad 00 00 00    	je     8010215b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020ae:	8b 03                	mov    (%ebx),%eax
801020b0:	83 e0 06             	and    $0x6,%eax
801020b3:	83 f8 02             	cmp    $0x2,%eax
801020b6:	0f 84 b9 00 00 00    	je     80102175 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801020bc:	8b 53 04             	mov    0x4(%ebx),%edx
801020bf:	85 d2                	test   %edx,%edx
801020c1:	74 0d                	je     801020d0 <iderw+0x40>
801020c3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801020c8:	85 c0                	test   %eax,%eax
801020ca:	0f 84 98 00 00 00    	je     80102168 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801020d0:	83 ec 0c             	sub    $0xc,%esp
801020d3:	68 80 a5 10 80       	push   $0x8010a580
801020d8:	e8 43 25 00 00       	call   80104620 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020dd:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801020e3:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801020e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020ed:	85 d2                	test   %edx,%edx
801020ef:	75 09                	jne    801020fa <iderw+0x6a>
801020f1:	eb 58                	jmp    8010214b <iderw+0xbb>
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020f8:	89 c2                	mov    %eax,%edx
801020fa:	8b 42 58             	mov    0x58(%edx),%eax
801020fd:	85 c0                	test   %eax,%eax
801020ff:	75 f7                	jne    801020f8 <iderw+0x68>
80102101:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102104:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102106:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010210c:	74 44                	je     80102152 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010210e:	8b 03                	mov    (%ebx),%eax
80102110:	83 e0 06             	and    $0x6,%eax
80102113:	83 f8 02             	cmp    $0x2,%eax
80102116:	74 23                	je     8010213b <iderw+0xab>
80102118:	90                   	nop
80102119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102120:	83 ec 08             	sub    $0x8,%esp
80102123:	68 80 a5 10 80       	push   $0x8010a580
80102128:	53                   	push   %ebx
80102129:	e8 62 1c 00 00       	call   80103d90 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010212e:	8b 03                	mov    (%ebx),%eax
80102130:	83 c4 10             	add    $0x10,%esp
80102133:	83 e0 06             	and    $0x6,%eax
80102136:	83 f8 02             	cmp    $0x2,%eax
80102139:	75 e5                	jne    80102120 <iderw+0x90>
    sleep(b, &idelock);
  }

  release(&idelock);
8010213b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102145:	c9                   	leave  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
80102146:	e9 b5 26 00 00       	jmp    80104800 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102150:	eb b2                	jmp    80102104 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102152:	89 d8                	mov    %ebx,%eax
80102154:	e8 37 fd ff ff       	call   80101e90 <idestart>
80102159:	eb b3                	jmp    8010210e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010215b:	83 ec 0c             	sub    $0xc,%esp
8010215e:	68 41 75 10 80       	push   $0x80107541
80102163:	e8 08 e2 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102168:	83 ec 0c             	sub    $0xc,%esp
8010216b:	68 6c 75 10 80       	push   $0x8010756c
80102170:	e8 fb e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	68 57 75 10 80       	push   $0x80107557
8010217d:	e8 ee e1 ff ff       	call   80100370 <panic>
80102182:	66 90                	xchg   %ax,%ax
80102184:	66 90                	xchg   %ax,%ax
80102186:	66 90                	xchg   %ax,%ax
80102188:	66 90                	xchg   %ax,%ax
8010218a:	66 90                	xchg   %ax,%ax
8010218c:	66 90                	xchg   %ax,%ax
8010218e:	66 90                	xchg   %ax,%ax

80102190 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
80102190:	a1 84 27 11 80       	mov    0x80112784,%eax
80102195:	85 c0                	test   %eax,%eax
80102197:	0f 84 a8 00 00 00    	je     80102245 <ioapicinit+0xb5>
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010219d:	55                   	push   %ebp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010219e:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801021a5:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021a8:	89 e5                	mov    %esp,%ebp
801021aa:	56                   	push   %esi
801021ab:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ac:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021b3:	00 00 00 
  return ioapic->data;
801021b6:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801021bc:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021bf:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801021c5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021cb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801021d2:	89 f0                	mov    %esi,%eax
801021d4:	c1 e8 10             	shr    $0x10,%eax
801021d7:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801021da:	8b 41 10             	mov    0x10(%ecx),%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021dd:	c1 e8 18             	shr    $0x18,%eax
801021e0:	39 d0                	cmp    %edx,%eax
801021e2:	74 16                	je     801021fa <ioapicinit+0x6a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801021e4:	83 ec 0c             	sub    $0xc,%esp
801021e7:	68 8c 75 10 80       	push   $0x8010758c
801021ec:	e8 6f e4 ff ff       	call   80100660 <cprintf>
801021f1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
801021f7:	83 c4 10             	add    $0x10,%esp
801021fa:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fd:	ba 10 00 00 00       	mov    $0x10,%edx
80102202:	b8 20 00 00 00       	mov    $0x20,%eax
80102207:	89 f6                	mov    %esi,%esi
80102209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102210:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102212:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102218:	89 c3                	mov    %eax,%ebx
8010221a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102220:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102223:	89 59 10             	mov    %ebx,0x10(%ecx)
80102226:	8d 5a 01             	lea    0x1(%edx),%ebx
80102229:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010222c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010222e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102230:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102236:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010223d:	75 d1                	jne    80102210 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010223f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102242:	5b                   	pop    %ebx
80102243:	5e                   	pop    %esi
80102244:	5d                   	pop    %ebp
80102245:	f3 c3                	repz ret 
80102247:	89 f6                	mov    %esi,%esi
80102249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102250 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102250:	8b 15 84 27 11 80    	mov    0x80112784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102256:	55                   	push   %ebp
80102257:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102259:	85 d2                	test   %edx,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
8010225b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010225e:	74 2b                	je     8010228b <ioapicenable+0x3b>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102260:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102266:	8d 50 20             	lea    0x20(%eax),%edx
80102269:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010226d:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010226f:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102275:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102278:	89 51 10             	mov    %edx,0x10(%ecx)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010227b:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227e:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102280:	a1 54 26 11 80       	mov    0x80112654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102285:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102288:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
8010228b:	5d                   	pop    %ebp
8010228c:	c3                   	ret    
8010228d:	66 90                	xchg   %ax,%ax
8010228f:	90                   	nop

80102290 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	53                   	push   %ebx
80102294:	83 ec 04             	sub    $0x4,%esp
80102297:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010229a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022a0:	75 70                	jne    80102312 <kfree+0x82>
801022a2:	81 fb 28 56 11 80    	cmp    $0x80115628,%ebx
801022a8:	72 68                	jb     80102312 <kfree+0x82>
801022aa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022b0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022b5:	77 5b                	ja     80102312 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022b7:	83 ec 04             	sub    $0x4,%esp
801022ba:	68 00 10 00 00       	push   $0x1000
801022bf:	6a 01                	push   $0x1
801022c1:	53                   	push   %ebx
801022c2:	e8 89 25 00 00       	call   80104850 <memset>

  if(kmem.use_lock)
801022c7:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801022cd:	83 c4 10             	add    $0x10,%esp
801022d0:	85 d2                	test   %edx,%edx
801022d2:	75 2c                	jne    80102300 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801022d4:	a1 98 26 11 80       	mov    0x80112698,%eax
801022d9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801022db:	a1 94 26 11 80       	mov    0x80112694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801022e0:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
801022e6:	85 c0                	test   %eax,%eax
801022e8:	75 06                	jne    801022f0 <kfree+0x60>
    release(&kmem.lock);
}
801022ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022ed:	c9                   	leave  
801022ee:	c3                   	ret    
801022ef:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801022f0:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
801022f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022fa:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801022fb:	e9 00 25 00 00       	jmp    80104800 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102300:	83 ec 0c             	sub    $0xc,%esp
80102303:	68 60 26 11 80       	push   $0x80112660
80102308:	e8 13 23 00 00       	call   80104620 <acquire>
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	eb c2                	jmp    801022d4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102312:	83 ec 0c             	sub    $0xc,%esp
80102315:	68 be 75 10 80       	push   $0x801075be
8010231a:	e8 51 e0 ff ff       	call   80100370 <panic>
8010231f:	90                   	nop

80102320 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	56                   	push   %esi
80102324:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102325:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102328:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010232b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102331:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102337:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010233d:	39 de                	cmp    %ebx,%esi
8010233f:	72 23                	jb     80102364 <freerange+0x44>
80102341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102348:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010234e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102351:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102357:	50                   	push   %eax
80102358:	e8 33 ff ff ff       	call   80102290 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	39 f3                	cmp    %esi,%ebx
80102362:	76 e4                	jbe    80102348 <freerange+0x28>
    kfree(p);
}
80102364:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102367:	5b                   	pop    %ebx
80102368:	5e                   	pop    %esi
80102369:	5d                   	pop    %ebp
8010236a:	c3                   	ret    
8010236b:	90                   	nop
8010236c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102370 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	56                   	push   %esi
80102374:	53                   	push   %ebx
80102375:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102378:	83 ec 08             	sub    $0x8,%esp
8010237b:	68 c4 75 10 80       	push   $0x801075c4
80102380:	68 60 26 11 80       	push   $0x80112660
80102385:	e8 76 22 00 00       	call   80104600 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010238d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102390:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102397:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010239a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023ac:	39 de                	cmp    %ebx,%esi
801023ae:	72 1c                	jb     801023cc <kinit1+0x5c>
    kfree(p);
801023b0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023b6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023bf:	50                   	push   %eax
801023c0:	e8 cb fe ff ff       	call   80102290 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c5:	83 c4 10             	add    $0x10,%esp
801023c8:	39 de                	cmp    %ebx,%esi
801023ca:	73 e4                	jae    801023b0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801023cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023cf:	5b                   	pop    %ebx
801023d0:	5e                   	pop    %esi
801023d1:	5d                   	pop    %ebp
801023d2:	c3                   	ret    
801023d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023e0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fd:	39 de                	cmp    %ebx,%esi
801023ff:	72 23                	jb     80102424 <kinit2+0x44>
80102401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102408:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010240e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102417:	50                   	push   %eax
80102418:	e8 73 fe ff ff       	call   80102290 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	39 de                	cmp    %ebx,%esi
80102422:	73 e4                	jae    80102408 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102424:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010242b:	00 00 00 
}
8010242e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	53                   	push   %ebx
80102444:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102447:	a1 94 26 11 80       	mov    0x80112694,%eax
8010244c:	85 c0                	test   %eax,%eax
8010244e:	75 30                	jne    80102480 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102450:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
80102456:	85 db                	test   %ebx,%ebx
80102458:	74 1c                	je     80102476 <kalloc+0x36>
    kmem.freelist = r->next;
8010245a:	8b 13                	mov    (%ebx),%edx
8010245c:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
80102462:	85 c0                	test   %eax,%eax
80102464:	74 10                	je     80102476 <kalloc+0x36>
    release(&kmem.lock);
80102466:	83 ec 0c             	sub    $0xc,%esp
80102469:	68 60 26 11 80       	push   $0x80112660
8010246e:	e8 8d 23 00 00       	call   80104800 <release>
80102473:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102476:	89 d8                	mov    %ebx,%eax
80102478:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010247b:	c9                   	leave  
8010247c:	c3                   	ret    
8010247d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102480:	83 ec 0c             	sub    $0xc,%esp
80102483:	68 60 26 11 80       	push   $0x80112660
80102488:	e8 93 21 00 00       	call   80104620 <acquire>
  r = kmem.freelist;
8010248d:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  if(r)
80102493:	83 c4 10             	add    $0x10,%esp
80102496:	a1 94 26 11 80       	mov    0x80112694,%eax
8010249b:	85 db                	test   %ebx,%ebx
8010249d:	75 bb                	jne    8010245a <kalloc+0x1a>
8010249f:	eb c1                	jmp    80102462 <kalloc+0x22>
801024a1:	66 90                	xchg   %ax,%ax
801024a3:	66 90                	xchg   %ax,%ax
801024a5:	66 90                	xchg   %ax,%ax
801024a7:	66 90                	xchg   %ax,%ax
801024a9:	66 90                	xchg   %ax,%ax
801024ab:	66 90                	xchg   %ax,%ax
801024ad:	66 90                	xchg   %ax,%ax
801024af:	90                   	nop

801024b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024b0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024b1:	ba 64 00 00 00       	mov    $0x64,%edx
801024b6:	89 e5                	mov    %esp,%ebp
801024b8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024b9:	a8 01                	test   $0x1,%al
801024bb:	0f 84 af 00 00 00    	je     80102570 <kbdgetc+0xc0>
801024c1:	ba 60 00 00 00       	mov    $0x60,%edx
801024c6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801024c7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801024ca:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801024d0:	74 7e                	je     80102550 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801024d2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801024d4:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801024da:	79 24                	jns    80102500 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801024dc:	f6 c1 40             	test   $0x40,%cl
801024df:	75 05                	jne    801024e6 <kbdgetc+0x36>
801024e1:	89 c2                	mov    %eax,%edx
801024e3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801024e6:	0f b6 82 00 77 10 80 	movzbl -0x7fef8900(%edx),%eax
801024ed:	83 c8 40             	or     $0x40,%eax
801024f0:	0f b6 c0             	movzbl %al,%eax
801024f3:	f7 d0                	not    %eax
801024f5:	21 c8                	and    %ecx,%eax
801024f7:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801024fc:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801024fe:	5d                   	pop    %ebp
801024ff:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102500:	f6 c1 40             	test   $0x40,%cl
80102503:	74 09                	je     8010250e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102505:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102508:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010250b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010250e:	0f b6 82 00 77 10 80 	movzbl -0x7fef8900(%edx),%eax
80102515:	09 c1                	or     %eax,%ecx
80102517:	0f b6 82 00 76 10 80 	movzbl -0x7fef8a00(%edx),%eax
8010251e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102520:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102522:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102528:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010252b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010252e:	8b 04 85 e0 75 10 80 	mov    -0x7fef8a20(,%eax,4),%eax
80102535:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102539:	74 c3                	je     801024fe <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010253b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010253e:	83 fa 19             	cmp    $0x19,%edx
80102541:	77 1d                	ja     80102560 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102543:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102546:	5d                   	pop    %ebp
80102547:	c3                   	ret    
80102548:	90                   	nop
80102549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102550:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102552:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	90                   	nop
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102560:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102563:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102566:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102567:	83 f9 19             	cmp    $0x19,%ecx
8010256a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010256d:	c3                   	ret    
8010256e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102575:	5d                   	pop    %ebp
80102576:	c3                   	ret    
80102577:	89 f6                	mov    %esi,%esi
80102579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102580 <kbdintr>:

void
kbdintr(void)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102586:	68 b0 24 10 80       	push   $0x801024b0
8010258b:	e8 60 e2 ff ff       	call   801007f0 <consoleintr>
}
80102590:	83 c4 10             	add    $0x10,%esp
80102593:	c9                   	leave  
80102594:	c3                   	ret    
80102595:	66 90                	xchg   %ax,%ax
80102597:	66 90                	xchg   %ax,%ax
80102599:	66 90                	xchg   %ax,%ax
8010259b:	66 90                	xchg   %ax,%ax
8010259d:	66 90                	xchg   %ax,%ax
8010259f:	90                   	nop

801025a0 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
801025a0:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
801025a5:	55                   	push   %ebp
801025a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025a8:	85 c0                	test   %eax,%eax
801025aa:	0f 84 c8 00 00 00    	je     80102678 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025ba:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801025c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025c7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801025d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801025d4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801025de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801025e1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801025eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025ee:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801025f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801025fe:	8b 50 30             	mov    0x30(%eax),%edx
80102601:	c1 ea 10             	shr    $0x10,%edx
80102604:	80 fa 03             	cmp    $0x3,%dl
80102607:	77 77                	ja     80102680 <lapicinit+0xe0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102609:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102610:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102613:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102616:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010261d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102620:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102623:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010262a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010262d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102630:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102637:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010263a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010263d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102644:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102647:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010264a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102651:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102654:	8b 50 20             	mov    0x20(%eax),%edx
80102657:	89 f6                	mov    %esi,%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102660:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102666:	80 e6 10             	and    $0x10,%dh
80102669:	75 f5                	jne    80102660 <lapicinit+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010266b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102672:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102675:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102678:	5d                   	pop    %ebp
80102679:	c3                   	ret    
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102680:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102687:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx
8010268d:	e9 77 ff ff ff       	jmp    80102609 <lapicinit+0x69>
80102692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	56                   	push   %esi
801026a4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801026a5:	9c                   	pushf  
801026a6:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801026a7:	f6 c4 02             	test   $0x2,%ah
801026aa:	74 12                	je     801026be <cpunum+0x1e>
    static int n;
    if(n++ == 0)
801026ac:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801026b1:	8d 50 01             	lea    0x1(%eax),%edx
801026b4:	85 c0                	test   %eax,%eax
801026b6:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
801026bc:	74 4d                	je     8010270b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
801026be:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801026c3:	85 c0                	test   %eax,%eax
801026c5:	74 60                	je     80102727 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
801026c7:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
801026ca:	8b 35 80 2d 11 80    	mov    0x80112d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
801026d0:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
801026d3:	85 f6                	test   %esi,%esi
801026d5:	7e 59                	jle    80102730 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801026d7:	0f b6 05 a0 27 11 80 	movzbl 0x801127a0,%eax
801026de:	39 c3                	cmp    %eax,%ebx
801026e0:	74 45                	je     80102727 <cpunum+0x87>
801026e2:	ba 5c 28 11 80       	mov    $0x8011285c,%edx
801026e7:	31 c0                	xor    %eax,%eax
801026e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
801026f0:	83 c0 01             	add    $0x1,%eax
801026f3:	39 f0                	cmp    %esi,%eax
801026f5:	74 39                	je     80102730 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801026f7:	0f b6 0a             	movzbl (%edx),%ecx
801026fa:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102700:	39 cb                	cmp    %ecx,%ebx
80102702:	75 ec                	jne    801026f0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102704:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102707:	5b                   	pop    %ebx
80102708:	5e                   	pop    %esi
80102709:	5d                   	pop    %ebp
8010270a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
8010270b:	83 ec 08             	sub    $0x8,%esp
8010270e:	ff 75 04             	pushl  0x4(%ebp)
80102711:	68 00 78 10 80       	push   $0x80107800
80102716:	e8 45 df ff ff       	call   80100660 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010271b:	a1 9c 26 11 80       	mov    0x8011269c,%eax
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
80102720:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if (!lapic)
80102723:	85 c0                	test   %eax,%eax
80102725:	75 a0                	jne    801026c7 <cpunum+0x27>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102727:	8d 65 f8             	lea    -0x8(%ebp),%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010272a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010272c:	5b                   	pop    %ebx
8010272d:	5e                   	pop    %esi
8010272e:	5d                   	pop    %ebp
8010272f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102730:	83 ec 0c             	sub    $0xc,%esp
80102733:	68 2c 78 10 80       	push   $0x8010782c
80102738:	e8 33 dc ff ff       	call   80100370 <panic>
8010273d:	8d 76 00             	lea    0x0(%esi),%esi

80102740 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102740:	a1 9c 26 11 80       	mov    0x8011269c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102745:	55                   	push   %ebp
80102746:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102748:	85 c0                	test   %eax,%eax
8010274a:	74 0d                	je     80102759 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010274c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102753:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102756:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102759:	5d                   	pop    %ebp
8010275a:	c3                   	ret    
8010275b:	90                   	nop
8010275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102760 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
}
80102763:	5d                   	pop    %ebp
80102764:	c3                   	ret    
80102765:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102770:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102771:	ba 70 00 00 00       	mov    $0x70,%edx
80102776:	b8 0f 00 00 00       	mov    $0xf,%eax
8010277b:	89 e5                	mov    %esp,%ebp
8010277d:	53                   	push   %ebx
8010277e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102781:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102784:	ee                   	out    %al,(%dx)
80102785:	ba 71 00 00 00       	mov    $0x71,%edx
8010278a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010278f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102790:	31 c0                	xor    %eax,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102792:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102795:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010279b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010279d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027a0:	c1 e8 04             	shr    $0x4,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027a5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027a8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ae:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801027b3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027b9:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027bc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027c3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c6:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027d0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d3:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027dc:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027df:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ee:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027fa:	5b                   	pop    %ebx
801027fb:	5d                   	pop    %ebp
801027fc:	c3                   	ret    
801027fd:	8d 76 00             	lea    0x0(%esi),%esi

80102800 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102800:	55                   	push   %ebp
80102801:	ba 70 00 00 00       	mov    $0x70,%edx
80102806:	b8 0b 00 00 00       	mov    $0xb,%eax
8010280b:	89 e5                	mov    %esp,%ebp
8010280d:	57                   	push   %edi
8010280e:	56                   	push   %esi
8010280f:	53                   	push   %ebx
80102810:	83 ec 4c             	sub    $0x4c,%esp
80102813:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102814:	ba 71 00 00 00       	mov    $0x71,%edx
80102819:	ec                   	in     (%dx),%al
8010281a:	83 e0 04             	and    $0x4,%eax
8010281d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102820:	31 db                	xor    %ebx,%ebx
80102822:	88 45 b7             	mov    %al,-0x49(%ebp)
80102825:	bf 70 00 00 00       	mov    $0x70,%edi
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102830:	89 d8                	mov    %ebx,%eax
80102832:	89 fa                	mov    %edi,%edx
80102834:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102835:	b9 71 00 00 00       	mov    $0x71,%ecx
8010283a:	89 ca                	mov    %ecx,%edx
8010283c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010283d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102840:	89 fa                	mov    %edi,%edx
80102842:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102845:	b8 02 00 00 00       	mov    $0x2,%eax
8010284a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284b:	89 ca                	mov    %ecx,%edx
8010284d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010284e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102851:	89 fa                	mov    %edi,%edx
80102853:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102856:	b8 04 00 00 00       	mov    $0x4,%eax
8010285b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285c:	89 ca                	mov    %ecx,%edx
8010285e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010285f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102862:	89 fa                	mov    %edi,%edx
80102864:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102867:	b8 07 00 00 00       	mov    $0x7,%eax
8010286c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286d:	89 ca                	mov    %ecx,%edx
8010286f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102870:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102873:	89 fa                	mov    %edi,%edx
80102875:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102878:	b8 08 00 00 00       	mov    $0x8,%eax
8010287d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287e:	89 ca                	mov    %ecx,%edx
80102880:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102881:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102884:	89 fa                	mov    %edi,%edx
80102886:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102889:	b8 09 00 00 00       	mov    $0x9,%eax
8010288e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288f:	89 ca                	mov    %ecx,%edx
80102891:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102892:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102895:	89 fa                	mov    %edi,%edx
80102897:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010289a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010289f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a0:	89 ca                	mov    %ecx,%edx
801028a2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028a3:	84 c0                	test   %al,%al
801028a5:	78 89                	js     80102830 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a7:	89 d8                	mov    %ebx,%eax
801028a9:	89 fa                	mov    %edi,%edx
801028ab:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	89 ca                	mov    %ecx,%edx
801028ae:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801028af:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b2:	89 fa                	mov    %edi,%edx
801028b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028b7:	b8 02 00 00 00       	mov    $0x2,%eax
801028bc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bd:	89 ca                	mov    %ecx,%edx
801028bf:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801028c0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c3:	89 fa                	mov    %edi,%edx
801028c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028c8:	b8 04 00 00 00       	mov    $0x4,%eax
801028cd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ce:	89 ca                	mov    %ecx,%edx
801028d0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801028d1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d4:	89 fa                	mov    %edi,%edx
801028d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028d9:	b8 07 00 00 00       	mov    $0x7,%eax
801028de:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028df:	89 ca                	mov    %ecx,%edx
801028e1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028e2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e5:	89 fa                	mov    %edi,%edx
801028e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028ea:	b8 08 00 00 00       	mov    $0x8,%eax
801028ef:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f0:	89 ca                	mov    %ecx,%edx
801028f2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028f3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f6:	89 fa                	mov    %edi,%edx
801028f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028fb:	b8 09 00 00 00       	mov    $0x9,%eax
80102900:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102901:	89 ca                	mov    %ecx,%edx
80102903:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102904:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102907:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
8010290a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010290d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102910:	6a 18                	push   $0x18
80102912:	56                   	push   %esi
80102913:	50                   	push   %eax
80102914:	e8 87 1f 00 00       	call   801048a0 <memcmp>
80102919:	83 c4 10             	add    $0x10,%esp
8010291c:	85 c0                	test   %eax,%eax
8010291e:	0f 85 0c ff ff ff    	jne    80102830 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102924:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102928:	75 78                	jne    801029a2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010292a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010292d:	89 c2                	mov    %eax,%edx
8010292f:	83 e0 0f             	and    $0xf,%eax
80102932:	c1 ea 04             	shr    $0x4,%edx
80102935:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102938:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010293b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010293e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102941:	89 c2                	mov    %eax,%edx
80102943:	83 e0 0f             	and    $0xf,%eax
80102946:	c1 ea 04             	shr    $0x4,%edx
80102949:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010294c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010294f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102952:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102955:	89 c2                	mov    %eax,%edx
80102957:	83 e0 0f             	and    $0xf,%eax
8010295a:	c1 ea 04             	shr    $0x4,%edx
8010295d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102960:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102963:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102966:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102969:	89 c2                	mov    %eax,%edx
8010296b:	83 e0 0f             	and    $0xf,%eax
8010296e:	c1 ea 04             	shr    $0x4,%edx
80102971:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102974:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102977:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010297a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010297d:	89 c2                	mov    %eax,%edx
8010297f:	83 e0 0f             	and    $0xf,%eax
80102982:	c1 ea 04             	shr    $0x4,%edx
80102985:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102988:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010298b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010298e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102991:	89 c2                	mov    %eax,%edx
80102993:	83 e0 0f             	and    $0xf,%eax
80102996:	c1 ea 04             	shr    $0x4,%edx
80102999:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029a2:	8b 75 08             	mov    0x8(%ebp),%esi
801029a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029a8:	89 06                	mov    %eax,(%esi)
801029aa:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029ad:	89 46 04             	mov    %eax,0x4(%esi)
801029b0:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b3:	89 46 08             	mov    %eax,0x8(%esi)
801029b6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029b9:	89 46 0c             	mov    %eax,0xc(%esi)
801029bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029bf:	89 46 10             	mov    %eax,0x10(%esi)
801029c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029c8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029d2:	5b                   	pop    %ebx
801029d3:	5e                   	pop    %esi
801029d4:	5f                   	pop    %edi
801029d5:	5d                   	pop    %ebp
801029d6:	c3                   	ret    
801029d7:	66 90                	xchg   %ax,%ax
801029d9:	66 90                	xchg   %ax,%ax
801029db:	66 90                	xchg   %ax,%ax
801029dd:	66 90                	xchg   %ax,%ax
801029df:	90                   	nop

801029e0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029e0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
801029e6:	85 c9                	test   %ecx,%ecx
801029e8:	0f 8e 85 00 00 00    	jle    80102a73 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029ee:	55                   	push   %ebp
801029ef:	89 e5                	mov    %esp,%ebp
801029f1:	57                   	push   %edi
801029f2:	56                   	push   %esi
801029f3:	53                   	push   %ebx
801029f4:	31 db                	xor    %ebx,%ebx
801029f6:	83 ec 0c             	sub    $0xc,%esp
801029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a00:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102a05:	83 ec 08             	sub    $0x8,%esp
80102a08:	01 d8                	add    %ebx,%eax
80102a0a:	83 c0 01             	add    $0x1,%eax
80102a0d:	50                   	push   %eax
80102a0e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102a14:	e8 b7 d6 ff ff       	call   801000d0 <bread>
80102a19:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a1b:	58                   	pop    %eax
80102a1c:	5a                   	pop    %edx
80102a1d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102a24:	ff 35 e4 26 11 80    	pushl  0x801126e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a2a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a2d:	e8 9e d6 ff ff       	call   801000d0 <bread>
80102a32:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a34:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a37:	83 c4 0c             	add    $0xc,%esp
80102a3a:	68 00 02 00 00       	push   $0x200
80102a3f:	50                   	push   %eax
80102a40:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a43:	50                   	push   %eax
80102a44:	e8 b7 1e 00 00       	call   80104900 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a49:	89 34 24             	mov    %esi,(%esp)
80102a4c:	e8 4f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a51:	89 3c 24             	mov    %edi,(%esp)
80102a54:	e8 87 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a59:	89 34 24             	mov    %esi,(%esp)
80102a5c:	e8 7f d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a61:	83 c4 10             	add    $0x10,%esp
80102a64:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102a6a:	7f 94                	jg     80102a00 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a6f:	5b                   	pop    %ebx
80102a70:	5e                   	pop    %esi
80102a71:	5f                   	pop    %edi
80102a72:	5d                   	pop    %ebp
80102a73:	f3 c3                	repz ret 
80102a75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	53                   	push   %ebx
80102a84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a87:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102a8d:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102a93:	e8 38 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a98:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a9e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aa1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102aa3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102aa5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102aa8:	7e 1f                	jle    80102ac9 <write_head+0x49>
80102aaa:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102ab1:	31 d2                	xor    %edx,%edx
80102ab3:	90                   	nop
80102ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ab8:	8b 8a ec 26 11 80    	mov    -0x7feed914(%edx),%ecx
80102abe:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102ac2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ac5:	39 c2                	cmp    %eax,%edx
80102ac7:	75 ef                	jne    80102ab8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102ac9:	83 ec 0c             	sub    $0xc,%esp
80102acc:	53                   	push   %ebx
80102acd:	e8 ce d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ad2:	89 1c 24             	mov    %ebx,(%esp)
80102ad5:	e8 06 d7 ff ff       	call   801001e0 <brelse>
}
80102ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102add:	c9                   	leave  
80102ade:	c3                   	ret    
80102adf:	90                   	nop

80102ae0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	53                   	push   %ebx
80102ae4:	83 ec 2c             	sub    $0x2c,%esp
80102ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aea:	68 3c 78 10 80       	push   $0x8010783c
80102aef:	68 a0 26 11 80       	push   $0x801126a0
80102af4:	e8 07 1b 00 00       	call   80104600 <initlock>
  readsb(dev, &sb);
80102af9:	58                   	pop    %eax
80102afa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102afd:	5a                   	pop    %edx
80102afe:	50                   	push   %eax
80102aff:	53                   	push   %ebx
80102b00:	e8 8b e8 ff ff       	call   80101390 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b05:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b08:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b0b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b0c:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b12:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b18:	a3 d4 26 11 80       	mov    %eax,0x801126d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 ab d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b25:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b28:	83 c4 10             	add    $0x10,%esp
80102b2b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b2d:	89 0d e8 26 11 80    	mov    %ecx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102b33:	7e 1c                	jle    80102b51 <initlog+0x71>
80102b35:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b3c:	31 d2                	xor    %edx,%edx
80102b3e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b40:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b44:	83 c2 04             	add    $0x4,%edx
80102b47:	89 8a e8 26 11 80    	mov    %ecx,-0x7feed918(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b4d:	39 da                	cmp    %ebx,%edx
80102b4f:	75 ef                	jne    80102b40 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b51:	83 ec 0c             	sub    $0xc,%esp
80102b54:	50                   	push   %eax
80102b55:	e8 86 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b5a:	e8 81 fe ff ff       	call   801029e0 <install_trans>
  log.lh.n = 0;
80102b5f:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102b66:	00 00 00 
  write_head(); // clear the log
80102b69:	e8 12 ff ff ff       	call   80102a80 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b71:	c9                   	leave  
80102b72:	c3                   	ret    
80102b73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b86:	68 a0 26 11 80       	push   $0x801126a0
80102b8b:	e8 90 1a 00 00       	call   80104620 <acquire>
80102b90:	83 c4 10             	add    $0x10,%esp
80102b93:	eb 18                	jmp    80102bad <begin_op+0x2d>
80102b95:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b98:	83 ec 08             	sub    $0x8,%esp
80102b9b:	68 a0 26 11 80       	push   $0x801126a0
80102ba0:	68 a0 26 11 80       	push   $0x801126a0
80102ba5:	e8 e6 11 00 00       	call   80103d90 <sleep>
80102baa:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bad:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102bb2:	85 c0                	test   %eax,%eax
80102bb4:	75 e2                	jne    80102b98 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bb6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102bbb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102bc1:	83 c0 01             	add    $0x1,%eax
80102bc4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bc7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bca:	83 fa 1e             	cmp    $0x1e,%edx
80102bcd:	7f c9                	jg     80102b98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bcf:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102bd2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102bd7:	68 a0 26 11 80       	push   $0x801126a0
80102bdc:	e8 1f 1c 00 00       	call   80104800 <release>
      break;
    }
  }
}
80102be1:	83 c4 10             	add    $0x10,%esp
80102be4:	c9                   	leave  
80102be5:	c3                   	ret    
80102be6:	8d 76 00             	lea    0x0(%esi),%esi
80102be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bf0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	57                   	push   %edi
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bf9:	68 a0 26 11 80       	push   $0x801126a0
80102bfe:	e8 1d 1a 00 00       	call   80104620 <acquire>
  log.outstanding -= 1;
80102c03:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102c08:	8b 1d e0 26 11 80    	mov    0x801126e0,%ebx
80102c0e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c11:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c14:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c16:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  if(log.committing)
80102c1b:	0f 85 23 01 00 00    	jne    80102d44 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c21:	85 c0                	test   %eax,%eax
80102c23:	0f 85 f7 00 00 00    	jne    80102d20 <end_op+0x130>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c29:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c2c:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102c33:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c36:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c38:	68 a0 26 11 80       	push   $0x801126a0
80102c3d:	e8 be 1b 00 00       	call   80104800 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c42:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102c48:	83 c4 10             	add    $0x10,%esp
80102c4b:	85 c9                	test   %ecx,%ecx
80102c4d:	0f 8e 8a 00 00 00    	jle    80102cdd <end_op+0xed>
80102c53:	90                   	nop
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c58:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102c5d:	83 ec 08             	sub    $0x8,%esp
80102c60:	01 d8                	add    %ebx,%eax
80102c62:	83 c0 01             	add    $0x1,%eax
80102c65:	50                   	push   %eax
80102c66:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102c6c:	e8 5f d4 ff ff       	call   801000d0 <bread>
80102c71:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c73:	58                   	pop    %eax
80102c74:	5a                   	pop    %edx
80102c75:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102c7c:	ff 35 e4 26 11 80    	pushl  0x801126e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c82:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c85:	e8 46 d4 ff ff       	call   801000d0 <bread>
80102c8a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c8c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c8f:	83 c4 0c             	add    $0xc,%esp
80102c92:	68 00 02 00 00       	push   $0x200
80102c97:	50                   	push   %eax
80102c98:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c9b:	50                   	push   %eax
80102c9c:	e8 5f 1c 00 00       	call   80104900 <memmove>
    bwrite(to);  // write the log
80102ca1:	89 34 24             	mov    %esi,(%esp)
80102ca4:	e8 f7 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ca9:	89 3c 24             	mov    %edi,(%esp)
80102cac:	e8 2f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cb1:	89 34 24             	mov    %esi,(%esp)
80102cb4:	e8 27 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cb9:	83 c4 10             	add    $0x10,%esp
80102cbc:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102cc2:	7c 94                	jl     80102c58 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cc4:	e8 b7 fd ff ff       	call   80102a80 <write_head>
    install_trans(); // Now install writes to home locations
80102cc9:	e8 12 fd ff ff       	call   801029e0 <install_trans>
    log.lh.n = 0;
80102cce:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102cd5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cd8:	e8 a3 fd ff ff       	call   80102a80 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cdd:	83 ec 0c             	sub    $0xc,%esp
80102ce0:	68 a0 26 11 80       	push   $0x801126a0
80102ce5:	e8 36 19 00 00       	call   80104620 <acquire>
    log.committing = 0;
    wakeup(&log);
80102cea:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cf1:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102cf8:	00 00 00 
    wakeup(&log);
80102cfb:	e8 30 12 00 00       	call   80103f30 <wakeup>
    release(&log.lock);
80102d00:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d07:	e8 f4 1a 00 00       	call   80104800 <release>
80102d0c:	83 c4 10             	add    $0x10,%esp
  }
}
80102d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d12:	5b                   	pop    %ebx
80102d13:	5e                   	pop    %esi
80102d14:	5f                   	pop    %edi
80102d15:	5d                   	pop    %ebp
80102d16:	c3                   	ret    
80102d17:	89 f6                	mov    %esi,%esi
80102d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80102d20:	83 ec 0c             	sub    $0xc,%esp
80102d23:	68 a0 26 11 80       	push   $0x801126a0
80102d28:	e8 03 12 00 00       	call   80103f30 <wakeup>
  }
  release(&log.lock);
80102d2d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102d34:	e8 c7 1a 00 00       	call   80104800 <release>
80102d39:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d3f:	5b                   	pop    %ebx
80102d40:	5e                   	pop    %esi
80102d41:	5f                   	pop    %edi
80102d42:	5d                   	pop    %ebp
80102d43:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d44:	83 ec 0c             	sub    $0xc,%esp
80102d47:	68 40 78 10 80       	push   $0x80107840
80102d4c:	e8 1f d6 ff ff       	call   80100370 <panic>
80102d51:	eb 0d                	jmp    80102d60 <log_write>
80102d53:	90                   	nop
80102d54:	90                   	nop
80102d55:	90                   	nop
80102d56:	90                   	nop
80102d57:	90                   	nop
80102d58:	90                   	nop
80102d59:	90                   	nop
80102d5a:	90                   	nop
80102d5b:	90                   	nop
80102d5c:	90                   	nop
80102d5d:	90                   	nop
80102d5e:	90                   	nop
80102d5f:	90                   	nop

80102d60 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	53                   	push   %ebx
80102d64:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d67:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d70:	83 fa 1d             	cmp    $0x1d,%edx
80102d73:	0f 8f 97 00 00 00    	jg     80102e10 <log_write+0xb0>
80102d79:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102d7e:	83 e8 01             	sub    $0x1,%eax
80102d81:	39 c2                	cmp    %eax,%edx
80102d83:	0f 8d 87 00 00 00    	jge    80102e10 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d89:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d8e:	85 c0                	test   %eax,%eax
80102d90:	0f 8e 87 00 00 00    	jle    80102e1d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d96:	83 ec 0c             	sub    $0xc,%esp
80102d99:	68 a0 26 11 80       	push   $0x801126a0
80102d9e:	e8 7d 18 00 00       	call   80104620 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102da3:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102da9:	83 c4 10             	add    $0x10,%esp
80102dac:	83 fa 00             	cmp    $0x0,%edx
80102daf:	7e 50                	jle    80102e01 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102db1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102db4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102db6:	3b 0d ec 26 11 80    	cmp    0x801126ec,%ecx
80102dbc:	75 0b                	jne    80102dc9 <log_write+0x69>
80102dbe:	eb 38                	jmp    80102df8 <log_write+0x98>
80102dc0:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102dc7:	74 2f                	je     80102df8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102dc9:	83 c0 01             	add    $0x1,%eax
80102dcc:	39 d0                	cmp    %edx,%eax
80102dce:	75 f0                	jne    80102dc0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dd0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102dd7:	83 c2 01             	add    $0x1,%edx
80102dda:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
80102de0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102de3:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ded:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dee:	e9 0d 1a 00 00       	jmp    80104800 <release>
80102df3:	90                   	nop
80102df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102df8:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102dff:	eb df                	jmp    80102de0 <log_write+0x80>
80102e01:	8b 43 08             	mov    0x8(%ebx),%eax
80102e04:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80102e09:	75 d5                	jne    80102de0 <log_write+0x80>
80102e0b:	eb ca                	jmp    80102dd7 <log_write+0x77>
80102e0d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e10:	83 ec 0c             	sub    $0xc,%esp
80102e13:	68 4f 78 10 80       	push   $0x8010784f
80102e18:	e8 53 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e1d:	83 ec 0c             	sub    $0xc,%esp
80102e20:	68 65 78 10 80       	push   $0x80107865
80102e25:	e8 46 d5 ff ff       	call   80100370 <panic>
80102e2a:	66 90                	xchg   %ax,%ax
80102e2c:	66 90                	xchg   %ax,%ax
80102e2e:	66 90                	xchg   %ax,%ax

80102e30 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 08             	sub    $0x8,%esp
  idtinit();       // load idt register
80102e36:	e8 f5 2d 00 00       	call   80105c30 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e3b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e42:	b8 01 00 00 00       	mov    $0x1,%eax
80102e47:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e4e:	e8 5d 0c 00 00       	call   80103ab0 <scheduler>
80102e53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e60 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e66:	e8 75 3f 00 00       	call   80106de0 <switchkvm>
  seginit();
80102e6b:	e8 90 3d 00 00       	call   80106c00 <seginit>
  lapicinit();
80102e70:	e8 2b f7 ff ff       	call   801025a0 <lapicinit>
  mpmain();
80102e75:	e8 b6 ff ff ff       	call   80102e30 <mpmain>
80102e7a:	66 90                	xchg   %ax,%ax
80102e7c:	66 90                	xchg   %ax,%ax
80102e7e:	66 90                	xchg   %ax,%ax

80102e80 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e80:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e84:	83 e4 f0             	and    $0xfffffff0,%esp
80102e87:	ff 71 fc             	pushl  -0x4(%ecx)
80102e8a:	55                   	push   %ebp
80102e8b:	89 e5                	mov    %esp,%ebp
80102e8d:	53                   	push   %ebx
80102e8e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e8f:	83 ec 08             	sub    $0x8,%esp
80102e92:	68 00 00 40 80       	push   $0x80400000
80102e97:	68 28 56 11 80       	push   $0x80115628
80102e9c:	e8 cf f4 ff ff       	call   80102370 <kinit1>
  kvmalloc();      // kernel page table
80102ea1:	e8 1a 3f 00 00       	call   80106dc0 <kvmalloc>
  mpinit();        // detect other processors
80102ea6:	e8 a5 01 00 00       	call   80103050 <mpinit>
  lapicinit();     // interrupt controller
80102eab:	e8 f0 f6 ff ff       	call   801025a0 <lapicinit>
  seginit();       // segment descriptors
80102eb0:	e8 4b 3d 00 00       	call   80106c00 <seginit>
  picinit();       // another interrupt controller
80102eb5:	e8 a6 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102eba:	e8 d1 f2 ff ff       	call   80102190 <ioapicinit>
  consoleinit();   // console hardware
80102ebf:	e8 dc da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102ec4:	e8 17 30 00 00       	call   80105ee0 <uartinit>
  pinit();         // process table
80102ec9:	e8 42 09 00 00       	call   80103810 <pinit>
  tvinit();        // trap vectors
80102ece:	e8 bd 2c 00 00       	call   80105b90 <tvinit>
  binit();         // buffer cache
80102ed3:	e8 68 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ed8:	e8 53 de ff ff       	call   80100d30 <fileinit>
  ideinit();       // disk
80102edd:	e8 7e f0 ff ff       	call   80101f60 <ideinit>
  if(!ismp)
80102ee2:	a1 84 27 11 80       	mov    0x80112784,%eax
80102ee7:	83 c4 10             	add    $0x10,%esp
80102eea:	85 c0                	test   %eax,%eax
80102eec:	0f 84 c5 00 00 00    	je     80102fb7 <main+0x137>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ef2:	83 ec 04             	sub    $0x4,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80102ef5:	bb a0 27 11 80       	mov    $0x801127a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102efa:	68 8a 00 00 00       	push   $0x8a
80102eff:	68 8c a4 10 80       	push   $0x8010a48c
80102f04:	68 00 70 00 80       	push   $0x80007000
80102f09:	e8 f2 19 00 00       	call   80104900 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f0e:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f15:	00 00 00 
80102f18:	83 c4 10             	add    $0x10,%esp
80102f1b:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f20:	39 d8                	cmp    %ebx,%eax
80102f22:	76 77                	jbe    80102f9b <main+0x11b>
80102f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80102f28:	e8 73 f7 ff ff       	call   801026a0 <cpunum>
80102f2d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f33:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f38:	39 c3                	cmp    %eax,%ebx
80102f3a:	74 46                	je     80102f82 <main+0x102>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f3c:	e8 ff f4 ff ff       	call   80102440 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f41:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102f46:	c7 05 f8 6f 00 80 60 	movl   $0x80102e60,0x80006ff8
80102f4d:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f50:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f57:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f5a:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f5f:	0f b6 03             	movzbl (%ebx),%eax
80102f62:	83 ec 08             	sub    $0x8,%esp
80102f65:	68 00 70 00 00       	push   $0x7000
80102f6a:	50                   	push   %eax
80102f6b:	e8 00 f8 ff ff       	call   80102770 <lapicstartap>
80102f70:	83 c4 10             	add    $0x10,%esp
80102f73:	90                   	nop
80102f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f78:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102f7e:	85 c0                	test   %eax,%eax
80102f80:	74 f6                	je     80102f78 <main+0xf8>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f82:	69 05 80 2d 11 80 bc 	imul   $0xbc,0x80112d80,%eax
80102f89:	00 00 00 
80102f8c:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102f92:	05 a0 27 11 80       	add    $0x801127a0,%eax
80102f97:	39 c3                	cmp    %eax,%ebx
80102f99:	72 8d                	jb     80102f28 <main+0xa8>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f9b:	83 ec 08             	sub    $0x8,%esp
80102f9e:	68 00 00 00 8e       	push   $0x8e000000
80102fa3:	68 00 00 40 80       	push   $0x80400000
80102fa8:	e8 33 f4 ff ff       	call   801023e0 <kinit2>
  userinit();      // first user process
80102fad:	e8 7e 08 00 00       	call   80103830 <userinit>
  mpmain();        // finish this processor's setup
80102fb2:	e8 79 fe ff ff       	call   80102e30 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80102fb7:	e8 74 2b 00 00       	call   80105b30 <timerinit>
80102fbc:	e9 31 ff ff ff       	jmp    80102ef2 <main+0x72>
80102fc1:	66 90                	xchg   %ax,%ax
80102fc3:	66 90                	xchg   %ax,%ax
80102fc5:	66 90                	xchg   %ax,%ax
80102fc7:	66 90                	xchg   %ax,%ax
80102fc9:	66 90                	xchg   %ax,%ax
80102fcb:	66 90                	xchg   %ax,%ax
80102fcd:	66 90                	xchg   %ax,%ax
80102fcf:	90                   	nop

80102fd0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	57                   	push   %edi
80102fd4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fd5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fdb:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102fdc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fdf:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fe2:	39 de                	cmp    %ebx,%esi
80102fe4:	73 48                	jae    8010302e <mpsearch1+0x5e>
80102fe6:	8d 76 00             	lea    0x0(%esi),%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ff0:	83 ec 04             	sub    $0x4,%esp
80102ff3:	8d 7e 10             	lea    0x10(%esi),%edi
80102ff6:	6a 04                	push   $0x4
80102ff8:	68 80 78 10 80       	push   $0x80107880
80102ffd:	56                   	push   %esi
80102ffe:	e8 9d 18 00 00       	call   801048a0 <memcmp>
80103003:	83 c4 10             	add    $0x10,%esp
80103006:	85 c0                	test   %eax,%eax
80103008:	75 1e                	jne    80103028 <mpsearch1+0x58>
8010300a:	8d 7e 10             	lea    0x10(%esi),%edi
8010300d:	89 f2                	mov    %esi,%edx
8010300f:	31 c9                	xor    %ecx,%ecx
80103011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103018:	0f b6 02             	movzbl (%edx),%eax
8010301b:	83 c2 01             	add    $0x1,%edx
8010301e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103020:	39 fa                	cmp    %edi,%edx
80103022:	75 f4                	jne    80103018 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103024:	84 c9                	test   %cl,%cl
80103026:	74 10                	je     80103038 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103028:	39 fb                	cmp    %edi,%ebx
8010302a:	89 fe                	mov    %edi,%esi
8010302c:	77 c2                	ja     80102ff0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010302e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103031:	31 c0                	xor    %eax,%eax
}
80103033:	5b                   	pop    %ebx
80103034:	5e                   	pop    %esi
80103035:	5f                   	pop    %edi
80103036:	5d                   	pop    %ebp
80103037:	c3                   	ret    
80103038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010303b:	89 f0                	mov    %esi,%eax
8010303d:	5b                   	pop    %ebx
8010303e:	5e                   	pop    %esi
8010303f:	5f                   	pop    %edi
80103040:	5d                   	pop    %ebp
80103041:	c3                   	ret    
80103042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103050 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103059:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103060:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103067:	c1 e0 08             	shl    $0x8,%eax
8010306a:	09 d0                	or     %edx,%eax
8010306c:	c1 e0 04             	shl    $0x4,%eax
8010306f:	85 c0                	test   %eax,%eax
80103071:	75 1b                	jne    8010308e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103073:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010307a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103081:	c1 e0 08             	shl    $0x8,%eax
80103084:	09 d0                	or     %edx,%eax
80103086:	c1 e0 0a             	shl    $0xa,%eax
80103089:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010308e:	ba 00 04 00 00       	mov    $0x400,%edx
80103093:	e8 38 ff ff ff       	call   80102fd0 <mpsearch1>
80103098:	85 c0                	test   %eax,%eax
8010309a:	89 c6                	mov    %eax,%esi
8010309c:	0f 84 66 01 00 00    	je     80103208 <mpinit+0x1b8>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030a2:	8b 5e 04             	mov    0x4(%esi),%ebx
801030a5:	85 db                	test   %ebx,%ebx
801030a7:	0f 84 d6 00 00 00    	je     80103183 <mpinit+0x133>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030ad:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801030b3:	83 ec 04             	sub    $0x4,%esp
801030b6:	6a 04                	push   $0x4
801030b8:	68 85 78 10 80       	push   $0x80107885
801030bd:	50                   	push   %eax
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801030c1:	e8 da 17 00 00       	call   801048a0 <memcmp>
801030c6:	83 c4 10             	add    $0x10,%esp
801030c9:	85 c0                	test   %eax,%eax
801030cb:	0f 85 b2 00 00 00    	jne    80103183 <mpinit+0x133>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801030d1:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030d8:	3c 01                	cmp    $0x1,%al
801030da:	74 08                	je     801030e4 <mpinit+0x94>
801030dc:	3c 04                	cmp    $0x4,%al
801030de:	0f 85 9f 00 00 00    	jne    80103183 <mpinit+0x133>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030e4:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030eb:	85 ff                	test   %edi,%edi
801030ed:	74 1e                	je     8010310d <mpinit+0xbd>
801030ef:	31 d2                	xor    %edx,%edx
801030f1:	31 c0                	xor    %eax,%eax
801030f3:	90                   	nop
801030f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030f8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801030ff:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103100:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103103:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103105:	39 c7                	cmp    %eax,%edi
80103107:	75 ef                	jne    801030f8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103109:	84 d2                	test   %dl,%dl
8010310b:	75 76                	jne    80103183 <mpinit+0x133>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010310d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103110:	85 ff                	test   %edi,%edi
80103112:	74 6f                	je     80103183 <mpinit+0x133>
    return;
  ismp = 1;
80103114:	c7 05 84 27 11 80 01 	movl   $0x1,0x80112784
8010311b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010311e:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103124:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103129:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
80103130:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103136:	01 f9                	add    %edi,%ecx
80103138:	39 c8                	cmp    %ecx,%eax
8010313a:	0f 83 a0 00 00 00    	jae    801031e0 <mpinit+0x190>
    switch(*p){
80103140:	80 38 04             	cmpb   $0x4,(%eax)
80103143:	0f 87 87 00 00 00    	ja     801031d0 <mpinit+0x180>
80103149:	0f b6 10             	movzbl (%eax),%edx
8010314c:	ff 24 95 8c 78 10 80 	jmp    *-0x7fef8774(,%edx,4)
80103153:	90                   	nop
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103158:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315b:	39 c1                	cmp    %eax,%ecx
8010315d:	77 e1                	ja     80103140 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
8010315f:	a1 84 27 11 80       	mov    0x80112784,%eax
80103164:	85 c0                	test   %eax,%eax
80103166:	75 78                	jne    801031e0 <mpinit+0x190>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103168:	c7 05 80 2d 11 80 01 	movl   $0x1,0x80112d80
8010316f:	00 00 00 
    lapic = 0;
80103172:	c7 05 9c 26 11 80 00 	movl   $0x0,0x8011269c
80103179:	00 00 00 
    ioapicid = 0;
8010317c:	c6 05 80 27 11 80 00 	movb   $0x0,0x80112780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103183:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103186:	5b                   	pop    %ebx
80103187:	5e                   	pop    %esi
80103188:	5f                   	pop    %edi
80103189:	5d                   	pop    %ebp
8010318a:	c3                   	ret    
8010318b:	90                   	nop
8010318c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103190:	8b 15 80 2d 11 80    	mov    0x80112d80,%edx
80103196:	83 fa 07             	cmp    $0x7,%edx
80103199:	7f 19                	jg     801031b4 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010319b:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
8010319f:	69 fa bc 00 00 00    	imul   $0xbc,%edx,%edi
        ncpu++;
801031a5:	83 c2 01             	add    $0x1,%edx
801031a8:	89 15 80 2d 11 80    	mov    %edx,0x80112d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031ae:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801031b4:	83 c0 14             	add    $0x14,%eax
      continue;
801031b7:	eb a2                	jmp    8010315b <mpinit+0x10b>
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031c0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031c4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031c7:	88 15 80 27 11 80    	mov    %dl,0x80112780
      p += sizeof(struct mpioapic);
      continue;
801031cd:	eb 8c                	jmp    8010315b <mpinit+0x10b>
801031cf:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031d0:	c7 05 84 27 11 80 00 	movl   $0x0,0x80112784
801031d7:	00 00 00 
      break;
801031da:	e9 7c ff ff ff       	jmp    8010315b <mpinit+0x10b>
801031df:	90                   	nop
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
801031e0:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801031e4:	74 9d                	je     80103183 <mpinit+0x133>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031e6:	ba 22 00 00 00       	mov    $0x22,%edx
801031eb:	b8 70 00 00 00       	mov    $0x70,%eax
801031f0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031f1:	ba 23 00 00 00       	mov    $0x23,%edx
801031f6:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031f7:	83 c8 01             	or     $0x1,%eax
801031fa:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801031fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fe:	5b                   	pop    %ebx
801031ff:	5e                   	pop    %esi
80103200:	5f                   	pop    %edi
80103201:	5d                   	pop    %ebp
80103202:	c3                   	ret    
80103203:	90                   	nop
80103204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103208:	ba 00 00 01 00       	mov    $0x10000,%edx
8010320d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103212:	e8 b9 fd ff ff       	call   80102fd0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103217:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103219:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010321b:	0f 85 81 fe ff ff    	jne    801030a2 <mpinit+0x52>
80103221:	e9 5d ff ff ff       	jmp    80103183 <mpinit+0x133>
80103226:	66 90                	xchg   %ax,%ax
80103228:	66 90                	xchg   %ax,%ax
8010322a:	66 90                	xchg   %ax,%ax
8010322c:	66 90                	xchg   %ax,%ax
8010322e:	66 90                	xchg   %ax,%ax

80103230 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103230:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103231:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103236:	ba 21 00 00 00       	mov    $0x21,%edx
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
8010323b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010323d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103240:	d3 c0                	rol    %cl,%eax
80103242:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103249:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
8010324f:	ee                   	out    %al,(%dx)
80103250:	ba a1 00 00 00       	mov    $0xa1,%edx
80103255:	66 c1 e8 08          	shr    $0x8,%ax
80103259:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
8010325a:	5d                   	pop    %ebp
8010325b:	c3                   	ret    
8010325c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103260 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103260:	55                   	push   %ebp
80103261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103266:	89 e5                	mov    %esp,%ebp
80103268:	57                   	push   %edi
80103269:	56                   	push   %esi
8010326a:	53                   	push   %ebx
8010326b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103270:	89 da                	mov    %ebx,%edx
80103272:	ee                   	out    %al,(%dx)
80103273:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103278:	89 ca                	mov    %ecx,%edx
8010327a:	ee                   	out    %al,(%dx)
8010327b:	bf 11 00 00 00       	mov    $0x11,%edi
80103280:	be 20 00 00 00       	mov    $0x20,%esi
80103285:	89 f8                	mov    %edi,%eax
80103287:	89 f2                	mov    %esi,%edx
80103289:	ee                   	out    %al,(%dx)
8010328a:	b8 20 00 00 00       	mov    $0x20,%eax
8010328f:	89 da                	mov    %ebx,%edx
80103291:	ee                   	out    %al,(%dx)
80103292:	b8 04 00 00 00       	mov    $0x4,%eax
80103297:	ee                   	out    %al,(%dx)
80103298:	b8 03 00 00 00       	mov    $0x3,%eax
8010329d:	ee                   	out    %al,(%dx)
8010329e:	bb a0 00 00 00       	mov    $0xa0,%ebx
801032a3:	89 f8                	mov    %edi,%eax
801032a5:	89 da                	mov    %ebx,%edx
801032a7:	ee                   	out    %al,(%dx)
801032a8:	b8 28 00 00 00       	mov    $0x28,%eax
801032ad:	89 ca                	mov    %ecx,%edx
801032af:	ee                   	out    %al,(%dx)
801032b0:	b8 02 00 00 00       	mov    $0x2,%eax
801032b5:	ee                   	out    %al,(%dx)
801032b6:	b8 03 00 00 00       	mov    $0x3,%eax
801032bb:	ee                   	out    %al,(%dx)
801032bc:	bf 68 00 00 00       	mov    $0x68,%edi
801032c1:	89 f2                	mov    %esi,%edx
801032c3:	89 f8                	mov    %edi,%eax
801032c5:	ee                   	out    %al,(%dx)
801032c6:	b9 0a 00 00 00       	mov    $0xa,%ecx
801032cb:	89 c8                	mov    %ecx,%eax
801032cd:	ee                   	out    %al,(%dx)
801032ce:	89 f8                	mov    %edi,%eax
801032d0:	89 da                	mov    %ebx,%edx
801032d2:	ee                   	out    %al,(%dx)
801032d3:	89 c8                	mov    %ecx,%eax
801032d5:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
801032d6:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
801032dd:	66 83 f8 ff          	cmp    $0xffff,%ax
801032e1:	74 10                	je     801032f3 <picinit+0x93>
801032e3:	ba 21 00 00 00       	mov    $0x21,%edx
801032e8:	ee                   	out    %al,(%dx)
801032e9:	ba a1 00 00 00       	mov    $0xa1,%edx
801032ee:	66 c1 e8 08          	shr    $0x8,%ax
801032f2:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
801032f3:	5b                   	pop    %ebx
801032f4:	5e                   	pop    %esi
801032f5:	5f                   	pop    %edi
801032f6:	5d                   	pop    %ebp
801032f7:	c3                   	ret    
801032f8:	66 90                	xchg   %ax,%ax
801032fa:	66 90                	xchg   %ax,%ax
801032fc:	66 90                	xchg   %ax,%ax
801032fe:	66 90                	xchg   %ax,%ax

80103300 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 0c             	sub    $0xc,%esp
80103309:	8b 75 08             	mov    0x8(%ebp),%esi
8010330c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010330f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103315:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010331b:	e8 30 da ff ff       	call   80100d50 <filealloc>
80103320:	85 c0                	test   %eax,%eax
80103322:	89 06                	mov    %eax,(%esi)
80103324:	0f 84 a8 00 00 00    	je     801033d2 <pipealloc+0xd2>
8010332a:	e8 21 da ff ff       	call   80100d50 <filealloc>
8010332f:	85 c0                	test   %eax,%eax
80103331:	89 03                	mov    %eax,(%ebx)
80103333:	0f 84 87 00 00 00    	je     801033c0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103339:	e8 02 f1 ff ff       	call   80102440 <kalloc>
8010333e:	85 c0                	test   %eax,%eax
80103340:	89 c7                	mov    %eax,%edi
80103342:	0f 84 b0 00 00 00    	je     801033f8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103348:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010334b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103352:	00 00 00 
  p->writeopen = 1;
80103355:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010335c:	00 00 00 
  p->nwrite = 0;
8010335f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103366:	00 00 00 
  p->nread = 0;
80103369:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103370:	00 00 00 
  initlock(&p->lock, "pipe");
80103373:	68 a0 78 10 80       	push   $0x801078a0
80103378:	50                   	push   %eax
80103379:	e8 82 12 00 00       	call   80104600 <initlock>
  (*f0)->type = FD_PIPE;
8010337e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103380:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103383:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103389:	8b 06                	mov    (%esi),%eax
8010338b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010338f:	8b 06                	mov    (%esi),%eax
80103391:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103395:	8b 06                	mov    (%esi),%eax
80103397:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010339a:	8b 03                	mov    (%ebx),%eax
8010339c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033a2:	8b 03                	mov    (%ebx),%eax
801033a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033a8:	8b 03                	mov    (%ebx),%eax
801033aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033ae:	8b 03                	mov    (%ebx),%eax
801033b0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033b6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033b8:	5b                   	pop    %ebx
801033b9:	5e                   	pop    %esi
801033ba:	5f                   	pop    %edi
801033bb:	5d                   	pop    %ebp
801033bc:	c3                   	ret    
801033bd:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033c0:	8b 06                	mov    (%esi),%eax
801033c2:	85 c0                	test   %eax,%eax
801033c4:	74 1e                	je     801033e4 <pipealloc+0xe4>
    fileclose(*f0);
801033c6:	83 ec 0c             	sub    $0xc,%esp
801033c9:	50                   	push   %eax
801033ca:	e8 41 da ff ff       	call   80100e10 <fileclose>
801033cf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801033d2:	8b 03                	mov    (%ebx),%eax
801033d4:	85 c0                	test   %eax,%eax
801033d6:	74 0c                	je     801033e4 <pipealloc+0xe4>
    fileclose(*f1);
801033d8:	83 ec 0c             	sub    $0xc,%esp
801033db:	50                   	push   %eax
801033dc:	e8 2f da ff ff       	call   80100e10 <fileclose>
801033e1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801033e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801033e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801033ec:	5b                   	pop    %ebx
801033ed:	5e                   	pop    %esi
801033ee:	5f                   	pop    %edi
801033ef:	5d                   	pop    %ebp
801033f0:	c3                   	ret    
801033f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033f8:	8b 06                	mov    (%esi),%eax
801033fa:	85 c0                	test   %eax,%eax
801033fc:	75 c8                	jne    801033c6 <pipealloc+0xc6>
801033fe:	eb d2                	jmp    801033d2 <pipealloc+0xd2>

80103400 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	56                   	push   %esi
80103404:	53                   	push   %ebx
80103405:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103408:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010340b:	83 ec 0c             	sub    $0xc,%esp
8010340e:	53                   	push   %ebx
8010340f:	e8 0c 12 00 00       	call   80104620 <acquire>
  if(writable){
80103414:	83 c4 10             	add    $0x10,%esp
80103417:	85 f6                	test   %esi,%esi
80103419:	74 45                	je     80103460 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010341b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103421:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103424:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010342b:	00 00 00 
    wakeup(&p->nread);
8010342e:	50                   	push   %eax
8010342f:	e8 fc 0a 00 00       	call   80103f30 <wakeup>
80103434:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103437:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010343d:	85 d2                	test   %edx,%edx
8010343f:	75 0a                	jne    8010344b <pipeclose+0x4b>
80103441:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103447:	85 c0                	test   %eax,%eax
80103449:	74 35                	je     80103480 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010344b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010344e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103451:	5b                   	pop    %ebx
80103452:	5e                   	pop    %esi
80103453:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103454:	e9 a7 13 00 00       	jmp    80104800 <release>
80103459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103460:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103466:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103469:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103470:	00 00 00 
    wakeup(&p->nwrite);
80103473:	50                   	push   %eax
80103474:	e8 b7 0a 00 00       	call   80103f30 <wakeup>
80103479:	83 c4 10             	add    $0x10,%esp
8010347c:	eb b9                	jmp    80103437 <pipeclose+0x37>
8010347e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	53                   	push   %ebx
80103484:	e8 77 13 00 00       	call   80104800 <release>
    kfree((char*)p);
80103489:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010348c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010348f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103492:	5b                   	pop    %ebx
80103493:	5e                   	pop    %esi
80103494:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103495:	e9 f6 ed ff ff       	jmp    80102290 <kfree>
8010349a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801034a0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 28             	sub    $0x28,%esp
801034a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
801034ac:	57                   	push   %edi
801034ad:	e8 6e 11 00 00       	call   80104620 <acquire>
  for(i = 0; i < n; i++){
801034b2:	8b 45 10             	mov    0x10(%ebp),%eax
801034b5:	83 c4 10             	add    $0x10,%esp
801034b8:	85 c0                	test   %eax,%eax
801034ba:	0f 8e c6 00 00 00    	jle    80103586 <pipewrite+0xe6>
801034c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801034c3:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
801034c9:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
801034cf:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
801034d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034d8:	03 45 10             	add    0x10(%ebp),%eax
801034db:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034de:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801034e4:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801034ea:	39 d1                	cmp    %edx,%ecx
801034ec:	0f 85 cf 00 00 00    	jne    801035c1 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
801034f2:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801034f8:	85 d2                	test   %edx,%edx
801034fa:	0f 84 a8 00 00 00    	je     801035a8 <pipewrite+0x108>
80103500:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103507:	8b 42 24             	mov    0x24(%edx),%eax
8010350a:	85 c0                	test   %eax,%eax
8010350c:	74 25                	je     80103533 <pipewrite+0x93>
8010350e:	e9 95 00 00 00       	jmp    801035a8 <pipewrite+0x108>
80103513:	90                   	nop
80103514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103518:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010351e:	85 c0                	test   %eax,%eax
80103520:	0f 84 82 00 00 00    	je     801035a8 <pipewrite+0x108>
80103526:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010352c:	8b 40 24             	mov    0x24(%eax),%eax
8010352f:	85 c0                	test   %eax,%eax
80103531:	75 75                	jne    801035a8 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103533:	83 ec 0c             	sub    $0xc,%esp
80103536:	56                   	push   %esi
80103537:	e8 f4 09 00 00       	call   80103f30 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010353c:	59                   	pop    %ecx
8010353d:	58                   	pop    %eax
8010353e:	57                   	push   %edi
8010353f:	53                   	push   %ebx
80103540:	e8 4b 08 00 00       	call   80103d90 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103545:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
8010354b:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
80103551:	83 c4 10             	add    $0x10,%esp
80103554:	05 00 02 00 00       	add    $0x200,%eax
80103559:	39 c2                	cmp    %eax,%edx
8010355b:	74 bb                	je     80103518 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010355d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103560:	8d 4a 01             	lea    0x1(%edx),%ecx
80103563:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103567:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010356d:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
80103573:	0f b6 00             	movzbl (%eax),%eax
80103576:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
8010357a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010357d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80103580:	0f 85 58 ff ff ff    	jne    801034de <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103586:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
8010358c:	83 ec 0c             	sub    $0xc,%esp
8010358f:	52                   	push   %edx
80103590:	e8 9b 09 00 00       	call   80103f30 <wakeup>
  release(&p->lock);
80103595:	89 3c 24             	mov    %edi,(%esp)
80103598:	e8 63 12 00 00       	call   80104800 <release>
  return n;
8010359d:	83 c4 10             	add    $0x10,%esp
801035a0:	8b 45 10             	mov    0x10(%ebp),%eax
801035a3:	eb 14                	jmp    801035b9 <pipewrite+0x119>
801035a5:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
801035a8:	83 ec 0c             	sub    $0xc,%esp
801035ab:	57                   	push   %edi
801035ac:	e8 4f 12 00 00       	call   80104800 <release>
        return -1;
801035b1:	83 c4 10             	add    $0x10,%esp
801035b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035bc:	5b                   	pop    %ebx
801035bd:	5e                   	pop    %esi
801035be:	5f                   	pop    %edi
801035bf:	5d                   	pop    %ebp
801035c0:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c1:	89 ca                	mov    %ecx,%edx
801035c3:	eb 98                	jmp    8010355d <pipewrite+0xbd>
801035c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035d0 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 18             	sub    $0x18,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035df:	53                   	push   %ebx
801035e0:	e8 3b 10 00 00       	call   80104620 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035ee:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801035f4:	75 6a                	jne    80103660 <piperead+0x90>
801035f6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801035fc:	85 f6                	test   %esi,%esi
801035fe:	0f 84 cc 00 00 00    	je     801036d0 <piperead+0x100>
80103604:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010360a:	eb 2d                	jmp    80103639 <piperead+0x69>
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103610:	83 ec 08             	sub    $0x8,%esp
80103613:	53                   	push   %ebx
80103614:	56                   	push   %esi
80103615:	e8 76 07 00 00       	call   80103d90 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010361a:	83 c4 10             	add    $0x10,%esp
8010361d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103623:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103629:	75 35                	jne    80103660 <piperead+0x90>
8010362b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103631:	85 d2                	test   %edx,%edx
80103633:	0f 84 97 00 00 00    	je     801036d0 <piperead+0x100>
    if(proc->killed){
80103639:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103640:	8b 4a 24             	mov    0x24(%edx),%ecx
80103643:	85 c9                	test   %ecx,%ecx
80103645:	74 c9                	je     80103610 <piperead+0x40>
      release(&p->lock);
80103647:	83 ec 0c             	sub    $0xc,%esp
8010364a:	53                   	push   %ebx
8010364b:	e8 b0 11 00 00       	call   80104800 <release>
      return -1;
80103650:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103653:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
80103656:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
8010365b:	5b                   	pop    %ebx
8010365c:	5e                   	pop    %esi
8010365d:	5f                   	pop    %edi
8010365e:	5d                   	pop    %ebp
8010365f:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103660:	8b 45 10             	mov    0x10(%ebp),%eax
80103663:	85 c0                	test   %eax,%eax
80103665:	7e 69                	jle    801036d0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103667:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
8010366d:	31 c9                	xor    %ecx,%ecx
8010366f:	eb 15                	jmp    80103686 <piperead+0xb6>
80103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103678:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
8010367e:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
80103684:	74 5a                	je     801036e0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103686:	8d 72 01             	lea    0x1(%edx),%esi
80103689:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010368f:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103695:	0f b6 54 13 34       	movzbl 0x34(%ebx,%edx,1),%edx
8010369a:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010369d:	83 c1 01             	add    $0x1,%ecx
801036a0:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801036a3:	75 d3                	jne    80103678 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036a5:	8d 93 38 02 00 00    	lea    0x238(%ebx),%edx
801036ab:	83 ec 0c             	sub    $0xc,%esp
801036ae:	52                   	push   %edx
801036af:	e8 7c 08 00 00       	call   80103f30 <wakeup>
  release(&p->lock);
801036b4:	89 1c 24             	mov    %ebx,(%esp)
801036b7:	e8 44 11 00 00       	call   80104800 <release>
  return i;
801036bc:	8b 45 10             	mov    0x10(%ebp),%eax
801036bf:	83 c4 10             	add    $0x10,%esp
}
801036c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036c5:	5b                   	pop    %ebx
801036c6:	5e                   	pop    %esi
801036c7:	5f                   	pop    %edi
801036c8:	5d                   	pop    %ebp
801036c9:	c3                   	ret    
801036ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036d0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801036d7:	eb cc                	jmp    801036a5 <piperead+0xd5>
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036e0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801036e3:	eb c0                	jmp    801036a5 <piperead+0xd5>
801036e5:	66 90                	xchg   %ax,%ax
801036e7:	66 90                	xchg   %ax,%ax
801036e9:	66 90                	xchg   %ax,%ax
801036eb:	66 90                	xchg   %ax,%ax
801036ed:	66 90                	xchg   %ax,%ax
801036ef:	90                   	nop

801036f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036f4:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
    static struct proc*
allocproc(void)
{
801036f9:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
801036fc:	68 a0 2d 11 80       	push   $0x80112da0
80103701:	e8 1a 0f 00 00       	call   80104620 <acquire>
80103706:	83 c4 10             	add    $0x10,%esp
80103709:	eb 14                	jmp    8010371f <allocproc+0x2f>
8010370b:	90                   	nop
8010370c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103710:	83 eb 80             	sub    $0xffffff80,%ebx
80103713:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
80103719:	0f 84 81 00 00 00    	je     801037a0 <allocproc+0xb0>
        if(p->state == UNUSED)
8010371f:	8b 43 0c             	mov    0xc(%ebx),%eax
80103722:	85 c0                	test   %eax,%eax
80103724:	75 ea                	jne    80103710 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103726:	a1 08 a0 10 80       	mov    0x8010a008,%eax
    p->niceness = 20;     //default niceness
    release(&ptable.lock);
8010372b:	83 ec 0c             	sub    $0xc,%esp

    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
8010372e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
    p->niceness = 20;     //default niceness
    release(&ptable.lock);
80103735:	68 a0 2d 11 80       	push   $0x80112da0
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
    p->niceness = 20;     //default niceness
8010373a:	c7 43 6c 14 00 00 00 	movl   $0x14,0x6c(%ebx)
    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103741:	8d 50 01             	lea    0x1(%eax),%edx
80103744:	89 43 10             	mov    %eax,0x10(%ebx)
80103747:	89 15 08 a0 10 80    	mov    %edx,0x8010a008
    p->niceness = 20;     //default niceness
    release(&ptable.lock);
8010374d:	e8 ae 10 00 00       	call   80104800 <release>

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
80103752:	e8 e9 ec ff ff       	call   80102440 <kalloc>
80103757:	83 c4 10             	add    $0x10,%esp
8010375a:	85 c0                	test   %eax,%eax
8010375c:	89 43 08             	mov    %eax,0x8(%ebx)
8010375f:	74 56                	je     801037b7 <allocproc+0xc7>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103761:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
80103767:	83 ec 04             	sub    $0x4,%esp
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
8010376a:	05 9c 0f 00 00       	add    $0xf9c,%eax
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
8010376f:	89 53 18             	mov    %edx,0x18(%ebx)
    p->tf = (struct trapframe*)sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;
80103772:	c7 40 14 7e 5b 10 80 	movl   $0x80105b7e,0x14(%eax)

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
80103779:	6a 14                	push   $0x14
8010377b:	6a 00                	push   $0x0
8010377d:	50                   	push   %eax
    // which returns to trapret.
    sp -= 4;
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
8010377e:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103781:	e8 ca 10 00 00       	call   80104850 <memset>
    p->context->eip = (uint)forkret;
80103786:	8b 43 1c             	mov    0x1c(%ebx),%eax

    return p;
80103789:	83 c4 10             	add    $0x10,%esp
    *(uint*)sp = (uint)trapret;

    sp -= sizeof *p->context;
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;
8010378c:	c7 40 10 c0 37 10 80 	movl   $0x801037c0,0x10(%eax)

    return p;
80103793:	89 d8                	mov    %ebx,%eax
}
80103795:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103798:	c9                   	leave  
80103799:	c3                   	ret    
8010379a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if(p->state == UNUSED)
            goto found;

    release(&ptable.lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	68 a0 2d 11 80       	push   $0x80112da0
801037a8:	e8 53 10 00 00       	call   80104800 <release>
    return 0;
801037ad:	83 c4 10             	add    $0x10,%esp
801037b0:	31 c0                	xor    %eax,%eax
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}
801037b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037b5:	c9                   	leave  
801037b6:	c3                   	ret    
    p->niceness = 20;     //default niceness
    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
801037b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
801037be:	eb d5                	jmp    80103795 <allocproc+0xa5>

801037c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
    void
forkret(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
801037c6:	68 a0 2d 11 80       	push   $0x80112da0
801037cb:	e8 30 10 00 00       	call   80104800 <release>

    if (first) {
801037d0:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	85 c0                	test   %eax,%eax
801037da:	75 04                	jne    801037e0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
801037dc:	c9                   	leave  
801037dd:	c3                   	ret    
801037de:	66 90                	xchg   %ax,%ax
    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
801037e0:	83 ec 0c             	sub    $0xc,%esp

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
801037e3:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
801037ea:	00 00 00 
        iinit(ROOTDEV);
801037ed:	6a 01                	push   $0x1
801037ef:	e8 5c dc ff ff       	call   80101450 <iinit>
        initlog(ROOTDEV);
801037f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037fb:	e8 e0 f2 ff ff       	call   80102ae0 <initlog>
80103800:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103803:	c9                   	leave  
80103804:	c3                   	ret    
80103805:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103810 <pinit>:

static void wakeup1(void *chan);

    void
pinit(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103816:	68 a5 78 10 80       	push   $0x801078a5
8010381b:	68 a0 2d 11 80       	push   $0x80112da0
80103820:	e8 db 0d 00 00       	call   80104600 <initlock>
}
80103825:	83 c4 10             	add    $0x10,%esp
80103828:	c9                   	leave  
80103829:	c3                   	ret    
8010382a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103830 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
    void
userinit(void)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	53                   	push   %ebx
80103834:	83 ec 04             	sub    $0x4,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
80103837:	e8 b4 fe ff ff       	call   801036f0 <allocproc>
8010383c:	89 c3                	mov    %eax,%ebx

    initproc = p;
8010383e:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
    if((p->pgdir = setupkvm()) == 0)
80103843:	e8 08 35 00 00       	call   80106d50 <setupkvm>
80103848:	85 c0                	test   %eax,%eax
8010384a:	89 43 04             	mov    %eax,0x4(%ebx)
8010384d:	0f 84 bd 00 00 00    	je     80103910 <userinit+0xe0>
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103853:	83 ec 04             	sub    $0x4,%esp
80103856:	68 2c 00 00 00       	push   $0x2c
8010385b:	68 60 a4 10 80       	push   $0x8010a460
80103860:	50                   	push   %eax
80103861:	e8 6a 36 00 00       	call   80106ed0 <inituvm>
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
80103866:	83 c4 0c             	add    $0xc,%esp

    initproc = p;
    if((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
    p->sz = PGSIZE;
80103869:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
8010386f:	6a 4c                	push   $0x4c
80103871:	6a 00                	push   $0x0
80103873:	ff 73 18             	pushl  0x18(%ebx)
80103876:	e8 d5 0f 00 00       	call   80104850 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010387b:	8b 43 18             	mov    0x18(%ebx),%eax
8010387e:	ba 23 00 00 00       	mov    $0x23,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103883:	b9 2b 00 00 00       	mov    $0x2b,%ecx
    p->tf->ss = p->tf->ds;
    p->tf->eflags = FL_IF;
    p->tf->esp = PGSIZE;
    p->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
80103888:	83 c4 0c             	add    $0xc,%esp
    if((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010388b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010388f:	8b 43 18             	mov    0x18(%ebx),%eax
80103892:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103896:	8b 43 18             	mov    0x18(%ebx),%eax
80103899:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010389d:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
801038a1:	8b 43 18             	mov    0x18(%ebx),%eax
801038a4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038a8:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
801038ac:	8b 43 18             	mov    0x18(%ebx),%eax
801038af:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
801038b6:	8b 43 18             	mov    0x18(%ebx),%eax
801038b9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
801038c0:	8b 43 18             	mov    0x18(%ebx),%eax
801038c3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
801038ca:	8d 43 70             	lea    0x70(%ebx),%eax
801038cd:	6a 10                	push   $0x10
801038cf:	68 c5 78 10 80       	push   $0x801078c5
801038d4:	50                   	push   %eax
801038d5:	e8 76 11 00 00       	call   80104a50 <safestrcpy>
    p->cwd = namei("/");
801038da:	c7 04 24 ce 78 10 80 	movl   $0x801078ce,(%esp)
801038e1:	e8 6a e5 ff ff       	call   80101e50 <namei>
801038e6:	89 43 68             	mov    %eax,0x68(%ebx)

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
801038e9:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801038f0:	e8 2b 0d 00 00       	call   80104620 <acquire>

    p->state = RUNNABLE;
801038f5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

    release(&ptable.lock);
801038fc:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103903:	e8 f8 0e 00 00       	call   80104800 <release>
}
80103908:	83 c4 10             	add    $0x10,%esp
8010390b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010390e:	c9                   	leave  
8010390f:	c3                   	ret    

    p = allocproc();

    initproc = p;
    if((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
80103910:	83 ec 0c             	sub    $0xc,%esp
80103913:	68 ac 78 10 80       	push   $0x801078ac
80103918:	e8 53 ca ff ff       	call   80100370 <panic>
8010391d:	8d 76 00             	lea    0x0(%esi),%esi

80103920 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	83 ec 08             	sub    $0x8,%esp
    uint sz;

    sz = proc->sz;
80103926:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
    int
growproc(int n)
{
8010392d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    uint sz;

    sz = proc->sz;
80103930:	8b 02                	mov    (%edx),%eax
    if(n > 0){
80103932:	83 f9 00             	cmp    $0x0,%ecx
80103935:	7e 39                	jle    80103970 <growproc+0x50>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103937:	83 ec 04             	sub    $0x4,%esp
8010393a:	01 c1                	add    %eax,%ecx
8010393c:	51                   	push   %ecx
8010393d:	50                   	push   %eax
8010393e:	ff 72 04             	pushl  0x4(%edx)
80103941:	e8 ca 36 00 00       	call   80107010 <allocuvm>
80103946:	83 c4 10             	add    $0x10,%esp
80103949:	85 c0                	test   %eax,%eax
8010394b:	74 3b                	je     80103988 <growproc+0x68>
8010394d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
            return -1;
    } else if(n < 0){
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    proc->sz = sz;
80103954:	89 02                	mov    %eax,(%edx)
    switchuvm(proc);
80103956:	83 ec 0c             	sub    $0xc,%esp
80103959:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
80103960:	e8 9b 34 00 00       	call   80106e00 <switchuvm>
    return 0;
80103965:	83 c4 10             	add    $0x10,%esp
80103968:	31 c0                	xor    %eax,%eax
}
8010396a:	c9                   	leave  
8010396b:	c3                   	ret    
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    sz = proc->sz;
    if(n > 0){
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if(n < 0){
80103970:	74 e2                	je     80103954 <growproc+0x34>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103972:	83 ec 04             	sub    $0x4,%esp
80103975:	01 c1                	add    %eax,%ecx
80103977:	51                   	push   %ecx
80103978:	50                   	push   %eax
80103979:	ff 72 04             	pushl  0x4(%edx)
8010397c:	e8 8f 37 00 00       	call   80107110 <deallocuvm>
80103981:	83 c4 10             	add    $0x10,%esp
80103984:	85 c0                	test   %eax,%eax
80103986:	75 c5                	jne    8010394d <growproc+0x2d>
    uint sz;

    sz = proc->sz;
    if(n > 0){
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
            return -1;
80103988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return -1;
    }
    proc->sz = sz;
    switchuvm(proc);
    return 0;
}
8010398d:	c9                   	leave  
8010398e:	c3                   	ret    
8010398f:	90                   	nop

80103990 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
    int
fork(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	57                   	push   %edi
80103994:	56                   	push   %esi
80103995:	53                   	push   %ebx
80103996:	83 ec 0c             	sub    $0xc,%esp
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0){
80103999:	e8 52 fd ff ff       	call   801036f0 <allocproc>
8010399e:	85 c0                	test   %eax,%eax
801039a0:	0f 84 d6 00 00 00    	je     80103a7c <fork+0xec>
801039a6:	89 c3                	mov    %eax,%ebx
        return -1;
    }

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801039a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801039ae:	83 ec 08             	sub    $0x8,%esp
801039b1:	ff 30                	pushl  (%eax)
801039b3:	ff 70 04             	pushl  0x4(%eax)
801039b6:	e8 35 38 00 00       	call   801071f0 <copyuvm>
801039bb:	83 c4 10             	add    $0x10,%esp
801039be:	85 c0                	test   %eax,%eax
801039c0:	89 43 04             	mov    %eax,0x4(%ebx)
801039c3:	0f 84 ba 00 00 00    	je     80103a83 <fork+0xf3>
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = proc->sz;
801039c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    np->parent = proc;
    *np->tf = *proc->tf;
801039cf:	8b 7b 18             	mov    0x18(%ebx),%edi
801039d2:	b9 13 00 00 00       	mov    $0x13,%ecx
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = proc->sz;
801039d7:	8b 00                	mov    (%eax),%eax
801039d9:	89 03                	mov    %eax,(%ebx)
    np->parent = proc;
801039db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801039e1:	89 43 14             	mov    %eax,0x14(%ebx)
    *np->tf = *proc->tf;
801039e4:	8b 70 18             	mov    0x18(%eax),%esi
801039e7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
801039e9:	31 f6                	xor    %esi,%esi
    np->sz = proc->sz;
    np->parent = proc;
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
801039eb:	8b 43 18             	mov    0x18(%ebx),%eax
801039ee:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801039f5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for(i = 0; i < NOFILE; i++)
        if(proc->ofile[i])
80103a00:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103a04:	85 c0                	test   %eax,%eax
80103a06:	74 17                	je     80103a1f <fork+0x8f>
            np->ofile[i] = filedup(proc->ofile[i]);
80103a08:	83 ec 0c             	sub    $0xc,%esp
80103a0b:	50                   	push   %eax
80103a0c:	e8 af d3 ff ff       	call   80100dc0 <filedup>
80103a11:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103a15:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a1c:	83 c4 10             	add    $0x10,%esp
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
80103a1f:	83 c6 01             	add    $0x1,%esi
80103a22:	83 fe 10             	cmp    $0x10,%esi
80103a25:	75 d9                	jne    80103a00 <fork+0x70>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
80103a27:	83 ec 0c             	sub    $0xc,%esp
80103a2a:	ff 72 68             	pushl  0x68(%edx)
80103a2d:	e8 be db ff ff       	call   801015f0 <idup>
80103a32:	89 43 68             	mov    %eax,0x68(%ebx)

    safestrcpy(np->name, proc->name, sizeof(proc->name));
80103a35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a3b:	83 c4 0c             	add    $0xc,%esp
80103a3e:	6a 10                	push   $0x10
80103a40:	83 c0 70             	add    $0x70,%eax
80103a43:	50                   	push   %eax
80103a44:	8d 43 70             	lea    0x70(%ebx),%eax
80103a47:	50                   	push   %eax
80103a48:	e8 03 10 00 00       	call   80104a50 <safestrcpy>

    pid = np->pid;
80103a4d:	8b 73 10             	mov    0x10(%ebx),%esi

    acquire(&ptable.lock);
80103a50:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103a57:	e8 c4 0b 00 00       	call   80104620 <acquire>

    np->state = RUNNABLE;
80103a5c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

    release(&ptable.lock);
80103a63:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103a6a:	e8 91 0d 00 00       	call   80104800 <release>

    return pid;
80103a6f:	83 c4 10             	add    $0x10,%esp
80103a72:	89 f0                	mov    %esi,%eax
}
80103a74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a77:	5b                   	pop    %ebx
80103a78:	5e                   	pop    %esi
80103a79:	5f                   	pop    %edi
80103a7a:	5d                   	pop    %ebp
80103a7b:	c3                   	ret    
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0){
        return -1;
80103a7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a81:	eb f1                	jmp    80103a74 <fork+0xe4>
    }

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
        kfree(np->kstack);
80103a83:	83 ec 0c             	sub    $0xc,%esp
80103a86:	ff 73 08             	pushl  0x8(%ebx)
80103a89:	e8 02 e8 ff ff       	call   80102290 <kfree>
        np->kstack = 0;
80103a8e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
80103a95:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
80103a9c:	83 c4 10             	add    $0x10,%esp
80103a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aa4:	eb ce                	jmp    80103a74 <fork+0xe4>
80103aa6:	8d 76 00             	lea    0x0(%esi),%esi
80103aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ab0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
    void
scheduler(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
80103ab4:	83 ec 04             	sub    $0x4,%esp
80103ab7:	89 f6                	mov    %esi,%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ac0:	fb                   	sti    
    for(;;){
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103ac1:	83 ec 0c             	sub    $0xc,%esp
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ac4:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
    for(;;){
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103ac9:	68 a0 2d 11 80       	push   $0x80112da0
80103ace:	e8 4d 0b 00 00       	call   80104620 <acquire>
80103ad3:	83 c4 10             	add    $0x10,%esp
80103ad6:	eb 13                	jmp    80103aeb <scheduler+0x3b>
80103ad8:	90                   	nop
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae0:	83 eb 80             	sub    $0xffffff80,%ebx
80103ae3:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
80103ae9:	74 55                	je     80103b40 <scheduler+0x90>
            if(p->state != RUNNABLE)
80103aeb:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103aef:	75 ef                	jne    80103ae0 <scheduler+0x30>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
            switchuvm(p);
80103af1:	83 ec 0c             	sub    $0xc,%esp
                continue;

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
80103af4:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
            switchuvm(p);
80103afb:	53                   	push   %ebx
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103afc:	83 eb 80             	sub    $0xffffff80,%ebx

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
            switchuvm(p);
80103aff:	e8 fc 32 00 00       	call   80106e00 <switchuvm>
            p->state = RUNNING;
            swtch(&cpu->scheduler, p->context);
80103b04:	58                   	pop    %eax
80103b05:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            proc = p;
            switchuvm(p);
            p->state = RUNNING;
80103b0b:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)
            swtch(&cpu->scheduler, p->context);
80103b12:	5a                   	pop    %edx
80103b13:	ff 73 9c             	pushl  -0x64(%ebx)
80103b16:	83 c0 04             	add    $0x4,%eax
80103b19:	50                   	push   %eax
80103b1a:	e8 8c 0f 00 00       	call   80104aab <swtch>
            switchkvm();
80103b1f:	e8 bc 32 00 00       	call   80106de0 <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
80103b24:	83 c4 10             	add    $0x10,%esp
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b27:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
            swtch(&cpu->scheduler, p->context);
            switchkvm();

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
80103b2d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103b34:	00 00 00 00 
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b38:	75 b1                	jne    80103aeb <scheduler+0x3b>
80103b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
        }
        release(&ptable.lock);
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	68 a0 2d 11 80       	push   $0x80112da0
80103b48:	e8 b3 0c 00 00       	call   80104800 <release>

    }
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	e9 6b ff ff ff       	jmp    80103ac0 <scheduler+0x10>
80103b55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b60 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
    void
sched(void)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 10             	sub    $0x10,%esp
    int intena;

    if(!holding(&ptable.lock))
80103b67:	68 a0 2d 11 80       	push   $0x80112da0
80103b6c:	e8 df 0b 00 00       	call   80104750 <holding>
80103b71:	83 c4 10             	add    $0x10,%esp
80103b74:	85 c0                	test   %eax,%eax
80103b76:	74 4c                	je     80103bc4 <sched+0x64>
        panic("sched ptable.lock");
    if(cpu->ncli != 1)
80103b78:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103b7f:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103b86:	75 63                	jne    80103beb <sched+0x8b>
        panic("sched locks");
    if(proc->state == RUNNING)
80103b88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b8e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103b92:	74 4a                	je     80103bde <sched+0x7e>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b94:	9c                   	pushf  
80103b95:	59                   	pop    %ecx
        panic("sched running");
    if(readeflags()&FL_IF)
80103b96:	80 e5 02             	and    $0x2,%ch
80103b99:	75 36                	jne    80103bd1 <sched+0x71>
        panic("sched interruptible");
    intena = cpu->intena;
    swtch(&proc->context, cpu->scheduler);
80103b9b:	83 ec 08             	sub    $0x8,%esp
80103b9e:	83 c0 1c             	add    $0x1c,%eax
        panic("sched locks");
    if(proc->state == RUNNING)
        panic("sched running");
    if(readeflags()&FL_IF)
        panic("sched interruptible");
    intena = cpu->intena;
80103ba1:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
    swtch(&proc->context, cpu->scheduler);
80103ba7:	ff 72 04             	pushl  0x4(%edx)
80103baa:	50                   	push   %eax
80103bab:	e8 fb 0e 00 00       	call   80104aab <swtch>
    cpu->intena = intena;
80103bb0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80103bb6:	83 c4 10             	add    $0x10,%esp
        panic("sched running");
    if(readeflags()&FL_IF)
        panic("sched interruptible");
    intena = cpu->intena;
    swtch(&proc->context, cpu->scheduler);
    cpu->intena = intena;
80103bb9:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103bbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc2:	c9                   	leave  
80103bc3:	c3                   	ret    
sched(void)
{
    int intena;

    if(!holding(&ptable.lock))
        panic("sched ptable.lock");
80103bc4:	83 ec 0c             	sub    $0xc,%esp
80103bc7:	68 d0 78 10 80       	push   $0x801078d0
80103bcc:	e8 9f c7 ff ff       	call   80100370 <panic>
    if(cpu->ncli != 1)
        panic("sched locks");
    if(proc->state == RUNNING)
        panic("sched running");
    if(readeflags()&FL_IF)
        panic("sched interruptible");
80103bd1:	83 ec 0c             	sub    $0xc,%esp
80103bd4:	68 fc 78 10 80       	push   $0x801078fc
80103bd9:	e8 92 c7 ff ff       	call   80100370 <panic>
    if(!holding(&ptable.lock))
        panic("sched ptable.lock");
    if(cpu->ncli != 1)
        panic("sched locks");
    if(proc->state == RUNNING)
        panic("sched running");
80103bde:	83 ec 0c             	sub    $0xc,%esp
80103be1:	68 ee 78 10 80       	push   $0x801078ee
80103be6:	e8 85 c7 ff ff       	call   80100370 <panic>
    int intena;

    if(!holding(&ptable.lock))
        panic("sched ptable.lock");
    if(cpu->ncli != 1)
        panic("sched locks");
80103beb:	83 ec 0c             	sub    $0xc,%esp
80103bee:	68 e2 78 10 80       	push   $0x801078e2
80103bf3:	e8 78 c7 ff ff       	call   80100370 <panic>
80103bf8:	90                   	nop
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c00 <exit>:
exit(void)
{
    struct proc *p;
    int fd;

    if(proc == initproc)
80103c00:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c07:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
    void
exit(void)
{
80103c0d:	55                   	push   %ebp
80103c0e:	89 e5                	mov    %esp,%ebp
80103c10:	56                   	push   %esi
80103c11:	53                   	push   %ebx
    struct proc *p;
    int fd;

    if(proc == initproc)
80103c12:	0f 84 1f 01 00 00    	je     80103d37 <exit+0x137>
80103c18:	31 db                	xor    %ebx,%ebx
80103c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
        if(proc->ofile[fd]){
80103c20:	8d 73 08             	lea    0x8(%ebx),%esi
80103c23:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103c27:	85 c0                	test   %eax,%eax
80103c29:	74 1b                	je     80103c46 <exit+0x46>
            fileclose(proc->ofile[fd]);
80103c2b:	83 ec 0c             	sub    $0xc,%esp
80103c2e:	50                   	push   %eax
80103c2f:	e8 dc d1 ff ff       	call   80100e10 <fileclose>
            proc->ofile[fd] = 0;
80103c34:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c3b:	83 c4 10             	add    $0x10,%esp
80103c3e:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103c45:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80103c46:	83 c3 01             	add    $0x1,%ebx
80103c49:	83 fb 10             	cmp    $0x10,%ebx
80103c4c:	75 d2                	jne    80103c20 <exit+0x20>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    begin_op();
80103c4e:	e8 2d ef ff ff       	call   80102b80 <begin_op>
    iput(proc->cwd);
80103c53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c59:	83 ec 0c             	sub    $0xc,%esp
80103c5c:	ff 70 68             	pushl  0x68(%eax)
80103c5f:	e8 ec da ff ff       	call   80101750 <iput>
    end_op();
80103c64:	e8 87 ef ff ff       	call   80102bf0 <end_op>
    proc->cwd = 0;
80103c69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c6f:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80103c76:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103c7d:	e8 9e 09 00 00       	call   80104620 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80103c82:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80103c89:	83 c4 10             	add    $0x10,%esp
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c8c:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
    proc->cwd = 0;

    acquire(&ptable.lock);

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80103c91:	8b 51 14             	mov    0x14(%ecx),%edx
80103c94:	eb 14                	jmp    80103caa <exit+0xaa>
80103c96:	8d 76 00             	lea    0x0(%esi),%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ca0:	83 e8 80             	sub    $0xffffff80,%eax
80103ca3:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103ca8:	74 1c                	je     80103cc6 <exit+0xc6>
        if(p->state == SLEEPING && p->chan == chan)
80103caa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cae:	75 f0                	jne    80103ca0 <exit+0xa0>
80103cb0:	3b 50 20             	cmp    0x20(%eax),%edx
80103cb3:	75 eb                	jne    80103ca0 <exit+0xa0>
            p->state = RUNNABLE;
80103cb5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cbc:	83 e8 80             	sub    $0xffffff80,%eax
80103cbf:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103cc4:	75 e4                	jne    80103caa <exit+0xaa>
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent == proc){
            p->parent = initproc;
80103cc6:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103ccc:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80103cd1:	eb 10                	jmp    80103ce3 <exit+0xe3>
80103cd3:	90                   	nop
80103cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cd8:	83 ea 80             	sub    $0xffffff80,%edx
80103cdb:	81 fa d4 4d 11 80    	cmp    $0x80114dd4,%edx
80103ce1:	74 3b                	je     80103d1e <exit+0x11e>
        if(p->parent == proc){
80103ce3:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103ce6:	75 f0                	jne    80103cd8 <exit+0xd8>
            p->parent = initproc;
            if(p->state == ZOMBIE)
80103ce8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
    wakeup1(proc->parent);

    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent == proc){
            p->parent = initproc;
80103cec:	89 5a 14             	mov    %ebx,0x14(%edx)
            if(p->state == ZOMBIE)
80103cef:	75 e7                	jne    80103cd8 <exit+0xd8>
80103cf1:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103cf6:	eb 12                	jmp    80103d0a <exit+0x10a>
80103cf8:	90                   	nop
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d00:	83 e8 80             	sub    $0xffffff80,%eax
80103d03:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103d08:	74 ce                	je     80103cd8 <exit+0xd8>
        if(p->state == SLEEPING && p->chan == chan)
80103d0a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d0e:	75 f0                	jne    80103d00 <exit+0x100>
80103d10:	3b 58 20             	cmp    0x20(%eax),%ebx
80103d13:	75 eb                	jne    80103d00 <exit+0x100>
            p->state = RUNNABLE;
80103d15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d1c:	eb e2                	jmp    80103d00 <exit+0x100>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
80103d1e:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
    sched();
80103d25:	e8 36 fe ff ff       	call   80103b60 <sched>
    panic("zombie exit");
80103d2a:	83 ec 0c             	sub    $0xc,%esp
80103d2d:	68 1d 79 10 80       	push   $0x8010791d
80103d32:	e8 39 c6 ff ff       	call   80100370 <panic>
{
    struct proc *p;
    int fd;

    if(proc == initproc)
        panic("init exiting");
80103d37:	83 ec 0c             	sub    $0xc,%esp
80103d3a:	68 10 79 10 80       	push   $0x80107910
80103d3f:	e8 2c c6 ff ff       	call   80100370 <panic>
80103d44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d50 <yield>:
}

// Give up the CPU for one scheduling round.
    void
yield(void)
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	83 ec 14             	sub    $0x14,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80103d56:	68 a0 2d 11 80       	push   $0x80112da0
80103d5b:	e8 c0 08 00 00       	call   80104620 <acquire>
    proc->state = RUNNABLE;
80103d60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d66:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
80103d6d:	e8 ee fd ff ff       	call   80103b60 <sched>
    release(&ptable.lock);
80103d72:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103d79:	e8 82 0a 00 00       	call   80104800 <release>
}
80103d7e:	83 c4 10             	add    $0x10,%esp
80103d81:	c9                   	leave  
80103d82:	c3                   	ret    
80103d83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d90 <sleep>:
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
    if(proc == 0)
80103d90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
80103d96:	55                   	push   %ebp
80103d97:	89 e5                	mov    %esp,%ebp
80103d99:	56                   	push   %esi
80103d9a:	53                   	push   %ebx
    if(proc == 0)
80103d9b:	85 c0                	test   %eax,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
80103d9d:	8b 75 08             	mov    0x8(%ebp),%esi
80103da0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if(proc == 0)
80103da3:	0f 84 97 00 00 00    	je     80103e40 <sleep+0xb0>
        panic("sleep");

    if(lk == 0)
80103da9:	85 db                	test   %ebx,%ebx
80103dab:	0f 84 82 00 00 00    	je     80103e33 <sleep+0xa3>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
80103db1:	81 fb a0 2d 11 80    	cmp    $0x80112da0,%ebx
80103db7:	74 57                	je     80103e10 <sleep+0x80>
        acquire(&ptable.lock);  //DOC: sleeplock1
80103db9:	83 ec 0c             	sub    $0xc,%esp
80103dbc:	68 a0 2d 11 80       	push   $0x80112da0
80103dc1:	e8 5a 08 00 00       	call   80104620 <acquire>
        release(lk);
80103dc6:	89 1c 24             	mov    %ebx,(%esp)
80103dc9:	e8 32 0a 00 00       	call   80104800 <release>
    }

    // Go to sleep.
    proc->chan = chan;
80103dce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dd4:	89 70 20             	mov    %esi,0x20(%eax)
    proc->state = SLEEPING;
80103dd7:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    sched();
80103dde:	e8 7d fd ff ff       	call   80103b60 <sched>

    // Tidy up.
    proc->chan = 0;
80103de3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103de9:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
        release(&ptable.lock);
80103df0:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103df7:	e8 04 0a 00 00       	call   80104800 <release>
        acquire(lk);
80103dfc:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103dff:	83 c4 10             	add    $0x10,%esp
    }
}
80103e02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e05:	5b                   	pop    %ebx
80103e06:	5e                   	pop    %esi
80103e07:	5d                   	pop    %ebp
    proc->chan = 0;

    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
80103e08:	e9 13 08 00 00       	jmp    80104620 <acquire>
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }

    // Go to sleep.
    proc->chan = chan;
80103e10:	89 70 20             	mov    %esi,0x20(%eax)
    proc->state = SLEEPING;
80103e13:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    sched();
80103e1a:	e8 41 fd ff ff       	call   80103b60 <sched>

    // Tidy up.
    proc->chan = 0;
80103e1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e25:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}
80103e2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e2f:	5b                   	pop    %ebx
80103e30:	5e                   	pop    %esi
80103e31:	5d                   	pop    %ebp
80103e32:	c3                   	ret    
{
    if(proc == 0)
        panic("sleep");

    if(lk == 0)
        panic("sleep without lk");
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	68 2f 79 10 80       	push   $0x8010792f
80103e3b:	e8 30 c5 ff ff       	call   80100370 <panic>
// Reacquires lock when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
    if(proc == 0)
        panic("sleep");
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	68 29 79 10 80       	push   $0x80107929
80103e48:	e8 23 c5 ff ff       	call   80100370 <panic>
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi

80103e50 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
    int
wait(void)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	56                   	push   %esi
80103e54:	53                   	push   %ebx
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
80103e55:	83 ec 0c             	sub    $0xc,%esp
80103e58:	68 a0 2d 11 80       	push   $0x80112da0
80103e5d:	e8 be 07 00 00       	call   80104620 <acquire>
80103e62:	83 c4 10             	add    $0x10,%esp
80103e65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
80103e6b:	31 d2                	xor    %edx,%edx
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e6d:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80103e72:	eb 0f                	jmp    80103e83 <wait+0x33>
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e78:	83 eb 80             	sub    $0xffffff80,%ebx
80103e7b:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
80103e81:	74 1d                	je     80103ea0 <wait+0x50>
            if(p->parent != proc)
80103e83:	3b 43 14             	cmp    0x14(%ebx),%eax
80103e86:	75 f0                	jne    80103e78 <wait+0x28>
                continue;
            havekids = 1;
            if(p->state == ZOMBIE){
80103e88:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e8c:	74 30                	je     80103ebe <wait+0x6e>

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8e:	83 eb 80             	sub    $0xffffff80,%ebx
            if(p->parent != proc)
                continue;
            havekids = 1;
80103e91:	ba 01 00 00 00       	mov    $0x1,%edx

    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e96:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
80103e9c:	75 e5                	jne    80103e83 <wait+0x33>
80103e9e:	66 90                	xchg   %ax,%ax
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
80103ea0:	85 d2                	test   %edx,%edx
80103ea2:	74 70                	je     80103f14 <wait+0xc4>
80103ea4:	8b 50 24             	mov    0x24(%eax),%edx
80103ea7:	85 d2                	test   %edx,%edx
80103ea9:	75 69                	jne    80103f14 <wait+0xc4>
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103eab:	83 ec 08             	sub    $0x8,%esp
80103eae:	68 a0 2d 11 80       	push   $0x80112da0
80103eb3:	50                   	push   %eax
80103eb4:	e8 d7 fe ff ff       	call   80103d90 <sleep>
    }
80103eb9:	83 c4 10             	add    $0x10,%esp
80103ebc:	eb a7                	jmp    80103e65 <wait+0x15>
                continue;
            havekids = 1;
            if(p->state == ZOMBIE){
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
80103ebe:	83 ec 0c             	sub    $0xc,%esp
80103ec1:	ff 73 08             	pushl  0x8(%ebx)
            if(p->parent != proc)
                continue;
            havekids = 1;
            if(p->state == ZOMBIE){
                // Found one.
                pid = p->pid;
80103ec4:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80103ec7:	e8 c4 e3 ff ff       	call   80102290 <kfree>
                p->kstack = 0;
                freevm(p->pgdir);
80103ecc:	59                   	pop    %ecx
80103ecd:	ff 73 04             	pushl  0x4(%ebx)
            havekids = 1;
            if(p->state == ZOMBIE){
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
80103ed0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80103ed7:	e8 64 32 00 00       	call   80107140 <freevm>
                p->pid = 0;
80103edc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80103ee3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80103eea:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
                p->killed = 0;
80103eee:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80103ef5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
80103efc:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f03:	e8 f8 08 00 00       	call   80104800 <release>
                return pid;
80103f08:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}
80103f0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                release(&ptable.lock);
                return pid;
80103f0e:	89 f0                	mov    %esi,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}
80103f10:	5b                   	pop    %ebx
80103f11:	5e                   	pop    %esi
80103f12:	5d                   	pop    %ebp
80103f13:	c3                   	ret    
            }
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
            release(&ptable.lock);
80103f14:	83 ec 0c             	sub    $0xc,%esp
80103f17:	68 a0 2d 11 80       	push   $0x80112da0
80103f1c:	e8 df 08 00 00       	call   80104800 <release>
            return -1;
80103f21:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}
80103f24:	8d 65 f8             	lea    -0x8(%ebp),%esp
        }

        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
            release(&ptable.lock);
            return -1;
80103f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}
80103f2c:	5b                   	pop    %ebx
80103f2d:	5e                   	pop    %esi
80103f2e:	5d                   	pop    %ebp
80103f2f:	c3                   	ret    

80103f30 <wakeup>:
}

// Wake up all processes sleeping on chan.
    void
wakeup(void *chan)
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	53                   	push   %ebx
80103f34:	83 ec 10             	sub    $0x10,%esp
80103f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
80103f3a:	68 a0 2d 11 80       	push   $0x80112da0
80103f3f:	e8 dc 06 00 00       	call   80104620 <acquire>
80103f44:	83 c4 10             	add    $0x10,%esp
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f47:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103f4c:	eb 0c                	jmp    80103f5a <wakeup+0x2a>
80103f4e:	66 90                	xchg   %ax,%ax
80103f50:	83 e8 80             	sub    $0xffffff80,%eax
80103f53:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103f58:	74 1c                	je     80103f76 <wakeup+0x46>
        if(p->state == SLEEPING && p->chan == chan)
80103f5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f5e:	75 f0                	jne    80103f50 <wakeup+0x20>
80103f60:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f63:	75 eb                	jne    80103f50 <wakeup+0x20>
            p->state = RUNNABLE;
80103f65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    static void
wakeup1(void *chan)
{
    struct proc *p;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f6c:	83 e8 80             	sub    $0xffffff80,%eax
80103f6f:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103f74:	75 e4                	jne    80103f5a <wakeup+0x2a>
    void
wakeup(void *chan)
{
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
80103f76:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80103f7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f80:	c9                   	leave  
    void
wakeup(void *chan)
{
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
80103f81:	e9 7a 08 00 00       	jmp    80104800 <release>
80103f86:	8d 76 00             	lea    0x0(%esi),%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
    int
kill(int pid)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	53                   	push   %ebx
80103f94:	83 ec 10             	sub    $0x10,%esp
80103f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
80103f9a:	68 a0 2d 11 80       	push   $0x80112da0
80103f9f:	e8 7c 06 00 00       	call   80104620 <acquire>
80103fa4:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa7:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80103fac:	eb 0c                	jmp    80103fba <kill+0x2a>
80103fae:	66 90                	xchg   %ax,%ax
80103fb0:	83 e8 80             	sub    $0xffffff80,%eax
80103fb3:	3d d4 4d 11 80       	cmp    $0x80114dd4,%eax
80103fb8:	74 3e                	je     80103ff8 <kill+0x68>
        if(p->pid == pid){
80103fba:	39 58 10             	cmp    %ebx,0x10(%eax)
80103fbd:	75 f1                	jne    80103fb0 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
80103fbf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
    struct proc *p;

    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->pid == pid){
            p->killed = 1;
80103fc3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
80103fca:	74 1c                	je     80103fe8 <kill+0x58>
                p->state = RUNNABLE;
            release(&ptable.lock);
80103fcc:	83 ec 0c             	sub    $0xc,%esp
80103fcf:	68 a0 2d 11 80       	push   $0x80112da0
80103fd4:	e8 27 08 00 00       	call   80104800 <release>
            return 0;
80103fd9:	83 c4 10             	add    $0x10,%esp
80103fdc:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80103fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fe1:	c9                   	leave  
80103fe2:	c3                   	ret    
80103fe3:	90                   	nop
80103fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->pid == pid){
            p->killed = 1;
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING)
                p->state = RUNNABLE;
80103fe8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fef:	eb db                	jmp    80103fcc <kill+0x3c>
80103ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
80103ff8:	83 ec 0c             	sub    $0xc,%esp
80103ffb:	68 a0 2d 11 80       	push   $0x80112da0
80104000:	e8 fb 07 00 00       	call   80104800 <release>
    return -1;
80104005:	83 c4 10             	add    $0x10,%esp
80104008:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010400d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104010:	c9                   	leave  
80104011:	c3                   	ret    
80104012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104020 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	57                   	push   %edi
80104024:	56                   	push   %esi
80104025:	53                   	push   %ebx
80104026:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104029:	bb 44 2e 11 80       	mov    $0x80112e44,%ebx
8010402e:	83 ec 3c             	sub    $0x3c,%esp
80104031:	eb 24                	jmp    80104057 <procdump+0x37>
80104033:	90                   	nop
80104034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104038:	83 ec 0c             	sub    $0xc,%esp
8010403b:	68 2f 7d 10 80       	push   $0x80107d2f
80104040:	e8 1b c6 ff ff       	call   80100660 <cprintf>
80104045:	83 c4 10             	add    $0x10,%esp
80104048:	83 eb 80             	sub    $0xffffff80,%ebx
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010404b:	81 fb 44 4e 11 80    	cmp    $0x80114e44,%ebx
80104051:	0f 84 81 00 00 00    	je     801040d8 <procdump+0xb8>
        if(p->state == UNUSED)
80104057:	8b 43 9c             	mov    -0x64(%ebx),%eax
8010405a:	85 c0                	test   %eax,%eax
8010405c:	74 ea                	je     80104048 <procdump+0x28>
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010405e:	83 f8 05             	cmp    $0x5,%eax
            state = states[p->state];
        else
            state = "???";
80104061:	ba 40 79 10 80       	mov    $0x80107940,%edx
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104066:	77 11                	ja     80104079 <procdump+0x59>
80104068:	8b 14 85 10 7a 10 80 	mov    -0x7fef85f0(,%eax,4),%edx
            state = states[p->state];
        else
            state = "???";
8010406f:	b8 40 79 10 80       	mov    $0x80107940,%eax
80104074:	85 d2                	test   %edx,%edx
80104076:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80104079:	53                   	push   %ebx
8010407a:	52                   	push   %edx
8010407b:	ff 73 a0             	pushl  -0x60(%ebx)
8010407e:	68 44 79 10 80       	push   $0x80107944
80104083:	e8 d8 c5 ff ff       	call   80100660 <cprintf>
        if(p->state == SLEEPING){
80104088:	83 c4 10             	add    $0x10,%esp
8010408b:	83 7b 9c 02          	cmpl   $0x2,-0x64(%ebx)
8010408f:	75 a7                	jne    80104038 <procdump+0x18>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80104091:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104094:	83 ec 08             	sub    $0x8,%esp
80104097:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010409a:	50                   	push   %eax
8010409b:	8b 43 ac             	mov    -0x54(%ebx),%eax
8010409e:	8b 40 0c             	mov    0xc(%eax),%eax
801040a1:	83 c0 08             	add    $0x8,%eax
801040a4:	50                   	push   %eax
801040a5:	e8 46 06 00 00       	call   801046f0 <getcallerpcs>
801040aa:	83 c4 10             	add    $0x10,%esp
801040ad:	8d 76 00             	lea    0x0(%esi),%esi
            for(i=0; i<10 && pc[i] != 0; i++)
801040b0:	8b 17                	mov    (%edi),%edx
801040b2:	85 d2                	test   %edx,%edx
801040b4:	74 82                	je     80104038 <procdump+0x18>
                cprintf(" %p", pc[i]);
801040b6:	83 ec 08             	sub    $0x8,%esp
801040b9:	83 c7 04             	add    $0x4,%edi
801040bc:	52                   	push   %edx
801040bd:	68 09 74 10 80       	push   $0x80107409
801040c2:	e8 99 c5 ff ff       	call   80100660 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
801040c7:	83 c4 10             	add    $0x10,%esp
801040ca:	39 f7                	cmp    %esi,%edi
801040cc:	75 e2                	jne    801040b0 <procdump+0x90>
801040ce:	e9 65 ff ff ff       	jmp    80104038 <procdump+0x18>
801040d3:	90                   	nop
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
801040d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040db:	5b                   	pop    %ebx
801040dc:	5e                   	pop    %esi
801040dd:	5f                   	pop    %edi
801040de:	5d                   	pop    %ebp
801040df:	c3                   	ret    

801040e0 <ps>:




// new system calls
void ps(int pid){
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	57                   	push   %edi
801040e4:	56                   	push   %esi
801040e5:	53                   	push   %ebx
801040e6:	83 ec 18             	sub    $0x18,%esp
801040e9:	8b 75 08             	mov    0x8(%ebp),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
801040ec:	fb                   	sti    
    struct proc *p;
    sti();
    acquire(&ptable.lock);
801040ed:	68 a0 2d 11 80       	push   $0x80112da0
801040f2:	bb 44 2e 11 80       	mov    $0x80112e44,%ebx
801040f7:	e8 24 05 00 00       	call   80104620 <acquire>
    if(pid == 0){
801040fc:	83 c4 10             	add    $0x10,%esp
801040ff:	85 f6                	test   %esi,%esi
80104101:	0f 84 96 00 00 00    	je     8010419d <ps+0xbd>
80104107:	bf 44 4e 11 80       	mov    $0x80114e44,%edi
8010410c:	eb 09                	jmp    80104117 <ps+0x37>
8010410e:	66 90                	xchg   %ax,%ax
80104110:	83 eb 80             	sub    $0xffffff80,%ebx
            else if(p->state == EMBRYO)
                cprintf("%d %d EMBRYO %s\n",p->pid, p->niceness, p->name);

        }
    }else{
        for(p = ptable.proc ; p<&ptable.proc[NPROC];p++){
80104113:	39 df                	cmp    %ebx,%edi
80104115:	74 52                	je     80104169 <ps+0x89>
            if(p->pid == pid){
80104117:	3b 73 a0             	cmp    -0x60(%ebx),%esi
8010411a:	75 f4                	jne    80104110 <ps+0x30>
                if(p->state == SLEEPING)
8010411c:	8b 43 9c             	mov    -0x64(%ebx),%eax
8010411f:	83 f8 02             	cmp    $0x2,%eax
80104122:	0f 84 68 01 00 00    	je     80104290 <ps+0x1b0>
                    cprintf("%d %d SLEEPING %s\n",p->pid, p->niceness, p->name);
                else if(p->state == RUNNING)
80104128:	83 f8 04             	cmp    $0x4,%eax
8010412b:	0f 84 7f 01 00 00    	je     801042b0 <ps+0x1d0>
                    cprintf("%d %d RUNNING %s\n",p->pid, p->niceness, p->name);
                else if(p->state == RUNNABLE)
80104131:	83 f8 03             	cmp    $0x3,%eax
80104134:	0f 84 96 01 00 00    	je     801042d0 <ps+0x1f0>
                    cprintf("%d %d RUNNABLE %s\n",p->pid, p->niceness, p->name);
                else if(p->state == UNUSED)
8010413a:	85 c0                	test   %eax,%eax
8010413c:	0f 84 2e 01 00 00    	je     80104270 <ps+0x190>
                    cprintf("%d %d UNUSED %s\n",p->pid, p->niceness, p->name);
                else if(p->state == ZOMBIE)
80104142:	83 f8 05             	cmp    $0x5,%eax
80104145:	0f 84 a5 01 00 00    	je     801042f0 <ps+0x210>
                    cprintf("%d %d ZOMBIE %s\n",p->pid, p->niceness, p->name);
                else if(p->state == EMBRYO)
8010414b:	83 f8 01             	cmp    $0x1,%eax
8010414e:	75 c0                	jne    80104110 <ps+0x30>
                    cprintf("%d %d EMBRYO %s\n",p->pid, p->niceness, p->name);
80104150:	53                   	push   %ebx
80104151:	ff 73 fc             	pushl  -0x4(%ebx)
80104154:	83 eb 80             	sub    $0xffffff80,%ebx
80104157:	56                   	push   %esi
80104158:	68 a7 79 10 80       	push   $0x801079a7
8010415d:	e8 fe c4 ff ff       	call   80100660 <cprintf>
80104162:	83 c4 10             	add    $0x10,%esp
            else if(p->state == EMBRYO)
                cprintf("%d %d EMBRYO %s\n",p->pid, p->niceness, p->name);

        }
    }else{
        for(p = ptable.proc ; p<&ptable.proc[NPROC];p++){
80104165:	39 df                	cmp    %ebx,%edi
80104167:	75 ae                	jne    80104117 <ps+0x37>
                else if(p->state == EMBRYO)
                    cprintf("%d %d EMBRYO %s\n",p->pid, p->niceness, p->name);
            }
        }
    }
    release(&ptable.lock);
80104169:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)

}
80104170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104173:	5b                   	pop    %ebx
80104174:	5e                   	pop    %esi
80104175:	5f                   	pop    %edi
80104176:	5d                   	pop    %ebp
                else if(p->state == EMBRYO)
                    cprintf("%d %d EMBRYO %s\n",p->pid, p->niceness, p->name);
            }
        }
    }
    release(&ptable.lock);
80104177:	e9 84 06 00 00       	jmp    80104800 <release>
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                cprintf("%d %d RUNNING %s\n",p->pid, p->niceness, p->name);
            else if(p->state == RUNNABLE)
                cprintf("%d %d RUNNABLE %s\n",p->pid, p->niceness, p->name);
            else if(p->state == UNUSED)
                cprintf("%d %d UNUSED %s\n",p->pid, p->niceness, p->name);
            else if(p->state == ZOMBIE)
80104180:	83 f8 05             	cmp    $0x5,%eax
80104183:	0f 84 a7 00 00 00    	je     80104230 <ps+0x150>
                cprintf("%d %d ZOMBIE %s\n",p->pid, p->niceness, p->name);
            else if(p->state == EMBRYO)
80104189:	83 f8 01             	cmp    $0x1,%eax
8010418c:	0f 84 be 00 00 00    	je     80104250 <ps+0x170>
80104192:	83 eb 80             	sub    $0xffffff80,%ebx
void ps(int pid){
    struct proc *p;
    sti();
    acquire(&ptable.lock);
    if(pid == 0){
        for(p = ptable.proc ; p<&ptable.proc[NPROC];p++){
80104195:	81 fb 44 4e 11 80    	cmp    $0x80114e44,%ebx
8010419b:	74 cc                	je     80104169 <ps+0x89>
            if(p->state == SLEEPING)
8010419d:	8b 43 9c             	mov    -0x64(%ebx),%eax
801041a0:	83 f8 02             	cmp    $0x2,%eax
801041a3:	74 2b                	je     801041d0 <ps+0xf0>
                cprintf("%d %d SLEEPING %s\n",p->pid, p->niceness, p->name);
            else if(p->state == RUNNING)
801041a5:	83 f8 04             	cmp    $0x4,%eax
801041a8:	74 46                	je     801041f0 <ps+0x110>
                cprintf("%d %d RUNNING %s\n",p->pid, p->niceness, p->name);
            else if(p->state == RUNNABLE)
801041aa:	83 f8 03             	cmp    $0x3,%eax
801041ad:	74 61                	je     80104210 <ps+0x130>
                cprintf("%d %d RUNNABLE %s\n",p->pid, p->niceness, p->name);
            else if(p->state == UNUSED)
801041af:	85 c0                	test   %eax,%eax
801041b1:	75 cd                	jne    80104180 <ps+0xa0>
                cprintf("%d %d UNUSED %s\n",p->pid, p->niceness, p->name);
801041b3:	53                   	push   %ebx
801041b4:	ff 73 fc             	pushl  -0x4(%ebx)
801041b7:	ff 73 a0             	pushl  -0x60(%ebx)
801041ba:	68 85 79 10 80       	push   $0x80107985
801041bf:	e8 9c c4 ff ff       	call   80100660 <cprintf>
801041c4:	83 c4 10             	add    $0x10,%esp
801041c7:	eb c9                	jmp    80104192 <ps+0xb2>
801041c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sti();
    acquire(&ptable.lock);
    if(pid == 0){
        for(p = ptable.proc ; p<&ptable.proc[NPROC];p++){
            if(p->state == SLEEPING)
                cprintf("%d %d SLEEPING %s\n",p->pid, p->niceness, p->name);
801041d0:	53                   	push   %ebx
801041d1:	ff 73 fc             	pushl  -0x4(%ebx)
801041d4:	ff 73 a0             	pushl  -0x60(%ebx)
801041d7:	68 4d 79 10 80       	push   $0x8010794d
801041dc:	e8 7f c4 ff ff       	call   80100660 <cprintf>
801041e1:	83 c4 10             	add    $0x10,%esp
801041e4:	eb ac                	jmp    80104192 <ps+0xb2>
801041e6:	8d 76 00             	lea    0x0(%esi),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            else if(p->state == RUNNING)
                cprintf("%d %d RUNNING %s\n",p->pid, p->niceness, p->name);
801041f0:	53                   	push   %ebx
801041f1:	ff 73 fc             	pushl  -0x4(%ebx)
801041f4:	ff 73 a0             	pushl  -0x60(%ebx)
801041f7:	68 60 79 10 80       	push   $0x80107960
801041fc:	e8 5f c4 ff ff       	call   80100660 <cprintf>
80104201:	83 c4 10             	add    $0x10,%esp
80104204:	eb 8c                	jmp    80104192 <ps+0xb2>
80104206:	8d 76 00             	lea    0x0(%esi),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            else if(p->state == RUNNABLE)
                cprintf("%d %d RUNNABLE %s\n",p->pid, p->niceness, p->name);
80104210:	53                   	push   %ebx
80104211:	ff 73 fc             	pushl  -0x4(%ebx)
80104214:	ff 73 a0             	pushl  -0x60(%ebx)
80104217:	68 72 79 10 80       	push   $0x80107972
8010421c:	e8 3f c4 ff ff       	call   80100660 <cprintf>
80104221:	83 c4 10             	add    $0x10,%esp
80104224:	e9 69 ff ff ff       	jmp    80104192 <ps+0xb2>
80104229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            else if(p->state == UNUSED)
                cprintf("%d %d UNUSED %s\n",p->pid, p->niceness, p->name);
            else if(p->state == ZOMBIE)
                cprintf("%d %d ZOMBIE %s\n",p->pid, p->niceness, p->name);
80104230:	53                   	push   %ebx
80104231:	ff 73 fc             	pushl  -0x4(%ebx)
80104234:	ff 73 a0             	pushl  -0x60(%ebx)
80104237:	68 96 79 10 80       	push   $0x80107996
8010423c:	e8 1f c4 ff ff       	call   80100660 <cprintf>
80104241:	83 c4 10             	add    $0x10,%esp
80104244:	e9 49 ff ff ff       	jmp    80104192 <ps+0xb2>
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            else if(p->state == EMBRYO)
                cprintf("%d %d EMBRYO %s\n",p->pid, p->niceness, p->name);
80104250:	53                   	push   %ebx
80104251:	ff 73 fc             	pushl  -0x4(%ebx)
80104254:	ff 73 a0             	pushl  -0x60(%ebx)
80104257:	68 a7 79 10 80       	push   $0x801079a7
8010425c:	e8 ff c3 ff ff       	call   80100660 <cprintf>
80104261:	83 c4 10             	add    $0x10,%esp
80104264:	e9 29 ff ff ff       	jmp    80104192 <ps+0xb2>
80104269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                else if(p->state == RUNNING)
                    cprintf("%d %d RUNNING %s\n",p->pid, p->niceness, p->name);
                else if(p->state == RUNNABLE)
                    cprintf("%d %d RUNNABLE %s\n",p->pid, p->niceness, p->name);
                else if(p->state == UNUSED)
                    cprintf("%d %d UNUSED %s\n",p->pid, p->niceness, p->name);
80104270:	53                   	push   %ebx
80104271:	ff 73 fc             	pushl  -0x4(%ebx)
80104274:	56                   	push   %esi
80104275:	68 85 79 10 80       	push   $0x80107985
8010427a:	e8 e1 c3 ff ff       	call   80100660 <cprintf>
8010427f:	83 c4 10             	add    $0x10,%esp
80104282:	e9 89 fe ff ff       	jmp    80104110 <ps+0x30>
80104287:	89 f6                	mov    %esi,%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        }
    }else{
        for(p = ptable.proc ; p<&ptable.proc[NPROC];p++){
            if(p->pid == pid){
                if(p->state == SLEEPING)
                    cprintf("%d %d SLEEPING %s\n",p->pid, p->niceness, p->name);
80104290:	53                   	push   %ebx
80104291:	ff 73 fc             	pushl  -0x4(%ebx)
80104294:	56                   	push   %esi
80104295:	68 4d 79 10 80       	push   $0x8010794d
8010429a:	e8 c1 c3 ff ff       	call   80100660 <cprintf>
8010429f:	83 c4 10             	add    $0x10,%esp
801042a2:	e9 69 fe ff ff       	jmp    80104110 <ps+0x30>
801042a7:	89 f6                	mov    %esi,%esi
801042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                else if(p->state == RUNNING)
                    cprintf("%d %d RUNNING %s\n",p->pid, p->niceness, p->name);
801042b0:	53                   	push   %ebx
801042b1:	ff 73 fc             	pushl  -0x4(%ebx)
801042b4:	56                   	push   %esi
801042b5:	68 60 79 10 80       	push   $0x80107960
801042ba:	e8 a1 c3 ff ff       	call   80100660 <cprintf>
801042bf:	83 c4 10             	add    $0x10,%esp
801042c2:	e9 49 fe ff ff       	jmp    80104110 <ps+0x30>
801042c7:	89 f6                	mov    %esi,%esi
801042c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                else if(p->state == RUNNABLE)
                    cprintf("%d %d RUNNABLE %s\n",p->pid, p->niceness, p->name);
801042d0:	53                   	push   %ebx
801042d1:	ff 73 fc             	pushl  -0x4(%ebx)
801042d4:	56                   	push   %esi
801042d5:	68 72 79 10 80       	push   $0x80107972
801042da:	e8 81 c3 ff ff       	call   80100660 <cprintf>
801042df:	83 c4 10             	add    $0x10,%esp
801042e2:	e9 29 fe ff ff       	jmp    80104110 <ps+0x30>
801042e7:	89 f6                	mov    %esi,%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                else if(p->state == UNUSED)
                    cprintf("%d %d UNUSED %s\n",p->pid, p->niceness, p->name);
                else if(p->state == ZOMBIE)
                    cprintf("%d %d ZOMBIE %s\n",p->pid, p->niceness, p->name);
801042f0:	53                   	push   %ebx
801042f1:	ff 73 fc             	pushl  -0x4(%ebx)
801042f4:	56                   	push   %esi
801042f5:	68 96 79 10 80       	push   $0x80107996
801042fa:	e8 61 c3 ff ff       	call   80100660 <cprintf>
801042ff:	83 c4 10             	add    $0x10,%esp
80104302:	e9 09 fe ff ff       	jmp    80104110 <ps+0x30>
80104307:	89 f6                	mov    %esi,%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104310 <getnice>:
    }
    release(&ptable.lock);

}
int 
getnice(int pid){
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
80104315:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&ptable.lock);
    //   cprintf("입력한 pid : %d\n",pid);                                 //code for test
    //   for(p = ptable.proc; p <&ptable.proc[NPROC];p++){
    //       cprintf("P->pid: %d P->nice : %d \n",p->pid,p->niceness);
    //   }
    for(p = ptable.proc; p< &ptable.proc[NPROC];p++){
80104318:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx

}
int 
getnice(int pid){
    struct proc *p;
    acquire(&ptable.lock);
8010431d:	83 ec 0c             	sub    $0xc,%esp
80104320:	68 a0 2d 11 80       	push   $0x80112da0
80104325:	e8 f6 02 00 00       	call   80104620 <acquire>
8010432a:	83 c4 10             	add    $0x10,%esp
8010432d:	eb 0c                	jmp    8010433b <getnice+0x2b>
8010432f:	90                   	nop
    //   cprintf("입력한 pid : %d\n",pid);                                 //code for test
    //   for(p = ptable.proc; p <&ptable.proc[NPROC];p++){
    //       cprintf("P->pid: %d P->nice : %d \n",p->pid,p->niceness);
    //   }
    for(p = ptable.proc; p< &ptable.proc[NPROC];p++){
80104330:	83 eb 80             	sub    $0xffffff80,%ebx
80104333:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
80104339:	74 55                	je     80104390 <getnice+0x80>
        if(p->pid == pid){
8010433b:	39 73 10             	cmp    %esi,0x10(%ebx)
8010433e:	75 f0                	jne    80104330 <getnice+0x20>
            if(p->state == SLEEPING)
80104340:	8b 43 0c             	mov    0xc(%ebx),%eax
80104343:	83 f8 02             	cmp    $0x2,%eax
80104346:	0f 84 8e 00 00 00    	je     801043da <getnice+0xca>
                cprintf("%d %d SLEEPING %s\n",p->pid, p->niceness, p->name);
            else if(p->state == RUNNING)
8010434c:	83 f8 04             	cmp    $0x4,%eax
8010434f:	0f 84 9f 00 00 00    	je     801043f4 <getnice+0xe4>
                cprintf("%d %d RUNNING %s\n",p->pid, p->niceness, p->name);
            else if(p->state == RUNNABLE)
80104355:	83 f8 03             	cmp    $0x3,%eax
80104358:	74 52                	je     801043ac <getnice+0x9c>
                cprintf("%d %d RUNNABLE %s\n",p->pid, p->niceness, p->name);
            else if(p->state == UNUSED)
8010435a:	85 c0                	test   %eax,%eax
8010435c:	74 65                	je     801043c3 <getnice+0xb3>
                cprintf("%d %d UNUSED %s\n",p->pid, p->niceness, p->name);
            else if(p->state == ZOMBIE)
8010435e:	83 f8 05             	cmp    $0x5,%eax
80104361:	0f 84 c1 00 00 00    	je     80104428 <getnice+0x118>
                cprintf("%d %d ZOMBIE %s\n",p->pid, p->niceness, p->name);
            else if(p->state == EMBRYO)
80104367:	83 f8 01             	cmp    $0x1,%eax
8010436a:	0f 84 9e 00 00 00    	je     8010440e <getnice+0xfe>
                cprintf("%d %d EMBRYO %s\n",p->pid, p->niceness, p->name);

            release(&ptable.lock);
80104370:	83 ec 0c             	sub    $0xc,%esp
80104373:	68 a0 2d 11 80       	push   $0x80112da0
80104378:	e8 83 04 00 00       	call   80104800 <release>
            return p->niceness;
8010437d:	8b 43 6c             	mov    0x6c(%ebx),%eax
80104380:	83 c4 10             	add    $0x10,%esp
        }
    }
    release(&ptable.lock);
    return -1;
}
80104383:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104386:	5b                   	pop    %ebx
80104387:	5e                   	pop    %esi
80104388:	5d                   	pop    %ebp
80104389:	c3                   	ret    
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

            release(&ptable.lock);
            return p->niceness;
        }
    }
    release(&ptable.lock);
80104390:	83 ec 0c             	sub    $0xc,%esp
80104393:	68 a0 2d 11 80       	push   $0x80112da0
80104398:	e8 63 04 00 00       	call   80104800 <release>
    return -1;
8010439d:	83 c4 10             	add    $0x10,%esp
}
801043a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
            release(&ptable.lock);
            return p->niceness;
        }
    }
    release(&ptable.lock);
    return -1;
801043a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043a8:	5b                   	pop    %ebx
801043a9:	5e                   	pop    %esi
801043aa:	5d                   	pop    %ebp
801043ab:	c3                   	ret    
            if(p->state == SLEEPING)
                cprintf("%d %d SLEEPING %s\n",p->pid, p->niceness, p->name);
            else if(p->state == RUNNING)
                cprintf("%d %d RUNNING %s\n",p->pid, p->niceness, p->name);
            else if(p->state == RUNNABLE)
                cprintf("%d %d RUNNABLE %s\n",p->pid, p->niceness, p->name);
801043ac:	8d 43 70             	lea    0x70(%ebx),%eax
801043af:	50                   	push   %eax
801043b0:	ff 73 6c             	pushl  0x6c(%ebx)
801043b3:	56                   	push   %esi
801043b4:	68 72 79 10 80       	push   $0x80107972
801043b9:	e8 a2 c2 ff ff       	call   80100660 <cprintf>
801043be:	83 c4 10             	add    $0x10,%esp
801043c1:	eb ad                	jmp    80104370 <getnice+0x60>
            else if(p->state == UNUSED)
                cprintf("%d %d UNUSED %s\n",p->pid, p->niceness, p->name);
801043c3:	8d 43 70             	lea    0x70(%ebx),%eax
801043c6:	50                   	push   %eax
801043c7:	ff 73 6c             	pushl  0x6c(%ebx)
801043ca:	56                   	push   %esi
801043cb:	68 85 79 10 80       	push   $0x80107985
801043d0:	e8 8b c2 ff ff       	call   80100660 <cprintf>
801043d5:	83 c4 10             	add    $0x10,%esp
801043d8:	eb 96                	jmp    80104370 <getnice+0x60>
    //       cprintf("P->pid: %d P->nice : %d \n",p->pid,p->niceness);
    //   }
    for(p = ptable.proc; p< &ptable.proc[NPROC];p++){
        if(p->pid == pid){
            if(p->state == SLEEPING)
                cprintf("%d %d SLEEPING %s\n",p->pid, p->niceness, p->name);
801043da:	8d 43 70             	lea    0x70(%ebx),%eax
801043dd:	50                   	push   %eax
801043de:	ff 73 6c             	pushl  0x6c(%ebx)
801043e1:	56                   	push   %esi
801043e2:	68 4d 79 10 80       	push   $0x8010794d
801043e7:	e8 74 c2 ff ff       	call   80100660 <cprintf>
801043ec:	83 c4 10             	add    $0x10,%esp
801043ef:	e9 7c ff ff ff       	jmp    80104370 <getnice+0x60>
            else if(p->state == RUNNING)
                cprintf("%d %d RUNNING %s\n",p->pid, p->niceness, p->name);
801043f4:	8d 43 70             	lea    0x70(%ebx),%eax
801043f7:	50                   	push   %eax
801043f8:	ff 73 6c             	pushl  0x6c(%ebx)
801043fb:	56                   	push   %esi
801043fc:	68 60 79 10 80       	push   $0x80107960
80104401:	e8 5a c2 ff ff       	call   80100660 <cprintf>
80104406:	83 c4 10             	add    $0x10,%esp
80104409:	e9 62 ff ff ff       	jmp    80104370 <getnice+0x60>
            else if(p->state == UNUSED)
                cprintf("%d %d UNUSED %s\n",p->pid, p->niceness, p->name);
            else if(p->state == ZOMBIE)
                cprintf("%d %d ZOMBIE %s\n",p->pid, p->niceness, p->name);
            else if(p->state == EMBRYO)
                cprintf("%d %d EMBRYO %s\n",p->pid, p->niceness, p->name);
8010440e:	8d 43 70             	lea    0x70(%ebx),%eax
80104411:	50                   	push   %eax
80104412:	ff 73 6c             	pushl  0x6c(%ebx)
80104415:	56                   	push   %esi
80104416:	68 a7 79 10 80       	push   $0x801079a7
8010441b:	e8 40 c2 ff ff       	call   80100660 <cprintf>
80104420:	83 c4 10             	add    $0x10,%esp
80104423:	e9 48 ff ff ff       	jmp    80104370 <getnice+0x60>
            else if(p->state == RUNNABLE)
                cprintf("%d %d RUNNABLE %s\n",p->pid, p->niceness, p->name);
            else if(p->state == UNUSED)
                cprintf("%d %d UNUSED %s\n",p->pid, p->niceness, p->name);
            else if(p->state == ZOMBIE)
                cprintf("%d %d ZOMBIE %s\n",p->pid, p->niceness, p->name);
80104428:	8d 43 70             	lea    0x70(%ebx),%eax
8010442b:	50                   	push   %eax
8010442c:	ff 73 6c             	pushl  0x6c(%ebx)
8010442f:	56                   	push   %esi
80104430:	68 96 79 10 80       	push   $0x80107996
80104435:	e8 26 c2 ff ff       	call   80100660 <cprintf>
8010443a:	83 c4 10             	add    $0x10,%esp
8010443d:	e9 2e ff ff ff       	jmp    80104370 <getnice+0x60>
80104442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104450 <setnice>:
    }
    release(&ptable.lock);
    return -1;
}

int setnice(int pid, int value){
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	57                   	push   %edi
80104454:	56                   	push   %esi
80104455:	53                   	push   %ebx
80104456:	83 ec 18             	sub    $0x18,%esp
80104459:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010445c:	8b 75 08             	mov    0x8(%ebp),%esi
    struct proc *p;
    acquire(&ptable.lock);
8010445f:	68 a0 2d 11 80       	push   $0x80112da0
80104464:	e8 b7 01 00 00       	call   80104620 <acquire>

    if(value<0 || value >40){
80104469:	83 c4 10             	add    $0x10,%esp
8010446c:	83 ff 28             	cmp    $0x28,%edi
8010446f:	77 5f                	ja     801044d0 <setnice+0x80>
80104471:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80104476:	eb 13                	jmp    8010448b <setnice+0x3b>
80104478:	90                   	nop
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        release(&ptable.lock);
        return -1;
    }    

    for(p=ptable.proc;p < &ptable.proc[NPROC];p++){
80104480:	83 eb 80             	sub    $0xffffff80,%ebx
80104483:	81 fb d4 4d 11 80    	cmp    $0x80114dd4,%ebx
80104489:	74 45                	je     801044d0 <setnice+0x80>
        if(p->pid == pid){
8010448b:	39 73 10             	cmp    %esi,0x10(%ebx)
8010448e:	75 f0                	jne    80104480 <setnice+0x30>
            cprintf("you set niceness of %s(pid:%d)  : %d to ",p->name,p->pid, p->niceness);
80104490:	8d 43 70             	lea    0x70(%ebx),%eax
80104493:	ff 73 6c             	pushl  0x6c(%ebx)
80104496:	56                   	push   %esi
80104497:	50                   	push   %eax
80104498:	68 e4 79 10 80       	push   $0x801079e4
8010449d:	e8 be c1 ff ff       	call   80100660 <cprintf>
            p->niceness = value;          
            cprintf("%d\n",p->niceness);
801044a2:	58                   	pop    %eax
801044a3:	5a                   	pop    %edx
801044a4:	57                   	push   %edi
801044a5:	68 79 7a 10 80       	push   $0x80107a79
    }    

    for(p=ptable.proc;p < &ptable.proc[NPROC];p++){
        if(p->pid == pid){
            cprintf("you set niceness of %s(pid:%d)  : %d to ",p->name,p->pid, p->niceness);
            p->niceness = value;          
801044aa:	89 7b 6c             	mov    %edi,0x6c(%ebx)
            cprintf("%d\n",p->niceness);
801044ad:	e8 ae c1 ff ff       	call   80100660 <cprintf>
            release(&ptable.lock);
801044b2:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801044b9:	e8 42 03 00 00       	call   80104800 <release>
            return 0;
801044be:	83 c4 10             	add    $0x10,%esp
        }
    }
    release(&ptable.lock);
    return -1;
}           
801044c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
        if(p->pid == pid){
            cprintf("you set niceness of %s(pid:%d)  : %d to ",p->name,p->pid, p->niceness);
            p->niceness = value;          
            cprintf("%d\n",p->niceness);
            release(&ptable.lock);
            return 0;
801044c4:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}           
801044c6:	5b                   	pop    %ebx
801044c7:	5e                   	pop    %esi
801044c8:	5f                   	pop    %edi
801044c9:	5d                   	pop    %ebp
801044ca:	c3                   	ret    
801044cb:	90                   	nop
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int setnice(int pid, int value){
    struct proc *p;
    acquire(&ptable.lock);

    if(value<0 || value >40){
        release(&ptable.lock);
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	68 a0 2d 11 80       	push   $0x80112da0
801044d8:	e8 23 03 00 00       	call   80104800 <release>
        return -1;
801044dd:	83 c4 10             	add    $0x10,%esp
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}           
801044e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    struct proc *p;
    acquire(&ptable.lock);

    if(value<0 || value >40){
        release(&ptable.lock);
        return -1;
801044e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}           
801044e8:	5b                   	pop    %ebx
801044e9:	5e                   	pop    %esi
801044ea:	5f                   	pop    %edi
801044eb:	5d                   	pop    %ebp
801044ec:	c3                   	ret    
801044ed:	66 90                	xchg   %ax,%ax
801044ef:	90                   	nop

801044f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 0c             	sub    $0xc,%esp
801044f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044fa:	68 28 7a 10 80       	push   $0x80107a28
801044ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104502:	50                   	push   %eax
80104503:	e8 f8 00 00 00       	call   80104600 <initlock>
  lk->name = name;
80104508:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010450b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104511:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104514:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010451b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010451e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104521:	c9                   	leave  
80104522:	c3                   	ret    
80104523:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104530 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	8d 73 04             	lea    0x4(%ebx),%esi
8010453e:	56                   	push   %esi
8010453f:	e8 dc 00 00 00       	call   80104620 <acquire>
  while (lk->locked) {
80104544:	8b 13                	mov    (%ebx),%edx
80104546:	83 c4 10             	add    $0x10,%esp
80104549:	85 d2                	test   %edx,%edx
8010454b:	74 16                	je     80104563 <acquiresleep+0x33>
8010454d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104550:	83 ec 08             	sub    $0x8,%esp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	e8 36 f8 ff ff       	call   80103d90 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010455a:	8b 03                	mov    (%ebx),%eax
8010455c:	83 c4 10             	add    $0x10,%esp
8010455f:	85 c0                	test   %eax,%eax
80104561:	75 ed                	jne    80104550 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104563:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
80104569:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010456f:	8b 40 10             	mov    0x10(%eax),%eax
80104572:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104575:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104578:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010457b:	5b                   	pop    %ebx
8010457c:	5e                   	pop    %esi
8010457d:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
8010457e:	e9 7d 02 00 00       	jmp    80104800 <release>
80104583:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104598:	83 ec 0c             	sub    $0xc,%esp
8010459b:	8d 73 04             	lea    0x4(%ebx),%esi
8010459e:	56                   	push   %esi
8010459f:	e8 7c 00 00 00       	call   80104620 <acquire>
  lk->locked = 0;
801045a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045b1:	89 1c 24             	mov    %ebx,(%esp)
801045b4:	e8 77 f9 ff ff       	call   80103f30 <wakeup>
  release(&lk->lk);
801045b9:	89 75 08             	mov    %esi,0x8(%ebp)
801045bc:	83 c4 10             	add    $0x10,%esp
}
801045bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c2:	5b                   	pop    %ebx
801045c3:	5e                   	pop    %esi
801045c4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801045c5:	e9 36 02 00 00       	jmp    80104800 <release>
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	8d 5e 04             	lea    0x4(%esi),%ebx
801045de:	53                   	push   %ebx
801045df:	e8 3c 00 00 00       	call   80104620 <acquire>
  r = lk->locked;
801045e4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801045e6:	89 1c 24             	mov    %ebx,(%esp)
801045e9:	e8 12 02 00 00       	call   80104800 <release>
  return r;
}
801045ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f1:	89 f0                	mov    %esi,%eax
801045f3:	5b                   	pop    %ebx
801045f4:	5e                   	pop    %esi
801045f5:	5d                   	pop    %ebp
801045f6:	c3                   	ret    
801045f7:	66 90                	xchg   %ax,%ax
801045f9:	66 90                	xchg   %ax,%ax
801045fb:	66 90                	xchg   %ax,%ax
801045fd:	66 90                	xchg   %ax,%ax
801045ff:	90                   	nop

80104600 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104606:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010460f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104619:	5d                   	pop    %ebp
8010461a:	c3                   	ret    
8010461b:	90                   	nop
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104620 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 04             	sub    $0x4,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104627:	9c                   	pushf  
80104628:	5a                   	pop    %edx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104629:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
8010462a:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80104631:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
80104637:	85 c0                	test   %eax,%eax
80104639:	75 0c                	jne    80104647 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
8010463b:	81 e2 00 02 00 00    	and    $0x200,%edx
80104641:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
80104647:	8b 55 08             	mov    0x8(%ebp),%edx

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
    cpu->intena = eflags & FL_IF;
  cpu->ncli += 1;
8010464a:	83 c0 01             	add    $0x1,%eax
8010464d:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104653:	8b 02                	mov    (%edx),%eax
80104655:	85 c0                	test   %eax,%eax
80104657:	74 05                	je     8010465e <acquire+0x3e>
80104659:	39 4a 08             	cmp    %ecx,0x8(%edx)
8010465c:	74 7a                	je     801046d8 <acquire+0xb8>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010465e:	b9 01 00 00 00       	mov    $0x1,%ecx
80104663:	90                   	nop
80104664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104668:	89 c8                	mov    %ecx,%eax
8010466a:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010466d:	85 c0                	test   %eax,%eax
8010466f:	75 f7                	jne    80104668 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104671:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104676:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104679:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010467f:	89 ea                	mov    %ebp,%edx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104681:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
80104684:	83 c1 0c             	add    $0xc,%ecx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104687:	31 c0                	xor    %eax,%eax
80104689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104690:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104696:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010469c:	77 1a                	ja     801046b8 <acquire+0x98>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010469e:	8b 5a 04             	mov    0x4(%edx),%ebx
801046a1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046a4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801046a7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046a9:	83 f8 0a             	cmp    $0xa,%eax
801046ac:	75 e2                	jne    80104690 <acquire+0x70>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  getcallerpcs(&lk, lk->pcs);
}
801046ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b1:	c9                   	leave  
801046b2:	c3                   	ret    
801046b3:	90                   	nop
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801046b8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801046bf:	83 c0 01             	add    $0x1,%eax
801046c2:	83 f8 0a             	cmp    $0xa,%eax
801046c5:	74 e7                	je     801046ae <acquire+0x8e>
    pcs[i] = 0;
801046c7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801046ce:	83 c0 01             	add    $0x1,%eax
801046d1:	83 f8 0a             	cmp    $0xa,%eax
801046d4:	75 e2                	jne    801046b8 <acquire+0x98>
801046d6:	eb d6                	jmp    801046ae <acquire+0x8e>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	68 33 7a 10 80       	push   $0x80107a33
801046e0:	e8 8b bc ff ff       	call   80100370 <panic>
801046e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801046f4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801046fa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801046fd:	31 c0                	xor    %eax,%eax
801046ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104700:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104706:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010470c:	77 1a                	ja     80104728 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010470e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104711:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104714:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104717:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104719:	83 f8 0a             	cmp    $0xa,%eax
8010471c:	75 e2                	jne    80104700 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010471e:	5b                   	pop    %ebx
8010471f:	5d                   	pop    %ebp
80104720:	c3                   	ret    
80104721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104728:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010472f:	83 c0 01             	add    $0x1,%eax
80104732:	83 f8 0a             	cmp    $0xa,%eax
80104735:	74 e7                	je     8010471e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104737:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010473e:	83 c0 01             	add    $0x1,%eax
80104741:	83 f8 0a             	cmp    $0xa,%eax
80104744:	75 e2                	jne    80104728 <getcallerpcs+0x38>
80104746:	eb d6                	jmp    8010471e <getcallerpcs+0x2e>
80104748:	90                   	nop
80104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104750 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104756:	8b 02                	mov    (%edx),%eax
80104758:	85 c0                	test   %eax,%eax
8010475a:	74 14                	je     80104770 <holding+0x20>
8010475c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104762:	39 42 08             	cmp    %eax,0x8(%edx)
}
80104765:	5d                   	pop    %ebp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104766:	0f 94 c0             	sete   %al
80104769:	0f b6 c0             	movzbl %al,%eax
}
8010476c:	c3                   	ret    
8010476d:	8d 76 00             	lea    0x0(%esi),%esi
80104770:	31 c0                	xor    %eax,%eax
80104772:	5d                   	pop    %ebp
80104773:	c3                   	ret    
80104774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010477a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104780 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104783:	9c                   	pushf  
80104784:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104785:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104786:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010478d:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104793:	85 c0                	test   %eax,%eax
80104795:	75 0c                	jne    801047a3 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
80104797:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010479d:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
801047a3:	83 c0 01             	add    $0x1,%eax
801047a6:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
801047ac:	5d                   	pop    %ebp
801047ad:	c3                   	ret    
801047ae:	66 90                	xchg   %ax,%ax

801047b0 <popcli>:

void
popcli(void)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047b6:	9c                   	pushf  
801047b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047b8:	f6 c4 02             	test   $0x2,%ah
801047bb:	75 2c                	jne    801047e9 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
801047bd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801047c4:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
801047cb:	78 0f                	js     801047dc <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
801047cd:	75 0b                	jne    801047da <popcli+0x2a>
801047cf:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
801047d5:	85 c0                	test   %eax,%eax
801047d7:	74 01                	je     801047da <popcli+0x2a>
}

static inline void
sti(void)
{
  asm volatile("sti");
801047d9:	fb                   	sti    
    sti();
}
801047da:	c9                   	leave  
801047db:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
801047dc:	83 ec 0c             	sub    $0xc,%esp
801047df:	68 52 7a 10 80       	push   $0x80107a52
801047e4:	e8 87 bb ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801047e9:	83 ec 0c             	sub    $0xc,%esp
801047ec:	68 3b 7a 10 80       	push   $0x80107a3b
801047f1:	e8 7a bb ff ff       	call   80100370 <panic>
801047f6:	8d 76 00             	lea    0x0(%esi),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	83 ec 08             	sub    $0x8,%esp
80104806:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104809:	8b 10                	mov    (%eax),%edx
8010480b:	85 d2                	test   %edx,%edx
8010480d:	74 0c                	je     8010481b <release+0x1b>
8010480f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104816:	39 50 08             	cmp    %edx,0x8(%eax)
80104819:	74 15                	je     80104830 <release+0x30>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010481b:	83 ec 0c             	sub    $0xc,%esp
8010481e:	68 59 7a 10 80       	push   $0x80107a59
80104823:	e8 48 bb ff ff       	call   80100370 <panic>
80104828:	90                   	nop
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  lk->pcs[0] = 0;
80104830:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104837:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010483e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104843:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104849:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010484a:	e9 61 ff ff ff       	jmp    801047b0 <popcli>
8010484f:	90                   	nop

80104850 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	53                   	push   %ebx
80104855:	8b 55 08             	mov    0x8(%ebp),%edx
80104858:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010485b:	f6 c2 03             	test   $0x3,%dl
8010485e:	75 05                	jne    80104865 <memset+0x15>
80104860:	f6 c1 03             	test   $0x3,%cl
80104863:	74 13                	je     80104878 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104865:	89 d7                	mov    %edx,%edi
80104867:	8b 45 0c             	mov    0xc(%ebp),%eax
8010486a:	fc                   	cld    
8010486b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010486d:	5b                   	pop    %ebx
8010486e:	89 d0                	mov    %edx,%eax
80104870:	5f                   	pop    %edi
80104871:	5d                   	pop    %ebp
80104872:	c3                   	ret    
80104873:	90                   	nop
80104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104878:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010487c:	c1 e9 02             	shr    $0x2,%ecx
8010487f:	89 fb                	mov    %edi,%ebx
80104881:	89 f8                	mov    %edi,%eax
80104883:	c1 e3 18             	shl    $0x18,%ebx
80104886:	c1 e0 10             	shl    $0x10,%eax
80104889:	09 d8                	or     %ebx,%eax
8010488b:	09 f8                	or     %edi,%eax
8010488d:	c1 e7 08             	shl    $0x8,%edi
80104890:	09 f8                	or     %edi,%eax
80104892:	89 d7                	mov    %edx,%edi
80104894:	fc                   	cld    
80104895:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104897:	5b                   	pop    %ebx
80104898:	89 d0                	mov    %edx,%eax
8010489a:	5f                   	pop    %edi
8010489b:	5d                   	pop    %ebp
8010489c:	c3                   	ret    
8010489d:	8d 76 00             	lea    0x0(%esi),%esi

801048a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	56                   	push   %esi
801048a5:	8b 45 10             	mov    0x10(%ebp),%eax
801048a8:	53                   	push   %ebx
801048a9:	8b 75 0c             	mov    0xc(%ebp),%esi
801048ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048af:	85 c0                	test   %eax,%eax
801048b1:	74 29                	je     801048dc <memcmp+0x3c>
    if(*s1 != *s2)
801048b3:	0f b6 13             	movzbl (%ebx),%edx
801048b6:	0f b6 0e             	movzbl (%esi),%ecx
801048b9:	38 d1                	cmp    %dl,%cl
801048bb:	75 2b                	jne    801048e8 <memcmp+0x48>
801048bd:	8d 78 ff             	lea    -0x1(%eax),%edi
801048c0:	31 c0                	xor    %eax,%eax
801048c2:	eb 14                	jmp    801048d8 <memcmp+0x38>
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048c8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801048cd:	83 c0 01             	add    $0x1,%eax
801048d0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801048d4:	38 ca                	cmp    %cl,%dl
801048d6:	75 10                	jne    801048e8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048d8:	39 f8                	cmp    %edi,%eax
801048da:	75 ec                	jne    801048c8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801048dc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801048dd:	31 c0                	xor    %eax,%eax
}
801048df:	5e                   	pop    %esi
801048e0:	5f                   	pop    %edi
801048e1:	5d                   	pop    %ebp
801048e2:	c3                   	ret    
801048e3:	90                   	nop
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801048e8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
801048eb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801048ec:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801048ee:	5e                   	pop    %esi
801048ef:	5f                   	pop    %edi
801048f0:	5d                   	pop    %ebp
801048f1:	c3                   	ret    
801048f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	8b 45 08             	mov    0x8(%ebp),%eax
80104908:	8b 75 0c             	mov    0xc(%ebp),%esi
8010490b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010490e:	39 c6                	cmp    %eax,%esi
80104910:	73 2e                	jae    80104940 <memmove+0x40>
80104912:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104915:	39 c8                	cmp    %ecx,%eax
80104917:	73 27                	jae    80104940 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104919:	85 db                	test   %ebx,%ebx
8010491b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010491e:	74 17                	je     80104937 <memmove+0x37>
      *--d = *--s;
80104920:	29 d9                	sub    %ebx,%ecx
80104922:	89 cb                	mov    %ecx,%ebx
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104928:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010492c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010492f:	83 ea 01             	sub    $0x1,%edx
80104932:	83 fa ff             	cmp    $0xffffffff,%edx
80104935:	75 f1                	jne    80104928 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104937:	5b                   	pop    %ebx
80104938:	5e                   	pop    %esi
80104939:	5d                   	pop    %ebp
8010493a:	c3                   	ret    
8010493b:	90                   	nop
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104940:	31 d2                	xor    %edx,%edx
80104942:	85 db                	test   %ebx,%ebx
80104944:	74 f1                	je     80104937 <memmove+0x37>
80104946:	8d 76 00             	lea    0x0(%esi),%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104950:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104954:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104957:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010495a:	39 d3                	cmp    %edx,%ebx
8010495c:	75 f2                	jne    80104950 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010495e:	5b                   	pop    %ebx
8010495f:	5e                   	pop    %esi
80104960:	5d                   	pop    %ebp
80104961:	c3                   	ret    
80104962:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104970 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104973:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104974:	eb 8a                	jmp    80104900 <memmove>
80104976:	8d 76 00             	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	56                   	push   %esi
80104985:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104988:	53                   	push   %ebx
80104989:	8b 7d 08             	mov    0x8(%ebp),%edi
8010498c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010498f:	85 c9                	test   %ecx,%ecx
80104991:	74 37                	je     801049ca <strncmp+0x4a>
80104993:	0f b6 17             	movzbl (%edi),%edx
80104996:	0f b6 1e             	movzbl (%esi),%ebx
80104999:	84 d2                	test   %dl,%dl
8010499b:	74 3f                	je     801049dc <strncmp+0x5c>
8010499d:	38 d3                	cmp    %dl,%bl
8010499f:	75 3b                	jne    801049dc <strncmp+0x5c>
801049a1:	8d 47 01             	lea    0x1(%edi),%eax
801049a4:	01 cf                	add    %ecx,%edi
801049a6:	eb 1b                	jmp    801049c3 <strncmp+0x43>
801049a8:	90                   	nop
801049a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049b0:	0f b6 10             	movzbl (%eax),%edx
801049b3:	84 d2                	test   %dl,%dl
801049b5:	74 21                	je     801049d8 <strncmp+0x58>
801049b7:	0f b6 19             	movzbl (%ecx),%ebx
801049ba:	83 c0 01             	add    $0x1,%eax
801049bd:	89 ce                	mov    %ecx,%esi
801049bf:	38 da                	cmp    %bl,%dl
801049c1:	75 19                	jne    801049dc <strncmp+0x5c>
801049c3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
801049c5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801049c8:	75 e6                	jne    801049b0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801049ca:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801049cb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801049cd:	5e                   	pop    %esi
801049ce:	5f                   	pop    %edi
801049cf:	5d                   	pop    %ebp
801049d0:	c3                   	ret    
801049d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049dc:	0f b6 c2             	movzbl %dl,%eax
801049df:	29 d8                	sub    %ebx,%eax
}
801049e1:	5b                   	pop    %ebx
801049e2:	5e                   	pop    %esi
801049e3:	5f                   	pop    %edi
801049e4:	5d                   	pop    %ebp
801049e5:	c3                   	ret    
801049e6:	8d 76 00             	lea    0x0(%esi),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	8b 45 08             	mov    0x8(%ebp),%eax
801049f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801049fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049fe:	89 c2                	mov    %eax,%edx
80104a00:	eb 19                	jmp    80104a1b <strncpy+0x2b>
80104a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a08:	83 c3 01             	add    $0x1,%ebx
80104a0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104a0f:	83 c2 01             	add    $0x1,%edx
80104a12:	84 c9                	test   %cl,%cl
80104a14:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a17:	74 09                	je     80104a22 <strncpy+0x32>
80104a19:	89 f1                	mov    %esi,%ecx
80104a1b:	85 c9                	test   %ecx,%ecx
80104a1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104a20:	7f e6                	jg     80104a08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104a22:	31 c9                	xor    %ecx,%ecx
80104a24:	85 f6                	test   %esi,%esi
80104a26:	7e 17                	jle    80104a3f <strncpy+0x4f>
80104a28:	90                   	nop
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104a34:	89 f3                	mov    %esi,%ebx
80104a36:	83 c1 01             	add    $0x1,%ecx
80104a39:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104a3b:	85 db                	test   %ebx,%ebx
80104a3d:	7f f1                	jg     80104a30 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104a3f:	5b                   	pop    %ebx
80104a40:	5e                   	pop    %esi
80104a41:	5d                   	pop    %ebp
80104a42:	c3                   	ret    
80104a43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a58:	8b 45 08             	mov    0x8(%ebp),%eax
80104a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104a5e:	85 c9                	test   %ecx,%ecx
80104a60:	7e 26                	jle    80104a88 <safestrcpy+0x38>
80104a62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104a66:	89 c1                	mov    %eax,%ecx
80104a68:	eb 17                	jmp    80104a81 <safestrcpy+0x31>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a70:	83 c2 01             	add    $0x1,%edx
80104a73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104a77:	83 c1 01             	add    $0x1,%ecx
80104a7a:	84 db                	test   %bl,%bl
80104a7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104a7f:	74 04                	je     80104a85 <safestrcpy+0x35>
80104a81:	39 f2                	cmp    %esi,%edx
80104a83:	75 eb                	jne    80104a70 <safestrcpy+0x20>
    ;
  *s = 0;
80104a85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104a88:	5b                   	pop    %ebx
80104a89:	5e                   	pop    %esi
80104a8a:	5d                   	pop    %ebp
80104a8b:	c3                   	ret    
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <strlen>:

int
strlen(const char *s)
{
80104a90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a91:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104a98:	80 3a 00             	cmpb   $0x0,(%edx)
80104a9b:	74 0c                	je     80104aa9 <strlen+0x19>
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
80104aa0:	83 c0 01             	add    $0x1,%eax
80104aa3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104aa7:	75 f7                	jne    80104aa0 <strlen+0x10>
    ;
  return n;
}
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret    

80104aab <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104aab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104aaf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104ab3:	55                   	push   %ebp
  pushl %ebx
80104ab4:	53                   	push   %ebx
  pushl %esi
80104ab5:	56                   	push   %esi
  pushl %edi
80104ab6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ab7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ab9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104abb:	5f                   	pop    %edi
  popl %esi
80104abc:	5e                   	pop    %esi
  popl %ebx
80104abd:	5b                   	pop    %ebx
  popl %ebp
80104abe:	5d                   	pop    %ebp
  ret
80104abf:	c3                   	ret    

80104ac0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ac0:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104ac1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ac8:	89 e5                	mov    %esp,%ebp
80104aca:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
80104acd:	8b 12                	mov    (%edx),%edx
80104acf:	39 c2                	cmp    %eax,%edx
80104ad1:	76 15                	jbe    80104ae8 <fetchint+0x28>
80104ad3:	8d 48 04             	lea    0x4(%eax),%ecx
80104ad6:	39 ca                	cmp    %ecx,%edx
80104ad8:	72 0e                	jb     80104ae8 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
80104ada:	8b 10                	mov    (%eax),%edx
80104adc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104adf:	89 10                	mov    %edx,(%eax)
  return 0;
80104ae1:	31 c0                	xor    %eax,%eax
}
80104ae3:	5d                   	pop    %ebp
80104ae4:	c3                   	ret    
80104ae5:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
80104aed:	5d                   	pop    %ebp
80104aee:	c3                   	ret    
80104aef:	90                   	nop

80104af0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104af0:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
80104af1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104af7:	89 e5                	mov    %esp,%ebp
80104af9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
80104afc:	39 08                	cmp    %ecx,(%eax)
80104afe:	76 2c                	jbe    80104b2c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104b00:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b03:	89 c8                	mov    %ecx,%eax
80104b05:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104b07:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b0e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104b10:	39 d1                	cmp    %edx,%ecx
80104b12:	73 18                	jae    80104b2c <fetchstr+0x3c>
    if(*s == 0)
80104b14:	80 39 00             	cmpb   $0x0,(%ecx)
80104b17:	75 0c                	jne    80104b25 <fetchstr+0x35>
80104b19:	eb 1d                	jmp    80104b38 <fetchstr+0x48>
80104b1b:	90                   	nop
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b20:	80 38 00             	cmpb   $0x0,(%eax)
80104b23:	74 13                	je     80104b38 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104b25:	83 c0 01             	add    $0x1,%eax
80104b28:	39 c2                	cmp    %eax,%edx
80104b2a:	77 f4                	ja     80104b20 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
80104b2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104b31:	5d                   	pop    %ebp
80104b32:	c3                   	ret    
80104b33:	90                   	nop
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104b38:	29 c8                	sub    %ecx,%eax
  return -1;
}
80104b3a:	5d                   	pop    %ebp
80104b3b:	c3                   	ret    
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104b40:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b47:	55                   	push   %ebp
80104b48:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104b4a:	8b 42 18             	mov    0x18(%edx),%eax
80104b4d:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104b50:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104b52:	8b 40 44             	mov    0x44(%eax),%eax
80104b55:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104b58:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104b5b:	39 d1                	cmp    %edx,%ecx
80104b5d:	73 19                	jae    80104b78 <argint+0x38>
80104b5f:	8d 48 08             	lea    0x8(%eax),%ecx
80104b62:	39 ca                	cmp    %ecx,%edx
80104b64:	72 12                	jb     80104b78 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104b66:	8b 50 04             	mov    0x4(%eax),%edx
80104b69:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b6c:	89 10                	mov    %edx,(%eax)
  return 0;
80104b6e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104b70:	5d                   	pop    %ebp
80104b71:	c3                   	ret    
80104b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104b7d:	5d                   	pop    %ebp
80104b7e:	c3                   	ret    
80104b7f:	90                   	nop

80104b80 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104b80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b86:	55                   	push   %ebp
80104b87:	89 e5                	mov    %esp,%ebp
80104b89:	56                   	push   %esi
80104b8a:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104b8b:	8b 48 18             	mov    0x18(%eax),%ecx
80104b8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b91:	8b 55 10             	mov    0x10(%ebp),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104b94:	8b 49 44             	mov    0x44(%ecx),%ecx
80104b97:	8d 1c 99             	lea    (%ecx,%ebx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104b9a:	8b 08                	mov    (%eax),%ecx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
80104b9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104ba1:	8d 73 04             	lea    0x4(%ebx),%esi

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104ba4:	39 ce                	cmp    %ecx,%esi
80104ba6:	73 1f                	jae    80104bc7 <argptr+0x47>
80104ba8:	8d 73 08             	lea    0x8(%ebx),%esi
80104bab:	39 f1                	cmp    %esi,%ecx
80104bad:	72 18                	jb     80104bc7 <argptr+0x47>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104baf:	85 d2                	test   %edx,%edx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104bb1:	8b 5b 04             	mov    0x4(%ebx),%ebx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104bb4:	78 11                	js     80104bc7 <argptr+0x47>
80104bb6:	39 cb                	cmp    %ecx,%ebx
80104bb8:	73 0d                	jae    80104bc7 <argptr+0x47>
80104bba:	01 da                	add    %ebx,%edx
80104bbc:	39 ca                	cmp    %ecx,%edx
80104bbe:	77 07                	ja     80104bc7 <argptr+0x47>
    return -1;
  *pp = (char*)i;
80104bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bc3:	89 18                	mov    %ebx,(%eax)
  return 0;
80104bc5:	31 c0                	xor    %eax,%eax
}
80104bc7:	5b                   	pop    %ebx
80104bc8:	5e                   	pop    %esi
80104bc9:	5d                   	pop    %ebp
80104bca:	c3                   	ret    
80104bcb:	90                   	nop
80104bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bd0 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104bd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bd6:	55                   	push   %ebp
80104bd7:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104bd9:	8b 50 18             	mov    0x18(%eax),%edx
80104bdc:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104bdf:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104be1:	8b 52 44             	mov    0x44(%edx),%edx
80104be4:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104be7:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104bea:	39 c1                	cmp    %eax,%ecx
80104bec:	73 07                	jae    80104bf5 <argstr+0x25>
80104bee:	8d 4a 08             	lea    0x8(%edx),%ecx
80104bf1:	39 c8                	cmp    %ecx,%eax
80104bf3:	73 0b                	jae    80104c00 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104bf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104bfa:	5d                   	pop    %ebp
80104bfb:	c3                   	ret    
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104c00:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104c03:	39 c1                	cmp    %eax,%ecx
80104c05:	73 ee                	jae    80104bf5 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
80104c07:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c0a:	89 c8                	mov    %ecx,%eax
80104c0c:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104c0e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c15:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104c17:	39 d1                	cmp    %edx,%ecx
80104c19:	73 da                	jae    80104bf5 <argstr+0x25>
    if(*s == 0)
80104c1b:	80 39 00             	cmpb   $0x0,(%ecx)
80104c1e:	75 0d                	jne    80104c2d <argstr+0x5d>
80104c20:	eb 1e                	jmp    80104c40 <argstr+0x70>
80104c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c28:	80 38 00             	cmpb   $0x0,(%eax)
80104c2b:	74 13                	je     80104c40 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104c2d:	83 c0 01             	add    $0x1,%eax
80104c30:	39 c2                	cmp    %eax,%edx
80104c32:	77 f4                	ja     80104c28 <argstr+0x58>
80104c34:	eb bf                	jmp    80104bf5 <argstr+0x25>
80104c36:	8d 76 00             	lea    0x0(%esi),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(*s == 0)
      return s - *pp;
80104c40:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c42:	5d                   	pop    %ebp
80104c43:	c3                   	ret    
80104c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c50 <syscall>:
[SYS_setnice] sys_setnice,
};

void
syscall(void)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 04             	sub    $0x4,%esp
  int num;

  num = proc->tf->eax;
80104c57:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c5e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104c61:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c64:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104c67:	83 f9 18             	cmp    $0x18,%ecx
80104c6a:	77 1c                	ja     80104c88 <syscall+0x38>
80104c6c:	8b 0c 85 80 7a 10 80 	mov    -0x7fef8580(,%eax,4),%ecx
80104c73:	85 c9                	test   %ecx,%ecx
80104c75:	74 11                	je     80104c88 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104c77:	ff d1                	call   *%ecx
80104c79:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80104c7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c7f:	c9                   	leave  
80104c80:	c3                   	ret    
80104c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104c88:	50                   	push   %eax
            proc->pid, proc->name, num);
80104c89:	8d 42 70             	lea    0x70(%edx),%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104c8c:	50                   	push   %eax
80104c8d:	ff 72 10             	pushl  0x10(%edx)
80104c90:	68 61 7a 10 80       	push   $0x80107a61
80104c95:	e8 c6 b9 ff ff       	call   80100660 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104c9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca0:	83 c4 10             	add    $0x10,%esp
80104ca3:	8b 40 18             	mov    0x18(%eax),%eax
80104ca6:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104cad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb0:	c9                   	leave  
80104cb1:	c3                   	ret    
80104cb2:	66 90                	xchg   %ax,%ax
80104cb4:	66 90                	xchg   %ax,%ax
80104cb6:	66 90                	xchg   %ax,%ax
80104cb8:	66 90                	xchg   %ax,%ax
80104cba:	66 90                	xchg   %ax,%ax
80104cbc:	66 90                	xchg   %ax,%ax
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
80104cc5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cc6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cc9:	83 ec 44             	sub    $0x44,%esp
80104ccc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104ccf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cd2:	56                   	push   %esi
80104cd3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cd4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104cd7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cda:	e8 91 d1 ff ff       	call   80101e70 <nameiparent>
80104cdf:	83 c4 10             	add    $0x10,%esp
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	0f 84 f6 00 00 00    	je     80104de0 <create+0x120>
    return 0;
  ilock(dp);
80104cea:	83 ec 0c             	sub    $0xc,%esp
80104ced:	89 c7                	mov    %eax,%edi
80104cef:	50                   	push   %eax
80104cf0:	e8 2b c9 ff ff       	call   80101620 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104cf5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104cf8:	83 c4 0c             	add    $0xc,%esp
80104cfb:	50                   	push   %eax
80104cfc:	56                   	push   %esi
80104cfd:	57                   	push   %edi
80104cfe:	e8 2d ce ff ff       	call   80101b30 <dirlookup>
80104d03:	83 c4 10             	add    $0x10,%esp
80104d06:	85 c0                	test   %eax,%eax
80104d08:	89 c3                	mov    %eax,%ebx
80104d0a:	74 54                	je     80104d60 <create+0xa0>
    iunlockput(dp);
80104d0c:	83 ec 0c             	sub    $0xc,%esp
80104d0f:	57                   	push   %edi
80104d10:	e8 7b cb ff ff       	call   80101890 <iunlockput>
    ilock(ip);
80104d15:	89 1c 24             	mov    %ebx,(%esp)
80104d18:	e8 03 c9 ff ff       	call   80101620 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104d25:	75 19                	jne    80104d40 <create+0x80>
80104d27:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104d2c:	89 d8                	mov    %ebx,%eax
80104d2e:	75 10                	jne    80104d40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d33:	5b                   	pop    %ebx
80104d34:	5e                   	pop    %esi
80104d35:	5f                   	pop    %edi
80104d36:	5d                   	pop    %ebp
80104d37:	c3                   	ret    
80104d38:	90                   	nop
80104d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104d40:	83 ec 0c             	sub    $0xc,%esp
80104d43:	53                   	push   %ebx
80104d44:	e8 47 cb ff ff       	call   80101890 <iunlockput>
    return 0;
80104d49:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104d4f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d51:	5b                   	pop    %ebx
80104d52:	5e                   	pop    %esi
80104d53:	5f                   	pop    %edi
80104d54:	5d                   	pop    %ebp
80104d55:	c3                   	ret    
80104d56:	8d 76 00             	lea    0x0(%esi),%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104d60:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104d64:	83 ec 08             	sub    $0x8,%esp
80104d67:	50                   	push   %eax
80104d68:	ff 37                	pushl  (%edi)
80104d6a:	e8 41 c7 ff ff       	call   801014b0 <ialloc>
80104d6f:	83 c4 10             	add    $0x10,%esp
80104d72:	85 c0                	test   %eax,%eax
80104d74:	89 c3                	mov    %eax,%ebx
80104d76:	0f 84 cc 00 00 00    	je     80104e48 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104d7c:	83 ec 0c             	sub    $0xc,%esp
80104d7f:	50                   	push   %eax
80104d80:	e8 9b c8 ff ff       	call   80101620 <ilock>
  ip->major = major;
80104d85:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104d89:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104d8d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104d91:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104d95:	b8 01 00 00 00       	mov    $0x1,%eax
80104d9a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104d9e:	89 1c 24             	mov    %ebx,(%esp)
80104da1:	e8 ca c7 ff ff       	call   80101570 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104da6:	83 c4 10             	add    $0x10,%esp
80104da9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104dae:	74 40                	je     80104df0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104db0:	83 ec 04             	sub    $0x4,%esp
80104db3:	ff 73 04             	pushl  0x4(%ebx)
80104db6:	56                   	push   %esi
80104db7:	57                   	push   %edi
80104db8:	e8 d3 cf ff ff       	call   80101d90 <dirlink>
80104dbd:	83 c4 10             	add    $0x10,%esp
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	78 77                	js     80104e3b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104dc4:	83 ec 0c             	sub    $0xc,%esp
80104dc7:	57                   	push   %edi
80104dc8:	e8 c3 ca ff ff       	call   80101890 <iunlockput>

  return ip;
80104dcd:	83 c4 10             	add    $0x10,%esp
}
80104dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104dd3:	89 d8                	mov    %ebx,%eax
}
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5f                   	pop    %edi
80104dd8:	5d                   	pop    %ebp
80104dd9:	c3                   	ret    
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104de0:	31 c0                	xor    %eax,%eax
80104de2:	e9 49 ff ff ff       	jmp    80104d30 <create+0x70>
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104df0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104df5:	83 ec 0c             	sub    $0xc,%esp
80104df8:	57                   	push   %edi
80104df9:	e8 72 c7 ff ff       	call   80101570 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dfe:	83 c4 0c             	add    $0xc,%esp
80104e01:	ff 73 04             	pushl  0x4(%ebx)
80104e04:	68 04 7b 10 80       	push   $0x80107b04
80104e09:	53                   	push   %ebx
80104e0a:	e8 81 cf ff ff       	call   80101d90 <dirlink>
80104e0f:	83 c4 10             	add    $0x10,%esp
80104e12:	85 c0                	test   %eax,%eax
80104e14:	78 18                	js     80104e2e <create+0x16e>
80104e16:	83 ec 04             	sub    $0x4,%esp
80104e19:	ff 77 04             	pushl  0x4(%edi)
80104e1c:	68 03 7b 10 80       	push   $0x80107b03
80104e21:	53                   	push   %ebx
80104e22:	e8 69 cf ff ff       	call   80101d90 <dirlink>
80104e27:	83 c4 10             	add    $0x10,%esp
80104e2a:	85 c0                	test   %eax,%eax
80104e2c:	79 82                	jns    80104db0 <create+0xf0>
      panic("create dots");
80104e2e:	83 ec 0c             	sub    $0xc,%esp
80104e31:	68 f7 7a 10 80       	push   $0x80107af7
80104e36:	e8 35 b5 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104e3b:	83 ec 0c             	sub    $0xc,%esp
80104e3e:	68 06 7b 10 80       	push   $0x80107b06
80104e43:	e8 28 b5 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	68 e8 7a 10 80       	push   $0x80107ae8
80104e50:	e8 1b b5 ff ff       	call   80100370 <panic>
80104e55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
80104e65:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104e67:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104e6a:	89 d3                	mov    %edx,%ebx
80104e6c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104e6f:	50                   	push   %eax
80104e70:	6a 00                	push   $0x0
80104e72:	e8 c9 fc ff ff       	call   80104b40 <argint>
80104e77:	83 c4 10             	add    $0x10,%esp
80104e7a:	85 c0                	test   %eax,%eax
80104e7c:	78 3a                	js     80104eb8 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e81:	83 f8 0f             	cmp    $0xf,%eax
80104e84:	77 32                	ja     80104eb8 <argfd.constprop.0+0x58>
80104e86:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e8d:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
80104e91:	85 d2                	test   %edx,%edx
80104e93:	74 23                	je     80104eb8 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104e95:	85 f6                	test   %esi,%esi
80104e97:	74 02                	je     80104e9b <argfd.constprop.0+0x3b>
    *pfd = fd;
80104e99:	89 06                	mov    %eax,(%esi)
  if(pf)
80104e9b:	85 db                	test   %ebx,%ebx
80104e9d:	74 11                	je     80104eb0 <argfd.constprop.0+0x50>
    *pf = f;
80104e9f:	89 13                	mov    %edx,(%ebx)
  return 0;
80104ea1:	31 c0                	xor    %eax,%eax
}
80104ea3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ea6:	5b                   	pop    %ebx
80104ea7:	5e                   	pop    %esi
80104ea8:	5d                   	pop    %ebp
80104ea9:	c3                   	ret    
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104eb0:	31 c0                	xor    %eax,%eax
80104eb2:	eb ef                	jmp    80104ea3 <argfd.constprop.0+0x43>
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ebd:	eb e4                	jmp    80104ea3 <argfd.constprop.0+0x43>
80104ebf:	90                   	nop

80104ec0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104ec0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ec1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ec6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104ec9:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ecc:	e8 8f ff ff ff       	call   80104e60 <argfd.constprop.0>
80104ed1:	85 c0                	test   %eax,%eax
80104ed3:	78 1b                	js     80104ef0 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ed8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104ede:	31 db                	xor    %ebx,%ebx
    if(proc->ofile[fd] == 0){
80104ee0:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104ee4:	85 c9                	test   %ecx,%ecx
80104ee6:	74 18                	je     80104f00 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104ee8:	83 c3 01             	add    $0x1,%ebx
80104eeb:	83 fb 10             	cmp    $0x10,%ebx
80104eee:	75 f0                	jne    80104ee0 <sys_dup+0x20>
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104ef5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ef8:	c9                   	leave  
80104ef9:	c3                   	ret    
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104f00:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104f03:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104f07:	52                   	push   %edx
80104f08:	e8 b3 be ff ff       	call   80100dc0 <filedup>
  return fd;
80104f0d:	89 d8                	mov    %ebx,%eax
80104f0f:	83 c4 10             	add    $0x10,%esp
}
80104f12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f15:	c9                   	leave  
80104f16:	c3                   	ret    
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <sys_read>:

int
sys_read(void)
{
80104f20:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f21:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104f23:	89 e5                	mov    %esp,%ebp
80104f25:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f2b:	e8 30 ff ff ff       	call   80104e60 <argfd.constprop.0>
80104f30:	85 c0                	test   %eax,%eax
80104f32:	78 4c                	js     80104f80 <sys_read+0x60>
80104f34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f37:	83 ec 08             	sub    $0x8,%esp
80104f3a:	50                   	push   %eax
80104f3b:	6a 02                	push   $0x2
80104f3d:	e8 fe fb ff ff       	call   80104b40 <argint>
80104f42:	83 c4 10             	add    $0x10,%esp
80104f45:	85 c0                	test   %eax,%eax
80104f47:	78 37                	js     80104f80 <sys_read+0x60>
80104f49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f4c:	83 ec 04             	sub    $0x4,%esp
80104f4f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f52:	50                   	push   %eax
80104f53:	6a 01                	push   $0x1
80104f55:	e8 26 fc ff ff       	call   80104b80 <argptr>
80104f5a:	83 c4 10             	add    $0x10,%esp
80104f5d:	85 c0                	test   %eax,%eax
80104f5f:	78 1f                	js     80104f80 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104f61:	83 ec 04             	sub    $0x4,%esp
80104f64:	ff 75 f0             	pushl  -0x10(%ebp)
80104f67:	ff 75 f4             	pushl  -0xc(%ebp)
80104f6a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f6d:	e8 be bf ff ff       	call   80100f30 <fileread>
80104f72:	83 c4 10             	add    $0x10,%esp
}
80104f75:	c9                   	leave  
80104f76:	c3                   	ret    
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104f85:	c9                   	leave  
80104f86:	c3                   	ret    
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f90 <sys_write>:

int
sys_write(void)
{
80104f90:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f91:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104f93:	89 e5                	mov    %esp,%ebp
80104f95:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f98:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f9b:	e8 c0 fe ff ff       	call   80104e60 <argfd.constprop.0>
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	78 4c                	js     80104ff0 <sys_write+0x60>
80104fa4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fa7:	83 ec 08             	sub    $0x8,%esp
80104faa:	50                   	push   %eax
80104fab:	6a 02                	push   $0x2
80104fad:	e8 8e fb ff ff       	call   80104b40 <argint>
80104fb2:	83 c4 10             	add    $0x10,%esp
80104fb5:	85 c0                	test   %eax,%eax
80104fb7:	78 37                	js     80104ff0 <sys_write+0x60>
80104fb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fbc:	83 ec 04             	sub    $0x4,%esp
80104fbf:	ff 75 f0             	pushl  -0x10(%ebp)
80104fc2:	50                   	push   %eax
80104fc3:	6a 01                	push   $0x1
80104fc5:	e8 b6 fb ff ff       	call   80104b80 <argptr>
80104fca:	83 c4 10             	add    $0x10,%esp
80104fcd:	85 c0                	test   %eax,%eax
80104fcf:	78 1f                	js     80104ff0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104fd1:	83 ec 04             	sub    $0x4,%esp
80104fd4:	ff 75 f0             	pushl  -0x10(%ebp)
80104fd7:	ff 75 f4             	pushl  -0xc(%ebp)
80104fda:	ff 75 ec             	pushl  -0x14(%ebp)
80104fdd:	e8 de bf ff ff       	call   80100fc0 <filewrite>
80104fe2:	83 c4 10             	add    $0x10,%esp
}
80104fe5:	c9                   	leave  
80104fe6:	c3                   	ret    
80104fe7:	89 f6                	mov    %esi,%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104ff5:	c9                   	leave  
80104ff6:	c3                   	ret    
80104ff7:	89 f6                	mov    %esi,%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105000 <sys_close>:

int
sys_close(void)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105006:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105009:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010500c:	e8 4f fe ff ff       	call   80104e60 <argfd.constprop.0>
80105011:	85 c0                	test   %eax,%eax
80105013:	78 2b                	js     80105040 <sys_close+0x40>
    return -1;
  proc->ofile[fd] = 0;
80105015:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105018:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  fileclose(f);
8010501e:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  proc->ofile[fd] = 0;
80105021:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105028:	00 
  fileclose(f);
80105029:	ff 75 f4             	pushl  -0xc(%ebp)
8010502c:	e8 df bd ff ff       	call   80100e10 <fileclose>
  return 0;
80105031:	83 c4 10             	add    $0x10,%esp
80105034:	31 c0                	xor    %eax,%eax
}
80105036:	c9                   	leave  
80105037:	c3                   	ret    
80105038:	90                   	nop
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105045:	c9                   	leave  
80105046:	c3                   	ret    
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <sys_fstat>:

int
sys_fstat(void)
{
80105050:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105051:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105053:	89 e5                	mov    %esp,%ebp
80105055:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105058:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010505b:	e8 00 fe ff ff       	call   80104e60 <argfd.constprop.0>
80105060:	85 c0                	test   %eax,%eax
80105062:	78 2c                	js     80105090 <sys_fstat+0x40>
80105064:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105067:	83 ec 04             	sub    $0x4,%esp
8010506a:	6a 14                	push   $0x14
8010506c:	50                   	push   %eax
8010506d:	6a 01                	push   $0x1
8010506f:	e8 0c fb ff ff       	call   80104b80 <argptr>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	78 15                	js     80105090 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010507b:	83 ec 08             	sub    $0x8,%esp
8010507e:	ff 75 f4             	pushl  -0xc(%ebp)
80105081:	ff 75 f0             	pushl  -0x10(%ebp)
80105084:	e8 57 be ff ff       	call   80100ee0 <filestat>
80105089:	83 c4 10             	add    $0x10,%esp
}
8010508c:	c9                   	leave  
8010508d:	c3                   	ret    
8010508e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105095:	c9                   	leave  
80105096:	c3                   	ret    
80105097:	89 f6                	mov    %esi,%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
801050a5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801050a9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 1c fb ff ff       	call   80104bd0 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 fb 00 00 00    	js     801051ba <sys_link+0x11a>
801050bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050c2:	83 ec 08             	sub    $0x8,%esp
801050c5:	50                   	push   %eax
801050c6:	6a 01                	push   $0x1
801050c8:	e8 03 fb ff ff       	call   80104bd0 <argstr>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	0f 88 e2 00 00 00    	js     801051ba <sys_link+0x11a>
    return -1;

  begin_op();
801050d8:	e8 a3 da ff ff       	call   80102b80 <begin_op>
  if((ip = namei(old)) == 0){
801050dd:	83 ec 0c             	sub    $0xc,%esp
801050e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801050e3:	e8 68 cd ff ff       	call   80101e50 <namei>
801050e8:	83 c4 10             	add    $0x10,%esp
801050eb:	85 c0                	test   %eax,%eax
801050ed:	89 c3                	mov    %eax,%ebx
801050ef:	0f 84 f3 00 00 00    	je     801051e8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
801050f5:	83 ec 0c             	sub    $0xc,%esp
801050f8:	50                   	push   %eax
801050f9:	e8 22 c5 ff ff       	call   80101620 <ilock>
  if(ip->type == T_DIR){
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105106:	0f 84 c4 00 00 00    	je     801051d0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010510c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105111:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105114:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105117:	53                   	push   %ebx
80105118:	e8 53 c4 ff ff       	call   80101570 <iupdate>
  iunlock(ip);
8010511d:	89 1c 24             	mov    %ebx,(%esp)
80105120:	e8 db c5 ff ff       	call   80101700 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105125:	58                   	pop    %eax
80105126:	5a                   	pop    %edx
80105127:	57                   	push   %edi
80105128:	ff 75 d0             	pushl  -0x30(%ebp)
8010512b:	e8 40 cd ff ff       	call   80101e70 <nameiparent>
80105130:	83 c4 10             	add    $0x10,%esp
80105133:	85 c0                	test   %eax,%eax
80105135:	89 c6                	mov    %eax,%esi
80105137:	74 5b                	je     80105194 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105139:	83 ec 0c             	sub    $0xc,%esp
8010513c:	50                   	push   %eax
8010513d:	e8 de c4 ff ff       	call   80101620 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	8b 03                	mov    (%ebx),%eax
80105147:	39 06                	cmp    %eax,(%esi)
80105149:	75 3d                	jne    80105188 <sys_link+0xe8>
8010514b:	83 ec 04             	sub    $0x4,%esp
8010514e:	ff 73 04             	pushl  0x4(%ebx)
80105151:	57                   	push   %edi
80105152:	56                   	push   %esi
80105153:	e8 38 cc ff ff       	call   80101d90 <dirlink>
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	85 c0                	test   %eax,%eax
8010515d:	78 29                	js     80105188 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010515f:	83 ec 0c             	sub    $0xc,%esp
80105162:	56                   	push   %esi
80105163:	e8 28 c7 ff ff       	call   80101890 <iunlockput>
  iput(ip);
80105168:	89 1c 24             	mov    %ebx,(%esp)
8010516b:	e8 e0 c5 ff ff       	call   80101750 <iput>

  end_op();
80105170:	e8 7b da ff ff       	call   80102bf0 <end_op>

  return 0;
80105175:	83 c4 10             	add    $0x10,%esp
80105178:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010517a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010517d:	5b                   	pop    %ebx
8010517e:	5e                   	pop    %esi
8010517f:	5f                   	pop    %edi
80105180:	5d                   	pop    %ebp
80105181:	c3                   	ret    
80105182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105188:	83 ec 0c             	sub    $0xc,%esp
8010518b:	56                   	push   %esi
8010518c:	e8 ff c6 ff ff       	call   80101890 <iunlockput>
    goto bad;
80105191:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105194:	83 ec 0c             	sub    $0xc,%esp
80105197:	53                   	push   %ebx
80105198:	e8 83 c4 ff ff       	call   80101620 <ilock>
  ip->nlink--;
8010519d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051a2:	89 1c 24             	mov    %ebx,(%esp)
801051a5:	e8 c6 c3 ff ff       	call   80101570 <iupdate>
  iunlockput(ip);
801051aa:	89 1c 24             	mov    %ebx,(%esp)
801051ad:	e8 de c6 ff ff       	call   80101890 <iunlockput>
  end_op();
801051b2:	e8 39 da ff ff       	call   80102bf0 <end_op>
  return -1;
801051b7:	83 c4 10             	add    $0x10,%esp
}
801051ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801051bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c2:	5b                   	pop    %ebx
801051c3:	5e                   	pop    %esi
801051c4:	5f                   	pop    %edi
801051c5:	5d                   	pop    %ebp
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	53                   	push   %ebx
801051d4:	e8 b7 c6 ff ff       	call   80101890 <iunlockput>
    end_op();
801051d9:	e8 12 da ff ff       	call   80102bf0 <end_op>
    return -1;
801051de:	83 c4 10             	add    $0x10,%esp
801051e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e6:	eb 92                	jmp    8010517a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
801051e8:	e8 03 da ff ff       	call   80102bf0 <end_op>
    return -1;
801051ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f2:	eb 86                	jmp    8010517a <sys_link+0xda>
801051f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105200 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
80105205:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105206:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105209:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 bc f9 ff ff       	call   80104bd0 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 82 01 00 00    	js     801053a1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010521f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105222:	e8 59 d9 ff ff       	call   80102b80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105227:	83 ec 08             	sub    $0x8,%esp
8010522a:	53                   	push   %ebx
8010522b:	ff 75 c0             	pushl  -0x40(%ebp)
8010522e:	e8 3d cc ff ff       	call   80101e70 <nameiparent>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	85 c0                	test   %eax,%eax
80105238:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010523b:	0f 84 6a 01 00 00    	je     801053ab <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105241:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105244:	83 ec 0c             	sub    $0xc,%esp
80105247:	56                   	push   %esi
80105248:	e8 d3 c3 ff ff       	call   80101620 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010524d:	58                   	pop    %eax
8010524e:	5a                   	pop    %edx
8010524f:	68 04 7b 10 80       	push   $0x80107b04
80105254:	53                   	push   %ebx
80105255:	e8 b6 c8 ff ff       	call   80101b10 <namecmp>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	85 c0                	test   %eax,%eax
8010525f:	0f 84 fc 00 00 00    	je     80105361 <sys_unlink+0x161>
80105265:	83 ec 08             	sub    $0x8,%esp
80105268:	68 03 7b 10 80       	push   $0x80107b03
8010526d:	53                   	push   %ebx
8010526e:	e8 9d c8 ff ff       	call   80101b10 <namecmp>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	0f 84 e3 00 00 00    	je     80105361 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010527e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105281:	83 ec 04             	sub    $0x4,%esp
80105284:	50                   	push   %eax
80105285:	53                   	push   %ebx
80105286:	56                   	push   %esi
80105287:	e8 a4 c8 ff ff       	call   80101b30 <dirlookup>
8010528c:	83 c4 10             	add    $0x10,%esp
8010528f:	85 c0                	test   %eax,%eax
80105291:	89 c3                	mov    %eax,%ebx
80105293:	0f 84 c8 00 00 00    	je     80105361 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	50                   	push   %eax
8010529d:	e8 7e c3 ff ff       	call   80101620 <ilock>

  if(ip->nlink < 1)
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052aa:	0f 8e 24 01 00 00    	jle    801053d4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801052b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052b5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801052b8:	74 66                	je     80105320 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801052ba:	83 ec 04             	sub    $0x4,%esp
801052bd:	6a 10                	push   $0x10
801052bf:	6a 00                	push   $0x0
801052c1:	56                   	push   %esi
801052c2:	e8 89 f5 ff ff       	call   80104850 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052c7:	6a 10                	push   $0x10
801052c9:	ff 75 c4             	pushl  -0x3c(%ebp)
801052cc:	56                   	push   %esi
801052cd:	ff 75 b4             	pushl  -0x4c(%ebp)
801052d0:	e8 0b c7 ff ff       	call   801019e0 <writei>
801052d5:	83 c4 20             	add    $0x20,%esp
801052d8:	83 f8 10             	cmp    $0x10,%eax
801052db:	0f 85 e6 00 00 00    	jne    801053c7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801052e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052e6:	0f 84 9c 00 00 00    	je     80105388 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801052ec:	83 ec 0c             	sub    $0xc,%esp
801052ef:	ff 75 b4             	pushl  -0x4c(%ebp)
801052f2:	e8 99 c5 ff ff       	call   80101890 <iunlockput>

  ip->nlink--;
801052f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052fc:	89 1c 24             	mov    %ebx,(%esp)
801052ff:	e8 6c c2 ff ff       	call   80101570 <iupdate>
  iunlockput(ip);
80105304:	89 1c 24             	mov    %ebx,(%esp)
80105307:	e8 84 c5 ff ff       	call   80101890 <iunlockput>

  end_op();
8010530c:	e8 df d8 ff ff       	call   80102bf0 <end_op>

  return 0;
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105316:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105319:	5b                   	pop    %ebx
8010531a:	5e                   	pop    %esi
8010531b:	5f                   	pop    %edi
8010531c:	5d                   	pop    %ebp
8010531d:	c3                   	ret    
8010531e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105320:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105324:	76 94                	jbe    801052ba <sys_unlink+0xba>
80105326:	bf 20 00 00 00       	mov    $0x20,%edi
8010532b:	eb 0f                	jmp    8010533c <sys_unlink+0x13c>
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
80105330:	83 c7 10             	add    $0x10,%edi
80105333:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105336:	0f 83 7e ff ff ff    	jae    801052ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010533c:	6a 10                	push   $0x10
8010533e:	57                   	push   %edi
8010533f:	56                   	push   %esi
80105340:	53                   	push   %ebx
80105341:	e8 9a c5 ff ff       	call   801018e0 <readi>
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	83 f8 10             	cmp    $0x10,%eax
8010534c:	75 6c                	jne    801053ba <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010534e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105353:	74 db                	je     80105330 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105355:	83 ec 0c             	sub    $0xc,%esp
80105358:	53                   	push   %ebx
80105359:	e8 32 c5 ff ff       	call   80101890 <iunlockput>
    goto bad;
8010535e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105361:	83 ec 0c             	sub    $0xc,%esp
80105364:	ff 75 b4             	pushl  -0x4c(%ebp)
80105367:	e8 24 c5 ff ff       	call   80101890 <iunlockput>
  end_op();
8010536c:	e8 7f d8 ff ff       	call   80102bf0 <end_op>
  return -1;
80105371:	83 c4 10             	add    $0x10,%esp
}
80105374:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010537c:	5b                   	pop    %ebx
8010537d:	5e                   	pop    %esi
8010537e:	5f                   	pop    %edi
8010537f:	5d                   	pop    %ebp
80105380:	c3                   	ret    
80105381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105388:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010538b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010538e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105393:	50                   	push   %eax
80105394:	e8 d7 c1 ff ff       	call   80101570 <iupdate>
80105399:	83 c4 10             	add    $0x10,%esp
8010539c:	e9 4b ff ff ff       	jmp    801052ec <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801053a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053a6:	e9 6b ff ff ff       	jmp    80105316 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801053ab:	e8 40 d8 ff ff       	call   80102bf0 <end_op>
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b5:	e9 5c ff ff ff       	jmp    80105316 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	68 28 7b 10 80       	push   $0x80107b28
801053c2:	e8 a9 af ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801053c7:	83 ec 0c             	sub    $0xc,%esp
801053ca:	68 3a 7b 10 80       	push   $0x80107b3a
801053cf:	e8 9c af ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	68 16 7b 10 80       	push   $0x80107b16
801053dc:	e8 8f af ff ff       	call   80100370 <panic>
801053e1:	eb 0d                	jmp    801053f0 <sys_open>
801053e3:	90                   	nop
801053e4:	90                   	nop
801053e5:	90                   	nop
801053e6:	90                   	nop
801053e7:	90                   	nop
801053e8:	90                   	nop
801053e9:	90                   	nop
801053ea:	90                   	nop
801053eb:	90                   	nop
801053ec:	90                   	nop
801053ed:	90                   	nop
801053ee:	90                   	nop
801053ef:	90                   	nop

801053f0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
801053f5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801053f9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053fc:	50                   	push   %eax
801053fd:	6a 00                	push   $0x0
801053ff:	e8 cc f7 ff ff       	call   80104bd0 <argstr>
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	85 c0                	test   %eax,%eax
80105409:	0f 88 9e 00 00 00    	js     801054ad <sys_open+0xbd>
8010540f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105412:	83 ec 08             	sub    $0x8,%esp
80105415:	50                   	push   %eax
80105416:	6a 01                	push   $0x1
80105418:	e8 23 f7 ff ff       	call   80104b40 <argint>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	0f 88 85 00 00 00    	js     801054ad <sys_open+0xbd>
    return -1;

  begin_op();
80105428:	e8 53 d7 ff ff       	call   80102b80 <begin_op>

  if(omode & O_CREATE){
8010542d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105431:	0f 85 89 00 00 00    	jne    801054c0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105437:	83 ec 0c             	sub    $0xc,%esp
8010543a:	ff 75 e0             	pushl  -0x20(%ebp)
8010543d:	e8 0e ca ff ff       	call   80101e50 <namei>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	85 c0                	test   %eax,%eax
80105447:	89 c7                	mov    %eax,%edi
80105449:	0f 84 8e 00 00 00    	je     801054dd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	50                   	push   %eax
80105453:	e8 c8 c1 ff ff       	call   80101620 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105458:	83 c4 10             	add    $0x10,%esp
8010545b:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80105460:	0f 84 d2 00 00 00    	je     80105538 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105466:	e8 e5 b8 ff ff       	call   80100d50 <filealloc>
8010546b:	85 c0                	test   %eax,%eax
8010546d:	89 c6                	mov    %eax,%esi
8010546f:	74 2b                	je     8010549c <sys_open+0xac>
80105471:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105478:	31 db                	xor    %ebx,%ebx
8010547a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105480:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
80105484:	85 c0                	test   %eax,%eax
80105486:	74 68                	je     801054f0 <sys_open+0x100>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105488:	83 c3 01             	add    $0x1,%ebx
8010548b:	83 fb 10             	cmp    $0x10,%ebx
8010548e:	75 f0                	jne    80105480 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	56                   	push   %esi
80105494:	e8 77 b9 ff ff       	call   80100e10 <fileclose>
80105499:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010549c:	83 ec 0c             	sub    $0xc,%esp
8010549f:	57                   	push   %edi
801054a0:	e8 eb c3 ff ff       	call   80101890 <iunlockput>
    end_op();
801054a5:	e8 46 d7 ff ff       	call   80102bf0 <end_op>
    return -1;
801054aa:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801054ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801054b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801054b5:	5b                   	pop    %ebx
801054b6:	5e                   	pop    %esi
801054b7:	5f                   	pop    %edi
801054b8:	5d                   	pop    %ebp
801054b9:	c3                   	ret    
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054c6:	31 c9                	xor    %ecx,%ecx
801054c8:	6a 00                	push   $0x0
801054ca:	ba 02 00 00 00       	mov    $0x2,%edx
801054cf:	e8 ec f7 ff ff       	call   80104cc0 <create>
    if(ip == 0){
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801054d9:	89 c7                	mov    %eax,%edi
    if(ip == 0){
801054db:	75 89                	jne    80105466 <sys_open+0x76>
      end_op();
801054dd:	e8 0e d7 ff ff       	call   80102bf0 <end_op>
      return -1;
801054e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e7:	eb 43                	jmp    8010552c <sys_open+0x13c>
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054f0:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801054f3:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054f7:	57                   	push   %edi
801054f8:	e8 03 c2 ff ff       	call   80101700 <iunlock>
  end_op();
801054fd:	e8 ee d6 ff ff       	call   80102bf0 <end_op>

  f->type = FD_INODE;
80105502:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105508:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010550b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010550e:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80105511:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80105518:	89 d0                	mov    %edx,%eax
8010551a:	83 e0 01             	and    $0x1,%eax
8010551d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105520:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105523:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105526:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
8010552a:	89 d8                	mov    %ebx,%eax
}
8010552c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010552f:	5b                   	pop    %ebx
80105530:	5e                   	pop    %esi
80105531:	5f                   	pop    %edi
80105532:	5d                   	pop    %ebp
80105533:	c3                   	ret    
80105534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105538:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010553b:	85 d2                	test   %edx,%edx
8010553d:	0f 84 23 ff ff ff    	je     80105466 <sys_open+0x76>
80105543:	e9 54 ff ff ff       	jmp    8010549c <sys_open+0xac>
80105548:	90                   	nop
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105550 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105556:	e8 25 d6 ff ff       	call   80102b80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010555b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010555e:	83 ec 08             	sub    $0x8,%esp
80105561:	50                   	push   %eax
80105562:	6a 00                	push   $0x0
80105564:	e8 67 f6 ff ff       	call   80104bd0 <argstr>
80105569:	83 c4 10             	add    $0x10,%esp
8010556c:	85 c0                	test   %eax,%eax
8010556e:	78 30                	js     801055a0 <sys_mkdir+0x50>
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105576:	31 c9                	xor    %ecx,%ecx
80105578:	6a 00                	push   $0x0
8010557a:	ba 01 00 00 00       	mov    $0x1,%edx
8010557f:	e8 3c f7 ff ff       	call   80104cc0 <create>
80105584:	83 c4 10             	add    $0x10,%esp
80105587:	85 c0                	test   %eax,%eax
80105589:	74 15                	je     801055a0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010558b:	83 ec 0c             	sub    $0xc,%esp
8010558e:	50                   	push   %eax
8010558f:	e8 fc c2 ff ff       	call   80101890 <iunlockput>
  end_op();
80105594:	e8 57 d6 ff ff       	call   80102bf0 <end_op>
  return 0;
80105599:	83 c4 10             	add    $0x10,%esp
8010559c:	31 c0                	xor    %eax,%eax
}
8010559e:	c9                   	leave  
8010559f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801055a0:	e8 4b d6 ff ff       	call   80102bf0 <end_op>
    return -1;
801055a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801055aa:	c9                   	leave  
801055ab:	c3                   	ret    
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055b0 <sys_mknod>:

int
sys_mknod(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055b6:	e8 c5 d5 ff ff       	call   80102b80 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055be:	83 ec 08             	sub    $0x8,%esp
801055c1:	50                   	push   %eax
801055c2:	6a 00                	push   $0x0
801055c4:	e8 07 f6 ff ff       	call   80104bd0 <argstr>
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	85 c0                	test   %eax,%eax
801055ce:	78 60                	js     80105630 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055d3:	83 ec 08             	sub    $0x8,%esp
801055d6:	50                   	push   %eax
801055d7:	6a 01                	push   $0x1
801055d9:	e8 62 f5 ff ff       	call   80104b40 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	85 c0                	test   %eax,%eax
801055e3:	78 4b                	js     80105630 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801055e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055e8:	83 ec 08             	sub    $0x8,%esp
801055eb:	50                   	push   %eax
801055ec:	6a 02                	push   $0x2
801055ee:	e8 4d f5 ff ff       	call   80104b40 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801055f3:	83 c4 10             	add    $0x10,%esp
801055f6:	85 c0                	test   %eax,%eax
801055f8:	78 36                	js     80105630 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055fa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055fe:	83 ec 0c             	sub    $0xc,%esp
80105601:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105605:	ba 03 00 00 00       	mov    $0x3,%edx
8010560a:	50                   	push   %eax
8010560b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010560e:	e8 ad f6 ff ff       	call   80104cc0 <create>
80105613:	83 c4 10             	add    $0x10,%esp
80105616:	85 c0                	test   %eax,%eax
80105618:	74 16                	je     80105630 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010561a:	83 ec 0c             	sub    $0xc,%esp
8010561d:	50                   	push   %eax
8010561e:	e8 6d c2 ff ff       	call   80101890 <iunlockput>
  end_op();
80105623:	e8 c8 d5 ff ff       	call   80102bf0 <end_op>
  return 0;
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	31 c0                	xor    %eax,%eax
}
8010562d:	c9                   	leave  
8010562e:	c3                   	ret    
8010562f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105630:	e8 bb d5 ff ff       	call   80102bf0 <end_op>
    return -1;
80105635:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010563a:	c9                   	leave  
8010563b:	c3                   	ret    
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_chdir>:

int
sys_chdir(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	53                   	push   %ebx
80105644:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105647:	e8 34 d5 ff ff       	call   80102b80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010564c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010564f:	83 ec 08             	sub    $0x8,%esp
80105652:	50                   	push   %eax
80105653:	6a 00                	push   $0x0
80105655:	e8 76 f5 ff ff       	call   80104bd0 <argstr>
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	85 c0                	test   %eax,%eax
8010565f:	78 7f                	js     801056e0 <sys_chdir+0xa0>
80105661:	83 ec 0c             	sub    $0xc,%esp
80105664:	ff 75 f4             	pushl  -0xc(%ebp)
80105667:	e8 e4 c7 ff ff       	call   80101e50 <namei>
8010566c:	83 c4 10             	add    $0x10,%esp
8010566f:	85 c0                	test   %eax,%eax
80105671:	89 c3                	mov    %eax,%ebx
80105673:	74 6b                	je     801056e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105675:	83 ec 0c             	sub    $0xc,%esp
80105678:	50                   	push   %eax
80105679:	e8 a2 bf ff ff       	call   80101620 <ilock>
  if(ip->type != T_DIR){
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105686:	75 38                	jne    801056c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105688:	83 ec 0c             	sub    $0xc,%esp
8010568b:	53                   	push   %ebx
8010568c:	e8 6f c0 ff ff       	call   80101700 <iunlock>
  iput(proc->cwd);
80105691:	58                   	pop    %eax
80105692:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105698:	ff 70 68             	pushl  0x68(%eax)
8010569b:	e8 b0 c0 ff ff       	call   80101750 <iput>
  end_op();
801056a0:	e8 4b d5 ff ff       	call   80102bf0 <end_op>
  proc->cwd = ip;
801056a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
801056ab:	83 c4 10             	add    $0x10,%esp
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
801056ae:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
801056b1:	31 c0                	xor    %eax,%eax
}
801056b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056b6:	c9                   	leave  
801056b7:	c3                   	ret    
801056b8:	90                   	nop
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	53                   	push   %ebx
801056c4:	e8 c7 c1 ff ff       	call   80101890 <iunlockput>
    end_op();
801056c9:	e8 22 d5 ff ff       	call   80102bf0 <end_op>
    return -1;
801056ce:	83 c4 10             	add    $0x10,%esp
801056d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d6:	eb db                	jmp    801056b3 <sys_chdir+0x73>
801056d8:	90                   	nop
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801056e0:	e8 0b d5 ff ff       	call   80102bf0 <end_op>
    return -1;
801056e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ea:	eb c7                	jmp    801056b3 <sys_chdir+0x73>
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056f0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	57                   	push   %edi
801056f4:	56                   	push   %esi
801056f5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056f6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801056fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105702:	50                   	push   %eax
80105703:	6a 00                	push   $0x0
80105705:	e8 c6 f4 ff ff       	call   80104bd0 <argstr>
8010570a:	83 c4 10             	add    $0x10,%esp
8010570d:	85 c0                	test   %eax,%eax
8010570f:	78 7f                	js     80105790 <sys_exec+0xa0>
80105711:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105717:	83 ec 08             	sub    $0x8,%esp
8010571a:	50                   	push   %eax
8010571b:	6a 01                	push   $0x1
8010571d:	e8 1e f4 ff ff       	call   80104b40 <argint>
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	85 c0                	test   %eax,%eax
80105727:	78 67                	js     80105790 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105729:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010572f:	83 ec 04             	sub    $0x4,%esp
80105732:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105738:	68 80 00 00 00       	push   $0x80
8010573d:	6a 00                	push   $0x0
8010573f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105745:	50                   	push   %eax
80105746:	31 db                	xor    %ebx,%ebx
80105748:	e8 03 f1 ff ff       	call   80104850 <memset>
8010574d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105750:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105756:	83 ec 08             	sub    $0x8,%esp
80105759:	57                   	push   %edi
8010575a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010575d:	50                   	push   %eax
8010575e:	e8 5d f3 ff ff       	call   80104ac0 <fetchint>
80105763:	83 c4 10             	add    $0x10,%esp
80105766:	85 c0                	test   %eax,%eax
80105768:	78 26                	js     80105790 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010576a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105770:	85 c0                	test   %eax,%eax
80105772:	74 2c                	je     801057a0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105774:	83 ec 08             	sub    $0x8,%esp
80105777:	56                   	push   %esi
80105778:	50                   	push   %eax
80105779:	e8 72 f3 ff ff       	call   80104af0 <fetchstr>
8010577e:	83 c4 10             	add    $0x10,%esp
80105781:	85 c0                	test   %eax,%eax
80105783:	78 0b                	js     80105790 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105785:	83 c3 01             	add    $0x1,%ebx
80105788:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010578b:	83 fb 20             	cmp    $0x20,%ebx
8010578e:	75 c0                	jne    80105750 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105790:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105793:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105798:	5b                   	pop    %ebx
80105799:	5e                   	pop    %esi
8010579a:	5f                   	pop    %edi
8010579b:	5d                   	pop    %ebp
8010579c:	c3                   	ret    
8010579d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801057a0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801057a6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801057a9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057b0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801057b4:	50                   	push   %eax
801057b5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801057bb:	e8 30 b2 ff ff       	call   801009f0 <exec>
801057c0:	83 c4 10             	add    $0x10,%esp
}
801057c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c6:	5b                   	pop    %ebx
801057c7:	5e                   	pop    %esi
801057c8:	5f                   	pop    %edi
801057c9:	5d                   	pop    %ebp
801057ca:	c3                   	ret    
801057cb:	90                   	nop
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_pipe>:

int
sys_pipe(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801057d9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057dc:	6a 08                	push   $0x8
801057de:	50                   	push   %eax
801057df:	6a 00                	push   $0x0
801057e1:	e8 9a f3 ff ff       	call   80104b80 <argptr>
801057e6:	83 c4 10             	add    $0x10,%esp
801057e9:	85 c0                	test   %eax,%eax
801057eb:	78 48                	js     80105835 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057ed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	50                   	push   %eax
801057f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057f7:	50                   	push   %eax
801057f8:	e8 03 db ff ff       	call   80103300 <pipealloc>
801057fd:	83 c4 10             	add    $0x10,%esp
80105800:	85 c0                	test   %eax,%eax
80105802:	78 31                	js     80105835 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105804:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80105807:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010580e:	31 c0                	xor    %eax,%eax
    if(proc->ofile[fd] == 0){
80105810:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105814:	85 d2                	test   %edx,%edx
80105816:	74 28                	je     80105840 <sys_pipe+0x70>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105818:	83 c0 01             	add    $0x1,%eax
8010581b:	83 f8 10             	cmp    $0x10,%eax
8010581e:	75 f0                	jne    80105810 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	53                   	push   %ebx
80105824:	e8 e7 b5 ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
80105829:	58                   	pop    %eax
8010582a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010582d:	e8 de b5 ff ff       	call   80100e10 <fileclose>
    return -1;
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583a:	eb 45                	jmp    80105881 <sys_pipe+0xb1>
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105840:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105843:	8b 7d e4             	mov    -0x1c(%ebp),%edi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105846:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105848:	89 5e 28             	mov    %ebx,0x28(%esi)
8010584b:	90                   	nop
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105850:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
80105855:	74 19                	je     80105870 <sys_pipe+0xa0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105857:	83 c2 01             	add    $0x1,%edx
8010585a:	83 fa 10             	cmp    $0x10,%edx
8010585d:	75 f1                	jne    80105850 <sys_pipe+0x80>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
8010585f:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
80105866:	eb b8                	jmp    80105820 <sys_pipe+0x50>
80105868:	90                   	nop
80105869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105870:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105874:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105877:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105879:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010587c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010587f:	31 c0                	xor    %eax,%eax
}
80105881:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105884:	5b                   	pop    %ebx
80105885:	5e                   	pop    %esi
80105886:	5f                   	pop    %edi
80105887:	5d                   	pop    %ebp
80105888:	c3                   	ret    
80105889:	66 90                	xchg   %ax,%ax
8010588b:	66 90                	xchg   %ax,%ax
8010588d:	66 90                	xchg   %ax,%ax
8010588f:	90                   	nop

80105890 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105893:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105894:	e9 f7 e0 ff ff       	jmp    80103990 <fork>
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_exit>:
}

int
sys_exit(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058a6:	e8 55 e3 ff ff       	call   80103c00 <exit>
  return 0;  // not reached
}
801058ab:	31 c0                	xor    %eax,%eax
801058ad:	c9                   	leave  
801058ae:	c3                   	ret    
801058af:	90                   	nop

801058b0 <sys_wait>:

int
sys_wait(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801058b3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801058b4:	e9 97 e5 ff ff       	jmp    80103e50 <wait>
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058c0 <sys_kill>:
}

int
sys_kill(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c9:	50                   	push   %eax
801058ca:	6a 00                	push   $0x0
801058cc:	e8 6f f2 ff ff       	call   80104b40 <argint>
801058d1:	83 c4 10             	add    $0x10,%esp
801058d4:	85 c0                	test   %eax,%eax
801058d6:	78 18                	js     801058f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058d8:	83 ec 0c             	sub    $0xc,%esp
801058db:	ff 75 f4             	pushl  -0xc(%ebp)
801058de:	e8 ad e6 ff ff       	call   80103f90 <kill>
801058e3:	83 c4 10             	add    $0x10,%esp
}
801058e6:	c9                   	leave  
801058e7:	c3                   	ret    
801058e8:	90                   	nop
801058e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801058f5:	c9                   	leave  
801058f6:	c3                   	ret    
801058f7:	89 f6                	mov    %esi,%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105900 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105900:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105906:	55                   	push   %ebp
80105907:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105909:	8b 40 10             	mov    0x10(%eax),%eax
}
8010590c:	5d                   	pop    %ebp
8010590d:	c3                   	ret    
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_sbrk>:

int
sys_sbrk(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105914:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return proc->pid;
}

int
sys_sbrk(void)
{
80105917:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010591a:	50                   	push   %eax
8010591b:	6a 00                	push   $0x0
8010591d:	e8 1e f2 ff ff       	call   80104b40 <argint>
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	85 c0                	test   %eax,%eax
80105927:	78 27                	js     80105950 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
80105929:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
8010592f:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105932:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105934:	ff 75 f4             	pushl  -0xc(%ebp)
80105937:	e8 e4 df ff ff       	call   80103920 <growproc>
8010593c:	83 c4 10             	add    $0x10,%esp
8010593f:	85 c0                	test   %eax,%eax
80105941:	78 0d                	js     80105950 <sys_sbrk+0x40>
    return -1;
  return addr;
80105943:	89 d8                	mov    %ebx,%eax
}
80105945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105948:	c9                   	leave  
80105949:	c3                   	ret    
8010594a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105955:	eb ee                	jmp    80105945 <sys_sbrk+0x35>
80105957:	89 f6                	mov    %esi,%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105960 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105964:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105967:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010596a:	50                   	push   %eax
8010596b:	6a 00                	push   $0x0
8010596d:	e8 ce f1 ff ff       	call   80104b40 <argint>
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	85 c0                	test   %eax,%eax
80105977:	0f 88 8a 00 00 00    	js     80105a07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010597d:	83 ec 0c             	sub    $0xc,%esp
80105980:	68 e0 4d 11 80       	push   $0x80114de0
80105985:	e8 96 ec ff ff       	call   80104620 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010598a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010598d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105990:	8b 1d 20 56 11 80    	mov    0x80115620,%ebx
  while(ticks - ticks0 < n){
80105996:	85 d2                	test   %edx,%edx
80105998:	75 27                	jne    801059c1 <sys_sleep+0x61>
8010599a:	eb 54                	jmp    801059f0 <sys_sleep+0x90>
8010599c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059a0:	83 ec 08             	sub    $0x8,%esp
801059a3:	68 e0 4d 11 80       	push   $0x80114de0
801059a8:	68 20 56 11 80       	push   $0x80115620
801059ad:	e8 de e3 ff ff       	call   80103d90 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059b2:	a1 20 56 11 80       	mov    0x80115620,%eax
801059b7:	83 c4 10             	add    $0x10,%esp
801059ba:	29 d8                	sub    %ebx,%eax
801059bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059bf:	73 2f                	jae    801059f0 <sys_sleep+0x90>
    if(proc->killed){
801059c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059c7:	8b 40 24             	mov    0x24(%eax),%eax
801059ca:	85 c0                	test   %eax,%eax
801059cc:	74 d2                	je     801059a0 <sys_sleep+0x40>
      release(&tickslock);
801059ce:	83 ec 0c             	sub    $0xc,%esp
801059d1:	68 e0 4d 11 80       	push   $0x80114de0
801059d6:	e8 25 ee ff ff       	call   80104800 <release>
      return -1;
801059db:	83 c4 10             	add    $0x10,%esp
801059de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801059e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059e6:	c9                   	leave  
801059e7:	c3                   	ret    
801059e8:	90                   	nop
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	68 e0 4d 11 80       	push   $0x80114de0
801059f8:	e8 03 ee ff ff       	call   80104800 <release>
  return 0;
801059fd:	83 c4 10             	add    $0x10,%esp
80105a00:	31 c0                	xor    %eax,%eax
}
80105a02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a05:	c9                   	leave  
80105a06:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105a07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0c:	eb d5                	jmp    801059e3 <sys_sleep+0x83>
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	53                   	push   %ebx
80105a14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a17:	68 e0 4d 11 80       	push   $0x80114de0
80105a1c:	e8 ff eb ff ff       	call   80104620 <acquire>
  xticks = ticks;
80105a21:	8b 1d 20 56 11 80    	mov    0x80115620,%ebx
  release(&tickslock);
80105a27:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105a2e:	e8 cd ed ff ff       	call   80104800 <release>
  return xticks;
}
80105a33:	89 d8                	mov    %ebx,%eax
80105a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a38:	c9                   	leave  
80105a39:	c3                   	ret    
80105a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a40 <sys_halt>:

int
sys_halt(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 14             	sub    $0x14,%esp
  cprintf("shutdown signal\n"); // 나중에 이거 지우기 
80105a46:	68 49 7b 10 80       	push   $0x80107b49
80105a4b:	e8 10 ac ff ff       	call   80100660 <cprintf>
}

static inline void
outw(ushort port, ushort data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a50:	ba 04 b0 ff ff       	mov    $0xffffb004,%edx
80105a55:	b8 00 20 00 00       	mov    $0x2000,%eax
80105a5a:	66 ef                	out    %ax,(%dx)
  outw(0xB004, 0x0|0x2000);
  return 0;
}
80105a5c:	31 c0                	xor    %eax,%eax
80105a5e:	c9                   	leave  
80105a5f:	c3                   	ret    

80105a60 <sys_ps>:

int
sys_ps(void)
{   
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 20             	sub    $0x20,%esp
    int pid;
    if(argint(0,&pid)<0)
80105a66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a69:	50                   	push   %eax
80105a6a:	6a 00                	push   $0x0
80105a6c:	e8 cf f0 ff ff       	call   80104b40 <argint>
80105a71:	83 c4 10             	add    $0x10,%esp
80105a74:	85 c0                	test   %eax,%eax
80105a76:	78 18                	js     80105a90 <sys_ps+0x30>
        return -1;
    ps(pid); 
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a7e:	e8 5d e6 ff ff       	call   801040e0 <ps>
    return 0;
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	31 c0                	xor    %eax,%eax
}
80105a88:	c9                   	leave  
80105a89:	c3                   	ret    
80105a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
sys_ps(void)
{   
    int pid;
    if(argint(0,&pid)<0)
        return -1;
80105a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    ps(pid); 
    return 0;
}
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
80105a97:	89 f6                	mov    %esi,%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105aa0 <sys_getnice>:

int 
sys_getnice(void){
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	83 ec 20             	sub    $0x20,%esp
   int pid;
   if(argint(0, &pid) < 0)
80105aa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aa9:	50                   	push   %eax
80105aaa:	6a 00                	push   $0x0
80105aac:	e8 8f f0 ff ff       	call   80104b40 <argint>
80105ab1:	83 c4 10             	add    $0x10,%esp
80105ab4:	85 c0                	test   %eax,%eax
80105ab6:	78 18                	js     80105ad0 <sys_getnice+0x30>
        return -1;
    return getnice(pid);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	ff 75 f4             	pushl  -0xc(%ebp)
80105abe:	e8 4d e8 ff ff       	call   80104310 <getnice>
80105ac3:	83 c4 10             	add    $0x10,%esp
    
   

}
80105ac6:	c9                   	leave  
80105ac7:	c3                   	ret    
80105ac8:	90                   	nop
80105ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int 
sys_getnice(void){
   int pid;
   if(argint(0, &pid) < 0)
        return -1;
80105ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return getnice(pid);
    
   

}
80105ad5:	c9                   	leave  
80105ad6:	c3                   	ret    
80105ad7:	89 f6                	mov    %esi,%esi
80105ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ae0 <sys_setnice>:

int
sys_setnice(void){
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	83 ec 20             	sub    $0x20,%esp
     int pid , nice;
     if(argint(0,&pid)<0)
80105ae6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ae9:	50                   	push   %eax
80105aea:	6a 00                	push   $0x0
80105aec:	e8 4f f0 ff ff       	call   80104b40 <argint>
80105af1:	83 c4 10             	add    $0x10,%esp
80105af4:	85 c0                	test   %eax,%eax
80105af6:	78 28                	js     80105b20 <sys_setnice+0x40>
         return -1;
     if(argint(1,&nice)<0)
80105af8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105afb:	83 ec 08             	sub    $0x8,%esp
80105afe:	50                   	push   %eax
80105aff:	6a 01                	push   $0x1
80105b01:	e8 3a f0 ff ff       	call   80104b40 <argint>
80105b06:	83 c4 10             	add    $0x10,%esp
80105b09:	85 c0                	test   %eax,%eax
80105b0b:	78 13                	js     80105b20 <sys_setnice+0x40>
         return -1;
     return setnice(pid,nice);
80105b0d:	83 ec 08             	sub    $0x8,%esp
80105b10:	ff 75 f4             	pushl  -0xc(%ebp)
80105b13:	ff 75 f0             	pushl  -0x10(%ebp)
80105b16:	e8 35 e9 ff ff       	call   80104450 <setnice>
80105b1b:	83 c4 10             	add    $0x10,%esp
     

}
80105b1e:	c9                   	leave  
80105b1f:	c3                   	ret    

int
sys_setnice(void){
     int pid , nice;
     if(argint(0,&pid)<0)
         return -1;
80105b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     if(argint(1,&nice)<0)
         return -1;
     return setnice(pid,nice);
     

}
80105b25:	c9                   	leave  
80105b26:	c3                   	ret    
80105b27:	66 90                	xchg   %ax,%ax
80105b29:	66 90                	xchg   %ax,%ax
80105b2b:	66 90                	xchg   %ax,%ax
80105b2d:	66 90                	xchg   %ax,%ax
80105b2f:	90                   	nop

80105b30 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105b30:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b31:	ba 43 00 00 00       	mov    $0x43,%edx
80105b36:	b8 34 00 00 00       	mov    $0x34,%eax
80105b3b:	89 e5                	mov    %esp,%ebp
80105b3d:	83 ec 14             	sub    $0x14,%esp
80105b40:	ee                   	out    %al,(%dx)
80105b41:	ba 40 00 00 00       	mov    $0x40,%edx
80105b46:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105b4b:	ee                   	out    %al,(%dx)
80105b4c:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105b51:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105b52:	6a 00                	push   $0x0
80105b54:	e8 d7 d6 ff ff       	call   80103230 <picenable>
}
80105b59:	83 c4 10             	add    $0x10,%esp
80105b5c:	c9                   	leave  
80105b5d:	c3                   	ret    

80105b5e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b5e:	1e                   	push   %ds
  pushl %es
80105b5f:	06                   	push   %es
  pushl %fs
80105b60:	0f a0                	push   %fs
  pushl %gs
80105b62:	0f a8                	push   %gs
  pushal
80105b64:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105b65:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b69:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b6b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80105b6d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105b71:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105b73:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b75:	54                   	push   %esp
  call trap
80105b76:	e8 e5 00 00 00       	call   80105c60 <trap>
  addl $4, %esp
80105b7b:	83 c4 04             	add    $0x4,%esp

80105b7e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b7e:	61                   	popa   
  popl %gs
80105b7f:	0f a9                	pop    %gs
  popl %fs
80105b81:	0f a1                	pop    %fs
  popl %es
80105b83:	07                   	pop    %es
  popl %ds
80105b84:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b85:	83 c4 08             	add    $0x8,%esp
  iret
80105b88:	cf                   	iret   
80105b89:	66 90                	xchg   %ax,%ax
80105b8b:	66 90                	xchg   %ax,%ax
80105b8d:	66 90                	xchg   %ax,%ax
80105b8f:	90                   	nop

80105b90 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105b90:	31 c0                	xor    %eax,%eax
80105b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b98:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
80105b9f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105ba4:	c6 04 c5 24 4e 11 80 	movb   $0x0,-0x7feeb1dc(,%eax,8)
80105bab:	00 
80105bac:	66 89 0c c5 22 4e 11 	mov    %cx,-0x7feeb1de(,%eax,8)
80105bb3:	80 
80105bb4:	c6 04 c5 25 4e 11 80 	movb   $0x8e,-0x7feeb1db(,%eax,8)
80105bbb:	8e 
80105bbc:	66 89 14 c5 20 4e 11 	mov    %dx,-0x7feeb1e0(,%eax,8)
80105bc3:	80 
80105bc4:	c1 ea 10             	shr    $0x10,%edx
80105bc7:	66 89 14 c5 26 4e 11 	mov    %dx,-0x7feeb1da(,%eax,8)
80105bce:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105bcf:	83 c0 01             	add    $0x1,%eax
80105bd2:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bd7:	75 bf                	jne    80105b98 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bd9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bda:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bdf:	89 e5                	mov    %esp,%ebp
80105be1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105be4:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105be9:	68 5a 7b 10 80       	push   $0x80107b5a
80105bee:	68 e0 4d 11 80       	push   $0x80114de0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bf3:	66 89 15 22 50 11 80 	mov    %dx,0x80115022
80105bfa:	c6 05 24 50 11 80 00 	movb   $0x0,0x80115024
80105c01:	66 a3 20 50 11 80    	mov    %ax,0x80115020
80105c07:	c1 e8 10             	shr    $0x10,%eax
80105c0a:	c6 05 25 50 11 80 ef 	movb   $0xef,0x80115025
80105c11:	66 a3 26 50 11 80    	mov    %ax,0x80115026

  initlock(&tickslock, "time");
80105c17:	e8 e4 e9 ff ff       	call   80104600 <initlock>
}
80105c1c:	83 c4 10             	add    $0x10,%esp
80105c1f:	c9                   	leave  
80105c20:	c3                   	ret    
80105c21:	eb 0d                	jmp    80105c30 <idtinit>
80105c23:	90                   	nop
80105c24:	90                   	nop
80105c25:	90                   	nop
80105c26:	90                   	nop
80105c27:	90                   	nop
80105c28:	90                   	nop
80105c29:	90                   	nop
80105c2a:	90                   	nop
80105c2b:	90                   	nop
80105c2c:	90                   	nop
80105c2d:	90                   	nop
80105c2e:	90                   	nop
80105c2f:	90                   	nop

80105c30 <idtinit>:

void
idtinit(void)
{
80105c30:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105c31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c36:	89 e5                	mov    %esp,%ebp
80105c38:	83 ec 10             	sub    $0x10,%esp
80105c3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c3f:	b8 20 4e 11 80       	mov    $0x80114e20,%eax
80105c44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c48:	c1 e8 10             	shr    $0x10,%eax
80105c4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105c4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c55:	c9                   	leave  
80105c56:	c3                   	ret    
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
80105c65:	53                   	push   %ebx
80105c66:	83 ec 0c             	sub    $0xc,%esp
80105c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c6c:	8b 43 30             	mov    0x30(%ebx),%eax
80105c6f:	83 f8 40             	cmp    $0x40,%eax
80105c72:	0f 84 f8 00 00 00    	je     80105d70 <trap+0x110>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c78:	83 e8 20             	sub    $0x20,%eax
80105c7b:	83 f8 1f             	cmp    $0x1f,%eax
80105c7e:	77 68                	ja     80105ce8 <trap+0x88>
80105c80:	ff 24 85 00 7c 10 80 	jmp    *-0x7fef8400(,%eax,4)
80105c87:	89 f6                	mov    %esi,%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105c90:	e8 0b ca ff ff       	call   801026a0 <cpunum>
80105c95:	85 c0                	test   %eax,%eax
80105c97:	0f 84 b3 01 00 00    	je     80105e50 <trap+0x1f0>
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
80105c9d:	e8 9e ca ff ff       	call   80102740 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105ca2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ca8:	85 c0                	test   %eax,%eax
80105caa:	74 2d                	je     80105cd9 <trap+0x79>
80105cac:	8b 50 24             	mov    0x24(%eax),%edx
80105caf:	85 d2                	test   %edx,%edx
80105cb1:	0f 85 86 00 00 00    	jne    80105d3d <trap+0xdd>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105cb7:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105cbb:	0f 84 ef 00 00 00    	je     80105db0 <trap+0x150>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105cc1:	8b 40 24             	mov    0x24(%eax),%eax
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	74 11                	je     80105cd9 <trap+0x79>
80105cc8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ccc:	83 e0 03             	and    $0x3,%eax
80105ccf:	66 83 f8 03          	cmp    $0x3,%ax
80105cd3:	0f 84 c1 00 00 00    	je     80105d9a <trap+0x13a>
    exit();
}
80105cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cdc:	5b                   	pop    %ebx
80105cdd:	5e                   	pop    %esi
80105cde:	5f                   	pop    %edi
80105cdf:	5d                   	pop    %ebp
80105ce0:	c3                   	ret    
80105ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105ce8:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80105cef:	85 c9                	test   %ecx,%ecx
80105cf1:	0f 84 8d 01 00 00    	je     80105e84 <trap+0x224>
80105cf7:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105cfb:	0f 84 83 01 00 00    	je     80105e84 <trap+0x224>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d01:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d04:	8b 73 38             	mov    0x38(%ebx),%esi
80105d07:	e8 94 c9 ff ff       	call   801026a0 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105d0c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d13:	57                   	push   %edi
80105d14:	56                   	push   %esi
80105d15:	50                   	push   %eax
80105d16:	ff 73 34             	pushl  0x34(%ebx)
80105d19:	ff 73 30             	pushl  0x30(%ebx)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105d1c:	8d 42 70             	lea    0x70(%edx),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d1f:	50                   	push   %eax
80105d20:	ff 72 10             	pushl  0x10(%edx)
80105d23:	68 bc 7b 10 80       	push   $0x80107bbc
80105d28:	e8 33 a9 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80105d2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d33:	83 c4 20             	add    $0x20,%esp
80105d36:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105d3d:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105d41:	83 e2 03             	and    $0x3,%edx
80105d44:	66 83 fa 03          	cmp    $0x3,%dx
80105d48:	0f 85 69 ff ff ff    	jne    80105cb7 <trap+0x57>
    exit();
80105d4e:	e8 ad de ff ff       	call   80103c00 <exit>
80105d53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105d59:	85 c0                	test   %eax,%eax
80105d5b:	0f 85 56 ff ff ff    	jne    80105cb7 <trap+0x57>
80105d61:	e9 73 ff ff ff       	jmp    80105cd9 <trap+0x79>
80105d66:	8d 76 00             	lea    0x0(%esi),%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105d70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d76:	8b 70 24             	mov    0x24(%eax),%esi
80105d79:	85 f6                	test   %esi,%esi
80105d7b:	0f 85 bf 00 00 00    	jne    80105e40 <trap+0x1e0>
      exit();
    proc->tf = tf;
80105d81:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d84:	e8 c7 ee ff ff       	call   80104c50 <syscall>
    if(proc->killed)
80105d89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d8f:	8b 58 24             	mov    0x24(%eax),%ebx
80105d92:	85 db                	test   %ebx,%ebx
80105d94:	0f 84 3f ff ff ff    	je     80105cd9 <trap+0x79>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d9d:	5b                   	pop    %ebx
80105d9e:	5e                   	pop    %esi
80105d9f:	5f                   	pop    %edi
80105da0:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105da1:	e9 5a de ff ff       	jmp    80103c00 <exit>
80105da6:	8d 76 00             	lea    0x0(%esi),%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105db0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105db4:	0f 85 07 ff ff ff    	jne    80105cc1 <trap+0x61>
    yield();
80105dba:	e8 91 df ff ff       	call   80103d50 <yield>
80105dbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	0f 85 f4 fe ff ff    	jne    80105cc1 <trap+0x61>
80105dcd:	e9 07 ff ff ff       	jmp    80105cd9 <trap+0x79>
80105dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105dd8:	e8 a3 c7 ff ff       	call   80102580 <kbdintr>
    lapiceoi();
80105ddd:	e8 5e c9 ff ff       	call   80102740 <lapiceoi>
    break;
80105de2:	e9 bb fe ff ff       	jmp    80105ca2 <trap+0x42>
80105de7:	89 f6                	mov    %esi,%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105df0:	e8 cb 01 00 00       	call   80105fc0 <uartintr>
80105df5:	e9 a3 fe ff ff       	jmp    80105c9d <trap+0x3d>
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e00:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e04:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e07:	e8 94 c8 ff ff       	call   801026a0 <cpunum>
80105e0c:	57                   	push   %edi
80105e0d:	56                   	push   %esi
80105e0e:	50                   	push   %eax
80105e0f:	68 64 7b 10 80       	push   $0x80107b64
80105e14:	e8 47 a8 ff ff       	call   80100660 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105e19:	e8 22 c9 ff ff       	call   80102740 <lapiceoi>
    break;
80105e1e:	83 c4 10             	add    $0x10,%esp
80105e21:	e9 7c fe ff ff       	jmp    80105ca2 <trap+0x42>
80105e26:	8d 76 00             	lea    0x0(%esi),%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e30:	e8 bb c1 ff ff       	call   80101ff0 <ideintr>
    lapiceoi();
80105e35:	e8 06 c9 ff ff       	call   80102740 <lapiceoi>
    break;
80105e3a:	e9 63 fe ff ff       	jmp    80105ca2 <trap+0x42>
80105e3f:	90                   	nop
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105e40:	e8 bb dd ff ff       	call   80103c00 <exit>
80105e45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e4b:	e9 31 ff ff ff       	jmp    80105d81 <trap+0x121>
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	68 e0 4d 11 80       	push   $0x80114de0
80105e58:	e8 c3 e7 ff ff       	call   80104620 <acquire>
      ticks++;
      wakeup(&ticks);
80105e5d:	c7 04 24 20 56 11 80 	movl   $0x80115620,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105e64:	83 05 20 56 11 80 01 	addl   $0x1,0x80115620
      wakeup(&ticks);
80105e6b:	e8 c0 e0 ff ff       	call   80103f30 <wakeup>
      release(&tickslock);
80105e70:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105e77:	e8 84 e9 ff ff       	call   80104800 <release>
80105e7c:	83 c4 10             	add    $0x10,%esp
80105e7f:	e9 19 fe ff ff       	jmp    80105c9d <trap+0x3d>
80105e84:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e87:	8b 73 38             	mov    0x38(%ebx),%esi
80105e8a:	e8 11 c8 ff ff       	call   801026a0 <cpunum>
80105e8f:	83 ec 0c             	sub    $0xc,%esp
80105e92:	57                   	push   %edi
80105e93:	56                   	push   %esi
80105e94:	50                   	push   %eax
80105e95:	ff 73 30             	pushl  0x30(%ebx)
80105e98:	68 88 7b 10 80       	push   $0x80107b88
80105e9d:	e8 be a7 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105ea2:	83 c4 14             	add    $0x14,%esp
80105ea5:	68 5f 7b 10 80       	push   $0x80107b5f
80105eaa:	e8 c1 a4 ff ff       	call   80100370 <panic>
80105eaf:	90                   	nop

80105eb0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105eb0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105eb5:	55                   	push   %ebp
80105eb6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105eb8:	85 c0                	test   %eax,%eax
80105eba:	74 1c                	je     80105ed8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ebc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ec1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ec2:	a8 01                	test   $0x1,%al
80105ec4:	74 12                	je     80105ed8 <uartgetc+0x28>
80105ec6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ecb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ecc:	0f b6 c0             	movzbl %al,%eax
}
80105ecf:	5d                   	pop    %ebp
80105ed0:	c3                   	ret    
80105ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105edd:	5d                   	pop    %ebp
80105ede:	c3                   	ret    
80105edf:	90                   	nop

80105ee0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105ee0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ee1:	31 c9                	xor    %ecx,%ecx
80105ee3:	89 c8                	mov    %ecx,%eax
80105ee5:	89 e5                	mov    %esp,%ebp
80105ee7:	57                   	push   %edi
80105ee8:	56                   	push   %esi
80105ee9:	53                   	push   %ebx
80105eea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105eef:	89 da                	mov    %ebx,%edx
80105ef1:	83 ec 0c             	sub    $0xc,%esp
80105ef4:	ee                   	out    %al,(%dx)
80105ef5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105efa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105eff:	89 fa                	mov    %edi,%edx
80105f01:	ee                   	out    %al,(%dx)
80105f02:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f0c:	ee                   	out    %al,(%dx)
80105f0d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f12:	89 c8                	mov    %ecx,%eax
80105f14:	89 f2                	mov    %esi,%edx
80105f16:	ee                   	out    %al,(%dx)
80105f17:	b8 03 00 00 00       	mov    $0x3,%eax
80105f1c:	89 fa                	mov    %edi,%edx
80105f1e:	ee                   	out    %al,(%dx)
80105f1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f24:	89 c8                	mov    %ecx,%eax
80105f26:	ee                   	out    %al,(%dx)
80105f27:	b8 01 00 00 00       	mov    $0x1,%eax
80105f2c:	89 f2                	mov    %esi,%edx
80105f2e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f34:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105f35:	3c ff                	cmp    $0xff,%al
80105f37:	74 2b                	je     80105f64 <uartinit+0x84>
    return;
  uart = 1;
80105f39:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105f40:	00 00 00 
80105f43:	89 da                	mov    %ebx,%edx
80105f45:	ec                   	in     (%dx),%al
80105f46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f4b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105f4c:	83 ec 0c             	sub    $0xc,%esp
80105f4f:	6a 04                	push   $0x4
80105f51:	e8 da d2 ff ff       	call   80103230 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105f56:	58                   	pop    %eax
80105f57:	5a                   	pop    %edx
80105f58:	6a 00                	push   $0x0
80105f5a:	6a 04                	push   $0x4
80105f5c:	e8 ef c2 ff ff       	call   80102250 <ioapicenable>
80105f61:	83 c4 10             	add    $0x10,%esp
}
80105f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f67:	5b                   	pop    %ebx
80105f68:	5e                   	pop    %esi
80105f69:	5f                   	pop    %edi
80105f6a:	5d                   	pop    %ebp
80105f6b:	c3                   	ret    
80105f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f70 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105f70:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80105f75:	85 c0                	test   %eax,%eax
80105f77:	74 3f                	je     80105fb8 <uartputc+0x48>
  ioapicenable(IRQ_COM1, 0);
}

void
uartputc(int c)
{
80105f79:	55                   	push   %ebp
80105f7a:	89 e5                	mov    %esp,%ebp
80105f7c:	56                   	push   %esi
80105f7d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f82:	53                   	push   %ebx
80105f83:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f88:	eb 18                	jmp    80105fa2 <uartputc+0x32>
80105f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105f90:	83 ec 0c             	sub    $0xc,%esp
80105f93:	6a 0a                	push   $0xa
80105f95:	e8 c6 c7 ff ff       	call   80102760 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f9a:	83 c4 10             	add    $0x10,%esp
80105f9d:	83 eb 01             	sub    $0x1,%ebx
80105fa0:	74 07                	je     80105fa9 <uartputc+0x39>
80105fa2:	89 f2                	mov    %esi,%edx
80105fa4:	ec                   	in     (%dx),%al
80105fa5:	a8 20                	test   $0x20,%al
80105fa7:	74 e7                	je     80105f90 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fa9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fae:	8b 45 08             	mov    0x8(%ebp),%eax
80105fb1:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105fb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fb5:	5b                   	pop    %ebx
80105fb6:	5e                   	pop    %esi
80105fb7:	5d                   	pop    %ebp
80105fb8:	f3 c3                	repz ret 
80105fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105fc0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fc6:	68 b0 5e 10 80       	push   $0x80105eb0
80105fcb:	e8 20 a8 ff ff       	call   801007f0 <consoleintr>
}
80105fd0:	83 c4 10             	add    $0x10,%esp
80105fd3:	c9                   	leave  
80105fd4:	c3                   	ret    

80105fd5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $0
80105fd7:	6a 00                	push   $0x0
  jmp alltraps
80105fd9:	e9 80 fb ff ff       	jmp    80105b5e <alltraps>

80105fde <vector1>:
.globl vector1
vector1:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $1
80105fe0:	6a 01                	push   $0x1
  jmp alltraps
80105fe2:	e9 77 fb ff ff       	jmp    80105b5e <alltraps>

80105fe7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $2
80105fe9:	6a 02                	push   $0x2
  jmp alltraps
80105feb:	e9 6e fb ff ff       	jmp    80105b5e <alltraps>

80105ff0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105ff0:	6a 00                	push   $0x0
  pushl $3
80105ff2:	6a 03                	push   $0x3
  jmp alltraps
80105ff4:	e9 65 fb ff ff       	jmp    80105b5e <alltraps>

80105ff9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ff9:	6a 00                	push   $0x0
  pushl $4
80105ffb:	6a 04                	push   $0x4
  jmp alltraps
80105ffd:	e9 5c fb ff ff       	jmp    80105b5e <alltraps>

80106002 <vector5>:
.globl vector5
vector5:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $5
80106004:	6a 05                	push   $0x5
  jmp alltraps
80106006:	e9 53 fb ff ff       	jmp    80105b5e <alltraps>

8010600b <vector6>:
.globl vector6
vector6:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $6
8010600d:	6a 06                	push   $0x6
  jmp alltraps
8010600f:	e9 4a fb ff ff       	jmp    80105b5e <alltraps>

80106014 <vector7>:
.globl vector7
vector7:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $7
80106016:	6a 07                	push   $0x7
  jmp alltraps
80106018:	e9 41 fb ff ff       	jmp    80105b5e <alltraps>

8010601d <vector8>:
.globl vector8
vector8:
  pushl $8
8010601d:	6a 08                	push   $0x8
  jmp alltraps
8010601f:	e9 3a fb ff ff       	jmp    80105b5e <alltraps>

80106024 <vector9>:
.globl vector9
vector9:
  pushl $0
80106024:	6a 00                	push   $0x0
  pushl $9
80106026:	6a 09                	push   $0x9
  jmp alltraps
80106028:	e9 31 fb ff ff       	jmp    80105b5e <alltraps>

8010602d <vector10>:
.globl vector10
vector10:
  pushl $10
8010602d:	6a 0a                	push   $0xa
  jmp alltraps
8010602f:	e9 2a fb ff ff       	jmp    80105b5e <alltraps>

80106034 <vector11>:
.globl vector11
vector11:
  pushl $11
80106034:	6a 0b                	push   $0xb
  jmp alltraps
80106036:	e9 23 fb ff ff       	jmp    80105b5e <alltraps>

8010603b <vector12>:
.globl vector12
vector12:
  pushl $12
8010603b:	6a 0c                	push   $0xc
  jmp alltraps
8010603d:	e9 1c fb ff ff       	jmp    80105b5e <alltraps>

80106042 <vector13>:
.globl vector13
vector13:
  pushl $13
80106042:	6a 0d                	push   $0xd
  jmp alltraps
80106044:	e9 15 fb ff ff       	jmp    80105b5e <alltraps>

80106049 <vector14>:
.globl vector14
vector14:
  pushl $14
80106049:	6a 0e                	push   $0xe
  jmp alltraps
8010604b:	e9 0e fb ff ff       	jmp    80105b5e <alltraps>

80106050 <vector15>:
.globl vector15
vector15:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $15
80106052:	6a 0f                	push   $0xf
  jmp alltraps
80106054:	e9 05 fb ff ff       	jmp    80105b5e <alltraps>

80106059 <vector16>:
.globl vector16
vector16:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $16
8010605b:	6a 10                	push   $0x10
  jmp alltraps
8010605d:	e9 fc fa ff ff       	jmp    80105b5e <alltraps>

80106062 <vector17>:
.globl vector17
vector17:
  pushl $17
80106062:	6a 11                	push   $0x11
  jmp alltraps
80106064:	e9 f5 fa ff ff       	jmp    80105b5e <alltraps>

80106069 <vector18>:
.globl vector18
vector18:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $18
8010606b:	6a 12                	push   $0x12
  jmp alltraps
8010606d:	e9 ec fa ff ff       	jmp    80105b5e <alltraps>

80106072 <vector19>:
.globl vector19
vector19:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $19
80106074:	6a 13                	push   $0x13
  jmp alltraps
80106076:	e9 e3 fa ff ff       	jmp    80105b5e <alltraps>

8010607b <vector20>:
.globl vector20
vector20:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $20
8010607d:	6a 14                	push   $0x14
  jmp alltraps
8010607f:	e9 da fa ff ff       	jmp    80105b5e <alltraps>

80106084 <vector21>:
.globl vector21
vector21:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $21
80106086:	6a 15                	push   $0x15
  jmp alltraps
80106088:	e9 d1 fa ff ff       	jmp    80105b5e <alltraps>

8010608d <vector22>:
.globl vector22
vector22:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $22
8010608f:	6a 16                	push   $0x16
  jmp alltraps
80106091:	e9 c8 fa ff ff       	jmp    80105b5e <alltraps>

80106096 <vector23>:
.globl vector23
vector23:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $23
80106098:	6a 17                	push   $0x17
  jmp alltraps
8010609a:	e9 bf fa ff ff       	jmp    80105b5e <alltraps>

8010609f <vector24>:
.globl vector24
vector24:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $24
801060a1:	6a 18                	push   $0x18
  jmp alltraps
801060a3:	e9 b6 fa ff ff       	jmp    80105b5e <alltraps>

801060a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $25
801060aa:	6a 19                	push   $0x19
  jmp alltraps
801060ac:	e9 ad fa ff ff       	jmp    80105b5e <alltraps>

801060b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $26
801060b3:	6a 1a                	push   $0x1a
  jmp alltraps
801060b5:	e9 a4 fa ff ff       	jmp    80105b5e <alltraps>

801060ba <vector27>:
.globl vector27
vector27:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $27
801060bc:	6a 1b                	push   $0x1b
  jmp alltraps
801060be:	e9 9b fa ff ff       	jmp    80105b5e <alltraps>

801060c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $28
801060c5:	6a 1c                	push   $0x1c
  jmp alltraps
801060c7:	e9 92 fa ff ff       	jmp    80105b5e <alltraps>

801060cc <vector29>:
.globl vector29
vector29:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $29
801060ce:	6a 1d                	push   $0x1d
  jmp alltraps
801060d0:	e9 89 fa ff ff       	jmp    80105b5e <alltraps>

801060d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $30
801060d7:	6a 1e                	push   $0x1e
  jmp alltraps
801060d9:	e9 80 fa ff ff       	jmp    80105b5e <alltraps>

801060de <vector31>:
.globl vector31
vector31:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $31
801060e0:	6a 1f                	push   $0x1f
  jmp alltraps
801060e2:	e9 77 fa ff ff       	jmp    80105b5e <alltraps>

801060e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $32
801060e9:	6a 20                	push   $0x20
  jmp alltraps
801060eb:	e9 6e fa ff ff       	jmp    80105b5e <alltraps>

801060f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $33
801060f2:	6a 21                	push   $0x21
  jmp alltraps
801060f4:	e9 65 fa ff ff       	jmp    80105b5e <alltraps>

801060f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $34
801060fb:	6a 22                	push   $0x22
  jmp alltraps
801060fd:	e9 5c fa ff ff       	jmp    80105b5e <alltraps>

80106102 <vector35>:
.globl vector35
vector35:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $35
80106104:	6a 23                	push   $0x23
  jmp alltraps
80106106:	e9 53 fa ff ff       	jmp    80105b5e <alltraps>

8010610b <vector36>:
.globl vector36
vector36:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $36
8010610d:	6a 24                	push   $0x24
  jmp alltraps
8010610f:	e9 4a fa ff ff       	jmp    80105b5e <alltraps>

80106114 <vector37>:
.globl vector37
vector37:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $37
80106116:	6a 25                	push   $0x25
  jmp alltraps
80106118:	e9 41 fa ff ff       	jmp    80105b5e <alltraps>

8010611d <vector38>:
.globl vector38
vector38:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $38
8010611f:	6a 26                	push   $0x26
  jmp alltraps
80106121:	e9 38 fa ff ff       	jmp    80105b5e <alltraps>

80106126 <vector39>:
.globl vector39
vector39:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $39
80106128:	6a 27                	push   $0x27
  jmp alltraps
8010612a:	e9 2f fa ff ff       	jmp    80105b5e <alltraps>

8010612f <vector40>:
.globl vector40
vector40:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $40
80106131:	6a 28                	push   $0x28
  jmp alltraps
80106133:	e9 26 fa ff ff       	jmp    80105b5e <alltraps>

80106138 <vector41>:
.globl vector41
vector41:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $41
8010613a:	6a 29                	push   $0x29
  jmp alltraps
8010613c:	e9 1d fa ff ff       	jmp    80105b5e <alltraps>

80106141 <vector42>:
.globl vector42
vector42:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $42
80106143:	6a 2a                	push   $0x2a
  jmp alltraps
80106145:	e9 14 fa ff ff       	jmp    80105b5e <alltraps>

8010614a <vector43>:
.globl vector43
vector43:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $43
8010614c:	6a 2b                	push   $0x2b
  jmp alltraps
8010614e:	e9 0b fa ff ff       	jmp    80105b5e <alltraps>

80106153 <vector44>:
.globl vector44
vector44:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $44
80106155:	6a 2c                	push   $0x2c
  jmp alltraps
80106157:	e9 02 fa ff ff       	jmp    80105b5e <alltraps>

8010615c <vector45>:
.globl vector45
vector45:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $45
8010615e:	6a 2d                	push   $0x2d
  jmp alltraps
80106160:	e9 f9 f9 ff ff       	jmp    80105b5e <alltraps>

80106165 <vector46>:
.globl vector46
vector46:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $46
80106167:	6a 2e                	push   $0x2e
  jmp alltraps
80106169:	e9 f0 f9 ff ff       	jmp    80105b5e <alltraps>

8010616e <vector47>:
.globl vector47
vector47:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $47
80106170:	6a 2f                	push   $0x2f
  jmp alltraps
80106172:	e9 e7 f9 ff ff       	jmp    80105b5e <alltraps>

80106177 <vector48>:
.globl vector48
vector48:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $48
80106179:	6a 30                	push   $0x30
  jmp alltraps
8010617b:	e9 de f9 ff ff       	jmp    80105b5e <alltraps>

80106180 <vector49>:
.globl vector49
vector49:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $49
80106182:	6a 31                	push   $0x31
  jmp alltraps
80106184:	e9 d5 f9 ff ff       	jmp    80105b5e <alltraps>

80106189 <vector50>:
.globl vector50
vector50:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $50
8010618b:	6a 32                	push   $0x32
  jmp alltraps
8010618d:	e9 cc f9 ff ff       	jmp    80105b5e <alltraps>

80106192 <vector51>:
.globl vector51
vector51:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $51
80106194:	6a 33                	push   $0x33
  jmp alltraps
80106196:	e9 c3 f9 ff ff       	jmp    80105b5e <alltraps>

8010619b <vector52>:
.globl vector52
vector52:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $52
8010619d:	6a 34                	push   $0x34
  jmp alltraps
8010619f:	e9 ba f9 ff ff       	jmp    80105b5e <alltraps>

801061a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $53
801061a6:	6a 35                	push   $0x35
  jmp alltraps
801061a8:	e9 b1 f9 ff ff       	jmp    80105b5e <alltraps>

801061ad <vector54>:
.globl vector54
vector54:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $54
801061af:	6a 36                	push   $0x36
  jmp alltraps
801061b1:	e9 a8 f9 ff ff       	jmp    80105b5e <alltraps>

801061b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $55
801061b8:	6a 37                	push   $0x37
  jmp alltraps
801061ba:	e9 9f f9 ff ff       	jmp    80105b5e <alltraps>

801061bf <vector56>:
.globl vector56
vector56:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $56
801061c1:	6a 38                	push   $0x38
  jmp alltraps
801061c3:	e9 96 f9 ff ff       	jmp    80105b5e <alltraps>

801061c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $57
801061ca:	6a 39                	push   $0x39
  jmp alltraps
801061cc:	e9 8d f9 ff ff       	jmp    80105b5e <alltraps>

801061d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $58
801061d3:	6a 3a                	push   $0x3a
  jmp alltraps
801061d5:	e9 84 f9 ff ff       	jmp    80105b5e <alltraps>

801061da <vector59>:
.globl vector59
vector59:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $59
801061dc:	6a 3b                	push   $0x3b
  jmp alltraps
801061de:	e9 7b f9 ff ff       	jmp    80105b5e <alltraps>

801061e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $60
801061e5:	6a 3c                	push   $0x3c
  jmp alltraps
801061e7:	e9 72 f9 ff ff       	jmp    80105b5e <alltraps>

801061ec <vector61>:
.globl vector61
vector61:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $61
801061ee:	6a 3d                	push   $0x3d
  jmp alltraps
801061f0:	e9 69 f9 ff ff       	jmp    80105b5e <alltraps>

801061f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $62
801061f7:	6a 3e                	push   $0x3e
  jmp alltraps
801061f9:	e9 60 f9 ff ff       	jmp    80105b5e <alltraps>

801061fe <vector63>:
.globl vector63
vector63:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $63
80106200:	6a 3f                	push   $0x3f
  jmp alltraps
80106202:	e9 57 f9 ff ff       	jmp    80105b5e <alltraps>

80106207 <vector64>:
.globl vector64
vector64:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $64
80106209:	6a 40                	push   $0x40
  jmp alltraps
8010620b:	e9 4e f9 ff ff       	jmp    80105b5e <alltraps>

80106210 <vector65>:
.globl vector65
vector65:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $65
80106212:	6a 41                	push   $0x41
  jmp alltraps
80106214:	e9 45 f9 ff ff       	jmp    80105b5e <alltraps>

80106219 <vector66>:
.globl vector66
vector66:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $66
8010621b:	6a 42                	push   $0x42
  jmp alltraps
8010621d:	e9 3c f9 ff ff       	jmp    80105b5e <alltraps>

80106222 <vector67>:
.globl vector67
vector67:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $67
80106224:	6a 43                	push   $0x43
  jmp alltraps
80106226:	e9 33 f9 ff ff       	jmp    80105b5e <alltraps>

8010622b <vector68>:
.globl vector68
vector68:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $68
8010622d:	6a 44                	push   $0x44
  jmp alltraps
8010622f:	e9 2a f9 ff ff       	jmp    80105b5e <alltraps>

80106234 <vector69>:
.globl vector69
vector69:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $69
80106236:	6a 45                	push   $0x45
  jmp alltraps
80106238:	e9 21 f9 ff ff       	jmp    80105b5e <alltraps>

8010623d <vector70>:
.globl vector70
vector70:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $70
8010623f:	6a 46                	push   $0x46
  jmp alltraps
80106241:	e9 18 f9 ff ff       	jmp    80105b5e <alltraps>

80106246 <vector71>:
.globl vector71
vector71:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $71
80106248:	6a 47                	push   $0x47
  jmp alltraps
8010624a:	e9 0f f9 ff ff       	jmp    80105b5e <alltraps>

8010624f <vector72>:
.globl vector72
vector72:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $72
80106251:	6a 48                	push   $0x48
  jmp alltraps
80106253:	e9 06 f9 ff ff       	jmp    80105b5e <alltraps>

80106258 <vector73>:
.globl vector73
vector73:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $73
8010625a:	6a 49                	push   $0x49
  jmp alltraps
8010625c:	e9 fd f8 ff ff       	jmp    80105b5e <alltraps>

80106261 <vector74>:
.globl vector74
vector74:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $74
80106263:	6a 4a                	push   $0x4a
  jmp alltraps
80106265:	e9 f4 f8 ff ff       	jmp    80105b5e <alltraps>

8010626a <vector75>:
.globl vector75
vector75:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $75
8010626c:	6a 4b                	push   $0x4b
  jmp alltraps
8010626e:	e9 eb f8 ff ff       	jmp    80105b5e <alltraps>

80106273 <vector76>:
.globl vector76
vector76:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $76
80106275:	6a 4c                	push   $0x4c
  jmp alltraps
80106277:	e9 e2 f8 ff ff       	jmp    80105b5e <alltraps>

8010627c <vector77>:
.globl vector77
vector77:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $77
8010627e:	6a 4d                	push   $0x4d
  jmp alltraps
80106280:	e9 d9 f8 ff ff       	jmp    80105b5e <alltraps>

80106285 <vector78>:
.globl vector78
vector78:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $78
80106287:	6a 4e                	push   $0x4e
  jmp alltraps
80106289:	e9 d0 f8 ff ff       	jmp    80105b5e <alltraps>

8010628e <vector79>:
.globl vector79
vector79:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $79
80106290:	6a 4f                	push   $0x4f
  jmp alltraps
80106292:	e9 c7 f8 ff ff       	jmp    80105b5e <alltraps>

80106297 <vector80>:
.globl vector80
vector80:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $80
80106299:	6a 50                	push   $0x50
  jmp alltraps
8010629b:	e9 be f8 ff ff       	jmp    80105b5e <alltraps>

801062a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $81
801062a2:	6a 51                	push   $0x51
  jmp alltraps
801062a4:	e9 b5 f8 ff ff       	jmp    80105b5e <alltraps>

801062a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $82
801062ab:	6a 52                	push   $0x52
  jmp alltraps
801062ad:	e9 ac f8 ff ff       	jmp    80105b5e <alltraps>

801062b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $83
801062b4:	6a 53                	push   $0x53
  jmp alltraps
801062b6:	e9 a3 f8 ff ff       	jmp    80105b5e <alltraps>

801062bb <vector84>:
.globl vector84
vector84:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $84
801062bd:	6a 54                	push   $0x54
  jmp alltraps
801062bf:	e9 9a f8 ff ff       	jmp    80105b5e <alltraps>

801062c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $85
801062c6:	6a 55                	push   $0x55
  jmp alltraps
801062c8:	e9 91 f8 ff ff       	jmp    80105b5e <alltraps>

801062cd <vector86>:
.globl vector86
vector86:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $86
801062cf:	6a 56                	push   $0x56
  jmp alltraps
801062d1:	e9 88 f8 ff ff       	jmp    80105b5e <alltraps>

801062d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $87
801062d8:	6a 57                	push   $0x57
  jmp alltraps
801062da:	e9 7f f8 ff ff       	jmp    80105b5e <alltraps>

801062df <vector88>:
.globl vector88
vector88:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $88
801062e1:	6a 58                	push   $0x58
  jmp alltraps
801062e3:	e9 76 f8 ff ff       	jmp    80105b5e <alltraps>

801062e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $89
801062ea:	6a 59                	push   $0x59
  jmp alltraps
801062ec:	e9 6d f8 ff ff       	jmp    80105b5e <alltraps>

801062f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $90
801062f3:	6a 5a                	push   $0x5a
  jmp alltraps
801062f5:	e9 64 f8 ff ff       	jmp    80105b5e <alltraps>

801062fa <vector91>:
.globl vector91
vector91:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $91
801062fc:	6a 5b                	push   $0x5b
  jmp alltraps
801062fe:	e9 5b f8 ff ff       	jmp    80105b5e <alltraps>

80106303 <vector92>:
.globl vector92
vector92:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $92
80106305:	6a 5c                	push   $0x5c
  jmp alltraps
80106307:	e9 52 f8 ff ff       	jmp    80105b5e <alltraps>

8010630c <vector93>:
.globl vector93
vector93:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $93
8010630e:	6a 5d                	push   $0x5d
  jmp alltraps
80106310:	e9 49 f8 ff ff       	jmp    80105b5e <alltraps>

80106315 <vector94>:
.globl vector94
vector94:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $94
80106317:	6a 5e                	push   $0x5e
  jmp alltraps
80106319:	e9 40 f8 ff ff       	jmp    80105b5e <alltraps>

8010631e <vector95>:
.globl vector95
vector95:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $95
80106320:	6a 5f                	push   $0x5f
  jmp alltraps
80106322:	e9 37 f8 ff ff       	jmp    80105b5e <alltraps>

80106327 <vector96>:
.globl vector96
vector96:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $96
80106329:	6a 60                	push   $0x60
  jmp alltraps
8010632b:	e9 2e f8 ff ff       	jmp    80105b5e <alltraps>

80106330 <vector97>:
.globl vector97
vector97:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $97
80106332:	6a 61                	push   $0x61
  jmp alltraps
80106334:	e9 25 f8 ff ff       	jmp    80105b5e <alltraps>

80106339 <vector98>:
.globl vector98
vector98:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $98
8010633b:	6a 62                	push   $0x62
  jmp alltraps
8010633d:	e9 1c f8 ff ff       	jmp    80105b5e <alltraps>

80106342 <vector99>:
.globl vector99
vector99:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $99
80106344:	6a 63                	push   $0x63
  jmp alltraps
80106346:	e9 13 f8 ff ff       	jmp    80105b5e <alltraps>

8010634b <vector100>:
.globl vector100
vector100:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $100
8010634d:	6a 64                	push   $0x64
  jmp alltraps
8010634f:	e9 0a f8 ff ff       	jmp    80105b5e <alltraps>

80106354 <vector101>:
.globl vector101
vector101:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $101
80106356:	6a 65                	push   $0x65
  jmp alltraps
80106358:	e9 01 f8 ff ff       	jmp    80105b5e <alltraps>

8010635d <vector102>:
.globl vector102
vector102:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $102
8010635f:	6a 66                	push   $0x66
  jmp alltraps
80106361:	e9 f8 f7 ff ff       	jmp    80105b5e <alltraps>

80106366 <vector103>:
.globl vector103
vector103:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $103
80106368:	6a 67                	push   $0x67
  jmp alltraps
8010636a:	e9 ef f7 ff ff       	jmp    80105b5e <alltraps>

8010636f <vector104>:
.globl vector104
vector104:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $104
80106371:	6a 68                	push   $0x68
  jmp alltraps
80106373:	e9 e6 f7 ff ff       	jmp    80105b5e <alltraps>

80106378 <vector105>:
.globl vector105
vector105:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $105
8010637a:	6a 69                	push   $0x69
  jmp alltraps
8010637c:	e9 dd f7 ff ff       	jmp    80105b5e <alltraps>

80106381 <vector106>:
.globl vector106
vector106:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $106
80106383:	6a 6a                	push   $0x6a
  jmp alltraps
80106385:	e9 d4 f7 ff ff       	jmp    80105b5e <alltraps>

8010638a <vector107>:
.globl vector107
vector107:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $107
8010638c:	6a 6b                	push   $0x6b
  jmp alltraps
8010638e:	e9 cb f7 ff ff       	jmp    80105b5e <alltraps>

80106393 <vector108>:
.globl vector108
vector108:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $108
80106395:	6a 6c                	push   $0x6c
  jmp alltraps
80106397:	e9 c2 f7 ff ff       	jmp    80105b5e <alltraps>

8010639c <vector109>:
.globl vector109
vector109:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $109
8010639e:	6a 6d                	push   $0x6d
  jmp alltraps
801063a0:	e9 b9 f7 ff ff       	jmp    80105b5e <alltraps>

801063a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $110
801063a7:	6a 6e                	push   $0x6e
  jmp alltraps
801063a9:	e9 b0 f7 ff ff       	jmp    80105b5e <alltraps>

801063ae <vector111>:
.globl vector111
vector111:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $111
801063b0:	6a 6f                	push   $0x6f
  jmp alltraps
801063b2:	e9 a7 f7 ff ff       	jmp    80105b5e <alltraps>

801063b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $112
801063b9:	6a 70                	push   $0x70
  jmp alltraps
801063bb:	e9 9e f7 ff ff       	jmp    80105b5e <alltraps>

801063c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $113
801063c2:	6a 71                	push   $0x71
  jmp alltraps
801063c4:	e9 95 f7 ff ff       	jmp    80105b5e <alltraps>

801063c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $114
801063cb:	6a 72                	push   $0x72
  jmp alltraps
801063cd:	e9 8c f7 ff ff       	jmp    80105b5e <alltraps>

801063d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $115
801063d4:	6a 73                	push   $0x73
  jmp alltraps
801063d6:	e9 83 f7 ff ff       	jmp    80105b5e <alltraps>

801063db <vector116>:
.globl vector116
vector116:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $116
801063dd:	6a 74                	push   $0x74
  jmp alltraps
801063df:	e9 7a f7 ff ff       	jmp    80105b5e <alltraps>

801063e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $117
801063e6:	6a 75                	push   $0x75
  jmp alltraps
801063e8:	e9 71 f7 ff ff       	jmp    80105b5e <alltraps>

801063ed <vector118>:
.globl vector118
vector118:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $118
801063ef:	6a 76                	push   $0x76
  jmp alltraps
801063f1:	e9 68 f7 ff ff       	jmp    80105b5e <alltraps>

801063f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $119
801063f8:	6a 77                	push   $0x77
  jmp alltraps
801063fa:	e9 5f f7 ff ff       	jmp    80105b5e <alltraps>

801063ff <vector120>:
.globl vector120
vector120:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $120
80106401:	6a 78                	push   $0x78
  jmp alltraps
80106403:	e9 56 f7 ff ff       	jmp    80105b5e <alltraps>

80106408 <vector121>:
.globl vector121
vector121:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $121
8010640a:	6a 79                	push   $0x79
  jmp alltraps
8010640c:	e9 4d f7 ff ff       	jmp    80105b5e <alltraps>

80106411 <vector122>:
.globl vector122
vector122:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $122
80106413:	6a 7a                	push   $0x7a
  jmp alltraps
80106415:	e9 44 f7 ff ff       	jmp    80105b5e <alltraps>

8010641a <vector123>:
.globl vector123
vector123:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $123
8010641c:	6a 7b                	push   $0x7b
  jmp alltraps
8010641e:	e9 3b f7 ff ff       	jmp    80105b5e <alltraps>

80106423 <vector124>:
.globl vector124
vector124:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $124
80106425:	6a 7c                	push   $0x7c
  jmp alltraps
80106427:	e9 32 f7 ff ff       	jmp    80105b5e <alltraps>

8010642c <vector125>:
.globl vector125
vector125:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $125
8010642e:	6a 7d                	push   $0x7d
  jmp alltraps
80106430:	e9 29 f7 ff ff       	jmp    80105b5e <alltraps>

80106435 <vector126>:
.globl vector126
vector126:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $126
80106437:	6a 7e                	push   $0x7e
  jmp alltraps
80106439:	e9 20 f7 ff ff       	jmp    80105b5e <alltraps>

8010643e <vector127>:
.globl vector127
vector127:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $127
80106440:	6a 7f                	push   $0x7f
  jmp alltraps
80106442:	e9 17 f7 ff ff       	jmp    80105b5e <alltraps>

80106447 <vector128>:
.globl vector128
vector128:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $128
80106449:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010644e:	e9 0b f7 ff ff       	jmp    80105b5e <alltraps>

80106453 <vector129>:
.globl vector129
vector129:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $129
80106455:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010645a:	e9 ff f6 ff ff       	jmp    80105b5e <alltraps>

8010645f <vector130>:
.globl vector130
vector130:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $130
80106461:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106466:	e9 f3 f6 ff ff       	jmp    80105b5e <alltraps>

8010646b <vector131>:
.globl vector131
vector131:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $131
8010646d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106472:	e9 e7 f6 ff ff       	jmp    80105b5e <alltraps>

80106477 <vector132>:
.globl vector132
vector132:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $132
80106479:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010647e:	e9 db f6 ff ff       	jmp    80105b5e <alltraps>

80106483 <vector133>:
.globl vector133
vector133:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $133
80106485:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010648a:	e9 cf f6 ff ff       	jmp    80105b5e <alltraps>

8010648f <vector134>:
.globl vector134
vector134:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $134
80106491:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106496:	e9 c3 f6 ff ff       	jmp    80105b5e <alltraps>

8010649b <vector135>:
.globl vector135
vector135:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $135
8010649d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064a2:	e9 b7 f6 ff ff       	jmp    80105b5e <alltraps>

801064a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $136
801064a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064ae:	e9 ab f6 ff ff       	jmp    80105b5e <alltraps>

801064b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $137
801064b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801064ba:	e9 9f f6 ff ff       	jmp    80105b5e <alltraps>

801064bf <vector138>:
.globl vector138
vector138:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $138
801064c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064c6:	e9 93 f6 ff ff       	jmp    80105b5e <alltraps>

801064cb <vector139>:
.globl vector139
vector139:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $139
801064cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064d2:	e9 87 f6 ff ff       	jmp    80105b5e <alltraps>

801064d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $140
801064d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064de:	e9 7b f6 ff ff       	jmp    80105b5e <alltraps>

801064e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $141
801064e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064ea:	e9 6f f6 ff ff       	jmp    80105b5e <alltraps>

801064ef <vector142>:
.globl vector142
vector142:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $142
801064f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064f6:	e9 63 f6 ff ff       	jmp    80105b5e <alltraps>

801064fb <vector143>:
.globl vector143
vector143:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $143
801064fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106502:	e9 57 f6 ff ff       	jmp    80105b5e <alltraps>

80106507 <vector144>:
.globl vector144
vector144:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $144
80106509:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010650e:	e9 4b f6 ff ff       	jmp    80105b5e <alltraps>

80106513 <vector145>:
.globl vector145
vector145:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $145
80106515:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010651a:	e9 3f f6 ff ff       	jmp    80105b5e <alltraps>

8010651f <vector146>:
.globl vector146
vector146:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $146
80106521:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106526:	e9 33 f6 ff ff       	jmp    80105b5e <alltraps>

8010652b <vector147>:
.globl vector147
vector147:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $147
8010652d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106532:	e9 27 f6 ff ff       	jmp    80105b5e <alltraps>

80106537 <vector148>:
.globl vector148
vector148:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $148
80106539:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010653e:	e9 1b f6 ff ff       	jmp    80105b5e <alltraps>

80106543 <vector149>:
.globl vector149
vector149:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $149
80106545:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010654a:	e9 0f f6 ff ff       	jmp    80105b5e <alltraps>

8010654f <vector150>:
.globl vector150
vector150:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $150
80106551:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106556:	e9 03 f6 ff ff       	jmp    80105b5e <alltraps>

8010655b <vector151>:
.globl vector151
vector151:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $151
8010655d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106562:	e9 f7 f5 ff ff       	jmp    80105b5e <alltraps>

80106567 <vector152>:
.globl vector152
vector152:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $152
80106569:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010656e:	e9 eb f5 ff ff       	jmp    80105b5e <alltraps>

80106573 <vector153>:
.globl vector153
vector153:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $153
80106575:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010657a:	e9 df f5 ff ff       	jmp    80105b5e <alltraps>

8010657f <vector154>:
.globl vector154
vector154:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $154
80106581:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106586:	e9 d3 f5 ff ff       	jmp    80105b5e <alltraps>

8010658b <vector155>:
.globl vector155
vector155:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $155
8010658d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106592:	e9 c7 f5 ff ff       	jmp    80105b5e <alltraps>

80106597 <vector156>:
.globl vector156
vector156:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $156
80106599:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010659e:	e9 bb f5 ff ff       	jmp    80105b5e <alltraps>

801065a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $157
801065a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065aa:	e9 af f5 ff ff       	jmp    80105b5e <alltraps>

801065af <vector158>:
.globl vector158
vector158:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $158
801065b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801065b6:	e9 a3 f5 ff ff       	jmp    80105b5e <alltraps>

801065bb <vector159>:
.globl vector159
vector159:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $159
801065bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065c2:	e9 97 f5 ff ff       	jmp    80105b5e <alltraps>

801065c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $160
801065c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065ce:	e9 8b f5 ff ff       	jmp    80105b5e <alltraps>

801065d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $161
801065d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065da:	e9 7f f5 ff ff       	jmp    80105b5e <alltraps>

801065df <vector162>:
.globl vector162
vector162:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $162
801065e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065e6:	e9 73 f5 ff ff       	jmp    80105b5e <alltraps>

801065eb <vector163>:
.globl vector163
vector163:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $163
801065ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065f2:	e9 67 f5 ff ff       	jmp    80105b5e <alltraps>

801065f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $164
801065f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065fe:	e9 5b f5 ff ff       	jmp    80105b5e <alltraps>

80106603 <vector165>:
.globl vector165
vector165:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $165
80106605:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010660a:	e9 4f f5 ff ff       	jmp    80105b5e <alltraps>

8010660f <vector166>:
.globl vector166
vector166:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $166
80106611:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106616:	e9 43 f5 ff ff       	jmp    80105b5e <alltraps>

8010661b <vector167>:
.globl vector167
vector167:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $167
8010661d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106622:	e9 37 f5 ff ff       	jmp    80105b5e <alltraps>

80106627 <vector168>:
.globl vector168
vector168:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $168
80106629:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010662e:	e9 2b f5 ff ff       	jmp    80105b5e <alltraps>

80106633 <vector169>:
.globl vector169
vector169:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $169
80106635:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010663a:	e9 1f f5 ff ff       	jmp    80105b5e <alltraps>

8010663f <vector170>:
.globl vector170
vector170:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $170
80106641:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106646:	e9 13 f5 ff ff       	jmp    80105b5e <alltraps>

8010664b <vector171>:
.globl vector171
vector171:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $171
8010664d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106652:	e9 07 f5 ff ff       	jmp    80105b5e <alltraps>

80106657 <vector172>:
.globl vector172
vector172:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $172
80106659:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010665e:	e9 fb f4 ff ff       	jmp    80105b5e <alltraps>

80106663 <vector173>:
.globl vector173
vector173:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $173
80106665:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010666a:	e9 ef f4 ff ff       	jmp    80105b5e <alltraps>

8010666f <vector174>:
.globl vector174
vector174:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $174
80106671:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106676:	e9 e3 f4 ff ff       	jmp    80105b5e <alltraps>

8010667b <vector175>:
.globl vector175
vector175:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $175
8010667d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106682:	e9 d7 f4 ff ff       	jmp    80105b5e <alltraps>

80106687 <vector176>:
.globl vector176
vector176:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $176
80106689:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010668e:	e9 cb f4 ff ff       	jmp    80105b5e <alltraps>

80106693 <vector177>:
.globl vector177
vector177:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $177
80106695:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010669a:	e9 bf f4 ff ff       	jmp    80105b5e <alltraps>

8010669f <vector178>:
.globl vector178
vector178:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $178
801066a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066a6:	e9 b3 f4 ff ff       	jmp    80105b5e <alltraps>

801066ab <vector179>:
.globl vector179
vector179:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $179
801066ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801066b2:	e9 a7 f4 ff ff       	jmp    80105b5e <alltraps>

801066b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $180
801066b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066be:	e9 9b f4 ff ff       	jmp    80105b5e <alltraps>

801066c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $181
801066c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066ca:	e9 8f f4 ff ff       	jmp    80105b5e <alltraps>

801066cf <vector182>:
.globl vector182
vector182:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $182
801066d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066d6:	e9 83 f4 ff ff       	jmp    80105b5e <alltraps>

801066db <vector183>:
.globl vector183
vector183:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $183
801066dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066e2:	e9 77 f4 ff ff       	jmp    80105b5e <alltraps>

801066e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $184
801066e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066ee:	e9 6b f4 ff ff       	jmp    80105b5e <alltraps>

801066f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $185
801066f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066fa:	e9 5f f4 ff ff       	jmp    80105b5e <alltraps>

801066ff <vector186>:
.globl vector186
vector186:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $186
80106701:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106706:	e9 53 f4 ff ff       	jmp    80105b5e <alltraps>

8010670b <vector187>:
.globl vector187
vector187:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $187
8010670d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106712:	e9 47 f4 ff ff       	jmp    80105b5e <alltraps>

80106717 <vector188>:
.globl vector188
vector188:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $188
80106719:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010671e:	e9 3b f4 ff ff       	jmp    80105b5e <alltraps>

80106723 <vector189>:
.globl vector189
vector189:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $189
80106725:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010672a:	e9 2f f4 ff ff       	jmp    80105b5e <alltraps>

8010672f <vector190>:
.globl vector190
vector190:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $190
80106731:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106736:	e9 23 f4 ff ff       	jmp    80105b5e <alltraps>

8010673b <vector191>:
.globl vector191
vector191:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $191
8010673d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106742:	e9 17 f4 ff ff       	jmp    80105b5e <alltraps>

80106747 <vector192>:
.globl vector192
vector192:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $192
80106749:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010674e:	e9 0b f4 ff ff       	jmp    80105b5e <alltraps>

80106753 <vector193>:
.globl vector193
vector193:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $193
80106755:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010675a:	e9 ff f3 ff ff       	jmp    80105b5e <alltraps>

8010675f <vector194>:
.globl vector194
vector194:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $194
80106761:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106766:	e9 f3 f3 ff ff       	jmp    80105b5e <alltraps>

8010676b <vector195>:
.globl vector195
vector195:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $195
8010676d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106772:	e9 e7 f3 ff ff       	jmp    80105b5e <alltraps>

80106777 <vector196>:
.globl vector196
vector196:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $196
80106779:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010677e:	e9 db f3 ff ff       	jmp    80105b5e <alltraps>

80106783 <vector197>:
.globl vector197
vector197:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $197
80106785:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010678a:	e9 cf f3 ff ff       	jmp    80105b5e <alltraps>

8010678f <vector198>:
.globl vector198
vector198:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $198
80106791:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106796:	e9 c3 f3 ff ff       	jmp    80105b5e <alltraps>

8010679b <vector199>:
.globl vector199
vector199:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $199
8010679d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067a2:	e9 b7 f3 ff ff       	jmp    80105b5e <alltraps>

801067a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $200
801067a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067ae:	e9 ab f3 ff ff       	jmp    80105b5e <alltraps>

801067b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $201
801067b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801067ba:	e9 9f f3 ff ff       	jmp    80105b5e <alltraps>

801067bf <vector202>:
.globl vector202
vector202:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $202
801067c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067c6:	e9 93 f3 ff ff       	jmp    80105b5e <alltraps>

801067cb <vector203>:
.globl vector203
vector203:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $203
801067cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067d2:	e9 87 f3 ff ff       	jmp    80105b5e <alltraps>

801067d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $204
801067d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067de:	e9 7b f3 ff ff       	jmp    80105b5e <alltraps>

801067e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $205
801067e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067ea:	e9 6f f3 ff ff       	jmp    80105b5e <alltraps>

801067ef <vector206>:
.globl vector206
vector206:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $206
801067f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067f6:	e9 63 f3 ff ff       	jmp    80105b5e <alltraps>

801067fb <vector207>:
.globl vector207
vector207:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $207
801067fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106802:	e9 57 f3 ff ff       	jmp    80105b5e <alltraps>

80106807 <vector208>:
.globl vector208
vector208:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $208
80106809:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010680e:	e9 4b f3 ff ff       	jmp    80105b5e <alltraps>

80106813 <vector209>:
.globl vector209
vector209:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $209
80106815:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010681a:	e9 3f f3 ff ff       	jmp    80105b5e <alltraps>

8010681f <vector210>:
.globl vector210
vector210:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $210
80106821:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106826:	e9 33 f3 ff ff       	jmp    80105b5e <alltraps>

8010682b <vector211>:
.globl vector211
vector211:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $211
8010682d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106832:	e9 27 f3 ff ff       	jmp    80105b5e <alltraps>

80106837 <vector212>:
.globl vector212
vector212:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $212
80106839:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010683e:	e9 1b f3 ff ff       	jmp    80105b5e <alltraps>

80106843 <vector213>:
.globl vector213
vector213:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $213
80106845:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010684a:	e9 0f f3 ff ff       	jmp    80105b5e <alltraps>

8010684f <vector214>:
.globl vector214
vector214:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $214
80106851:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106856:	e9 03 f3 ff ff       	jmp    80105b5e <alltraps>

8010685b <vector215>:
.globl vector215
vector215:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $215
8010685d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106862:	e9 f7 f2 ff ff       	jmp    80105b5e <alltraps>

80106867 <vector216>:
.globl vector216
vector216:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $216
80106869:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010686e:	e9 eb f2 ff ff       	jmp    80105b5e <alltraps>

80106873 <vector217>:
.globl vector217
vector217:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $217
80106875:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010687a:	e9 df f2 ff ff       	jmp    80105b5e <alltraps>

8010687f <vector218>:
.globl vector218
vector218:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $218
80106881:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106886:	e9 d3 f2 ff ff       	jmp    80105b5e <alltraps>

8010688b <vector219>:
.globl vector219
vector219:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $219
8010688d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106892:	e9 c7 f2 ff ff       	jmp    80105b5e <alltraps>

80106897 <vector220>:
.globl vector220
vector220:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $220
80106899:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010689e:	e9 bb f2 ff ff       	jmp    80105b5e <alltraps>

801068a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $221
801068a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068aa:	e9 af f2 ff ff       	jmp    80105b5e <alltraps>

801068af <vector222>:
.globl vector222
vector222:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $222
801068b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801068b6:	e9 a3 f2 ff ff       	jmp    80105b5e <alltraps>

801068bb <vector223>:
.globl vector223
vector223:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $223
801068bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068c2:	e9 97 f2 ff ff       	jmp    80105b5e <alltraps>

801068c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $224
801068c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068ce:	e9 8b f2 ff ff       	jmp    80105b5e <alltraps>

801068d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $225
801068d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068da:	e9 7f f2 ff ff       	jmp    80105b5e <alltraps>

801068df <vector226>:
.globl vector226
vector226:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $226
801068e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068e6:	e9 73 f2 ff ff       	jmp    80105b5e <alltraps>

801068eb <vector227>:
.globl vector227
vector227:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $227
801068ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068f2:	e9 67 f2 ff ff       	jmp    80105b5e <alltraps>

801068f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $228
801068f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068fe:	e9 5b f2 ff ff       	jmp    80105b5e <alltraps>

80106903 <vector229>:
.globl vector229
vector229:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $229
80106905:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010690a:	e9 4f f2 ff ff       	jmp    80105b5e <alltraps>

8010690f <vector230>:
.globl vector230
vector230:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $230
80106911:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106916:	e9 43 f2 ff ff       	jmp    80105b5e <alltraps>

8010691b <vector231>:
.globl vector231
vector231:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $231
8010691d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106922:	e9 37 f2 ff ff       	jmp    80105b5e <alltraps>

80106927 <vector232>:
.globl vector232
vector232:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $232
80106929:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010692e:	e9 2b f2 ff ff       	jmp    80105b5e <alltraps>

80106933 <vector233>:
.globl vector233
vector233:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $233
80106935:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010693a:	e9 1f f2 ff ff       	jmp    80105b5e <alltraps>

8010693f <vector234>:
.globl vector234
vector234:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $234
80106941:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106946:	e9 13 f2 ff ff       	jmp    80105b5e <alltraps>

8010694b <vector235>:
.globl vector235
vector235:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $235
8010694d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106952:	e9 07 f2 ff ff       	jmp    80105b5e <alltraps>

80106957 <vector236>:
.globl vector236
vector236:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $236
80106959:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010695e:	e9 fb f1 ff ff       	jmp    80105b5e <alltraps>

80106963 <vector237>:
.globl vector237
vector237:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $237
80106965:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010696a:	e9 ef f1 ff ff       	jmp    80105b5e <alltraps>

8010696f <vector238>:
.globl vector238
vector238:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $238
80106971:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106976:	e9 e3 f1 ff ff       	jmp    80105b5e <alltraps>

8010697b <vector239>:
.globl vector239
vector239:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $239
8010697d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106982:	e9 d7 f1 ff ff       	jmp    80105b5e <alltraps>

80106987 <vector240>:
.globl vector240
vector240:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $240
80106989:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010698e:	e9 cb f1 ff ff       	jmp    80105b5e <alltraps>

80106993 <vector241>:
.globl vector241
vector241:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $241
80106995:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010699a:	e9 bf f1 ff ff       	jmp    80105b5e <alltraps>

8010699f <vector242>:
.globl vector242
vector242:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $242
801069a1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069a6:	e9 b3 f1 ff ff       	jmp    80105b5e <alltraps>

801069ab <vector243>:
.globl vector243
vector243:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $243
801069ad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801069b2:	e9 a7 f1 ff ff       	jmp    80105b5e <alltraps>

801069b7 <vector244>:
.globl vector244
vector244:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $244
801069b9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069be:	e9 9b f1 ff ff       	jmp    80105b5e <alltraps>

801069c3 <vector245>:
.globl vector245
vector245:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $245
801069c5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069ca:	e9 8f f1 ff ff       	jmp    80105b5e <alltraps>

801069cf <vector246>:
.globl vector246
vector246:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $246
801069d1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069d6:	e9 83 f1 ff ff       	jmp    80105b5e <alltraps>

801069db <vector247>:
.globl vector247
vector247:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $247
801069dd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069e2:	e9 77 f1 ff ff       	jmp    80105b5e <alltraps>

801069e7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $248
801069e9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069ee:	e9 6b f1 ff ff       	jmp    80105b5e <alltraps>

801069f3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $249
801069f5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069fa:	e9 5f f1 ff ff       	jmp    80105b5e <alltraps>

801069ff <vector250>:
.globl vector250
vector250:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $250
80106a01:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a06:	e9 53 f1 ff ff       	jmp    80105b5e <alltraps>

80106a0b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $251
80106a0d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a12:	e9 47 f1 ff ff       	jmp    80105b5e <alltraps>

80106a17 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $252
80106a19:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a1e:	e9 3b f1 ff ff       	jmp    80105b5e <alltraps>

80106a23 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $253
80106a25:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a2a:	e9 2f f1 ff ff       	jmp    80105b5e <alltraps>

80106a2f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $254
80106a31:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a36:	e9 23 f1 ff ff       	jmp    80105b5e <alltraps>

80106a3b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $255
80106a3d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a42:	e9 17 f1 ff ff       	jmp    80105b5e <alltraps>
80106a47:	66 90                	xchg   %ax,%ax
80106a49:	66 90                	xchg   %ax,%ax
80106a4b:	66 90                	xchg   %ax,%ax
80106a4d:	66 90                	xchg   %ax,%ax
80106a4f:	90                   	nop

80106a50 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a58:	c1 ea 16             	shr    $0x16,%edx
80106a5b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a5e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106a61:	8b 07                	mov    (%edi),%eax
80106a63:	a8 01                	test   $0x1,%al
80106a65:	74 29                	je     80106a90 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a6c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a75:	c1 eb 0a             	shr    $0xa,%ebx
80106a78:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106a7e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106a81:	5b                   	pop    %ebx
80106a82:	5e                   	pop    %esi
80106a83:	5f                   	pop    %edi
80106a84:	5d                   	pop    %ebp
80106a85:	c3                   	ret    
80106a86:	8d 76 00             	lea    0x0(%esi),%esi
80106a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a90:	85 c9                	test   %ecx,%ecx
80106a92:	74 2c                	je     80106ac0 <walkpgdir+0x70>
80106a94:	e8 a7 b9 ff ff       	call   80102440 <kalloc>
80106a99:	85 c0                	test   %eax,%eax
80106a9b:	89 c6                	mov    %eax,%esi
80106a9d:	74 21                	je     80106ac0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106a9f:	83 ec 04             	sub    $0x4,%esp
80106aa2:	68 00 10 00 00       	push   $0x1000
80106aa7:	6a 00                	push   $0x0
80106aa9:	50                   	push   %eax
80106aaa:	e8 a1 dd ff ff       	call   80104850 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106aaf:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ab5:	83 c4 10             	add    $0x10,%esp
80106ab8:	83 c8 07             	or     $0x7,%eax
80106abb:	89 07                	mov    %eax,(%edi)
80106abd:	eb b3                	jmp    80106a72 <walkpgdir+0x22>
80106abf:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106ac3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106ac5:	5b                   	pop    %ebx
80106ac6:	5e                   	pop    %esi
80106ac7:	5f                   	pop    %edi
80106ac8:	5d                   	pop    %ebp
80106ac9:	c3                   	ret    
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ad0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106ad6:	89 d3                	mov    %edx,%ebx
80106ad8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ade:	83 ec 1c             	sub    $0x1c,%esp
80106ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ae4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ae8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106aeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106af0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106af3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106af6:	29 df                	sub    %ebx,%edi
80106af8:	83 c8 01             	or     $0x1,%eax
80106afb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106afe:	eb 15                	jmp    80106b15 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106b00:	f6 00 01             	testb  $0x1,(%eax)
80106b03:	75 45                	jne    80106b4a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b05:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b08:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b0b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b0d:	74 31                	je     80106b40 <mappages+0x70>
      break;
    a += PGSIZE;
80106b0f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b18:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b1d:	89 da                	mov    %ebx,%edx
80106b1f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b22:	e8 29 ff ff ff       	call   80106a50 <walkpgdir>
80106b27:	85 c0                	test   %eax,%eax
80106b29:	75 d5                	jne    80106b00 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106b2b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106b2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106b33:	5b                   	pop    %ebx
80106b34:	5e                   	pop    %esi
80106b35:	5f                   	pop    %edi
80106b36:	5d                   	pop    %ebp
80106b37:	c3                   	ret    
80106b38:	90                   	nop
80106b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106b43:	31 c0                	xor    %eax,%eax
}
80106b45:	5b                   	pop    %ebx
80106b46:	5e                   	pop    %esi
80106b47:	5f                   	pop    %edi
80106b48:	5d                   	pop    %ebp
80106b49:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106b4a:	83 ec 0c             	sub    $0xc,%esp
80106b4d:	68 80 7c 10 80       	push   $0x80107c80
80106b52:	e8 19 98 ff ff       	call   80100370 <panic>
80106b57:	89 f6                	mov    %esi,%esi
80106b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b60 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b66:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b6c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b6e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b74:	83 ec 1c             	sub    $0x1c,%esp
80106b77:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106b7a:	39 d3                	cmp    %edx,%ebx
80106b7c:	73 66                	jae    80106be4 <deallocuvm.part.0+0x84>
80106b7e:	89 d6                	mov    %edx,%esi
80106b80:	eb 3d                	jmp    80106bbf <deallocuvm.part.0+0x5f>
80106b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106b88:	8b 10                	mov    (%eax),%edx
80106b8a:	f6 c2 01             	test   $0x1,%dl
80106b8d:	74 26                	je     80106bb5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106b8f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106b95:	74 58                	je     80106bef <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106b97:	83 ec 0c             	sub    $0xc,%esp
80106b9a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ba0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ba3:	52                   	push   %edx
80106ba4:	e8 e7 b6 ff ff       	call   80102290 <kfree>
      *pte = 0;
80106ba9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bac:	83 c4 10             	add    $0x10,%esp
80106baf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106bb5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bbb:	39 f3                	cmp    %esi,%ebx
80106bbd:	73 25                	jae    80106be4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106bbf:	31 c9                	xor    %ecx,%ecx
80106bc1:	89 da                	mov    %ebx,%edx
80106bc3:	89 f8                	mov    %edi,%eax
80106bc5:	e8 86 fe ff ff       	call   80106a50 <walkpgdir>
    if(!pte)
80106bca:	85 c0                	test   %eax,%eax
80106bcc:	75 ba                	jne    80106b88 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106bce:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106bd4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106bda:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106be0:	39 f3                	cmp    %esi,%ebx
80106be2:	72 db                	jb     80106bbf <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106be4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bea:	5b                   	pop    %ebx
80106beb:	5e                   	pop    %esi
80106bec:	5f                   	pop    %edi
80106bed:	5d                   	pop    %ebp
80106bee:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106bef:	83 ec 0c             	sub    $0xc,%esp
80106bf2:	68 be 75 10 80       	push   $0x801075be
80106bf7:	e8 74 97 ff ff       	call   80100370 <panic>
80106bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c00 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	53                   	push   %ebx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c04:	31 db                	xor    %ebx,%ebx

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106c06:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106c09:	e8 92 ba ff ff       	call   801026a0 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c0e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106c14:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106c19:	8d 90 a0 27 11 80    	lea    -0x7feed860(%eax),%edx
80106c1f:	c6 80 1d 28 11 80 9a 	movb   $0x9a,-0x7feed7e3(%eax)
80106c26:	c6 80 1e 28 11 80 cf 	movb   $0xcf,-0x7feed7e2(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c2d:	c6 80 25 28 11 80 92 	movb   $0x92,-0x7feed7db(%eax)
80106c34:	c6 80 26 28 11 80 cf 	movb   $0xcf,-0x7feed7da(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c3b:	66 89 4a 78          	mov    %cx,0x78(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c3f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c44:	66 89 5a 7a          	mov    %bx,0x7a(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c48:	66 89 8a 80 00 00 00 	mov    %cx,0x80(%edx)
80106c4f:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c51:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c56:	66 89 9a 82 00 00 00 	mov    %bx,0x82(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c5d:	66 89 8a 90 00 00 00 	mov    %cx,0x90(%edx)
80106c64:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c66:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c6b:	66 89 9a 92 00 00 00 	mov    %bx,0x92(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c72:	31 db                	xor    %ebx,%ebx
80106c74:	66 89 8a 98 00 00 00 	mov    %cx,0x98(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106c7b:	8d 88 54 28 11 80    	lea    -0x7feed7ac(%eax),%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c81:	66 89 9a 9a 00 00 00 	mov    %bx,0x9a(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106c88:	31 db                	xor    %ebx,%ebx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c8a:	c6 80 35 28 11 80 fa 	movb   $0xfa,-0x7feed7cb(%eax)
80106c91:	c6 80 36 28 11 80 cf 	movb   $0xcf,-0x7feed7ca(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106c98:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
80106c9f:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
80106ca6:	89 cb                	mov    %ecx,%ebx
80106ca8:	c1 e9 18             	shr    $0x18,%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cab:	c6 80 3d 28 11 80 f2 	movb   $0xf2,-0x7feed7c3(%eax)
80106cb2:	c6 80 3e 28 11 80 cf 	movb   $0xcf,-0x7feed7c2(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106cb9:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
80106cbf:	c6 80 2d 28 11 80 92 	movb   $0x92,-0x7feed7d3(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106cc6:	b9 37 00 00 00       	mov    $0x37,%ecx
80106ccb:	c6 80 2e 28 11 80 c0 	movb   $0xc0,-0x7feed7d2(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80106cd2:	05 10 28 11 80       	add    $0x80112810,%eax
80106cd7:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106cdb:	c1 eb 10             	shr    $0x10,%ebx
  pd[1] = (uint)p;
80106cde:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ce2:	c1 e8 10             	shr    $0x10,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ce5:	c6 42 7c 00          	movb   $0x0,0x7c(%edx)
80106ce9:	c6 42 7f 00          	movb   $0x0,0x7f(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ced:	c6 82 84 00 00 00 00 	movb   $0x0,0x84(%edx)
80106cf4:	c6 82 87 00 00 00 00 	movb   $0x0,0x87(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cfb:	c6 82 94 00 00 00 00 	movb   $0x0,0x94(%edx)
80106d02:	c6 82 97 00 00 00 00 	movb   $0x0,0x97(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d09:	c6 82 9c 00 00 00 00 	movb   $0x0,0x9c(%edx)
80106d10:	c6 82 9f 00 00 00 00 	movb   $0x0,0x9f(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106d17:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
80106d1d:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106d21:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d24:	0f 01 10             	lgdtl  (%eax)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106d27:	b8 18 00 00 00       	mov    $0x18,%eax
80106d2c:	8e e8                	mov    %eax,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106d2e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106d35:	00 00 00 00 

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106d39:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
}
80106d40:	83 c4 14             	add    $0x14,%esp
80106d43:	5b                   	pop    %ebx
80106d44:	5d                   	pop    %ebp
80106d45:	c3                   	ret    
80106d46:	8d 76 00             	lea    0x0(%esi),%esi
80106d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d50 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	56                   	push   %esi
80106d54:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106d55:	e8 e6 b6 ff ff       	call   80102440 <kalloc>
80106d5a:	85 c0                	test   %eax,%eax
80106d5c:	74 52                	je     80106db0 <setupkvm+0x60>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106d5e:	83 ec 04             	sub    $0x4,%esp
80106d61:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d63:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106d68:	68 00 10 00 00       	push   $0x1000
80106d6d:	6a 00                	push   $0x0
80106d6f:	50                   	push   %eax
80106d70:	e8 db da ff ff       	call   80104850 <memset>
80106d75:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d78:	8b 43 04             	mov    0x4(%ebx),%eax
80106d7b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d7e:	83 ec 08             	sub    $0x8,%esp
80106d81:	8b 13                	mov    (%ebx),%edx
80106d83:	ff 73 0c             	pushl  0xc(%ebx)
80106d86:	50                   	push   %eax
80106d87:	29 c1                	sub    %eax,%ecx
80106d89:	89 f0                	mov    %esi,%eax
80106d8b:	e8 40 fd ff ff       	call   80106ad0 <mappages>
80106d90:	83 c4 10             	add    $0x10,%esp
80106d93:	85 c0                	test   %eax,%eax
80106d95:	78 19                	js     80106db0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d97:	83 c3 10             	add    $0x10,%ebx
80106d9a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106da0:	75 d6                	jne    80106d78 <setupkvm+0x28>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106da2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106da5:	89 f0                	mov    %esi,%eax
80106da7:	5b                   	pop    %ebx
80106da8:	5e                   	pop    %esi
80106da9:	5d                   	pop    %ebp
80106daa:	c3                   	ret    
80106dab:	90                   	nop
80106dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106db0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106db3:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106db5:	5b                   	pop    %ebx
80106db6:	5e                   	pop    %esi
80106db7:	5d                   	pop    %ebp
80106db8:	c3                   	ret    
80106db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106dc0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106dc6:	e8 85 ff ff ff       	call   80106d50 <setupkvm>
80106dcb:	a3 24 56 11 80       	mov    %eax,0x80115624
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106dd0:	05 00 00 00 80       	add    $0x80000000,%eax
80106dd5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106dd8:	c9                   	leave  
80106dd9:	c3                   	ret    
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106de0 <switchkvm>:
80106de0:	a1 24 56 11 80       	mov    0x80115624,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106de5:	55                   	push   %ebp
80106de6:	89 e5                	mov    %esp,%ebp
80106de8:	05 00 00 00 80       	add    $0x80000000,%eax
80106ded:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106df0:	5d                   	pop    %ebp
80106df1:	c3                   	ret    
80106df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e00 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	53                   	push   %ebx
80106e04:	83 ec 04             	sub    $0x4,%esp
80106e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106e0a:	85 db                	test   %ebx,%ebx
80106e0c:	0f 84 93 00 00 00    	je     80106ea5 <switchuvm+0xa5>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106e12:	8b 43 08             	mov    0x8(%ebx),%eax
80106e15:	85 c0                	test   %eax,%eax
80106e17:	0f 84 a2 00 00 00    	je     80106ebf <switchuvm+0xbf>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106e1d:	8b 43 04             	mov    0x4(%ebx),%eax
80106e20:	85 c0                	test   %eax,%eax
80106e22:	0f 84 8a 00 00 00    	je     80106eb2 <switchuvm+0xb2>
    panic("switchuvm: no pgdir");

  pushcli();
80106e28:	e8 53 d9 ff ff       	call   80104780 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106e2d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106e33:	b9 67 00 00 00       	mov    $0x67,%ecx
80106e38:	8d 50 08             	lea    0x8(%eax),%edx
80106e3b:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106e42:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80106e49:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106e50:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106e57:	89 d1                	mov    %edx,%ecx
80106e59:	c1 ea 18             	shr    $0x18,%edx
80106e5c:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106e62:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106e65:	ba 10 00 00 00       	mov    $0x10,%edx
80106e6a:	66 89 50 10          	mov    %dx,0x10(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106e6e:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e74:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106e77:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106e7d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106e82:	66 89 48 6e          	mov    %cx,0x6e(%eax)

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e86:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106e89:	b8 30 00 00 00       	mov    $0x30,%eax
80106e8e:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e91:	8b 43 04             	mov    0x4(%ebx),%eax
80106e94:	05 00 00 00 80       	add    $0x80000000,%eax
80106e99:	0f 22 d8             	mov    %eax,%cr3
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106e9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106e9f:	c9                   	leave  
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106ea0:	e9 0b d9 ff ff       	jmp    801047b0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106ea5:	83 ec 0c             	sub    $0xc,%esp
80106ea8:	68 86 7c 10 80       	push   $0x80107c86
80106ead:	e8 be 94 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106eb2:	83 ec 0c             	sub    $0xc,%esp
80106eb5:	68 b1 7c 10 80       	push   $0x80107cb1
80106eba:	e8 b1 94 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106ebf:	83 ec 0c             	sub    $0xc,%esp
80106ec2:	68 9c 7c 10 80       	push   $0x80107c9c
80106ec7:	e8 a4 94 ff ff       	call   80100370 <panic>
80106ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ed0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
80106ed9:	8b 75 10             	mov    0x10(%ebp),%esi
80106edc:	8b 45 08             	mov    0x8(%ebp),%eax
80106edf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106ee2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ee8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106eeb:	77 49                	ja     80106f36 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106eed:	e8 4e b5 ff ff       	call   80102440 <kalloc>
  memset(mem, 0, PGSIZE);
80106ef2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106ef5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ef7:	68 00 10 00 00       	push   $0x1000
80106efc:	6a 00                	push   $0x0
80106efe:	50                   	push   %eax
80106eff:	e8 4c d9 ff ff       	call   80104850 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f04:	58                   	pop    %eax
80106f05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f0b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f10:	5a                   	pop    %edx
80106f11:	6a 06                	push   $0x6
80106f13:	50                   	push   %eax
80106f14:	31 d2                	xor    %edx,%edx
80106f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f19:	e8 b2 fb ff ff       	call   80106ad0 <mappages>
  memmove(mem, init, sz);
80106f1e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f21:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f24:	83 c4 10             	add    $0x10,%esp
80106f27:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f2d:	5b                   	pop    %ebx
80106f2e:	5e                   	pop    %esi
80106f2f:	5f                   	pop    %edi
80106f30:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106f31:	e9 ca d9 ff ff       	jmp    80104900 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106f36:	83 ec 0c             	sub    $0xc,%esp
80106f39:	68 c5 7c 10 80       	push   $0x80107cc5
80106f3e:	e8 2d 94 ff ff       	call   80100370 <panic>
80106f43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f50 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
80106f56:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106f59:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106f60:	0f 85 91 00 00 00    	jne    80106ff7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106f66:	8b 75 18             	mov    0x18(%ebp),%esi
80106f69:	31 db                	xor    %ebx,%ebx
80106f6b:	85 f6                	test   %esi,%esi
80106f6d:	75 1a                	jne    80106f89 <loaduvm+0x39>
80106f6f:	eb 6f                	jmp    80106fe0 <loaduvm+0x90>
80106f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f78:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f7e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106f84:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106f87:	76 57                	jbe    80106fe0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f89:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f8f:	31 c9                	xor    %ecx,%ecx
80106f91:	01 da                	add    %ebx,%edx
80106f93:	e8 b8 fa ff ff       	call   80106a50 <walkpgdir>
80106f98:	85 c0                	test   %eax,%eax
80106f9a:	74 4e                	je     80106fea <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106f9c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106fa1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106fa6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106fab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fb1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fb4:	01 d9                	add    %ebx,%ecx
80106fb6:	05 00 00 00 80       	add    $0x80000000,%eax
80106fbb:	57                   	push   %edi
80106fbc:	51                   	push   %ecx
80106fbd:	50                   	push   %eax
80106fbe:	ff 75 10             	pushl  0x10(%ebp)
80106fc1:	e8 1a a9 ff ff       	call   801018e0 <readi>
80106fc6:	83 c4 10             	add    $0x10,%esp
80106fc9:	39 c7                	cmp    %eax,%edi
80106fcb:	74 ab                	je     80106f78 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106fcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106fd5:	5b                   	pop    %ebx
80106fd6:	5e                   	pop    %esi
80106fd7:	5f                   	pop    %edi
80106fd8:	5d                   	pop    %ebp
80106fd9:	c3                   	ret    
80106fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106fe3:	31 c0                	xor    %eax,%eax
}
80106fe5:	5b                   	pop    %ebx
80106fe6:	5e                   	pop    %esi
80106fe7:	5f                   	pop    %edi
80106fe8:	5d                   	pop    %ebp
80106fe9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106fea:	83 ec 0c             	sub    $0xc,%esp
80106fed:	68 df 7c 10 80       	push   $0x80107cdf
80106ff2:	e8 79 93 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106ff7:	83 ec 0c             	sub    $0xc,%esp
80106ffa:	68 80 7d 10 80       	push   $0x80107d80
80106fff:	e8 6c 93 ff ff       	call   80100370 <panic>
80107004:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010700a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107010 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 0c             	sub    $0xc,%esp
80107019:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010701c:	85 ff                	test   %edi,%edi
8010701e:	0f 88 ca 00 00 00    	js     801070ee <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107024:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107027:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010702a:	0f 82 82 00 00 00    	jb     801070b2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107030:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107036:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010703c:	39 df                	cmp    %ebx,%edi
8010703e:	77 43                	ja     80107083 <allocuvm+0x73>
80107040:	e9 bb 00 00 00       	jmp    80107100 <allocuvm+0xf0>
80107045:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107048:	83 ec 04             	sub    $0x4,%esp
8010704b:	68 00 10 00 00       	push   $0x1000
80107050:	6a 00                	push   $0x0
80107052:	50                   	push   %eax
80107053:	e8 f8 d7 ff ff       	call   80104850 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107058:	58                   	pop    %eax
80107059:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010705f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107064:	5a                   	pop    %edx
80107065:	6a 06                	push   $0x6
80107067:	50                   	push   %eax
80107068:	89 da                	mov    %ebx,%edx
8010706a:	8b 45 08             	mov    0x8(%ebp),%eax
8010706d:	e8 5e fa ff ff       	call   80106ad0 <mappages>
80107072:	83 c4 10             	add    $0x10,%esp
80107075:	85 c0                	test   %eax,%eax
80107077:	78 47                	js     801070c0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107079:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010707f:	39 df                	cmp    %ebx,%edi
80107081:	76 7d                	jbe    80107100 <allocuvm+0xf0>
    mem = kalloc();
80107083:	e8 b8 b3 ff ff       	call   80102440 <kalloc>
    if(mem == 0){
80107088:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010708a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010708c:	75 ba                	jne    80107048 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010708e:	83 ec 0c             	sub    $0xc,%esp
80107091:	68 fd 7c 10 80       	push   $0x80107cfd
80107096:	e8 c5 95 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010709b:	83 c4 10             	add    $0x10,%esp
8010709e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801070a1:	76 4b                	jbe    801070ee <allocuvm+0xde>
801070a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070a6:	8b 45 08             	mov    0x8(%ebp),%eax
801070a9:	89 fa                	mov    %edi,%edx
801070ab:	e8 b0 fa ff ff       	call   80106b60 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801070b0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801070b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b5:	5b                   	pop    %ebx
801070b6:	5e                   	pop    %esi
801070b7:	5f                   	pop    %edi
801070b8:	5d                   	pop    %ebp
801070b9:	c3                   	ret    
801070ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801070c0:	83 ec 0c             	sub    $0xc,%esp
801070c3:	68 15 7d 10 80       	push   $0x80107d15
801070c8:	e8 93 95 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801070cd:	83 c4 10             	add    $0x10,%esp
801070d0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801070d3:	76 0d                	jbe    801070e2 <allocuvm+0xd2>
801070d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070d8:	8b 45 08             	mov    0x8(%ebp),%eax
801070db:	89 fa                	mov    %edi,%edx
801070dd:	e8 7e fa ff ff       	call   80106b60 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801070e2:	83 ec 0c             	sub    $0xc,%esp
801070e5:	56                   	push   %esi
801070e6:	e8 a5 b1 ff ff       	call   80102290 <kfree>
      return 0;
801070eb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
801070ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
801070f1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
801070f3:	5b                   	pop    %ebx
801070f4:	5e                   	pop    %esi
801070f5:	5f                   	pop    %edi
801070f6:	5d                   	pop    %ebp
801070f7:	c3                   	ret    
801070f8:	90                   	nop
801070f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107100:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107103:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107105:	5b                   	pop    %ebx
80107106:	5e                   	pop    %esi
80107107:	5f                   	pop    %edi
80107108:	5d                   	pop    %ebp
80107109:	c3                   	ret    
8010710a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107110 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	8b 55 0c             	mov    0xc(%ebp),%edx
80107116:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107119:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010711c:	39 d1                	cmp    %edx,%ecx
8010711e:	73 10                	jae    80107130 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107120:	5d                   	pop    %ebp
80107121:	e9 3a fa ff ff       	jmp    80106b60 <deallocuvm.part.0>
80107126:	8d 76 00             	lea    0x0(%esi),%esi
80107129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107130:	89 d0                	mov    %edx,%eax
80107132:	5d                   	pop    %ebp
80107133:	c3                   	ret    
80107134:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010713a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107140 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 0c             	sub    $0xc,%esp
80107149:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010714c:	85 f6                	test   %esi,%esi
8010714e:	74 59                	je     801071a9 <freevm+0x69>
80107150:	31 c9                	xor    %ecx,%ecx
80107152:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107157:	89 f0                	mov    %esi,%eax
80107159:	e8 02 fa ff ff       	call   80106b60 <deallocuvm.part.0>
8010715e:	89 f3                	mov    %esi,%ebx
80107160:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107166:	eb 0f                	jmp    80107177 <freevm+0x37>
80107168:	90                   	nop
80107169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107170:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107173:	39 fb                	cmp    %edi,%ebx
80107175:	74 23                	je     8010719a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107177:	8b 03                	mov    (%ebx),%eax
80107179:	a8 01                	test   $0x1,%al
8010717b:	74 f3                	je     80107170 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010717d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107182:	83 ec 0c             	sub    $0xc,%esp
80107185:	83 c3 04             	add    $0x4,%ebx
80107188:	05 00 00 00 80       	add    $0x80000000,%eax
8010718d:	50                   	push   %eax
8010718e:	e8 fd b0 ff ff       	call   80102290 <kfree>
80107193:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107196:	39 fb                	cmp    %edi,%ebx
80107198:	75 dd                	jne    80107177 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010719a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010719d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071a0:	5b                   	pop    %ebx
801071a1:	5e                   	pop    %esi
801071a2:	5f                   	pop    %edi
801071a3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801071a4:	e9 e7 b0 ff ff       	jmp    80102290 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801071a9:	83 ec 0c             	sub    $0xc,%esp
801071ac:	68 31 7d 10 80       	push   $0x80107d31
801071b1:	e8 ba 91 ff ff       	call   80100370 <panic>
801071b6:	8d 76 00             	lea    0x0(%esi),%esi
801071b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071c1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071c3:	89 e5                	mov    %esp,%ebp
801071c5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071cb:	8b 45 08             	mov    0x8(%ebp),%eax
801071ce:	e8 7d f8 ff ff       	call   80106a50 <walkpgdir>
  if(pte == 0)
801071d3:	85 c0                	test   %eax,%eax
801071d5:	74 05                	je     801071dc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801071d7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071da:	c9                   	leave  
801071db:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801071dc:	83 ec 0c             	sub    $0xc,%esp
801071df:	68 42 7d 10 80       	push   $0x80107d42
801071e4:	e8 87 91 ff ff       	call   80100370 <panic>
801071e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071f9:	e8 52 fb ff ff       	call   80106d50 <setupkvm>
801071fe:	85 c0                	test   %eax,%eax
80107200:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107203:	0f 84 b2 00 00 00    	je     801072bb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107209:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010720c:	85 c9                	test   %ecx,%ecx
8010720e:	0f 84 9c 00 00 00    	je     801072b0 <copyuvm+0xc0>
80107214:	31 f6                	xor    %esi,%esi
80107216:	eb 4a                	jmp    80107262 <copyuvm+0x72>
80107218:	90                   	nop
80107219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107220:	83 ec 04             	sub    $0x4,%esp
80107223:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107229:	68 00 10 00 00       	push   $0x1000
8010722e:	57                   	push   %edi
8010722f:	50                   	push   %eax
80107230:	e8 cb d6 ff ff       	call   80104900 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107235:	58                   	pop    %eax
80107236:	5a                   	pop    %edx
80107237:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
8010723d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107240:	ff 75 e4             	pushl  -0x1c(%ebp)
80107243:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107248:	52                   	push   %edx
80107249:	89 f2                	mov    %esi,%edx
8010724b:	e8 80 f8 ff ff       	call   80106ad0 <mappages>
80107250:	83 c4 10             	add    $0x10,%esp
80107253:	85 c0                	test   %eax,%eax
80107255:	78 3e                	js     80107295 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107257:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010725d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107260:	76 4e                	jbe    801072b0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107262:	8b 45 08             	mov    0x8(%ebp),%eax
80107265:	31 c9                	xor    %ecx,%ecx
80107267:	89 f2                	mov    %esi,%edx
80107269:	e8 e2 f7 ff ff       	call   80106a50 <walkpgdir>
8010726e:	85 c0                	test   %eax,%eax
80107270:	74 5a                	je     801072cc <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107272:	8b 18                	mov    (%eax),%ebx
80107274:	f6 c3 01             	test   $0x1,%bl
80107277:	74 46                	je     801072bf <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107279:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010727b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107281:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107284:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010728a:	e8 b1 b1 ff ff       	call   80102440 <kalloc>
8010728f:	85 c0                	test   %eax,%eax
80107291:	89 c3                	mov    %eax,%ebx
80107293:	75 8b                	jne    80107220 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107295:	83 ec 0c             	sub    $0xc,%esp
80107298:	ff 75 e0             	pushl  -0x20(%ebp)
8010729b:	e8 a0 fe ff ff       	call   80107140 <freevm>
  return 0;
801072a0:	83 c4 10             	add    $0x10,%esp
801072a3:	31 c0                	xor    %eax,%eax
}
801072a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a8:	5b                   	pop    %ebx
801072a9:	5e                   	pop    %esi
801072aa:	5f                   	pop    %edi
801072ab:	5d                   	pop    %ebp
801072ac:	c3                   	ret    
801072ad:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801072b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
801072b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b6:	5b                   	pop    %ebx
801072b7:	5e                   	pop    %esi
801072b8:	5f                   	pop    %edi
801072b9:	5d                   	pop    %ebp
801072ba:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801072bb:	31 c0                	xor    %eax,%eax
801072bd:	eb e6                	jmp    801072a5 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801072bf:	83 ec 0c             	sub    $0xc,%esp
801072c2:	68 66 7d 10 80       	push   $0x80107d66
801072c7:	e8 a4 90 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801072cc:	83 ec 0c             	sub    $0xc,%esp
801072cf:	68 4c 7d 10 80       	push   $0x80107d4c
801072d4:	e8 97 90 ff ff       	call   80100370 <panic>
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072e1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072e3:	89 e5                	mov    %esp,%ebp
801072e5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072eb:	8b 45 08             	mov    0x8(%ebp),%eax
801072ee:	e8 5d f7 ff ff       	call   80106a50 <walkpgdir>
  if((*pte & PTE_P) == 0)
801072f3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801072f5:	89 c2                	mov    %eax,%edx
801072f7:	83 e2 05             	and    $0x5,%edx
801072fa:	83 fa 05             	cmp    $0x5,%edx
801072fd:	75 11                	jne    80107310 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801072ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107304:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107305:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010730a:	c3                   	ret    
8010730b:	90                   	nop
8010730c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107310:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107312:	c9                   	leave  
80107313:	c3                   	ret    
80107314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010731a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107320 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
80107329:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010732c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010732f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107332:	85 db                	test   %ebx,%ebx
80107334:	75 40                	jne    80107376 <copyout+0x56>
80107336:	eb 70                	jmp    801073a8 <copyout+0x88>
80107338:	90                   	nop
80107339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107340:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107343:	89 f1                	mov    %esi,%ecx
80107345:	29 d1                	sub    %edx,%ecx
80107347:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010734d:	39 d9                	cmp    %ebx,%ecx
8010734f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107352:	29 f2                	sub    %esi,%edx
80107354:	83 ec 04             	sub    $0x4,%esp
80107357:	01 d0                	add    %edx,%eax
80107359:	51                   	push   %ecx
8010735a:	57                   	push   %edi
8010735b:	50                   	push   %eax
8010735c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010735f:	e8 9c d5 ff ff       	call   80104900 <memmove>
    len -= n;
    buf += n;
80107364:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107367:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010736a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107370:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107372:	29 cb                	sub    %ecx,%ebx
80107374:	74 32                	je     801073a8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107376:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107378:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010737b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010737e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107384:	56                   	push   %esi
80107385:	ff 75 08             	pushl  0x8(%ebp)
80107388:	e8 53 ff ff ff       	call   801072e0 <uva2ka>
    if(pa0 == 0)
8010738d:	83 c4 10             	add    $0x10,%esp
80107390:	85 c0                	test   %eax,%eax
80107392:	75 ac                	jne    80107340 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107394:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010739c:	5b                   	pop    %ebx
8010739d:	5e                   	pop    %esi
8010739e:	5f                   	pop    %edi
8010739f:	5d                   	pop    %ebp
801073a0:	c3                   	ret    
801073a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801073ab:	31 c0                	xor    %eax,%eax
}
801073ad:	5b                   	pop    %ebx
801073ae:	5e                   	pop    %esi
801073af:	5f                   	pop    %edi
801073b0:	5d                   	pop    %ebp
801073b1:	c3                   	ret    
