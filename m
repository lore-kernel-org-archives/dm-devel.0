Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEC07081A
	for <dm-devel@lists.linux.dev>; Tue, 23 Jun 2026 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782227211; cv=none; b=txnG3ql8wg0PH4qVl8mQs1W/WN3OY6Gzt23hpWfdx1EAMQ69ne88XSIX1vEsFfhlUFpvas5uXIumKiclrXX+o3BnslTZWWEioAH1WmK3ELrt9XThzv77Juz/tmOUuWdG6oZsxKRuBd3/7BUadaSvodzPliYahLUrzrdu1F5auRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782227211; c=relaxed/simple;
	bh=sK3ItveBFUrVJJnRNhrTldbfjNPeAE2ukwjWv7fEHs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K18Selj3rSrb0rCfSfA9hdNzwnOi8u3KEXcpzLWlTitoxZ2x+deVRHWOSpIvJiEFHHcQLIZaBi1uqURtDB5MUd3VQNVrz6QOYKfw6lt9Ue7IDiC2QoH4iSxu95/fUv7g0CYhKIpB5hhqJ3Mb2b4AIVlNljkjkwV+UVAtoGKvRV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4673168C4E; Tue, 23 Jun 2026 17:06:47 +0200 (CEST)
Date: Tue, 23 Jun 2026 17:06:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 5/6] zloop: set dma_alignment from the backing files
 for direct I/O
Message-ID: <20260623150647.GE13628@lst.de>
References: <20260622174241.2299563-1-kbusch@meta.com> <20260622174241.2299563-6-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622174241.2299563-6-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 10:42:40AM -0700, Keith Busch wrote:
>  {
>  	struct block_device *sb_bdev = zone->file->f_mapping->host->i_sb->s_bdev;
>  	struct kstat st;
> +	bool have_dioalign = !vfs_getattr(&zone->file->f_path, &st,
> +					  STATX_DIOALIGN, 0) &&
> +			     (st.result_mask & STATX_DIOALIGN);

This is getting a bit crazy for an assignment :)

Maybe refactor this along the lines of the loop.c code?

> +	/* Direct I/O hands the request's pages to the backing files unchanged. */

Overly long line.

