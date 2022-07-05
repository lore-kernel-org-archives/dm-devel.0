Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7574C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988860;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xBY7cVPs8uUSshdGhdgemlEkWEYVM9Sr5K6EwYjFORU=;
	b=eTEKIGUA5edag6KICNfAvSb9si3pPyf73nowd2F7DVpUzdvYcEjHFLn3Bi65n0qy+lQCp8
	RbRcNDoJD0HtkvBRt3iID+DkWToCk1xgXRMcMqdQrkiL0phZV8CdS/UBjpcq8kBcTbMpE4
	i2jgLOepcctXMki46Xpr5ct3RXbx55U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-wN3i5xtdP-SzZLZ6lNUI9g-1; Mon, 04 Jul 2022 22:40:57 -0400
X-MC-Unique: wN3i5xtdP-SzZLZ6lNUI9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C230185A79C;
	Tue,  5 Jul 2022 02:40:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8834740CF8EB;
	Tue,  5 Jul 2022 02:40:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3FE2B194704A;
	Tue,  5 Jul 2022 02:40:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A847A1947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:40:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D2C8400DFDE; Tue,  5 Jul 2022 02:40:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 38F6740B40C6
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:40:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20313811E7A
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:40:54 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-XhgUOfnENG--lLm1_mIEAw-1; Mon, 04 Jul 2022 22:40:52 -0400
X-MC-Unique: XhgUOfnENG--lLm1_mIEAw-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="309129911"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:40:51 +0800
IronPort-SDR: dgDe3LDSg9C7Ig38Iooh+g5xyQ6C8dm9BAQeYlHEXZd+9M+OPjRwFKZZZ5P/J7XhWrfAtb5LTC
 a6xPX5KHMjCO0jKeQsZH+PpVujr2rptuK6YSUaMpwEG7JYCqjWHtPOsAzS4qP2/i1yLxJyhXW9
 8yzlKPG24l3vTic9mRqvOn4EnJlo7TZk09yAPWnwtMv1DnhhevLlkuqwjgMycY8GmMfiMinWW4
 Bcp8OlfqVU6llqMLbJHo8dM94MhXkPJ98u/2F4QVCvwABSDMsO4GK8ebSxyjJaFQMRTQeZA7Bi
 FT8P3VtRv62jgh6/EBjsNeG4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 18:58:10 -0700
IronPort-SDR: T8ZxYbXpwbEdrDzRZ8NCuk5cxb6zgL2D1lxY4s6qRohxpbhW9InoMdA0FCVRH+Wwy7jjhLKoyT
 AGCeCc1mhbDZtyriew9sDdHVHRCe09DaPbSNXfxBNN7QlYmVSwArd01wqsn6e+zOZtCZw5vbH6
 Sy20szeVPqyVj/f50mhI8w2UQRIOrbaoaaUw/h9a7Zjx60/5LSLfCD//sPUpVM/clo7Xcqutu1
 VfJH2ApvJtTkN90MMR3J9rD08y855v6LJxsgMDhtLRbnt8lC/9hAlbQKejMIge576jPDoXYKge
 yaI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:40:51 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRkB6FqXz1Rwnm
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:40:50 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id WtZ3An1aZm4v for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:40:50 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRk93N6wz1RtVk;
 Mon,  4 Jul 2022 19:40:49 -0700 (PDT)
Message-ID: <71dae34b-b5fb-e3d2-941a-0dd0836e542d@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:40:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-8-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-8-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 07/17] block: simplify blk_check_zone_append
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:44, Christoph Hellwig wrote:
> Use the bdev based helpers instead of open coding them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index bc16e9bae2dc4..b530ce7b370c4 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -565,7 +565,6 @@ static int blk_partition_remap(struct bio *bio)
>  static inline blk_status_t blk_check_zone_append(struct request_queue *q,
>  						 struct bio *bio)
>  {
> -	sector_t pos = bio->bi_iter.bi_sector;
>  	int nr_sectors = bio_sectors(bio);
>  
>  	/* Only applicable to zoned block devices */
> @@ -573,8 +572,8 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
>  		return BLK_STS_NOTSUPP;
>  
>  	/* The bio sector must point to the start of a sequential zone */
> -	if (pos & (blk_queue_zone_sectors(q) - 1) ||
> -	    !blk_queue_zone_is_seq(q, pos))
> +	if (bio->bi_iter.bi_sector & (bdev_zone_sectors(bio->bi_bdev) - 1) ||
> +	    !bio_zone_is_seq(bio))
>  		return BLK_STS_IOERR;
>  
>  	/*

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

