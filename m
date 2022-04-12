Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982D1C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 17:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649783727;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GHRzliLo0IAGnV+uYUShYK2pbtUSpfeHKYGWcUZQ3ns=;
	b=aQAKOwViIByM7A0PArTBSwhbmnhUNSYHhipNFiSAviSvX7bPVZzdAFVwNjuiBG7iL05SKf
	NN+pe6DXuagrZeM1rlMhVZtp2e54o0eeOMiQVoKKH/fjf0jSrbLS1/T31eImTN762a5/u/
	kS+lmIOrmHFTEXibB+C6qukcMDoHXHQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-ZsVzhtPHO3WT8Q4lMHGlQg-1; Tue, 12 Apr 2022 13:15:24 -0400
X-MC-Unique: ZsVzhtPHO3WT8Q4lMHGlQg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92C3A801E67;
	Tue, 12 Apr 2022 17:15:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8E7A1457F07;
	Tue, 12 Apr 2022 17:15:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6E0241940373;
	Tue, 12 Apr 2022 17:15:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0E349194036A
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 17:15:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F32D21457F07; Tue, 12 Apr 2022 17:15:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF86D1457F12
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 17:15:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D48672999B30
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 17:15:18 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-maaBBoQHPHK4mlUQKl2OFQ-1; Tue, 12 Apr 2022 13:15:17 -0400
X-MC-Unique: maaBBoQHPHK4mlUQKl2OFQ-1
Received: by mail-qt1-f199.google.com with SMTP id
 bt12-20020ac8690c000000b002ee65af14d0so4417927qtb.22
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 10:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=RQSg+fcGgsIovBMSED5kWUrqeIxltHs9zhn3+V43E5w=;
 b=UQgEV1kMM0GrzoW1HtiwbXS5QpDfKH9EDTrZmAWn8C5QEvzTXF08aAnUCASR5qnYvw
 EalIpCcHYtq1bhMwFWDthKgAPbZDFVTFKdtqUUxb0Um3LyfVVow7F04sVRBn/wAZR5ID
 szhWz39CmWm66V+U8ub79db8E0y6vw9I7pWfAVLtHxbazcrUoRW5pYYXoj+d3OsoWN19
 tkl5GEuSgyNxihIjQiioZ4It2hxc4hRmTHCMEFQ1LI6vi3r8RCwj9fkU8x9n6VWdrSED
 XDbPdJ5sIVJu5llOElLj8qvFUt7LYLjIZfvApUl+2iJb+UOU5R2I64vlY4ZByC7gUQFa
 B5dw==
X-Gm-Message-State: AOAM532DMpLymhaXo90tdar/B6zHyO/tzkOkuRL2aQ3dcO6bhm16Xc6h
 tKHmQjEjo1CRIZv/1bUuneCkqSHfjFrA8lMx/JvJURgX6ZD/p6Z5vfwhcqVrtGhDUvGoLQAH2cu
 mcPt/1zZIbuks3g==
X-Received: by 2002:a05:6214:1d23:b0:444:4d2d:e377 with SMTP id
 f3-20020a0562141d2300b004444d2de377mr7107833qvd.116.1649783716797; 
 Tue, 12 Apr 2022 10:15:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbgL0jHo2bPMSrSx0VpwBt3GfTFFXXN6q9xlEpCtbK4KzVbZUTCV64ELttOITi2TjcTROl4w==
X-Received: by 2002:a05:6214:1d23:b0:444:4d2d:e377 with SMTP id
 f3-20020a0562141d2300b004444d2de377mr7107810qvd.116.1649783716520; 
 Tue, 12 Apr 2022 10:15:16 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 x5-20020a05620a01e500b0069c42d12378sm901453qkn.18.2022.04.12.10.15.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Apr 2022 10:15:15 -0700 (PDT)
Date: Tue, 12 Apr 2022 13:15:14 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YlWzoj+M1ykUubH+@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20220412085616.1409626-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 0/8] dm: io accounting & polling improvement
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 12 2022 at  4:56P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> Hello Guys,
> 
> The 1st patch adds bdev based io accounting interface.
> 
> The 2nd ~ 5th patches improves dm's io accounting & split, meantime
> fixes kernel panic on dm-zone.
> 
> The other patches improves io polling & dm io reference handling.
> 
> 
> Ming Lei (8):
>   block: replace disk based account with bdev's
>   dm: don't pass bio to __dm_start_io_acct and dm_end_io_acct
>   dm: pass 'dm_io' instance to dm_io_acct directly
>   dm: switch to bdev based io accounting interface
>   dm: always setup ->orig_bio in alloc_io
>   dm: don't grab target io reference in dm_zone_map_bio
>   dm: improve target io referencing
>   dm: put all polled io into one single list
> 
>  block/blk-core.c              |  15 +--
>  drivers/block/zram/zram_drv.c |   5 +-
>  drivers/md/dm-core.h          |  17 ++-
>  drivers/md/dm-zone.c          |  10 --
>  drivers/md/dm.c               | 190 +++++++++++++++++++---------------
>  include/linux/blkdev.h        |   7 +-
>  6 files changed, 131 insertions(+), 113 deletions(-)
> 
> -- 
> 2.31.1
> 

I'll review this closely but, a couple weeks ago, I queued up quite a
lot of conflicting changes for 5.19 here:

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

