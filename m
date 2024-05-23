Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF87171A1
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 15:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716478706; cv=none; b=Eubx+FX/GvQjf3vXZLiZUoe+MpdrzU00tLRZo6OQqmV85ZhlHkFbyO8LP7zzWO80je2bHWi+WhahCz2YIUi6SygXJJHmoD/jxLcmbjsiIwfn6QBBPB7RWUOTIRLp4HuS8BNWp9fsU+0LxbRT5JfTbp5tjCPYm/kYxhhwhk8/XrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716478706; c=relaxed/simple;
	bh=ymAAPlNf30KsYSMpVqiqQ+5vOurYotV9W5+WZR7XWgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCY8WckXI1/50cxnltyg+nqTzhE01n9P5Y+XNDDEPTLtdMLf8DUA0QoQDnF9ifjZ7enStdIzHsdOJQytlURC9LE8NnSbr3EJ/Elrtd1FQrRMeZUTDbcIEknuCPc65pwd9Agia10xinA2PlnXWPn4DKz+ERPAhunePdNDolZnx90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-792b8d989e8so152464685a.0
        for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 08:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716478703; x=1717083503;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pmbi3PuFdK7IOy43Ad1IdwYz7L7GXJpAycfVxdvzP/E=;
        b=kioqtZsuaf73o0t/6cB/JuMuqhmnoVKiqebHonlxlQYrV44bfqw7IRuuwdxH9RxwqN
         oRy/oL0U2oajvxui5cV64UhxvcUNwM2489M4v2oYoHAvYdgGBlokQDBYdeVzIrmOn9jX
         hZO21Ng12vUVq7P83B/gidgPSr44uFCrlSLj0vthgbUo4Gnr1dNKJUxEE+THdyRoZnMD
         wfHb/JCCmEScDBxshw7j+bnchVTLllbT2lMWBUAAuVHTjloZBqeJRQgcPDjsCjcD9WKd
         KHcVXuWqlsllnqfGPnSOS2amt7mC+pCUgr3xOuxTn7pIJCgJSlhqhHXvqypUebQtFATJ
         a4QA==
X-Gm-Message-State: AOJu0Yyup6FoJC98AXl6uuJVJ22wWZzc2mFOMt4nFSh/9OGENbcjX1lA
	n9AYNNu4EYEAmV0VSttmWjDBOd9FE6TsRrhsqmtQgaRs2uX1B3RIsTR0Th4aO1w=
X-Google-Smtp-Source: AGHT+IH9/Akf67TTZMgOeXVk19UNbl/6dksi9CYKF1hQNO7NkgsocfYydPhMPC9EujELFmcVsiB0aQ==
X-Received: by 2002:a05:620a:4623:b0:792:d3a2:3759 with SMTP id af79cd13be357-794a0963a3fmr498827085a.21.1716478703421;
        Thu, 23 May 2024 08:38:23 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7930c538f13sm725022385a.38.2024.05.23.08.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 08:38:22 -0700 (PDT)
Date: Thu, 23 May 2024 11:38:21 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
	axboe@kernel.dk
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>, linux-raid@vger.kernel.org
Subject: [PATCH for-6.10-rc1] block: fix blk_validate_limits() to properly
 handle stacked devices
Message-ID: <Zk9i7V2GRoHxBPRu@kernel.org>
References: <20240522025117.75568-1-snitzer@kernel.org>
 <20240522142458.GB7502@lst.de>
 <Zk4h-6f2M0XmraJV@kernel.org>
 <Zk6haNVa5JXxlOf1@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zk6haNVa5JXxlOf1@fedora>

On Thu, May 23, 2024 at 09:52:40AM +0800, Ming Lei wrote:
> On Wed, May 22, 2024 at 12:48:59PM -0400, Mike Snitzer wrote:
> > On Wed, May 22, 2024 at 04:24:58PM +0200, Christoph Hellwig wrote:
> > > On Tue, May 21, 2024 at 10:51:17PM -0400, Mike Snitzer wrote:
> > > > Otherwise, blk_validate_limits() will throw-away the max_sectors that
> > > > was stacked from underlying device(s). In doing so it can set a
> > > > max_sectors limit that violates underlying device limits.
> > > 
> > > Hmm, yes it sort of is "throwing the limit away", but it really
> > > recalculates it from max_hw_sectors, max_dev_sectors and user_max_sectors.
> > 
> > Yes, but it needs to do that recalculation at each level of a stacked
> > device.  And then we need to combine them via blk_stack_limits() -- as
> > is done with the various limits stacking loops in
> > drivers/md/dm-table.c:dm_calculate_queue_limits
> 
> This way looks one stacking specific requirement, just wondering why not
> put the logic into blk_validate_limits() by passing 'stacking' parameter?
> Then raid can benefit from it too.

Sure, we could elevate it to blk_validate_limits (and callers) but
adding a 'stacking' parameter is more intrusive on an API level.

Best to just update blk_set_stacking_limits() to set a new 'stacking'
flag in struct queue_limits, and update blk_stack_limits() to stack
that flag up.

