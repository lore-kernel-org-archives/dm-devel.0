Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50DF1DE4FB
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 23:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765494821; cv=none; b=qsv0wQ5DBugKBIwbqQ/iaqIak+2b3rCBHPgKveefxJUnCHasllMr6cngvO8snQrfmqGE3RCv8pJBK5BPbcTdEVo3mY6IgegNqQFIHxMLSCCVzDKliTna/sJPE7IOtp3d1kI3dCmz0dMzfoxObtTcfyh0ED74Men58zVXMnQuUo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765494821; c=relaxed/simple;
	bh=jUHR6HuMlyl1p2H1CSYSxNmZBTjzgzPX56Cg63T84Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=F3QNieGhFZmV+gIATuJspAoUKV7bT29klRx7hyZfNOWXzQnACMsHbao4I7K2B/9CKjxhoEaKb0d3vfedVoQ+gx0ZM7qMGFWh6HhLDv68yIokSOmI+aJnfxkcSUJDpCHwOpPgVDOiky4o2D8451XhXzp2ntL4wapTZKI93DLw9Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d9Rke8Nq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d9Rke8Nq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765494817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DcnFHer2TO9r2eCmD4WSfJHxqBsfPjKi2yOGqwH0OcU=;
	b=d9Rke8Nq5/LZj5a0920F3hAXwkX2BNhSl9SLOOYBT9EYgy7C0YUHuBpPoNSHeIjdLnGnW6
	nkCC0lXTs/UZXWHuhnhcmOgAvrSsGqwGWyMMiYxFg8Z3ltUQBqvYA+9Ha75oP5YvzbJq3Y
	UphkXuH39HWyaO8BOyUc/OPdImXOHQs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-JCeYE4pOOU2vZoSxK7p_QA-1; Thu,
 11 Dec 2025 18:13:34 -0500
X-MC-Unique: JCeYE4pOOU2vZoSxK7p_QA-1
X-Mimecast-MFC-AGG-ID: JCeYE4pOOU2vZoSxK7p_QA_1765494813
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 705D21800451;
	Thu, 11 Dec 2025 23:13:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAC42180044F;
	Thu, 11 Dec 2025 23:13:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BBNDVQc1837611
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Dec 2025 18:13:31 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BBNDVVp1837610;
	Thu, 11 Dec 2025 18:13:31 -0500
Date: Thu, 11 Dec 2025 18:13:31 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yongpeng Yang <yangyongpeng.storage@outlook.com>
Cc: Yongpeng Yang <yangyongpeng.storage@gmail.com>,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: Re: [PATCH 1/1] dm-stripe: adjust max_hw_discard_sectors to avoid
 unnecessary discard bio splitting
Message-ID: <aTtQGwmfStMjR7xs@redhat.com>
References: <20251208100713.697542-2-yangyongpeng.storage@gmail.com>
 <aTkOIzJVOcEJB7SU@redhat.com>
 <SI4PR02MB869655E1A6EAD8A9462F432899A1A@SI4PR02MB8696.apcprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <SI4PR02MB869655E1A6EAD8A9462F432899A1A@SI4PR02MB8696.apcprd02.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pxcl8gFQFblQO3SSqcxFUYEdfhkjOrpqtrOusmzrG3M_1765494813
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Resending, since somehow, I didn't reply-to-all last time.

