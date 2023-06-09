Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88BEBC7EE45
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 20:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686340835;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=esgDy0v2QpWCWs93YOxWMnHVWSS8ZWcKbgZP/LiVYyc=;
	b=CFTL6bHSg2b3Y3PRtDGicUtT7YGqDXaDReEUjYFEOLKK6FwxgXCTN2lIHloCEtI3TXtpOb
	TPSaNl28sxfqukV/MTdOsZFVZhvg8CjtWS1IubLBQYF+Jk1XWJ2lEWndaW+RmWX0RKlIxu
	33TN0x9EqfcdsenpAgoUogfHlkT+uEg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-CZYU93_LO9CM39Gwh3etYw-1; Fri, 09 Jun 2023 16:00:34 -0400
X-MC-Unique: CZYU93_LO9CM39Gwh3etYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95F171C03D80;
	Fri,  9 Jun 2023 20:00:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1128D10DF8;
	Fri,  9 Jun 2023 20:00:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C440C19451C1;
	Fri,  9 Jun 2023 20:00:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E8B4194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 20:00:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7F669140E959; Fri,  9 Jun 2023 20:00:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 77448140E958
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 20:00:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5857D185A794
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 20:00:28 +0000 (UTC)
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com
 [209.85.222.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-9y6pdRrSMnGHXtkj-_Ml7g-1; Fri, 09 Jun 2023 16:00:26 -0400
X-MC-Unique: 9y6pdRrSMnGHXtkj-_Ml7g-1
Received: by mail-qk1-f173.google.com with SMTP id
 af79cd13be357-75efda265f8so52899185a.0
 for <dm-devel@redhat.com>; Fri, 09 Jun 2023 13:00:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686340826; x=1688932826;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=XFxNC6AwIefC8h+OVa9YMEjCXThkDxxKP8p9zX4LNFY=;
 b=kHUOibu5eW+QcjVGUzNwRWeqpF5bW4ChCWHpB776zGnS3rAJFp/RcVmCiwgdekmpXW
 /8wPPnQnYgUt8QrFeyhYzFq3OnEdOCpkjJpyMWbVwgSeO9vXFG1Rc/Dj3nhv4Omz0wGC
 zVY3OUqXcDnX/2xJZ3l53AGttTYo+BsIMNrfBMNIZV5RZuE18/Aofz7vikByYggMKOJG
 VBBE2dODYFLnlW+oY+ZVXvmpOFLd/p7EDNHsITXatnxvQJYTq8ipCHQ32lRPrIQoUbcP
 jJfCMThZpvtEy33p0pLcvtcjMqanQfE6sDs97bcd5YbrH3K8kfxZ7rXASWBjPNcB3/6K
 nYvg==
X-Gm-Message-State: AC+VfDzm7IdEzQUibEItv8y9pe/E0NqwYTXiWCrnA3kJ1cFPxA02eJpZ
 2pTj30BDGAhxK3rM2ODXLZediG0=
X-Google-Smtp-Source: ACHHUZ6f5D0na1vDQSbLNkOIR7VVTt7ADDPvJzshNMQToGx2m/jPA4IIyjKZFD+hGnfTs+abIWzkWA==
X-Received: by 2002:ac8:7e88:0:b0:3f8:6c15:c3a5 with SMTP id
 w8-20020ac87e88000000b003f86c15c3a5mr3039832qtj.33.1686340826214; 
 Fri, 09 Jun 2023 13:00:26 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 d3-20020ac85343000000b003f740336bb9sm1418338qto.9.2023.06.09.13.00.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Jun 2023 13:00:25 -0700 (PDT)
Date: Fri, 9 Jun 2023 16:00:24 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZIOE2ASeUAXxzpRO@redhat.com>
References: <20230518223326.18744-1-sarthakkukreti@chromium.org>
 <20230518223326.18744-3-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230518223326.18744-3-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v7 2/5] block: Introduce provisioning
 primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, May 18 2023 at  6:33P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> Introduce block request REQ_OP_PROVISION. The intent of this request
> is to request underlying storage to preallocate disk space for the given
> block range. Block devices that support this capability will export
> a provision limit within their request queues.
> 
> This patch also adds the capability to call fallocate() in mode 0
> on block devices, which will send REQ_OP_PROVISION to the block
> device for the specified range,
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
...
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 896b4654ab00..d303e6614c36 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -59,6 +59,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->zoned = BLK_ZONED_NONE;
>  	lim->zone_write_granularity = 0;
>  	lim->dma_alignment = 511;
> +	lim->max_provision_sectors = 0;
>  }
>  
>  /**
> @@ -82,6 +83,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>  	lim->max_dev_sectors = UINT_MAX;
>  	lim->max_write_zeroes_sectors = UINT_MAX;
>  	lim->max_zone_append_sectors = UINT_MAX;
> +	lim->max_provision_sectors = UINT_MAX;
>  }
>  EXPORT_SYMBOL(blk_set_stacking_limits);
>  
> @@ -578,6 +594,9 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  	t->max_segment_size = min_not_zero(t->max_segment_size,
>  					   b->max_segment_size);
>  
> +	t->max_provision_sectors = min_not_zero(t->max_provision_sectors,
> +						b->max_provision_sectors);
> +

This needs to use min() since max_provision_sectors also serves to
indicate if the device supports REQ_OP_PROVISION.  Otherwise, if I set
max_provision_sectors to 0 on a dm thin-pool the blk_stack_limits()
will ignore my having set it to 0 (to disable) and it'll remain as
UINT_MAX (thanks to blk_set_default_limits).

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

