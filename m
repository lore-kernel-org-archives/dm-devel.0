Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E3AC433EF
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656988806;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5kAJT1v25Ha8ZIKXCk4AGL4AlWn32OncBIQslsQGqqU=;
	b=G2OF7gvwnB4qwX66k6nOV8uttudgtUvlrRszwW/vF/Cn95E6pUZ0A0nHL1+YTEYMY6gnZG
	T7rys3ZVClKY2gkllZR3UtdGKoOKfs9c2kd1Fq7kC6osJpYvKc776/Oy8Jrdo7GOWMri1j
	fOvCsf3slXwwSqcvBHkLQ45zrtjF4Wc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-VQyCTifnNWuPRcWOoviWIQ-1; Mon, 04 Jul 2022 22:40:03 -0400
X-MC-Unique: VQyCTifnNWuPRcWOoviWIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C26F3C0CD4B;
	Tue,  5 Jul 2022 02:40:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C4044010D28;
	Tue,  5 Jul 2022 02:40:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F01BE194704A;
	Tue,  5 Jul 2022 02:40:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C675F1947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:39:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B7DB3112131B; Tue,  5 Jul 2022 02:39:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B38CD1121315
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:39:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98B9D3C0CD48
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:39:59 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-qDVtQnkzMh6z0Kb5Kb7A8g-1; Mon, 04 Jul 2022 22:39:57 -0400
X-MC-Unique: qDVtQnkzMh6z0Kb5Kb7A8g-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="205520000"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:39:56 +0800
IronPort-SDR: ajgib9akbqRsyXlH4PNmcoQqQua2t7N3Bjre+FnKtY8UbPwwVKpDlD7rUr7RII0VP+TXwYBih1
 XNXy4znHXNoIbSourJgqZ81EnMIH7Ndo9LZIey0dAc7bKmcGvneuoDVjgEL5tZ1URp0owP/nk8
 d/duGAJux1JwfxpApZ9B3OsopTdD/CGKnoVDt1ybSWS8lrumk4WM63euv/J6XSZ4NWHFbqz+Xo
 5eNouTCsDeEdQXU1w7yBqMr54XFWHMzfaDrEt3k8iMYTn9TojZ7HGMThOqWMDvYkWFzJUVkPHq
 t8l5wjpkK/Q/BHNbCpv25or5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 18:57:15 -0700
IronPort-SDR: /CzObeX4aPtPZVhkK4CiF02jWiqkXQQKT8sbk+fa61CmluiMA+DVcWwKt7zLuvLZ0KvFkYJle2
 AJGQR1YXmSlvl5W8+TOyVQiMs6p1vY3g1/Omjs4Hl6mYRcNaMpn5LiDdFGY21/xoNK0pBIaqmQ
 CXipmaVNunVM63bIjBg7LFulk+V+MpAYO82AQavD9wHUhGxPjn5qpO73Md8tCXCwRfN4JAzB7G
 1G2gs7GS+4iqbOJtXlYzr7NfFFb9nBaUs/LLxgv24oWPP59sLdMujEsDpzl/mp8EZCSm8LBRsH
 bqw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:39:56 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcRj81dbKz1Rwnl
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:39:56 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 3usDui2dFIzr for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:39:55 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcRj614KWz1RtVk;
 Mon,  4 Jul 2022 19:39:53 -0700 (PDT)
Message-ID: <a71ac62a-9fcd-5282-9c4d-17348dff18c5@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:39:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-6-hch@lst.de>
 <9e815a0b-0d60-730a-51f8-6ba749b5c60e@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <9e815a0b-0d60-730a-51f8-6ba749b5c60e@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 05/17] block: export blkdev_zone_mgmt_all
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

On 7/5/22 11:31, Damien Le Moal wrote:
> On 7/4/22 21:44, Christoph Hellwig wrote:
>> Export blkdev_zone_mgmt_all so that the nvme target can use it instead
>> of duplicating the functionality.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Actually, looking again at this, if we generalize
blkdev_zone_reset_all_emulated() into blkdev_zone_mgmt_all(), we should
not allocate the need_reset bitmap if op is not reset. And the emulation
for open/close/finish all is a bit tricky as we have to look at the
current state of the zones, so we still need the report. The bitmat should
this be something like "do_op" and the bits in it set using a helper for
the zone depending on the op. Then using that function as is in nvmet will
work. Otherwise, as-is, I think it will break something in nvmet.

> 
>> ---
>>  block/blk-zoned.c      | 10 +++++-----
>>  include/linux/blkdev.h |  2 ++
>>  2 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index 90a5c9cc80ab3..7fbe395fa51fc 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -185,8 +185,8 @@ static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
>>  	}
>>  }
>>  
>> -static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
>> -					  gfp_t gfp_mask)
>> +int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
>> +			 gfp_t gfp_mask)
>>  {
>>  	struct request_queue *q = bdev_get_queue(bdev);
>>  	sector_t capacity = get_capacity(bdev->bd_disk);
>> @@ -213,8 +213,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
>>  			continue;
>>  		}
>>  
>> -		bio = blk_next_bio(bio, bdev, 0, REQ_OP_ZONE_RESET | REQ_SYNC,
>> -				   gfp_mask);
>> +		bio = blk_next_bio(bio, bdev, 0, op | REQ_SYNC, gfp_mask);
>>  		bio->bi_iter.bi_sector = sector;
>>  		sector += zone_sectors;
>>  
>> @@ -231,6 +230,7 @@ static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
>>  	kfree(need_reset);
>>  	return ret;
>>  }
>> +EXPORT_SYMBOL_GPL(blkdev_zone_mgmt_all);
>>  
>>  static int blkdev_zone_reset_all(struct block_device *bdev, gfp_t gfp_mask)
>>  {
>> @@ -295,7 +295,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>>  	 */
>>  	if (op == REQ_OP_ZONE_RESET && sector == 0 && nr_sectors == capacity) {
>>  		if (!blk_queue_zone_resetall(q))
>> -			return blkdev_zone_reset_all_emulated(bdev, gfp_mask);
>> +			return blkdev_zone_mgmt_all(bdev, op, gfp_mask);
>>  		return blkdev_zone_reset_all(bdev, gfp_mask);
>>  	}
>>  
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 270cd0c552924..b9baee910b825 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -302,6 +302,8 @@ unsigned int blkdev_nr_zones(struct gendisk *disk);
>>  extern int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>>  			    sector_t sectors, sector_t nr_sectors,
>>  			    gfp_t gfp_mask);
>> +int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
>> +			 gfp_t gfp_mask);
>>  int blk_revalidate_disk_zones(struct gendisk *disk,
>>  			      void (*update_driver_data)(struct gendisk *disk));
>>  
> 
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

