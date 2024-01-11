Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E90C15AC5
	for <dm-devel@lists.linux.dev>; Thu, 11 Jan 2024 12:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EgMIOZdJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704976480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5s6koNfHDweClSoQ/u2NRjNboHHnIyBcRKHcSfcax14=;
	b=EgMIOZdJXGydZmaeAQUP1i4qzU/AhZW9p4YohjRXYTm+0Mh9GwRjoz0sfUvr+T/UJZgNxs
	mBOX+CXE5Ps1ehANJ5pkgm+E5AKmmcfFZ/nJl7IgvtcAMp33Z0wZsEaNUTE1LB6ySQH/vU
	YPHKKTvxPyP/jwKz+KSCIosNVzpxIls=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-UCf0ZP_aM6-NJnlMuKkqqA-1; Thu, 11 Jan 2024 07:34:39 -0500
X-MC-Unique: UCf0ZP_aM6-NJnlMuKkqqA-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5cdbf9fd702so4578558a12.0
        for <dm-devel@lists.linux.dev>; Thu, 11 Jan 2024 04:34:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976478; x=1705581278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5s6koNfHDweClSoQ/u2NRjNboHHnIyBcRKHcSfcax14=;
        b=WRrsyNmoTY8A93AB5bXKnX+sL9IpEw7OFiI6Si3wWBVkrJ5F5VZn786caJiVA1v+aP
         RV07dZJTARVFEXmPkx0o6tquG4Vhev2vHyXulOX2biI4yscdgwxw+QCdX70PboiO84Ta
         4GxPZWAW7opvSL4zMIvPTjjL4MVa5mtnmjxXi+BrUxAZ7J9UthqUQXXNMOs5eKN0TONj
         AjOr7dYYKrmZFH2ousNDUUZ3g53gLhPfn0wqNGTMlPGN7V4zW1EbrcVJnbWrJ4fpXe0H
         rEE1O0BduOokheiP867g7h868cttLFjF87rbBkqSlQu94Flnf1S1SAOFtiWsEDUlAQDS
         p7tw==
X-Gm-Message-State: AOJu0YwG6jWY4I+vgcwprt3gyw7/mXdkyCTPqwszSxhAotnB8QH0U0yq
	k/pQgR0rnUUW1SaZL0bWEThhMidXGwvlSq2aXurolm8R3mxAiB97yDZtFGDPoNv7knp4yBQurSa
	F21BUaW7y3Hn6ZjNouljWakwXN7LFypcujFZgMecOOJg=
X-Received: by 2002:a05:6a20:a105:b0:19a:5a57:5e17 with SMTP id q5-20020a056a20a10500b0019a5a575e17mr539689pzk.15.1704976478043;
        Thu, 11 Jan 2024 04:34:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF8qaiRdvCv9TWMTNTMv4XasUkG5QOH3L7u/L9HuBwqmtavB35RP0rSWl1r/8YOui34PWcePAgY3YixJjumGcA=
X-Received: by 2002:a05:6a20:a105:b0:19a:5a57:5e17 with SMTP id
 q5-20020a056a20a10500b0019a5a575e17mr539675pzk.15.1704976477675; Thu, 11 Jan
 2024 04:34:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <fb4ae62-522-e262-df25-c82e8acf8baf@ewheeler.net>
In-Reply-To: <fb4ae62-522-e262-df25-c82e8acf8baf@ewheeler.net>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 11 Jan 2024 20:34:25 +0800
Message-ID: <CALTww2-kBfJw2uNTp8JgMz5=MZKFKGP=ATAC42=Wf7hWJfPT1A@mail.gmail.com>
Subject: Re: Stuck IOs with dm-integrity + md raid1 + dm-thin
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: Joe Thornber <thornber@redhat.com>, dm-devel@lists.linux.dev, 
	Heinz Mauelshagen <heinzm@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, 
	"Snitzer, Mike" <snitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 29, 2023 at 10:10=E2=80=AFAM Eric Wheeler
