Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E28111A1
	for <dm-devel@lists.linux.dev>; Sat,  1 Jun 2024 05:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717221215; cv=none; b=gHSU2ZvTtumaj9wzCpCdS7e/EHzclC0S40Q9gcmiZy664CS+Q8Uxlm4q75KSrwLHnxL7cO5hd4pDVHvoNg0y59N86bXa+wzwmspigVmu9eR8rQR+DLAMFmTejqBS76ejFWb5ZR0AQazgtg6WapHinY06EeN1cKz8WchYtGxZRQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717221215; c=relaxed/simple;
	bh=sK+PY7jfW5rGdua1lss1CPxpFyj2P5q7uLdGs1sUJpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NawgWVwL2hAeSkhlevPdcp1+4S/n3+X5uvBFISk12Dg6SbZNtmYSZez7XaJ3GY7v+kxKY8w4QfuGHQJULryrX72L5PhYUpGUlrH0T4XfjKiE8gLwXj8BCoLQG0srHsnkX2KNgSTBT+Uc+K2AXFvD4GgIF+F5sbxWlbb+uFz+ogE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3643A68D17; Sat,  1 Jun 2024 07:53:23 +0200 (CEST)
Date: Sat, 1 Jun 2024 07:53:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	martin.petersen@oracle.com, bvanassche@acm.org, david@fromorbit.com,
	hare@suse.de, damien.lemoal@opensource.wdc.com,
	anuj20.g@samsung.com, joshi.k@samsung.com, nitheshshetty@gmail.com,
	gost.dev@samsung.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v20 01/12] block: Introduce queue limits and sysfs for
 copy-offload support
Message-ID: <20240601055323.GB5613@lst.de>
References: <20240520102033.9361-1-nj.shetty@samsung.com> <CGME20240520102830epcas5p27274901f3d0c2738c515709890b1dec4@epcas5p2.samsung.com> <20240520102033.9361-2-nj.shetty@samsung.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520102033.9361-2-nj.shetty@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 20, 2024 at 03:50:14PM +0530, Nitesh Shetty wrote:
> Add device limits as sysfs entries,
> 	- copy_max_bytes (RW)
> 	- copy_max_hw_bytes (RO)
> 
> Above limits help to split the copy payload in block layer.
> copy_max_bytes: maximum total length of copy in single payload.
> copy_max_hw_bytes: Reflects the device supported maximum limit.

That's a bit of a weird way to phrase the commit log as the queue_limits
are the main thing (and there are three of them as required for the
scheme to work).  The sysfs attributes really are just an artifact.

> @@ -231,10 +237,11 @@ int blk_set_default_limits(struct queue_limits *lim)
>  {
>  	/*
>  	 * Most defaults are set by capping the bounds in blk_validate_limits,
> -	 * but max_user_discard_sectors is special and needs an explicit
> -	 * initialization to the max value here.
> +	 * but max_user_discard_sectors and max_user_copy_sectors are special
> +	 * and needs an explicit initialization to the max value here.

s/needs/need/

> +/*
> + * blk_queue_max_copy_hw_sectors - set max sectors for a single copy payload
> + * @q:	the request queue for the device
> + * @max_copy_sectors: maximum number of sectors to copy
> + */
> +void blk_queue_max_copy_hw_sectors(struct request_queue *q,
> +				   unsigned int max_copy_sectors)
> +{
> +	struct queue_limits *lim = &q->limits;
> +
> +	if (max_copy_sectors > (BLK_COPY_MAX_BYTES >> SECTOR_SHIFT))
> +		max_copy_sectors = BLK_COPY_MAX_BYTES >> SECTOR_SHIFT;
> +
> +	lim->max_copy_hw_sectors = max_copy_sectors;
> +	lim->max_copy_sectors =
> +		min(max_copy_sectors, lim->max_user_copy_sectors);
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_max_copy_hw_sectors);

Please don't add new blk_queue_* helpers, everything should go through
the atomic queue limits API now.  Also capping the hardware limit
here looks odd.

> +	if (max_copy_bytes & (queue_logical_block_size(q) - 1))
> +		return -EINVAL;

This should probably go into blk_validate_limits and just round down.

Also most block limits are in kb.  Not that I really know why we are
doing that, but is there a good reason to deviate from that scheme?

