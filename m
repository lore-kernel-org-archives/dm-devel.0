Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6FBC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 23:21:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-PwkDLTXPMeCVOKlpFBGB6w-1; Thu, 16 Jun 2022 19:21:25 -0400
X-MC-Unique: PwkDLTXPMeCVOKlpFBGB6w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C04C4802D1F;
	Thu, 16 Jun 2022 23:21:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6573510725;
	Thu, 16 Jun 2022 23:21:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E55A41947063;
	Thu, 16 Jun 2022 23:21:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4F0BE194705D
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 23:21:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3F89A2026D2D; Thu, 16 Jun 2022 23:21:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AB722026985
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:21:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E803802C17
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:21:21 +0000 (UTC)
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com
 [209.85.219.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-9j_J1ETOOwiw1Ub0N-vkXg-1; Thu, 16 Jun 2022 19:21:19 -0400
X-MC-Unique: 9j_J1ETOOwiw1Ub0N-vkXg-1
Received: by mail-qv1-f45.google.com with SMTP id 89so4342304qvc.0
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 16:21:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=xGBUeFZ3kzOUfo8Z+CVdU374hif3wHQ3Al0jBzW3Lq0=;
 b=tocx+oXvwHMzW5dTKfeNkDnmX8CwwmRrOYZgn6ccfvaMToqNBiTXMNiMzzAV6Bs80Z
 1MAwFgXultiRrOLEec+L1JkmP1zvueAHOFMJ5atlzldnFnpx2BV4/5PyoevF6SdUcTC0
 BZEU5EoHkznw/3Yb+On4px3467jiQvTuiRA3L32/Zx3hh01Ok4PetsYG5PJBtVOlzVOh
 k/um28FXPbTCIsio9ky3NVfNKpoWs5ad8CXnmUbt4G3IDSnxUxRtULxZJ/kW262OpWGY
 9FD7Mh+TD/d70ILr0as3el10Xn7S1EpGfDdvfjLAWTPZXy4L0NbUqfZC/VHlTB8hD7pd
 XVyA==
X-Gm-Message-State: AJIora9mw5BMWsndUEacsxZdzY2Cb1gNpOHIUhw06EbZHJn809vzLypt
 KCvQOJ36LLQRBecm4xRY08KtfmU=
X-Google-Smtp-Source: AGRyM1sbd0C9yAQtprkahYGVnorsFh8MimX5KCOPjnIsKQgw0Zel5KKGSpsnl0iVAj0zuc2/Di2GBw==
X-Received: by 2002:ac8:5a50:0:b0:305:20c4:791d with SMTP id
 o16-20020ac85a50000000b0030520c4791dmr6258068qta.437.1655421678946; 
 Thu, 16 Jun 2022 16:21:18 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 q13-20020a37f70d000000b006a91da2fc8dsm2875780qkj.0.2022.06.16.16.21.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 16 Jun 2022 16:21:18 -0700 (PDT)
Date: Thu, 16 Jun 2022 19:21:17 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Yqu67Y4+n9KzKUf1@redhat.com>
References: <20220614090934.570632-1-hch@lst.de>
 <20220614090934.570632-3-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220614090934.570632-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 2/6] dm: open code blk_max_size_offset in
 max_io_len
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
 dm-devel@redhat.com
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

> max_io_len always passes an explicitly non-zero chunk_sectors into
> blk_max_size_offset.  That means much of blk_max_size_offset is not
> needed and can be open coded to simplify the code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index d8f16183bf27c..0514358a1f8e5 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1079,23 +1079,18 @@ static sector_t max_io_len(struct dm_target *ti, sector_t sector)
>  {
>  	sector_t target_offset = dm_target_offset(ti, sector);
>  	sector_t len = max_io_len_target_boundary(ti, target_offset);
> -	sector_t max_len;
>  
>  	/*
>  	 * Does the target need to split IO even further?
>  	 * - varied (per target) IO splitting is a tenet of DM; this
>  	 *   explains why stacked chunk_sectors based splitting via
> -	 *   blk_max_size_offset() isn't possible here. So pass in
> -	 *   ti->max_io_len to override stacked chunk_sectors.
> +	 *   blk_queue_split() isn't possible here.
>  	 */
> -	if (ti->max_io_len) {
> -		max_len = blk_max_size_offset(ti->table->md->queue,
> -					      target_offset, ti->max_io_len);
> -		if (len > max_len)
> -			len = max_len;
> -	}
> -
> -	return len;
> +	if (!ti->max_io_len)
> +		return len;
> +	return min_t(sector_t, len,
> +		min(queue_max_sectors(ti->table->md->queue),
> +		    blk_chunk_sectors_left(target_offset, ti->max_io_len)));
>  }
>  
>  int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
> -- 
> 2.30.2
> 

Not in love with the nested min() but don't have a better suggestion.

Reviewed-by: Mike Snitzer <snitzer@kernel.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

