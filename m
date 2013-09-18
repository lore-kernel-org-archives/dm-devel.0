From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH] dm-snapshot: workaround for a lockdep warning
Date: Wed, 18 Sep 2013 08:57:29 +0200
Message-ID: <52394ED9.5010308@redhat.com>
References: <alpine.LRH.2.02.1309171646050.550@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1309171920050.18335@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1309172006001.24061@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1309172006001.24061@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Stephen Boyd <sboyd@codeaurora.org>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Dne 18.9.2013 02:08, Mikulas Patocka napsal(a):
>
>
> On Tue, 17 Sep 2013, Mikulas Patocka wrote:
>
>> BTW. this patch is no longer needed on 3.11 because md->io_lock was
>> removed there, so the false lockdep warning doesn't happen.
>>
>> So we need to get this patch to stable trees 3.5 to 3.10, but not
>> upstream. How to push the patch there without pushing it upstream?
>>
>> Mikulas
>
> It's more complicated than that - the original Zdenek's report shows that
> the false warning happened on kernel "3.11.1-300.fc20.x86_64+debug". But I
> am not able to reproduce the bug on 3.11, I only reproduced it on 3.5-3.10
> kernels.
>
> Zdenek, could you reproduce the bug on kernel 3.11?
>
> Mikulas
>


Since I do not have clean 3.11 at my hands  - I've reproduced it with my -rc6 
kernel (few patches based on 8495e9c4a9616c9d19f23182d0536485902259db)
With enabled kmemleak=on lockdep.prove_locking=1 lockdep.lock_stat=1.


[  173.077483] device-mapper: snapshots: Invalidating snapshot: Unable to 
allocate exception.

[  173.077928] ======================================================
[  173.077930] [ INFO: possible circular locking dependency detected ]
[  173.077934] 3.11.0-rc6-00153-gf4c4c6a #160 Not tainted
[  173.077936] -------------------------------------------------------
[  173.077939] kworker/u4:3/50 is trying to acquire lock:
[  173.077941]  ((&req.work)){+.+...}, at: [<ffffffff81067915>] 
flush_work+0x5/0x60
[  173.077954]
but task is already holding lock:
[  173.077957]  (&s->lock){++++..}, at: [<ffffffffa0a71b3a>] 
snapshot_map+0x2aa/0x3a0 [dm_snapshot]
[  173.077968]
which lock already depends on the new lock.

[  173.077971]
the existing dependency chain (in reverse order) is:
[  173.077974]
-> #1 (&s->lock){++++..}:
[  173.077980]        [<ffffffff810bd5e3>] lock_acquire+0x93/0x200
[  173.077986]        [<ffffffff8158df60>] _raw_spin_lock+0x40/0x80
[  173.077991]        [<ffffffff815849b9>] __slab_alloc.constprop.67+0x141/0x50d
[  173.077996]        [<ffffffff8118bd42>] kmem_cache_alloc+0x252/0x290
[  173.078001]        [<ffffffff8119f969>] create_object+0x39/0x310
[  173.078006]        [<ffffffff8157e2ae>] kmemleak_alloc+0x4e/0xb0
[  173.078011]        [<ffffffff8118b8b5>] kmem_cache_alloc_trace+0x105/0x2a0
[  173.078015]        [<ffffffff8121c502>] sysfs_open_file+0x1e2/0x240
[  173.078021]        [<ffffffff811a232b>] do_dentry_open+0x1fb/0x290
[  173.078025]        [<ffffffff811a2400>] finish_open+0x40/0x50
[  173.078029]        [<ffffffff811b3c9a>] do_last+0x4ca/0xe00
[  173.078033]        [<ffffffff811b468e>] path_openat+0xbe/0x6f0
[  173.078037]        [<ffffffff811b539a>] do_filp_open+0x3a/0x90
[  173.078040]        [<ffffffff811a37ee>] do_sys_open+0x12e/0x210
[  173.078045]        [<ffffffff811a38ee>] SyS_open+0x1e/0x20
[  173.078049]        [<ffffffff81597106>] system_call_fastpath+0x1a/0x1f
[  173.078053]
-> #0 ((&req.work)){+.+...}:
[  173.078060]        [<ffffffff810bcac0>] __lock_acquire+0x1790/0x1af0
[  173.078063]        [<ffffffff810bd5e3>] lock_acquire+0x93/0x200
[  173.078067]        [<ffffffff81067946>] flush_work+0x36/0x60
[  173.078071]        [<ffffffffa0a72748>] chunk_io+0x118/0x150 [dm_snapshot]
[  173.078076]        [<ffffffffa0a727d9>] write_header+0x59/0x60 [dm_snapshot]
[  173.078081]        [<ffffffffa0a727f9>] persistent_drop_snapshot+0x19/0x30 
[dm_snapshot]
[  173.078086]        [<ffffffffa0a6fe9c>] 
__invalidate_snapshot.part.13+0x2c/0x70 [dm_snapshot]
[  173.078091]        [<ffffffffa0a719b7>] snapshot_map+0x127/0x3a0 [dm_snapshot]
[  173.078096]        [<ffffffffa0a4e7ee>] __map_bio+0x3e/0x1f0 [dm_mod]
[  173.078104]        [<ffffffffa0a4eb80>] 
__clone_and_map_data_bio+0x150/0x230 [dm_mod]
[  173.078109]        [<ffffffffa0a4f08c>] __split_and_process_bio+0x38c/0x5a0 
[dm_mod]
[  173.078115]        [<ffffffffa0a4f5a9>] dm_request+0x1b9/0x2f0 [dm_mod]
[  173.078121]        [<ffffffff813042b2>] generic_make_request+0xc2/0x110
[  173.078127]        [<ffffffff81304362>] submit_bio+0x62/0x130
[  173.078131]        [<ffffffff811e7ac8>] __mpage_writepage+0x448/0x680
[  173.078136]        [<ffffffff8114931b>] write_cache_pages+0x27b/0x630
[  173.078142]        [<ffffffff811e763a>] mpage_writepages+0x5a/0xa0
[  173.078146]        [<ffffffff812429d5>] ext2_writepages+0x15/0x20
[  173.078151]        [<ffffffff8114b081>] do_writepages+0x21/0x50
[  173.078155]        [<ffffffff811d27d0>] __writeback_single_inode+0x40/0x600
[  173.078160]        [<ffffffff811d3000>] writeback_sb_inodes+0x270/0x570
[  173.078164]        [<ffffffff811d339f>] __writeback_inodes_wb+0x9f/0xd0
[  173.078168]        [<ffffffff811d3743>] wb_writeback+0x373/0x5a0
[  173.078172]        [<ffffffff811d4094>] bdi_writeback_workfn+0x134/0x6d0
[  173.078176]        [<ffffffff8106993d>] process_one_work+0x1fd/0x6f0
[  173.078180]        [<ffffffff81069f53>] worker_thread+0x123/0x3b0
[  173.078184]        [<ffffffff81074a0e>] kthread+0xde/0xf0
[  173.078188]        [<ffffffff8159705c>] ret_from_fork+0x7c/0xb0
[  173.078192]
other info that might help us debug this:

