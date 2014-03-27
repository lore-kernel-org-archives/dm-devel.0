From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] avoid recursion in bio_endio
Date: Thu, 27 Mar 2014 16:19:53 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403271557180.13917@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1403191816380.4463@file01.intranet.prod.int.rdu2.redhat.com>
	<20140320002952.GA19120@redhat.com>
	<alpine.LRH.2.02.1403192220400.456@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403192256470.11960@file01.intranet.prod.int.rdu2.redhat.com>
	<20140320034721.GB20047@redhat.com> <20140320035315.GA20193@redhat.com>
	<alpine.LRH.2.02.1403201702390.9015@file01.intranet.prod.int.rdu2.redhat.com>
	<20140320211253.GA25187@redhat.com>
	<alpine.LRH.2.02.1403201742010.14227@file01.intranet.prod.int.rdu2.redhat.com>
	<20140321010605.GA15280@redhat.com>
	<alpine.LRH.2.02.1403202149380.16499@file01.intranet.prod.int.rdu2.redhat.com>
	<532C41E7.8000303@redhat.com>
	<alpine.LRH.2.02.1403211214250.9191@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1403221413080.17722@file01.intranet.prod.int.rdu2.redhat.com>
	<5332AB82.80107@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5332AB82.80107@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi

Here I'm sending a patch that avoids recursion in bio_endio. It fixes a 
crash when deep nested chain of device mapper devices is used.

Note, there is still recursion in q->merge_bvec_fn and 
q->backing_dev_info.congested_fn. I suppose that the fix for recursion in 
these functions would be to allow a limited recursion depth (maybe 10) and 
then return some default value.

If we need to ignore a call to q->merge_bvec_fn due to recursion depth, 
should I restrict it to allow only one-page bios? Or should I allow 
unlimited bios? Kent did some patches to enable bio splitting and allow 
bios of unlimited size - I'd like to ask if these changes are complete and 
if q->merge_bvec_fn can be ignored when building a bio.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

bio_endio: avoid recursion

There is unbounded recursion in bio_endio. There was some provisioning to
avoid recursion when bio->bi_end_io == bio_chain_endio, but it is not
sufficient because recursion can happen in other ways. Using nested device
mapper devices results in recursion in bio_endio and it may cause stack
overflow.

This patch builds a per-cpu queue of bios waiting to be finished. When
bio_endio is called recursively, the bio is added to the queue and
bio_endio finishes immediatelly without calling bi_end_io. bi_end_io is
called only from the topmost bio_endio invocation, preventing unbounded
recursion.

In order to avoid interrupt latency, we restore interrupts when calling
bi_end_io. We disable preemption, so that we can access our per-cpu queue.

This is example of a crash that happens due to bio_endio recursion when 20
nested dm-crypt targets are used:

