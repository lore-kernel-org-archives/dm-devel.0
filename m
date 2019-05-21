From: Hans van Kranenburg <hans@knorrie.org>
Subject: Re: [dm-crypt] Dm-integrity freeze
Date: Tue, 21 May 2019 22:33:30 +0200
Message-ID: <33d155ac-9b09-c8b0-3df1-88063dac964f@knorrie.org>
References: <5D8A23C5-B6AD-48EA-B0AD-AD1BD1A2B97B@gmail.com>
	<9d19e5b1-b76f-27da-fa4a-f3a83e6e2791@gmail.com>
	<2a12ef24-ab21-a9bb-af40-3743d0b8e2c7@knorrie.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2a12ef24-ab21-a9bb-af40-3743d0b8e2c7@knorrie.org>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>, Victor Helmholtz <victor.helmholtz@gmail.com>, dm-crypt@saout.de
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hi,

On 5/21/19 10:43 AM, Hans van Kranenburg wrote:
> Hi,
> 
> I'm seeing the same lockup, also 4.19. This is mdadm RAID10 on top of 4x
> a partition with only dm-integrity.
> 
> It just happened out of the blue, no heavy load or anything. All IO to
> it is frozen now.
> 
> [...]

There it is again... dmesg dump below. All cpus on 100% iowait.

