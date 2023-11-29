Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84021854
	for <dm-devel@lists.linux.dev>; Wed, 29 Nov 2023 02:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 1F81C85;
	Tue, 28 Nov 2023 17:55:48 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id wLbniF-Lw8lf; Tue, 28 Nov 2023 17:55:46 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id A539440;
	Tue, 28 Nov 2023 17:55:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net A539440
Date: Tue, 28 Nov 2023 17:55:42 -0800 (PST)
From: Eric Wheeler <dm-devel@lists.ewheeler.net>
To: Joe Thornber <thornber@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: Stuck IOs with dm-integrity + md raid1 + dm-thin
Message-ID: <fb4ae62-522-e262-df25-c82e8acf8baf@ewheeler.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Joe,

I'm not sure who else to CC on this issue, feel free to add others.

Recently we tried putting dm-integrity on NVMe's under MD RAID1 with 
dm-thin metadata (tmeta) on that raid1 mirror (Linux v6.5.7).  It worked 
fine for ~12 hours and then, at ~3:30 am in the morning when we do a 
reserve_metadata_snap and thin_dump's, IO's began to hang.

For reference, we have been using the same block device stack for years, 
and it is quite stable.  We've been running Linux v6.5.7 for about 6 weeks 
without issue until we tried dm-integrity under dm-thin.  The stack 
_without_ dm-integrity looks like this:

    nvme{0,1} =>
        raid mirror /dev/md0 =>
            LVM PV for VG "data" =>
                tmeta for dm-thin

    /dev/sda (LSI-based Hardware RAID)
        bcache =>
            LVM PV for VG "data" =>
                tdata for dm-thin "pool0" =>
                    single thin volume from the pool =>
                        drbd to another host over the network

After adding dm-integrity, the stack is the same as above except that
the RAID mirror is above dm-integrity:

    nvme{0,1} =>
        dm-integrity =>
            raid mirror /dev/md0 =>
                LVM PV for VG "data" =>
                    tmeta for dm-thin

The first time we had the thindump+IO hang problem we thought that an
underlying NVMe drive was bad, so we replaced both: We rebooted and did
a `pvmove` of the tmeta volume to different NVMe+md-raid1+dm-integrity
on disks that were brand new, but had the same issue that night during
reserve_metadata_snap+thin_dump. 

Since we had the same problem on a different set of new NVMe disks, we 
rebooted, did a `pvmove` back to the original MD RAID1 mirror stack 
_without_ dm-integrity, and everything was back to normal.  Thus, I do not 
think it is a disk or tmeta corruption issue, but an obscure race or 
deadlock bug.

We tried to reproduce this in a virtual environment, but so far it has not 
triggered. In about a week when we get downtime for this system, I will 
take a copy of its thin metadata to inspect further. For now, I have not 
yet been enable to reproduce problem outside our semi-production testing 
environment.

So, this is what we see so far:

We get _thousands_ of these lines in the kernel logs when IO hangs. The 
`dm-175` device is one of the the dm-integrity targets being mirrored. 
Note the "12924 callbacks suppressed" message:

	[  +0.584816] raid1_end_read_request: 12924 callbacks suppressed
	[  +0.000006] md/raid1:md0: dm-175: rescheduling sector 1979682216
	[  +0.020011] md/raid1:md0: dm-175: rescheduling sector 1979682216
	[  +0.019462] md/raid1:md0: dm-175: rescheduling sector 1979682216
	[  +0.018672] md/raid1:md0: dm-175: rescheduling sector 1979682216
	[  +0.006242] md/raid1:md0: dm-175: rescheduling sector 1979682216
	[  +0.002399] md/raid1:md0: dm-175: rescheduling sector 1979682216
	[  +0.000934] md/raid1:md0: dm-175: rescheduling sector 1979682216
	[  +0.000688] md/raid1:md0: dm-175: rescheduling sector 1979682216
	[  +0.001161] md/raid1:md0: dm-175: rescheduling sector 1979682216
	[  +0.006404] md/raid1:md0: dm-175: rescheduling sector 1979682216
	[  +3.594380] integrity_metadata: 13095 callbacks suppressed
	[  +0.000006] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
	[  +0.001410] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
	[  +0.000824] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
	[  +0.003587] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
	[  +0.011065] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
	[  +0.004176] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
	[  +0.000604] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
	[  +0.006153] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
	[  +0.008797] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
	[  +0.002350] device-mapper: integrity: dm-175: Checksum failed at sector 0x760395b0
	[  +0.668866] raid1_read_request: 12747 callbacks suppressed
	[  +0.000005] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
	[  +0.024708] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
	[  +0.024441] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
	[  +0.018321] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
	[  +0.000850] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
	[  +0.004479] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
	[  +0.001225] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
	[  +0.001024] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
	[  +0.000741] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175
	[  +0.001094] md/raid1:md0: redirecting sector 1979682216 to other mirror: dm-175

