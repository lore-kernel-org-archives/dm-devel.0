Return-Path: <SRS0=1REc=D5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4EBC388F2
	for <dm-devel@archiver.kernel.org>; Thu, 22 Oct 2020 03:15:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0F7792063A
	for <dm-devel@archiver.kernel.org>; Thu, 22 Oct 2020 03:15:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0EfEgTY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F7792063A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603336509;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eOaViWLUkTV4LnzF81LRa6a47IU1/awCOrU92Ivedjs=;
	b=C0EfEgTY3NYplpY04HwkJSd4LdG4SlP3nZbr7HJeUz4zbfY6U3/zKRZFPIpyQjt75wXtaK
	ui2JYtHUQMo6pa1ljUKiTo4vCV1SQ00I7xwQ+Q7ZwWxgaY5CGUOZ1dGEJOza0pGNBqH7uh
	4Ovm3OfVxZnWvAg5Z4R/L7OshjUUOD8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-JmyColfbMAmALLZqBBmLKA-1; Wed, 21 Oct 2020 23:15:07 -0400
X-MC-Unique: JmyColfbMAmALLZqBBmLKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D38721008542;
	Thu, 22 Oct 2020 03:15:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 90D9D55781;
	Thu, 22 Oct 2020 03:15:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 877001832FC2;
	Thu, 22 Oct 2020 03:14:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09M3EtDM013945 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Oct 2020 23:14:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 507A719D7C; Thu, 22 Oct 2020 03:14:55 +0000 (UTC)
Received: from T590 (ovpn-12-46.pek2.redhat.com [10.72.12.46])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A019A19728;
	Thu, 22 Oct 2020 03:14:38 +0000 (UTC)
Date: Thu, 22 Oct 2020 11:14:34 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20201022031434.GA1643586@T590>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
	<20201020065420.124885-4-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20201020065420.124885-4-jefflexu@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, snitzer@redhat.com, xiaoguang.wang@linux.alibaba.com,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, haoxu@linux.alibaba.com
Subject: Re: [dm-devel] [RFC 3/3] dm: add support for IO polling
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Tue, Oct 20, 2020 at 02:54:20PM +0800, Jeffle Xu wrote:
> Design of cookie is initially constrained as a per-bio concept. It
> dosn't work well when bio-split needed, and it is really an issue when
> adding support of iopoll for dm devices.
> 
> The current algorithm implementation is simple. The returned cookie of
> dm device is actually not used since it is just the cookie of one of
> the cloned bios. Polling of dm device is actually polling on all
> hardware queues (in poll mode) of all underlying target devices.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  drivers/md/dm-core.h  |  1 +
>  drivers/md/dm-table.c | 30 ++++++++++++++++++++++++++++++
>  drivers/md/dm.c       | 39 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 70 insertions(+)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index d522093cb39d..f18e066beffe 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -187,4 +187,5 @@ extern atomic_t dm_global_event_nr;
>  extern wait_queue_head_t dm_global_eventq;
>  void dm_issue_global_event(void);
>  
> +int dm_io_poll(struct request_queue *q, blk_qc_t cookie);
>  #endif
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index ce543b761be7..634b79842519 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1809,6 +1809,31 @@ static bool dm_table_requires_stable_pages(struct dm_table *t)
>  	return false;
>  }
>  
> +static int device_not_support_poll(struct dm_target *ti, struct dm_dev *dev,
> +					   sector_t start, sector_t len, void *data)
> +{
> +	struct request_queue *q = bdev_get_queue(dev->bdev);
> +
> +	return q && !(q->queue_flags & QUEUE_FLAG_POLL);
> +}
> +
> +bool dm_table_supports_poll(struct dm_table *t)
> +{
> +	struct dm_target *ti;
> +	unsigned int i;
> +
> +	/* Ensure that all targets support DAX. */
> +	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> +		ti = dm_table_get_target(t, i);
> +
> +		if (!ti->type->iterate_devices ||
> +		    ti->type->iterate_devices(ti, device_not_support_poll, NULL))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  			       struct queue_limits *limits)
>  {
> @@ -1901,6 +1926,11 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  #endif
>  
>  	blk_queue_update_readahead(q);
> +
> +	if (dm_table_supports_poll(t)) {
> +		q->poll_fn = dm_io_poll;
> +		blk_queue_flag_set(QUEUE_FLAG_POLL, q);
> +	}
>  }
>  
>  unsigned int dm_table_get_num_targets(struct dm_table *t)
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index c18fc2548518..4eceaf87ffd4 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1666,6 +1666,45 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
>  	return ret;
>  }
>  
> +static int dm_poll_one_dev(struct request_queue *q, blk_qc_t cookie)
> +{
> +	/* Iterate polling on all polling queues for mq device */
> +	if (queue_is_mq(q)) {
> +		struct blk_mq_hw_ctx *hctx;
> +		int i, ret = 0;
> +
> +		if (!percpu_ref_tryget(&q->q_usage_counter))
> +			return 0;
> +
> +		queue_for_each_poll_hw_ctx(q, hctx, i) {
> +			ret += q->mq_ops->poll(hctx);
> +		}

IMO, this way may not be accepted from performance viewpoint, .poll()
often requires per-hw-queue lock. So in case of > 1 io thread,
contention/cache ping-pong on hw queue resource can be very serious.

I guess you may have to find one way to pass correct cookie to ->poll().


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

