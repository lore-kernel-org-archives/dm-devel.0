Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B90C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 16:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652112393;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vMk4Q37nWHf7aPdN0JGFZj1puuOUendAIG3tZeH3rcY=;
	b=ha/TuKgQsBBV2h9C6RozAhIcxFnv1ENuDK/qQ2lOlk5eZ86h9xnRQbrcdug4hxHdLjQpLQ
	FDhp2+M1Laj+iAdrb+RPa9rNGItt+iFrdUKxsjj4fxVq4f5D3NM5xityJTKy+WdsLdW6sg
	5K2TYzU4SfvCrecAHuRrVMG1tBJtDBM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-5W4i737OM1qRX7vBJfqi1Q-1; Mon, 09 May 2022 12:06:30 -0400
X-MC-Unique: 5W4i737OM1qRX7vBJfqi1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 297B63C138C1;
	Mon,  9 May 2022 16:05:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C8B742166B2F;
	Mon,  9 May 2022 16:05:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 74C291947052;
	Mon,  9 May 2022 16:05:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7EEE81947051
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 16:05:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 71A7C40D1B9A; Mon,  9 May 2022 16:05:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DCD04010E2A
 for <dm-devel@redhat.com>; Mon,  9 May 2022 16:05:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54C6E100BAAB
 for <dm-devel@redhat.com>; Mon,  9 May 2022 16:05:39 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-gf7E2n_xMmqW8xsKUCkpNA-1; Mon, 09 May 2022 12:05:37 -0400
X-MC-Unique: gf7E2n_xMmqW8xsKUCkpNA-1
Received: by mail-qt1-f197.google.com with SMTP id
 x10-20020ac8700a000000b002c3ef8fc44cso12470497qtm.8
 for <dm-devel@redhat.com>; Mon, 09 May 2022 09:05:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=oeFX2E5ey4pZOwmjvDjcnRprgKudS5nUCFFZ6mjCjw4=;
 b=z3jX2bn+lSv/eGNPDnQA74zPpKFtE9AuQT0C+X/gBEHHiPH/BlwI0bc3XWfrQ+HTPc
 qYLgvE47z38qcpsSUJMOY/2UgG0PuWyqmjSkvMYVAMZjtDV9dT9oa6BOXWzjsDD0BxTv
 FzfzaLEpRALrUSoxDDVctvpMAwYikx1cQtoVxtIj4FvsB3yBmaW5l87uEVVS4HGCOGn0
 JkP6pITOWrWNkmL2h7EPCUBrA5akVZNgZXOs8ETGAlIsBr+K5kKx+lsMC7F+bx6dhUcq
 rw4tprypEtE0fgtVxGGYc/0rvi7aOFkFyo8Ohylcp5fyGx6KVR4SKCY/SPSLr5YCCPDZ
 kJIA==
X-Gm-Message-State: AOAM532QZi61yfLTSYo6kdaNsnksBuxVJBRftAEeRGf5htt2U7UQAkN+
 SJB3NKQAN1YuRaie8y2h7giHcCXIYdSjrI01UuQwhdvsasPa5Ix8Q2hqbnKaZB4I7sVT/dyPODk
 5CgIBgoN2KguN4Q==
X-Received: by 2002:ad4:5504:0:b0:456:35e0:1968 with SMTP id
 az4-20020ad45504000000b0045635e01968mr13785932qvb.126.1652112337394; 
 Mon, 09 May 2022 09:05:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzb2Vrd1ITeAGMSA0ykyWFDZQi/Pj9RpII0I7NdSUoTuyX2v0W9UQn5F/cD9u0YFL4E+wPA+Q==
X-Received: by 2002:ad4:5504:0:b0:456:35e0:1968 with SMTP id
 az4-20020ad45504000000b0045635e01968mr13785891qvb.126.1652112337165; 
 Mon, 09 May 2022 09:05:37 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 x14-20020ac8538e000000b002f3bbad9e37sm7663441qtp.91.2022.05.09.09.05.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 09 May 2022 09:05:36 -0700 (PDT)
Date: Mon, 9 May 2022 12:05:35 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <Ynk7z4FhE2zTrzZh@redhat.com>
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a@eucas1p1.samsung.com>
 <20220506081105.29134-12-p.raghav@samsung.com>
 <7f1bd653-6f75-7c0d-9a82-e8992b1476e4@opensource.wdc.com>
 <26ccce4c-da31-4e53-b71f-38adaea852a2@samsung.com>
MIME-Version: 1.0
In-Reply-To: <26ccce4c-da31-4e53-b71f-38adaea852a2@samsung.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v3 11/11] dm-zoned: ensure only power of 2
 zone sizes are allowed
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
Cc: jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 Chris Mason <clm@fb.com>, dm-devel@redhat.com, hch@lst.de,
 Alasdair Kergon <agk@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 bvanassche@acm.org, gost.dev@samsung.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, jonathan.derrick@linux.dev,
 Chaitanya Kulkarni <kch@nvidia.com>, snitzer@kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@fb.com>,
 dsterba@suse.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
 Johannes Thumshirn <jth@kernel.org>, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 09 2022 at  7:03P -0400,
Pankaj Raghav <p.raghav@samsung.com> wrote:

> >> ---
> >>  drivers/md/dm-zone.c | 12 ++++++++++++
> >>  1 file changed, 12 insertions(+)
> >>
> >> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> >> index 3e7b1fe15..27dc4ddf2 100644
> >> --- a/drivers/md/dm-zone.c
> >> +++ b/drivers/md/dm-zone.c
> >> @@ -231,6 +231,18 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
> >>  	struct request_queue *q = md->queue;
> >>  	unsigned int noio_flag;
> >>  	int ret;
> >> +	struct block_device *bdev = md->disk->part0;
> >> +	sector_t zone_sectors;
> >> +	char bname[BDEVNAME_SIZE];
> >> +
> >> +	zone_sectors = bdev_zone_sectors(bdev);
> >> +
> >> +	if (!is_power_of_2(zone_sectors)) {
> >> +		DMWARN("%s: %s only power of two zone size supported\n",
> >> +		       dm_device_name(md),
> >> +		       bdevname(bdev, bname));
> >> +		return 1;
> > 
> > return -EINVAL;
> > 
> > The error propagates to dm_table_set_restrictions() so a proper error code must
> > be returned.
> > 
> Good point. I will add this in the next rev.

Also, DMWARN already provides the trailing newline, so please remove
the above newline.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