Here are two traces of hung tasks that the kernel reported in dmesg. The
decoded line numbers are at the bottom of this email.

It looks like dmeventd is checking metadata transaction IDs, and then
hangs. We believe that is snapshot was being made at the moment that IOs
hung. This trace only appears once:

	INFO: task dmeventd:3718459 blocked for more than 122 seconds.
	     Tainted: G            E      6.5.7 #23
	"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
	task:dmeventd        state:D stack:0     pid:3718459 ppid:1      flags:0x00000002
	Call Trace:
	<TASK>
	__schedule+0x2d7/0x800
	schedule+0x5e/0xe0
	schedule_preempt_disabled+0x15/0x30
	rwsem_down_read_slowpath+0x2c4/0x5f0
	? lock_acquire+0x10b/0x120
	down_read+0xff/0x260
	dm_pool_get_metadata_transaction_id+0x24/0x60 [dm_thin_pool]
	pool_status+0x133/0x630 [dm_thin_pool]
	retrieve_status+0xc4/0x210 [dm_mod]
	table_status+0x9c/0x150 [dm_mod]
	ctl_ioctl+0x248/0x370 [dm_mod]
	? __pfx_table_status+0x10/0x10 [dm_mod]
	dm_ctl_ioctl+0xe/0x20 [dm_mod]
	__x64_sys_ioctl+0x99/0xe0
	do_syscall_64+0x3f/0xa0
	entry_SYSCALL_64_after_hwframe+0x6e/0xd8

In the next trace below, you can see that DRBD is trying to write to it's 
thin volume backing device, and thin metadata is being manipulated it by 
dm-thin (which is above md raid1 with dm-integrity), but hangs during 
`dm_thin_find_block`:

This trace appears several times for different DRBD volumes that are
backed by thin volumes in the same pool.  Except that the thin volume
differs, the traces are the same:

	INFO: task drbd_r_secServe:1072212 blocked for more than 122 seconds.
	     Tainted: G            E      6.5.7 #23
	"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
	task:drbd_r_secServe state:D stack:0     pid:1072212 ppid:2      flags:0x00004000
	Call Trace:
	<TASK>
	__schedule+0x2d7/0x800
	schedule+0x5e/0xe0
	schedule_preempt_disabled+0x15/0x30
	rwsem_down_read_slowpath+0x2c4/0x5f0
	? dm_thin_find_block+0x32/0x90 [dm_thin_pool]
	down_read+0xff/0x260
	dm_thin_find_block+0x32/0x90 [dm_thin_pool]
	thin_bio_map.isra.0+0x169/0x3a0 [dm_thin_pool]
	__map_bio+0x49/0x1d0 [dm_mod]
	dm_split_and_process_bio+0x21c/0x580 [dm_mod]
	dm_submit_bio+0x64/0x170 [dm_mod]
	__submit_bio+0x7e/0xd0
	__submit_bio_noacct+0x90/0x200
	drbd_submit_peer_request+0x138/0x2d0 [drbd]
	receive_DataRequest+0x244/0x710 [drbd]
	? __pfx_receive_DataRequest+0x10/0x10 [drbd]
	drbdd+0x174/0x280 [drbd]
	? __pfx_drbd_thread_setup+0x10/0x10 [drbd]
	drbd_receiver+0x51/0xd0 [drbd]
	drbd_thread_setup+0xa3/0x1b0 [drbd]
	kthread+0xe9/0x120
	? __pfx_kthread+0x10/0x10
	ret_from_fork+0x34/0x50
	? __pfx_kthread+0x10/0x10
	ret_from_fork_asm+0x1b/0x30
	</TASK>

