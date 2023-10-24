Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86576208AB
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 19:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QTflm0Pq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698175119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lS84szxsRg1zhn9iPxyR4LlVpZT/QcmLjPslOtmdaWM=;
	b=QTflm0Pqz4V8JcjSzLhqsIxlN5DCY1x2DQFqqMns1FFecUg4G/Foqhx7ZrM+ec/vcY/xgD
	FNimtu4zKacy4DAZJLaSD4OLaFPkCgTeHLP+7iHpRHIJ+2Kxbi9tFTstdIc3/Be5AAGCni
	0KrU/NrTnHSdIyRqBERiHaHgADl3fxo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-ZvxjRgYBMSiFb4JPVfVKnw-1; Tue,
 24 Oct 2023 15:18:35 -0400
X-MC-Unique: ZvxjRgYBMSiFb4JPVfVKnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B8981C0513A;
	Tue, 24 Oct 2023 19:18:35 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69E3940C6F79;
	Tue, 24 Oct 2023 19:18:35 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 3A06530C0521; Tue, 24 Oct 2023 19:18:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 355403FB77;
	Tue, 24 Oct 2023 21:18:35 +0200 (CEST)
Date: Tue, 24 Oct 2023 21:18:35 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: Ming Lei <ming.lei@redhat.com>, dm-devel@lists.linux.dev, 
    linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: dm: Respect REQ_NOWAIT bios
In-Reply-To: <ZTgFtseG3m3WPWn/@redhat.com>
Message-ID: <e796de8-bac1-8f7a-c6eb-74d39aad8a2b@redhat.com>
References: <15ca26cc-174a-d4e8-9780-d09f8e5a6ea5@redhat.com> <ZTgFtseG3m3WPWn/@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2



On Tue, 24 Oct 2023, Mike Snitzer wrote:

> For the benefit of others, since this patch was posted to the old
> dm-devel list, here is the original patch proposal:
> https://patchwork.kernel.org/project/dm-devel/patch/15ca26cc-174a-d4e8-9780-d09f8e5a6ea5@redhat.com/
> 
> On Tue, Oct 03 2023 at 11:30P -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > Here I'm sending that patch for REQ_NOWAIT for review.
> > 
> > It is not tested, except for some trivial tests that involve logical 
> > volume activation.
> 
> At a minimum we need to test with the simple test code Jens provided
> in commit a9ce385344f9 ("dm: don't attempt to queue IO under RCU protection")

The question is - how do we simulate the memory allocation failures? Do we 
need to add some test harness that will randomly return NULL to these 
allocations? Or will we use the kernel fault-injection framework?

> > I found out that it seems easier to propagate the error using bits in 
> > clone_info rather than changing return codes for each affected function.
> 
> Yes, the various DM core code that allocates multiple bios, etc
> certianly benefits from not having to worry about tracking
> fine-grained return codes.  So I've kept the flag in clone_info.
> 
> > 
> > Mikulas
> > 
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Please don't add Signed-off-by to anything you don't want to see going
> upstream (yet), especially something you haven't tested.

OK

> Even going so far as adding 'Not-Signed-off-by' is appropriate.
> 
> More comments inline below, and then at the end I'm attaching an
> incremental patch that should get us closer to something that works
> (but I haven't tested yet either).  I've also messaged Ming Lei to
> check with him on the FIXME I added before the call to dm_io_rewind()
> -- hopefully Ming will reply to this email.
> 
> > +	if (unlikely(ci->is_nowait)) {
> > +		clone = bio_alloc_clone(NULL, bio, GFP_NOWAIT, &md->mempools->io_bs);
> > +		if (!clone) {
> > +			ci->nowait_failed = true;
> > +			return NULL;
> > +		}
> > +	} else {
> > +		clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->mempools->io_bs);
> > +	}
> >  	tio = clone_to_tio(clone);
> >  	tio->flags = 0;
> >  	dm_tio_set_flag(tio, DM_TIO_INSIDE_DM_IO);
> 
> The above is bogus because if the clone cannot be allocated then the
> returned NULL dm_io struct will cause NULL pointer dereference during
> error handling at the end of dm_split_and_process_bio() -- my patch
> attached below addresses this.

Yes, thanks for finding it.

