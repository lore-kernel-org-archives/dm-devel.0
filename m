From: Alexander Nyberg <alexn@dsv.su.se>
Subject: possible dm-crypt leak over loop
Date: Sun, 06 Mar 2005 23:22:18 +0100
Message-ID: <1110147738.2266.26.camel@boxen>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Hi

I think this is more related to dm-crypt and not to loop. However - this
only seems to happen when dm-crypt is on top of loop, something I cannot
explain, how do they differ?. Sysrq-t trace at the bottom. My belief
after looking at this is that dm-crypt leaks memory somewhere but I
couldn't get around the dm code so here it is. This is 2.6.11, but this
bug has been present forever (easier to trigger now though).

=================================================

Testcase:
#!/bin/sh
losetup /dev/loop7 loopbackfile
echo 0 `blockdev --getsize /dev/loop7` crypt aes-plain 0123456789abcdef0123456789abcdef 0 /dev/loop7 0 | dmsetup create volume1
mkfs.ext3 /dev/mapper/volume1
mount /dev/mapper/volume1 mnt
cd mnt
dbench 20

=================================================

SysRq : Show Memory
Mem-info:
DMA per-cpu:
cpu 0 hot: low 2, high 6, batch 1
cpu 0 cold: low 0, high 2, batch 1
Normal per-cpu:
cpu 0 hot: low 12, high 36, batch 6
cpu 0 cold: low 0, high 12, batch 6
HighMem per-cpu: empty

Free pages:        1424kB (0kB HighMem)
Active:1311 inactive:6306 dirty:4720 writeback:1964 unstable:0 free:356 slab:6724 mapped:1095 pagetables:110
DMA free:552kB min:184kB low:228kB high:276kB active:32kB inactive:3916kB present:16384kB pages_scanned:1490985 all_unreclaimable? no
lowmem_reserve[]: 0 103 103
Normal free:872kB min:1212kB low:1512kB high:1816kB active:5212kB inactive:21308kB present:106432kB pages_scanned:9324481 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
HighMem free:0kB min:128kB low:160kB high:192kB active:0kB inactive:0kB present:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 0*4kB 1*8kB 0*16kB 1*32kB 0*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 552kB
Normal: 0*4kB 1*8kB 0*16kB 1*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 872kB
HighMem: empty
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 0kB
Total swap = 0kB
Free swap:            0kB
30704 pages of RAM
0 pages of HIGHMEM
1154 reserved pages
7475 pages shared
0 pages swap cached

=================================================

  task             PC      pid father child younger older
init          D 00000000     0     1      0     2               (NOTLB)
c77ae9b0 00000086 00000282 00000000 00000001 00000001 00000282 ffffffff
       0000023a 24064d98 00000015 c77adb10 c77adc60 c64c9e8c 00000052 c64c9ea4
       c77ae9b8 c024655e c77aea10 c012cb48 00000002 00000000 c77adb10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014720c>] __block_write_full_page+0x12c/0x2c0
 [<c014863b>] block_write_full_page+0xab/0xb0
 [<c0176cb8>] ext3_ordered_writepage+0xb8/0x190
 [<c0133ea6>] pageout+0x96/0xe0
 [<c01340c0>] shrink_list+0x1d0/0x3b0
 [<c01343e4>] shrink_cache+0x144/0x2c0
 [<c0134a2a>] shrink_zone+0xba/0xe0
 [<c0134ab3>] shrink_caches+0x63/0x70
 [<c0134b68>] try_to_free_pages+0xa8/0x150
 [<c012dc64>] __alloc_pages+0x164/0x3e0
 [<c012df02>] __get_free_pages+0x22/0x50
 [<c0154769>] __pollwait+0x79/0xc0
 [<c014f1f2>] pipe_poll+0x32/0xb0
 [<c0154a7e>] do_select+0x1ee/0x240
 [<c0154d85>] sys_select+0x285/0x460
 [<c0102167>] syscall_call+0x7/0xb
ksoftirqd/0   S C77B2FC8     0     2      1             3       (L-TLB)
c77b2fbc 00000046 c77b1b10 c77b2fc8 c0245d73 c77b2fb4 c0113447 00000011
       00000188 26314673 00000013 c77b1b10 c77b1c60 c77b2000 c77aef84 00000000
       c77b2fc8 c011a473 c77b2000 c77b2fec c0126705 fffffffc c011a400 ffffffff
Call Trace:
 [<c011a473>] ksoftirqd+0x73/0x90
 [<c0126705>] kthread+0x95/0xa0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
