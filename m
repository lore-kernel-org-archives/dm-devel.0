Return-Path: <SRS0=AZSO=II=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCBBCC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 22:21:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5B74D64FC6
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 22:21:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B74D64FC6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615414908;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hy1QTTxOe0Vt/eZa0aSFyreTQLa1UU9Qdfpk15sINkg=;
	b=fOIrzl/Ev1FKVoXAGgcYiHLj2Xo0NrLZmzjHi0KHIEeBRoEV18ltSQ69mPijBKNYPgkTWt
	5wP9/koiv7KUnzD/+31Pg5yI/Tt6TEH2k4Nmg0xXgx3020oumRQzo/o8vTe2vWJa2U1Sv1
	iTJWwFcNV+wTw4uuzZz588BqRslT1sk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-KOODKrN7Pl-PBEwkfiwOwA-1; Wed, 10 Mar 2021 17:21:46 -0500
X-MC-Unique: KOODKrN7Pl-PBEwkfiwOwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EE361005D4A;
	Wed, 10 Mar 2021 22:21:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A9B165D6D7;
	Wed, 10 Mar 2021 22:21:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 133AA1809C86;
	Wed, 10 Mar 2021 22:21:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12AMLZCk021741 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Mar 2021 17:21:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 35CB95D746; Wed, 10 Mar 2021 22:21:35 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39ED05D6D7;
	Wed, 10 Mar 2021 22:21:30 +0000 (UTC)
Date: Wed, 10 Mar 2021 17:21:30 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20210310222130.GC23410@redhat.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
	<20210303115740.127001-5-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20210303115740.127001-5-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, caspar@linux.alibaba.com, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
	mpatocka@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 04/12] block: add poll_capable method to
 support bio-based IO polling
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 03 2021 at  6:57am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> This method can be used to check if bio-based device supports IO polling
> or not. For mq devices, checking for hw queue in polling mode is
> adequate, while the sanity check shall be implementation specific for
> bio-based devices. For example, dm device needs to check if all
> underlying devices are capable of IO polling.
> 
> Though bio-based device may have done the sanity check during the
> device initialization phase, cacheing the result of this sanity check
> (such as by cacheing in the queue_flags) may not work. Because for dm

s/cacheing/caching/

> devices, users could change the state of the underlying devices through
> '/sys/block/<dev>/io_poll', bypassing the dm device above. In this case,
> the cached result of the very beginning sanity check could be
> out-of-date. Thus the sanity check needs to be done every time 'io_poll'
> is to be modified.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Ideally QUEUE_FLAG_POLL would be authoritative.. but I appreciate the
problem you've described.  Though I do wonder if this should be solved
by bio-based's fops->poll() method clearing the request_queue's
QUEUE_FLAG_POLL if it finds an underlying device doesn't have
QUEUE_FLAG_POLL set.  Though making bio-based's fops->poll() always need
to validate the an underlying device does support polling is pretty
unfortunate.

Either way, queue_poll_store() will need to avoid blk-mq specific poll
checking for bio-based devices.

Mike

> ---
>  block/blk-sysfs.c      | 14 +++++++++++---
>  include/linux/blkdev.h |  1 +
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 0f4f0c8a7825..367c1d9a55c6 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -426,9 +426,17 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
>  	unsigned long poll_on;
>  	ssize_t ret;
>  
> -	if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
> -	    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
> -		return -EINVAL;
> +	if (queue_is_mq(q)) {
> +		if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
> +		    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
> +			return -EINVAL;
> +	} else {
> +		struct gendisk *disk = queue_to_disk(q);
> +
> +		if (!disk->fops->poll_capable ||
> +		    !disk->fops->poll_capable(disk))
> +			return -EINVAL;
> +	}
>  
>  	ret = queue_var_store(&poll_on, page, count);
>  	if (ret < 0)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 9dc83c30e7bc..7df40792c032 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1867,6 +1867,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
>  struct block_device_operations {
>  	blk_qc_t (*submit_bio) (struct bio *bio);
>  	int (*poll)(struct request_queue *q, blk_qc_t cookie);
> +	bool (*poll_capable)(struct gendisk *disk);
>  	int (*open) (struct block_device *, fmode_t);
>  	void (*release) (struct gendisk *, fmode_t);
>  	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
> -- 
> 2.27.0
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