[151453.447523] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: barrier=1
[151526.491370] bio: create slab <bio-0> at 0
[151538.572038] BUG: unable to handle kernel paging request at fffffffe38cb54a0
[151538.573009] IP: [<ffffffff810bda87>] cpuacct_charge+0x27/0x40
[151538.573009] PGD 1931067 PUD 0
[151538.573009] Thread overran stack, or stack corrupted
[151538.573009] Oops: 0000 [#1] SMP
[151538.573009] Modules linked in: dm_crypt(F) raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx ext4 mbcache jbd2 crypto_null xts gf128mul dm_zero sg cfg80211 rfkill iTCO_wdt iTCO_vendor_support ppdev dcdbas lpc_ich mfd_core serio_raw pcspkr e1000 ipmi_si video shpchp parport_pc ipmi_msghandler e752x_edac parport edac_core nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c sd_mod crc_t10dif crct10dif_common sr_mod cdrom ata_generic pata_acpi radeon i2c_algo_bit drm_kms_helper ttm drm i2c_core mptspi ata_piix libata scsi_transport_spi mptscsih mptbase floppy dm_mirror dm_region_hash dm_log dm_mod [last unloaded: dm_crypt]
[151538.573009] CPU: 2 PID: 27720 Comm: md0_raid5 Tainted: GF       W    3.14.0-1.el7.x86_64 #1
[151538.573009] Hardware name: Dell Computer Corporation PowerEdge 2800/0C8306, BIOS A07 04/25/2008
[151538.573009] task: ffff880098b7dd30 ti: ffff8800d6e4c000 task.ti: ffff8800d6e4c000
[151538.573009] RIP: 0010:[<ffffffff810bda87>]  [<ffffffff810bda87>] cpuacct_charge+0x27/0x40
[151538.573009] RSP: 0018:ffff88011fc83d88  EFLAGS: 00010046
[151538.573009] RAX: 000000000000e6a8 RBX: ffff880098b7dd98 RCX: ffffffffd6e4c118
[151538.573009] RDX: ffffffff8196bb40 RSI: 000000000007ce0c RDI: ffff880098b7dd30
[151538.573009] RBP: ffff88011fc83d88 R08: 0000000000000000 R09: 0001d3ef4337d60f
[151538.573009] R10: 135c4e303b2f38c3 R11: ffffea00035f6900 R12: 000000000007ce0c
[151538.573009] R13: ffff88011fc94740 R14: ffff880098b7dd30 R15: 0000000000000000
[151538.573009] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
[151538.573009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[151538.573009] CR2: fffffffe38cb54a0 CR3: 00000001191cb000 CR4: 00000000000007e0
[151538.573009] Stack:
[151538.573009]  ffff88011fc83dc8 ffffffff810af40c 00001534734a3f1f ffff880098b7dd98
[151538.573009]  0000000000000002 ffff88011fc94740 ffff88011fc946c0 0000000000000000
[151538.573009]  ffff88011fc83e28 ffffffff810b0859 0000000000015140 00000000000146c0
[151538.573009] Call Trace:
[151538.573009]  <IRQ>
[151538.573009]  [<ffffffff810af40c>] update_curr+0xcc/0x160
[151538.573009]  [<ffffffff810b0859>] task_tick_fair+0x2b9/0x690
[151538.573009]  [<ffffffff810a9a18>] ? sched_clock_cpu+0x98/0xc0
[151538.573009]  [<ffffffff810a4e0f>] scheduler_tick+0x5f/0xe0
[151538.573009]  [<ffffffff8107ebc0>] update_process_times+0x60/0x70
[151538.573009]  [<ffffffff810e1fe5>] tick_sched_handle.isra.17+0x25/0x60
[151538.573009]  [<ffffffff810e2061>] tick_sched_timer+0x41/0x60
[151538.573009]  [<ffffffff810981a7>] __run_hrtimer+0x77/0x1d0
[151538.573009]  [<ffffffff810e2020>] ? tick_sched_handle.isra.17+0x60/0x60
[151538.573009]  [<ffffffff810989e7>] hrtimer_interrupt+0xf7/0x240
[151538.573009]  [<ffffffff8104aad7>] local_apic_timer_interrupt+0x37/0x60
[151538.573009]  [<ffffffff816371ef>] smp_apic_timer_interrupt+0x3f/0x60
[151538.573009]  [<ffffffff81635b5d>] apic_timer_interrupt+0x6d/0x80
[151538.573009]  <EOI>
[151538.573009]  [<ffffffff811610a7>] ? mempool_free_slab+0x17/0x20
[151538.573009]  [<ffffffff81620445>] ? cmpxchg_double_slab.isra.53+0x31/0xfa
[151538.573009]  [<ffffffff81167232>] ? __free_memcg_kmem_pages+0x22/0x50
[151538.573009]  [<ffffffff811b34b8>] ? __free_slab+0xd8/0x1d0
[151538.573009]  [<ffffffff81620939>] __slab_free+0xf1/0x1bb
[151538.573009]  [<ffffffff812df6c9>] ? __fprop_inc_percpu_max+0x69/0xb0
[151538.573009]  [<ffffffff8116a1fb>] ? test_clear_page_writeback+0xeb/0x220
[151538.573009]  [<ffffffff81620939>] ? __slab_free+0xf1/0x1bb
[151538.573009]  [<ffffffff811b4765>] kmem_cache_free+0x1b5/0x1e0
[151538.573009]  [<ffffffff811610a7>] mempool_free_slab+0x17/0x20
[151538.573009]  [<ffffffff81161349>] mempool_free+0x49/0x90
[151538.573009]  [<ffffffff8120ad28>] bio_put+0x78/0x90
[151538.573009]  [<ffffffff81205274>] end_bio_bh_io_sync+0x34/0x60
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa0000af9>] dec_pending+0x199/0x300 [dm_mod]
[151538.573009]  [<ffffffffa0000ddf>] clone_endio+0x6f/0xa0 [dm_mod]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06d3933>] crypt_dec_pending+0x73/0xa0 [dm_crypt]
[151538.573009]  [<ffffffffa06d3ca8>] crypt_endio+0x58/0xe0 [dm_crypt]
[151538.573009]  [<ffffffff8120bf1b>] bio_endio+0x5b/0xa0
[151538.573009]  [<ffffffffa06bea5a>] return_io+0x5a/0xa0 [raid456]
[151538.573009]  [<ffffffffa06c5c74>] handle_stripe+0x164/0x2580 [raid456]
[151538.573009]  [<ffffffffa00d72ed>] ? mptspi_qcmd+0x8d/0x120 [mptspi]
[151538.573009]  [<ffffffffa06c83fe>] handle_active_stripes.isra.38+0x36e/0x4f0 [raid456]
[151538.573009]  [<ffffffffa06bd8c9>] ? __release_stripe+0x19/0x20 [raid456]
[151538.573009]  [<ffffffffa06c8a68>] raid5d+0x4e8/0x740 [raid456]
[151538.573009]  [<ffffffff814b0b07>] md_thread+0x137/0x150
[151538.573009]  [<ffffffff810b9860>] ? abort_exclusive_wait+0xb0/0xb0
[151538.573009]  [<ffffffff814b09d0>] ? mddev_unlock+0xe0/0xe0
[151538.573009]  [<ffffffff81094cb1>] kthread+0xe1/0x100
[151538.573009]  [<ffffffff81094bd0>] ? kthread_create_on_node+0x1a0/0x1a0
[151538.573009]  [<ffffffff81634e3c>] ret_from_fork+0x7c/0xb0
[151538.573009]  [<ffffffff81094bd0>] ? kthread_create_on_node+0x1a0/0x1a0
[151538.573009] Code: 5d eb d7 90 0f 1f 44 00 00 48 8b 47 08 55 48 89 e5 48 63 48 18 48 8b 87 78 0b 00 00 48 8b 50 48 0f 1f 40 00 48 8b 82 80 00 00 00 <48> 03 04 cd e0 4b a5 81 48 01 30 48 8b 52 40 48 85 d2 75 e5 5d
[151538.573009] RIP  [<ffffffff810bda87>] cpuacct_charge+0x27/0x40
[151538.573009]  RSP <ffff88011fc83d88>
[151538.573009] CR2: fffffffe38cb54a0
[151538.573009] ---[ end trace 2076d7d550022e1d ]---

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/bio.c                  |   76 ++++++++++++++++++++++++++++++++--------------
 include/linux/blk_types.h |    5 ++-
 2 files changed, 58 insertions(+), 23 deletions(-)