events/0      R running     0     3      1             4     2 (L-TLB)
khelper       S 00010000     0     4      1             5     3 (L-TLB)
c124bf4c 00000046 5a5a5a5a 00010000 00010000 c124ab10 c124b000 c124bf4c
       00001b99 b5d33840 00000004 c124ab10 c124ac60 c124bf9c c1243f78 c1243f88
       c124bfc8 c012332c b5af1834 c124bf70 c0112a0a c031f2e0 00000000 c77adb10
Call Trace:
 [<c012332c>] worker_thread+0x1bc/0x1e0
 [<c0126705>] kthread+0x95/0xa0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
kthread       S C0113447     0     5      1     6       9     4 (L-TLB)
c12bff4c 00000046 c12bff38 c0113447 c12bcf90 00000001 00000003 00000000
       000000ce 03b9241e 00000008 c12beb10 c12bec60 c12bff9c c12bcf78 c12bcf88
       c12bffc8 c012332c 00000000 c12bff70 c0112a0a c12bcf90 c77aef20 c0126710
Call Trace:
 [<c012332c>] worker_thread+0x1bc/0x1e0
 [<c0126705>] kthread+0x95/0xa0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
kblockd/0     S FFFFFFFF     0     6      5             7       (L-TLB)
c7475f4c 00000046 c01bab7a ffffffff c7473f90 00000001 00000003 00000000
       00001376 24256763 00000015 c7474b10 c7474c60 c7475f9c c7473f78 c7473f88
       c7475fc8 c012332c 00000000 c7475f70 c0112a0a c7473f90 c721ee90 c01bca40
Call Trace:
 [<c012332c>] worker_thread+0x1bc/0x1e0
 [<c0126705>] kthread+0x95/0xa0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
pdflush       D 00000003     0     7      5             8     6 (L-TLB)
c7508e90 00000046 c48d6fe0 00000003 00000000 c7508e88 c0161dae 00000000
       000007da db6c58c4 00000015 c7507b10 c7507c60 fffc9823 c7508ea4 c7508efc
       c7508ecc c024665b c7508f4c c7508edc c0245d73 c0330a40 c5c50dec fffc9823
Call Trace:
 [<c024665b>] schedule_timeout+0x5b/0xb0
 [<c024657e>] io_schedule_timeout+0xe/0x50
 [<c01bd7ab>] blk_congestion_wait+0x6b/0x80
 [<c012edfa>] background_writeout+0x7a/0xa0
 [<c012f6cd>] __pdflush+0x8d/0x140
 [<c012f79e>] pdflush+0x1e/0x20
 [<c0126705>] kthread+0x95/0xa0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
pdflush       D 00000000     0     8      5            10     7 (L-TLB)
c750cad4 00000046 00000200 00000000 00000001 00000001 00000282 ffffffff
       0008cb50 2403e63c 00000015 c750bb10 c750bc60 c64c9e8c 00000052 c64c9ea4
       c750cadc c024655e c750cb34 c012cb48 00000002 00000000 c750bb10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014720c>] __block_write_full_page+0x12c/0x2c0
 [<c014863b>] block_write_full_page+0xab/0xb0
 [<c0176cb8>] ext3_ordered_writepage+0xb8/0x190
 [<c01633af>] mpage_writepages+0x1ff/0x310
 [<c0161d42>] __sync_single_inode+0x52/0x1e0
 [<c0161f39>] __writeback_single_inode+0x69/0x130
 [<c01621a1>] sync_sb_inodes+0x1a1/0x280
 [<c0162309>] writeback_inodes+0x89/0x90
 [<c012eddd>] background_writeout+0x5d/0xa0
 [<c012f6cd>] __pdflush+0x8d/0x140
 [<c012f79e>] pdflush+0x1e/0x20
 [<c0126705>] kthread+0x95/0xa0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
aio/0         S 00010000     0    10      5            12     8 (L-TLB)
c751cf4c 00000046 5a5a5a5a 00010000 00010000 c751bb10 c751c000 c751cf4c
       00001e80 b97b4859 00000004 c751bb10 c751bc60 c751cf9c c751af78 c751af88
       c751cfc8 c012332c b92a737c c751cf70 c0112a0a c031f2e0 00000000 c12beb10
Call Trace:
 [<c012332c>] worker_thread+0x1bc/0x1e0
 [<c0126705>] kthread+0x95/0xa0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
kswapd0       D C7508FA8     0     9      1            11     5 (L-TLB)
c7510ae8 00000046 00000282 c7508fa8 c012ed80 c7510ad8 24344d55 00000015
       0000871e 24345036 00000015 c750fb10 c750fc60 c64c9e8c 00000052 c64c9ea4
       c7510af0 c024655e c7510b48 c012cb48 00000002 00000000 c750fb10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014720c>] __block_write_full_page+0x12c/0x2c0
 [<c014863b>] block_write_full_page+0xab/0xb0
 [<c0176cb8>] ext3_ordered_writepage+0xb8/0x190
 [<c0133ea6>] pageout+0x96/0xe0
 [<c01340c0>] shrink_list+0x1d0/0x3b0
 [<c01343e4>] shrink_cache+0x144/0x2c0
 [<c0134a2a>] shrink_zone+0xba/0xe0
 [<c0134e50>] balance_pgdat+0x240/0x310
 [<c0134fee>] kswapd+0xce/0xe0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
