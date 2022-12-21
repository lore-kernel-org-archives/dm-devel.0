Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1227CC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 21 Dec 2022 17:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671643326;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KPHvMKBrRvlK3k0gT/PgJHm6a/3T5eZ6xzT8RzKh3hM=;
	b=VzzQ8U8vwQB58w2bWCcDGs2s/uRF4r6h7MHNUsIp2KL/J6fUP615XpkbLYYqYTbbbcpSiK
	fNuRH1X+yfq9f+v1tZs57JBaHeDKHt2fc4vnIl7uIYUNVa45KCjkcTUkrFl4WLV4f+Pz9E
	FGnx+C4QXBaAQwaaTaaeS7Ayf1uJcs0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593--0N2ZNUQPdOUUKvx-dENXQ-1; Wed, 21 Dec 2022 12:22:03 -0500
X-MC-Unique: -0N2ZNUQPdOUUKvx-dENXQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6AD3811E6E;
	Wed, 21 Dec 2022 17:21:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7785339D7C;
	Wed, 21 Dec 2022 17:21:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 38FD919465B5;
	Wed, 21 Dec 2022 17:21:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 31A8019465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Dec 2022 17:17:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1147F2166B2C; Wed, 21 Dec 2022 17:17:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A4682166B2B
 for <dm-devel@redhat.com>; Wed, 21 Dec 2022 17:17:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE0E3101A52E
 for <dm-devel@redhat.com>; Wed, 21 Dec 2022 17:17:42 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-JmwWY2WBMTGcsHAa7YBrSA-1; Wed, 21 Dec 2022 12:17:39 -0500
X-MC-Unique: JmwWY2WBMTGcsHAa7YBrSA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 95704B81BA7;
 Wed, 21 Dec 2022 17:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BB4C433EF;
 Wed, 21 Dec 2022 17:09:03 +0000 (UTC)
Date: Wed, 21 Dec 2022 10:09:00 -0700
From: Keith Busch <kbusch@kernel.org>
To: Gulam Mohamed <gulam.mohamed@oracle.com>
Message-ID: <Y6M9rJbw3ZMvOeDr@kbusch-mbp.dhcp.thefacebook.com>
References: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
 <20221221040506.1174644-2-gulam.mohamed@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20221221040506.1174644-2-gulam.mohamed@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH for-6.2/block V3 2/2] block: Change the
 granularity of io ticks from ms to ns
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: nvdimm@lists.linux.dev, shminderjit.singh@oracle.com,
 linux-kernel@vger.kernel.org, song@kernel.org, dm-devel@redhat.com,
 ira.weiny@intel.com, agk@redhat.com, drbd-dev@lists.linbit.com,
 dave.jiang@intel.com, minchan@kernel.org, vishal.l.verma@intel.com,
 konrad.wilk@oracle.com, joe.jin@oracle.com, kent.overstreet@gmail.com,
 ngupta@vflare.org, kch@nvidia.com, senozhatsky@chromium.org,
 snitzer@kernel.org, colyli@suse.de, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, dan.j.williams@intel.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 rajesh.sivaramasubramaniom@oracle.com, philipp.reisner@linbit.com,
 junxiao.bi@oracle.com, christoph.boehmwalder@linbit.com,
 lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 21, 2022 at 04:05:06AM +0000, Gulam Mohamed wrote:
> +u64  blk_get_iostat_ticks(struct request_queue *q)
> +{
> +       return (blk_queue_precise_io_stat(q) ? ktime_get_ns() : jiffies);
> +}
> +EXPORT_SYMBOL_GPL(blk_get_iostat_ticks);
> +
>  void update_io_ticks(struct block_device *part, u64 now, bool end)
>  {
>  	u64 stamp;
> @@ -968,20 +980,26 @@ EXPORT_SYMBOL(bdev_start_io_acct);
>  u64 bio_start_io_acct(struct bio *bio)
>  {
>  	return bdev_start_io_acct(bio->bi_bdev, bio_sectors(bio),
> -				  bio_op(bio), jiffies);
> +				  bio_op(bio),
> +				  blk_get_iostat_ticks(bio->bi_bdev->bd_queue));
>  }
>  EXPORT_SYMBOL_GPL(bio_start_io_acct);
>  
>  void bdev_end_io_acct(struct block_device *bdev, enum req_op op,
>  		      u64 start_time)
>  {
> +	u64 now;
> +	u64 duration;
> +	struct request_queue *q = bdev_get_queue(bdev);
>  	const int sgrp = op_stat_group(op);
> -	u64 now = READ_ONCE(jiffies);
> -	u64 duration = (unsigned long)now -(unsigned long) start_time;
> +	now = blk_get_iostat_ticks(q);;

I don't think you can rely on the blk_queue_precise_io_stat() flag in
the completion side. The user can toggle this with data in flight, which
means the completion may use different tick units than the start. I
think you'll need to add a flag to the request in the start accounting
side to know which method to use for the completion.

> @@ -951,6 +951,7 @@ ssize_t part_stat_show(struct device *dev,
>  	struct request_queue *q = bdev_get_queue(bdev);
>  	struct disk_stats stat;
>  	unsigned int inflight;
> +	u64 stat_ioticks;
>  
>  	if (queue_is_mq(q))
>  		inflight = blk_mq_in_flight(q, bdev);
> @@ -959,10 +960,13 @@ ssize_t part_stat_show(struct device *dev,
>  
>  	if (inflight) {
>  		part_stat_lock();
> -		update_io_ticks(bdev, jiffies, true);
> +		update_io_ticks(bdev, blk_get_iostat_ticks(q), true);
>  		part_stat_unlock();
>  	}
>  	part_stat_read_all(bdev, &stat);
> +	stat_ioticks = (blk_queue_precise_io_stat(q) ?
> +				div_u64(stat.io_ticks, NSEC_PER_MSEC) :
> +				jiffies_to_msecs(stat.io_ticks));


With the user able to change the precision at will, I think these
io_ticks need to have a consistent unit size. Mixing jiffies and nsecs
is going to create garbage stats output. Could existing io_ticks using
jiffies be converted to jiffies_to_nsecs() so that you only have one
unit to consider?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

