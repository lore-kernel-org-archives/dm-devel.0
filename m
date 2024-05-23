Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FCA125AC
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 15:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716479416; cv=none; b=CK5cgvI+MrVYLZlBWEIKsVQsJLGCxn+52EP956U+ppQI9Wj87W4nKpceyfQ2yxnouuIbs4XXomR0n6ocQog26uBO6YgWme9TTq7Sdnh9la7nOJH3KKg2+zBclDf8XBWk5nbh14tsLMBSWm+BshBl0m5CC1USJqLUQJ7lYjpilo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716479416; c=relaxed/simple;
	bh=HfmwJIJauEW0yIYRaRsYm3ww7IE6tXAHzGyQMRqfvzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aG1p0G1stN6IEcuBqh7BhIQVyZEHifZtuT5v9oFhDQd3U8svDRqlSv5V7x8/prvrp5L/rCYl6IXUZ+laCPRvVZHS6xcsH4Z2zulcxUg3q7L0mD96sPb3axs5EIm2X1gU0F8txVqbKlqPkBqBLsOULfxEPr3rb+zLc226/F1Bj/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 23BAF68BFE; Thu, 23 May 2024 17:50:10 +0200 (CEST)
Date: Thu, 23 May 2024 17:50:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>
Subject: Re: dm: retain stacked max_sectors when setting queue_limits
Message-ID: <20240523155009.GB1783@lst.de>
References: <20240522025117.75568-1-snitzer@kernel.org> <20240522142458.GB7502@lst.de> <Zk4h-6f2M0XmraJV@kernel.org> <20240523082731.GA3010@lst.de> <Zk9OyGTESlHXu6Wa@kernel.org> <20240523144938.GA30227@lst.de> <Zk9kRYgwhu49c8YY@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zk9kRYgwhu49c8YY@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 23, 2024 at 11:44:05AM -0400, Mike Snitzer wrote:
> a difference on larger IOs being formed (given it is virtual
> scsi_debug devices).
> 
> In any case, we know I can reproduce with this scsi_debug-based mptest
> test and Marco has verified my fix resolves the issue on his FC
> multipath testbed.
> 
> But I've just floated a patch to elevate the fix to block core (based
> on Ming's suggestion):
> https://patchwork.kernel.org/project/dm-devel/patch/Zk9i7V2GRoHxBPRu@kernel.org/

I still think that is wrong.  Unfortunately I can't actually reproduce
the issue locally, but I think we want sd to set the user_max_sectors
and stack if you want to see the limits propagated, i.e. the combined
patch below.   In the longer run I need to get SCSI out of messing
with max_sectors directly, and the blk-mq stacking to stop looking
at it vs just the hardware limits (or just drop the check).

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a7fe8e90240a6e..7a672021daee6a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -611,6 +611,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	unsigned int top, bottom, alignment, ret = 0;
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
+	t->max_user_sectors = min_not_zero(t->max_user_sectors,
+			b->max_user_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
 	t->max_dev_sectors = min_not_zero(t->max_dev_sectors, b->max_dev_sectors);
 	t->max_write_zeroes_sectors = min(t->max_write_zeroes_sectors,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 332eb9dac22d91..f6c822c9cbd2d3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3700,8 +3700,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->first_scan ||
 	    q->limits.max_sectors > q->limits.max_dev_sectors ||
-	    q->limits.max_sectors > q->limits.max_hw_sectors)
+	    q->limits.max_sectors > q->limits.max_hw_sectors) {
 		q->limits.max_sectors = rw_max;
+		q->limits.max_user_sectors = rw_max;
+	}
 
 	sdkp->first_scan = 0;
 