This is the call stack of the thin_dump command, its just waiting:

	# thin_dump -f xml --dev-id 671125 -m /dev/mapper/data-pool0_tmeta
	...

	# cat /proc/4016388/stack 
	[<0>] submit_bio_wait+0x7a/0xc0
	[<0>] __blkdev_direct_IO_simple+0x130/0x280
	[<0>] blkdev_read_iter+0xb8/0x150
	[<0>] do_iter_readv_writev+0x14e/0x160
	[<0>] do_iter_read+0x125/0x1c0
	[<0>] vfs_readv+0xa8/0xf0
	[<0>] __x64_sys_preadv+0xc0/0x100
	[<0>] do_syscall_64+0x3f/0xa0
	[<0>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8



These are the line number decodes for the above traces:

trace 1:
	kernel: INFO: task dmeventd:3718459 blocked for more than 122 seconds.
	__schedule (kernel/sched/core.c:5381 kernel/sched/core.c:6710) 
	schedule (./arch/x86/include/asm/preempt.h:85 (discriminator 1) kernel/sched/core.c:6787 (discriminator 1)) 
	schedule_preempt_disabled (./arch/x86/include/asm/preempt.h:80 kernel/sched/core.c:6846) 
	rwsem_down_read_slowpath (kernel/locking/rwsem.c:1073) 
	? lock_acquire (./include/trace/events/lock.h:24 kernel/locking/lockdep.c:5724) 
	down_read (kernel/locking/rwsem.c:1250 kernel/locking/rwsem.c:1263 kernel/locking/rwsem.c:1522) 
	dm_pool_get_metadata_transaction_id (drivers/md/dm-thin-metadata.c:1323) dm_thin_pool
	pool_status (drivers/md/dm-thin.c:3944) dm_thin_pool
	retrieve_status (./include/linux/fortify-string.h:214 drivers/md/dm-ioctl.c:1316) dm_mod
	table_status (drivers/md/dm-ioctl.c:1707) dm_mod
	ctl_ioctl (drivers/md/dm-ioctl.c:2083) dm_mod
	? __pfx_table_status (drivers/md/dm-ioctl.c:1693) dm_mod
	dm_ctl_ioctl (drivers/md/dm-ioctl.c:2103) dm_mod
	__x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:870 fs/ioctl.c:856 fs/ioctl.c:856) 
	do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120) 


trace 2:
	kernel: INFO: task drbd_r_secServe:1072212 blocked for more than 122 seconds.
	__schedule (kernel/sched/core.c:5381 kernel/sched/core.c:6710) 
	schedule (./arch/x86/include/asm/preempt.h:85 (discriminator 1) kernel/sched/core.c:6787 (discriminator 1)) 
	schedule_preempt_disabled (./arch/x86/include/asm/preempt.h:80 kernel/sched/core.c:6846) 
	rwsem_down_read_slowpath (kernel/locking/rwsem.c:1073) 
	? dm_thin_find_block (drivers/md/dm-thin-metadata.c:1574) dm_thin_pool
	down_read (kernel/locking/rwsem.c:1250 kernel/locking/rwsem.c:1263 kernel/locking/rwsem.c:1522) 
	dm_thin_find_block (drivers/md/dm-thin-metadata.c:1574) dm_thin_pool
	thin_bio_map.isra.0 (drivers/md/dm-thin.c:2764) dm_thin_pool
	__map_bio (drivers/md/dm.c:1427) dm_mod
	dm_split_and_process_bio (drivers/md/dm.c:1729 drivers/md/dm.c:1782) dm_mod
	dm_submit_bio (drivers/md/dm.c:1835) dm_mod
	__submit_bio (block/blk-core.c:373 block/blk-core.c:603) 
	__submit_bio_noacct (./include/linux/bio.h:624 block/blk-core.c:653) 
	drbd_submit_peer_request (drivers/block/drbd/drbd_receiver.c:1723) drbd
	receive_DataRequest (drivers/block/drbd/drbd_receiver.c:2993) drbd
	? __pfx_receive_DataRequest (drivers/block/drbd/drbd_receiver.c:2803) drbd
	drbdd (drivers/block/drbd/drbd_receiver.c:5092) drbd
	? __pfx_drbd_thread_setup (drivers/block/drbd/drbd_main.c:310) drbd
	drbd_receiver (drivers/block/drbd/drbd_receiver.c:5561) drbd
	drbd_thread_setup (drivers/block/drbd/drbd_main.c:325) drbd
	kthread (kernel/kthread.c:389) 
	? __pfx_kthread (kernel/kthread.c:342) 
	ret_from_fork (arch/x86/kernel/process.c:151) 
	? __pfx_kthread (kernel/kthread.c:342) 
	ret_from_fork_asm (arch/x86/entry/entry_64.S:312) 

trace 3:
	# thin_dump -f xml --dev-id 671125 -m /dev/mapper/data-pool0_tmeta
	<hung>

	# cat /proc/4016388/stack
	submit_bio_wait (block/bio.c:1370 (discriminator 1)) 
	__blkdev_direct_IO_simple (./include/linux/bio.h:495 block/fops.c:99) 
	blkdev_read_iter (block/fops.c:608) 
	do_iter_readv_writev (./include/linux/fs.h:1871) 
	do_iter_read (fs/read_write.c:795) 
	vfs_readv (fs/read_write.c:916) 
	__x64_sys_preadv (fs/read_write.c:1007 fs/read_write.c:1057 fs/read_write.c:1052 fs/read_write.c:1052) 
	do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
	entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120) 



--
Eric Wheeler
