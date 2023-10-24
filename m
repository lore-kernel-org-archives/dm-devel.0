Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD822E625
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 19:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-49d0a704ac7so1954322e0c.1
        for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 12:32:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698175968; x=1698780768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4d/wdjrBU4iBQl0Krvv4V/aUJPtOrENbOsxzLG2hnU=;
        b=w/AyncBtu1nTLHCvE4lX+4K+BZwqJpf2JiiA9txkhvo4/qYRN+aanYOe8jgQ5+kVQ/
         Kls7hisgM+jLSjClHsxWo4Hqxof/pNGRDAXbzXzGfKA6gXgQU3sN2YCXzGPtiAqNNANF
         4nVF9qVyR6XPItD9X7AMoU+6JS94POpHRXyfwTTuWCMOFiMdBMo0zm/QsbGmwewNjfK/
         aZc39JajACJH2/p4zmbMVXE9Qd9OAtgMFclhMimjKkvm8wF/HnGFc8EOCirwAHk+vXSm
         uxxVecXHA/h8/34s45H+FFi0BdSEPNSi9V4jQMXZ7hLMQLkZ9MM0fQcBWF/uszsZtNuE
         Yp4w==
X-Gm-Message-State: AOJu0Yz4b1TiWwsw+IIfdXXuot/rf/DelvrxLzTEfJATDrgSI18ZDpQa
	CGaj7HYQPh2yzjZpYpmPgq9t
X-Google-Smtp-Source: AGHT+IHpT46Nea/R6DQGkaAmCmglP5T/IJM1EVz0+VmMUXFnJuAvM6r8MxaqLZMK4I+/u578/+ahWQ==
X-Received: by 2002:a1f:a701:0:b0:49b:289a:cc4a with SMTP id q1-20020a1fa701000000b0049b289acc4amr11026335vke.3.1698175967988;
        Tue, 24 Oct 2023 12:32:47 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id m26-20020ae9e01a000000b007726002d69esm3658244qkk.10.2023.10.24.12.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 12:32:47 -0700 (PDT)
Date: Tue, 24 Oct 2023 15:32:46 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: dm: Respect REQ_NOWAIT bios
Message-ID: <ZTgb3lkNmEUIYpsl@redhat.com>
References: <15ca26cc-174a-d4e8-9780-d09f8e5a6ea5@redhat.com>
 <ZTgFtseG3m3WPWn/@redhat.com>
 <e796de8-bac1-8f7a-c6eb-74d39aad8a2b@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e796de8-bac1-8f7a-c6eb-74d39aad8a2b@redhat.com>

On Tue, Oct 24 2023 at  3:18P -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 24 Oct 2023, Mike Snitzer wrote:
> 
> > For the benefit of others, since this patch was posted to the old
> > dm-devel list, here is the original patch proposal:
> > https://patchwork.kernel.org/project/dm-devel/patch/15ca26cc-174a-d4e8-9780-d09f8e5a6ea5@redhat.com/
> > 
> > On Tue, Oct 03 2023 at 11:30P -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > Hi
> > > 
> > > Here I'm sending that patch for REQ_NOWAIT for review.
> > > 
> > > It is not tested, except for some trivial tests that involve logical 
> > > volume activation.
> > 
> > At a minimum we need to test with the simple test code Jens provided
> > in commit a9ce385344f9 ("dm: don't attempt to queue IO under RCU protection")
> 
> The question is - how do we simulate the memory allocation failures? Do we 
> need to add some test harness that will randomly return NULL to these 
> allocations? Or will we use the kernel fault-injection framework?

Will think about it (and do research).  Maybe others have suggestions?

> > Below you'll see I insulated dm_split_and_process_bio() from ever
> > checking ci.nowait_failed -- prefer methods like __send_empty_flush
> > that are called from dm_split_and_process_bio() return blk_status_t
> > (like __process_abnormal_io and __split_and_process_bio do).
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index d6fbbaa7600b..2a9ff269c28b 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -572,18 +572,16 @@ static void dm_end_io_acct(struct dm_io *io)
> >  	dm_io_acct(io, true);
> >  }
> >  
> > -static struct dm_io *alloc_io(struct clone_info *ci, struct mapped_device *md, struct bio *bio)
> > +static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
> >  {
> >  	struct dm_io *io;
> >  	struct dm_target_io *tio;
> >  	struct bio *clone;
> >  
> > -	if (unlikely(ci->is_nowait)) {
> > +	if (unlikely(bio->bi_opf & REQ_NOWAIT)) {
> >  		clone = bio_alloc_clone(NULL, bio, GFP_NOWAIT, &md->mempools->io_bs);
> > -		if (!clone) {
> > -			ci->nowait_failed = true;
> > -			return NULL;
> > -		}
> > +		if (!clone)
> > +			return PTR_ERR(-EAGAIN);
> 
> :s/PTR_ERR/ERR_PTR/

Ha, not sure how I inverted it.. but thanks.

> If -EAGAIN is the only possible error code, should we return NULL instead?

Yeah, thought about that.  Think returning NULL is fine and if/when
other reasons for failure possible we can extend as needed.

> > @@ -1813,17 +1815,17 @@ static void dm_split_and_process_bio(struct mapped_device *md,
> >  			return;
> >  	}
> >  
> > -	init_clone_info(&ci, md, map, bio, is_abnormal);
> > -	if (unlikely(ci.nowait_failed)) {
> > -		error = BLK_STS_AGAIN;
> > -		goto out;
> > +	io = alloc_io(md, bio);
> > +	if (unlikely(IS_ERR(io) && ERR_PTR(io) == -EAGAIN)) {
> :s/ERR_PTR/PTR_ERR/

Yes.

> > +		/* Unable to do anything without dm_io. */
> > +		bio_wouldblock_error(bio);
> > +		return;
> 
> I would use "if (unlikely(IS_ERR(io)) {
> 		bio->bi_status = errno_to_blk_status(PTR_ERR(io));
> 		bio_set_flag(bio, BIO_QUIET);
> 		bio_endio(bio);
> 		return;",
> so that all possible error codes (that could be added in the future) are 
> propageted.
> 
> Or, if you change alloc_io to return NULL, you can leave 
> bio_wouldblock_error here.

Yeah, will just return NULL and stick with bio_wouldblock_error() for
now.

Thanks,
Mike
