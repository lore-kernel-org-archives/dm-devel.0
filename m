Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB35385D97
	for <dm-devel@lists.linux.dev>; Wed,  8 Jul 2026 23:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783553061; cv=none; b=TZr1TaRRIXQqqdCGptESXiQKzlV2TgrbvX+ljsXpQ7H2HvVX2ppU6KbXnN1DRZFdsC4suDOsZli2oI/rs8oZx0yBymI1ENd1Iy6D6XLeem9y/GdQTM830bki9bMPWOmO4QND6uHZtfubC2TSgRh+pwxy9gif1cUIfHQeSO7gJyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783553061; c=relaxed/simple;
	bh=JtRB+pY0jGgOOTlVurcxI4B+c+Yq3YAfLr+R/J5xOM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=a6PdsGAbcMiOszU6ttTUI7V3PeZ1iqFrPVTvJXGIxPCRY7UJVaV5oA4VnVsT9OBU4IwCQQLeKxuFpmmMhTB3LuSt0HL2ofOZDLDBtlQIikycrf22aSipkrPydMdgUft27jps28IIo5NYEw11SKHYq2ZjC3zq6F8BQ34CQYXZm4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RTh6lsEB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RTh6lsEB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783553059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p9Tdbre0PNKSXvRptozBBT+tS7NebUWHcrzp9pkL8yo=;
	b=RTh6lsEBaML+A3XqiAiuu2AZOCDk2uwHzm7QAmwoeviTllAjfMRiZJWej7fSR0gtPp0OyK
	2FJvpQ+BhST1iOG2c8TeEbGjrDwG6FVu4hmeTJXNCqIgZCQG3apYZn4SgDqmjtRnvT8Cfe
	QuSbfMyflIVueJcFI7YrCfeXMVLakEY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-412-zC17dWHfNZ2Q1N59mu4B1w-1; Wed,
 08 Jul 2026 19:24:18 -0400
X-MC-Unique: zC17dWHfNZ2Q1N59mu4B1w-1
X-Mimecast-MFC-AGG-ID: zC17dWHfNZ2Q1N59mu4B1w_1783553056
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2DBE419560B7;
	Wed,  8 Jul 2026 23:24:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 372943F317;
	Wed,  8 Jul 2026 23:24:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 668NOD8G2029519
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 8 Jul 2026 19:24:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 668NODbv2029518;
	Wed, 8 Jul 2026 19:24:13 -0400
Date: Wed, 8 Jul 2026 19:24:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>, axboe@kernel.dk,
        Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@meta.com>,
        dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ak7cHXaWjVX6Uamj@redhat.com>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <ajFyuoMqnvQm738z@kbusch-mbp>
 <0bd687cf-82ac-eacf-844b-c179a52dc72c@redhat.com>
 <akwVkSnXtyl6rBdh@kbusch-mbp>
 <ak1XNlyFC34W47iP@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ak1XNlyFC34W47iP@kernel.org>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: f7q2HVS2DEa8cfSg8CCGC7SffuoGglwFL1YF4CZK4qk_1783553056
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 07, 2026 at 03:44:54PM -0400, Mike Snitzer wrote:
> On Mon, Jul 06, 2026 at 02:52:33PM -0600, Keith Busch wrote:
> > On Wed, Jun 24, 2026 at 01:14:03PM +0200, Mikulas Patocka wrote:
> > > This approach is OK, I will stage the patches when 7.2-rc1 comes out and 
> > > when I'll fork the dm git branches.
> > > 
> > > I suggest one change - it is kind of hacky when multiple I/O completion 
> > > callbacks write into io->orig_bio->bi_status concurrently - so it would be 
> > > better to not do it and maintain and return separate bit mask for 
> > > non-retryable errors.
> > > 
> > > For example:
> > > 
> > > static void complete_io(struct io *io)
> > > {
> > >         unsigned long error_bits = io->error_bits;
> > >         unsigned long nonretryable_error_bits = io->nonretryable_error_bits;
> > >         io_notify_fn fn = io->callback;
> > >         void *context = io->context;
> > > 
> > >         if (io->vma_invalidate_size)
> > >                 invalidate_kernel_vmap_range(io->vma_invalidate_address,
> > >                                              io->vma_invalidate_size);
> > > 
> > >         mempool_free(io, &io->client->pool);
> > >         fn(error_bits, nonretryable_error_bits, context);
> > > }
> > > 
> > > static void dec_count(struct io *io, unsigned int region, blk_status_t error)
> > > {
> > >         if (unlikely(error == BLK_STS_NOTSUPP) || unlikely(error == BLK_STS_INVAL))
> > > 		set_bit(region, &io->nonretryable_error_bits);
> > >         else if (unlikely(error != BLK_STS_OK))
> > >                 set_bit(region, &io->error_bits);
> > > 
> > >         if (atomic_dec_and_test(&io->count))
> > >                 complete_io(io);
> > > }
> > > 
> > > Please send the updated patch that uses this approach.
> > 
> > Sure thing, I can get started on that. Though I think it's largely
> > obviated if we get the block layer to handle things early rather than
> > submit malformed bio's, and this will accomplish that:
> > 
> >   https://lore.kernel.org/dm-devel/20260624170905.3972095-1-kbusch@meta.com/
> 
> Jens hasn't picked that series up yet. Jens?
> 
> > But I can certainly respin this series as it provides a more indepth
> > defence.
> > 
> > I also owe an update on the relaxed dm-crypt direct-io memory alignment
> > as well, as that series fell through the cracks on me for the previous
> > merge window.
> 
> So where does dm-raid1 and dm-crypt stand relative to these DIO memory
> alignment changes?  Inferring they are pretty exposed.
> 
> > > BTW. I think that blk_path_error should also test for BLK_STS_INVAL and 
> > > return false, otherwise, dm-multipath would be suffering from this bug 
> > > too. Ben, could you test it?
> > 
> > Good point.
> 
> Would appreciate knowing if multipath exposed too.

I can't make it happen. I can reproduce this using dm-mirror, but when I
try with dm-multipath, it fails with BLK_STS_INVAL before it ever makes
it into the request layer.

blk_mq_submit_bio() -> __bio_split_to_limits() -> bio_split_rw() ->
bio_split_rw_at() -> bio_split_io_at()

bio_split_io_at() checks the bio_vec alignment and fails with -EINVAL,
causing the bio to get failed.

-Ben

> 
> Thanks,
> Mike