> Below you'll see I insulated dm_split_and_process_bio() from ever
> checking ci.nowait_failed -- prefer methods like __send_empty_flush
> that are called from dm_split_and_process_bio() return blk_status_t
> (like __process_abnormal_io and __split_and_process_bio do).
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index d6fbbaa7600b..2a9ff269c28b 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -572,18 +572,16 @@ static void dm_end_io_acct(struct dm_io *io)
>  	dm_io_acct(io, true);
>  }
>  
> -static struct dm_io *alloc_io(struct clone_info *ci, struct mapped_device *md, struct bio *bio)
> +static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
>  {
>  	struct dm_io *io;
>  	struct dm_target_io *tio;
>  	struct bio *clone;
>  
> -	if (unlikely(ci->is_nowait)) {
> +	if (unlikely(bio->bi_opf & REQ_NOWAIT)) {
>  		clone = bio_alloc_clone(NULL, bio, GFP_NOWAIT, &md->mempools->io_bs);
> -		if (!clone) {
> -			ci->nowait_failed = true;
> -			return NULL;
> -		}
> +		if (!clone)
> +			return PTR_ERR(-EAGAIN);

:s/PTR_ERR/ERR_PTR/

If -EAGAIN is the only possible error code, should we return NULL instead?

>  	} else {
>  		clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->mempools->io_bs);
>  	}
> @@ -1001,6 +999,8 @@ static void dm_wq_requeue_work(struct work_struct *work)
>  	while (io) {
>  		struct dm_io *next = io->next;
>  
> +		// FIXME: if io->orig_bio has REQ_NOWAIT set should GFP_NOWAIT be used?
> +		// requeue performed from completion path so REQ_NOWAIT can be safely dropped?
>  		dm_io_rewind(io, &md->disk->bio_split);
>  
>  		io->next = NULL;
> @@ -1565,7 +1565,7 @@ static unsigned int __send_duplicate_bios(struct clone_info *ci, struct dm_targe
>  	return ret;
>  }
>  
> -static void __send_empty_flush(struct clone_info *ci)
> +static blk_status_t __send_empty_flush(struct clone_info *ci)
>  {
>  	struct dm_table *t = ci->map;
>  	struct bio flush_bio;
> @@ -1598,6 +1598,8 @@ static void __send_empty_flush(struct clone_info *ci)
>  	atomic_sub(1, &ci->io->io_count);
>  
>  	bio_uninit(ci->bio);
> +
> +	return likely(!ci->nowait_failed) ? BLK_STS_OK : BLK_STS_AGAIN;
>  }
>  
>  static void __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
> @@ -1758,7 +1760,7 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
>  	if (unlikely(ci->is_nowait)) {
>  		clone = alloc_tio(ci, ti, 0, &len, GFP_NOWAIT);
>  		if (unlikely(!clone)) {
> -			ci->nowait_failed = true;
> +			ci->nowait_failed = true; /* unchecked, set for consistency */
>  			return BLK_STS_AGAIN;
>  		}
>  	} else {
> @@ -1772,13 +1774,13 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
>  	return BLK_STS_OK;
>  }
>  
> -static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
> +static void init_clone_info(struct clone_info *ci, struct dm_io *io,
>  			    struct dm_table *map, struct bio *bio, bool is_abnormal)
>  {
>  	ci->is_nowait = !!(bio->bi_opf & REQ_NOWAIT);
>  	ci->nowait_failed = false;
>  	ci->map = map;
> -	ci->io = alloc_io(ci, md, bio);
> +	ci->io = io;
>  	ci->bio = bio;
>  	ci->is_abnormal_io = is_abnormal;
>  	ci->submit_as_polled = false;
> @@ -1813,17 +1815,17 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>  			return;
>  	}
>  
> -	init_clone_info(&ci, md, map, bio, is_abnormal);
> -	if (unlikely(ci.nowait_failed)) {
> -		error = BLK_STS_AGAIN;
> -		goto out;
> +	io = alloc_io(md, bio);
> +	if (unlikely(IS_ERR(io) && ERR_PTR(io) == -EAGAIN)) {
:s/ERR_PTR/PTR_ERR/
> +		/* Unable to do anything without dm_io. */
> +		bio_wouldblock_error(bio);
> +		return;

I would use "if (unlikely(IS_ERR(io)) {
		bio->bi_status = errno_to_blk_status(PTR_ERR(io));
		bio_set_flag(bio, BIO_QUIET);
		bio_endio(bio);
		return;",
so that all possible error codes (that could be added in the future) are 
propageted.

Or, if you change alloc_io to return NULL, you can leave 
bio_wouldblock_error here.

>  	}
> -	io = ci.io;
> +
> +	init_clone_info(&ci, io, map, bio, is_abnormal);
>  
>  	if (bio->bi_opf & REQ_PREFLUSH) {
> -		__send_empty_flush(&ci);
> -		if (unlikely(ci.nowait_failed))
> -			error = BLK_STS_AGAIN;
> +		error = __send_empty_flush(&ci);
>  		/* dm_io_complete submits any data associated with flush */
>  		goto out;
>  	}
> 

Mikulas