kseriod       S C703CF7C     0    11      1            13     9 (L-TLB)
c703cf94 00000046 00000000 c703cf7c c703c000 00000000 b9638990 00000004
       00003a60 b97b8fa4 00000004 c703bb10 c703bc60 c703cfc0 c703c000 c703c000
       c703cfec c01ae8de c025ec42 00000000 c703bb10 c0126ab0 c703cfcc c703cfcc
Call Trace:
 [<c01ae8de>] serio_thread+0xae/0xf0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
kcryptd/0     S 00070002     0    12      5                  10 (L-TLB)
c7278f4c 00000046 c0f5b888 00070002 c7276f90 00000001 00000003 00000000
       000021b3 5f6bfcc4 00000012 c7277b10 c7277c60 c7278f9c c7276f78 c7276f88
       c7278fc8 c012332c 00000000 c7278f70 c0112a0a c7276f90 c6b1aa54 c01f9bd0
Call Trace:
 [<c012332c>] worker_thread+0x1bc/0x1e0
 [<c0126705>] kthread+0x95/0xa0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
kjournald     D C0102AD6     0    13      1           228    11 (L-TLB)
c6533c08 00000046 c6533c74 c0102ad6 c027bb60 c1031be8 00000020 00000021
       00063584 df1ada75 00000015 c653cb10 c653cc60 fffc9861 c6533c1c c6533c74
       c6533c44 c024665b c6533000 00000020 fffffff1 c0330c30 c0330c30 fffc9861
Call Trace:
 [<c024665b>] schedule_timeout+0x5b/0xb0
 [<c024657e>] io_schedule_timeout+0xe/0x50
 [<c01bd7ab>] blk_congestion_wait+0x6b/0x80
 [<c0134c00>] try_to_free_pages+0x140/0x150
 [<c012dc64>] __alloc_pages+0x164/0x3e0
 [<c0129e68>] find_or_create_page+0x98/0xb0
 [<c01469a6>] grow_dev_page+0x26/0xf0
 [<c0146afa>] __getblk_slow+0x8a/0x120
 [<c0146e38>] __getblk+0x38/0x40
 [<c01866a9>] journal_get_descriptor_buffer+0x39/0xa0
 [<c01835f4>] journal_commit_transaction+0x474/0xf40
 [<c0185dd1>] kjournald+0xb1/0x1c0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
dhclient3     S 000000D0     0   228      1           304    13 (NOTLB)
c6314e9c 00000086 00000000 000000d0 00000001 c6314e8c 000000d0 c63b8f6c
       000016e9 ba6fcce4 0000000a c60acb10 c60acc60 00003643 c6314eb0 00000006
       c6314ed8 c024665b c6314eb4 c0202035 c5ccaec8 c0331328 c0331328 00003643
Call Trace:
 [<c024665b>] schedule_timeout+0x5b/0xb0
 [<c01549c5>] do_select+0x135/0x240
 [<c0154d85>] sys_select+0x285/0x460
 [<c0102167>] syscall_call+0x7/0xb
syslogd       S 00000001     0   304      1           307   228 (NOTLB)
c631be9c 00000086 00000000 00000001 00000046 c631be80 c631bea0 c631be98
       00000f1d ec626caf 00000011 c61fbb10 c61fbc60 00000000 7fffffff 00000001
       c631bed8 c02466a7 00000304 00000001 00000001 00000000 c631bed8 00000304
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c01549c5>] do_select+0x135/0x240
 [<c0154d85>] sys_select+0x285/0x460
 [<c0102167>] syscall_call+0x7/0xb
klogd         R running     0   307      1           311   304 (NOTLB)
dbus-daemon-1 S C60DCE00     0   311      1           328   307 (NOTLB)
c5bddf18 00000086 c60dcdd4 c60dce00 000000d0 c5b50f6c c5bddfa0 c5bddf00
       0006199a 098cea48 0000000b c633db10 c633dc60 00000000 7fffffff 7fffffff
       c5bddf54 c02466a7 c028f380 c59fefa4 c5bddf34 c01fcb15 00000145 c5bddf54
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c0155091>] do_poll+0x91/0xb0
 [<c01551c9>] sys_poll+0x119/0x210
 [<c0102167>] syscall_call+0x7/0xb
