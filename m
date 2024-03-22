Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0EB138C
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 02:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711073328; cv=none; b=jw/5kU2cKgM2BnzE4DhcI6l1O43Ljrla0xoZ2F58Mhl7KE7CvHTBUEkYKlVs5de75V6bBk/BKqYtHjhCk8VycCx295HCxNStRb56gKsXui6RY8ASGO1fs3RfH4T7rTAv58354jc5GD40IxHMblurgCMNVmQ4Ph6Vn8F2PvGPUn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711073328; c=relaxed/simple;
	bh=9VEyF60vTjy13scdszn2tWTx4fxb49rOcCG/dWP96fk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nrmm0BxDxA2AQaLpxkjHLlGGmeHYcIOrm2ahBhhx3nlzkvfamVu4oDi51CHHKAy+DqR9iFwYBq9J9eHRY56n2L0LTrMnoE4Ng7shpd+Afxl0oycTNcaftsFm8jvE9mTz0dQRYlB0e7pRDNz8AStStJM3+KehM1NkA9NgqUSqrlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LKLgPz5t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LKLgPz5t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711073325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=evboKVLArOdvCbtOOewhsRFMGN1n9H8N78dURQUObnQ=;
	b=LKLgPz5tArAGSK7P3Cd8NntNtKvubxpnE4zjVNJrSo/TnMk6EcuS1oW/hs0wcv4IMqSxWJ
	rLQEuHVc3Arz2KbCdsefOKr0+4VMgL/uKsVTEQ1edCzri0gx4JytdhFPdmcrUY4SpAis27
	I1XKYtNnd+JiOZDHDenMfl8stG65bD8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-CK6CeazcPRqWrSLZOv6Ekg-1; Thu, 21 Mar 2024 22:08:39 -0400
X-MC-Unique: CK6CeazcPRqWrSLZOv6Ekg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5272285A58B;
	Fri, 22 Mar 2024 02:08:39 +0000 (UTC)
Received: from fedora (unknown [10.72.116.75])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29FDD3C20;
	Fri, 22 Mar 2024 02:08:34 +0000 (UTC)
Date: Fri, 22 Mar 2024 10:08:11 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	ming.lei@redhat.com
Subject: Re: block: fail unaligned bio from submit_bio_noacct()
Message-ID: <ZfzoC/V07nExJ+0x@fedora>
References: <20240321131634.1009972-1-ming.lei@redhat.com>
 <ZfxVqkniO-6jFFH5@redhat.com>
 <ea8a13c-ee40-47f9-a7be-17b84bd1f686@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea8a13c-ee40-47f9-a7be-17b84bd1f686@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Thu, Mar 21, 2024 at 06:01:41PM +0100, Mikulas Patocka wrote:
> 
> 
> On Thu, 21 Mar 2024, Mike Snitzer wrote:
> 
> > On Thu, Mar 21 2024 at  9:16P -0400,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > For any bio with data, its start sector and size have to be aligned with
> > > the queue's logical block size.
> > > 
> > > This rule is obvious, but there is still user which may send unaligned
> > > bio to block layer, and it is observed that dm-integrity can do that,
> > > and cause double free of driver's dma meta buffer.
> > > 
> > > So failfast unaligned bio from submit_bio_noacct() for avoiding more
> > > troubles.
> > > 
> > > Cc: Mikulas Patocka <mpatocka@redhat.com>
> > > Cc: Mike Snitzer <snitzer@kernel.org>
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  block/blk-core.c | 17 +++++++++++++++++
> > >  1 file changed, 17 insertions(+)
> > > 
> > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > index a16b5abdbbf5..b1a10187ef74 100644
> > > --- a/block/blk-core.c
> > > +++ b/block/blk-core.c
> > > @@ -729,6 +729,20 @@ void submit_bio_noacct_nocheck(struct bio *bio)
> > >  		__submit_bio_noacct(bio);
> > >  }
> > >  
> > > +static bool bio_check_alignment(struct bio *bio, struct request_queue *q)
> > > +{
> > > +	unsigned int bs = q->limits.logical_block_size;
> > > +	unsigned int size = bio->bi_iter.bi_size;
> > > +
> > > +	if (size & (bs - 1))
> > > +		return false;
> > > +
> > > +	if (size && ((bio->bi_iter.bi_sector << SECTOR_SHIFT) & (bs - 1)))
> > > +		return false;
> > > +
> > > +	return true;
> > > +}
> 
> I would change it to
> 
> if (unlikely(((bi_iter.bi_sector | bio_sectors(bio)) & ((queue_logical_block_size(q) >> 9) - 1)) != 0))
> 	return false;

What if bio->bi_iter.bi_size isn't aligned with 512? The above check
can't find that at all.

> 
> > >  /**
> > >   * submit_bio_noacct - re-submit a bio to the block device layer for I/O
> > >   * @bio:  The bio describing the location in memory and on the device.
> > > @@ -780,6 +794,9 @@ void submit_bio_noacct(struct bio *bio)
> > >  		}
> > >  	}
> > >  
> > > +	if (WARN_ON_ONCE(!bio_check_alignment(bio, q)))
> > > +		goto end_io;
> > > +
> > >  	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> > >  		bio_clear_polled(bio);
> > >  
> > > -- 
> > > 2.41.0
> > > 
> > > 
> > 
> > This check would really help more quickly find buggy code, but it
> > would be unfortunate for these extra checks to be required in
> > production.  It feels like this is the type of check that should be
> > wrapped by a debug CONFIG option (so only debug kernels have it).
> > 
> > Do we already have an appropriate CONFIG option to use?
> > 
> > Mike
> 
> But then, the system would crash with the config option being 'n' and 
> return an error with the config option being 'y' - which would be 
> unfortunate.

Yes, the check is basically zero-cost, not necessary to add config to
make things more complicated.

Thanks,
Ming