I've verified this commit to work and have staged it in linux-next via
linux-dm.git's 'for-next', see:

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=cedc03d697ff255dd5b600146521434e2e921815

Jens (and obviously: Christoph, Ming and others), I'm happy to send
this to Linus tomorrow morning if you could please provide your
Reviewed-by or Acked-by.  I'd prefer to keep the intermediate DM fix
just to "show the work and testing".

Thanks,
Mike

From cedc03d697ff255dd5b600146521434e2e921815 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@kernel.org>
Date: Thu, 23 May 2024 11:19:29 -0400
Subject: [PATCH] block: fix blk_validate_limits() to properly handle stacked devices

For the benefit of other stacking block drivers, e.g. MD, elevate the
DM fix from commit 0ead1c8e8e48 ("dm: retain stacked max_sectors when
setting queue_limits") to block core.

Switches to using a bool bitfield in struct queue_limits (for old
member 'zoned' and new member 'stacking') to not grow that struct.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 block/blk-settings.c   | 30 ++++++++++++++++++++++++++++--
 drivers/md/dm-table.c  |  8 --------
 include/linux/blkdev.h |  3 ++-
 3 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index cdbaef159c4b..24c799072f6c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -35,6 +35,7 @@ EXPORT_SYMBOL_GPL(blk_queue_rq_timeout);
 void blk_set_stacking_limits(struct queue_limits *lim)
 {
 	memset(lim, 0, sizeof(*lim));
+	lim->stacking = true;
 	lim->logical_block_size = SECTOR_SIZE;
 	lim->physical_block_size = SECTOR_SIZE;
 	lim->io_min = SECTOR_SIZE;
@@ -103,7 +104,7 @@ static int blk_validate_zoned_limits(struct queue_limits *lim)
  */
 static int blk_validate_limits(struct queue_limits *lim)
 {
-	unsigned int max_hw_sectors;
+	unsigned int max_hw_sectors, stacked_max_hw_sectors = 0;
 
 	/*
 	 * Unless otherwise specified, default to 512 byte logical blocks and a
@@ -121,6 +122,23 @@ static int blk_validate_limits(struct queue_limits *lim)
 	if (lim->io_min < lim->physical_block_size)
 		lim->io_min = lim->physical_block_size;
 
+
+	/*
+	 * For stacked block devices, don't throw-away stacked max_sectors.
+	 */
+	if (lim->stacking && lim->max_hw_sectors) {
+		/*
+		 * lim->max_sectors and lim->max_hw_sectors were already
+		 * validated, relative underlying device(s) in this stacked
+		 * block device.
+		 */
+		stacked_max_hw_sectors = lim->max_hw_sectors;
+		/*
+		 * Impose stacked max_sectors as upper-bound for code below.
+		 */
+		lim->max_hw_sectors = lim->max_sectors;
+	}
+
 	/*
 	 * max_hw_sectors has a somewhat weird default for historical reason,
 	 * but driver really should set their own instead of relying on this
@@ -155,6 +173,11 @@ static int blk_validate_limits(struct queue_limits *lim)
 	lim->max_sectors = round_down(lim->max_sectors,
 			lim->logical_block_size >> SECTOR_SHIFT);
 
+	if (stacked_max_hw_sectors) {
+		/* Restore previously validated stacked max_hw_sectors */
+		lim->max_hw_sectors = max_hw_sectors;
+	}
+
 	/*
 	 * Random default for the maximum number of segments.  Driver should not
 	 * rely on this and set their own.
@@ -881,11 +904,14 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 						   b->max_secure_erase_sectors);
 	t->zone_write_granularity = max(t->zone_write_granularity,
 					b->zone_write_granularity);
-	t->zoned = max(t->zoned, b->zoned);
+	t->zoned |= b->zoned;
 	if (!t->zoned) {
 		t->zone_write_granularity = 0;
 		t->max_zone_append_sectors = 0;
 	}
+
+	t->stacking |= b->stacking;
+
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6463b4afeaa4..88114719fe18 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1961,7 +1961,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			      struct queue_limits *limits)
 {
 	bool wc = false, fua = false;
-	unsigned int max_hw_sectors;
 	int r;
 
 	if (dm_table_supports_nowait(t))
@@ -1982,16 +1981,9 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (!dm_table_supports_secure_erase(t))
 		limits->max_secure_erase_sectors = 0;
 
-	/* Don't allow queue_limits_set() to throw-away stacked max_sectors */
-	max_hw_sectors = limits->max_hw_sectors;
-	limits->max_hw_sectors = limits->max_sectors;
 	r = queue_limits_set(q, limits);
 	if (r)
 		return r;
-	/* Restore stacked max_hw_sectors */
-	mutex_lock(&q->limits_lock);
-	limits->max_hw_sectors = max_hw_sectors;
-	mutex_unlock(&q->limits_lock);
 
 	if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
 		wc = true;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c3e8f7cf96be..ad1b00e5cc3e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -307,7 +307,8 @@ struct queue_limits {
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
-	bool			zoned;
+	bool			zoned:1;
+	bool			stacking:1;
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
 
-- 
2.44.0

