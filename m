Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA563C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 14:35:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 323BC61130
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 14:35:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 323BC61130
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633530910;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MpN822gpeZnjeeLz/71rX15xYiO1RCjcoCwixnFDf7c=;
	b=he6CVNVelqW8n6s9iqdvzmjsKsIWF/wVJmcMfmypw50zYtdNLxw/Chsjx/b8hREVz4FC5V
	iuEpOLBMib/pVUWKb//2QoNpAnE5oszjRHUhhjj/YuVU3vaS4D8+L0YKujyW4QX3x8T60b
	/lgKkFME6Wft9QnMHBQylBUTSMpAsyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-PtaEiWsCN5CEXT_hP-Kfhw-1; Wed, 06 Oct 2021 10:35:08 -0400
X-MC-Unique: PtaEiWsCN5CEXT_hP-Kfhw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3E7F8010ED;
	Wed,  6 Oct 2021 14:35:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C7B705F4EE;
	Wed,  6 Oct 2021 14:35:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3EE06180BAD1;
	Wed,  6 Oct 2021 14:35:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196EGJS4020465 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 10:16:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5E84E568C2; Wed,  6 Oct 2021 14:16:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5989C568C4
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 14:16:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D86910AF629
	for <dm-devel@redhat.com>; Wed,  6 Oct 2021 14:16:01 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
	[209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-414-vMzH62DzO2yNw_8VOuGbaw-1; Wed, 06 Oct 2021 10:16:00 -0400
X-MC-Unique: vMzH62DzO2yNw_8VOuGbaw-1
Received: by mail-qt1-f198.google.com with SMTP id
	d9-20020ac86149000000b002a6d33107c5so2378960qtm.8
	for <dm-devel@redhat.com>; Wed, 06 Oct 2021 07:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=2nZfEe0fsULKAbP8/XTtBhClH7ZEGDsMBL/8yy76ADA=;
	b=WVZ3Ksql35Q4aKqyC2gYpYVpkq6IrsfgfGqKGEk9w1ryd2aiJAQpfHHNPofnGbH+zk
	ckmWWoB5URzAvu5xE6eHinc3W0GLk2OgovaJsKBgZh7ye8LpRPdDkOM3KqqRL3mi9cQ8
	rWmNCb27fl0MwJlVT6j/+unfmbgH/PZf4GxNN6xJSOHKhiLl0aJ34uc1fOzhvqItadrg
	jFHwa4J+i9+iEGwD81We5CnzAaFyNp+9UL+uXSvS8tWQ5FNLafabOGmJb1MkD9R4LdWN
	l9xb/0dNyakaOE3nIzHl/4Ga09WovR8aNU3GGgOaonivb0fkTkf5RiUrFk184gxwBO7a
	URZA==
X-Gm-Message-State: AOAM532njMPe+kdxGkFePpSM74AHnM9G4hwhxlzODVUNXimxY3ccDypP
	2yRDlpOLyEHBU+4RRoPlCXtCKLts1sgWV8mS5DdZqqCqxvkbo3niNzACOMnRyNc8Gz4NqGdzob1
	V03my7m1QPcfRdg==
X-Received: by 2002:a37:9d4b:: with SMTP id g72mr5780782qke.94.1633529759713; 
	Wed, 06 Oct 2021 07:15:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwx3Gcq9RJkCMN6MeQZnyJjBu3l27wScE1qv6enjV0vlzgOyVEpyXxD3+QjnWT6MPU3gWE0xA==
X-Received: by 2002:a37:9d4b:: with SMTP id g72mr5780757qke.94.1633529759404; 
	Wed, 06 Oct 2021 07:15:59 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	14sm14159889qty.93.2021.10.06.07.15.58
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 06 Oct 2021 07:15:59 -0700 (PDT)
Date: Wed, 6 Oct 2021 10:15:58 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YV2vnlKScVXYvQMo@redhat.com>
References: <20210923091131.1463013-1-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210923091131.1463013-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] dm-rq: don't queue request during suspend
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

On Thu, Sep 23 2021 at  5:11P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> DM uses blk-mq's quiesce/unquiesce to stop/start device mapper queue.
> 
> But blk-mq's unquiesce may come from outside events, such as elevator
> switch, updating nr_requests or others, and request may come during
> suspend, so simply ask for blk-mq to requeue it.
> 
> Fixes one kernel panic issue when running updating nr_requests and
> dm-mpath suspend/resume stress test.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/md/dm-rq.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 5b95eea517d1..a896dea9750e 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -490,6 +490,14 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	struct mapped_device *md = tio->md;
>  	struct dm_target *ti = md->immutable_target;
>  
> +	/*
> +	 * blk-mq's unquiesce may come from outside events, such as
> +	 * elevator switch, updating nr_requests or others, and request may
> +	 * come during suspend, so simply ask for blk-mq to requeue it.
> +	 */
> +	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)))
> +		return BLK_STS_RESOURCE;
> +
>  	if (unlikely(!ti)) {
>  		int srcu_idx;
>  		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
> -- 
> 2.31.1
> 

Hey Ming,

I've marked this for stable@ and queued this up.  BUT this test is
racey, could easily be that device gets suspended just after your
test.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

