Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B42C4C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656989764;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gis+EpGH0+4mVNmsyCZvKdg5j88eIUc1HDYx1ATZ0lk=;
	b=gfzqzzypYixLxbzP0RQUzY9bqwF/vYIYlPuFwFwBK0vHuTEHgS6Gda32FcCUvVg6JJXmQO
	/70RDlJBAiAGQjMP7cqSof/ROMjRkob7UvdKEln/sHVvoF/yP4H6hVG4z7A6HFjICoIlGY
	CQkAENoHjQT9nRkmf+ioNeuvePiAA4M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-5jhWu0hxOGG6I6mPjFNbYA-1; Mon, 04 Jul 2022 22:56:01 -0400
X-MC-Unique: 5jhWu0hxOGG6I6mPjFNbYA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A4818001EA;
	Tue,  5 Jul 2022 02:56:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F055F4010D2A;
	Tue,  5 Jul 2022 02:55:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B721194704A;
	Tue,  5 Jul 2022 02:55:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2D7581947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:55:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0FBCA41617E; Tue,  5 Jul 2022 02:55:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B7D9401E54
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:55:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E88613802BAF
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:55:57 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-lP4p-DHcOyC8w4_tKJxY3A-1; Mon, 04 Jul 2022 22:55:56 -0400
X-MC-Unique: lP4p-DHcOyC8w4_tKJxY3A-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="205521015"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:55:55 +0800
IronPort-SDR: gcuf0ip/6VuzHmwE5tKiZP1/wAJWN0m361Mlt2fa4l2aAidd7FrNmAGsOx3c/e5VbM9bQ2bZ/V
 Mui6QnOqY+HxYW43rSFkgGpydj1izJFOvWyPr4zv2HyHaeuHL5RiMI4LF3EMyQWGr6t+mKIWfW
 5ltQ0xU1hQ8KZtw0MjxBdBxWjqfNvueSPqvXU+gc5Orav50R4yVUe5261/oQDSvfXRzGDAjOrn
 L1v9JSEy4DRWvFl0pKdP0UExtUHMfPXNfFs1MZDdCxuZ5PXLkOxvqQmYM8St6rAsSYAOaYK7Tu
 uFVywKfbQRqqxHM+Wjp4LDNN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:13:14 -0700
IronPort-SDR: X+A6gK4BXKm8nTwxvxRUvLJMAGacPqkgG2FELWa0N4MLuoK2zOj84g98J1YZWFNZFi+OgMq53v
 +6T6lSaBj30PmKhO3Wz4P8QVrgPvP7tA0bsXsl+UcfNAILIH/wKd1y8QgJQ+SvaD8tXEE9U8Yi
 tUqJs75PFldfTqJRc+8vo92bkFIXntSiS0bqc8GU2M1uL3c2Jmb5vkFoaUWZuj+DEE3w+TizR7
 egcvM4uQ8EizGnZG36SpyRd+fDW+seuL+2knDaPMhVocWrhiFun5EgJwFFUTI0uhFRO3T1RxKa
 jL4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:55:56 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcS3b0dJBz1RwqM
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:55:55 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id vn-Aqkd83uFg for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:55:54 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcS3Y3vhHz1RtVk;
 Mon,  4 Jul 2022 19:55:53 -0700 (PDT)
Message-ID: <98bebb07-d8a6-7a65-7843-874e62422fd6@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:55:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-17-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-17-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 16/17] block: remove blk_queue_zone_sectors
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:44, Christoph Hellwig wrote:
> Always use bdev_zone_sectors instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/md/dm-table.c  |  4 +---
>  drivers/md/dm-zone.c   | 10 ++++++----
>  include/linux/blkdev.h | 11 +++--------
>  3 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index b36b528e56cff..df904b7e95ce3 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1620,13 +1620,11 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>  static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
>  					   sector_t start, sector_t len, void *data)
>  {
> -	struct request_queue *q = bdev_get_queue(dev->bdev);
>  	unsigned int *zone_sectors = data;
>  
>  	if (!bdev_is_zoned(dev->bdev))
>  		return 0;
> -
> -	return blk_queue_zone_sectors(q) != *zone_sectors;
> +	return bdev_zone_sectors(dev->bdev) != *zone_sectors;
>  }
>  
>  /*
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 6d105abe12415..842c31019b513 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -334,7 +334,7 @@ static int dm_update_zone_wp_offset_cb(struct blk_zone *zone, unsigned int idx,
>  static int dm_update_zone_wp_offset(struct mapped_device *md, unsigned int zno,
>  				    unsigned int *wp_ofst)
>  {
> -	sector_t sector = zno * blk_queue_zone_sectors(md->queue);
> +	sector_t sector = zno * bdev_zone_sectors(md->disk->part0);
>  	unsigned int noio_flag;
>  	struct dm_table *t;
>  	int srcu_idx, ret;
> @@ -373,7 +373,7 @@ struct orig_bio_details {
>  static bool dm_zone_map_bio_begin(struct mapped_device *md,
>  				  unsigned int zno, struct bio *clone)
>  {
> -	sector_t zsectors = blk_queue_zone_sectors(md->queue);
> +	sector_t zsectors = bdev_zone_sectors(md->disk->part0);
>  	unsigned int zwp_offset = READ_ONCE(md->zwp_offset[zno]);
>  
>  	/*
> @@ -443,7 +443,7 @@ static blk_status_t dm_zone_map_bio_end(struct mapped_device *md, unsigned int z
>  		return BLK_STS_OK;
>  	case REQ_OP_ZONE_FINISH:
>  		WRITE_ONCE(md->zwp_offset[zno],
> -			   blk_queue_zone_sectors(md->queue));
> +			   bdev_zone_sectors(md->disk->part0));
>  		return BLK_STS_OK;
>  	case REQ_OP_WRITE_ZEROES:
>  	case REQ_OP_WRITE:
> @@ -593,6 +593,7 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
>  {
>  	struct mapped_device *md = io->md;
>  	struct request_queue *q = md->queue;
> +	struct gendisk *disk = md->disk;
>  	struct bio *orig_bio = io->orig_bio;
>  	unsigned int zwp_offset;
>  	unsigned int zno;
> @@ -608,7 +609,8 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
>  		 */
>  		if (clone->bi_status == BLK_STS_OK &&
>  		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
> -			sector_t mask = (sector_t)blk_queue_zone_sectors(q) - 1;
> +			sector_t mask =
> +				(sector_t)bdev_zone_sectors(disk->part0) - 1;
>  
>  			orig_bio->bi_iter.bi_sector +=
>  				clone->bi_iter.bi_sector & mask;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 183aa83143fd2..f1eca3f5610eb 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -669,11 +669,6 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
>  	}
>  }
>  
> -static inline sector_t blk_queue_zone_sectors(struct request_queue *q)
> -{
> -	return blk_queue_is_zoned(q) ? q->limits.chunk_sectors : 0;
> -}
> -
>  #ifdef CONFIG_BLK_DEV_ZONED
>  static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
>  {
> @@ -1312,9 +1307,9 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);
>  
> -	if (q)
> -		return blk_queue_zone_sectors(q);
> -	return 0;
> +	if (!blk_queue_is_zoned(q))
> +		return 0;
> +	return q->limits.chunk_sectors;
>  }
>  
>  static inline int queue_dma_alignment(const struct request_queue *q)


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

