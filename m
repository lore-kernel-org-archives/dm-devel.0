From: Michael Heyse <m.heyse@designassembly.de>
Subject: Maximum table size / oom
Date: Wed, 21 Nov 2007 03:42:39 +0100
Message-ID: <47439B1F.5070201@designassembly.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Is there a maximum table size for the device mapper? Or put in other
words, what is the relation between table size and memory usage? It
probably depends on the target, but is there an estimate for the linear
and the crypt targets? And what's the performance impact of having big
tables?

I tried to set up a device with a lot (about 3000) crypt targets, and
this was obviously way too much as the oom-killer kicked in.

Please cc me on your reply as I am not subscribed.

Thanks,
Michael


dmesg output:

dmsetup invoked oom-killer: gfp_mask=0xd0, order=1, oomkilladj=0
 [<c013cdbc>] out_of_memory+0x69/0x189
 [<c013e24f>] __alloc_pages+0x203/0x28d
 [<c0140e8a>] wakeup_kswapd+0x2d/0x70
 [<c0151dee>] cache_alloc_refill+0x27d/0x47f
 [<c0151b67>] kmem_cache_alloc+0x3d/0x47
 [<c013c859>] mempool_create_node+0x96/0xb4
 [<c013c687>] mempool_free_slab+0x0/0xb
 [<c013c671>] mempool_alloc_slab+0x0/0xb
 [<c013c88f>] mempool_create+0x18/0x1c
 [<c017119a>] bioset_create+0x65/0x8a
 [<c031d9f1>] crypt_ctr+0x3a2/0x5db
 [<c0318fd3>] dm_split_args+0x39/0xc8
 [<c03197d3>] dm_table_add_target+0x149/0x270
 [<c031adf4>] table_load+0xf0/0x1ab
 [<c031b887>] ctl_ioctl+0x212/0x257
 [<c031ad04>] table_load+0x0/0x1ab
 [<c031b675>] ctl_ioctl+0x0/0x257
 [<c031b675>] ctl_ioctl+0x0/0x257
 [<c015dfcf>] do_ioctl+0x87/0x9f
 [<c015e21e>] vfs_ioctl+0x237/0x249
 [<c015e263>] sys_ioctl+0x33/0x4c
 [<c01024ba>] sysenter_past_esp+0x5f/0x85
 [<c0380000>] xs_sendpages+0x13/0x1c0
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  29   Cold: hi:   62, btch:  15
usd:  45
CPU    1: Hot: hi:  186, btch:  31 usd:  92   Cold: hi:   62, btch:  15
usd:  54
HighMem per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15
usd:  10
CPU    1: Hot: hi:  186, btch:  31 usd: 171   Cold: hi:   62, btch:  15
usd:   3
Active:3672 inactive:89 dirty:10 writeback:0 unstable:0
 free:284215 slab:128693 mapped:770 pagetables:57 bounce:0
DMA free:3548kB min:68kB low:84kB high:100kB active:0kB inactive:0kB
present:16256kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 873 1989
Normal free:3736kB min:3744kB low:4680kB high:5616kB active:28kB
inactive:0kB present:894080kB pages_scanned:72 all_unreclaimable? yes
lowmem_reserve[]: 0 0 8929
HighMem free:1129576kB min:512kB low:1708kB high:2904kB active:14660kB
inactive:420kB present:1143000kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 1*4kB 1*8kB 1*16kB 0*32kB 1*64kB 1*128kB 1*256kB 4*512kB 1*1024kB
0*2048kB 0*4096kB = 3548kB
Normal: 31*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB
1*1024kB 1*2048kB 0*4096kB = 3692kB
HighMem: 0*4kB 1*8kB 404*16kB 284*32kB 215*64kB 178*128kB 137*256kB
104*512kB 70*1024kB 28*2048kB 210*4096kB = 1129608kB
Swap cache: add 45, delete 1, find 0/1, race 0+0
Free swap  = 5879584kB
Total swap = 5879760kB
Free swap:       5879584kB
517376 pages of RAM
288000 pages of HIGHMEM
5732 reserved pages
3896 pages shared
44 pages swap cached
10 pages dirty
0 pages writeback
770 pages mapped
128693 pages slab
57 pages pagetables
Out of memory: kill process 19418 (iamap.sh) score 107 or a child
Killed process 19423 (dmsetup)
dmsetup: page allocation failure. order:0, mode:0xd0
 [<c013e2c8>] __alloc_pages+0x27c/0x28d
 [<c013c859>] mempool_create_node+0x96/0xb4
 [<c013c5bc>] mempool_free_pages+0x0/0x5
 [<c013c5f6>] mempool_alloc_pages+0x0/0x31
 [<c013c88f>] mempool_create+0x18/0x1c
 [<c031d4cb>] crypt_iv_benbi_ctr+0x0/0x52
 [<c031d9c7>] crypt_ctr+0x378/0x5db
 [<c0318fd3>] dm_split_args+0x39/0xc8
 [<c03197d3>] dm_table_add_target+0x149/0x270
 [<c031adf4>] table_load+0xf0/0x1ab
 [<c031b887>] ctl_ioctl+0x212/0x257
 [<c031ad04>] table_load+0x0/0x1ab
 [<c031b675>] ctl_ioctl+0x0/0x257
 [<c031b675>] ctl_ioctl+0x0/0x257
 [<c015dfcf>] do_ioctl+0x87/0x9f
 [<c015e21e>] vfs_ioctl+0x237/0x249
 [<c015e263>] sys_ioctl+0x33/0x4c
 [<c01024ba>] sysenter_past_esp+0x5f/0x85
 [<c0380000>] xs_sendpages+0x13/0x1c0
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  29   Cold: hi:   62, btch:  15
usd:  45
CPU    1: Hot: hi:  186, btch:  31 usd:   0   Cold: hi:   62, btch:  15
usd:  54
HighMem per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:   1   Cold: hi:   62, btch:  15
usd:  10
CPU    1: Hot: hi:  186, btch:  31 usd: 171   Cold: hi:   62, btch:  15
usd:   3
Active:3673 inactive:109 dirty:10 writeback:0 unstable:0
 free:282421 slab:129796 mapped:770 pagetables:57 bounce:0
DMA free:12kB min:68kB low:84kB high:100kB active:0kB inactive:0kB
present:16256kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 873 1989
Normal free:96kB min:3744kB low:4680kB high:5616kB active:32kB
inactive:16kB present:894080kB pages_scanned:954 all_unreclaimable? yes
lowmem_reserve[]: 0 0 8929
HighMem free:1129576kB min:512kB low:1708kB high:2904kB active:14660kB
inactive:420kB present:1143000kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB
0*2048kB 0*4096kB = 0kB
Normal: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 0kB
HighMem: 0*4kB 1*8kB 404*16kB 284*32kB 215*64kB 178*128kB 137*256kB
104*512kB 70*1024kB 28*2048kB 210*4096kB = 1129608kB
Swap cache: add 45, delete 1, find 0/1, race 0+0
Free swap  = 5879584kB
Total swap = 5879760kB
Free swap:       5879584kB
517376 pages of RAM
288000 pages of HIGHMEM
5732 reserved pages
3896 pages shared
44 pages swap cached
10 pages dirty
0 pages writeback
770 pages mapped
129796 pages slab
57 pages pagetables
device-mapper: table: 253:1: crypt: Cannot allocate page mempool
device-mapper: ioctl: error adding target to table