It's triggered after a few minutes by running some Windows 2019 server
install (ugh, don't ask) in a Xen HVM domU, which writes into a raw
sparse file on a btrfs filesystem on LVM on mdadm RAID10 on 4x
dm-integrity (wheeee!!)...

This morning it was triggered a few minutes after starting an old
windows 2008 server image that I copied to this machine.

When running only other Linux vms, and when copying data onto
filesystems that live in LVM logical volumes I haven't seen this problem
yet, at all, in the last few weeks that this machine is running.

I noticed there's a "dm integrity: fix deadlock with overlapping I/O"
fix in a later 4.19. Is there any chance this is related? I have no
idea, but any hints or suggestions about what to try would be appreciated.

Right now, I still have the opportunity to stop the migration and keep
using the previous hardware for some days, having the possibility to
reproduce this a few times and try things, if you want.

If not, I likely have to go try remove the dm-integrity layer, but I'd
rather help fixing this issue.

Thanks,

[37218.238621] INFO: task md127_raid10:485 blocked for more than 120
seconds.
[37218.238713]       Not tainted 4.19.0-mx4-amd64 #1 Debian
4.19.28-2+mendix1
[37218.238782] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[37218.238856] md127_raid10    D    0   485      2 0x80000000
[37218.238859] Call Trace:
[37218.238868]  ? __schedule+0x2a2/0x870
[37218.238871]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[37218.238872]  schedule+0x28/0x80
[37218.238882]  md_super_wait+0x6e/0xa0 [md_mod]
[37218.238887]  ? finish_wait+0x80/0x80
[37218.238892]  write_page+0x172/0x320 [md_mod]
[37218.238894]  ? __schedule+0x2aa/0x870
[37218.238895]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[37218.238900]  md_update_sb.part.64+0x382/0x8f0 [md_mod]
[37218.238904]  md_check_recovery+0x148/0x540 [md_mod]
[37218.238907]  raid10d+0x62/0x1440 [raid10]
[37218.238910]  ? __switch_to_asm+0x34/0x70
[37218.238912]  ? finish_task_switch+0x78/0x260
[37218.238914]  ? _raw_spin_lock_irqsave+0x15/0x40
[37218.238917]  ? lock_timer_base+0x67/0x80
[37218.238918]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[37218.238920]  ? try_to_del_timer_sync+0x4d/0x80
[37218.238922]  ? del_timer_sync+0x35/0x40
[37218.238923]  ? schedule_timeout+0x173/0x390
[37218.238927]  ? md_rdev_init+0xb0/0xb0 [md_mod]
[37218.238930]  ? md_thread+0x94/0x150 [md_mod]
[37218.238932]  ? raid10_end_write_request+0x290/0x290 [raid10]
[37218.238936]  md_thread+0x94/0x150 [md_mod]
[37218.238938]  ? finish_wait+0x80/0x80
[37218.238940]  kthread+0x112/0x130
[37218.238941]  ? kthread_bind+0x30/0x30
[37218.238943]  ret_from_fork+0x35/0x40
[37218.238951] INFO: task btrfs-transacti:575 blocked for more than 120
seconds.
[37218.239023]       Not tainted 4.19.0-mx4-amd64 #1 Debian
4.19.28-2+mendix1
[37218.239092] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[37218.239164] btrfs-transacti D    0   575      2 0x80000000
[37218.239166] Call Trace:
[37218.239168]  ? __schedule+0x2a2/0x870
[37218.239169]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[37218.239171]  schedule+0x28/0x80
[37218.239175]  md_write_start+0x14b/0x220 [md_mod]
[37218.239177]  ? finish_wait+0x80/0x80
[37218.239179]  raid10_make_request+0x3d/0x130 [raid10]
[37218.239181]  ? finish_wait+0x80/0x80
[37218.239185]  md_handle_request+0x119/0x190 [md_mod]
[37218.239189]  md_make_request+0x78/0x160 [md_mod]
[37218.239192]  generic_make_request+0x1a4/0x410
[37218.239195]  submit_bio+0x45/0x140
[37218.239196]  ? bio_clone_fast+0x2c/0x60
[37218.239228]  btrfs_map_bio+0x20a/0x350 [btrfs]
[37218.239246]  btree_submit_bio_hook+0x8d/0xc0 [btrfs]
[37218.239264]  submit_one_bio+0x5f/0x80 [btrfs]
[37218.239283]  flush_write_bio.isra.40+0x1d/0x30 [btrfs]
[37218.239301]  btree_write_cache_pages+0x243/0x360 [btrfs]
[37218.239318]  ? btrfs_buffer_uptodate+0x33/0x50 [btrfs]
[37218.239331]  ? read_block_for_search.isra.36+0xf2/0x340 [btrfs]
[37218.239333]  do_writepages+0x41/0xd0
[37218.239351]  ? merge_state.part.45+0x3f/0x130 [btrfs]
[37218.239353]  ? kmem_cache_alloc+0x15c/0x1c0
[37218.239370]  ? clear_state_bit+0xdb/0x180 [btrfs]
[37218.239372]  __filemap_fdatawrite_range+0xbe/0xf0
[37218.239388]  btrfs_write_marked_extents+0x68/0x150 [btrfs]
[37218.239405]  btrfs_write_and_wait_transaction.isra.21+0x4d/0xa0 [btrfs]
[37218.239421]  btrfs_commit_transaction+0x56c/0x870 [btrfs]
[37218.239437]  ? start_transaction+0x9d/0x3f0 [btrfs]
[37218.239453]  transaction_kthread+0x147/0x180 [btrfs]
[37218.239468]  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
[37218.239470]  kthread+0x112/0x130
[37218.239471]  ? kthread_bind+0x30/0x30
[37218.239473]  ret_from_fork+0x35/0x40
[37218.239481] INFO: task 1.xvda-1:1820 blocked for more than 120 seconds.
[37218.239551]       Not tainted 4.19.0-mx4-amd64 #1 Debian
4.19.28-2+mendix1
[37218.239620] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[37218.239692] 1.xvda-1        D    0  1820      2 0x80000000
[37218.239694] Call Trace:
[37218.239696]  ? __schedule+0x2a2/0x870
[37218.239698]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[37218.239699]  schedule+0x28/0x80
[37218.239703]  md_write_start+0x14b/0x220 [md_mod]
[37218.239706]  ? finish_wait+0x80/0x80
[37218.239708]  raid10_make_request+0x3d/0x130 [raid10]
[37218.239710]  ? finish_wait+0x80/0x80
[37218.239713]  md_handle_request+0x119/0x190 [md_mod]
[37218.239718]  md_make_request+0x78/0x160 [md_mod]
[37218.239720]  generic_make_request+0x1a4/0x410
[37218.239723]  ? bvec_alloc+0x51/0xe0
[37218.239725]  submit_bio+0x45/0x140
[37218.239727]  ? bio_add_page+0x48/0x60
[37218.239731]  dispatch_rw_block_io+0x68f/0x990 [xen_blkback]
[37218.239734]  ? branch_type+0x2e4/0x350
[37218.239737]  __do_block_io_op+0x2fc/0x5f0 [xen_blkback]
[37218.239739]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[37218.239740]  ? try_to_del_timer_sync+0x4d/0x80
[37218.239743]  xen_blkif_schedule+0xce/0x620 [xen_blkback]
[37218.239745]  ? finish_wait+0x80/0x80
[37218.239748]  ? xen_blkif_be_int+0x30/0x30 [xen_blkback]
[37218.239749]  kthread+0x112/0x130
[37218.239750]  ? kthread_bind+0x30/0x30
[37218.239751]  ret_from_fork+0x35/0x40
[37218.239757] INFO: task 2.xvda-0:2125 blocked for more than 120 seconds.
[37218.239825]       Not tainted 4.19.0-mx4-amd64 #1 Debian
4.19.28-2+mendix1
[37218.239894] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[37218.239967] 2.xvda-0        D    0  2125      2 0x80000000
[37218.239968] Call Trace:
[37218.239970]  ? __schedule+0x2a2/0x870
[37218.239971]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[37218.239972]  schedule+0x28/0x80
[37218.239977]  md_write_start+0x14b/0x220 [md_mod]
[37218.239979]  ? finish_wait+0x80/0x80
[37218.239981]  raid10_make_request+0x3d/0x130 [raid10]
[37218.239983]  ? finish_wait+0x80/0x80
[37218.239986]  md_handle_request+0x119/0x190 [md_mod]
[37218.239990]  md_make_request+0x78/0x160 [md_mod]
[37218.239992]  generic_make_request+0x1a4/0x410
[37218.239994]  submit_bio+0x45/0x140
[37218.239996]  ? bio_add_page+0x48/0x60
[37218.239998]  dispatch_rw_block_io+0x68f/0x990 [xen_blkback]
[37218.240001]  ? branch_type+0x2e7/0x350
[37218.240003]  __do_block_io_op+0x2fc/0x5f0 [xen_blkback]
[37218.240005]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[37218.240006]  ? try_to_del_timer_sync+0x4d/0x80
[37218.240009]  xen_blkif_schedule+0xce/0x620 [xen_blkback]
[37218.240010]  ? __schedule+0x2aa/0x870
[37218.240012]  ? finish_wait+0x80/0x80
[37218.240014]  ? xen_blkif_be_int+0x30/0x30 [xen_blkback]
[37218.240015]  kthread+0x112/0x130
[37218.240016]  ? kthread_bind+0x30/0x30
[37218.240018]  ret_from_fork+0x35/0x40
[37218.240021] INFO: task qemu-system-i38:6225 blocked for more than 120
seconds.
[37218.240092]       Not tainted 4.19.0-mx4-amd64 #1 Debian
4.19.28-2+mendix1
[37218.240161] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[37218.240258] qemu-system-i38 D    0  6225      1 0x00000000
[37218.240260] Call Trace:
[37218.240262]  ? __schedule+0x2a2/0x870
[37218.240263]  schedule+0x28/0x80
[37218.240266]  io_schedule+0x12/0x40
[37218.240267]  wait_on_page_bit+0x114/0x150
[37218.240269]  ? page_cache_tree_insert+0xe0/0xe0
[37218.240288]  extent_write_cache_pages+0x33e/0x3e0 [btrfs]
[37218.240292]  ? timerqueue_del+0x1e/0x40
[37218.240293]  ? __remove_hrtimer+0x35/0x70
[37218.240311]  extent_writepages+0x50/0x80 [btrfs]
[37218.240314]  do_writepages+0x41/0xd0
[37218.240315]  ? __hrtimer_init+0xb0/0xb0
[37218.240317]  __filemap_fdatawrite_range+0xbe/0xf0
[37218.240334]  start_ordered_ops+0x4c/0x90 [btrfs]
[37218.240352]  btrfs_sync_file+0x9a/0x3d0 [btrfs]
[37218.240357]  do_fsync+0x38/0x70
[37218.240359]  __x64_sys_fdatasync+0x13/0x20
[37218.240361]  do_syscall_64+0x53/0x100
[37218.240364]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[37218.240366] RIP: 0033:0x7f2c4484f2e7
[37218.240373] Code: Bad RIP value.
[37218.240374] RSP: 002b:00007f2c40c24560 EFLAGS: 00000293 ORIG_RAX:
000000000000004b
[37218.240376] RAX: ffffffffffffffda RBX: 000000000000001c RCX:
00007f2c4484f2e7
[37218.240377] RDX: 0000000000000000 RSI: 0000000000000008 RDI:
000000000000001c
[37218.240378] RBP: 000055f297129ea0 R08: 0000000000000000 R09:
00000000ffffffff
[37218.240379] R10: 00007f2c40c24660 R11: 0000000000000293 R12:
000055f2964b06e0
[37218.240380] R13: 000055f2970ea078 R14: 000055f2974aa920 R15:
000055f297d92ab0
[37218.240383] INFO: task kworker/1:2:4661 blocked for more than 120
seconds.
[37218.240478]       Not tainted 4.19.0-mx4-amd64 #1 Debian
4.19.28-2+mendix1
[37218.240580] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[37218.240701] kworker/1:2     D    0  4661      2 0x80000000
[37218.240708] Workqueue: dm-integrity-metadata integrity_bio_wait
[dm_integrity]
[37218.240709] Call Trace:
[37218.240711]  ? __schedule+0x2a2/0x870
[37218.240713]  schedule+0x28/0x80
[37218.240715]  io_schedule+0x12/0x40
[37218.240717]  wait_and_add_new_range+0x89/0xa0 [dm_integrity]
[37218.240719]  dm_integrity_map_continue+0xe71/0x1020 [dm_integrity]
[37218.240723]  ? xen_load_sp0+0x77/0x170
[37218.240725]  ? __switch_to+0x1e1/0x440
[37218.240727]  ? finish_task_switch+0x78/0x260
[37218.240730]  process_one_work+0x1a7/0x3a0
[37218.240732]  worker_thread+0x30/0x390
[37218.240734]  ? create_worker+0x1a0/0x1a0
[37218.240735]  kthread+0x112/0x130
[37218.240736]  ? kthread_bind+0x30/0x30
[37218.240738]  ret_from_fork+0x35/0x40
[37218.240741] INFO: task kworker/1:11:4887 blocked for more than 120
seconds.
[37218.240836]       Not tainted 4.19.0-mx4-amd64 #1 Debian
4.19.28-2+mendix1
[37218.240929] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[37218.241050] kworker/1:11    D    0  4887      2 0x80000000
[37218.241053] Workqueue: dm-integrity-metadata integrity_bio_wait
[dm_integrity]
[37218.241054] Call Trace:
[37218.241056]  ? __schedule+0x2a2/0x870
[37218.241058]  schedule+0x28/0x80
[37218.241059]  io_schedule+0x12/0x40
[37218.241061]  wait_and_add_new_range+0x89/0xa0 [dm_integrity]
[37218.241063]  dm_integrity_map_continue+0xe71/0x1020 [dm_integrity]
[37218.241065]  ? xen_load_sp0+0x77/0x170
[37218.241067]  ? __switch_to+0x1e1/0x440
[37218.241068]  ? finish_task_switch+0x78/0x260
[37218.241070]  process_one_work+0x1a7/0x3a0
[37218.241072]  worker_thread+0x30/0x390
[37218.241073]  ? create_worker+0x1a0/0x1a0
[37218.241074]  kthread+0x112/0x130
[37218.241075]  ? kthread_bind+0x30/0x30
[37218.241077]  ret_from_fork+0x35/0x40
[37218.241082] INFO: task kworker/0:19:5061 blocked for more than 120
seconds.
[37218.241176]       Not tainted 4.19.0-mx4-amd64 #1 Debian
4.19.28-2+mendix1
[37218.241270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[37218.241391] kworker/0:19    D    0  5061      2 0x80000000
[37218.241394] Workqueue: dm-integrity-metadata integrity_bio_wait
[dm_integrity]
[37218.241395] Call Trace:
[37218.241397]  ? __schedule+0x2a2/0x870
[37218.241398]  schedule+0x28/0x80
[37218.241400]  io_schedule+0x12/0x40
[37218.241402]  wait_and_add_new_range+0x89/0xa0 [dm_integrity]
[37218.241404]  dm_integrity_map_continue+0xe71/0x1020 [dm_integrity]
[37218.241406]  ? xen_load_sp0+0x77/0x170
[37218.241407]  ? __switch_to+0x1e1/0x440
[37218.241408]  ? finish_task_switch+0x78/0x260
[37218.241410]  process_one_work+0x1a7/0x3a0
[37218.241412]  worker_thread+0x30/0x390
[37218.241414]  ? create_worker+0x1a0/0x1a0
[37218.241415]  kthread+0x112/0x130
[37218.241416]  ? kthread_bind+0x30/0x30
[37218.241417]  ret_from_fork+0x35/0x40
[37218.241420] INFO: task kworker/1:3:5090 blocked for more than 120
seconds.
[37218.241514]       Not tainted 4.19.0-mx4-amd64 #1 Debian
4.19.28-2+mendix1
[37218.241616] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[37218.241737] kworker/1:3     D    0  5090      2 0x80000000
[37218.241740] Workqueue: dm-integrity-metadata integrity_bio_wait
[dm_integrity]
[37218.241740] Call Trace:
[37218.241742]  ? __schedule+0x2a2/0x870
[37218.241744]  schedule+0x28/0x80
[37218.241745]  io_schedule+0x12/0x40
[37218.241747]  wait_and_add_new_range+0x89/0xa0 [dm_integrity]
[37218.241749]  dm_integrity_map_continue+0xe71/0x1020 [dm_integrity]
[37218.241751]  ? xen_load_sp0+0x77/0x170
[37218.241752]  ? __switch_to+0x1e1/0x440
[37218.241753]  ? finish_task_switch+0x78/0x260
[37218.241755]  process_one_work+0x1a7/0x3a0
[37218.241757]  worker_thread+0x30/0x390
[37218.241758]  ? create_worker+0x1a0/0x1a0
[37218.241759]  kthread+0x112/0x130
[37218.241760]  ? kthread_bind+0x30/0x30
[37218.241762]  ret_from_fork+0x35/0x40
[37218.241764] INFO: task kworker/1:10:5264 blocked for more than 120
seconds.
[37218.241859]       Not tainted 4.19.0-mx4-amd64 #1 Debian
4.19.28-2+mendix1
[37218.241952] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[37218.242073] kworker/1:10    D    0  5264      2 0x80000000
[37218.242076] Workqueue: dm-integrity-metadata integrity_bio_wait
[dm_integrity]
[37218.242077] Call Trace:
[37218.242079]  ? __schedule+0x2a2/0x870
[37218.242080]  schedule+0x28/0x80
[37218.242082]  io_schedule+0x12/0x40
[37218.242083]  wait_and_add_new_range+0x89/0xa0 [dm_integrity]
[37218.242085]  dm_integrity_map_continue+0xe71/0x1020 [dm_integrity]
[37218.242088]  ? xen_load_sp0+0x77/0x170
[37218.242089]  ? __switch_to+0x1e1/0x440
[37218.242090]  ? finish_task_switch+0x78/0x260
[37218.242092]  process_one_work+0x1a7/0x3a0
[37218.242094]  worker_thread+0x30/0x390
[37218.242095]  ? create_worker+0x1a0/0x1a0
[37218.242096]  kthread+0x112/0x130
[37218.242097]  ? kthread_bind+0x30/0x30
[37218.242099]  ret_from_fork+0x35/0x40
