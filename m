Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700209;
	b=dOInXPzrWQ03HFfbPELSZmLCJF87qCQZ5PYhS3befbUIkkYpFCeIv92U3wznquEJUJj5
	 erQrgeMtNpm2X9FvMDP1rUqgeGXFULFrjrzptoMvtzcEEN+9u8dC1NvG7yNqSTFKNSgQo
	 05zwA2gRGSvUtT3v9wVIB40M6FutbbdOoX8LC2BJyPnaHsLdHhVeC9RaC+GfClnZ5m+zc
	 eC93db/f//Ae/7NwhElmznmR8pzkmmWUWiPsOlaicgxTW967/4AttoKXxyIdF9U7T4NLP
	 sfeLVhRE+RK8YVzYbOZBztxdh9KNs+GYDE3JA1S9s9O7RXq+YUw5Kjr1zFvLNOcdmxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700209;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=7OLKJKb/QX1hzA4C4hWBkRiZv41kwBD/QQM6xWAMmhk=;
	b=kz6pxUN0cGLiXaEuZnaPAM0vi/Gp3H6BVd9ypdoqzT7/jlBpAZhw0RwwSKU3oXrDx83j
	 H0L1wDiweL9Y5GChel2F6lSsNhhZeoKFHHA1VxV/cqjANjb+PRJJqa37DsqKeDdHUXQND
	 XLJE9As5yretds1AtQZ+kLcfa1B1bMzG3FUGQfiHjYEPpbTFFgIcKRY493ePVQPFUpjuv
	 5PL0BJlb0xhtLwNO0jPWP2r71FGah4xGc1btFkKodhgtJbfP1XEQA9lMziv1rTtAF59kG
	 WtRvARbmHoIkV+UwRzUevd2FwfTKtlYYrkcltomVgNvDBxmd9q4CL78JMe3UF68+0WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rCmmAYwO;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3AC606A830;
	Tue,  3 Nov 2026 10:03:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B3AC606A830
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rCmmAYwO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7OLKJKb/QX1hzA4C4hWBkRiZv41kwBD/QQM6xWAMmhk=; b=rCmmAYwOVZugETZJXWaPr5M1GM
	BKS3Yv8PPbasw24xCTGq4i+S18Hsn9Adiqtw7OhdJS9NwvjwMq4oh9veFy3iT7cjDY+tflWdGG/Bf
	yk7ZSC5aD8htCgFd71TVjiY3k8WejYHGp67rGiyj2z5xSWPgXncpo/3HxWEr3GA4cbBE0sTRCyL7J
	3Jji5G5t5wj80JzGbrTE7KipUGNORd2E3m3bnJOBYHTgmaZ4IhxOeHoKNFt6JDv+oQY0kTJzMpuNF
	4j0GdJ0jx3KoASP4iVBHX7fvStdYlHl0UAk+yLAThx6FuEFaYPsG3Xt6uKt271VfW79Gjp/va7ehr
	G/4xP/Uw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOBMW-00000001s93-3zui;
	Tue, 03 Nov 2026 10:03:28 +0000
Date: Tue, 3 Nov 2026 02:03:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	dm-devel@lists.linux.dev, mpatocka@redhat.com, bmarzins@redhat.com,
	Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org
Subject: Re: [PATCH] block: let a stacking device inherit its members' DMA
 alignment
Message-ID: <aumxcHVjVonjs6OV@infradead.org>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-2-kbusch@meta.com>
 <atpBVtPqGDWZ2AFo@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atpBVtPqGDWZ2AFo@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 22, 2026 at 01:01:10PM -0400, Mike Snitzer wrote:
> On Thu, Jul 09, 2026 at 09:15:17AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > All device mappers that want to override the dma_alignment do so.

Don't start a patch description by quoting another mail.

> Direct I/O from memory every member accepts is therefore rejected at
> the stacking device, and callers that check the advertised alignment
> (for instance through STATX_DIOALIGN) fall back to buffered I/O.
> 
> Leave dma_alignment at zero in blk_set_stacking_limits() so that the
> stacked value is the strictest of the members'.  blk_validate_limits()
> still applies the SECTOR_SIZE - 1 default when nothing was stacked,
> such as for a table with no devices.  Targets that process the data
> themselves and need logical-block-aligned memory already set
> dma_alignment in their io_hints (dm-crypt, dm-integrity, dm-verity,
> dm-log-writes), and NVMe multipath sets its own.

Chances are very high that this will introduce bugs somewhere,
as a lot of drivers are historically not ready to deal with lower
alignments, and will creeat nasty exploitable bugs.

So you'll need to audit each driver that wants to relax this
individually, and then override the value for them.  Alternatively
we could start with 0 in the block layer, but then you need to
lift the current setting into each caller first, and only remove
them one-by-one with a commit per driver explaining why that is safe
(and sensible).

