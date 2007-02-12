From: "roland" <devzero@web.de>
Subject: Re: [PATCH 2.6.20] updated dm-loop patch
Date: Mon, 12 Feb 2007 09:49:19 +0100
Message-ID: <0a3001c74e82$bb519730$eeeea8c0@aldipc>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <breeves@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Bryn,

after some first tests which looked very very promising (could dmlosetup 
files >2gb, could create more than 256 loop dm-loop devices...), i have bad 
news.
maybe it`s not that "bad" because you may be able to fix it quickly, but it 
seems that dm-loop is racy (or whatever). maybe smp safeness, since i was 
testing on a P4 with HT enabled ? i did my first tests on non-smp system 
(VM), but it wasn`t put under that load as i did now.

i created some larger dm-loops, put a filesystem on that and generated some 
heavy load (loadavg >40)

- loop0: 1gig - reiserfs - untar kernel 2.6.20 and "make -j 16 bzImage 
modules"
- loop1: 5gig - ext3 - ditto
- loop2: mkfs.reiserfs needed some time because of system being so busy. 
while waiting for creation, i switched to the next vt
- while creating the 4th image-file and while mkfs.reiserfs was busy 
creating filesystem on loop2, bang - the whole thing crashed.

i have attached the dmesg output and i`m happy to assist for doing some more 
tests like this to get this nice piece of work stable ! :)

regards
roland

ps:
hey, why not announcing this on lkml, so this gut get some more notice or 
being reviewed by others?


Feb 12 12:58:56 test kernel: EXT3 FS on dm-1, internal journal
Feb 12 12:58:56 test kernel: EXT3-fs: mounted filesystem with ordered data 
mode.
Feb 12 12:58:56 test udevd-event[7064]: run_program: ressize 256 too short
Feb 12 13:21:05 test kernel: device-mapper: loop: not using 4294967296 bytes 
in incomplete block at EOF
Feb 12 13:21:05 test kernel: device-mapper: loop DEBUG: allocated linear 
extent map of 6049 bytes for 252 extents (8064 bytes)
Feb 12 13:21:05 test kernel: device-mapper: loop DEBUG: splitting io at 8 
sector boundaries
Feb 12 13:21:05 test kernel: device-mapper: loop DEBUG: constructed loop 
target on /usr/src/5gig.dat (5120000k, 1851392 sectors)
Feb 12 13:21:05 test udevd-event[9296]: run_program: ressize 256 too short
Feb 12 13:21:05 test udevd-event[9296]: run_program: ressize 256 too short
Feb 12 13:21:05 test udevd-event[9305]: run_program: ressize 256 too short
Feb 12 13:21:28 test kernel: device-mapper: loop: no matching extent in map 
for sector 10239992!
Feb 12 13:21:28 test kernel: Buffer I/O error on device dm-2, logical block 
1279999
Feb 12 13:21:28 test kernel: ------------[ cut here ]------------
Feb 12 13:21:28 test kernel: kernel BUG at drivers/md/dm-loop.c:260!
Feb 12 13:21:28 test kernel: invalid opcode: 0000 [#1]
Feb 12 13:21:28 test kernel: SMP
Feb 12 13:21:28 test kernel: Modules linked in: dm_loop
Feb 12 13:21:28 test kernel: CPU:    0
Feb 12 13:21:28 test kernel: EIP:    0060:[<f88d70b9>]    Not tainted VLI
Feb 12 13:21:28 test kernel: EFLAGS: 00010246   (2.6.20 #6)
Feb 12 13:21:28 test kernel: EIP is at contains_sector+0x40/0x48 [dm_loop]
Feb 12 13:21:28 test kernel: eax: 00000000   ebx: 00000000   ecx: 00000000 
edx: 009c3ff8
Feb 12 13:21:28 test kernel: esi: 009c3ff8   edi: 00000000   ebp: f1c46260 
esp: c917fbbc
Feb 12 13:21:28 test kernel: ds: 007b   es: 007b   ss: 0068
Feb 12 13:21:28 test kernel: Process mkfs.reiserfs (pid: 9718, ti=c917e000 
task=e16da550 task.ti=c917e000)
Feb 12 13:21:28 test kernel: Stack: dead83f0 f88d70c1 f1735378 f88d710e 
00001000 00000001 00000000 d9f02680
Feb 12 13:21:28 test kernel:        f8c0f080 009c3ff8 00000000 ef6006c0 
f1c4626c d9f02680 c016e761 f8c0f080
Feb 12 13:21:28 test kernel:        f88d70c1 f1735378 f8c0f080 f88d706b 
f487f9c0 d9f02680 c0399f1a 009c3ff8
Feb 12 13:21:28 test kernel: Call Trace:
Feb 12 13:21:28 test kernel:  [<f88d70c1>] loop_block_map+0x0/0x180 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<f88d710e>] loop_block_map+0x4d/0x180 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<c016e761>] __bio_clone+0x6f/0x8a
Feb 12 13:21:28 test kernel:  [<f88d70c1>] loop_block_map+0x0/0x180 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<f88d706b>] loop_map+0x27/0x35 [dm_loop]
Feb 12 13:21:28 test kernel:  [<c0399f1a>] __map_bio+0x34/0x99
Feb 12 13:21:28 test kernel:  [<c039a783>] __split_bio+0x173/0x41f
Feb 12 13:21:28 test kernel:  [<c014e7fe>] cache_alloc_refill+0x5b/0x488
Feb 12 13:21:28 test kernel:  [<c02179a3>] submit_bio+0xc0/0xc7
Feb 12 13:21:28 test kernel:  [<c039b113>] dm_request+0xc7/0xd4
Feb 12 13:21:28 test kernel:  [<c02159b9>] generic_make_request+0x1ae/0x1be
Feb 12 13:21:28 test kernel:  [<c016ddf8>] bio_put+0x23/0x24
Feb 12 13:21:28 test kernel:  [<c016b0cd>] submit_bh+0xe9/0xf6
Feb 12 13:21:28 test kernel:  [<c016fa14>] blkdev_get_block+0x0/0x43
Feb 12 13:21:28 test kernel:  [<c02179a3>] submit_bio+0xc0/0xc7
Feb 12 13:21:28 test kernel:  [<c01398b5>] mempool_alloc+0x28/0xc6
Feb 12 13:21:28 test kernel:  [<c013d079>] __pagevec_lru_add+0x85/0x90
Feb 12 13:21:28 test kernel:  [<c016dea9>] bio_alloc_bioset+0x9b/0xf3
Feb 12 13:21:28 test kernel:  [<c016b0bc>] submit_bh+0xd8/0xf6
Feb 12 13:21:28 test kernel:  [<c016d686>] block_read_full_page+0x2c8/0x2d9
Feb 12 13:21:28 test kernel:  [<c016fa14>] blkdev_get_block+0x0/0x43
Feb 12 13:21:28 test kernel:  [<c013cb63>] page_cache_readahead+0x12b/0x196
Feb 12 13:21:28 test kernel:  [<c01378bf>] 
do_generic_mapping_read+0x209/0x43b
Feb 12 13:21:28 test kernel:  [<c013971b>] generic_file_aio_read+0x19d/0x1ce
Feb 12 13:21:28 test kernel:  [<c0136fb8>] file_read_actor+0x0/0xd1
Feb 12 13:21:28 test kernel:  [<c0151353>] do_sync_read+0xc7/0x10a
Feb 12 13:21:28 test kernel:  [<c012b2ef>] remove_wait_queue+0xc/0x34
Feb 12 13:21:28 test kernel:  [<c012b199>] autoremove_wake_function+0x0/0x35
Feb 12 13:21:28 test kernel:  [<c026a12a>] tty_ldisc_deref+0x55/0x64
Feb 12 13:21:28 test kernel:  [<c0439389>] mutex_lock+0xb/0x1a
Feb 12 13:21:28 test kernel:  [<c016ed55>] block_llseek+0xad/0xb9
Feb 12 13:21:28 test kernel:  [<c015128c>] do_sync_read+0x0/0x10a
Feb 12 13:21:28 test kernel:  [<c0151b3b>] vfs_read+0x88/0x134
Feb 12 13:21:28 test kernel:  [<c0151f8f>] sys_read+0x41/0x67
Feb 12 13:21:28 test kernel:  [<c0103520>] sysenter_past_esp+0x5d/0x81
Feb 12 13:21:28 test kernel:  [<c0430033>] svc_create_pooled+0x2f/0xf1
Feb 12 13:21:28 test kernel:  =======================
Feb 12 13:21:28 test kernel: Code: 8b 5b 14 01 c1 11 d3 39 df 72 0a 77 04 39 
ce 72 04 31 c0 eb 1a 39 d7 b1 01 72 08 77 04 39 c6 72 02 31 c9 83 f1 01 0f 
b6 c1 eb 04 <0f> 0b eb fe 5b 5e 5f c3 55 89 d1 57 56 53 83 ec 2c 89 44 24 10
Feb 12 13:21:28 test kernel: EIP: [<f88d70b9>] contains_sector+0x40/0x48 
[dm_loop] SS:ESP 0068:c917fbbc
Feb 12 13:21:28 test kernel:  <0>------------[ cut here ]------------
Feb 12 13:21:28 test kernel: kernel BUG at drivers/md/dm-loop.c:260!
Feb 12 13:21:28 test kernel: invalid opcode: 0000 [#2]
Feb 12 13:21:28 test kernel: SMP
Feb 12 13:21:28 test kernel: Modules linked in: dm_loop
Feb 12 13:21:28 test kernel: CPU:    0
Feb 12 13:21:28 test kernel: EIP:    0060:[<f88d70b9>]    Not tainted VLI
Feb 12 13:21:28 test kernel: EFLAGS: 00010246   (2.6.20 #6)
Feb 12 13:21:28 test kernel: EIP is at contains_sector+0x40/0x48 [dm_loop]
Feb 12 13:21:28 test kernel: eax: 00000000   ebx: 00000000   ecx: 00000000 
edx: 00000000
Feb 12 13:21:28 test kernel: esi: 00000000   edi: 00000000   ebp: f1c46260 
esp: c917f6b0
Feb 12 13:21:28 test kernel: ds: 007b   es: 007b   ss: 0068
Feb 12 13:21:28 test kernel: Process mkfs.reiserfs (pid: 9718, ti=c917e000 
task=e16da550 task.ti=c917e000)
Feb 12 13:21:28 test kernel: Stack: dead83f0 f88d70c1 e39f1a88 f88d710e 
00001000 00000001 00000000 df62b880
Feb 12 13:21:28 test kernel:        f8c0f080 00000000 00000000 ef6006c0 
f1c4626c df62b880 c016e761 f8c0f080
Feb 12 13:21:28 test kernel:        f88d70c1 e39f1a88 f8c0f080 f88d706b 
f487f9c0 df62b880 c0399f1a 00000000
Feb 12 13:21:28 test kernel: Call Trace:
Feb 12 13:21:28 test kernel:  [<f88d70c1>] loop_block_map+0x0/0x180 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<f88d710e>] loop_block_map+0x4d/0x180 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<c016e761>] __bio_clone+0x6f/0x8a
Feb 12 13:21:28 test kernel:  [<f88d70c1>] loop_block_map+0x0/0x180 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<f88d706b>] loop_map+0x27/0x35 [dm_loop]
Feb 12 13:21:28 test kernel:  [<c0399f1a>] __map_bio+0x34/0x99
Feb 12 13:21:28 test kernel:  [<c039a783>] __split_bio+0x173/0x41f
Feb 12 13:21:28 test kernel:  [<c0222c22>] memmove+0xe/0x22
Feb 12 13:21:28 test kernel:  [<c02788cb>] vt_console_print+0x20f/0x220
Feb 12 13:21:28 test kernel:  [<c039b113>] dm_request+0xc7/0xd4
Feb 12 13:21:28 test kernel:  [<c02159b9>] generic_make_request+0x1ae/0x1be
Feb 12 13:21:28 test kernel:  [<c02786bc>] vt_console_print+0x0/0x220
Feb 12 13:21:28 test kernel:  [<c011b22b>] __call_console_drivers+0x4f/0x5b
Feb 12 13:21:28 test kernel:  [<c02179a3>] submit_bio+0xc0/0xc7
Feb 12 13:21:28 test kernel:  [<c01398b5>] mempool_alloc+0x28/0xc6
Feb 12 13:21:28 test kernel:  [<c016dea9>] bio_alloc_bioset+0x9b/0xf3
Feb 12 13:21:28 test kernel:  [<c016b0bc>] submit_bh+0xd8/0xf6
Feb 12 13:21:28 test kernel:  [<c016c4a2>] 
__block_write_full_page+0x215/0x308
Feb 12 13:21:28 test kernel:  [<c016fa14>] blkdev_get_block+0x0/0x43
Feb 12 13:21:28 test kernel:  [<c016c802>] block_write_full_page+0xce/0xd6
Feb 12 13:21:28 test kernel:  [<c016fa14>] blkdev_get_block+0x0/0x43
Feb 12 13:21:28 test kernel:  [<c013bc3f>] generic_writepages+0x17d/0x2aa
Feb 12 13:21:28 test kernel:  [<c016eea8>] blkdev_writepage+0x0/0xc
Feb 12 13:21:28 test kernel:  [<c013bac2>] generic_writepages+0x0/0x2aa
Feb 12 13:21:28 test kernel:  [<c013bd8c>] do_writepages+0x20/0x30
Feb 12 13:21:28 test kernel:  [<c0137df7>] 
__filemap_fdatawrite_range+0x65/0x71
Feb 12 13:21:28 test kernel:  [<c0138026>] filemap_fdatawrite+0x23/0x27
Feb 12 13:21:28 test kernel:  [<c013803b>] filemap_write_and_wait+0x11/0x29
Feb 12 13:21:28 test kernel:  [<c016f269>] __blkdev_put+0x3d/0x103
Feb 12 13:21:28 test kernel:  [<c0152281>] __fput+0xa5/0x14d
Feb 12 13:21:28 test kernel:  [<c014fed6>] filp_close+0x51/0x58
Feb 12 13:21:28 test kernel:  [<c011caa7>] put_files_struct+0x5f/0xa2
Feb 12 13:21:28 test kernel:  [<c011da3b>] do_exit+0x1dc/0x69b
Feb 12 13:21:28 test kernel:  [<c011007b>] __modify_IO_APIC_irq+0x4a/0x5a
Feb 12 13:21:28 test kernel:  [<c0104990>] die+0x1f1/0x216
Feb 12 13:21:28 test kernel:  [<c0104d9d>] do_invalid_op+0x0/0xab
Feb 12 13:21:28 test kernel:  [<c0104e3f>] do_invalid_op+0xa2/0xab
Feb 12 13:21:28 test kernel:  [<f88d70b9>] contains_sector+0x40/0x48 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<c011bb3e>] printk+0x1b/0x1f
Feb 12 13:21:28 test kernel:  [<c011bba8>] __printk_ratelimit+0x66/0xa0
Feb 12 13:21:28 test kernel:  [<c016c688>] end_bio_bh_io_sync+0x35/0x39
Feb 12 13:21:28 test kernel:  [<c016dfaa>] bio_endio+0x5b/0x63
Feb 12 13:21:28 test kernel:  [<c043a1ec>] error_code+0x7c/0x84
Feb 12 13:21:28 test kernel:  [<c03900d8>] ps2_handle_response+0xe/0x6f
Feb 12 13:21:28 test kernel:  [<f88d70b9>] contains_sector+0x40/0x48 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<f88d70c1>] loop_block_map+0x0/0x180 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<f88d710e>] loop_block_map+0x4d/0x180 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<c016e761>] __bio_clone+0x6f/0x8a
Feb 12 13:21:28 test kernel:  [<f88d70c1>] loop_block_map+0x0/0x180 
[dm_loop]
Feb 12 13:21:28 test kernel:  [<f88d706b>] loop_map+0x27/0x35 [dm_loop]
Feb 12 13:21:28 test kernel:  [<c0399f1a>] __map_bio+0x34/0x99
Feb 12 13:21:28 test kernel:  [<c039a783>] __split_bio+0x173/0x41f
Feb 12 13:21:28 test kernel:  [<c014e7fe>] cache_alloc_refill+0x5b/0x488
Feb 12 13:21:28 test kernel:  [<c02179a3>] submit_bio+0xc0/0xc7
Feb 12 13:21:28 test kernel:  [<c039b113>] dm_request+0xc7/0xd4
Feb 12 13:21:28 test kernel:  [<c02159b9>] generic_make_request+0x1ae/0x1be
Feb 12 13:21:28 test kernel:  [<c016ddf8>] bio_put+0x23/0x24
Feb 12 13:21:28 test kernel:  [<c016b0cd>] submit_bh+0xe9/0xf6
Feb 12 13:21:28 test kernel:  [<c016fa14>] blkdev_get_block+0x0/0x43
Feb 12 13:21:28 test kernel:  [<c02179a3>] submit_bio+0xc0/0xc7
Feb 12 13:21:28 test kernel:  [<c01398b5>] mempool_alloc+0x28/0xc6
Feb 12 13:21:28 test kernel:  [<c013d079>] __pagevec_lru_add+0x85/0x90
Feb 12 13:21:28 test kernel:  [<c016dea9>] bio_alloc_bioset+0x9b/0xf3
Feb 12 13:21:28 test kernel:  [<c016b0bc>] submit_bh+0xd8/0xf6
Feb 12 13:21:28 test kernel:  [<c016d686>] block_read_full_page+0x2c8/0x2d9
Feb 12 13:21:28 test kernel:  [<c016fa14>] blkdev_get_block+0x0/0x43
Feb 12 13:21:28 test kernel:  [<c013cb63>] page_cache_readahead+0x12b/0x196
Feb 12 13:21:28 test kernel:  [<c01378bf>] 
do_generic_mapping_read+0x209/0x43b
Feb 12 13:21:28 test kernel:  [<c013971b>] generic_file_aio_read+0x19d/0x1ce
Feb 12 13:21:28 test kernel:  [<c0136fb8>] file_read_actor+0x0/0xd1
Feb 12 13:21:28 test kernel:  [<c0151353>] do_sync_read+0xc7/0x10a
Feb 12 13:21:28 test kernel:  [<c012b2ef>] remove_wait_queue+0xc/0x34
Feb 12 13:21:28 test kernel:  [<c012b199>] autoremove_wake_function+0x0/0x35
Feb 12 13:21:28 test kernel:  [<c026a12a>] tty_ldisc_deref+0x55/0x64
Feb 12 13:21:28 test kernel:  [<c0439389>] mutex_lock+0xb/0x1a
Feb 12 13:21:28 test kernel:  [<c016ed55>] block_llseek+0xad/0xb9
Feb 12 13:21:28 test kernel:  [<c015128c>] do_sync_read+0x0/0x10a
Feb 12 13:21:28 test kernel:  [<c0151b3b>] vfs_read+0x88/0x134
Feb 12 13:21:28 test kernel:  [<c0151f8f>] sys_read+0x41/0x67
Feb 12 13:21:28 test kernel:  [<c0103520>] sysenter_past_esp+0x5d/0x81
Feb 12 13:21:28 test kernel:  [<c0430033>] svc_create_pooled+0x2f/0xf1
Feb 12 13:21:28 test kernel:  =======================
Feb 12 13:21:28 test kernel: Code: 8b 5b 14 01 c1 11 d3 39 df 72 0a 77 04 39 
ce 72 04 31 c0 eb 1a 39 d7 b1 01 72 08 77 04 39 c6 72 02 31 c9 83 f1 01 0f 
b6 c1 eb 04 <0f> 0b eb fe 5b 5e 5f c3 55 89 d1 57 56 53 83 ec 2c 89 44 24 10
Feb 12 13:21:28 test kernel: EIP: [<f88d70b9>] contains_sector+0x40/0x48 
[dm_loop] SS:ESP 0068:c917f6b0
Feb 12 13:21:28 test kernel:  <1>Fixing recursive fault but reboot is 
needed!
Feb 12 13:22:02 test kernel: ------------[ cut here ]------------
Feb 12 13:22:02 test kernel: kernel BUG at drivers/md/dm-loop.c:260!
Feb 12 13:22:02 test kernel: invalid opcode: 0000 [#3]
Feb 12 13:22:02 test kernel: SMP
Feb 12 13:22:02 test kernel: Modules linked in: dm_loop
Feb 12 13:22:02 test kernel: CPU:    0
Feb 12 13:22:02 test kernel: EIP:    0060:[<f88d70b9>]    Not tainted VLI
Feb 12 13:22:02 test kernel: EFLAGS: 00010246   (2.6.20 #6)
Feb 12 13:22:02 test kernel: EIP is at contains_sector+0x40/0x48 [dm_loop]
Feb 12 13:22:02 test kernel: eax: 00000000   ebx: 00000000   ecx: 00000000 
edx: 00000008
Feb 12 13:22:02 test kernel: esi: 00000008   edi: 00000000   ebp: f1c46260 
esp: ef9e5be8
Feb 12 13:22:02 test kernel: ds: 007b   es: 007b   ss: 0068
Feb 12 13:22:02 test kernel: Process pdflush (pid: 20365, ti=ef9e4000 
task=f494ca70 task.ti=ef9e4000)
Feb 12 13:22:02 test kernel: Stack: dead83f0 f88d70c1 f3485b78 f88d710e 
00001000 00000001 00000000 c2a4a100
Feb 12 13:22:02 test kernel:        f8c0f080 00000008 00000000 ef6006c0 
f1c4626c c2a4a100 c016e761 f8c0f080
Feb 12 13:22:02 test kernel:        f88d70c1 f3485b78 f8c0f080 f88d706b 
f487f9c0 c2a4a100 c0399f1a 00000008
Feb 12 13:22:02 test kernel: Call Trace:
Feb 12 13:22:02 test kernel:  [<f88d70c1>] loop_block_map+0x0/0x180 
[dm_loop]
Feb 12 13:22:02 test kernel:  [<f88d710e>] loop_block_map+0x4d/0x180 
[dm_loop]
Feb 12 13:22:02 test kernel:  [<c016e761>] __bio_clone+0x6f/0x8a
Feb 12 13:22:02 test kernel:  [<f88d70c1>] loop_block_map+0x0/0x180 
[dm_loop]
Feb 12 13:22:02 test kernel:  [<f88d706b>] loop_map+0x27/0x35 [dm_loop]
Feb 12 13:22:02 test kernel:  [<c0399f1a>] __map_bio+0x34/0x99
Feb 12 13:22:02 test kernel:  [<c039a783>] __split_bio+0x173/0x41f
Feb 12 13:22:02 test kernel:  [<f88d706b>] loop_map+0x27/0x35 [dm_loop]
Feb 12 13:22:02 test kernel:  [<c0399f1a>] __map_bio+0x34/0x99
Feb 12 13:22:02 test kernel:  [<c039b113>] dm_request+0xc7/0xd4
Feb 12 13:22:02 test kernel:  [<c02159b9>] generic_make_request+0x1ae/0x1be
Feb 12 13:22:02 test kernel:  [<c02179a3>] submit_bio+0xc0/0xc7
Feb 12 13:22:02 test kernel:  [<c01398b5>] mempool_alloc+0x28/0xc6
Feb 12 13:22:02 test kernel:  [<c016dea9>] bio_alloc_bioset+0x9b/0xf3
Feb 12 13:22:02 test kernel:  [<c016b0bc>] submit_bh+0xd8/0xf6
Feb 12 13:22:02 test kernel:  [<c016c4a2>] 
__block_write_full_page+0x215/0x308
Feb 12 13:22:02 test kernel:  [<c016fa14>] blkdev_get_block+0x0/0x43
Feb 12 13:22:02 test kernel:  [<c016c802>] block_write_full_page+0xce/0xd6
Feb 12 13:22:02 test kernel:  [<c016fa14>] blkdev_get_block+0x0/0x43
Feb 12 13:22:02 test kernel:  [<c013bc3f>] generic_writepages+0x17d/0x2aa
Feb 12 13:22:02 test kernel:  [<c016eea8>] blkdev_writepage+0x0/0xc
Feb 12 13:22:02 test kernel:  [<c013bac2>] generic_writepages+0x0/0x2aa
Feb 12 13:22:02 test kernel:  [<c013bd8c>] do_writepages+0x20/0x30
Feb 12 13:22:02 test kernel:  [<c0167e97>] 
__writeback_single_inode+0x1ae/0x31e
Feb 12 13:22:02 test kernel:  [<c01682e3>] sync_sb_inodes+0x169/0x212
Feb 12 13:22:02 test kernel:  [<c01686c3>] writeback_inodes+0x63/0xa4
Feb 12 13:22:02 test kernel:  [<c013c1f0>] wb_kupdate+0x94/0xf8
Feb 12 13:22:02 test kernel:  [<c013c4aa>] pdflush+0x0/0x19d
Feb 12 13:22:02 test kernel:  [<c013c5b3>] pdflush+0x109/0x19d
Feb 12 13:22:02 test kernel:  [<c013c15c>] wb_kupdate+0x0/0xf8
Feb 12 13:22:02 test kernel:  [<c012b0d0>] kthread+0xb0/0xd8
Feb 12 13:22:02 test kernel:  [<c012b020>] kthread+0x0/0xd8
Feb 12 13:22:02 test kernel:  [<c010416f>] kernel_thread_helper+0x7/0x10
Feb 12 13:22:02 test kernel:  =======================
Feb 12 13:22:02 test kernel: Code: 8b 5b 14 01 c1 11 d3 39 df 72 0a 77 04 39 
ce 72 04 31 c0 eb 1a 39 d7 b1 01 72 08 77 04 39 c6 72 02 31 c9 83 f1 01 0f 
b6 c1 eb 04 <0f> 0b eb fe 5b 5e 5f c3 55 89 d1 57 56 53 83 ec 2c 89 44 24 10
Feb 12 13:22:02 test kernel: EIP: [<f88d70b9>] contains_sector+0x40/0x48 
[dm_loop] SS:ESP 0068:ef9e5be8
Feb 12 13:24:48 test kernel:  <0>------------[ cut here ]------------
Feb 12 13:24:48 test kernel: kernel BUG at drivers/md/dm-loop.c:260!
Feb 12 13:24:48 test kernel: invalid opcode: 0000 [#4]
Feb 12 13:24:48 test kernel: SMP
Feb 12 13:24:48 test kernel: Modules linked in: dm_loop
--snipp---
(i can provide more of the log on request)
