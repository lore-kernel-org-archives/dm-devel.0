From: Hans van Kranenburg <hans@knorrie.org>
Subject: Re: [dm-crypt] Dm-integrity freeze
Date: Tue, 21 May 2019 10:43:43 +0200
Message-ID: <2a12ef24-ab21-a9bb-af40-3743d0b8e2c7@knorrie.org>
References: <5D8A23C5-B6AD-48EA-B0AD-AD1BD1A2B97B@gmail.com>
	<9d19e5b1-b76f-27da-fa4a-f3a83e6e2791@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9d19e5b1-b76f-27da-fa4a-f3a83e6e2791@gmail.com>
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

I'm seeing the same lockup, also 4.19. This is mdadm RAID10 on top of 4x
a partition with only dm-integrity.

It just happened out of the blue, no heavy load or anything. All IO to
it is frozen now.

[777184.932426] INFO: task md127_raid10:507 blocked for more than 120
seconds.
[777184.932544]       Tainted: G        W         4.19.0-mx4-amd64 #1
Debian 4.19.28-2+mendix1
[777184.932666] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[777184.932788] md127_raid10    D    0   507      2 0x80000000
[777184.932791] Call Trace:
[777184.932801]  ? __schedule+0x2a2/0x870
[777184.932804]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[777184.932805]  schedule+0x28/0x80
[777184.932814]  md_super_wait+0x6e/0xa0 [md_mod]
[777184.932820]  ? finish_wait+0x80/0x80
[777184.932824]  write_page+0x172/0x320 [md_mod]
[777184.932826]  ? __schedule+0x2aa/0x870
[777184.932828]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[777184.932832]  md_update_sb.part.64+0x382/0x8f0 [md_mod]
[777184.932837]  md_check_recovery+0x148/0x540 [md_mod]
[777184.932841]  raid10d+0x62/0x1440 [raid10]
[777184.932843]  ? __switch_to_asm+0x34/0x70
[777184.932845]  ? finish_task_switch+0x78/0x260
[777184.932847]  ? _raw_spin_lock_irqsave+0x15/0x40
[777184.932850]  ? lock_timer_base+0x67/0x80
[777184.932852]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[777184.932854]  ? try_to_del_timer_sync+0x4d/0x80
[777184.932855]  ? del_timer_sync+0x35/0x40
[777184.932857]  ? schedule_timeout+0x173/0x390
[777184.932861]  ? md_rdev_init+0xb0/0xb0 [md_mod]
[777184.932864]  ? md_thread+0x94/0x150 [md_mod]
[777184.932866]  ? raid10_end_write_request+0x290/0x290 [raid10]
[777184.932869]  md_thread+0x94/0x150 [md_mod]
[777184.932872]  ? finish_wait+0x80/0x80
[777184.932873]  kthread+0x112/0x130
[777184.932875]  ? kthread_bind+0x30/0x30
[777184.932877]  ret_from_fork+0x35/0x40
[777184.932884] INFO: task 1.xvda-1:1657 blocked for more than 120 seconds.
[777184.932979]       Tainted: G        W         4.19.0-mx4-amd64 #1
Debian 4.19.28-2+mendix1
[777184.933101] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[777184.933222] 1.xvda-1        D    0  1657      2 0x80000000
[777184.933223] Call Trace:
[777184.933225]  ? __schedule+0x2a2/0x870
[777184.933227]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[777184.933228]  schedule+0x28/0x80
[777184.933232]  md_write_start+0x14b/0x220 [md_mod]
[777184.933234]  ? finish_wait+0x80/0x80
[777184.933236]  raid10_make_request+0x3d/0x130 [raid10]
[777184.933239]  ? finish_wait+0x80/0x80
[777184.933242]  md_handle_request+0x119/0x190 [md_mod]
[777184.933247]  md_make_request+0x78/0x160 [md_mod]
[777184.933251]  generic_make_request+0x1a4/0x410
[777184.933254]  ? bvec_alloc+0x51/0xe0
[777184.933256]  submit_bio+0x45/0x140
[777184.933258]  ? bio_add_page+0x48/0x60
[777184.933263]  dispatch_rw_block_io+0x68f/0x990 [xen_blkback]
[777184.933266]  ? branch_type+0x2e4/0x350
[777184.933269]  __do_block_io_op+0x2fc/0x5f0 [xen_blkback]
[777184.933271]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[777184.933272]  ? try_to_del_timer_sync+0x4d/0x80
[777184.933275]  xen_blkif_schedule+0xce/0x620 [xen_blkback]
[777184.933277]  ? finish_wait+0x80/0x80
[777184.933279]  ? xen_blkif_be_int+0x30/0x30 [xen_blkback]
[777184.933281]  kthread+0x112/0x130
[777184.933282]  ? kthread_bind+0x30/0x30
[777184.933283]  ret_from_fork+0x35/0x40
[777184.933293] INFO: task 11.xvda-0:14864 blocked for more than 120
seconds.
[777184.933387]       Tainted: G        W         4.19.0-mx4-amd64 #1
Debian 4.19.28-2+mendix1
[777184.933509] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[777184.933638] 11.xvda-0       D    0 14864      2 0x80000000
[777184.933640] Call Trace:
[777184.933642]  ? __schedule+0x2a2/0x870
[777184.933643]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[777184.933644]  schedule+0x28/0x80
[777184.933648]  md_write_start+0x14b/0x220 [md_mod]
[777184.933650]  ? finish_wait+0x80/0x80
[777184.933652]  raid10_make_request+0x3d/0x130 [raid10]
[777184.933654]  ? finish_wait+0x80/0x80
[777184.933658]  md_handle_request+0x119/0x190 [md_mod]
[777184.933662]  md_make_request+0x78/0x160 [md_mod]
[777184.933664]  generic_make_request+0x1a4/0x410
[777184.933666]  submit_bio+0x45/0x140
[777184.933668]  ? bio_add_page+0x48/0x60
[777184.933670]  dispatch_rw_block_io+0x68f/0x990 [xen_blkback]
[777184.933672]  ? branch_type+0x2e7/0x350
[777184.933674]  __do_block_io_op+0x2fc/0x5f0 [xen_blkback]
[777184.933676]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[777184.933678]  ? try_to_del_timer_sync+0x4d/0x80
[777184.933680]  xen_blkif_schedule+0xce/0x620 [xen_blkback]
[777184.933682]  ? __schedule+0x2aa/0x870
[777184.933684]  ? finish_wait+0x80/0x80
[777184.933686]  ? xen_blkif_be_int+0x30/0x30 [xen_blkback]
[777184.933687]  kthread+0x112/0x130
[777184.933688]  ? kthread_bind+0x30/0x30
[777184.933689]  ret_from_fork+0x35/0x40
[777184.933694] INFO: task btrfs-transacti:15468 blocked for more than
120 seconds.
[777184.933815]       Tainted: G        W         4.19.0-mx4-amd64 #1
Debian 4.19.28-2+mendix1
[777184.933937] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[777184.934058] btrfs-transacti D    0 15468      2 0x80000000
[777184.934059] Call Trace:
[777184.934061]  ? __schedule+0x2a2/0x870
[777184.934062]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[777184.934063]  schedule+0x28/0x80
[777184.934067]  md_write_start+0x14b/0x220 [md_mod]
[777184.934069]  ? finish_wait+0x80/0x80
[777184.934072]  raid10_make_request+0x3d/0x130 [raid10]
[777184.934074]  ? finish_wait+0x80/0x80
[777184.934077]  md_handle_request+0x119/0x190 [md_mod]
[777184.934081]  md_make_request+0x78/0x160 [md_mod]
[777184.934083]  generic_make_request+0x1a4/0x410
[777184.934085]  submit_bio+0x45/0x140
[777184.934086]  ? bio_clone_fast+0x2c/0x60
[777184.934119]  btrfs_map_bio+0x20a/0x350 [btrfs]
[777184.934136]  btree_submit_bio_hook+0x8d/0xc0 [btrfs]
[777184.934155]  submit_one_bio+0x5f/0x80 [btrfs]
[777184.934173]  flush_write_bio.isra.40+0x1d/0x30 [btrfs]
[777184.934191]  btree_write_cache_pages+0x243/0x360 [btrfs]
[777184.934210]  ? alloc_extent_state+0x1e/0xc0 [btrfs]
[777184.934226]  ? btrfs_buffer_uptodate+0x33/0x50 [btrfs]
[777184.934238]  ? read_block_for_search.isra.36+0xf2/0x340 [btrfs]
[777184.934241]  do_writepages+0x41/0xd0
[777184.934244]  ? __slab_alloc+0x27/0x30
[777184.934261]  ? merge_state.part.45+0x3f/0x130 [btrfs]
[777184.934262]  ? kmem_cache_alloc+0x15c/0x1c0
[777184.934279]  ? clear_state_bit+0xdb/0x180 [btrfs]
[777184.934281]  __filemap_fdatawrite_range+0xbe/0xf0
[777184.934298]  btrfs_write_marked_extents+0x68/0x150 [btrfs]
[777184.934314]  btrfs_write_and_wait_transaction.isra.21+0x4d/0xa0 [btrfs]
[777184.934331]  btrfs_commit_transaction+0x56c/0x870 [btrfs]
[777184.934347]  ? start_transaction+0x9d/0x3f0 [btrfs]
[777184.934362]  transaction_kthread+0x147/0x180 [btrfs]
[777184.934379]  ? btrfs_cleanup_transaction+0x530/0x530 [btrfs]
[777184.934380]  kthread+0x112/0x130
[777184.934381]  ? kthread_bind+0x30/0x30
[777184.934383]  ret_from_fork+0x35/0x40
[777184.934391] INFO: task kworker/1:3:16943 blocked for more than 120
seconds.
[777184.934487]       Tainted: G        W         4.19.0-mx4-amd64 #1
Debian 4.19.28-2+mendix1
[777184.934617] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[777184.934747] kworker/1:3     D    0 16943      2 0x80000000
[777184.934753] Workqueue: dm-integrity-metadata integrity_bio_wait
[dm_integrity]
[777184.934754] Call Trace:
[777184.934756]  ? __schedule+0x2a2/0x870
[777184.934757]  schedule+0x28/0x80
[777184.934760]  io_schedule+0x12/0x40
[777184.934763]  wait_and_add_new_range+0x89/0xa0 [dm_integrity]
[777184.934766]  dm_integrity_map_continue+0xe71/0x1020 [dm_integrity]
[777184.934769]  ? xen_load_sp0+0x77/0x170
[777184.934771]  ? __switch_to+0x1e1/0x440
[777184.934773]  ? finish_task_switch+0x78/0x260
[777184.934775]  process_one_work+0x1a7/0x3a0
[777184.934777]  worker_thread+0x30/0x390
[777184.934779]  ? create_worker+0x1a0/0x1a0
[777184.934781]  kthread+0x112/0x130
[777184.934782]  ? kthread_bind+0x30/0x30
[777184.934783]  ret_from_fork+0x35/0x40
[777184.934787] INFO: task kworker/0:8:17282 blocked for more than 120
seconds.
[777184.934882]       Tainted: G        W         4.19.0-mx4-amd64 #1
Debian 4.19.28-2+mendix1
[777184.935005] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[777184.935125] kworker/0:8     D    0 17282      2 0x80000000
[777184.935129] Workqueue: dm-integrity-metadata integrity_bio_wait
[dm_integrity]
[777184.935130] Call Trace:
[777184.935132]  ? __schedule+0x2a2/0x870
[777184.935133]  schedule+0x28/0x80
[777184.935135]  io_schedule+0x12/0x40
[777184.935137]  wait_and_add_new_range+0x89/0xa0 [dm_integrity]
[777184.935139]  dm_integrity_map_continue+0xe71/0x1020 [dm_integrity]
[777184.935141]  ? xen_load_sp0+0x77/0x170
[777184.935143]  ? __switch_to+0x1e1/0x440
[777184.935144]  ? finish_task_switch+0x78/0x260
[777184.935146]  process_one_work+0x1a7/0x3a0
[777184.935148]  worker_thread+0x30/0x390
[777184.935149]  ? create_worker+0x1a0/0x1a0
[777184.935150]  kthread+0x112/0x130
[777184.935151]  ? kthread_bind+0x30/0x30
[777184.935153]  ret_from_fork+0x35/0x40
[777184.935156] INFO: task kworker/u8:9:17284 blocked for more than 120
seconds.
[777184.935251]       Tainted: G        W         4.19.0-mx4-amd64 #1
Debian 4.19.28-2+mendix1
[777184.935373] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[777184.935494] kworker/u8:9    D    0 17284      2 0x80000000
[777184.935515] Workqueue: btrfs-submit btrfs_submit_helper [btrfs]
[777184.935515] Call Trace:
[777184.935517]  ? __schedule+0x2a2/0x870
[777184.935519]  ? _raw_spin_unlock_irqrestore+0x14/0x20
[777184.935520]  schedule+0x28/0x80
[777184.935525]  md_write_start+0x14b/0x220 [md_mod]
[777184.935527]  ? finish_wait+0x80/0x80
[777184.935529]  raid10_make_request+0x3d/0x130 [raid10]
[777184.935531]  ? finish_wait+0x80/0x80
[777184.935535]  md_handle_request+0x119/0x190 [md_mod]
[777184.935539]  md_make_request+0x78/0x160 [md_mod]
[777184.935541]  generic_make_request+0x1a4/0x410
[777184.935544]  submit_bio+0x45/0x140
[777184.935562]  run_scheduled_bios+0x18e/0x440 [btrfs]
[777184.935581]  normal_work_helper+0xba/0x300 [btrfs]
[777184.935584]  process_one_work+0x1a7/0x3a0
[777184.935586]  worker_thread+0x30/0x390
[777184.935587]  ? create_worker+0x1a0/0x1a0
[777184.935588]  kthread+0x112/0x130
[777184.935589]  ? kthread_bind+0x30/0x30
[777184.935591]  ret_from_fork+0x35/0x40
[777184.935593] INFO: task kworker/1:13:17315 blocked for more than 120
seconds.
[777184.935713]       Tainted: G        W         4.19.0-mx4-amd64 #1
Debian 4.19.28-2+mendix1
[777184.935836] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[777184.935957] kworker/1:13    D    0 17315      2 0x80000000
[777184.935960] Workqueue: dm-integrity-metadata integrity_bio_wait
[dm_integrity]
[777184.935961] Call Trace:
[777184.935963]  ? __schedule+0x2a2/0x870
[777184.935965]  schedule+0x28/0x80
[777184.935967]  io_schedule+0x12/0x40
[777184.935969]  wait_and_add_new_range+0x89/0xa0 [dm_integrity]
[777184.935971]  dm_integrity_map_continue+0xe71/0x1020 [dm_integrity]
[777184.935973]  ? xen_load_sp0+0x77/0x170
[777184.935975]  ? __switch_to+0x1e1/0x440
[777184.935976]  ? finish_task_switch+0x78/0x260
[777184.935978]  process_one_work+0x1a7/0x3a0
[777184.935980]  worker_thread+0x30/0x390
[777184.935981]  ? create_worker+0x1a0/0x1a0
[777184.935982]  kthread+0x112/0x130
[777184.935983]  ? kthread_bind+0x30/0x30
[777184.935985]  ret_from_fork+0x35/0x40
[777184.935988] INFO: task kworker/0:20:17330 blocked for more than 120
seconds.
[777184.936083]       Tainted: G        W         4.19.0-mx4-amd64 #1
Debian 4.19.28-2+mendix1
[777184.936205] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[777184.936355] kworker/0:20    D    0 17330      2 0x80000000
[777184.936359] Workqueue: dm-integrity-metadata integrity_bio_wait
[dm_integrity]
[777184.936360] Call Trace:
[777184.936363]  ? __schedule+0x2a2/0x870
[777184.936364]  schedule+0x28/0x80
[777184.936366]  io_schedule+0x12/0x40
[777184.936368]  wait_and_add_new_range+0x89/0xa0 [dm_integrity]
[777184.936370]  dm_integrity_map_continue+0xe71/0x1020 [dm_integrity]
[777184.936373]  ? xen_load_sp0+0x77/0x170
[777184.936374]  ? __switch_to+0x1e1/0x440
[777184.936375]  ? finish_task_switch+0x78/0x260
[777184.936377]  process_one_work+0x1a7/0x3a0
[777184.936379]  worker_thread+0x30/0x390
[777184.936381]  ? create_worker+0x1a0/0x1a0
[777184.936382]  kthread+0x112/0x130
[777184.936383]  ? kthread_bind+0x30/0x30
[777184.936385]  ret_from_fork+0x35/0x40
[777184.936390] INFO: task kworker/1:23:17371 blocked for more than 120
seconds.
[777184.936500]       Tainted: G        W         4.19.0-mx4-amd64 #1
Debian 4.19.28-2+mendix1
[777184.936625] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[777184.936762] kworker/1:23    D    0 17371      2 0x80000000
[777184.936775] Workqueue: dm-integrity-metadata integrity_bio_wait
[dm_integrity]
[777184.936786] Call Trace:
[777184.936791]  ? __schedule+0x2a2/0x870
[777184.936798]  schedule+0x28/0x80
[777184.936805]  io_schedule+0x12/0x40
[777184.936812]  wait_and_add_new_range+0x89/0xa0 [dm_integrity]
[777184.936819]  dm_integrity_map_continue+0xe71/0x1020 [dm_integrity]
[777184.936828]  ? xen_load_sp0+0x77/0x170
[777184.936834]  ? __switch_to+0x1e1/0x440
[777184.936842]  ? finish_task_switch+0x78/0x260
[777184.936849]  process_one_work+0x1a7/0x3a0
[777184.936856]  worker_thread+0x30/0x390
[777184.936862]  ? create_worker+0x1a0/0x1a0
[777184.936868]  kthread+0x112/0x130
[777184.936875]  ? kthread_bind+0x30/0x30
[777184.936880]  ret_from_fork+0x35/0x40