nmbd          D 00000000     0   328      1           330   311 (NOTLB)
c5421994 00000086 00000200 00000000 00000001 00000001 00000282 ffffffff
       00000dea 24062d77 00000015 c5424b10 c5424c60 c64c9e8c 00000052 c64c9ea4
       c542199c c024655e c54219f4 c012cb48 00000002 00000000 c5424b10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014720c>] __block_write_full_page+0x12c/0x2c0
 [<c014863b>] block_write_full_page+0xab/0xb0
 [<c0176cb8>] ext3_ordered_writepage+0xb8/0x190
 [<c0133ea6>] pageout+0x96/0xe0
 [<c01340c0>] shrink_list+0x1d0/0x3b0
 [<c01343e4>] shrink_cache+0x144/0x2c0
 [<c0134a2a>] shrink_zone+0xba/0xe0
 [<c0134ab3>] shrink_caches+0x63/0x70
 [<c0134b68>] try_to_free_pages+0xa8/0x150
 [<c012dc64>] __alloc_pages+0x164/0x3e0
 [<c012df02>] __get_free_pages+0x22/0x50
 [<c0154769>] __pollwait+0x79/0xc0
 [<c0202035>] datagram_poll+0x15/0xe0
 [<c0234c32>] udp_poll+0x12/0xf0
 [<c01fcb15>] sock_poll+0x15/0x20
 [<c0154a7e>] do_select+0x1ee/0x240
 [<c0154d85>] sys_select+0x285/0x460
 [<c0102167>] syscall_call+0x7/0xb
smbd          S 00000000     0   330      1   335     337   328 (NOTLB)
c51b4e9c 00000086 00000001 00000000 c5cb5b10 00000010 c027becc 00000000
       0002cef0 66a488fb 0000000b c5cb5b10 c5cb5c60 00000000 7fffffff 00000015
       c51b4ed8 c02466a7 c0154769 c534bec8 00000246 c671fdf8 00000246 c671fdf8
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c01549c5>] do_select+0x135/0x240
 [<c0154d85>] sys_select+0x285/0x460
 [<c0102167>] syscall_call+0x7/0xb
smbd          S 00000000     0   335    330                     (NOTLB)
c5b48fb4 00000086 0000020c 00000000 00000001 00000000 00000000 c01062dc
       00014864 668e2f93 0000000b c605bb10 c605bc60 082d8c38 00000000 00000001
       c5b48fbc c0120af7 c5b48000 c0102167 082d8c38 00000019 08389140 00000000
Call Trace:
 [<c0120af7>] sys_pause+0x17/0x20
 [<c0102167>] syscall_call+0x7/0xb
sshd          S 00000000     0   337      1   352     340   330 (NOTLB)
c4c6de9c 00000086 00000001 00000000 c5270b10 00000010 c027becc 00000000
       00001b12 ccd5599a 0000000d c5270b10 c5270c60 00000000 7fffffff 00000004
       c4c6ded8 c02466a7 c0154769 c4c48ec8 00000246 c028dd40 c4cc8c10 c4c6decc
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c01549c5>] do_select+0x135/0x240
 [<c0154d85>] sys_select+0x285/0x460
 [<c0102167>] syscall_call+0x7/0xb
cron          S 00001000     0   340      1           346   337 (NOTLB)
c4d02f54 00000086 00000000 00001000 00000000 00001000 00000008 00000000
       00004605 53a50334 00000011 c4d01b10 c4d01c60 fffd3626 c4d02f68 000f41a7
       c4d02f90 c024665b 00000000 00000000 c4d02f70 c03314c8 c033e6bc fffd3626
Call Trace:
 [<c024665b>] schedule_timeout+0x5b/0xb0
 [<c011dc7e>] sys_nanosleep+0xce/0x150
 [<c0102167>] syscall_call+0x7/0xb
getty         S C114F050     0   346      1           347   340 (NOTLB)
c668ee6c 00000086 00000000 c114f050 00000217 c1201000 c1201000 00000292
       00009f56 ce6b0162 0000000b c6661b10 c6661c60 c604d000 7fffffff c66bdf6c
       c668eea8 c02466a7 c012a733 0000ef2c 00000008 c00bc4cc 0000000e c1201000
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c01a25c0>] read_chan+0x560/0x670
 [<c019d73e>] tty_read+0xce/0xf0
 [<c0144abe>] vfs_read+0x8e/0x100
 [<c0144d41>] sys_read+0x41/0x70
 [<c0102167>] syscall_call+0x7/0xb