Index: linux-3.14-rc8/fs/bio.c
===================================================================
--- linux-3.14-rc8.orig/fs/bio.c	2014-03-25 22:57:00.000000000 +0100
+++ linux-3.14-rc8/fs/bio.c	2014-03-27 03:30:39.000000000 +0100
@@ -1747,37 +1747,69 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
  *   bio unless they own it and thus know that it has an end_io
  *   function.
  **/
+
+static DEFINE_PER_CPU(struct bio **, bio_end_queue) = { NULL };
+
 void bio_endio(struct bio *bio, int error)
 {
-	while (bio) {
-		BUG_ON(atomic_read(&bio->bi_remaining) <= 0);
+	struct bio ***bio_end_queue_ptr;
+
+	unsigned long flags;
+
+	BUG_ON(atomic_read(&bio->bi_remaining) <= 0);
+
+	if (error)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		error = -EIO;
+
+	if (!atomic_dec_and_test(&bio->bi_remaining))
+		return;
+
+	/* save the error to the bio */
+	bio->bi_error = error;
 
-		if (error)
-			clear_bit(BIO_UPTODATE, &bio->bi_flags);
-		else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-			error = -EIO;
+	preempt_disable();
+	local_irq_save(flags);
+	bio_end_queue_ptr = &__get_cpu_var(bio_end_queue);
+
+	if (*bio_end_queue_ptr) {
+		**bio_end_queue_ptr = bio;
+		*bio_end_queue_ptr = &bio->bi_next;
+		bio->bi_next = NULL;
+	} else {
+		struct bio *bio_queue = NULL;
+		*bio_end_queue_ptr = &bio_queue;
 
-		if (!atomic_dec_and_test(&bio->bi_remaining))
-			return;
+next_bio:
+		local_irq_restore(flags);
 
+		/* restore the saved error */
+		error = bio->bi_error;
 		/*
-		 * Need to have a real endio function for chained bios,
-		 * otherwise various corner cases will break (like stacking
-		 * block devices that save/restore bi_end_io) - however, we want
-		 * to avoid unbounded recursion and blowing the stack. Tail call
-		 * optimization would handle this, but compiling with frame
-		 * pointers also disables gcc's sibling call optimization.
+		 * Restore bi_remaining. Don't use atomic_set - there is no
+		 * concurrent access and we want to avoid taking spinlock on
+		 * architectures where atomic_set takes it.
 		 */
-		if (bio->bi_end_io == bio_chain_endio) {
-			struct bio *parent = bio->bi_private;
-			bio_put(bio);
-			bio = parent;
-		} else {
-			if (bio->bi_end_io)
-				bio->bi_end_io(bio, error);
-			bio = NULL;
+		bio->bi_remaining = (atomic_t)ATOMIC_INIT(0);
+
+		if (bio->bi_end_io)
+			bio->bi_end_io(bio, error);
+
+		local_irq_disable();
+
+		if (bio_queue) {
+			bio = bio_queue;
+			bio_queue = bio->bi_next;
+			if (likely(!bio_queue))
+				*bio_end_queue_ptr = &bio_queue;
+			goto next_bio;
 		}
+		*bio_end_queue_ptr = NULL;
 	}
+
+	local_irq_restore(flags);
+	preempt_enable();
 }
 EXPORT_SYMBOL(bio_endio);
 
Index: linux-3.14-rc8/include/linux/blk_types.h
===================================================================
--- linux-3.14-rc8.orig/include/linux/blk_types.h	2014-03-27 03:15:21.000000000 +0100
+++ linux-3.14-rc8/include/linux/blk_types.h	2014-03-27 03:23:43.000000000 +0100
@@ -65,7 +65,10 @@ struct bio {
 	unsigned int		bi_seg_front_size;
 	unsigned int		bi_seg_back_size;
 
-	atomic_t		bi_remaining;
+	union {
+		atomic_t	bi_remaining;
+		int		bi_error;
+	};
 
 	bio_end_io_t		*bi_end_io;
 
