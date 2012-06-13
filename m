From: Christian May <cmay@linux.vnet.ibm.com>
Subject: Re: RHEL6.2: path failures during good path I/O
Date: Wed, 13 Jun 2012 17:41:29 +0200
Message-ID: <4FD8B4A9.40807@linux.vnet.ibm.com>
References: <4FD8AC55.3050909@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4FD8AC55.3050909@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


Am 13.06.2012 15:16, schrieb Mike Snitzer
>  Do you have any additional kernel log messages that might shed some
>  light on what (if anything ) is failing (be it the transport or target,
>  etc)?
>

Following some dmesg-output. I've noticed

sd 4:0:1:0: aborting command. lun 0x8100000000000000, tag 0xc00000026d3c8df8
sd 4:0:1:0: aborted task tag 0xc00000026d3c8df8 completed
sd 19:0:1:0: aborting command. lun 0x8100000000000000, tag
0xc00000026d850ce8
sd 19:0:1:0: aborted task tag 0xc00000026d850ce8 completed


as well as

Node 0 DMA free:22272kB min:12928kB low:16128kB high:19392kB
active_anon:120640kB inactive_anon:19584kB active_file:587e:3289728kB
unevictable:18176kB isolated(anon):0kB isolated(file):0kB
present:10476800kB mlocked:18176kB dirty:651392kBapped:15808kB
shmem:11968kB slab_reclaimable:613824kB slab_unreclaimable:79104kB
kernel_stack:8704kB pagetables:18240kBe:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
Node 0 DMA: 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB
0*8192kB 0*16384kB = 0kB
143519 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 10239872kB
Total swap = 10239872kB
163840 pages RAM
5040 pages reserved
116123 pages shared
44447 pages non-shared
irqbalance: page allocation failure. order:0, mode:0x8020
Call Trace:
[c00000026cabf5e0] [c000000000012f04] .show_stack+0x74/0x1c0 (unreliable)
[c00000026cabf690] [c000000000169b88] .__alloc_pages_nodemask+0x618/0x930
[c00000026cabf810] [c0000000001a5ab0] .alloc_pages_current+0xb0/0x170
[c00000026cabf8b0] [c000000000164f88] .__get_free_pages+0x18/0xb0
[c00000026cabf930] [d00000000302160c] .ehea_get_stats+0x4c/0x1e0 [ehea]
[c00000026cabf9d0] [c0000000004d2758] .dev_get_stats+0x38/0x90
[c00000026cabfa50] [c0000000004d35c4] .dev_seq_show+0x34/0x140
[c00000026cabfb40] [c0000000001ed7b0] .seq_read+0x3c0/0x5d0
[c00000026cabfc30] [c00000000023f4b4] .proc_reg_read+0xb4/0x130
[c00000026cabfce0] [c0000000001c5dbc] .vfs_read+0xec/0x1f0
[c00000026cabfd80] [c0000000001c5fe8] .SyS_read+0x58/0xb0
[c00000026cabfe30] [c000000000008564] syscall_exit+0x0/0x40
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    6, btch:   1 usd:   5
CPU    1: hi:    6, btch:   1 usd:   0
CPU    2: hi:    6, btch:   1 usd:   1
CPU    3: hi:    6, btch:   1 usd:   0
CPU    4: hi:    6, btch:   1 usd:   0
CPU    5: hi:    6, btch:   1 usd:   0
CPU    6: hi:    6, btch:   1 usd:   1
CPU    7: hi:    6, btch:   1 usd:   0
CPU    8: hi:    6, btch:   1 usd:   0
CPU    9: hi:    6, btch:   1 usd:   0
CPU   10: hi:    6, btch:   1 usd:   0
CPU   11: hi:    6, btch:   1 usd:   0
CPU   12: hi:    6, btch:   1 usd:   0
CPU   13: hi:    6, btch:   1 usd:   2
CPU   14: hi:    6, btch:   1 usd:   0
CPU   15: hi:    6, btch:   1 usd:   0
active_anon:1815 inactive_anon:305 isolated_anon:0


Strange...

Christian
