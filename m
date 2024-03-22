Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D578B524C4
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 15:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711122804; cv=none; b=OD3dlStDCQIpkTuPzj7oPL2/GALCS+WxYLbcx/YkfJzWXRRrypOFdv+6gO/SqTfO3z5XPBxy1tXsF8ebEwp+J4KgTBMvY43c0Y80XM9EXHlYpzLhbVtaYl4tHMR5HPOo94uatEw8N66FT+XgOAQ5yxx6ELrD76VxVKGxlfdrFio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711122804; c=relaxed/simple;
	bh=MBNIgrgvHLDU9Klz/XIqJ3C6Z6LwSbgnx+25wAHq/Ks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XHITm4mWQltEg/mjngqlHMBsd8oB+Dogi8nlZ9l3YrZbDhPW552rw3pqA07oRt860/uO+GzdaihNhCiJd4tkPsj4CY1rzmbnRuTa+PGCC0DdN/gXxOhJtUPumK5ap0rGsit6jV5MtSGNhwxtWT+S2gPswiVoVBaIWTUmBW7oLuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7e09e1871fdso799718241.0
        for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 08:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711122802; x=1711727602;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FRZRYhPh2Vb+iQZQyR/xjZfwWevZHZuaesiFqcjVqEs=;
        b=bk5xZ9m85O0rDM1TEJbeF3YkiorakeUzoz/q3CiP3jthQtcCY7Z1nMTDsfM/DiaMEW
         nM8rl4iTdIIEBXe9qlcfSbi39oSU486Z5pK2RwjGKeZ5vAIUm6jUqZ8GbMoNpXySbtVe
         OCO+fB1v+BqOocGrUAhNnA5pE8sOFuaG3nvSudD9BeX95tNgcS3gh4KrYxpaKMXTmBgc
         f7YT+Oj07s6RSkxeil4TfYsLr58NQC+DBTzbO/GKunmGSb7K6Dg2UrFfptPlKkPlqoul
         UzrjAawSTpS8Ph6uL2cqccT/iQXQblf6O6WLEOAHr7DuVaC6L5Sypmb8wzkKhyAdz3Qn
         ApDg==
X-Forwarded-Encrypted: i=1; AJvYcCWYbILRSoPUuL0PYqvnEx/AC05N+mB9r67VW0buLaMzgpNHPv87s5wgn9+wjaE9GmJy3X2hj7I+zwQuQ4Jy5n0Chhuyk66p2Xs=
X-Gm-Message-State: AOJu0YwoVlS597iKqLIQBDoIulha6KVJ9n138NwVV72bU81yTo92p4FW
	igbHEHdGL4Wod/S7q9p4BLRekwpMSkiv0jpHDtBnkqSDh4QqXGBrGW6NcmArWQ==
X-Google-Smtp-Source: AGHT+IELXDl9kBKQu38skKLeMUKJhY7bUGU5Lx2RYnmGNJ+VuFCouNADjyAJrJja7jasEq3OS4cfdw==
X-Received: by 2002:a05:6122:2019:b0:4d4:1b6a:7924 with SMTP id l25-20020a056122201900b004d41b6a7924mr35610vkd.8.1711122801711;
        Fri, 22 Mar 2024 08:53:21 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id pt19-20020a056214049300b00690f23c8605sm1188718qvb.23.2024.03.22.08.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 08:53:21 -0700 (PDT)
Date: Fri, 22 Mar 2024 11:53:20 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: dm-integrity: align the outgoing bio in integrity_recheck
Message-ID: <Zf2pcG_X1VyBimfV@redhat.com>
References: <580e4e3-b6b3-e291-282e-b57be178cec1@redhat.com>
 <ZfzhzMgdJJaOZwGA@fedora>
 <2ca5a02-de66-a4bb-b42f-45ea54f79de@redhat.com>
 <Zf1zfjuzb9be0Uwz@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf1zfjuzb9be0Uwz@fedora>