getty         S C114F050     0   347      1           348   346 (NOTLB)
c59b4e6c 00000086 00000000 c114f050 00001000 c59b4e4c c010f986 00000292
       00004618 ce6f8efd 0000000b c667cb10 c667cc60 c4d78000 7fffffff c66b8f6c
       c59b4ea8 c02466a7 c012a733 00004f2c c4d7a1fc 00000000 00000001 ffffffff
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c01a25c0>] read_chan+0x560/0x670
 [<c019d73e>] tty_read+0xce/0xf0
 [<c0144abe>] vfs_read+0x8e/0x100
 [<c0144d41>] sys_read+0x41/0x70
 [<c0102167>] syscall_call+0x7/0xb
getty         S C114F050     0   348      1           349   347 (NOTLB)
c67d4e6c 00000086 00000000 c114f050 00001000 c67d4e4c c010f986 00000292
       00004b9a ce6d5e39 0000000b c5235b10 c5235c60 c4d6c000 7fffffff c6703f6c
       c67d4ea8 c02466a7 c012a733 00004f2c c4d6e1fc 00000000 00000002 ffffffff
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c01a25c0>] read_chan+0x560/0x670
 [<c019d73e>] tty_read+0xce/0xf0
 [<c0144abe>] vfs_read+0x8e/0x100
 [<c0144d41>] sys_read+0x41/0x70
 [<c0102167>] syscall_call+0x7/0xb
getty         S C114F050     0   349      1           350   348 (NOTLB)
c543de6c 00000086 00000000 c114f050 00001000 c543de4c c010f986 00000292
       00005299 ce766723 0000000b c4d3fb10 c4d3fc60 c4d9f000 7fffffff c668df6c
       c543dea8 c02466a7 c012a733 0000df2c c4da11fc 00000000 00000003 ffffffff
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c01a25c0>] read_chan+0x560/0x670
 [<c019d73e>] tty_read+0xce/0xf0
 [<c0144abe>] vfs_read+0x8e/0x100
 [<c0144d41>] sys_read+0x41/0x70
 [<c0102167>] syscall_call+0x7/0xb
getty         S C114F050     0   350      1           351   349 (NOTLB)
c5b37e6c 00000086 00000000 c114f050 00001000 c5b37e4c c010f986 00000292
       000043a3 ce71ac1a 0000000b c5c5cb10 c5c5cc60 c4d83000 7fffffff c67fdf6c
       c5b37ea8 c02466a7 c012a733 00007f2c c4d851fc 00000000 00000004 ffffffff
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c01a25c0>] read_chan+0x560/0x670
 [<c019d73e>] tty_read+0xce/0xf0
 [<c0144abe>] vfs_read+0x8e/0x100
 [<c0144d41>] sys_read+0x41/0x70
 [<c0102167>] syscall_call+0x7/0xb
getty         S C114F050     0   351      1           372   350 (NOTLB)
c4d51e6c 00000086 00000000 c114f050 00001000 c4d51e4c c010f986 00000292
       000044c7 ce73d254 0000000b c4d50b10 c4d50c60 c4d90000 7fffffff c6025f6c
       c4d51ea8 c02466a7 c012a733 00001f2c c4d931fc 00000000 00000005 ffffffff
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c01a25c0>] read_chan+0x560/0x670
 [<c019d73e>] tty_read+0xce/0xf0
 [<c0144abe>] vfs_read+0x8e/0x100
 [<c0144d41>] sys_read+0x41/0x70
 [<c0102167>] syscall_call+0x7/0xb
sshd          D 00000000     0   352    337   355     359       (NOTLB)
c4ce39b0 00000086 00000200 00000000 00000001 00000001 00000282 ffffffff
       00000233 24067098 00000015 c4db7b10 c4db7c60 c64c9e8c 00000052 c64c9ea4
       c4ce39b8 c024655e c4ce3a10 c012cb48 00000002 00000000 c4db7b10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014720c>] __block_write_full_page+0x12c/0x2c0
 [<c014863b>] block_write_full_page+0xab/0xb0
 [<c0176cb8>] ext3_ordered_writepage+0xb8/0x190
 [<c0133ea6>] pageout+0x96/0xe0
 [<c01340c0>] shrink_list+0x1d0/0x3b0
 [<c01343e4>] shrink_cache+0x144/0x2c0
 [<c0134a2a>] shrink_zone+0xba/0xe0
 [<c0134ab3>] shrink_caches+0x63/0x70
 [<c0134b68>] try_to_free_pages+0xa8/0x150
 [<c012dc64>] __alloc_pages+0x164/0x3e0
 [<c012df02>] __get_free_pages+0x22/0x50
 [<c0154769>] __pollwait+0x79/0xc0
 [<c014f1f2>] pipe_poll+0x32/0xb0
 [<c0154a7e>] do_select+0x1ee/0x240
 [<c0154d85>] sys_select+0x285/0x460
 [<c0102167>] syscall_call+0x7/0xb