On Thu, Dec 11, 2025 at 03:03:12PM +0800, Yongpeng Yang wrote:
> On 12/10/25 14:07, Benjamin Marzinski wrote:
> > On Mon, Dec 08, 2025 at 06:07:14PM +0800, Yongpeng Yang wrote:
> >> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
> >>
> >> Currently, the max_hw_discard_sectors of a stripe target is set to the
> >> minimum max_hw_discard_sectors among all sub devices. When the discard
> >> bio is larger than max_hw_discard_sectors, this may cause the stripe
> >> device to split discard bios unnecessarily, because the value of
> >> max_hw_discard_sectors affects max_discard_sectors, which equal to
> >> min(max_hw_discard_sectors, max_user_discard_sectors).
> >>
> >> For example:
> >> root@vm:~# echo '0 33554432 striped 2 256 /dev/vdd 0 /dev/vde 0' | dmsetup create stripe_dev
> >> root@vm:~# cat /sys/block/dm-1/queue/discard_max_bytes
> >> 536870912
> >> root@vm:~# cat /sys/block/dm-1/slaves/vdd/queue/discard_max_bytes
> >> 536870912
> >> root@vm:~# blkdiscard -o 0 -l 1073741824 -p 1073741824 /dev/mapper/stripe_dev
> >>
> >> dm-1 is the stripe device, and its discard_max_bytes is equal to
> >> each sub device’s discard_max_bytes. Since the requested discard
> >> length exceeds discard_max_bytes, the block layer splits the discard bio:
> >>
> >> block_bio_queue: 252,1 DS 0 + 2097152 [blkdiscard]
> >> block_split: 252,1 DS 0 / 1048576 [blkdiscard]
> >> block_rq_issue: 253,48 DS 268435456 () 0 + 524288 be,0,4 [blkdiscard]
> >> block_bio_queue: 253,64 DS 524288 + 524288 [blkdiscard]
> >>
> >> However, both vdd and vde can actually handle a discard bio of 536870912
> >> bytes, so this split is not necessary.
> >>
> >> This patch updates the stripe target’s q->limits.max_hw_discard_sectors
> >> to be the minimum max_hw_discard_sectors of the sub devices multiplied
> >> by the # of stripe devices. This enables the stripe device to handle
> >> larger discard bios without incurring unnecessary splitting.
> >>
> >> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
> >> ---
> >>  drivers/md/dm-stripe.c | 16 +++++++++++++++-
> >>  1 file changed, 15 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> >> index 1461dc740dae..799d6def699b 100644
> >> --- a/drivers/md/dm-stripe.c
> >> +++ b/drivers/md/dm-stripe.c
> >> @@ -38,6 +38,9 @@ struct stripe_c {
> >>  	uint32_t chunk_size;
> >>  	int chunk_size_shift;
> >>  
> >> +	/* The minimum max_hw_discard_sectors of all sub devices. */
> >> +	unsigned int max_hw_discard_sectors;
> >> +
> >>  	/* Needed for handling events */
> >>  	struct dm_target *ti;
> >>  
> >> @@ -169,6 +172,8 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >>  	 * Get the stripe destinations.
> >>  	 */
> >>  	for (i = 0; i < stripes; i++) {
> >> +		struct request_queue *q;
> >> +
> >>  		argv += 2;
> >>  
> >>  		r = get_stripe(ti, sc, i, argv);
> >> @@ -180,6 +185,13 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >>  			return r;
> >>  		}
> >>  		atomic_set(&(sc->stripe[i].error_count), 0);
> >> +
> >> +		q = bdev_get_queue(sc->stripe[i].dev->bdev);
> >> +		if (i == 0)
> >> +			sc->max_hw_discard_sectors = q->limits.max_hw_discard_sectors;
> >> +		else
> >> +			sc->max_hw_discard_sectors = min_not_zero(sc->max_hw_discard_sectors,
> >> +					q->limits.max_hw_discard_sectors);
> > 
> > I don't think any of the above is necessary. When stripe_io_hints() is
> > called, dm_set_device_limits() will already have been called on all the
> > underlying stripe devices to combine the limits. So
> > limits->max_hw_discard_sectors should already be set to the same value
> > as you're computing for sc->max_hw_discard_sectors. Right?
> 
> dm_set_device_limits() initializes the stack-local ti_limits defined in
> dm_calculate_queue_limits(), and stripe_io_hints() modifies this same
> variable as well.

Yep. That's why it's o.k. to use limits->max_hw_discard_sectors in
stripe_io_hints(). dm_set_device_limits() -> blk_stack_limits()
is called on all of the underlying stripe devices before
stripe_io_hints() is called. blk_stack_limits() includes the line

t->max_hw_discard_sectors = min_not_zero(t->max_hw_discard_sectors,
                                         b->max_hw_discard_sectors);

Which updates ti_limits.max_hw_discard_sectors. ti_limits is then passed
into stripe_io_hints(), and has the same value that you compute in
stripe_ctr().

> These updates do not affect the stripe device’s
> q->limits until dm_calculate_queue_limits() later calls
> blk_stack_limits().

Actually, we don't update q->limits for the stripe device itself until
later, via __bind() -> dm_table_set_restrictions() ->
queue_limits_commit_update(). But we're not checking the queue limits of
the stripe device. We are checking the queue limits of the underlying
devices. Those devices are completely set up before we create the dm
device on top of them.

> Therefore, the q->limits.max_hw_discard_sectors of
> each sub device in a stripe target is never modified and it is necessary
> to record the minimum q->limits.max_hw_discard_sectors
> across all sub devices.

You are checking the same underlying q->limits.max_hw_discard of
each sub device in stripe_ctr(). stripe_ctr() is called when we set up
the table, well before we call dm_calculate_queue_limits() as part
of making the table active in dm_swap_table(). So if the
q->limits.max_hw_discard of the underlying devices is correct in
stripe_ctr(), it surely must be correct when dm_set_device_limits()
is called on them.

If you don't believe be try adding
DMERR("%u vs %u", sc->max_hw_discard_sectors, limits->max_hw_discard_sectors);

to stripe_io_hints(). It should show that they have the same number. If
it doesn't, I apologize for all this noise.
 
> > 
> >>  	}
> >>  
> >>  	ti->private = sc;
> >> @@ -456,7 +468,7 @@ static void stripe_io_hints(struct dm_target *ti,
> >>  			    struct queue_limits *limits)
> >>  {
> >>  	struct stripe_c *sc = ti->private;
> >> -	unsigned int io_min, io_opt;
> >> +	unsigned int io_min, io_opt, max_hw_discard_sectors;
> >>  
> >>  	limits->chunk_sectors = sc->chunk_size;
> >>  
> >> @@ -465,6 +477,8 @@ static void stripe_io_hints(struct dm_target *ti,
> >>  		limits->io_min = io_min;
> >>  		limits->io_opt = io_opt;
> >>  	}
> >> +	if (!check_mul_overflow(sc->max_hw_discard_sectors, sc->stripes, &max_hw_discard_sectors))
> > 
> > sc->max_hw_discard_sectors should be the same as
> > limits->max_hw_discard_sectors here 
> > 
> >> +		limits->max_hw_discard_sectors = max_hw_discard_sectors;
> > 
> > I see a couple of issues with this calculation. First, this only works
> > if max_hw_discard_sectors is greater than sc->chunk_size. But more than
> > that, before you multiply the original limit by the number of stripes,
> > you must round it down to a multiple of chunk_size. Otherwise, you can
> > end up writing too much to some of the underlying devices. To show this
> > with simple numbers, imagine you had 3 stripes that with a chunk_size of
> > 4 and all the underlying devices had a max_hw_discard_sectors of 5. You
> > would set max_hw_discard_sectors to 5 * 3 = 15. But if you discared 15
> > sectors from the beginning of the device, you would end up discarding
> > the first 4 sectors of each underlying device, and then loop around
> > discard 3 more sectors of the first device. This means that you would
> > discard 7 from the first device, instead of the 5 that it could handle.
> > Rounding max_hw_discard_sectors down to a multiple of chunk_size will
> > fix that.
> 
> The splitting of discard bios is based on limits->max_discard_sectors,
> which is independent of the stripe size. As a result, the discard bio
> size passed to stripe_map->stripe_map_range() may exceed
> `sc->chunk_size * sc->stripes`.

Of course this is true, but my example still holds if you had a
max_hw_discard_sectors of 9 instead. 9 * 3 = 27, so you would discard
the first 8 sectors (two chunks) of each stripe device, and then 3 more
sectors of the first stripe device. This means that you would send a
discard of 11 sectors to the first device, instead of the 9 that it can
handle at once.

> In the example above, stripe_map_range()
> is invoked three times, and each invocation reduces bio->bi_iter.bi_size
> to 5 sectors for each sub devices.

If it did that, that would be a bug.  You were intending to discard
the first 15 sectors of the dm device, but instead, you would be
discarding the first 13 sectors (0-12), plus sector 16 and sector 20.

It's easy to test my original thought experiment using a scsi debug
device with a discard granularity of 1 and a max_hw_discard_sectors of
5, and a stripe device with a 4 sector stripe size. Here's the test:

# modprobe scsi_debug dev_size_mb=128 max_luns=3 lbpu=1 unmap_max_blocks=5
# echo '0 786432 striped 3 4 /dev/sda 0 /dev/sdb 0 /dev/sdc 0' | create stripe_dev
# blkdiscard -o 0 -l 7680 /dev/mapper/stripe_dev

And here's the perf results:

block:block_bio_queue: 253,1 DS 0 + 15 [blkdiscard]
block:block_bio_remap: 8,0 DS 0 + 7 <- (253,1) 0
block:block_bio_queue: 8,0 DS 0 + 7 [blkdiscard]
block:block_bio_remap: 8,16 DS 0 + 4 <- (253,1) 0
block:block_bio_queue: 8,16 DS 0 + 4 [blkdiscard]
block:block_bio_remap: 8,32 DS 0 + 4 <- (253,1) 0
block:block_bio_queue: 8,32 DS 0 + 4 [blkdiscard]
    block:block_split: 8,0 DS 0 / 5 [blkdiscard] 
 block:block_rq_issue: 8,0 DS 2560 () 0 + 5 0x2,0,4 [kworker/5:1H]
 block:block_rq_issue: 8,0 DS 1024 () 5 + 2 0x2,0,4 [kworker/5:1H]
 block:block_rq_issue: 8,16 DS 2048 () 0 + 4 0x2,0,4 [kworker/5:1H] 
 block:block_rq_issue: 8,32 DS 2048 () 0 + 4 0x2,0,4 [kworker/5:1H] 

As you can see, it sends 7 sectors down to sda (8:0), which is too
large, so it needs to get split by the scsi device.

-Ben

> > 
> > Lastly, if you do overflow when multiplying max_hw_discard_sectors by
> > the number of stripes, you should probably just set
> > limits->max_hw_discard_sectors to UINT_MAX >> SECTOR_SHIFT, instead of
> > leaving it at what it was.
> 
> Yes, I overlooked that. I’ll fix it in v2.
> 
> Thanks
> Yongpeng,
> 
> > 
> > -Ben
> > 
> >>  }
> >>  
> >>  static struct target_type stripe_target = {
> >> -- 
> >> 2.43.0
> > 