On Fri, Mar 22 2024 at  8:03P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> On Fri, Mar 22, 2024 at 11:30:33AM +0100, Mikulas Patocka wrote:
> > 
> > 
> > On Fri, 22 Mar 2024, Ming Lei wrote:
> > 
> > > On Thu, Mar 21, 2024 at 05:48:45PM +0100, Mikulas Patocka wrote:
> > > > It may be possible to set up dm-integrity with smaller sector size than
> > > > the logical sector size of the underlying device. In this situation,
> > > > dm-integrity guarantees that the outgoing bios have the same alignment as
> > > > incoming bios (so, if you create a filesystem with 4k block size,
> > > > dm-integrity would send 4k-aligned bios to the underlying device).
> > > > 
> > > > This guarantee was broken when integrity_recheck was implemented.
> > > > integrity_recheck sends bio that is aligned to ic->sectors_per_block. So
> > > > if we set up integrity with 512-byte sector size on a device with logical
> > > > block size 4k, we would be sending unaligned bio. This triggered a bug in
> > > > one of our internal tests.
> > > > 
> > > > This commit fixes it - it determines what's the actual alignment of the
> > > > incoming bio and then makes sure that the outgoing bio in
> > > > integrity_recheck has the same alignment.
> > > > 
> > > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > > Fixes: c88f5e553fe3 ("dm-integrity: recheck the integrity tag after a failure")
> > > > Cc: stable@vger.kernel.org
> > > > 
> > > > ---
> > > >  drivers/md/dm-integrity.c |   12 ++++++++++--
> > > >  1 file changed, 10 insertions(+), 2 deletions(-)
> > > > 
> > > > Index: linux-2.6/drivers/md/dm-integrity.c
> > > > ===================================================================
> > > > --- linux-2.6.orig/drivers/md/dm-integrity.c	2024-03-21 14:25:45.000000000 +0100
> > > > +++ linux-2.6/drivers/md/dm-integrity.c	2024-03-21 17:47:39.000000000 +0100
> > > > @@ -1699,7 +1699,6 @@ static noinline void integrity_recheck(s
> > > >  	struct bio_vec bv;
> > > >  	sector_t sector, logical_sector, area, offset;
> > > >  	struct page *page;
> > > > -	void *buffer;
> > > >  
> > > >  	get_area_and_offset(ic, dio->range.logical_sector, &area, &offset);
> > > >  	dio->metadata_block = get_metadata_sector_and_offset(ic, area, offset,
> > > > @@ -1708,13 +1707,14 @@ static noinline void integrity_recheck(s
> > > >  	logical_sector = dio->range.logical_sector;
> > > >  
> > > >  	page = mempool_alloc(&ic->recheck_pool, GFP_NOIO);
> > > > -	buffer = page_to_virt(page);
> > > >  
> > > >  	__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
> > > >  		unsigned pos = 0;
> > > >  
> > > >  		do {
> > > > +			sector_t alignment;
> > > >  			char *mem;
> > > > +			char *buffer = page_to_virt(page);
> > > >  			int r;
> > > >  			struct dm_io_request io_req;
> > > >  			struct dm_io_region io_loc;
> > > > @@ -1727,6 +1727,14 @@ static noinline void integrity_recheck(s
> > > >  			io_loc.sector = sector;
> > > >  			io_loc.count = ic->sectors_per_block;
> > > >  
> > > > +			/* Align the bio to logical block size */
> > > > +			alignment = dio->range.logical_sector | bio_sectors(bio) | (PAGE_SIZE >> SECTOR_SHIFT);
> > > > +			alignment &= -alignment;
> > > 
> > > The above is less readable, :-(
> > 
> > It isolates the lowest bit from dio->range.logical_sector, 
> > bio_sectors(bio) and (PAGE_SIZE >> SECTOR_SHIFT).
> > 
> > See for example this https://www.felixcloutier.com/x86/blsi
> 
> Fine, but I have to say such usage isn't popular.

Yeah, at a minimum it should have a comment explaining the
optimization of combining and then getting lsbit.

The non-ffs() optimized gcd() uses the same but comments it:
	/* Isolate lsbit of r */
	r &= -r;

> > > > +			io_loc.sector = round_down(io_loc.sector, alignment);
> > > > +			io_loc.count += sector - io_loc.sector;
> > > > +			buffer += (sector - io_loc.sector) << SECTOR_SHIFT;
> > > > +			io_loc.count = round_up(io_loc.count, alignment);
> > > 
> > > I feel the above code isn't very reliable, what we need actually is to
> > > make sure that io's sector & size is aligned with dm's
> > > bdev_logical_block_size(bdev).
> > 
> > I thought about using bdev_logical_block_size. But it may be wrong if the 
> > device stack is reconfigured. So, I concluded that taking the alignment 
> > from the bio would be better.
> 
> If logical block becomes mismatched by reconfiguration, the whole DM stack can't work:
> 
> - at the beginning, DM is over NVMe(512 bs), DM & NVMe lbs is 512
> - later, nvme is reconfigured and its lbs becomes 4k, but DM's lbs can't
> be updated
> - then unaligned IO is submitted to NVMe
> 
> So DM _never_ works with mis-matched logical block size because of
> reconfigure, and same with MD.

At some point we need to trust the queue_limits and DM takes
considerable pain to validate the alignment when a dm-table is
(re)loaded.

But we could get into problems with deep(er) device stacks where an
underlying DM device is reloaded but the upper level devices'
queue_limits aren't restacked.  Thankfully, in practice that generally
doesn't occur!

If it were to become a prevalent issue DM would need to grow
validation that DM devices aren't changing their logic_block_size and
overall alignment during runtime.

> > > Yeah, so far the max logical block size is 4k, but it may be increased
> > > in future and you can see the recent lsfmm proposal, so can we force it to be
> > > aligned with bdev_logical_block_size(bdev) here?
> > > 
> > > Also can the above change work efficiently in case of 64K PAGE_SIZE?
> > 
> > It doesn't work efficiently at all - this piece of code is only run in a 
> > pathological case where the user writes into a buffer while reading it (or 
> > when he reads multiple blocks into the same buffer), so I optimized it for 
> > size, not for performance.
> > 
> > But yes, it works with 64K PAGE_SIZE.
> 
> Fine, but I still think PAGE_SIZE is hard to follow than logical block
> size.

Thanks for your review.  I shared many of your review concerns (the
math isn't apporachable, and why not just use logical_block_size in
queue_limits?).

That said, I'm OK with the code as-is because it has been tested to
fix the reported misalignment issue.  BUT, I would like to see
follow-on cleanup in a separate commit, at a minimum there should be
some helpful comments (to address the math and assumptions made,
e.g. this recheck code is not fast path).

Mike
