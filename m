Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D8B3F2101;
	Mon, 15 Jun 2026 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781527858; cv=none; b=g0XSM0jrAB/VFtMpC0N4r3TS67GqqdTCd0jsiHDr89/J6e81EHe1UXN508jI1SkWC5kINO//2ba9r791iFobnT/UKAikLqL7PtJgEjgo1mf6oXn5B8VZmNbNjztfOSwhxHG7jOkCffgN7jdEqPg5x4Ftvp9wU2P4smWSKctFG/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781527858; c=relaxed/simple;
	bh=LgRr811AidPC7U3MxiWhWmV+JqyoCtcdb2Dn3kuwJZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=My5S6f9gtkZ83o58+8AHUxPEwLd1YECB+UVCUCHGpefpnc7qBXGpghkobSoGVEtje0KhWfaejhPrzMrLK8lvbF1t0AePOYnTn/CpLLromKedpCDqSeRoZiil+2L/oK8PV4AxI8O9KQFoK0oUx7kqjj3p878bOp14qgUnJjOQoUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=OciTq0lu; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="OciTq0lu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=M1+d1+h6ftWSJpClSN8ye1EBWvGR1c4fB7lrTrfGH5Q=; b=OciTq0luBVQPA8hu
	x7DOlrDStBsgm+NTQnsdXBRdNQbuNkWFrFRJki1Vge6Dm8NwOR5l05PDtzQzL1HmKIgMXOH6o+S3W
	/pv37x+rxwGo/cxg9Xml0GCbCyUQdEyYVFVUcs9WP0emQrrHBXcoLkxW5hrr6wjUrxMXbdvphNp8T
	aTZrkJn6BJ68JnFgvlVJEzmj7pHH7najihiJ8V4H7l1//OOwQ28WZt9qCOEEhZDRSL9wHPe51ZacV
	NamAqjaNKu2ov+kPZh6gNjkRCBylk6Hj5OyIIt2bB0sM5rV/Uq7nwSsy5BilL1fkiR1KjnmjFJHZU
	cbvyzEVdM88LdhBoqQ==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZ6mD-00000007jAT-0zcd;
	Mon, 15 Jun 2026 12:50:53 +0000
Date: Mon, 15 Jun 2026 12:50:53 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Thorsten Leemhuis <regressions@leemhuis.info>, kbusch@kernel.org,
	vklimovs@gmail.com, trnka@scm.com
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ai_1LYtofh1fwD-N@gallifrey>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 12:32:40 up 30 days, 15:45,  2 users,  load average: 0.06, 0.06,
 0.01
User-Agent: Mutt/2.2.13 (2024-03-09)

