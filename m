Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3006351016
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 08:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716452856; cv=none; b=qU2kJfH4p9YBwtjEEnTTQJqAveive3DUQfDUfTBCHApGkV1yJsr8peNK75lXPiKP+qCvJ1KuO71awmLyd4Kdyiz2iamNsRkJeDnmzIeKTKDdaHD4WqQQL0raf/elSp0QeQ+OVXR9ie8fuFvePwaM1EnwW1IJXvzEn81YjxenLE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716452856; c=relaxed/simple;
	bh=dWp1ZFgBfuwdvB2Exxa2wTZd945aQKnDEvIVXv138Vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J07lvAPyDqjbfU56L45MunNwZyqrVdFtGRXPVA6W2qMZNAwXOayu3Sr3A+zOP1gzaXOB8UnO+MdLVjtpordtffIN1jqMbCQaBo7jF3i5d+juzMMgp3AYljpLVf4moEAXUHEuqdEm4dCPWgzy3b0akvFkn4mTIa0Gzx6lFoGegZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E58C68BFE; Thu, 23 May 2024 10:27:31 +0200 (CEST)
Date: Thu, 23 May 2024 10:27:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>
Subject: Re: dm: retain stacked max_sectors when setting queue_limits
Message-ID: <20240523082731.GA3010@lst.de>
References: <20240522025117.75568-1-snitzer@kernel.org> <20240522142458.GB7502@lst.de> <Zk4h-6f2M0XmraJV@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zk4h-6f2M0XmraJV@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 22, 2024 at 12:48:59PM -0400, Mike Snitzer wrote:
> [   74.872485] blk_insert_cloned_request: over max size limit. (2048 > 1024)
> [   74.872505] device-mapper: multipath: 254:3: Failing path 8:16.
> [   74.872620] blk_insert_cloned_request: over max size limit. (2048 > 1024)
> [   74.872641] device-mapper: multipath: 254:3: Failing path 8:32.
> [   74.872712] blk_insert_cloned_request: over max size limit. (2048 > 1024)
> [   74.872732] device-mapper: multipath: 254:3: Failing path 8:48.
> [   74.872788] blk_insert_cloned_request: over max size limit. (2048 > 1024)
> [   74.872808] device-mapper: multipath: 254:3: Failing path 8:64.
> 
> Simply setting max_user_sectors won't help with stacked devices
> because blk_stack_limits() doesn't stack max_user_sectors.  It'll
> inform the underlying device's blk_validate_limits() calculation which
> will result in max_sectors having the desired value (which it already
> did, as I showed above).  But when stacking limits from underlying
> devices up to the higher-level dm-mpath queue_limits we still have
> information loss.

So while I can't reproduce it, I think the main issue is that
max_sectors really just is a voluntary limit, and enforcing that at
the lower device doesn't really make any sense.  So we could just
check blk_insert_cloned_request to check max_hw_sectors instead.
Or my below preferre variant to just drop the check, as the
max_sectors == 0 check indicates it's pretty sketchy to start with.


diff --git a/block/blk-mq.c b/block/blk-mq.c
index fc364a226e952f..61b108aa20044d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3041,29 +3041,9 @@ void blk_mq_submit_bio(struct bio *bio)
 blk_status_t blk_insert_cloned_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
-	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
 	unsigned int max_segments = blk_rq_get_max_segments(rq);
 	blk_status_t ret;
 
-	if (blk_rq_sectors(rq) > max_sectors) {
-		/*
-		 * SCSI device does not have a good way to return if
-		 * Write Same/Zero is actually supported. If a device rejects
-		 * a non-read/write command (discard, write same,etc.) the
-		 * low-level device driver will set the relevant queue limit to
-		 * 0 to prevent blk-lib from issuing more of the offending
-		 * operations. Commands queued prior to the queue limit being
-		 * reset need to be completed with BLK_STS_NOTSUPP to avoid I/O
-		 * errors being propagated to upper layers.
-		 */
-		if (max_sectors == 0)
-			return BLK_STS_NOTSUPP;
-
-		printk(KERN_ERR "%s: over max size limit. (%u > %u)\n",
-			__func__, blk_rq_sectors(rq), max_sectors);
-		return BLK_STS_IOERR;
-	}
-
 	/*
 	 * The queue settings related to segment counting may differ from the
 	 * original queue.

> 
> Mike
---end quoted text---
