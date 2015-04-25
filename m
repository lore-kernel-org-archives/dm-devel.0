From: Christoph Hellwig <hch@infradead.org>
Subject: CONFIG_DM_MQ_DEFAULT makes my kernel unhappy..
Date: Sat, 25 Apr 2015 02:23:58 -0700
Message-ID: <20150425092358.GA15550@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Running dm-mpath against a tcm_loop target with two ALUA paths makes
the kernel very unhappy when CONFIG_DM_MQ_DEFAULT is set.  Without it
it's perfectly happy.

[   12.865522] ------------[ cut here ]------------
[   12.866119] WARNING: CPU: 0 PID: 3736 at ../lib/debugobjects.c:263 debug_print_object+0x8c/0xb0()
[   12.866679] ODEBUG: init active (active state 0) object type: timer_list hint: blk_mq_rq_timer+0x0/0x100
[   12.866679] Modules linked in:
[   12.866679] CPU: 0 PID: 3736 Comm: multipathd Not tainted 4.0.0+ #335
[   12.866679] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   12.866679]  ffffffff822b7186 ffff88007887b9e8 ffffffff81dfff1f 0000000000000000
[   12.866679]  ffff88007887ba38 ffff88007887ba28 ffffffff810c4dc2 0000000000000000
[   12.866679]  ffff88007b554b88 ffffffff82427f80 ffffffff823606cd 00000000000316c0
[   12.866679] Call Trace:
[   12.866679]  [<ffffffff81dfff1f>] dump_stack+0x45/0x57
[   12.866679]  [<ffffffff810c4dc2>] warn_slowpath_common+0x92/0xd0
[   12.866679]  [<ffffffff810c4ea1>] warn_slowpath_fmt+0x41/0x50
[   12.866679]  [<ffffffff817dcaac>] debug_print_object+0x8c/0xb0
[   12.866679]  [<ffffffff817a02a0>] ? blk_mq_free_request+0x40/0x40
[   12.866679]  [<ffffffff817dcbdc>] ? __debug_object_init+0x5c/0x430
[   12.866679]  [<ffffffff817dcdd3>] __debug_object_init+0x253/0x430
[   12.866679]  [<ffffffff817dcfcb>] debug_object_init+0x1b/0x20
[   12.866679]  [<ffffffff81131654>] init_timer_key+0x34/0xa0
[   12.866679]  [<ffffffff817a2b88>] blk_mq_init_allocated_queue+0x1b8/0x8f0
[   12.866679]  [<ffffffff81c7b6ef>] dm_setup_md_queue+0x1bf/0x2f0
[   12.866679]  [<ffffffff81c81060>] table_load+0x1b0/0x340
[   12.866679]  [<ffffffff81c80eb0>] ? table_clear+0xd0/0xd0
[   12.866679]  [<ffffffff81c81e2a>] ctl_ioctl+0x25a/0x4f0
[   12.866679]  [<ffffffff8110bf00>] ? match_held_lock+0x160/0x1f0
[   12.866679]  [<ffffffff81c820ce>] dm_ctl_ioctl+0xe/0x20
[   12.866679]  [<ffffffff811f2dc3>] do_vfs_ioctl+0x83/0x5b0
[   12.866679]  [<ffffffff811fe761>] ? __fget+0xb1/0x1e0
[   12.866679]  [<ffffffff811fe6b0>] ? put_unused_fd+0x60/0x60
[   12.866679]  [<ffffffff811fe8d5>] ? __fget_light+0x25/0x90
[   12.866679]  [<ffffffff811f3337>] SyS_ioctl+0x47/0x90
[   12.866679]  [<ffffffff81e0a7ae>] system_call_fastpath+0x12/0x76
[   12.866679] ---[ end trace f30ef5dd5b6c1afd ]---
[   12.888707] kobject (ffff88007b898df0): tried to init an initialized object, something is seriously wrong.
[   12.889790] CPU: 0 PID: 3736 Comm: multipathd Tainted: G        W       4.0.0+ #335
[   12.890704] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   12.891355]  ffffffff824b5980 ffff88007887bba8 ffffffff81dfff1f ffff88007b534f10
[   12.892542]  ffff88007b898df0 ffff88007887bbc8 ffffffff817bf957 ffff88007b898690
[   12.893805]  0000000000000000 ffff88007887bc08 ffffffff817a4e54 ffff88007887bc38
[   12.894911] Call Trace:
[   12.895279]  [<ffffffff81dfff1f>] dump_stack+0x45/0x57
[   12.895888]  [<ffffffff817bf957>] kobject_init+0x87/0xa0
[   12.896502]  [<ffffffff817a4e54>] blk_mq_register_disk+0x34/0x160
[   12.897360]  [<ffffffff81c7b716>] dm_setup_md_queue+0x1e6/0x2f0
[   12.898151]  [<ffffffff81c81060>] table_load+0x1b0/0x340
[   12.898834]  [<ffffffff81c80eb0>] ? table_clear+0xd0/0xd0
[   12.899454]  [<ffffffff81c81e2a>] ctl_ioctl+0x25a/0x4f0
[   12.900075]  [<ffffffff8110bf00>] ? match_held_lock+0x160/0x1f0
[   12.900737]  [<ffffffff81c820ce>] dm_ctl_ioctl+0xe/0x20
[   12.901346]  [<ffffffff811f2dc3>] do_vfs_ioctl+0x83/0x5b0
[   12.901964]  [<ffffffff811fe761>] ? __fget+0xb1/0x1e0
[   12.902553]  [<ffffffff811fe6b0>] ? put_unused_fd+0x60/0x60
[   12.903184]  [<ffffffff811fe8d5>] ? __fget_light+0x25/0x90
[   12.903818]  [<ffffffff811f3337>] SyS_ioctl+0x47/0x90
[   12.904409]  [<ffffffff81e0a7ae>] system_call_fastpath+0x12/0x76
[   12.905168] ------------[ cut here ]------------
[   12.905730] WARNING: CPU: 0 PID: 3736 at ../fs/sysfs/dir.c:31 sysfs_warn_dup+0x6a/0x80()
[   12.906676] sysfs: cannot create duplicate filename '/devices/virtual/block/dm-0/mq'
[   12.907588] Modules linked in:
[   12.908071] CPU: 0 PID: 3736 Comm: multipathd Tainted: G        W       4.0.0+ #335
[   12.908973] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   12.909621]  ffffffff8229a8ae ffff88007887b9e8 ffffffff81dfff1f ffff88007b534f10
[   12.910771]  ffff88007887ba38 ffff88007887ba28 ffffffff810c4dc2 ffff88007b298000
[   12.911907]  ffff88007b298000 ffff88007abe5be0 ffff88007b29a2e0 ffff88007b5a58a0
[   12.913024] Call Trace:
[   12.913408]  [<ffffffff81dfff1f>] dump_stack+0x45/0x57
[   12.914006]  [<ffffffff810c4dc2>] warn_slowpath_common+0x92/0xd0
[   12.914675]  [<ffffffff810c4ea1>] warn_slowpath_fmt+0x41/0x50
[   12.915323]  [<ffffffff8125bb00>] ? kernfs_path+0x50/0x70
[   12.915940]  [<ffffffff8125f3aa>] sysfs_warn_dup+0x6a/0x80
[   12.916564]  [<ffffffff8125f446>] sysfs_create_dir_ns+0x86/0x90
[   12.917242]  [<ffffffff817c0125>] kobject_add_internal+0xa5/0x2e0
[   12.917920]  [<ffffffff817c0577>] kobject_add+0x67/0xc0
[   12.918522]  [<ffffffff817a4efa>] blk_mq_register_disk+0xda/0x160
[   12.919201]  [<ffffffff81c7b716>] dm_setup_md_queue+0x1e6/0x2f0
[   12.919864]  [<ffffffff81c81060>] table_load+0x1b0/0x340
[   12.920482]  [<ffffffff81c80eb0>] ? table_clear+0xd0/0xd0
[   12.921101]  [<ffffffff81c81e2a>] ctl_ioctl+0x25a/0x4f0
[   12.921704]  [<ffffffff8110bf00>] ? match_held_lock+0x160/0x1f0
[   12.922365]  [<ffffffff81c820ce>] dm_ctl_ioctl+0xe/0x20
[   12.922963]  [<ffffffff811f2dc3>] do_vfs_ioctl+0x83/0x5b0
[   12.923696]  [<ffffffff811fe761>] ? __fget+0xb1/0x1e0
[   12.924390]  [<ffffffff811fe6b0>] ? put_unused_fd+0x60/0x60
[   12.925204]  [<ffffffff811fe8d5>] ? __fget_light+0x25/0x90
[   12.925838]  [<ffffffff811f3337>] SyS_ioctl+0x47/0x90
[   12.926430]  [<ffffffff81e0a7ae>] system_call_fastpath+0x12/0x76
[   12.927120] ---[ end trace f30ef5dd5b6c1afe ]---
[   12.927704] ------------[ cut here ]------------
[   12.928349] WARNING: CPU: 0 PID: 3736 at ../lib/kobject.c:240 kobject_add_internal+0x274/0x2e0()
[   12.929581] kobject_add_internal failed for mq with -EEXIST, don't try to register things with the same name in the same directory.
[   12.930926] Modules linked in:
[   12.931415] CPU: 0 PID: 3736 Comm: multipathd Tainted: G        W       4.0.0+ #335
[   12.932315] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   12.932962]  ffffffff822b6a52 ffff88007887ba48 ffffffff81dfff1f ffff88007b534f10
[   12.934104]  ffff88007887ba98 ffff88007887ba88 ffffffff810c4dc2 ffff88007887ba88
[   12.935194]  ffff88007b898df0 0000000000000000 00000000ffffffef ffff88007b5a58a0
[   12.936286] Call Trace:
[   12.936651]  [<ffffffff81dfff1f>] dump_stack+0x45/0x57
[   12.937268]  [<ffffffff810c4dc2>] warn_slowpath_common+0x92/0xd0
[   12.937942]  [<ffffffff810c4ea1>] warn_slowpath_fmt+0x41/0x50
[   12.938591]  [<ffffffff8125f446>] ? sysfs_create_dir_ns+0x86/0x90
[   12.939271]  [<ffffffff817c02f4>] kobject_add_internal+0x274/0x2e0
[   12.939961]  [<ffffffff817c0577>] kobject_add+0x67/0xc0
[   12.940574]  [<ffffffff817a4efa>] blk_mq_register_disk+0xda/0x160
[   12.941268]  [<ffffffff81c7b716>] dm_setup_md_queue+0x1e6/0x2f0
[   12.941932]  [<ffffffff81c81060>] table_load+0x1b0/0x340
[   12.942540]  [<ffffffff81c80eb0>] ? table_clear+0xd0/0xd0
[   12.943148]  [<ffffffff81c81e2a>] ctl_ioctl+0x25a/0x4f0
[   12.951270]  [<ffffffff8110bf00>] ? match_held_lock+0x160/0x1f0
[   12.951936]  [<ffffffff81c820ce>] dm_ctl_ioctl+0xe/0x20
[   12.952542]  [<ffffffff811f2dc3>] do_vfs_ioctl+0x83/0x5b0
[   12.953166]  [<ffffffff811fe761>] ? __fget+0xb1/0x1e0
[   12.953838]  [<ffffffff811fe6b0>] ? put_unused_fd+0x60/0x60
[   12.954759]  [<ffffffff811fe8d5>] ? __fget_light+0x25/0x90
[   12.955566]  [<ffffffff811f3337>] SyS_ioctl+0x47/0x90
[   12.956174]  [<ffffffff81e0a7ae>] system_call_fastpath+0x12/0x76
[   12.956875] ---[ end trace f30ef5dd5b6c1aff ]---