[  173.078196]  Possible unsafe locking scenario:

[  173.078198]        CPU0                    CPU1
[  173.078200]        ----                    ----
[  173.078202]   lock(&s->lock);
[  173.078207]                                lock((&req.work));
[  173.078211]                                lock(&s->lock);
[  173.078215]   lock((&req.work));
[  173.078219]
  *** DEADLOCK ***

[  173.078222] 5 locks held by kworker/u4:3/50:
[  173.078225]  #0:  (writeback){++++.+}, at: [<ffffffff810698db>] 
process_one_work+0x19b/0x6f0
[  173.078233]  #1:  ((&(&wb->dwork)->work)){+.+.+.}, at: [<ffffffff810698db>] 
process_one_work+0x19b/0x6f0
[  173.078242]  #2:  (&type->s_umount_key#30){++++..}, at: 
[<ffffffff811a7f64>] grab_super_passive+0x44/0x90
[  173.078252]  #3:  (&md->io_barrier){.+.+..}, at: [<ffffffffa0a4f335>] 
dm_get_live_table+0x5/0xc0 [dm_mod]
[  173.078263]  #4:  (&s->lock){++++..}, at: [<ffffffffa0a71b3a>] 
snapshot_map+0x2aa/0x3a0 [dm_snapshot]
[  173.078273]
stack backtrace:
[  173.078277] CPU: 0 PID: 50 Comm: kworker/u4:3 Not tainted 
3.11.0-rc6-00153-gf4c4c6a #160
[  173.078280] Hardware name: LENOVO 6464CTO/6464CTO, BIOS 7LETC9WW (2.29 ) 
03/18/2011
[  173.078284] Workqueue: writeback bdi_writeback_workfn (flush-253:3)
[  173.078289]  ffffffff82369540 ffff8801305732f8 ffffffff815869ad 
ffffffff82369540
[  173.078295]  ffff880130573338 ffffffff815827ab ffff880130573390 
ffff880130ab4ef8
[  173.078301]  0000000000000004 ffff880130ab4ec0 ffff880130ab46e0 
ffff880130ab4ef8
[  173.078307] Call Trace:
[  173.078312]  [<ffffffff815869ad>] dump_stack+0x4e/0x82
[  173.078317]  [<ffffffff815827ab>] print_circular_bug+0x200/0x20f
[  173.078322]  [<ffffffff810bcac0>] __lock_acquire+0x1790/0x1af0
[  173.078326]  [<ffffffff810b78df>] ? trace_hardirqs_off_caller+0x1f/0xc0
[  173.078330]  [<ffffffff810b8089>] ? put_lock_stats.isra.27+0x29/0x40
[  173.078334]  [<ffffffff810bd5e3>] lock_acquire+0x93/0x200
[  173.078338]  [<ffffffff81067915>] ? flush_work+0x5/0x60
[  173.078342]  [<ffffffff81067946>] flush_work+0x36/0x60
[  173.078346]  [<ffffffff81067915>] ? flush_work+0x5/0x60
[  173.078351]  [<ffffffffa0a72748>] chunk_io+0x118/0x150 [dm_snapshot]
[  173.078357]  [<ffffffffa0a72600>] ? persistent_prepare_exception+0xa0/0xa0 
[dm_snapshot]
[  173.078363]  [<ffffffffa0a727d9>] write_header+0x59/0x60 [dm_snapshot]
[  173.078368]  [<ffffffffa0a727f9>] persistent_drop_snapshot+0x19/0x30 
[dm_snapshot]
[  173.078373]  [<ffffffffa0a6fe9c>] __invalidate_snapshot.part.13+0x2c/0x70 
[dm_snapshot]
[  173.078378]  [<ffffffffa0a719b7>] snapshot_map+0x127/0x3a0 [dm_snapshot]
[  173.078384]  [<ffffffffa0a4e7ee>] __map_bio+0x3e/0x1f0 [dm_mod]
[  173.078391]  [<ffffffffa0a4eb80>] __clone_and_map_data_bio+0x150/0x230 [dm_mod]
[  173.078397]  [<ffffffffa0a4f08c>] __split_and_process_bio+0x38c/0x5a0 [dm_mod]
[  173.078404]  [<ffffffffa0a4f5a9>] dm_request+0x1b9/0x2f0 [dm_mod]
[  173.078410]  [<ffffffffa0a4f425>] ? dm_request+0x35/0x2f0 [dm_mod]
[  173.078414]  [<ffffffff813042b2>] generic_make_request+0xc2/0x110
[  173.078419]  [<ffffffff81304362>] submit_bio+0x62/0x130
[  173.078423]  [<ffffffff811e7ac8>] __mpage_writepage+0x448/0x680
[  173.078429]  [<ffffffff81084c2d>] ? get_parent_ip+0xd/0x50
[  173.078433]  [<ffffffff810baddb>] ? mark_held_locks+0xbb/0x140
[  173.078438]  [<ffffffff8114906c>] ? clear_page_dirty_for_io+0xac/0xe0
[  173.078442]  [<ffffffff810baf75>] ? trace_hardirqs_on_caller+0x115/0x1e0
[  173.078446]  [<ffffffff8114931b>] write_cache_pages+0x27b/0x630
[  173.078450]  [<ffffffff810ba933>] ? check_irq_usage+0x83/0xc0
[  173.078455]  [<ffffffff811e7680>] ? mpage_writepages+0xa0/0xa0
[  173.078459]  [<ffffffff81243620>] ? ext2_get_blocks+0xa90/0xa90
[  173.078463]  [<ffffffff811e763a>] mpage_writepages+0x5a/0xa0
[  173.078467]  [<ffffffff81243620>] ? ext2_get_blocks+0xa90/0xa90
[  173.078472]  [<ffffffff812429d5>] ext2_writepages+0x15/0x20
[  173.078476]  [<ffffffff8114b081>] do_writepages+0x21/0x50
[  173.078481]  [<ffffffff811d27d0>] __writeback_single_inode+0x40/0x600
[  173.078485]  [<ffffffff811d3000>] writeback_sb_inodes+0x270/0x570
[  173.078489]  [<ffffffff811d339f>] __writeback_inodes_wb+0x9f/0xd0
[  173.078494]  [<ffffffff811d3743>] wb_writeback+0x373/0x5a0
[  173.078498]  [<ffffffff811d4094>] bdi_writeback_workfn+0x134/0x6d0
[  173.078503]  [<ffffffff810698db>] ? process_one_work+0x19b/0x6f0
[  173.078507]  [<ffffffff8106993d>] process_one_work+0x1fd/0x6f0
[  173.078511]  [<ffffffff810698db>] ? process_one_work+0x19b/0x6f0
[  173.078515]  [<ffffffff81069f53>] worker_thread+0x123/0x3b0
[  173.078519]  [<ffffffff81069e30>] ? process_one_work+0x6f0/0x6f0
[  173.078523]  [<ffffffff81074a0e>] kthread+0xde/0xf0
[  173.078529]  [<ffffffff81074930>] ? insert_kthread_work+0x70/0x70
[  173.078532]  [<ffffffff8159705c>] ret_from_fork+0x7c/0xb0
[  173.078537]  [<ffffffff81074930>] ? insert_kthread_work+0x70/0x70
[  173.120355] quiet_error: 1206 callbacks suppressed
[  173.120362] Buffer I/O error on device dm-3, logical block 34