Hans

On 3/7/19 5:37 PM, Milan Broz wrote:
> Hi,
> =

> from the full log it seems that it is stuck in tgtd (iSCSI).
> =

> Anyway, this is device-mapper, dm-devel is better list here.
> (added to cc + Mikulas)
> =

> m.
> =

> On 3/7/19 4:26 PM, Victor Helmholtz wrote:
>> Hi
>>
>> I have recently had a problem with my server: all writes to RAID drives =
were frozen and I had to force-reboot it. I looked at kernel logs and I thi=
nk dm-integrity might be source of the problem. Could anyone help me unders=
tand meaning of following messages (this message was repeated 8 times, full=
 kernel log is here: https://pastebin.com/DMgMtNJq ):
>>
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.498048] INFO: task=
 kworker/0:112:26760 blocked for more than 120 seconds.
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.499784] =A0 =A0 =
=A0 Not tainted 4.19.0-2-amd64 #1 Debian 4.19.16-1
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.501222] "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.503095] kworker/0:=
112 =A0 D =A0 =A00 26760 =A0 =A0 =A02 0x80000080
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.504424] Workqueue:=
 dm-integrity-metadata integrity_bio_wait [dm_integrity]
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.506149] Call Trace:
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.506782] =A0? __sch=
edule+0x2a2/0x870
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.507706] =A0schedul=
e+0x28/0x80
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.508484] =A0io_sche=
dule+0x12/0x40
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.509321] =A0wait_an=
d_add_new_range+0x89/0xa0 [dm_integrity]
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.510709] =A0dm_inte=
grity_map_continue+0xe71/0x1020 [dm_integrity]
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.512193] =A0? __swi=
tch_to_asm+0x40/0x70
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.513149] =A0? __swi=
tch_to_asm+0x34/0x70
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.514105] =A0? __swi=
tch_to_asm+0x40/0x70
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.515088] =A0? __swi=
tch_to_asm+0x40/0x70
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.516048] =A0? __swi=
tch_to_asm+0x34/0x70
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.517000] =A0? __swi=
tch_to_asm+0x40/0x70
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.517978] =A0? __swi=
tch_to_asm+0x34/0x70
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.518968] =A0? __swi=
tch_to_asm+0x34/0x70
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.519926] =A0? __swi=
tch_to+0x8c/0x440
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.520822] =A0process=
_one_work+0x1a7/0x3a0
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.521798] =A0worker_=
thread+0x30/0x390
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.522725] =A0? pwq_u=
nbound_release_workfn+0xd0/0xd0
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.523901] =A0kthread=
+0x112/0x130
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.524691] =A0? kthre=
ad_bind+0x30/0x30
>> Mar =A01 23:48:21 unassigned-hostname kernel: [369732.525584] =A0ret_fro=
m_fork+0x35/0x40
>>
>> Is this a bug in kernel or do I have some problems with hardware?