<dm-devel@lists.ewheeler.net> wrote:
>
> Hi Joe,
>
> I'm not sure who else to CC on this issue, feel free to add others.
>
> Recently we tried putting dm-integrity on NVMe's under MD RAID1 with
> dm-thin metadata (tmeta) on that raid1 mirror (Linux v6.5.7).  It worked
> fine for ~12 hours and then, at ~3:30 am in the morning when we do a
> reserve_metadata_snap and thin_dump's, IO's began to hang.
>
> For reference, we have been using the same block device stack for years,
> and it is quite stable.  We've been running Linux v6.5.7 for about 6 week=
s
> without issue until we tried dm-integrity under dm-thin.  The stack
> _without_ dm-integrity looks like this:
>
>     nvme{0,1} =3D>
>         raid mirror /dev/md0 =3D>
>             LVM PV for VG "data" =3D>
>                 tmeta for dm-thin
>
>     /dev/sda (LSI-based Hardware RAID)
>         bcache =3D>
>             LVM PV for VG "data" =3D>
>                 tdata for dm-thin "pool0" =3D>
>                     single thin volume from the pool =3D>
>                         drbd to another host over the network
>
> After adding dm-integrity, the stack is the same as above except that
> the RAID mirror is above dm-integrity:
>
>     nvme{0,1} =3D>
>         dm-integrity =3D>
>             raid mirror /dev/md0 =3D>
>                 LVM PV for VG "data" =3D>
>                     tmeta for dm-thin
>
> The first time we had the thindump+IO hang problem we thought that an
> underlying NVMe drive was bad, so we replaced both: We rebooted and did
> a `pvmove` of the tmeta volume to different NVMe+md-raid1+dm-integrity
> on disks that were brand new, but had the same issue that night during
> reserve_metadata_snap+thin_dump.
>
> Since we had the same problem on a different set of new NVMe disks, we
> rebooted, did a `pvmove` back to the original MD RAID1 mirror stack
> _without_ dm-integrity, and everything was back to normal.  Thus, I do no=
t
> think it is a disk or tmeta corruption issue, but an obscure race or
> deadlock bug.
>
> We tried to reproduce this in a virtual environment, but so far it has no=
t
> triggered. In about a week when we get downtime for this system, I will
> take a copy of its thin metadata to inspect further. For now, I have not
> yet been enable to reproduce problem outside our semi-production testing
> environment.
>
> So, this is what we see so far:
>
> We get _thousands_ of these lines in the kernel logs when IO hangs. The
> `dm-175` device is one of the the dm-integrity targets being mirrored.
> Note the "12924 callbacks suppressed" message:
>
>         [  +0.584816] raid1_end_read_request: 12924 callbacks suppressed
>         [  +0.000006] md/raid1:md0: dm-175: rescheduling sector 197968221=
6
>         [  +0.020011] md/raid1:md0: dm-175: rescheduling sector 197968221=
6
>         [  +0.019462] md/raid1:md0: dm-175: rescheduling sector 197968221=
6
>         [  +0.018672] md/raid1:md0: dm-175: rescheduling sector 197968221=
6
>         [  +0.006242] md/raid1:md0: dm-175: rescheduling sector 197968221=
6
>         [  +0.002399] md/raid1:md0: dm-175: rescheduling sector 197968221=
6
>         [  +0.000934] md/raid1:md0: dm-175: rescheduling sector 197968221=
6
>         [  +0.000688] md/raid1:md0: dm-175: rescheduling sector 197968221=
6
>         [  +0.001161] md/raid1:md0: dm-175: rescheduling sector 197968221=
6
>         [  +0.006404] md/raid1:md0: dm-175: rescheduling sector 197968221=
6
>         [  +3.594380] integrity_metadata: 13095 callbacks suppressed
>         [  +0.000006] device-mapper: integrity: dm-175: Checksum failed a=
t sector 0x760395b0
>         [  +0.001410] device-mapper: integrity: dm-175: Checksum failed a=
t sector 0x760395b0
>         [  +0.000824] device-mapper: integrity: dm-175: Checksum failed a=
t sector 0x760395b0
>         [  +0.003587] device-mapper: integrity: dm-175: Checksum failed a=
t sector 0x760395b0
>         [  +0.011065] device-mapper: integrity: dm-175: Checksum failed a=
t sector 0x760395b0
>         [  +0.004176] device-mapper: integrity: dm-175: Checksum failed a=
t sector 0x760395b0
>         [  +0.000604] device-mapper: integrity: dm-175: Checksum failed a=
t sector 0x760395b0
>         [  +0.006153] device-mapper: integrity: dm-175: Checksum failed a=
t sector 0x760395b0
>         [  +0.008797] device-mapper: integrity: dm-175: Checksum failed a=
t sector 0x760395b0
>         [  +0.002350] device-mapper: integrity: dm-175: Checksum failed a=
t sector 0x760395b0
>         [  +0.668866] raid1_read_request: 12747 callbacks suppressed
>         [  +0.000005] md/raid1:md0: redirecting sector 1979682216 to othe=
r mirror: dm-175
>         [  +0.024708] md/raid1:md0: redirecting sector 1979682216 to othe=
r mirror: dm-175
>         [  +0.024441] md/raid1:md0: redirecting sector 1979682216 to othe=
r mirror: dm-175
>         [  +0.018321] md/raid1:md0: redirecting sector 1979682216 to othe=
r mirror: dm-175
>         [  +0.000850] md/raid1:md0: redirecting sector 1979682216 to othe=
r mirror: dm-175
>         [  +0.004479] md/raid1:md0: redirecting sector 1979682216 to othe=
r mirror: dm-175
>         [  +0.001225] md/raid1:md0: redirecting sector 1979682216 to othe=
r mirror: dm-175
>         [  +0.001024] md/raid1:md0: redirecting sector 1979682216 to othe=
r mirror: dm-175
>         [  +0.000741] md/raid1:md0: redirecting sector 1979682216 to othe=
r mirror: dm-175
>         [  +0.001094] md/raid1:md0: redirecting sector 1979682216 to othe=
r mirror: dm-175

