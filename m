Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4592215575F
	for <dm-devel@lists.linux.dev>; Mon,  9 Dec 2024 07:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733730261; cv=none; b=PTm9RAwoON/6wXNrgsFuOrh94I36MsZSJ3jDZ5J78LS6y2m0m7Pg1xz8g80FKw93aWUMLZ6SLe/1PgboEZ7KgQKxRJJ3ynICYi9PsWGvyNCTarIui/cJK+wkwpRB+wPKAGu6qpA2r3P8puNqfvzZINeUonJOd8lXP4EhL7+MPpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733730261; c=relaxed/simple;
	bh=NLbWVFxo5p0mUZ426qlpICcmfEgGn3ky+MDzRVVdCsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LaRRJzIDs4fdbZ//4sC2yKpQcW07BAvPxsj4gVBkHyk/WR9T2si3efsOuLAHfnsPqdB/GTfYfcweDceyeQp1AhDCH7usogjLkGe9y6VwEh8NoDWkKg3sE99gTrwGAETCqOqlYzEnRWxXhVVWAcfPBDSbq4C2l0XUfgfhZ7crDBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ED0F268AA6; Mon,  9 Dec 2024 08:44:08 +0100 (CET)
Date: Mon, 9 Dec 2024 08:44:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 4/4] dm: Fix dm-zoned-reclaim zone write pointer
 alignment
Message-ID: <20241209074408.GA24323@lst.de>
References: <20241208225758.219228-1-dlemoal@kernel.org> <20241208225758.219228-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241208225758.219228-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 09, 2024 at 07:57:58AM +0900, Damien Le Moal wrote:
> +int blkdev_issue_zone_zeroout(struct block_device *bdev, sector_t sector,
> +		sector_t nr_sects, gfp_t gfp_mask)

Nit: Would blk_zone_issue_zeroout be a better name?

Also I think this needs to be re-ordered before the previous patch to
preserve bisectability.

> +EXPORT_SYMBOL(blkdev_issue_zone_zeroout);

EXPORT_SYMBOL_GPL is used for all other zoned code, I'd do the same
here for consitency.

