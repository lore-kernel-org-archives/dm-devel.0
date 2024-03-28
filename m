Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2163207
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 04:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711601674; cv=none; b=PFGHex7sG5NncmUQPWma0CfUY31160ooqQaU/pytoChWtw/vtCfB1YB/8/b1WRvhTGE/9r4eaDwC/zUTGO+fg//+6wfmRU7en71FaDMrjNg8XtWW+2fAh7tUQdg+QVQfHz/z2uBFfnwkUg2pR5QS2WMYRA0HWOcdtMyNYuLX3qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711601674; c=relaxed/simple;
	bh=q33FZxlaS+vjnI68ODkHX0jOlECgGNUWLeZagFwgwtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YTD9y19aMUhQIV3aavd2WPykFDQ4DU1Jjf8dgc3WnWGaGA+JvaWpDSD0UihROWGP/ntu7qWNb2m9xxTBfcLaRmNT8hay3aYQZX92rH+fFvta8T5CIyao1uoe82Lrs5DCaMNdy3AbJkGD/tO5qyhQq0zVeVyYeXlTmVOdcz9OIPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B489968B05; Thu, 28 Mar 2024 05:54:30 +0100 (CET)
Date: Thu, 28 Mar 2024 05:54:30 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 30/30] block: Do not special-case plugging of zone
 write operations
Message-ID: <20240328045430.GN14113@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-31-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328004409.594888-31-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 09:44:09AM +0900, Damien Le Moal wrote:
> With the block layer zone write plugging being automatically done for
> any write operation to a zone of a zoned block device, a regular request
> plugging handled through current->plug can only ever see at most a
> single write request per zone. In such case, any potential reordering
> of the plugged requests will be harmless. We can thus remove the special
> casing for write operations to zones and have these requests plugged as
> well. This allows removing the function blk_mq_plug and instead directly
> using current->plug where needed.

This looks good in general:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But IIRC we recently had a report that plus reorder I/Os, which would
be grave for the extent layout if we haven't fixed that yet, so we
should probably look into it first.

