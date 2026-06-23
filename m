Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B8A3D75C2
	for <dm-devel@lists.linux.dev>; Tue, 23 Jun 2026 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782227102; cv=none; b=cg3T2VzjBE4GBKNCzGYxBjkEvhRSwM4g2Cgc4hJVvfPB8kxgsqjY+gFKJhRQ6co6UL3igNDnC7qhcXncUbmxYxEwrjYQGNY8ydy7oJfcuIiZXt0J3UNZSFMDEKSe5K5MldmWna3p0hVVlj6Jd8w0D0APf233JyC1E5qwPaCe0ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782227102; c=relaxed/simple;
	bh=LsR47Q5J0PpMSawQdmVblyxnAZHiFFAKrEwGD9KU4KQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JiUe7rYkpKwTUU0zyxWzIBlm8WnqDr4PSTPZ5+2ahh/8iRUlrK+1/1met5lY9U3mkKfhkFpmlaYMcxGbxp8dgHw6OLWKRi2Hat2cQI25PqyxfJrrdRq/Qm1isvnKtqVmya5m+/99iDpzN/CIDINUMrqs5mZF0YPDGS/F5wWp42c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E92C368C4E; Tue, 23 Jun 2026 17:04:57 +0200 (CEST)
Date: Tue, 23 Jun 2026 17:04:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 4/6] loop: set dma_alignment from the backing file
 for direct I/O
Message-ID: <20260623150457.GD13628@lst.de>
References: <20260622174241.2299563-1-kbusch@meta.com> <20260622174241.2299563-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622174241.2299563-5-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 10:42:39AM -0700, Keith Busch wrote:
>  	/*
> -	 * Use the minimal dio alignment of the file system if provided.
> +	 * Use the dio alignment of the file system if provided.  dio_offset_align
> +	 * is the minimum dio size and offset; dio_mem_align is the buffer memory
> +	 * alignment, kept as a mask to become the loop device's dma_alignment in
> +	 * direct I/O mode where the buffer is handed to the backing file unchanged.

A bunch of overly long lines here.

> +	 * In direct I/O the user pages are handed to the backing file as-is, so
> +	 * the backing's DMA alignment requirement applies to them.  Advertise it
> +	 * so misaligned I/O is rejected at this device's entry instead of being
> +	 * dispatched to the backend.  Buffered I/O copies through the page cache
> +	 * and imposes no such requirement.
> +	 */

More line spillover here.

> +	if (lo->lo_flags & LO_FLAGS_DIRECT_IO)
> +		lim->dma_alignment = lo->lo_dio_mem_align;
> +	else
> +		lim->dma_alignment = SECTOR_SIZE - 1;

Despite the comment above this does enforce a SECTOR_SIZE dma
alignment for buffered I/O.  Shouldn't this be our lowest supported
value (or dword alignment to match real devices)?

> +	lim = queue_limits_start_update(lo->lo_queue);
> +	if (lo->lo_flags & LO_FLAGS_DIRECT_IO)
> +		lim.dma_alignment = lo->lo_dio_mem_align;
> +	else
> +		lim.dma_alignment = SECTOR_SIZE - 1;

Should this and the above copy of this assignment be factored into a
helper?

