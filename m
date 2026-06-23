Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072DF23D2B1
	for <dm-devel@lists.linux.dev>; Tue, 23 Jun 2026 15:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782227426; cv=none; b=TeFLtVRpDDWL/0TNMMLkg4GV7LaPvofBNDdjm5lFjU12Te2Si0rYBsPbhB3K1feHHivRa1RGAJRHog0vGvrSvKkA9Haf1S4jAihC7zCc/plfzjoyuTeKwP9Ic2YMg6F3J9mqCf/zE6wtGflhjheUYlnAwLQHfxqhf2HDo+kbmqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782227426; c=relaxed/simple;
	bh=+T/B/tZ+woy91IHFHED5KB3IAl+8s0Wv7O1/PBcwXuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gw+3V6Y/J8miFwpIwkMKquZ/RJQLzHgE0ZYfhLfBbBhcbq/uCra3XHW+6tbkK1HhFyZzmeARX4NOJTTLRBEZ4trxX4FzofIuCmKqMvabq8kwyioqVDXnQ6IwRQjlPcLuRhHW7X4mklooja92A4vH17IknkSJ/Bh42VpI2H2hAzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 81F1C68C4E; Tue, 23 Jun 2026 17:10:21 +0200 (CEST)
Date: Tue, 23 Jun 2026 17:10:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCHv2 6/6] block: validate user space vectors during
 extraction
Message-ID: <20260623151021.GA14919@lst.de>
References: <20260622174241.2299563-1-kbusch@meta.com> <20260622174241.2299563-7-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622174241.2299563-7-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +#ifdef CONFIG_DEBUG_KERNEL

That's a pretty broad option.  Not that I have any better idea off the
bat.

> +static inline bool bio_iov_bvec_aligned(const struct bio *bio,
> +					unsigned mem_align_mask)
> +{
> +	/*
> +	 * The vectors are owned and laid out by the caller; we only forward
> +	 * them. Most callers are already aligned, but io_uring can place a
> +	 * user chosen offset through a registered buffer, where only the first
> +	 * vector may be unaligned.
> +	 */
> +	return !(mp_bvec_iter_offset(bio->bi_io_vec, bio->bi_iter) &
> +							mem_align_mask);

I don't fully understand the comment.  I guess this is to say ITER_BVEC
users better don't create any alignment gaps?  Maybe we should also
clearly document that in uio.h?

>  	return bio_iov_iter_get_pages(bio, iter,
> +			bdev_dma_alignment(bdev),

Nit: this easily fits onto the previous line.

Otherwise this looks good.
