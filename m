Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FC514374D;
	Tue, 30 Apr 2024 15:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714490940; cv=none; b=STwXjWGOXI4TJvuefxu6qQp20qH7Tr3cyttzr2/B6YzfYPXGu3z0HrWS7E0uUxDkTSmcS7rHWIt3mwKvkXMYsozXCnU+t8//6Yce5g0HlyhF/SvnhE42roDYcuOy48kG6Ww9LN72WNY51IB9Yh7W46tPoagn1x736n0TEZdNf/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714490940; c=relaxed/simple;
	bh=4wzhusDu2kottjdqxweKQCW8XSUzIVDg6+bz+ZC4EFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nXkg1QMmUfgDacWXrwpxIW/oHqTqBtZ6qCUDv0n1+gAIS6hM/2BxX1XwPdgmOOxmm7R8n7/7UxbKLHK6XAvm+HzpumHGCWLsRKXdvu1fRZEB+inxn3B3KujKODexHncYRkg1Gn/Erd1KWdTaWCEpC+0UcW2qLFtbxPigEAWXyuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qdxvIFt2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qdxvIFt2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=anq8xj4KEPmVHzsx/ChTyefgFVUaW5U9Pqm8x8DaWIA=; b=qdxvIFt21NoPYGOE99HCCpoYAq
	AX2A05PeK23yPJ6W/+Vg3hm8H1iHlYvcF0KCHbhsLVoliM8ue23S82s0bJ1GgKqZI1uvvoSPm6nub
	WbAbleRLz9C9NXYuU/7rm/B6JJN87mFoIYtKf8Rr09iEjo/efVkMY39XlOwCMIuAP/BxzsjsmQZxB
	BGEGgjCxvhrXN8YIg09u2HqTayYwbGZWX6bil6phhAlCQ0NzH9pvA16H60/YA7hQrXeus3LgUq/Rx
	Ew0xF671IXsSR6ZieH928oQAEszqpSNXEXkh0Wf6dPWME/FQJIIOsWUqC7sp3jChcjPRqU6ZPLOeU
	FYM/4SDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1pPf-000000072ic-06wM;
	Tue, 30 Apr 2024 15:28:59 +0000
Date: Tue, 30 Apr 2024 08:28:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 04/13] block: Fix reference counting for zone write plugs
 in error state
Message-ID: <ZjEOOmfY0e4Eve_9@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125131.668482-5-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  
> +static inline void disk_zone_wplug_set_error(struct gendisk *disk,
> +					     struct blk_zone_wplug *zwplug)
> +{
> +	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR)) {

Can you just do an early return if the flag is not set instead of
all the extra indentation?

> +static inline void disk_zone_wplug_clear_error(struct gendisk *disk,
> +					       struct blk_zone_wplug *zwplug)
> +{
> +	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {

Same here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
