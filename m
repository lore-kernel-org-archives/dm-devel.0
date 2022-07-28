Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C02A9C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 02:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658976863;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BPDwETT/xRCP+SCxWjOkCAY4t1GwgnWZJ4d1eR6ay8c=;
	b=arMrU1okzRJ+ocmGlti0Zpb3tnJYrUo6peDYE3LLVyNnSTOPUrQN1emcmfEiPw6FWVrsD6
	ILYQIeGhMeFVgFziiLb84sNB6SrhHN7BUOfXO2Fsq4bXAJvW0LS4ONWZU/KR6c6K+0IKx8
	4fL3zQxOwClSPSHrvDZ1b0tLCEE/qC4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-171-w4hVVxpdMQaZw-0riKw8Bw-1; Wed, 27 Jul 2022 22:54:20 -0400
X-MC-Unique: w4hVVxpdMQaZw-0riKw8Bw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A64C3C0D19C;
	Thu, 28 Jul 2022 02:54:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 949AA1121314;
	Thu, 28 Jul 2022 02:54:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 64CF41945DAB;
	Thu, 28 Jul 2022 02:54:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B7A541945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 02:54:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A901640CFD0A; Thu, 28 Jul 2022 02:54:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A561740CF8E2
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 02:54:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CCF829AB3FA
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 02:54:13 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-W_JaAgHgNcqeZLBlEzfnjQ-1; Wed, 27 Jul 2022 22:54:11 -0400
X-MC-Unique: W_JaAgHgNcqeZLBlEzfnjQ-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="212064288"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 10:54:09 +0800
IronPort-SDR: +ZkjsRY70SwDsEk//nQ25RQ7n2ZrPPGyDXpf63xyoL3QIwvketSFIFXl6xaMX72DTQ3Izd5lUz
 Ip6JN1xoEE0944Bh3NZPlNDGjlZVYMjhgyMr3ohGWZLthOa22cs9YCEr0woPsI6MOy/sIQTAFm
 dNGje6npyLVGVgC2oMggg6UPeemjc9tLsWDNYJ4I1VkgAO7/Jj/GibzNAt22vh9KSpprE41zTu
 rac9zkYcOfm7nb/+pGk1zBM39D6QgCb1irKcVXuM+z1vJ2zW0yOcYfFVnRlr3FRRbO5czhGkCH
 y53nm8AysHEDSLCJhKQirtvP
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 19:15:20 -0700
IronPort-SDR: BdaVitaouQXrxcp/Jwa6ELtBmhSbg7Dh9GPNGKBFixrBL3Fvf9ZS0S9G1WU+lKOELYK9ls4xkq
 hWQkcnyXWWtm4TQDDSAW+XQM5PUF/YXMdh+E4ESWDj8JtFna46HaZZ/ctv1Q6d3luRE4OWlruR
 0sz6RlqhCSaroZlbt53sOZqerfoKVApZJan/z9DCN0kVQN2hv+QwFd1N+RQJKPR0WcprlkHjXZ
 ZSHWN3GkU5X+FJIKWPq/pJxASuSTtcTAdx3br3eKyZccgF/BxWvqIWkfMcsQex7NC+X5wWysiw
 Skc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 19:54:09 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LtZww4VNVz1Rwnl
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 19:54:08 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id XD_OTYjcjzMV for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 19:54:07 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LtZwr6MMlz1RtVk;
 Wed, 27 Jul 2022 19:54:04 -0700 (PDT)
Message-ID: <8e0c4a9f-de4a-d53e-efef-0b27017ec78d@opensource.wdc.com>
Date: Thu, 28 Jul 2022 11:54:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162247eucas1p203fc14aa17ecbcb3e6215d5304bb0c85@eucas1p2.samsung.com>
 <20220727162245.209794-2-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220727162245.209794-2-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v8 01/11] block: make bdev_nr_zones and
 disk_zone_no generic for npo2 zsze
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
Cc: bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Adam Manzanares <a.manzanares@samsung.com>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/28/22 01:22, Pankaj Raghav wrote:
> Adapt bdev_nr_zones and disk_zone_no function so that it can

s/function/functions
s/it/they

> also work for non-power-of-2 zone sizes.
> 
> As the existing deployments of zoned devices had power-of-2

had power-of-2 assumption -> assume that a device zone size is a power of
2 number of sectors

Existing deployments still exist, so do not use the past tense please.

> assumption, power-of-2 optimized calculation is kept for those devices.
> 
> There are no direct hot paths modified and the changes just
> introduce one new branch per call.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-zoned.c      | 13 +++++++++----
>  include/linux/blkdev.h |  8 +++++++-
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index a264621d4905..dce9c95b4bcd 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -111,17 +111,22 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
>   * bdev_nr_zones - Get number of zones
>   * @bdev:	Target device
>   *
> - * Return the total number of zones of a zoned block device.  For a block
> - * device without zone capabilities, the number of zones is always 0.
> + * Return the total number of zones of a zoned block device, including the
> + * eventual small last zone if present. For a block device without zone
> + * capabilities, the number of zones is always 0.
>   */
>  unsigned int bdev_nr_zones(struct block_device *bdev)
>  {
>  	sector_t zone_sectors = bdev_zone_sectors(bdev);
> +	sector_t capacity = bdev_nr_sectors(bdev);
>  
>  	if (!bdev_is_zoned(bdev))
>  		return 0;
> -	return (bdev_nr_sectors(bdev) + zone_sectors - 1) >>
> -		ilog2(zone_sectors);
> +
> +	if (is_power_of_2(zone_sectors))
> +		return (capacity + zone_sectors - 1) >> ilog2(zone_sectors);
> +
> +	return DIV_ROUND_UP_SECTOR_T(capacity, zone_sectors);
>  }
>  EXPORT_SYMBOL_GPL(bdev_nr_zones);
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index dccdf1551c62..85b832908f28 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -673,9 +673,15 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
>  
>  static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>  {
> +	sector_t zone_sectors = disk->queue->limits.chunk_sectors;
> +
>  	if (!blk_queue_is_zoned(disk->queue))
>  		return 0;
> -	return sector >> ilog2(disk->queue->limits.chunk_sectors);
> +
> +	if (is_power_of_2(zone_sectors))
> +		return sector >> ilog2(zone_sectors);
> +
> +	return div64_u64(sector, zone_sectors);
>  }
>  
>  static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

