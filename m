Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE341DB12C
	for <dm-devel@lists.linux.dev>; Mon,  3 Nov 2025 13:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762177657; cv=none; b=eWzxYiAILiepts673IhSjGGHG0q4V7wOGgvBxgHOpMBsehHMsQjSMgqw/yv80V4Bx4gnRiJn8Ze/dBmTN+lTs+kJmdUVR2aUqufDzpJdBMtZOAVcBvJUELQphqGNvR8B343h15Q6zX90OWZ7ibn06qPGQjbFByIbhlytF/ZpU88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762177657; c=relaxed/simple;
	bh=SzWSy8kwCbuKTxu1PU8OhH0qr7LoFLR/Qs0PwOf85WA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kY/RXS959UNepeNTtqxDxg4mXBdOPnEKs18cqFM9OB2hF31vQAhpLJbuMzerYmwEz/cbBt7aWfvWT3JmnzbhHwqARkV29DJdfIfWfKtHCCjaZBVyi7hNdzzTIlk1UTm8kOp4PFUYcmelylv6A7DCofY0rNs1eUocmuSc3l0+njg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA162227AAA; Mon,  3 Nov 2025 14:47:31 +0100 (CET)
Date: Mon, 3 Nov 2025 14:47:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, Keith Busch <keith.busch@wdc.com>,
	Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v2 08/15] block: refactor blkdev_report_zones() code
Message-ID: <20251103134731.GB25126@lst.de>
References: <20251103133123.645038-1-dlemoal@kernel.org> <20251103133123.645038-9-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103133123.645038-9-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 03, 2025 at 10:31:16PM +0900, Damien Le Moal wrote:
> In preparation for implementing cached report zone, split the main part
> of the code of blkdev_report_zones() into the helper function
> blkdev_do_report_zones(), with this new helper taking as argument a
> struct blk_report_zones_args pointer instead of a report callback
> function and its private argument.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