bash          S C4E144D8     0   355    352   369               (NOTLB)
c4d40f1c 00000086 c528ce00 c4e144d8 c4d40fbc c010ec68 00000001 afa7f132
       00008908 afb62aab 0000000f c4defb10 c4defc60 fffffe00 00000006 c4defbb0
       c4d40f94 c0118cc8 00000000 c4ff7b10 c4d40fc4 c4defbb0 00000000 00000001
Call Trace:
 [<c0118cc8>] do_wait+0x188/0x410
 [<c0119010>] sys_wait4+0x30/0x40
 [<c0119047>] sys_waitpid+0x27/0x29
 [<c0102167>] syscall_call+0x7/0xb
sshd          D 00000000     0   359    337   362           352 (NOTLB)
c66789b0 00000086 00000200 00000000 00000001 00000001 00000282 ffffffff
       0000022c 24065efa 00000015 c710db10 c710dc60 c64c9e8c 00000052 c64c9ea4
       c66789b8 c024655e c6678a10 c012cb48 00000002 00000000 c710db10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014720c>] __block_write_full_page+0x12c/0x2c0
 [<c014863b>] block_write_full_page+0xab/0xb0
 [<c0176cb8>] ext3_ordered_writepage+0xb8/0x190
 [<c0133ea6>] pageout+0x96/0xe0
 [<c01340c0>] shrink_list+0x1d0/0x3b0
 [<c01343e4>] shrink_cache+0x144/0x2c0
 [<c0134a2a>] shrink_zone+0xba/0xe0
 [<c0134ab3>] shrink_caches+0x63/0x70
 [<c0134b68>] try_to_free_pages+0xa8/0x150
 [<c012dc64>] __alloc_pages+0x164/0x3e0
 [<c012df02>] __get_free_pages+0x22/0x50
 [<c0154769>] __pollwait+0x79/0xc0
 [<c014f1f2>] pipe_poll+0x32/0xb0
 [<c0154a7e>] do_select+0x1ee/0x240
 [<c0154d85>] sys_select+0x285/0x460
 [<c0102167>] syscall_call+0x7/0xb
bash          S C5858060     0   362    359                     (NOTLB)
c4ce0e6c 00000086 00000092 c5858060 00000000 c60ad934 ec6aac06 00000011
       00003b56 ec6c022a 00000011 c64f7b10 c64f7c60 c4cf7000 7fffffff c4fe8f6c
       c4ce0ea8 c02466a7 00000000 c60ad000 00000003 c60ad000 00000003 c4ce0ea4
Call Trace:
 [<c02466a7>] schedule_timeout+0xa7/0xb0
 [<c01a25c0>] read_chan+0x560/0x670
 [<c019d73e>] tty_read+0xce/0xf0
 [<c0144abe>] vfs_read+0x8e/0x100
 [<c0144d41>] sys_read+0x41/0x70
 [<c0102167>] syscall_call+0x7/0xb
test_crypt.sh S C4E147F8     0   369    355   379               (NOTLB)
c4d3af1c 00000086 c4855e00 c4e147f8 c4d3afbc c010ec68 00000001 924650e0
       0000706c 925319f3 00000010 c4ff7b10 c4ff7c60 fffffe00 00000004 c4ff7bb0
       c4d3af94 c0118cc8 00000000 c493ab10 c4d3afc4 c4ff7bb0 00000000 00000001
Call Trace:
 [<c0118cc8>] do_wait+0x188/0x410
 [<c0119010>] sys_wait4+0x30/0x40
 [<c0119047>] sys_waitpid+0x27/0x29
 [<c0102167>] syscall_call+0x7/0xb
loop7         D C0102AF8     0   372      1           378   351 (L-TLB)
c5c50dd8 00000046 c5c50e44 c0102af8 c027bc84 c10972e0 db6c085f 00000015
       00006ad6 db6c0a37 00000015 c4970b10 c4970c60 fffc9823 c5c50dec c5c50e44
       c5c50e14 c024665b c5c50000 00000020 b01e6400 c7508ea4 c0330a40 fffc9823
Call Trace:
 [<c024665b>] schedule_timeout+0x5b/0xb0
 [<c024657e>] io_schedule_timeout+0xe/0x50
 [<c01bd7ab>] blk_congestion_wait+0x6b/0x80
 [<c0134c00>] try_to_free_pages+0x140/0x150
 [<c012dc64>] __alloc_pages+0x164/0x3e0
 [<c0129e68>] find_or_create_page+0x98/0xb0
 [<c01cd316>] do_lo_send+0xa6/0x250
 [<c01cd51a>] lo_send+0x5a/0x80
 [<c01cd72e>] do_bio_filebacked+0x5e/0x60
 [<c01cd919>] loop_thread+0x89/0xe0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
