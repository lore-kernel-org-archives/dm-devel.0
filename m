Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBF9C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 20:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649795351;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zo40sJt1m1XhbsbRPXE2D2V82VMhC4EGMFA9SoEB9kE=;
	b=MUDoqM7LnkjnUqGo/ZHH3moTDD/zyk+MzcxJiYN109oBNzv8U86hWBduLyKld9jg5XYhko
	NN4sNDP5E5xS6T7ft0O6/GFMpxM+vXjclENyQMGOSS/t9y7ju0rsua0WLKjXCMiFrKsTWO
	TRBA/foRr0zo4cmDir5a36TrhWjsk1U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-z3SDjUtsMuGaru3aj3rDCw-1; Tue, 12 Apr 2022 16:29:10 -0400
X-MC-Unique: z3SDjUtsMuGaru3aj3rDCw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69E0886B8A0;
	Tue, 12 Apr 2022 20:29:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5727554ACB1;
	Tue, 12 Apr 2022 20:29:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EFFD61949763;
	Tue, 12 Apr 2022 20:29:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BFB201947BBE
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 20:29:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6B25554ACB1; Tue, 12 Apr 2022 20:29:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 678F640147C
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 20:29:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F666800B28
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 20:29:05 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-9cdWZIpFP56FMdh7h_Patw-1; Tue, 12 Apr 2022 16:29:02 -0400
X-MC-Unique: 9cdWZIpFP56FMdh7h_Patw-1
Received: by mail-qv1-f71.google.com with SMTP id
 o15-20020a0562140e4f00b00443dee06cc4so46553qvc.10
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 13:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OJbqnKkqep0Vk4w4W/zomWoOZ4tiSsZA9fVw+SRqOiQ=;
 b=67IjiDvg8T+uEV0hdkVqUxxR1GMMAhIVPKiZjzUbYf0fPLRsPJyaudgRPmUm4ol91H
 mJrPytylpaekGIS2ZdYMaV3Tms4WwDcOfITmUB/JTNN5IvSASRIItud5qnU/FRDLKdau
 AQscCrE7Tcr8x6SPHzX30jZTLAr0JcNj3uj/1Ytt8E8ie7hH6MMUFl9xxTccghEXYBvp
 sSNeDbEqxH6rsVnGeiaCNAxqO7YFyYQJRU5wrq3t3Vkr/NDjXu923VE3qpLV0j4yTIn4
 fIYJG0iKGrFy7qbegqN0JYyWSHuhkG91P9StWsLliStb8O4QDLnpjgjyHROZez6Gufrk
 E1yA==
X-Gm-Message-State: AOAM5334k58JejgseWpBK1iJUBDRkSx7GmpKNJ7GCLM0mYsIvSacZqgN
 SFphUpH/ovxZWNpTaZxsHmV2Hf3FVNJKRhV4D39rcV2JWudq4WtP3hpUkF4VKyvIEOWkybYAuQ2
 3TP+BrY9lwVUeKg==
X-Received: by 2002:a37:947:0:b0:69a:d9e:ed4a with SMTP id
 68-20020a370947000000b0069a0d9eed4amr4443504qkj.457.1649795341600; 
 Tue, 12 Apr 2022 13:29:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSGcXhtVeIYxdDfTCCnoFxp3d0501Nzl6W6dCig7McULYIVbXGd7o4+Fr8zRE6JaX85sfaTg==
X-Received: by 2002:a37:947:0:b0:69a:d9e:ed4a with SMTP id
 68-20020a370947000000b0069a0d9eed4amr4443496qkj.457.1649795341336; 
 Tue, 12 Apr 2022 13:29:01 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 w22-20020ac87e96000000b002eb8e71950csm27179053qtj.71.2022.04.12.13.29.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Apr 2022 13:29:00 -0700 (PDT)
Date: Tue, 12 Apr 2022 16:28:59 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YlXhC1tHYYyCQxdI@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-4-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220412085616.1409626-4-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 3/8] dm: pass 'dm_io' instance to dm_io_acct
 directly
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
 dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 12 2022 at  4:56P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> All the other 4 parameters are retrieved from the 'dm_io' instance, so
> not necessary to pass all four to dm_io_acct().
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Yeah, commit 0ab30b4079e103 ("dm: eliminate copying of dm_io fields in
dm_io_dec_pending") could've gone further to do what you've done here
in this patch.

But it stopped short because of the additional "games" associated with
the late assignment of io->orig_bio that is in the dm-5.19 branch.

Mike


> ---
>  drivers/md/dm.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 62f7af815ef8..ed85cd1165a4 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -498,9 +498,12 @@ static bool bio_is_flush_with_data(struct bio *bio)
>  	return ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size);
>  }
>  
> -static void dm_io_acct(bool end, struct mapped_device *md, struct bio *bio,
> -		       unsigned long start_time, struct dm_stats_aux *stats_aux)
> +static void dm_io_acct(struct dm_io *io, bool end)
>  {
> +	struct dm_stats_aux *stats_aux = &io->stats_aux;
> +	unsigned long start_time = io->start_time;
> +	struct mapped_device *md = io->md;
> +	struct bio *bio = io->orig_bio;
>  	bool is_flush_with_data;
>  	unsigned int bi_size;
>  
> @@ -528,7 +531,7 @@ static void dm_io_acct(bool end, struct mapped_device *md, struct bio *bio,
>  
>  static void __dm_start_io_acct(struct dm_io *io)
>  {
> -	dm_io_acct(false, io->md, io->orig_bio, io->start_time, &io->stats_aux);
> +	dm_io_acct(io, false);
>  }
>  
>  static void dm_start_io_acct(struct dm_io *io, struct bio *clone)
> @@ -557,7 +560,7 @@ static void dm_start_io_acct(struct dm_io *io, struct bio *clone)
>  
>  static void dm_end_io_acct(struct dm_io *io)
>  {
> -	dm_io_acct(true, io->md, io->orig_bio, io->start_time, &io->stats_aux);
> +	dm_io_acct(io, true);
>  }
>  
>  static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
> -- 
> 2.31.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