* Thorsten Leemhuis (regressions@leemhuis.info) wrote:
> On 6/14/26 19:57, Dr. David Alan Gilbert wrote:
> >
> >   I've got a repeatable raid hang/warn and would appreciate some pointers
> > as where to debug.
> >   (I've been logging stuff on  https://bugzilla.kernel.org/show_bug.cgi?id=221535 )
> 
> Note: not my area of expertise, so I might be sending you totally
> off-track with this comment. Feel free to ignore it. But FWIW:

Hi Thorsten,
  Thanks for the reply - these do seem to be related!
(So copying in Keith, Vjaceslavs, and Tomáš )
(Not my area either).

> Have you seen these reports?
> https://lore.kernel.org/all/2982107.4sosBPzcNG@electra/
> https://lore.kernel.org/all/CAC_j7i1R7oy+nRhxEjCTba=DUgn02w9X+p94DCu0aHv5+5tKnQ@mail.gmail.com/

I hadn't!  Those are both the problem I originally was trying to debug
and stumbled into the WARN/BUG/hang with my test program.

> The former lead to a fix in the mdraid code that should be in the kernel
> version you are using. But in a reply to the latter report the repoter
> claimed that that fix is not enough (claiming "this was obvious" and
> also using dm), but things then stalled there.

Yeh I see my world has Keith's f7b24c7b41f23

I think the problem I'm seeing is zero length requests coming from somewhere.

The WARN I'm seeing in 7.1.0-rc7+ is:

[ 2681.597042] device-mapper: raid1: Mirror read failed from 252:25. Trying alternative device.
[ 2681.631933] ------------[ cut here ]------------
[ 2681.631939] WARNING: block/bio.c:1044 at bio_add_page+0x18b/0x250, CPU#22: kworker/22:0/18929

1039 int bio_add_page(struct bio *bio, struct page *page,
1040                  unsigned int len, unsigned int offset)
1041 {
1042         if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
1043                 return 0;
1044         if (WARN_ON_ONCE(len == 0))
1045                 return 0;

So it's the ' if (WARN_ON_ONCE(len == 0))'

and the warn I got on the older 7.0.8 was:
[Sun May 17 17:22:52 2026] WARNING: drivers/scsi/scsi_lib.c:1140 at scsi_alloc_sgtables+0x38a/0x400, CPU#28: kworker/28:1H/3943

which I *think* corresponds to:
1164         if (WARN_ON_ONCE(!nr_segs))
1165                 return BLK_STS_IOERR;

so it sounds like we need to find where zero length requests are coming from??

Thanks again,

Dave

> Ciao, Thorsten
> 
> >   This started off as debugging a case where I'd get my RAID1 (on the host)
> > getting a reliable 'rescheduling sector'/disk failure while running the qemu block test suite
> > during a qemu build, but then I tried to build a smaller discrete
> > test, and now I've got a simply triggerable warn and test hang.
> > There's no errors from the underlying SATA layer on the storage,
> > everything resyncs just fine.
> > 
> > I've got an existing LVM vg ('main') with two mirrors on sda2, and sdb2
> > which are SATA disks.
> > 
> > # lvcreate --type mirror --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> > # mkfs.ext4 /dev/mapper/main-lvol0
> > # mount /dev/mapper/main-lvol0 /mnt/tmp/
> > # chmod a+rwx /mnt/tmp
> > 
> > $ dd if=/dev/zero of=/mnt/tmp/testfile bs=1024k count=1
> > 
> > (I then wait for the IO to stop)
> > 
> > then we've got this little test program:
> > 
> > <--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><-->
> > #include <errno.h>
> > #include <fcntl.h>             
> > #include <asm-generic/fcntl.h>
> > #include <stdio.h> 
> > #include <unistd.h>
> > 
> > 
> > const char* path="/mnt/tmp/testfile";
> > static char buf[8192];
> > 
> > int main()                                       
> > {
> >   int fd=open(path, O_RDWR|O_DIRECT|O_CLOEXEC);
> >     
> >   errno=0;
> >   int res3=pread(fd, buf, 4096, 0);
> >   printf("pread of 4096 said: %d (%m)\n", res3);
> > 
> > }
> > <--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><--><-->
> > 
> > running that, either hangs or gets a 'pread of 4096 said: -1 (Input/output error)'
> > when it hangs it's unkillable.
> > 
> > at the moment (on 7.1.0-rc7) this is giving:
> > Jun 14 18:08:32 dalek kernel: device-mapper: raid1: Mirror read failed from 252:24. Trying alternative device.
> > Jun 14 18:08:32 dalek kernel: ------------[ cut here ]------------
> > Jun 14 18:08:32 dalek dmeventd[1010]: Primary mirror device 252:24 read failed.
> > Jun 14 18:08:32 dalek kernel: WARNING: block/bio.c:1044 at bio_add_page+0x18b/0x250, CPU#15: kworker/15:1/369
> > 
> > (full backtrace below)
> > (Note there is a moan in there about sdb IO error - repeated a lot - but
> > again, there's no SATA level errors, and the drive is fine on smart, and
> > I can read the whole of the underlying lvm mirrors, so I don't think it's
> > physically there).
> > 
> > I did a blktrace, although that gives me a 23G blkparse output, hmm
> > (I see each event repeated a lot - maybe per thread?)
> > 
> > 252,26  15        1     0.000000000  3435  Q  RS 264192 + 8 [dbf]
> >   252,26 is /dev/mapper/main-lvol0
> > 252,24  15        1     0.000005501  3435  A  RS 264192 + 8 <- (252,26) 264192
> >   252,24 is main-lvol0_mimage_0
> > 252,24  15        2     0.000005761  3435  Q  RS 264192 + 8 [dbf]
> >   8,0   15        1     0.000008646  3435  A  RS 71634944 + 8 <- (252,24) 264192
> >     so that's sda 
> >   8,0   15        2     0.000008787  3435  A  RS 73734144 + 8 <- (8,2) 71634944
> >     I guess mapping down from sda2 to sda
> >   8,0   15        3     0.000009037  3435  Q  RS 73734144 + 8 [dbf]
> >   8,0   15        4     0.000009809  3435  C  RS 73734144 + 8 [65514]
> >       ??? Hmm what's the 65514 there?
> > 252,24  15        3     0.000010320  3435  C  RS 264192 + 8 [65514]
> > 252,25  15        1     0.000290384   369  Q   R 264192 + 8 [kworker/15:1]
> >    252,25 is main-lvol0_mimage_1
> > 
> > and at this point I'm a bit lost as to what I'm looking for.
> > 
> > Hints appreciated!
> > 
> > (I don't believe this is a regression - or at least not recent)
> > 
> > Dave
> > 
> > 
> > 
> > 
> > Jun 14 18:08:32 dalek kernel: device-mapper: raid1: Mirror read failed from 252:24. Trying alternative device.
> > Jun 14 18:08:32 dalek kernel: ------------[ cut here ]------------
> > Jun 14 18:08:32 dalek dmeventd[1010]: Primary mirror device 252:24 read failed.
> > Jun 14 18:08:32 dalek kernel: WARNING: block/bio.c:1044 at bio_add_page+0x18b/0x250, CPU#15: kworker/15:1/369
> > Jun 14 18:08:32 dalek dmeventd[1010]: main-lvol0 is now in-sync.
> > Jun 14 18:08:32 dalek kernel: Modules linked in: nft_masq nft_reject_ipv4 act_csum cls_u32 sch_htb nf_nat_tftp nf_conntrack_tftp bridge stp llc rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reje>
> > Jun 14 18:08:32 dalek kernel:  drm_panel_backlight_quirks gpu_sched drm_suballoc_helper video nvme drm_display_helper nvme_core cec nvme_keyring sp5100_tco nvme_auth wmi serio_raw fuse scsi_dh_alua i2c_dev scsi_dh_rdac scsi_dh_emc
> > Jun 14 18:08:32 dalek kernel: CPU: 15 UID: 0 PID: 369 Comm: kworker/15:1 Not tainted 7.1.0-rc7+ #786 PREEMPT(lazy) 
> > Jun 14 18:08:32 dalek kernel: Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X570 Pro4, BIOS P3.10 07/13/2020
> > Jun 14 18:08:32 dalek kernel: Workqueue: kmirrord do_mirror
> > Jun 14 18:08:32 dalek kernel: RIP: 0010:bio_add_page+0x18b/0x250
> > Jun 14 18:08:32 dalek kernel: Code: 24 10 4c 8b 04 24 84 c0 0f 85 c9 00 00 00 41 0f b7 40 78 48 8b 74 24 08 8b 4c 24 14 e9 b4 fe ff ff 0f 0b 31 c0 e9 55 d1 af 00 <0f> 0b eb f5 48 8b 7f 08 83 7f 60 05 0f 85 00 ff ff ff 49 8b 3b 4c
> > Jun 14 18:08:32 dalek kernel: RSP: 0018:ffffd1fb8176fc10 EFLAGS: 00010246
> > Jun 14 18:08:32 dalek kernel: RAX: 0000000000000000 RBX: ffffd1fb8176fd18 RCX: 0000000000000000
> > Jun 14 18:08:32 dalek kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8d1a8eb28b00
> > Jun 14 18:08:32 dalek kernel: RBP: 0000000000000000 R08: ffffd1fb8176fc38 R09: ffffd1fb8176fc40
> > Jun 14 18:08:32 dalek kernel: R10: ffffd1fb8176fc34 R11: 0000000000000000 R12: 0000000000000000
> > Jun 14 18:08:32 dalek kernel: R13: ffffd1fb8176fd90 R14: 0000000000000001 R15: ffff8d1a8eb28b00
> > Jun 14 18:08:32 dalek kernel: FS:  0000000000000000(0000) GS:ffff8d29d161f000(0000) knlGS:0000000000000000
> > Jun 14 18:08:32 dalek kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Jun 14 18:08:32 dalek kernel: CR2: 00007f0ddcd7b9d0 CR3: 000000023dcbf000 CR4: 0000000000350ef0
> > Jun 14 18:08:32 dalek kernel: Call Trace:
> > Jun 14 18:08:32 dalek kernel:  <TASK>
> > Jun 14 18:08:32 dalek kernel:  do_region+0x227/0x2a0
> > Jun 14 18:08:32 dalek kernel:  dispatch_io+0xf1/0x150
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_get_page+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_next_page+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_read_callback+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  dm_io+0x169/0x2d0
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_get_page+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_next_page+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  do_reads+0x149/0x230
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_read_callback+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  do_mirror+0x11a/0x2b0
> > Jun 14 18:08:32 dalek kernel:  process_one_work+0x19e/0x390
> > Jun 14 18:08:32 dalek kernel:  worker_thread+0x1a6/0x310
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_worker_thread+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  kthread+0xe4/0x120
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_kthread+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  ret_from_fork+0x1a1/0x270
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_kthread+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  ret_from_fork_asm+0x1a/0x30
> > Jun 14 18:08:32 dalek kernel:  </TASK>
> > Jun 14 18:08:32 dalek kernel: ---[ end trace 0000000000000000 ]---
> > Jun 14 18:08:32 dalek kernel: ------------[ cut here ]------------
> > Jun 14 18:08:32 dalek kernel: WARNING: drivers/scsi/scsi_lib.c:1164 at scsi_alloc_sgtables+0x38a/0x400, CPU#15: kworker/15:1/369
> > Jun 14 18:08:32 dalek kernel: Modules linked in: nft_masq nft_reject_ipv4 act_csum cls_u32 sch_htb nf_nat_tftp nf_conntrack_tftp bridge stp llc rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reje>
> > Jun 14 18:08:32 dalek kernel:  drm_panel_backlight_quirks gpu_sched drm_suballoc_helper video nvme drm_display_helper nvme_core cec nvme_keyring sp5100_tco nvme_auth wmi serio_raw fuse scsi_dh_alua i2c_dev scsi_dh_rdac scsi_dh_emc
> > Jun 14 18:08:32 dalek kernel: CPU: 15 UID: 0 PID: 369 Comm: kworker/15:1 Tainted: G        W           7.1.0-rc7+ #786 PREEMPT(lazy) 
> > Jun 14 18:08:32 dalek kernel: Tainted: [W]=WARN
> > Jun 14 18:08:32 dalek kernel: Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X570 Pro4, BIOS P3.10 07/13/2020
> > Jun 14 18:08:32 dalek kernel: Workqueue: kmirrord do_mirror
> > Jun 14 18:08:32 dalek kernel: RIP: 0010:scsi_alloc_sgtables+0x38a/0x400
> > Jun 14 18:08:32 dalek kernel: Code: 8b 3d ba 2d a9 01 e9 d1 fd ff ff 48 8b 75 00 48 8d bb f0 fe ff ff e8 15 b7 b0 ff 48 89 ab e0 00 00 00 89 45 08 e9 30 ff ff ff <0f> 0b 4c 8b 6c 24 30 b8 0a 00 00 00 e9 21 ff ff ff b8 09 00 00 00
> > Jun 14 18:08:32 dalek kernel: RSP: 0018:ffffd1fb8176f7f0 EFLAGS: 00010246
> > Jun 14 18:08:32 dalek kernel: RAX: 0000000000000000 RBX: ffff8d1aedad0110 RCX: 0000000000000009
> > Jun 14 18:08:32 dalek kernel: RDX: 0000000000000000 RSI: ffffffff99c15960 RDI: ffff8d1aedad0110
> > Jun 14 18:08:32 dalek kernel: RBP: ffff8d1a93d17000 R08: ffff8d1aedad0110 R09: ffff8d1a818fa800
> > Jun 14 18:08:32 dalek kernel: R10: 7020676e69736961 R11: 0000000000000000 R12: 0000000000000000
> > Jun 14 18:08:32 dalek kernel: R13: 0000000000000000 R14: ffff8d1a93394000 R15: ffff8d1a93d17000
> > Jun 14 18:08:32 dalek kernel: FS:  0000000000000000(0000) GS:ffff8d29d161f000(0000) knlGS:0000000000000000
> > Jun 14 18:08:32 dalek kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Jun 14 18:08:32 dalek kernel: CR2: 00007f0ddcd7b9d0 CR3: 000000023dcbf000 CR4: 0000000000350ef0
> > Jun 14 18:08:32 dalek kernel: Call Trace:
> > Jun 14 18:08:32 dalek kernel:  <TASK>
> > Jun 14 18:08:32 dalek kernel:  ? srso_return_thunk+0x5/0x5f
> > Jun 14 18:08:32 dalek kernel:  sd_setup_read_write_cmnd+0x9d/0x740
> > Jun 14 18:08:32 dalek kernel:  ? srso_return_thunk+0x5/0x5f
> > Jun 14 18:08:32 dalek kernel:  scsi_queue_rq+0x4d2/0x890
> > Jun 14 18:08:32 dalek kernel:  blk_mq_dispatch_rq_list+0x241/0x530
> > Jun 14 18:08:32 dalek kernel:  ? srso_return_thunk+0x5/0x5f
> > Jun 14 18:08:32 dalek kernel:  ? sbitmap_get+0x61/0x100
> > Jun 14 18:08:32 dalek kernel:  __blk_mq_do_dispatch_sched+0x330/0x340
> > Jun 14 18:08:32 dalek kernel:  __blk_mq_sched_dispatch_requests+0x143/0x180
> > Jun 14 18:08:32 dalek kernel:  blk_mq_sched_dispatch_requests+0x2d/0x70
> > Jun 14 18:08:32 dalek kernel:  blk_mq_run_hw_queue+0x2bf/0x350
> > Jun 14 18:08:32 dalek kernel:  ? srso_return_thunk+0x5/0x5f
> > Jun 14 18:08:32 dalek kernel:  blk_mq_dispatch_list+0x172/0x350
> > Jun 14 18:08:32 dalek kernel:  blk_mq_flush_plug_list+0x51/0x1a0
> > Jun 14 18:08:32 dalek kernel:  ? blk_mq_submit_bio+0x71c/0x9f0
> > Jun 14 18:08:32 dalek kernel:  __blk_flush_plug+0x112/0x180
> > Jun 14 18:08:32 dalek kernel:  ? srso_return_thunk+0x5/0x5f
> > Jun 14 18:08:32 dalek kernel:  __submit_bio+0x19c/0x260
> > Jun 14 18:08:32 dalek kernel:  __submit_bio_noacct+0x8e/0x210
> > Jun 14 18:08:32 dalek kernel:  do_region+0x14c/0x2a0
> > Jun 14 18:08:32 dalek kernel:  dispatch_io+0xf1/0x150
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_get_page+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_next_page+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_read_callback+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  dm_io+0x169/0x2d0
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_get_page+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_bio_next_page+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  do_reads+0x149/0x230
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_read_callback+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  do_mirror+0x11a/0x2b0
> > Jun 14 18:08:32 dalek kernel:  process_one_work+0x19e/0x390
> > Jun 14 18:08:32 dalek kernel:  worker_thread+0x1a6/0x310
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_worker_thread+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  kthread+0xe4/0x120
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_kthread+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  ret_from_fork+0x1a1/0x270
> > Jun 14 18:08:32 dalek kernel:  ? __pfx_kthread+0x10/0x10
> > Jun 14 18:08:32 dalek kernel:  ret_from_fork_asm+0x1a/0x30
> > Jun 14 18:08:32 dalek kernel:  </TASK>
> > Jun 14 18:08:32 dalek kernel: ---[ end trace 0000000000000000 ]---
> > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > Jun 14 18:08:32 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > Jun 14 18:08:37 dalek kernel: blk_print_req_error: 241000 callbacks suppressed
> > Jun 14 18:08:37 dalek kernel: I/O error, dev sdb, sector 50606087 op 0x0:(READ) flags 0x0 phys_seg 0 prio class 2
> > 
> > 
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