kjournald     D 00000000     0   378      1                 372 (L-TLB)
c667db38 00000046 00000200 00000000 00000001 00000001 23c293f1 00000015
       00000272 2403feb2 00000015 c4902b10 c4902c60 c64c9e8c 00000052 c64c9ea4
       c667db40 c024655e c667db98 c012cb48 00000002 00000000 c4902b10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014883f>] ll_rw_block+0x5f/0x80
 [<c0183f62>] journal_commit_transaction+0xde2/0xf40
 [<c0185dd1>] kjournald+0xb1/0x1c0
 [<c01006a5>] kernel_thread_helper+0x5/0x10
dbench        D 00000000     0   379    369   380               (NOTLB)
c5c42934 00000086 00000282 00000000 00000001 00000001 00000282 ffffffff
       000001c9 24063bc1 00000015 c493ab10 c493ac60 c64c9e8c 00000052 c64c9ea4
       c5c4293c c024655e c5c42994 c012cb48 00000002 00000000 c493ab10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014720c>] __block_write_full_page+0x12c/0x2c0
 [<c014863b>] block_write_full_page+0xab/0xb0
 [<c0176cb8>] ext3_ordered_writepage+0xb8/0x190
 [<c0133ea6>] pageout+0x96/0xe0
 [<c01340c0>] shrink_list+0x1d0/0x3b0
 [<c01343e4>] shrink_cache+0x144/0x2c0
 [<c0134a2a>] shrink_zone+0xba/0xe0
 [<c0134ab3>] shrink_caches+0x63/0x70
 [<c0134b68>] try_to_free_pages+0xa8/0x150
 [<c012dc64>] __alloc_pages+0x164/0x3e0
 [<c012fcac>] __do_page_cache_readahead+0xbc/0xf0
 [<c012ada4>] filemap_nopage+0x274/0x320
 [<c0138135>] do_no_page+0x95/0x2a0
 [<c01384d2>] handle_mm_fault+0xc2/0x130
 [<c010ec68>] do_page_fault+0x1b8/0x625
 [<c0102b7b>] error_code+0x2b/0x30
dbench        D 00000000     0   380    379           381       (NOTLB)
c4d56850 00000086 00000200 00000000 00000001 00000001 00000282 ffffffff
       0000038d 24068979 00000015 c495fb10 c495fc60 c64c9e8c 00000052 c64c9ea4
       c4d56858 c024655e c4d568b0 c012cb48 00000002 00000000 c495fb10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014720c>] __block_write_full_page+0x12c/0x2c0
 [<c014863b>] block_write_full_page+0xab/0xb0
 [<c0176cb8>] ext3_ordered_writepage+0xb8/0x190
 [<c0133ea6>] pageout+0x96/0xe0
 [<c01340c0>] shrink_list+0x1d0/0x3b0
 [<c01343e4>] shrink_cache+0x144/0x2c0
 [<c0134a2a>] shrink_zone+0xba/0xe0
 [<c0134ab3>] shrink_caches+0x63/0x70
 [<c0134b68>] try_to_free_pages+0xa8/0x150
 [<c012dc64>] __alloc_pages+0x164/0x3e0
 [<c012b6a5>] generic_file_buffered_write+0x125/0x580
 [<c012bd74>] __generic_file_aio_write_nolock+0x274/0x4a0
 [<c012c1cc>] generic_file_aio_write+0x5c/0xd0
 [<c017458d>] ext3_file_write+0x2d/0xe0
 [<c0144bc1>] do_sync_write+0x91/0xd0
 [<c0144c94>] vfs_write+0x94/0x100
 [<c0144ed3>] sys_pwrite64+0x73/0x80
 [<c0102167>] syscall_call+0x7/0xb
dbench        D C4D21BB8     0   381    379           382   380 (NOTLB)
c4d21be4 00000086 c4914334 c4d21bb8 c01bca19 c4d21bc0 c01bca31 c4d21bc8
       00029383 6175409f 00000012 c2d6bb10 c2d6bc60 c4d21c44 00000000 c4d21c4c
       c4d21bec c024655e c4d21bf4 c0145aaa c4d21c10 c0246797 c0145a80 c11fdd98
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c0145aaa>] sync_buffer+0x2a/0x40
 [<c0246797>] __wait_on_bit+0x57/0x60
 [<c024681f>] out_of_line_wait_on_bit+0x7f/0x90
 [<c0145b4e>] __wait_on_buffer+0x2e/0x30
 [<c01488b7>] sync_dirty_buffer+0x57/0xc0
 [<c0182280>] journal_dirty_data+0x140/0x150
 [<c0176818>] ext3_journal_dirty_data+0x18/0x50
 [<c017667d>] walk_page_buffers+0x6d/0x80
 [<c0176907>] ext3_ordered_commit_write+0x57/0xe0
 [<c012b786>] generic_file_buffered_write+0x206/0x580
 [<c012bd74>] __generic_file_aio_write_nolock+0x274/0x4a0
 [<c012c1cc>] generic_file_aio_write+0x5c/0xd0
 [<c017458d>] ext3_file_write+0x2d/0xe0
 [<c0144bc1>] do_sync_write+0x91/0xd0
 [<c0144c94>] vfs_write+0x94/0x100
 [<c0144ed3>] sys_pwrite64+0x73/0x80
 [<c0102167>] syscall_call+0x7/0xb
