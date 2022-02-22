Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52627C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 18:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645554482;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=s7Y5mbwUaRH95OQkesq/iwSFU39a97C1cd9KD5P9gzY=;
	b=IQls0jJHTdlNieGMH6nx9NzSB8h+bgA/B+q1I3cjBL4ljgKOvmNidC8+zkNCPousjY2dz+
	mV6QEDXb/VZoQwVZBzxGl6kDOQBR7zxbKdg5Tk66B3KOcANgEJPiH8VLYIzIVnOl3hqNNh
	JGtRRN0xAdHGP6hjB6rANTloHLajo7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-M_krnrlMMjSRok_j5oYFKA-1; Tue, 22 Feb 2022 13:27:58 -0500
X-MC-Unique: M_krnrlMMjSRok_j5oYFKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78571100C610;
	Tue, 22 Feb 2022 18:27:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ACB7D80FD8;
	Tue, 22 Feb 2022 18:27:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 72AB71809C98;
	Tue, 22 Feb 2022 18:27:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21MIRnGR024835 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 13:27:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8D4D25361F5; Tue, 22 Feb 2022 18:27:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 896455361F1
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 18:27:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70618381AA02
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 18:27:49 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
	[209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-610-hTQsS2XeMqaEwsT3i0E08g-1; Tue, 22 Feb 2022 13:27:46 -0500
X-MC-Unique: hTQsS2XeMqaEwsT3i0E08g-1
Received: by mail-qv1-f70.google.com with SMTP id
	kc30-20020a056214411e00b0042cb92fe8bbso586845qvb.8
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 10:27:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=8o8ifDV4Wsp9MNzW990jQZJGn8aGjNxzSGrWcKFlJGk=;
	b=LXJu2fCFY3LFQnEjsaWObT+6jjeYD3zyxqOgrKutk8uxV9O4NeW9sM1y3zKL9LHF6p
	qDK45JAmzyc7QpJTPa2LluOYAjTPWGHVAuMhu7kA/0uJ5mXKNs/JEb5nOhLSkVswbr6y
	TPrJjWiHkQYMaltxev6QJqRzUNyoPoM1u3/l8zFYVSjZSa4oZcpKi8sUXcYPWpM+k35d
	EdrbZuz5PziUS9YXMxbOUKb45lJVs0rTUSLHR2ByfIAtAVoVktY1yqQy75y8sX2cFGeW
	13pTeQnxrt0dCnA/D/U8n4tPHILHzlekGRlYaBis30czeRZUs05jpX1UxdcKTvwCa6s2
	uzfQ==
X-Gm-Message-State: AOAM530zSKF6rNunDN+EhD8EjT6BMp/ZZGpQszpHlFcm/bqnJudhjqKO
	Hk26YB7Qda+/mLjtWSJNmhqsSU8J8Hk+egYfjIeFUyRmeOHxk7JXOHjxa+4iLb5vsEez0kzIOaj
	mgzNydUhXSUrl+Q==
X-Received: by 2002:a37:f903:0:b0:648:ca74:b7dc with SMTP id
	l3-20020a37f903000000b00648ca74b7dcmr8244569qkj.666.1645554465582;
	Tue, 22 Feb 2022 10:27:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJwe2A38a6zFFVbDJ5FVEGv+t77RVoOuoYWwujx17APD/tpCaZ1mdM7EjHGn9xFuEOZjYRuA==
X-Received: by 2002:a37:f903:0:b0:648:ca74:b7dc with SMTP id
	l3-20020a37f903000000b00648ca74b7dcmr8244554qkj.666.1645554465307;
	Tue, 22 Feb 2022 10:27:45 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id h18sm169800qkl.90.2022.02.22.10.27.44
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 22 Feb 2022 10:27:44 -0800 (PST)
Date: Tue, 22 Feb 2022 13:27:43 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Zhang Yi <yi.zhang@huawei.com>
Message-ID: <YhUrH7UfBN3Uw5HP@redhat.com>
References: <20220209093751.2986716-1-yi.zhang@huawei.com>
MIME-Version: 1.0
In-Reply-To: <20220209093751.2986716-1-yi.zhang@huawei.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
	agk@redhat.com, yukuai3@huawei.com
Subject: Re: [dm-devel] dm: make sure dm_table is binded before queue request
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 09 2022 at  4:37P -0500,
Zhang Yi <yi.zhang@huawei.com> wrote:

> We found a NULL pointer dereference problem when using dm-mpath target.
> The problem is if we submit IO between loading and binding the table,
> we could neither get a valid dm_target nor a valid dm table when
> submitting request in dm_mq_queue_rq(). BIO based dm target could
> handle this case in dm_submit_bio(). This patch fix this by checking
> the mapping table before submitting request.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  drivers/md/dm-rq.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 579ab6183d4d..af2cf71519e9 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -499,8 +499,15 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  
>  	if (unlikely(!ti)) {
>  		int srcu_idx;
> -		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
> -
> +		struct dm_table *map;
> +
> +		map = dm_get_live_table(md, &srcu_idx);
> +		if (!map) {
> +			DMERR_LIMIT("%s: mapping table unavailable, erroring io",
> +				    dm_device_name(md));
> +			dm_put_live_table(md, srcu_idx);
> +			return BLK_STS_IOERR;
> +		}
>  		ti = dm_table_find_target(map, 0);
>  		dm_put_live_table(md, srcu_idx);
>  	}
> -- 
> 2.31.1
> 

I think both dm_submit_bio() and now dm_mq_queue_rq() should _not_
error the IO.  This is such a narrow race during device setup that it
best to requeue the IO.

I'll queue this for 5.18:

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 6948d5db9092..3dd040a56318 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -491,8 +491,13 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	if (unlikely(!ti)) {
 		int srcu_idx;
-		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
+		struct dm_table *map;
 
+		map = dm_get_live_table(md, &srcu_idx);
+		if (unlikely(!map)) {
+			dm_put_live_table(md, srcu_idx);
+			return BLK_STS_RESOURCE;
+		}
 		ti = dm_table_find_target(map, 0);
 		dm_put_live_table(md, srcu_idx);
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 082366d0ad49..c70be6e5ed55 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1533,15 +1533,10 @@ static void dm_submit_bio(struct bio *bio)
 	struct dm_table *map;
 
 	map = dm_get_live_table(md, &srcu_idx);
-	if (unlikely(!map)) {
-		DMERR_LIMIT("%s: mapping table unavailable, erroring io",
-			    dm_device_name(md));
-		bio_io_error(bio);
-		goto out;
-	}
 
-	/* If suspended, queue this IO for later */
-	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
+	/* If suspended, or map not yet available, queue this IO for later */
+	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) ||
+	    unlikely(!map)) {
 		if (bio->bi_opf & REQ_NOWAIT)
 			bio_wouldblock_error(bio);
 		else if (bio->bi_opf & REQ_RAHEAD)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

