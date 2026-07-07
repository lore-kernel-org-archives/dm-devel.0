Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D983B71BE;
	Tue,  7 Jul 2026 19:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783453506; cv=none; b=mpkn5AiOvZOm7zgvX/MkqrLU/qlPFlDqN1uzj0cgsPRmiKz7n9IrqKi4NxuMFuZLdcBfDKdJKjzw8d29ryokGra29A/x4x9hTdYhOO20UWIWVyOuG2ktf3tEGcnxvQRZUyasCEKb4Q8ssamk4v60el5Z/x4FdhHtLAGaVt7xSS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783453506; c=relaxed/simple;
	bh=BTRaOlYOWQeNLsIClkt83Znz0OdVJg74ADrwSnCdBP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X24PW4weeobcbbnrPgRafWFN4kC8Bk/5QsIQot+l6Nj89mJsbQLzz4feC5INu3oQF2+0WqeA1CNmfnlNAUJd8O8aK3c+4FZByxb8dSz5P/m31zXArSFaaNMuJp2X15wx2V7ffsntPvdRCmSXr6+IRDfHBgtV5JwpdvAIeX2WGF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UJACyNXV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJACyNXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3E81F000E9;
	Tue,  7 Jul 2026 19:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783453495;
	bh=mqrN0/2jNOXyVv2OffW0NWZLcVCCk3LcRNLuumYB8Ls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UJACyNXVPOs7tZriQGsNVwJlAmpZHuHBG0DuHpLZ8ZtYHxS0fNi3mmEO7BDbvkJ9m
	 Gf2jvnaNNUvFXrzWUrtrQ0QS4AP88NSFskYADqbbFhloBanWQHQb+bpkU9RS6WO80/
	 xbl3ZmfrxVBfUBesplKGBlmj2KD+Jhopwj3gxIm4x5Uu09cbCLsZTPOO8q+9D1cocJ
	 RJ9IJzthHfBAxIO6nzLjKv2fOCQ/DRBq0lAz+jKDEGHqBCqPkYtME/4ePKoNp5WJOY
	 oKhX+FpvrjpKjDl/Vedlt5Lzpgot5mcw6XKOm65CoNh9mc9M6YBGUISTDKsdiretoO
	 vBayuQTJl4eDg==
Date: Tue, 7 Jul 2026 15:44:54 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Keith Busch <kbusch@kernel.org>, axboe@kernel.dk
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ak1XNlyFC34W47iP@kernel.org>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <ajFyuoMqnvQm738z@kbusch-mbp>
 <0bd687cf-82ac-eacf-844b-c179a52dc72c@redhat.com>
 <akwVkSnXtyl6rBdh@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akwVkSnXtyl6rBdh@kbusch-mbp>

On Mon, Jul 06, 2026 at 02:52:33PM -0600, Keith Busch wrote:
> On Wed, Jun 24, 2026 at 01:14:03PM +0200, Mikulas Patocka wrote:
> > This approach is OK, I will stage the patches when 7.2-rc1 comes out and 
> > when I'll fork the dm git branches.
> > 
> > I suggest one change - it is kind of hacky when multiple I/O completion 
> > callbacks write into io->orig_bio->bi_status concurrently - so it would be 
> > better to not do it and maintain and return separate bit mask for 
> > non-retryable errors.
> > 
> > For example:
> > 
> > static void complete_io(struct io *io)
> > {
> >         unsigned long error_bits = io->error_bits;
> >         unsigned long nonretryable_error_bits = io->nonretryable_error_bits;
> >         io_notify_fn fn = io->callback;
> >         void *context = io->context;
> > 
> >         if (io->vma_invalidate_size)
> >                 invalidate_kernel_vmap_range(io->vma_invalidate_address,
> >                                              io->vma_invalidate_size);
> > 
> >         mempool_free(io, &io->client->pool);
> >         fn(error_bits, nonretryable_error_bits, context);
> > }
> > 
> > static void dec_count(struct io *io, unsigned int region, blk_status_t error)
> > {
> >         if (unlikely(error == BLK_STS_NOTSUPP) || unlikely(error == BLK_STS_INVAL))
> > 		set_bit(region, &io->nonretryable_error_bits);
> >         else if (unlikely(error != BLK_STS_OK))
> >                 set_bit(region, &io->error_bits);
> > 
> >         if (atomic_dec_and_test(&io->count))
> >                 complete_io(io);
> > }
> > 
> > Please send the updated patch that uses this approach.
> 
> Sure thing, I can get started on that. Though I think it's largely
> obviated if we get the block layer to handle things early rather than
> submit malformed bio's, and this will accomplish that:
> 
>   https://lore.kernel.org/dm-devel/20260624170905.3972095-1-kbusch@meta.com/

Jens hasn't picked that series up yet. Jens?

> But I can certainly respin this series as it provides a more indepth
> defence.
> 
> I also owe an update on the relaxed dm-crypt direct-io memory alignment
> as well, as that series fell through the cracks on me for the previous
> merge window.

So where does dm-raid1 and dm-crypt stand relative to these DIO memory
alignment changes?  Inferring they are pretty exposed.

> > BTW. I think that blk_path_error should also test for BLK_STS_INVAL and 
> > return false, otherwise, dm-multipath would be suffering from this bug 
> > too. Ben, could you test it?
> 
> Good point.

Would appreciate knowing if multipath exposed too.

Thanks,
Mike
