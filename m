Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CC43D3CF2;
	Mon,  6 Jul 2026 20:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783371156; cv=none; b=iNdN3s6aFZFdLuKtmuPwjc178sp+h+mNUSKU8eqnKFnx4Y6YDddmSoP1abgYOAQtpvy5/SWIixnpRlEkNfjrUn/3iGcgpkS+GeJsboeiMe/RQn0oeFTj9G2KD2+EHSPMMyndmp1/BqJvbyWJ1k/t/8pMM155e/3ErmYeYCixG50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783371156; c=relaxed/simple;
	bh=6wNW8CEKz/TdzFqSLnT7Wmn5hQxkNgcxhw+xSjzEbsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1GjoPOzlD/vtUr6Sr4bokDPwzjN34dvM+RIsmkKamsuDxCSJYTdevePutE57gFWq0976CdYFFmSTX/nNlwfvoRwRCD4stB8ZkMnkPLRvGhqDtwuy81zujWpR61MNJ2gcmwd9McQVjMnyHspXgJqkXnI+zY5WLvFGd3HJCiixqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OdVITmPm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OdVITmPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A396C1F000E9;
	Mon,  6 Jul 2026 20:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783371154;
	bh=1c5d93qfn7scBZhbRsILrksrQRfDvheZrFXKwJHJHkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OdVITmPmXHTaN+5akq7sGNv25rV0H/dpCE1VIu4UpPWlERMWyS2LIfSTW7b+tvmM5
	 958ZmVw59SllheqQjqRELKBvHWHed75AMt+UM2QjcYuMzW0SjnbeMHqlzWQ/AY47HR
	 WJK1tSTUfBwvDFT1UwDhGbtQKHkyfc/ziqyh811VPI8l0LhbO4lx4MEKbwEa+fHN25
	 MgxgtF/VTIc9yirj3qXgC6tNA/n0vL1/AO+7v7gqj5lpRzbdfAb7cFlvtb4wd9sz7W
	 GfwkYjHHLo6ZjzGWnxp46ic1VeOxowRD/N90qwK4Ajb05wTlhz5cyeR/BVKXFzXLE2
	 FUoaQPM4q3CMQ==
Date: Mon, 6 Jul 2026 14:52:33 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Keith Busch <kbusch@meta.com>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <akwVkSnXtyl6rBdh@kbusch-mbp>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <ajFyuoMqnvQm738z@kbusch-mbp>
 <0bd687cf-82ac-eacf-844b-c179a52dc72c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bd687cf-82ac-eacf-844b-c179a52dc72c@redhat.com>

On Wed, Jun 24, 2026 at 01:14:03PM +0200, Mikulas Patocka wrote:
> This approach is OK, I will stage the patches when 7.2-rc1 comes out and 
> when I'll fork the dm git branches.
> 
> I suggest one change - it is kind of hacky when multiple I/O completion 
> callbacks write into io->orig_bio->bi_status concurrently - so it would be 
> better to not do it and maintain and return separate bit mask for 
> non-retryable errors.
> 
> For example:
> 
> static void complete_io(struct io *io)
> {
>         unsigned long error_bits = io->error_bits;
>         unsigned long nonretryable_error_bits = io->nonretryable_error_bits;
>         io_notify_fn fn = io->callback;
>         void *context = io->context;
> 
>         if (io->vma_invalidate_size)
>                 invalidate_kernel_vmap_range(io->vma_invalidate_address,
>                                              io->vma_invalidate_size);
> 
>         mempool_free(io, &io->client->pool);
>         fn(error_bits, nonretryable_error_bits, context);
> }
> 
> static void dec_count(struct io *io, unsigned int region, blk_status_t error)
> {
>         if (unlikely(error == BLK_STS_NOTSUPP) || unlikely(error == BLK_STS_INVAL))
> 		set_bit(region, &io->nonretryable_error_bits);
>         else if (unlikely(error != BLK_STS_OK))
>                 set_bit(region, &io->error_bits);
> 
>         if (atomic_dec_and_test(&io->count))
>                 complete_io(io);
> }
> 
> Please send the updated patch that uses this approach.

Sure thing, I can get started on that. Though I think it's largely
obviated if we get the block layer to handle things early rather than
submit malformed bio's, and this will accomplish that:

  https://lore.kernel.org/dm-devel/20260624170905.3972095-1-kbusch@meta.com/

But I can certainly respin this series as it provides a more indepth
defence.

I also owe an update on the relaxed dm-crypt direct-io memory alignment
as well, as that series fell through the cracks on me for the previous
merge window.
 
> BTW. I think that blk_path_error should also test for BLK_STS_INVAL and 
> return false, otherwise, dm-multipath would be suffering from this bug 
> too. Ben, could you test it?

Good point.
