Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131231A9F87;
	Mon, 15 Jun 2026 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781541463; cv=none; b=R2T+cYAPYfuxtaAqZV/NtDVtbrCGIZYZ/OqafHiDdMrP/+HMJazBRS/nm91o3zoVPzc94eekcGppsXRYz1Nma1kuzQWGiH3S2wc9p41nEa6WkFvHJf5mMuPAYw2NJbKF1N+/lsuqBl8OaY375NS9mqkgt4OthiSo0AkQU1hLDYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781541463; c=relaxed/simple;
	bh=Cohom2Ou5SLC0ZDO02KAD1e0G/tpoEFYh1cIDL2cUF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HwtT01dh+9cL+MUFtnU78u1V9btshrkSZB+fPDtmDsN48D+GqTQSH/lfeN7DQ3zQ6x3+gtAbVWP8aEdNMY3byb0UUDmMwU+UiLQcvxbtm+WCDPUuuAZkSzVBGFsZKHc0BLzZH2GnBI3gtQfVWN+Y2PZ2IZrJ7KSD0cFtfFaN+o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=WCzCU1hV; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="WCzCU1hV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=x9qmKP09x6ZcRWzZLuwWvY1wTy1pWSGt1TNtv/lGbQI=; b=WCzCU1hVCZXGcf7L
	5GeobtBV9Xqa3O0Cub152YMz2zTBnOTInZLPprTCrEGQzaGebD5d6y7ED1wyqZxsI1Ma9C8ZuEE9U
	eEBcuF1JO/2MjX5XN1DMSqQ/pKRM+qEh/+xHmMITddgDHds00UDovVP5xvjeTeBvh4O3CXH/M35j1
	qiyihf4IvXNOWoFzKeIKnk7qvB1Dz3V4mYXf06tJt/fpCf2T0FjvB3pvuG29xT19BIiiZISdS28+8
	zeIR7i0CFmq9usZp2dqw8jWrDcnABTifEkeoQEPNOJqV/0IaZFAlio8Za2I3ulW+fWrVB0ZLqzIXq
	KdSpx2nVbkrnP2p3lQ==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1wZAJf-00000007nJa-44eX;
	Mon, 15 Jun 2026 16:37:39 +0000
Date: Mon, 15 Jun 2026 16:37:39 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
Message-ID: <ajAqUwo3eTm1c2_J@gallifrey>
References: <ai7rnH20IYeSmY8s@gallifrey>
 <ajAYN_mmjzYBAimV@kbusch-mbp>
 <ajAb0m9cNraQn2Pw@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <ajAb0m9cNraQn2Pw@kbusch-mbp>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.88+deb13-amd64 (x86_64)
