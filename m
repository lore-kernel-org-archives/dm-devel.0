Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415E540313F;
	Mon, 15 Jun 2026 15:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781536826; cv=none; b=V/dnqeEw/PYi9eJiy9S/oRw3DPbAHJs5kWUCGOJcEup1NvhSUFcAysAiFgGgW7bpAdbAacik2Nl44gogbW1XlX1T/NBemyR0RFoUwWquX8ZDFSWDGst4yzuV+LNldu4z1MyD7x5ZyBsfA1SIFACq54qfS4xMlR+JzrRJqEUDQoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781536826; c=relaxed/simple;
	bh=avdt4c2mHPT5v2FSu1I85m+T66Wp6hii6Eye7zrlF6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gdBcc7YDN0ozBX/O596BoQXagDFgnLr9utMrg/SiXaA7avNgtlWXMMpgFT+vK9DYDR6ooAjpfkmy084GuhIgU7B0WdE23knir3hTEKchAevb+vfNAK71oYvTpTP8dBauvKTpIQMhNfjzrodliruRVEhUWiIDgyP0O3vDnqxbzTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jvr/8MJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jvr/8MJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB431F00A3A;
	Mon, 15 Jun 2026 15:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781536825;
	bh=dGPgcbJdO0lRl03JxxXlyEHfZe8b6Vwnet2GCTbESy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jvr/8MJfCA/a9Z+fEroNJxIRrD4cGbVvLyGWSHKBFzT5iRUf9llvPm6wyY2NXXQrT
	 I8rAIjQY7S3Fd2zUBiP2/O6yKFLjg6qltRT/o45cHgQHZRB4m3lkl9sZAR/Azhf0wH
	 oMuiPrIp7X/EeVBTC6SuuCEqYh2TwAdG339rW5FNDbgIr0Wk4BkEPaw8lXx3IZzdVH
	 Kk2JLSs8M6BVw4g+oln/A0lj+0mUzVxa83BDM0GJWjm9tT3SLsQ/sdjz/sXhR7Q8Zt
	 L5f1MaBWU7gj+IftJ33Pj2rak3lATuDdRTp769gmqlcrS/DU9FKnOj0JBFCpanuCfs
	 EkL0j9QFYjrMQ==
Date: Mon, 15 Jun 2026 09:20:23 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajAYN_mmjzYBAimV@kbusch-mbp>
References: <ai7rnH20IYeSmY8s@gallifrey>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai7rnH20IYeSmY8s@gallifrey>

On Sun, Jun 14, 2026 at 05:57:48PM +0000, Dr. David Alan Gilbert wrote:
> Jun 14 18:08:32 dalek kernel: device-mapper: raid1: Mirror read failed from 252:24. Trying alternative device.
> Jun 14 18:08:32 dalek kernel: ------------[ cut here ]------------
> Jun 14 18:08:32 dalek dmeventd[1010]: Primary mirror device 252:24 read failed.
> Jun 14 18:08:32 dalek kernel: WARNING: block/bio.c:1044 at bio_add_page+0x18b/0x250, CPU#15: kworker/15:1/369
> Jun 14 18:08:32 dalek dmeventd[1010]: main-lvol0 is now in-sync.
> Jun 14 18:08:32 dalek kernel: Modules linked in: nft_masq nft_reject_ipv4 act_csum cls_u32 sch_htb nf_nat_tftp nf_conntrack_tftp bridge stp llc rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reje>
> Jun 14 18:08:32 dalek kernel:  drm_panel_backlight_quirks gpu_sched drm_suballoc_helper video nvme drm_display_helper nvme_core cec nvme_keyring sp5100_tco nvme_auth wmi serio_raw fuse scsi_dh_alua i2c_dev scsi_dh_rdac scsi_dh_emc
> Jun 14 18:08:32 dalek kernel: CPU: 15 UID: 0 PID: 369 Comm: kworker/15:1 Not tainted 7.1.0-rc7+ #786 PREEMPT(lazy) 
> Jun 14 18:08:32 dalek kernel: Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X570 Pro4, BIOS P3.10 07/13/2020
> Jun 14 18:08:32 dalek kernel: Workqueue: kmirrord do_mirror
> Jun 14 18:08:32 dalek kernel: RIP: 0010:bio_add_page+0x18b/0x250
> Jun 14 18:08:32 dalek kernel: Code: 24 10 4c 8b 04 24 84 c0 0f 85 c9 00 00 00 41 0f b7 40 78 48 8b 74 24 08 8b 4c 24 14 e9 b4 fe ff ff 0f 0b 31 c0 e9 55 d1 af 00 <0f> 0b eb f5 48 8b 7f 08 83 7f 60 05 0f 85 00 ff ff ff 49 8b 3b 4c
> Jun 14 18:08:32 dalek kernel: RSP: 0018:ffffd1fb8176fc10 EFLAGS: 00010246
> Jun 14 18:08:32 dalek kernel: RAX: 0000000000000000 RBX: ffffd1fb8176fd18 RCX: 0000000000000000
> Jun 14 18:08:32 dalek kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8d1a8eb28b00
> Jun 14 18:08:32 dalek kernel: RBP: 0000000000000000 R08: ffffd1fb8176fc38 R09: ffffd1fb8176fc40
> Jun 14 18:08:32 dalek kernel: R10: ffffd1fb8176fc34 R11: 0000000000000000 R12: 0000000000000000
> Jun 14 18:08:32 dalek kernel: R13: ffffd1fb8176fd90 R14: 0000000000000001 R15: ffff8d1a8eb28b00
> Jun 14 18:08:32 dalek kernel: FS:  0000000000000000(0000) GS:ffff8d29d161f000(0000) knlGS:0000000000000000
> Jun 14 18:08:32 dalek kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Jun 14 18:08:32 dalek kernel: CR2: 00007f0ddcd7b9d0 CR3: 000000023dcbf000 CR4: 0000000000350ef0
> Jun 14 18:08:32 dalek kernel: Call Trace:
> Jun 14 18:08:32 dalek kernel:  <TASK>
> Jun 14 18:08:32 dalek kernel:  do_region+0x227/0x2a0

I think the problem is that do_region is tracking the "remaining" in
sector granularity, but devices can have dma alignment such that it's
valid to have sub-sector vectors. Rounding the length appended
to_sectors() creates a 0 length subtraction, so the loop thinks no
progress is made and loops forever. If we track it in bytes instead of
sectors, then that should fix this observation.