dbench        D 00000000     0   382    379           383   381 (NOTLB)
c576c850 00000086 00000282 00000000 00000001 00000001 00000282 ffffffff
       000002e6 24069dc5 00000015 c2cc6b10 c2cc6c60 c64c9e8c 00000052 c64c9ea4
       c576c858 c024655e c576c8b0 c012cb48 00000002 00000000 c2cc6b10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014720c>] __block_write_full_page+0x12c/0x2c0
 [<c014863b>] block_write_full_page+0xab/0xb0
 [<c0176cb8>] ext3_ordered_writepage+0xb8/0x190
 [<c0133ea6>] pageout+0x96/0xe0
 [<c01340c0>] shrink_list+0x1d0/0x3b0
 [<c01343e4>] shrink_cache+0x144/0x2c0
 [<c0134a2a>] shrink_zone+0xba/0xe0
 [<c0134ab3>] shrink_caches+0x63/0x70
 [<c0134b68>] try_to_free_pages+0xa8/0x150
 [<c012dc64>] __alloc_pages+0x164/0x3e0
 [<c012b6a5>] generic_file_buffered_write+0x125/0x580
 [<c012bd74>] __generic_file_aio_write_nolock+0x274/0x4a0
 [<c012c1cc>] generic_file_aio_write+0x5c/0xd0
 [<c017458d>] ext3_file_write+0x2d/0xe0
 [<c0144bc1>] do_sync_write+0x91/0xd0
 [<c0144c94>] vfs_write+0x94/0x100
 [<c0144ed3>] sys_pwrite64+0x73/0x80
 [<c0102167>] syscall_call+0x7/0xb
dbench        D 00000000     0   383    379                 382 (NOTLB)
c541c850 00000086 00000200 00000000 00000001 00000001 00000282 ffffffff
       00000293 2406afcf 00000015 c332fb10 c332fc60 c64c9e8c 00000052 c64c9ea4
       c541c858 c024655e c541c8b0 c012cb48 00000002 00000000 c332fb10 c0126ab0
Call Trace:
 [<c024655e>] io_schedule+0xe/0x20
 [<c012cb48>] mempool_alloc+0xe8/0x100
 [<c01f9a04>] crypt_alloc_buffer+0xa4/0x160
 [<c01fa40a>] crypt_map+0x9a/0x250
 [<c01f274e>] __map_bio+0x3e/0xf0
 [<c01f2ade>] __clone_and_map+0x20e/0x220
 [<c01f2b77>] __split_bio+0x87/0xf0
 [<c01f2c44>] dm_request+0x64/0x90
 [<c01be08e>] generic_make_request+0x14e/0x200
 [<c01be197>] submit_bio+0x57/0xf0
 [<c014878b>] submit_bh+0xcb/0x120
 [<c014720c>] __block_write_full_page+0x12c/0x2c0
 [<c014863b>] block_write_full_page+0xab/0xb0
 [<c0176cb8>] ext3_ordered_writepage+0xb8/0x190
 [<c0133ea6>] pageout+0x96/0xe0
 [<c01340c0>] shrink_list+0x1d0/0x3b0
 [<c01343e4>] shrink_cache+0x144/0x2c0
 [<c0134a2a>] shrink_zone+0xba/0xe0
 [<c0134ab3>] shrink_caches+0x63/0x70
 [<c0134b68>] try_to_free_pages+0xa8/0x150
 [<c012dc64>] __alloc_pages+0x164/0x3e0
 [<c012b6a5>] generic_file_buffered_write+0x125/0x580
 [<c012bd74>] __generic_file_aio_write_nolock+0x274/0x4a0
 [<c012c1cc>] generic_file_aio_write+0x5c/0xd0
 [<c017458d>] ext3_file_write+0x2d/0xe0
 [<c0144bc1>] do_sync_write+0x91/0xd0
 [<c0144c94>] vfs_write+0x94/0x100
 [<c0144ed3>] sys_pwrite64+0x73/0x80
 [<c0102167>] syscall_call+0x7/0xb
