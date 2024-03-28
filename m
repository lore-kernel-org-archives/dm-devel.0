Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D5B4F894
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 06:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711608706; cv=none; b=TEhNk84LD2IusWBOzdcU7WTImoJqrx3IdlqO3nkMVXhvnx3W126JjeYz4jqLlFlzuN4l4FmaS5pQLzw5beZ5gb25edjKuOIsCaIpm78bvNuqBMOaBpT7VHvTXEE0Lgh3nhlE4v/T4w2MVaYEd52RS4ZciSYKk/3vkvhYTthkeGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711608706; c=relaxed/simple;
	bh=iWQJeLmFWhP310QIMJOM3u++IXJBHww6QFUNCdlYxH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFK1OSitFWUDbRJLU8qHryC06cFPZGAJmrft/8Uw8sDCfO3Fc47B07K1/nBOw6h4IOtCa1V8T4F1IrrppCozCxFxB3HpMhzVEnJyCdTXm7mJBdeAcm3LtgDRcRpVO/FSjn4pE1d1eqmuW9PoGyqVrc5EoF7upVwfHFoW1Y8kTC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2025C68D17; Thu, 28 Mar 2024 07:51:39 +0100 (CET)
Date: Thu, 28 Mar 2024 07:51:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 30/30] block: Do not special-case plugging of zone
 write operations
Message-ID: <20240328065138.GA17890@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-31-dlemoal@kernel.org> <20240328045430.GN14113@lst.de> <6035bad8-b157-4705-8ec1-80cc003fa646@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6035bad8-b157-4705-8ec1-80cc003fa646@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 03:43:02PM +0900, Damien Le Moal wrote:
> That is indeed not great, but irrelevant for zone writes as the regular BIO plug
> is after the zone write plugging. So the regular BIO plug can only see at most
> one write request per zone. Even if that order changes, that will not result in
> unaligned write errors like before. But the reordering may still be bad for
> performance though, especially on HDD, so yes, we should definitely look into this.

Irrelevant is not how I would frame it.  Yes, it will not affect
correctness.  But it will affect performance not just for the write
itself, but also in the long run as it affects the on-disk extent
layout.