X-Uptime: 16:34:56 up 30 days, 19:47,  2 users,  load average: 0.02, 0.04,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Keith Busch (kbusch@kernel.org) wrote:
> On Mon, Jun 15, 2026 at 09:20:23AM -0600, Keith Busch wrote:
> > On Sun, Jun 14, 2026 at 05:57:48PM +0000, Dr. David Alan Gilbert wrote:
> > > Jun 14 18:08:32 dalek kernel: device-mapper: raid1: Mirror read failed from 252:24. Trying alternative device.
> > > Jun 14 18:08:32 dalek kernel: ------------[ cut here ]------------
> > > Jun 14 18:08:32 dalek dmeventd[1010]: Primary mirror device 252:24 read failed.
> > > Jun 14 18:08:32 dalek kernel: WARNING: block/bio.c:1044 at bio_add_page+0x18b/0x250, CPU#15: kworker/15:1/369
> > > Jun 14 18:08:32 dalek dmeventd[1010]: main-lvol0 is now in-sync.
> > > Jun 14 18:08:32 dalek kernel: Modules linked in: nft_masq nft_reject_ipv4 act_csum cls_u32 sch_htb nf_nat_tftp nf_conntrack_tftp bridge stp llc rfkill nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reje>
> > > Jun 14 18:08:32 dalek kernel:  drm_panel_backlight_quirks gpu_sched drm_suballoc_helper video nvme drm_display_helper nvme_core cec nvme_keyring sp5100_tco nvme_auth wmi serio_raw fuse scsi_dh_alua i2c_dev scsi_dh_rdac scsi_dh_emc
> > > Jun 14 18:08:32 dalek kernel: CPU: 15 UID: 0 PID: 369 Comm: kworker/15:1 Not tainted 7.1.0-rc7+ #786 PREEMPT(lazy) 
> > > Jun 14 18:08:32 dalek kernel: Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X570 Pro4, BIOS P3.10 07/13/2020
> > > Jun 14 18:08:32 dalek kernel: Workqueue: kmirrord do_mirror
> > > Jun 14 18:08:32 dalek kernel: RIP: 0010:bio_add_page+0x18b/0x250
> > > Jun 14 18:08:32 dalek kernel: Code: 24 10 4c 8b 04 24 84 c0 0f 85 c9 00 00 00 41 0f b7 40 78 48 8b 74 24 08 8b 4c 24 14 e9 b4 fe ff ff 0f 0b 31 c0 e9 55 d1 af 00 <0f> 0b eb f5 48 8b 7f 08 83 7f 60 05 0f 85 00 ff ff ff 49 8b 3b 4c
> > > Jun 14 18:08:32 dalek kernel: RSP: 0018:ffffd1fb8176fc10 EFLAGS: 00010246
> > > Jun 14 18:08:32 dalek kernel: RAX: 0000000000000000 RBX: ffffd1fb8176fd18 RCX: 0000000000000000
> > > Jun 14 18:08:32 dalek kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8d1a8eb28b00
> > > Jun 14 18:08:32 dalek kernel: RBP: 0000000000000000 R08: ffffd1fb8176fc38 R09: ffffd1fb8176fc40
> > > Jun 14 18:08:32 dalek kernel: R10: ffffd1fb8176fc34 R11: 0000000000000000 R12: 0000000000000000
> > > Jun 14 18:08:32 dalek kernel: R13: ffffd1fb8176fd90 R14: 0000000000000001 R15: ffff8d1a8eb28b00
> > > Jun 14 18:08:32 dalek kernel: FS:  0000000000000000(0000) GS:ffff8d29d161f000(0000) knlGS:0000000000000000
> > > Jun 14 18:08:32 dalek kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > Jun 14 18:08:32 dalek kernel: CR2: 00007f0ddcd7b9d0 CR3: 000000023dcbf000 CR4: 0000000000350ef0
> > > Jun 14 18:08:32 dalek kernel: Call Trace:
> > > Jun 14 18:08:32 dalek kernel:  <TASK>
> > > Jun 14 18:08:32 dalek kernel:  do_region+0x227/0x2a0
> > 
> > I think the problem is that do_region is tracking the "remaining" in
> > sector granularity, but devices can have dma alignment such that it's
> > valid to have sub-sector vectors. Rounding the length appended
> > to_sectors() creates a 0 length subtraction, so the loop thinks no
> > progress is made and loops forever. If we track it in bytes instead of
> > sectors, then that should fix this observation.
> 
> I recreated your observation and this patch below appears to fix the
> stuck behavior.

Hi Keith,
  Thanks for the patch, alas it doesn't seem to be helping here;
 the first warn is still the same
and it still hangs the test process hard and eventually BUGs at

void blk_mq_end_request(struct request *rq, blk_status_t error)
{
        if (blk_update_request(rq, error, blk_rq_bytes(rq)))
                BUG();

Dave

> ---
> diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
> index 1db565b376200..d72b9331c2fd1 100644
> --- a/drivers/md/dm-io.c
> +++ b/drivers/md/dm-io.c
> @@ -362,19 +362,26 @@ static void do_region(const blk_opf_t opf, unsigned int region,
>                         bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
>                         remaining -= num_sectors;
>                 } else {
> -                       while (remaining) {
> +                       unsigned long byte_remaining = to_bytes(remaining);
> +
> +                       while (byte_remaining) {
>                                 /*
>                                  * Try and add as many pages as possible.
>                                  */
>                                 dp->get_page(dp, &page, &len, &offset);
> -                               len = min(len, to_bytes(remaining));
> +                               len = min(len, byte_remaining);
>                                 if (!bio_add_page(bio, page, len, offset))
>                                         break;
> 
>                                 offset = 0;
> -                               remaining -= to_sector(len);
> +                               byte_remaining -= len;
>                                 dp->next_page(dp);
>                         }
> +                       remaining = to_sector(byte_remaining);
>                 }
> 
>                 atomic_inc(&io->count);
> --
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
