Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60631C43334
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 23:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655420763;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aBJc2XexCfdnIhiMvqV8H3J/ko9ILaUOFbI7GPIKeFs=;
	b=EKL7lWZj9Wd7tQuM9XKQMxILlJnPlU88M5aMaBhyEYYE3t+rc2udI8tI7YSRxYYtNNHiGJ
	ZBs4wcrfrTM+iyfFBIe618NZd1O5NjvFK9LB5g/q7uarro/vM9zxeTeyoxd8rXkFq8tNdF
	7rDcBMWACLTuDlxxQUX4IfWHsT+KdKs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-inWGZtGJPOSoh1fVMMD2qw-1; Thu, 16 Jun 2022 19:06:00 -0400
X-MC-Unique: inWGZtGJPOSoh1fVMMD2qw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C74785A584;
	Thu, 16 Jun 2022 23:05:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB16F18EAB;
	Thu, 16 Jun 2022 23:05:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8C7A91947063;
	Thu, 16 Jun 2022 23:05:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9904C194705D
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 23:05:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6F9CA2026985; Thu, 16 Jun 2022 23:05:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A6F52026D2D
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:05:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D95685A585
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:05:53 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-8aEv27ipPnCM97AcZ0tKGA-1; Thu, 16 Jun 2022 19:05:51 -0400
X-MC-Unique: 8aEv27ipPnCM97AcZ0tKGA-1
Received: by mail-qk1-f197.google.com with SMTP id
 bj2-20020a05620a190200b005084968bb24so3122188qkb.23
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 16:05:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=U0VJ3Cm/Y3rwtx3nV+0/84LUEhDyMiOPdSL1VuMXois=;
 b=KMZbQdQ8zCmq663ykPtKDtb3b6jfJbyoFaN+13e12844b+r2gLiEXanunl5PvTOqKh
 Gte39ZjJzjqRKgnvQh19rZaHLUaELQpbIpebbfPNDMMuB7dNIZk5wiF2g+RB3nrYzJcg
 GYjiYeUllsQiB69UMUgD10n+upCX3wKVJniLKcx4MyLoVI7U8ILEKS1KcYz+oYghAVq5
 +OIiIEFGtYceljg7jBkJWDWgW5P+h6s7gHgdakqVucG2SbmVydvfHRrDlFQ5z2oOzfGy
 wco4peGUYAr+wBFDw+PxPsszesowf4A1kR+vDwjskozt90jzdbYmAMaBCKFPoVg6r3S5
 hmqA==
X-Gm-Message-State: AJIora9sgLmUH2bmKUcddkYEOyd4BQ+SdzwtkJW8jYW+kEwFxLNX09Jo
 sn2a1x9GFGE9AznenSKUA6TI1fQmPsWKIiTQXceDPcMXnHm6JwJMmynb5Q1qxDvit1JYq/bp1aF
 E+8YXs/A49xQg4w==
X-Received: by 2002:a37:9b09:0:b0:6a6:b23e:8534 with SMTP id
 d9-20020a379b09000000b006a6b23e8534mr5262839qke.214.1655420750849; 
 Thu, 16 Jun 2022 16:05:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ukWikPEibv89UPW9YJ/Lk3dW7LBJk8ug+kPZTWxjEHoD1biXBjayw9IgNpzke1CCiJW2LwRw==
X-Received: by 2002:a37:9b09:0:b0:6a6:b23e:8534 with SMTP id
 d9-20020a379b09000000b006a6b23e8534mr5262793qke.214.1655420750250; 
 Thu, 16 Jun 2022 16:05:50 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 x5-20020a05620a258500b006a75a0ffc97sm3428935qko.3.2022.06.16.16.05.49
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 16:05:49 -0700 (PDT)
Date: Thu, 16 Jun 2022 19:05:48 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Yqu3TKf5MUwcnUty@redhat.com>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220614090934.570632-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 1/6] block: factor out a chunk_size_left
 helper
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 14 2022 at  5:09P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Factor out a helper from blk_max_size_offset so that it can be reused
> independently.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/blkdev.h | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 914c613d81da7..e66ad451274ec 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -933,6 +933,17 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
>  	return q->limits.max_sectors;
>  }
>  
> +/*
> + * Return how much of the chunk is left to be used for I/O at a given offset.
> + */
> +static inline unsigned int blk_chunk_sectors_left(sector_t offset,
> +		unsigned int chunk_sectors)
> +{
> +	if (unlikely(!is_power_of_2(chunk_sectors)))
> +		return chunk_sectors - sector_div(offset, chunk_sectors);
> +	return chunk_sectors - (offset & (chunk_sectors - 1));
> +}
> +
>  /*
>   * Return maximum size of a request at given offset. Only valid for
>   * file system requests.
> @@ -948,12 +959,8 @@ static inline unsigned int blk_max_size_offset(struct request_queue *q,
>  			return q->limits.max_sectors;
>  	}
>  
> -	if (likely(is_power_of_2(chunk_sectors)))
> -		chunk_sectors -= offset & (chunk_sectors - 1);
> -	else
> -		chunk_sectors -= sector_div(offset, chunk_sectors);
> -
> -	return min(q->limits.max_sectors, chunk_sectors);
> +	return min(q->limits.max_sectors,
> +			blk_chunk_sectors_left(offset, chunk_sectors));
>  }

While you're at it, any reason not to use queue_max_sectors() here?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

