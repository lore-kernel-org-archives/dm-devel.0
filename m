Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFC8C19F28
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 03:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658977791;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wqJY1Wy5kjncI4mOF8vq0uAGf/Y6ViJpEwLoPXt+4io=;
	b=f05thRJxiIY8QNIBi58wrJ+R2fK3jrGsES057aVDKSHb39w49CP4ZiuVu+gntmqVYmk7/2
	kR1SaZ7SIMvAZ4tm17/wAoZhlqojRq7v9d+inZkTrIiMpKie9FKfM64aEtSa+ofCUFtfiV
	Fv0Gs7tcLcfkkVLct+H3CzD97ySoer8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-WDt7ygQVNdqDM_lci9DZCQ-1; Wed, 27 Jul 2022 23:09:48 -0400
X-MC-Unique: WDt7ygQVNdqDM_lci9DZCQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6740D85A584;
	Thu, 28 Jul 2022 03:09:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E9D81415118;
	Thu, 28 Jul 2022 03:09:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 334271945DAE;
	Thu, 28 Jul 2022 03:09:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 72EE51945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 03:09:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 53CFA4010E4D; Thu, 28 Jul 2022 03:09:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C990400F8F0
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:09:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21A123804502
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:09:45 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-AH18iIE-OY6wSOgAjxIpiw-1; Wed, 27 Jul 2022 23:09:43 -0400
X-MC-Unique: AH18iIE-OY6wSOgAjxIpiw-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="319201604"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 11:09:41 +0800
IronPort-SDR: 6n/ytH1FzFfRx0YkvGRv/lnrC/UepSroL62ZhV1A8MZYLL7QlFwOb8bmQwxkg2rG6vb8xGtJC8
 a48xXiSLTUs6z1s2IvIR7XZ2xsALMqNZXeytEwCutkyhjryDhSA98jD9pOCXu9JLeO8PNimjww
 tKntz4+KuROmXlOQr4wpn0L1TWtt+oJKrZMdwL8TcaiDlbahKGs9gtUejgNXHQ/h6Iz1IKRE3k
 ZhvlVxpgULr3yjA9e10skYF9ZTrhJ6oKK94203BV6nxeRwfK/JJwdg0VINNSSNhQlZMDIb+QsN
 cd49x1H4J+QKsPIPr0+iGZY7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 19:25:49 -0700
IronPort-SDR: qjlfmJBw0cKYGC1/mSU6b9ZTFqzOcO7L9g1Sdas+if2fmYl8iiILhUvDYN+yvGBCyJFw/GUVo5
 tOp78Z8eui6nMIiglXEOXBUX/ntDcXA/WCc1+u5ckrhcLqrTK+zpUeUtYiAYrbCoSpbuRWlQui
 Wg+7Cwec3b/2EoFObsrVBpkESl7d/cvm6oTsYt2Q7hz0O6RvtfIQBKzy2my/wqS+Qsf/DpC8dX
 V1PWnCHzB1x7Gb01tsudO8VYPYjGbshk+HDMTbQALbjETbZILkFskmAHDorxFol1iF/2W0TTHE
 ybY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 20:09:42 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LtbGs0NfZz1Rwnl
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 20:09:40 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id BZvPdb049Fsa for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 20:09:40 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LtbGp0d8bz1RtVk;
 Wed, 27 Jul 2022 20:09:37 -0700 (PDT)
Message-ID: <137b8772-a2cc-f195-1c0d-476214fabd52@opensource.wdc.com>
Date: Thu, 28 Jul 2022 12:09:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162250eucas1p133e8a814fee934f7161866122ef93273@eucas1p1.samsung.com>
 <20220727162245.209794-5-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220727162245.209794-5-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v8 04/11] nvmet: Allow ZNS target to support
 non-power_of_2 zone sizes
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
 linux-block@vger.kernel.org, dm-devel@redhat.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/28/22 01:22, Pankaj Raghav wrote:
> A generic bdev_zone_no() helper is added to calculate zone number for a
> given sector in a block device. This helper internally uses disk_zone_no()
> to find the zone number.
> 
> Use the helper bdev_zone_no() to calculate nr of zones. This let's us
> make modifications to the math if needed in one place and adds now
> support for npo2 zone devices.
> 
> Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/nvme/target/zns.c | 3 +--
>  include/linux/blkdev.h    | 5 +++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index c7ef69f29fe4..662f1a92f39b 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -241,8 +241,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
>  {
>  	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
>  
> -	return bdev_nr_zones(req->ns->bdev) -
> -		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
> +	return bdev_nr_zones(req->ns->bdev) - bdev_zone_no(req->ns->bdev, sect);
>  }

This change should go into patch 3. Otherwise, adding patch 3 only will
break the nvme target zone code.

>  
>  static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 1be805223026..d1ef9b9552ed 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1350,6 +1350,11 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
>  	return BLK_ZONED_NONE;
>  }
>  
> +static inline unsigned int bdev_zone_no(struct block_device *bdev, sector_t sec)
> +{
> +	return disk_zone_no(bdev->bd_disk, sec);
> +}
> +

This should go into a prep patch before patch 3.

>  static inline int queue_dma_alignment(const struct request_queue *q)
>  {
>  	return q ? q->dma_alignment : 511;


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

