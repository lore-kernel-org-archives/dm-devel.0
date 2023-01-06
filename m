Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08230C3DA7A
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 11:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673002916;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Aj/0ZfwYiuMxne3O7zvG10f7T4JK5DAYKNqf1jiaxPc=;
	b=L2S4avoA0t4CaTQfuOkgVMbR3LS/UGH+XTes3Cs1UP6/n3TCBAwcgri/fMtucHXL6zCq6F
	z/eRSTsAG824HNgz3KabqOrlSE/DgUWZKQqmHAea5n5AqG7GfaKGimlfEuSWMgUCTVK8JZ
	Sao24HtIHyowbvN2P9tPL72U4y0SEHU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-Weg4yufTP66FB2OcZOfEIQ-1; Fri, 06 Jan 2023 06:01:53 -0500
X-MC-Unique: Weg4yufTP66FB2OcZOfEIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 794A03C0D190;
	Fri,  6 Jan 2023 11:01:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 113E140C945A;
	Fri,  6 Jan 2023 11:01:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F210219465B9;
	Fri,  6 Jan 2023 11:01:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7F7D1946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 11:01:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B83B640C2004; Fri,  6 Jan 2023 11:01:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0A5A40C2064
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 11:01:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95581181E3EF
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 11:01:48 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-3pLmI8ZLPbupP36TSaH1dQ-1; Fri, 06 Jan 2023 06:01:46 -0500
X-MC-Unique: 3pLmI8ZLPbupP36TSaH1dQ-1
X-IronPort-AV: E=Sophos;i="5.96,305,1665417600"; d="scan'208";a="225224633"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 06 Jan 2023 19:00:43 +0800
IronPort-SDR: QLnf9Jz/3lmGzTU4gsruCrgV7Gs1s8+BxPHfc46u7rRmnB1JYYqNM6zR7VHkcPOfYyYK103jb7
 DlInTJCUEOb0HYkmOdrRNwZ98TNTgAtRlmQYU8RaMV3TeuOx4gaiRVtH1k2kGwMUusyE10sgux
 ExyiRRhjZK9V0Yc8Cq6xSpqrqTKb2C+I+tnI9uUDG1uXzQu/LDPA8r7/0H9az1TIvTMPpUq24a
 bStiifrOumx3ljfCLlWQJKbqppp7USlbc7tsFuDPVjz8NvelrCl5dGuaFpxyq5pWGGntvQa0wY
 7xE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jan 2023 02:18:38 -0800
IronPort-SDR: mloC2vrOkA5EXaz0vpd2S9b+DkoIwTQGY215cL/Hm0TeaIJ6l0WCEKj/KOBO54HEbtasrv11xA
 LdDv8np2wjkBrYtrO7RUAkOVOHzq5tKAIcXqwCgcy1p+0IPcnfrRoklJlq9DwAl9FGCyNWrJ4V
 mWvTEYYxKb/3sVlVujfxe2yNbPfmLJozIKXWQaKUrBVsi7/DKv0oBEKiAFpvdET7r1af8EGdzY
 jQR8lUkIrHMaBoQebdM66yhP/4cVRrMyjVXB4TMQkHQCAgg0qnFTp2+JLv/mx+fohVHNI9SQ1C
 zws=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jan 2023 03:00:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NpL3b1FSQz1RvTr
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 03:00:43 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id SkII0r5lXtF8 for <dm-devel@redhat.com>;
 Fri,  6 Jan 2023 03:00:41 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NpL3X00tLz1RvLy;
 Fri,  6 Jan 2023 03:00:39 -0800 (PST)
Message-ID: <32aaa034-dc39-75dd-f4ec-e0e5ef9dd29c@opensource.wdc.com>
Date: Fri, 6 Jan 2023 20:00:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083320eucas1p1f8de0c6ecf351738e8f0ee5f3390d94f@eucas1p1.samsung.com>
 <20230106083317.93938-3-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230106083317.93938-3-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 2/7] block: add a new helper
 bdev_{is_zone_start, offset_from_zone_start}
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
Cc: bvanassche@acm.org, gost.dev@samsung.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/6/23 17:33, Pankaj Raghav wrote:
> Instead of open coding to check for zone start, add a helper to improve
> readability and store the logic in one place.
> 
> bdev_offset_from_zone_start() will be used later in the series.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  block/blk-core.c       |  2 +-
>  block/blk-zoned.c      |  4 ++--
>  include/linux/blkdev.h | 18 ++++++++++++++++++
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9321767470dc..0405b3144e7a 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -573,7 +573,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
>  		return BLK_STS_NOTSUPP;
>  
>  	/* The bio sector must point to the start of a sequential zone */
> -	if (bio->bi_iter.bi_sector & (bdev_zone_sectors(bio->bi_bdev) - 1) ||
> +	if (!bdev_is_zone_start(bio->bi_bdev, bio->bi_iter.bi_sector) ||
>  	    !bio_zone_is_seq(bio))
>  		return BLK_STS_IOERR;
>  
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index db829401d8d0..614b575be899 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -277,10 +277,10 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_op op,
>  		return -EINVAL;
>  
>  	/* Check alignment (handle eventual smaller last zone) */
> -	if (sector & (zone_sectors - 1))
> +	if (!bdev_is_zone_start(bdev, sector))
>  		return -EINVAL;
>  
> -	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
> +	if (!bdev_is_zone_start(bdev, nr_sectors) && end_sector != capacity)
>  		return -EINVAL;
>  
>  	/*
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 0e40b014c40b..04b7cbfd7a2a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -715,6 +715,7 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>  {
>  	return 0;
>  }
> +

whiteline change

>  static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
>  {
>  	return 0;
> @@ -1304,6 +1305,23 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
>  	return q->limits.chunk_sectors;
>  }
>  
> +static inline sector_t bdev_offset_from_zone_start(struct block_device *bdev,
> +						   sector_t sec)
> +{
> +	if (!bdev_is_zoned(bdev))

this helper should never be called outside of code supporting zones. So
why this check ?

> +		return 0;
> +
> +	return sec & (bdev_zone_sectors(bdev) - 1);
> +}
> +
> +static inline bool bdev_is_zone_start(struct block_device *bdev, sector_t sec)
> +{
> +	if (!bdev_is_zoned(bdev))
> +		return false;

Same here.

> +
> +	return bdev_offset_from_zone_start(bdev, sec) == 0;
> +}
> +
>  static inline int queue_dma_alignment(const struct request_queue *q)
>  {
>  	return q ? q->limits.dma_alignment : 511;

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

