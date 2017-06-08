From: Shaohua Li <shli@kernel.org>
Subject: Re: kernel BUG at lib/percpu-refcount.c:192
Date: Thu, 8 Jun 2017 10:07:19 -0700
Message-ID: <20170608170719.6kkk4g2gwzrko7wr@kernel.org>
References: <5fd9ae4c-2cf3-360c-ed50-f2517aafda7a@redhat.com>
 <9dcf0086-6d8a-29db-2a27-6c63af988388@redhat.com>
 <20170608133829.GA32626@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170608133829.GA32626@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Marian Csontos <mcsontos@redhat.com>, device-mapper development <dm-devel@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jun 08, 2017 at 09:38:29AM -0400, Mike Snitzer wrote:
> On Thu, Jun 08 2017 at  4:29am -0400,
> Marian Csontos <mcsontos@redhat.com> wrote:
> 
> > Mike, Heinz, help please!
> > 
> > RC4 and still present:
> > 
> > [  248.815709] CPU: 0 PID: 21 Comm: rcuos/1 Not tainted
> > 4.12.0-0.rc4.git2.1.fc27.x86_64 #1
> > [  248.816841] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> > 
> > ...and it affects RAID1 as well.
> > 
> > Is this md wrong or is there a more serious issue? And if so is it a
> > known one?
> > I have not found any reference anywhere except this dm-devel thread.
> > Is this a problem in LVM RAID only?
> 
> Unclear.
>  
> > Where to forward this? LKML? Fedora Bugzilla?
> 
> Certainly linux-raid (now cc'd).
> 
> > Is there anything else I should provide?
> 
> The linewrapping makes it hard to read these logs, but I'll defer to
> others to weigh-in on any additional info needed.

Neil fixed a bug in this side recently, which is pretty similar like the
reported, I'll push the patch to upstream soon. Could you please try my
for-next tree, and check if you still have the issue?

Thanks,
Shaohua
> 
> > -- Martian
> > 
> > On 05/18/2017 10:33 AM, Marian Csontos wrote:
> > >When running `lvm lvcreate --type raid5 --size 4194304B --name
> > >meta_r5 LVMTEST12279nqymhamb_vg --yes` there's a warning followed
> > >by the bug.
> > >
> > >Also at [  192.140142] it looks like there is an uninitialized
> > >variable somewhere.
> > >
> > >env: rawhide, kvm, 2 (V)CPUs
> > >lvm2: upstream
> > >kernel: 4.12.0-0.rc1.git1.1.fc27.x86_64
> > >
> > >----
> > >
> > >[  192.131076] mdX: bitmap file is out of date, doing full recovery
> > >
> > >[  192.140142] percpu ref (          (null)) <= 0
> > >(-9223372036854775807) after switching to atomic
> > >
> > >[  192.140180] ------------[ cut here ]------------
> > >[  192.143734] WARNING: CPU: 0 PID: 10 at
> > >lib/percpu-refcount.c:155
> > >percpu_ref_switch_to_atomic_rcu+0x1cd/0x1f0
> > >[  192.146353] Modules linked in: dm_raid raid456
> > >async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> > >raid6_pq ...|dm_thin_pool dm_cache_smq dm_cache dm_persistent_data
> > >dm_bio_prison libcrc32c loop crct10dif_pclmul crc32_pclmul
> > >crc32c_intel     ...|ppdev ghash_clmulni_intel acpi_cpufreq
> > >virtio_net virtio_balloon tpm_tis joydev tpm_tis_core parport_pc
> > >parport tpm i2c_piix4     ...|virtio_blk cirrus drm_kms_helper ttm
> > >drm serio_raw virtio_pci virtio_ring virtio ata_generic pata_acpi
> > >[  192.154276] CPU: 0 PID: 10 Comm: rcuos/0 Not tainted
> > >4.12.0-0.rc1.git1.1.fc27.x86_64 #1
> > >[  192.155684] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> > >[  192.156741] task: ffff8d5bb6e73100 task.stack: ffffa9a3c0360000
> > >[  192.157830] RIP: 0010:percpu_ref_switch_to_atomic_rcu+0x1cd/0x1f0
> > >[  192.158956] RSP: 0018:ffffa9a3c0363e50 EFLAGS: 00010282
> > >[  192.159899] RAX: 0000000000000053 RBX: 8000000000000000 RCX:
> > >0000000000000000
> > >[  192.161192] RDX: 0000000000000000 RSI: ffff8d5bb6e73d90 RDI:
> > >0000000000000247
> > >[  192.162483] RBP: ffffa9a3c0363e68 R08: 0000000000000000 R09:
> > >0000000000000000
> > >[  192.163762] R10: ffffa9a3c0363e00 R11: 0000000000000000 R12:
> > >0000000000000000
> > >[  192.165144] R13: ffff8d5bb5252580 R14: ffff8d5bb5252580 R15:
> > >0000000000000000
> > >[  192.166437] FS:  0000000000000000(0000)
> > >GS:ffff8d5bb7800000(0000) knlGS:0000000000000000
> > >[  192.169392] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >[  192.171893] CR2: 00007ffc83d87d98 CR3: 0000000013e11000 CR4:
> > >00000000000006f0
> > >[  192.174692] Call Trace:
> > >[  192.176627]  ? percpu_ref_reinit+0x140/0x140
> > >[  192.178875]  rcu_nocb_kthread+0x1ae/0x580
> > >[  192.181174]  kthread+0x133/0x150
> > >[  192.183305]  ? rcu_eqs_enter_common.constprop.68+0x1c0/0x1c0
> > >[  192.185813]  ? kthread_create_on_node+0x70/0x70
> > >[  192.188110]  ret_from_fork+0x31/0x40
> > >[  192.190338] Code: ff ff ff 80 3d a6 71 b9 00 00 0f 85 c1 fe ff
> > >ff 49 8b 55 d8 49 8b 75 e8 48 c7 c7 f0 2b ce 8b c6 05 8a 71 b9 00
> > >...|01 e8 89 95 d4 ff <0f> ff e9 9f fe ff ff f0 49 83 6d d8 01 0f
> > >85 05 ff ff ff 48 89
> > >[  192.196842] ---[ end trace fbf926294c454ffa ]---
> > >
> > >[  192.199425] ------------[ cut here ]------------
> > >[  192.200346] kernel BUG at lib/percpu-refcount.c:192!
> > >[  192.200346] invalid opcode: 0000 [#1] SMP
> > >[  192.200346] Modules linked in: dm_raid raid456
> > >async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> > >raid6_pq ...|dm_thin_pool dm_cache_smq dm_cache dm_persistent_data
> > >dm_bio_prison libcrc32c loop crct10dif_pclmul crc32_pclmul
> > >crc32c_intel     ...|ppdev ghash_clmulni_intel acpi_cpufreq
> > >virtio_net virtio_balloon tpm_tis joydev tpm_tis_core parport_pc
> > >parport tpm i2c_piix4     ...|virtio_blk cirrus drm_kms_helper ttm
> > >drm serio_raw virtio_pci virtio_ring virtio ata_generic pata_acpi
> > >[  192.211647] CPU: 0 PID: 13767 Comm: mdX_raid5 Tainted: G
> > >W   4.12.0-0.rc1.git1.1.fc27.x86_64 #1
> > >[  192.211647] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> > >[  192.211647] task: ffff8d5bb15f3100 task.stack: ffffa9a3c0d10000
> > >[  192.211647] RIP: 0010:__percpu_ref_switch_mode+0x278/0x280
> > >[  192.211647] RSP: 0018:ffffa9a3c0d13ce8 EFLAGS: 00010046
> > >[  192.211647] RAX: 0000000000000001 RBX: ffff8d5bb5252558 RCX:
> > >0000000000000000
> > >[  192.211647] RDX: 0000000000000001 RSI: ffffffff8c05a098 RDI:
> > >0000000000000046
> > >[  192.211647] RBP: ffffa9a3c0d13d30 R08: 0000000000000001 R09:
> > >0000000000000000
> > >[  192.211647] R10: ffffa9a3c0d13ca0 R11: ffffffff8c05a098 R12:
> > >0000000000000000
> > >[  192.211647] R13: 0000000000000000 R14: ffff8d5bb15f3100 R15:
> > >ffff8d5bb508f000
> > >[  192.211647] FS:  0000000000000000(0000)
> > >GS:ffff8d5bb7800000(0000) knlGS:0000000000000000
> > >[  192.211647] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >[  192.211647] CR2: 00007ffc83d87d98 CR3: 0000000013e11000 CR4:
> > >00000000000006f0
> > >[  192.211647] Call Trace:
> > >[  192.211647]  percpu_ref_switch_to_percpu+0x27/0x40
> > >[  192.211647]  set_in_sync+0xd4/0xe0
> > >[  192.211647]  md_check_recovery+0x1f5/0x4e0
> > >[  192.211647]  raid5d+0x56/0x6a0 [raid456]
> > >[  192.211647]  ? finish_wait+0x72/0x90
> > >[  192.211647]  ? trace_hardirqs_on_caller+0xf4/0x190
> > >[  192.211647]  ? trace_hardirqs_on+0xd/0x10
> > >[  192.211647]  md_thread+0x138/0x180
> > >[  192.211647]  ? md_thread+0x138/0x180
> > >[  192.211647]  ? finish_wait+0x90/0x90
> > >[  192.211647]  kthread+0x133/0x150
> > >[  192.211647]  ? find_pers+0x70/0x70
> > >[  192.211647]  ? kthread_create_on_node+0x70/0x70
> > >[  192.211647]  ret_from_fork+0x31/0x40
> > >[  192.211647] Code: f0 4a c8 8b be d5 03 00 00 48 c7 c7 b1 75 c7
> > >8b c6 05 ef 75 b9 00 01 e8 97 d2 c4 ff e9 e8 fe ff ff f0 48 83 03
> > >...|01 e9 bf fe ff ff <0f> 0b e8 21 d9 be ff 90 55 48 89 e5 41 55
> > >41 54 53 48 89 fb 48
> > >[  192.211647] RIP: __percpu_ref_switch_mode+0x278/0x280 RSP:
> > >ffffa9a3c0d13ce8
> > >[  192.211647] ---[ end trace fbf926294c454ffb ]---
> > >
> > >[  192.211647] BUG: sleeping function called from invalid context
> > >at ./include/linux/percpu-rwsem.h:33
> > >[  192.211647] in_atomic(): 1, irqs_disabled(): 1, pid: 13767,
> > >name: mdX_raid5
> > >[  192.211647] INFO: lockdep is turned off.
> > >[  192.211647] irq event stamp: 68
> > >[  192.211647] hardirqs last  enabled at (67):
> > >[<ffffffff8b983586>] _raw_spin_unlock_irqrestore+0x36/0x60
> > >[  192.211647] hardirqs last disabled at (68):
> > >[<ffffffff8b983c47>] _raw_spin_lock_irqsave+0x27/0x90
> > >[  192.211647] softirqs last  enabled at (0): [<ffffffff8b0ae308>]
> > >copy_process.part.26+0x618/0x1ee0
> > >[  192.211647] softirqs last disabled at (0): [<          (null)>]
> > >(null)
> > >[  192.211647] CPU: 0 PID: 13767 Comm: mdX_raid5 Tainted: G      D
> > >W   4.12.0-0.rc1.git1.1.fc27.x86_64 #1
> > >[  192.211647] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> > >[  192.211647] Call Trace:
> > >[  192.211647]  dump_stack+0x8e/0xcd
> > >[  192.211647]  ___might_sleep+0x144/0x260
> > >[  192.211647]  __might_sleep+0x4a/0x80
> > >[  192.211647]  exit_signals+0x33/0x240
> > >[  192.211647]  do_exit+0xb4/0xd30
> > >[  192.211647]  ? kthread+0x133/0x150
> > >[  192.211647]  ? find_pers+0x70/0x70
> > >[  192.211647]  rewind_stack_do_exit+0x17/0x20
> > >
> > >[  192.211647] note: mdX_raid5[13767] exited with preempt_count 2
> > >
> > >[  220.071005] NMI watchdog: BUG: soft lockup - CPU#1 stuck for
> > >22s! [lvm:13678]
> > >[  220.071079] Modules linked in: dm_raid raid456
> > >async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> > >raid6_pq ...|dm_thin_pool dm_cache_smq dm_cache dm_persistent_data
> > >dm_bio_prison libcrc32c loop crct10dif_pclmul crc32_pclmul
> > >crc32c_intel     ...|ppdev ghash_clmulni_intel acpi_cpufreq
> > >virtio_net virtio_balloon tpm_tis joydev tpm_tis_core parport_pc
> > >parport tpm i2c_piix4     ...|virtio_blk cirrus drm_kms_helper ttm
> > >drm serio_raw virtio_pci virtio_ring virtio ata_generic pata_acpi
> > >[  220.083131] irq event stamp: 313716
> > >[  220.087117] hardirqs last  enabled at (313715):
> > >[<ffffffff8b983da7>] entry_SYSCALL_64_fastpath+0x5/0xbe
> > >[  220.091109] hardirqs last disabled at (313716):
> > >[<ffffffff8b97afe4>] __schedule+0xc4/0xb40
> > >[  220.091109] softirqs last  enabled at (301518):
> > >[<ffffffff8b988d52>] __do_softirq+0x382/0x4ed
> > >[  220.095114] softirqs last disabled at (301511):
> > >[<ffffffff8b0b8e7f>] irq_exit+0x10f/0x120
> > >[  220.099150] CPU: 1 PID: 13678 Comm: lvm Tainted: G      D W
> > >4.12.0-0.rc1.git1.1.fc27.x86_64 #1
> > >[  220.103049] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> > >[  220.103049] task: ffff8d5bb3c03100 task.stack: ffffa9a3c155c000
> > >[  220.107103] RIP: 0010:queued_spin_lock_slowpath+0x25/0x1b0
> > >[  220.107103] RSP: 0018:ffffa9a3c155f720 EFLAGS: 00000202
> > >ORIG_RAX: ffffffffffffff10
> > >[  220.111144] RAX: 0000000000000001 RBX: ffff8d5bb5252448 RCX:
> > >0000000000000000
> > >[  220.115126] RDX: 0000000000000001 RSI: 0000000000000001 RDI:
> > >ffff8d5bb5252448
> > >[  220.115126] RBP: ffffa9a3c155f720 R08: 0000000000000000 R09:
> > >0000000000000000
> > >[  220.119130] R10: ffffa9a3c155f6d0 R11: ffff8d5bb3c03100 R12:
> > >ffff8d5bb5252448
> > >[  220.123139] R13: ffff8d5bb5252448 R14: ffff8d5bb379ca20 R15:
> > >ffff8d5bb5252058
> > >[  220.127118] FS:  00007f1f8253b880(0000)
> > >GS:ffff8d5bb7a00000(0000) knlGS:0000000000000000
> > >[  220.127118] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > >[  220.131158] CR2: 00007fe2715ae000 CR3: 0000000075108000 CR4:
> > >00000000000006e0
> > >[  220.135114] Call Trace:
> > >[  220.135114]  do_raw_spin_lock+0xb2/0xc0
> > >[  220.139145]  _raw_spin_lock+0x55/0x70
> > >[  220.139145]  md_write_start+0x143/0x360
> > >[  220.143126]  ? probe_sched_wakeup+0x1c/0x20
> > >[  220.143126]  ? check_preempt_curr+0x27/0xb0
> > >[  220.147147]  raid5_make_request+0xd0/0x1060 [raid456]
> > >[  220.147147]  ? _raw_spin_unlock_irqrestore+0x5b/0x60
> > >[  220.151162]  ? try_to_wake_up+0x58/0x520
> > >[  220.151162]  ? finish_wait+0x90/0x90
> > >[  220.155099]  ? mempool_alloc_slab+0x1d/0x30
> > >[  220.155099]  ? finish_wait+0x90/0x90
> > >[  220.159136]  raid_map+0x2b/0x40 [dm_raid]
> > >[  220.159136]  __map_bio+0xc9/0x2b0
> > >[  220.163115]  ? dm_put_table_device+0xd0/0xd0
> > >[  220.163115]  __split_and_process_bio+0x293/0x590
> > >[  220.167133]  dm_make_request+0x7f/0x120
> > >[  220.167133]  ? generic_make_request+0xf9/0x3b0
> > >[  220.171131]  generic_make_request+0x126/0x3b0
> > >[  220.171131]  ? iov_iter_get_pages+0xc9/0x300
> > >[  220.175138]  submit_bio+0x73/0x150
> > >[  220.175138]  ? submit_bio+0x73/0x150
> > >[  220.179132]  ? bio_iov_iter_get_pages+0xe0/0x120
> > >[  220.179132]  ? __blkdev_direct_IO_simple+0x168/0x320
> > >[  220.183114]  __blkdev_direct_IO_simple+0x184/0x320
> > >[  220.183114]  ? lock_acquire+0xa3/0x1f0
> > >[  220.187129]  ? bdput+0x20/0x20
> > >[  220.187129]  blkdev_direct_IO+0x3b1/0x3e0
> > >[  220.191112]  ? blkdev_direct_IO+0x3b1/0x3e0
> > >[  220.191112]  ? current_time+0x1a/0x70
> > >[  220.195108]  ? trace_hardirqs_on+0xd/0x10
> > >[  220.195108]  generic_file_direct_write+0x9c/0x110
> > >[  220.199114]  ? generic_file_direct_write+0x9c/0x110
> > >[  220.199114]  __generic_file_write_iter+0xbe/0x1d0
> > >[  220.199114]  blkdev_write_iter+0x96/0x110
> > >[  220.203115]  __vfs_write+0xe8/0x160
> > >[  220.203115]  ? __vfs_write+0xe8/0x160
> > >[  220.207211]  vfs_write+0xc6/0x1c0
> > >[  220.207211]  SyS_write+0x58/0xc0
> > >[  220.207211]  entry_SYSCALL_64_fastpath+0x1f/0xbe
> > >[  220.211130] RIP: 0033:0x7f1f81309290
> > >[  220.211130] RSP: 002b:00007fffba453af8 EFLAGS: 00000246
> > >ORIG_RAX: 0000000000000001
> > >[  220.215116] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
> > >00007f1f81309290
> > >[  220.215116] RDX: 0000000000001000 RSI: 000055f0c4ab4000 RDI:
> > >000000000000000c
> > >[  220.219114] RBP: 00007f1f815d5583 R08: fffffffffffffff0 R09:
> > >0000000000000000
> > >[  220.219114] R10: 00007f1f815d4b38 R11: 0000000000000246 R12:
> > >0000000000000001
> > >[  220.223148] R13: 0000000000000001 R14: 00007f1f815d5500 R15:
> > >00007f1f815d08c0
> > >[  220.223148] Code: 1f 80 00 00 00 00 66 66 66 66 90 55 48 89 e5
> > >66 66 90 66 90 ba 01 00 00 00 8b 07 85 c0 75 0a f0 0f b1 17 85 c0
> > >...|75 f2 5d c3 f3 90 <eb> ec 81 fe 00 01 00 00 0f 84 1a 01 00 00
> > >41 b8 01 01 00 00 b9
> > >
> > >-- 
> > >dm-devel mailing list
> > >dm-devel@redhat.com
> > >https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
