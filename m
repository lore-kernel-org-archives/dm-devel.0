Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E42575F
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 04:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711600222; cv=none; b=SJmW3d/TtrbEj/seTgDLRG6lS3o37if3CXpMH/NP2JkFafLyWbXLoaFqxHULwgj/gD7N+dYgTxgoOIjjgJQ2NAqhqfWa06D5NEnDbuFvzCwd8RsKscZaP24ZUeyCw/HQ2EfFal3ta+dZwKlKM8ux5JTISJ7yW+3MhjfTcz2CqKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711600222; c=relaxed/simple;
	bh=hG/i8gRQhFBrTzjtU0VZ5rcgsLCk1BTlkYDy8jUqDZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=el5DHTIikhvN8jVq+U2XvaRgNJmI/wZqPmDfaO/XuQ73hNrlG1+FDi/WlWoVbVF7WMUaXCO6L7DWaHiQQAnXcvj1RgYL20PGG1FUcLbjWmsdr8OSOzqdo5RRcDGV5wovuY9mPa1wVTsFVG5hDDeFpFHInhkjA2ELFU+UP7uAqbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 80AD268B05; Thu, 28 Mar 2024 05:30:16 +0100 (CET)
Date: Thu, 28 Mar 2024 05:30:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
Message-ID: <20240328043016.GA13701@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-10-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328004409.594888-10-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

I think this should go into the previous patch, splitting it
out just causes confusion.

> +static void disk_free_zone_wplug(struct blk_zone_wplug *zwplug)
> +{
> +	struct gendisk *disk = zwplug->disk;
> +	unsigned long flags;
> +
> +	if (zwplug->flags & BLK_ZONE_WPLUG_NEEDS_FREE) {
> +		kfree(zwplug);
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
> +	list_add_tail(&zwplug->link, &disk->zone_wplugs_free_list);
> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +}
> +
>  static bool disk_insert_zone_wplug(struct gendisk *disk,
>  				   struct blk_zone_wplug *zwplug)
>  {
> @@ -630,18 +665,24 @@ static struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
>  	return zwplug;
>  }
>  
> +static void disk_free_zone_wplug_rcu(struct rcu_head *rcu_head)
> +{
> +	struct blk_zone_wplug *zwplug =
> +		container_of(rcu_head, struct blk_zone_wplug, rcu_head);
> +
> +	disk_free_zone_wplug(zwplug);
> +}

Please verify my idea carefully, but I think we can do without the
RCU grace period and thus the rcu_head in struct blk_zone_wplug:

When the zwplug is removed from the hash, we set the
BLK_ZONE_WPLUG_UNHASHED flag under disk->zone_wplugs_lock.  Once
caller see that flag any lookup that modifies the structure
will fail/wait.  If we then just clear BLK_ZONE_WPLUG_UNHASHED after
the final put in disk_put_zone_wplug when we know the bio list is
empty and no other state is kept (if there might be flags left
we should clear them before), it is perfectly fine for the
zwplug to get reused for another zone at this point.