Hi all

The process is as follows and I add some logs
1. raid1_read_request submits bio to read data
2. raid1_end_read finds the read request fails and try to fix the read erro=
r
3. handle_read_error>fix_read_error tries to read data in 4K unit in
another disk, write to the failed disk in 4K unit and read from the
failed disk in 4K unit. fix_read_error finishes successfully.
4. handle_read_error re-read data from the failed disk. And the read
request fails again.
[ 1067.149829] device-mapper: integrity: dm-3: Checksum failed at sector 0x=
17d8
[ 1067.149842] md/raid1:md9: dm-3: rescheduling sector 3912, sectors 248
[ 1067.150437] md/raid1:md9: dm-3: fix read error 3912, sectors 248
[ 1067.150439] md/raid1:md9: dm-3: re read 3912, sectors 248

It looks like the bio size is suspicious. Because it reads
successfully when bio size is 4K.

Best Regards
Xiao

>
> Here are two traces of hung tasks that the kernel reported in dmesg. The
> decoded line numbers are at the bottom of this email.
>
> It looks like dmeventd is checking metadata transaction IDs, and then
> hangs. We believe that is snapshot was being made at the moment that IOs
> hung. This trace only appears once:
>
>         INFO: task dmeventd:3718459 blocked for more than 122 seconds.
>              Tainted: G            E      6.5.7 #23
>         "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
>         task:dmeventd        state:D stack:0     pid:3718459 ppid:1      =
flags:0x00000002
>         Call Trace:
>         <TASK>
>         __schedule+0x2d7/0x800
>         schedule+0x5e/0xe0
>         schedule_preempt_disabled+0x15/0x30
>         rwsem_down_read_slowpath+0x2c4/0x5f0
>         ? lock_acquire+0x10b/0x120
>         down_read+0xff/0x260
>         dm_pool_get_metadata_transaction_id+0x24/0x60 [dm_thin_pool]
>         pool_status+0x133/0x630 [dm_thin_pool]
>         retrieve_status+0xc4/0x210 [dm_mod]
>         table_status+0x9c/0x150 [dm_mod]
>         ctl_ioctl+0x248/0x370 [dm_mod]
>         ? __pfx_table_status+0x10/0x10 [dm_mod]
>         dm_ctl_ioctl+0xe/0x20 [dm_mod]
>         __x64_sys_ioctl+0x99/0xe0
>         do_syscall_64+0x3f/0xa0
>         entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>
> In the next trace below, you can see that DRBD is trying to write to it's
> thin volume backing device, and thin metadata is being manipulated it by
> dm-thin (which is above md raid1 with dm-integrity), but hangs during
> `dm_thin_find_block`:
>
> This trace appears several times for different DRBD volumes that are
> backed by thin volumes in the same pool.  Except that the thin volume
> differs, the traces are the same:
>
>         INFO: task drbd_r_secServe:1072212 blocked for more than 122 seco=
nds.
>              Tainted: G            E      6.5.7 #23
>         "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this =
message.
>         task:drbd_r_secServe state:D stack:0     pid:1072212 ppid:2      =
flags:0x00004000
>         Call Trace:
>         <TASK>
>         __schedule+0x2d7/0x800
>         schedule+0x5e/0xe0
>         schedule_preempt_disabled+0x15/0x30
>         rwsem_down_read_slowpath+0x2c4/0x5f0
>         ? dm_thin_find_block+0x32/0x90 [dm_thin_pool]
>         down_read+0xff/0x260
>         dm_thin_find_block+0x32/0x90 [dm_thin_pool]
>         thin_bio_map.isra.0+0x169/0x3a0 [dm_thin_pool]
>         __map_bio+0x49/0x1d0 [dm_mod]
>         dm_split_and_process_bio+0x21c/0x580 [dm_mod]
>         dm_submit_bio+0x64/0x170 [dm_mod]
>         __submit_bio+0x7e/0xd0
>         __submit_bio_noacct+0x90/0x200
>         drbd_submit_peer_request+0x138/0x2d0 [drbd]
>         receive_DataRequest+0x244/0x710 [drbd]
>         ? __pfx_receive_DataRequest+0x10/0x10 [drbd]
>         drbdd+0x174/0x280 [drbd]
>         ? __pfx_drbd_thread_setup+0x10/0x10 [drbd]
>         drbd_receiver+0x51/0xd0 [drbd]
>         drbd_thread_setup+0xa3/0x1b0 [drbd]
>         kthread+0xe9/0x120
>         ? __pfx_kthread+0x10/0x10
>         ret_from_fork+0x34/0x50
>         ? __pfx_kthread+0x10/0x10
>         ret_from_fork_asm+0x1b/0x30
>         </TASK>
>
> This is the call stack of the thin_dump command, its just waiting:
>
>         # thin_dump -f xml --dev-id 671125 -m /dev/mapper/data-pool0_tmet=
a
>         ...
>
>         # cat /proc/4016388/stack
>         [<0>] submit_bio_wait+0x7a/0xc0
>         [<0>] __blkdev_direct_IO_simple+0x130/0x280
>         [<0>] blkdev_read_iter+0xb8/0x150
>         [<0>] do_iter_readv_writev+0x14e/0x160
>         [<0>] do_iter_read+0x125/0x1c0
>         [<0>] vfs_readv+0xa8/0xf0
>         [<0>] __x64_sys_preadv+0xc0/0x100
>         [<0>] do_syscall_64+0x3f/0xa0
>         [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>
>
>
> These are the line number decodes for the above traces:
>
> trace 1:
>         kernel: INFO: task dmeventd:3718459 blocked for more than 122 sec=
onds.
>         __schedule (kernel/sched/core.c:5381 kernel/sched/core.c:6710)
>         schedule (./arch/x86/include/asm/preempt.h:85 (discriminator 1) k=
ernel/sched/core.c:6787 (discriminator 1))
>         schedule_preempt_disabled (./arch/x86/include/asm/preempt.h:80 ke=
rnel/sched/core.c:6846)
>         rwsem_down_read_slowpath (kernel/locking/rwsem.c:1073)
>         ? lock_acquire (./include/trace/events/lock.h:24 kernel/locking/l=
ockdep.c:5724)
>         down_read (kernel/locking/rwsem.c:1250 kernel/locking/rwsem.c:126=
3 kernel/locking/rwsem.c:1522)
>         dm_pool_get_metadata_transaction_id (drivers/md/dm-thin-metadata.=
c:1323) dm_thin_pool
>         pool_status (drivers/md/dm-thin.c:3944) dm_thin_pool
>         retrieve_status (./include/linux/fortify-string.h:214 drivers/md/=
dm-ioctl.c:1316) dm_mod
>         table_status (drivers/md/dm-ioctl.c:1707) dm_mod
>         ctl_ioctl (drivers/md/dm-ioctl.c:2083) dm_mod
>         ? __pfx_table_status (drivers/md/dm-ioctl.c:1693) dm_mod
>         dm_ctl_ioctl (drivers/md/dm-ioctl.c:2103) dm_mod
>         __x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:870 fs/ioctl.c:856 fs/i=
octl.c:856)
>         do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c=
:80)
>         entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
>
>
> trace 2:
>         kernel: INFO: task drbd_r_secServe:1072212 blocked for more than =
122 seconds.
>         __schedule (kernel/sched/core.c:5381 kernel/sched/core.c:6710)
>         schedule (./arch/x86/include/asm/preempt.h:85 (discriminator 1) k=
ernel/sched/core.c:6787 (discriminator 1))
>         schedule_preempt_disabled (./arch/x86/include/asm/preempt.h:80 ke=
rnel/sched/core.c:6846)
>         rwsem_down_read_slowpath (kernel/locking/rwsem.c:1073)
>         ? dm_thin_find_block (drivers/md/dm-thin-metadata.c:1574) dm_thin=
_pool
>         down_read (kernel/locking/rwsem.c:1250 kernel/locking/rwsem.c:126=
3 kernel/locking/rwsem.c:1522)
>         dm_thin_find_block (drivers/md/dm-thin-metadata.c:1574) dm_thin_p=
ool
>         thin_bio_map.isra.0 (drivers/md/dm-thin.c:2764) dm_thin_pool
>         __map_bio (drivers/md/dm.c:1427) dm_mod
>         dm_split_and_process_bio (drivers/md/dm.c:1729 drivers/md/dm.c:17=
82) dm_mod
>         dm_submit_bio (drivers/md/dm.c:1835) dm_mod
>         __submit_bio (block/blk-core.c:373 block/blk-core.c:603)
>         __submit_bio_noacct (./include/linux/bio.h:624 block/blk-core.c:6=
53)
>         drbd_submit_peer_request (drivers/block/drbd/drbd_receiver.c:1723=
) drbd
>         receive_DataRequest (drivers/block/drbd/drbd_receiver.c:2993) drb=
d
>         ? __pfx_receive_DataRequest (drivers/block/drbd/drbd_receiver.c:2=
803) drbd
>         drbdd (drivers/block/drbd/drbd_receiver.c:5092) drbd
>         ? __pfx_drbd_thread_setup (drivers/block/drbd/drbd_main.c:310) dr=
bd
>         drbd_receiver (drivers/block/drbd/drbd_receiver.c:5561) drbd
>         drbd_thread_setup (drivers/block/drbd/drbd_main.c:325) drbd
>         kthread (kernel/kthread.c:389)
>         ? __pfx_kthread (kernel/kthread.c:342)
>         ret_from_fork (arch/x86/kernel/process.c:151)
>         ? __pfx_kthread (kernel/kthread.c:342)
>         ret_from_fork_asm (arch/x86/entry/entry_64.S:312)
>
> trace 3:
>         # thin_dump -f xml --dev-id 671125 -m /dev/mapper/data-pool0_tmet=
a
>         <hung>
>
>         # cat /proc/4016388/stack
>         submit_bio_wait (block/bio.c:1370 (discriminator 1))
>         __blkdev_direct_IO_simple (./include/linux/bio.h:495 block/fops.c=
:99)
>         blkdev_read_iter (block/fops.c:608)
>         do_iter_readv_writev (./include/linux/fs.h:1871)
>         do_iter_read (fs/read_write.c:795)
>         vfs_readv (fs/read_write.c:916)
>         __x64_sys_preadv (fs/read_write.c:1007 fs/read_write.c:1057 fs/re=
ad_write.c:1052 fs/read_write.c:1052)
>         do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c=
:80)
>         entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
>
>
>
> --
> Eric Wheeler
>

