Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6293779CF
	for <dm-devel@lists.linux.dev>; Mon,  5 Feb 2024 02:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707099571; cv=none; b=QoEd+5mTXfSf8kpEFzRP8asd6k9QGp9QZJ58UKsjJEaD0gXVI8sf5GTiKq1webJMwpbywX+a1wCXI+c9QMfxbBaE78DYEEkIGYOQ43M+LV751hOOrZ6abrTxBdP5lVOTrZAsMSuclhwXPjKjPTPF8GiVHAJ+QG8j7CicuCYieaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707099571; c=relaxed/simple;
	bh=YNLVJadeBU3MigIiF7lgLr98ea7UZJdpIXR5AJeobm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLyTpBMIfwAQdfhbcPdJYkIliAPM51S20pchNUxbancwnptHJxVVlZaVelVFVnFgm0Af1vIcxuJHdHWBxaJ6RMtOASHWhwuKSJkgjatNcfIvQoryBGwdGcbUO2rAlbVCQdKkXQgaZTVmkhiZwZza5GkX0qj89TSFjBYfwFOz6L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b2vfx665; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b2vfx665"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707099568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LPefuR83KBi7OStCyON/nYajtROuhhD6CFUz0EyFryI=;
	b=b2vfx665x8Rnf51T2t4v+n2SmWOhSzgamcxtyIlQ6ogQq52HSXhfwO3mRWjrzMk8mkI6RY
	3+CQLNkrm02CkFB5L2vItmc1GH9EHkeEarVcS0cHLeQwwMe9b+72GihD6n23uRC7X67NDg
	WKjLStiJFaNLDP03/M0Up9iz1otJ+B4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-ex0s0-fqNAKTrOIZ2E4YBg-1; Sun, 04 Feb 2024 21:19:23 -0500
X-MC-Unique: ex0s0-fqNAKTrOIZ2E4YBg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B06D800074;
	Mon,  5 Feb 2024 02:19:22 +0000 (UTC)
Received: from fedora (unknown [10.72.116.96])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A51A2166B32;
	Mon,  5 Feb 2024 02:19:18 +0000 (UTC)
Date: Mon, 5 Feb 2024 10:19:14 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Message-ID: <ZcBFoqweG+okoTN6@fedora>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-7-dlemoal@kernel.org>
 <Zb8K4uSN3SNeqrPI@fedora>
 <a3f17ffb-872b-49cf-a1a7-553ca4a272c0@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3f17ffb-872b-49cf-a1a7-553ca4a272c0@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Mon, Feb 05, 2024 at 08:57:00AM +0900, Damien Le Moal wrote:
> On 2/4/24 12:56, Ming Lei wrote:
> > On Fri, Feb 02, 2024 at 04:30:44PM +0900, Damien Le Moal wrote:
> >> +/*
> >> + * Zone write plug flags bits:
> >> + *  - BLK_ZONE_WPLUG_CONV: Indicate that the zone is a conventional one. Writes
> >> + *    to these zones are never plugged.
> >> + *  - BLK_ZONE_WPLUG_PLUGGED: Indicate that the zone write plug is plugged,
> >> + *    that is, that write BIOs are being throttled due to a write BIO already
> >> + *    being executed or the zone write plug bio list is not empty.
> >> + */
> >> +#define BLK_ZONE_WPLUG_CONV	(1U << 0)
> >> +#define BLK_ZONE_WPLUG_PLUGGED	(1U << 1)
> > 
> > BLK_ZONE_WPLUG_PLUGGED == !bio_list_empty(&zwplug->bio_list), so looks
> > this flag isn't necessary.
> 
> No, it is. As the description says, the flag not only indicates that there are
> plugged BIOs, but it also indicates that there is a write for the zone
> in-flight. And that can happen even with the BIO list being empty. E.g. for a
> qd=1 workload of small BIOs, no BIO will ever be added to the BIO list, but the
> zone still must be marked as "plugged" when a write BIO is issued for it.

OK.

> 
> >> +static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
> >> +					  struct bio *bio, unsigned int nr_segs)
> >> +{
> >> +	/*
> >> +	 * Keep a reference on the BIO request queue usage. This reference will
> >> +	 * be dropped either if the BIO is failed or after it is issued and
> >> +	 * completes.
> >> +	 */
> >> +	percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
> > 
> > It is fragile to get nested usage_counter, and same with grabbing/releasing it
> > from different contexts or even functions, and it could be much better to just
> > let block layer maintain it.
> > 
> > From patch 23's change:
> > 
> > +	 * Zoned block device information. Reads of this information must be
> > +	 * protected with blk_queue_enter() / blk_queue_exit(). Modifying this
> > 
> > Anytime if there is in-flight bio, the block device is opened, so both gendisk and
> > request_queue are live, so not sure if this .q_usage_counter protection
> > is needed.
> 
> Hannes also commented about this. Let me revisit this.

I think only queue re-configuration(blk_revalidate_zone) requires the
queue usage counter. Otherwise, bdev open()/close() should work just
fine.

> 
> >> +	/*
> >> +	 * blk-mq devices will reuse the reference on the request queue usage
> >> +	 * we took when the BIO was plugged, but the submission path for
> >> +	 * BIO-based devices will not do that. So drop this reference here.
> >> +	 */
> >> +	if (bio->bi_bdev->bd_has_submit_bio)
> >> +		blk_queue_exit(bio->bi_bdev->bd_disk->queue);
> > 
> > But I don't see where this reference is reused for blk-mq in this patch,
> > care to point it out?
> 
> This patch modifies blk_mq_submit_bio() to add a "goto new_request" at the top
> for any BIO flagged with BIO_FLAG_ZONE_WRITE_PLUGGING. So when a plugged BIO is
> unplugged and submitted again, the reference that was taken in
> blk_zone_wplug_add_bio() is reused for the new request for that BIO.

OK, this reference reuse may be worse, because queue freeze can't prevent new
write zoned bio from being submitted any more given only percpu_ref_get() is
called for all write zoned bios.


Thanks,
Ming

