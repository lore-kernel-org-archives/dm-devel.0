Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2EC3C25B07
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660151107;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XTl5Z7MQHiTtZxSVLqEmR438s/SCWsg76GKAl+age2g=;
	b=jHjomAi3UKE+r8skmuvau3NM3SYXQoYxlMMFVDu0qw1YyYbtEEe3/q3iTbDoKmIXv7NwpK
	nmjQ/VM2eSZrwxvf5Flq+kB2H63KrAKC7+dGCaLl2iL+F0NGGO4ewo2df18ZLZDLpxAv0q
	hHJZeGY7m0ujixxoeC92yxe5ATaWzfc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611--Z_lQsl_OqOuVko1OBspLA-1; Wed, 10 Aug 2022 13:05:05 -0400
X-MC-Unique: -Z_lQsl_OqOuVko1OBspLA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 821CF8039AE;
	Wed, 10 Aug 2022 17:05:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6CB71C15BA6;
	Wed, 10 Aug 2022 17:05:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2A0FF1946A50;
	Wed, 10 Aug 2022 17:05:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 77A991946A4F
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 17:05:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5529A40315E; Wed, 10 Aug 2022 17:05:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 50AEB492C3B
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 17:05:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 383748039A1
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 17:05:01 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-ODsc6AwRPpKaR5fa56-MPQ-2; Wed, 10 Aug 2022 13:04:59 -0400
X-MC-Unique: ODsc6AwRPpKaR5fa56-MPQ-2
X-IronPort-AV: E=Sophos;i="5.93,227,1654531200"; d="scan'208";a="208917156"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2022 01:04:57 +0800
IronPort-SDR: Sg9xoIebxBRNK2GbK4L+uiB+m3fDb9WjoVH5IYENzoXA2o6jFjtFQ3h1mJBMpRvWjd52bIdj/A
 QzX8fiOVCNUNcenz+sMgxeYVJnDtgj5LRL+Jkg21/UTBXCSPXdHwUmpKXzfFOLod5fA1pwTONU
 jPLx2KzcKY+ezL75C2H7/dhMb+ORGneyA93BQ9WpCbGkjQwdrRw62w34QwiLyQpyquX0IQhoII
 Pj+1d6Q8OCBPPtiwSaMx1Z7MCPHvqkwYZioUQ4JRMVLXQabGhvQVTiwcuQSrAMDLueZaHyBvOK
 OLejzoKzCIqNwqXhrhAgx63E
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 09:25:53 -0700
IronPort-SDR: IXJSpMy0sxfiXdbxA1iTWnZ64Usy4A2CVkcoyun4kE+joJDHCMvUWj2n6gnT4S1GzziyCi4n8Z
 /ayh++MroR5cPwKJHxULJqxcU7Bi0LFrQvY+Cy5I/OdTFi1g0MYEQ2O7S01eKVqsxnego51wHS
 b7GDTi97LygP6Z6kcwDLYWA4D+KcRmoj5kfLYE7vav7C7orrMo/sTZOj2Dsx39Wawf8XG4zi/E
 wWbzcYPxi6CKzjuyIDE55F7mJe7p+Zt6XOWs7ek36CPkEtcziPYsQTjy7JZatOJcC5avthJOIz
 cjg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 10:04:58 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4M2xBc5J5Sz1Rwnl
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 10:04:56 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id lF4fzIJNTa_s for <dm-devel@redhat.com>;
 Wed, 10 Aug 2022 10:04:56 -0700 (PDT)
Received: from [10.111.68.99] (c02drav6md6t.sdcorp.global.sandisk.com
 [10.111.68.99])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4M2xBb523Qz1RtVk;
 Wed, 10 Aug 2022 10:04:55 -0700 (PDT)
Message-ID: <89327143-48b1-297a-bf16-1ea7a2128595@opensource.wdc.com>
Date: Wed, 10 Aug 2022 10:04:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094806eucas1p24e1fd0f3a595e050d79c4315559d97ae@eucas1p2.samsung.com>
 <20220803094801.177490-5-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220803094801.177490-5-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v9 04/13] nvmet: Allow ZNS target to support
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/08/03 2:47, Pankaj Raghav wrote:
> A generic bdev_zone_no() helper is added to calculate zone number for a
> given sector in a block device. This helper internally uses disk_zone_no()
> to find the zone number.
> 
> Use the helper bdev_zone_no() to calculate nr of zones. This let's us
> make modifications to the math if needed in one place and adds now
> support for zoned devices with non po2 zone size.
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
>  
>  static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 5aa15172299d..ead848a15946 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1345,6 +1345,11 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
>  	return BLK_ZONED_NONE;
>  }
>  
> +static inline unsigned int bdev_zone_no(struct block_device *bdev, sector_t sec)
> +{
> +	return disk_zone_no(bdev->bd_disk, sec);
> +}
> +
>  static inline int queue_dma_alignment(const struct request_queue *q)
>  {
>  	return q ? q->dma_alignment : 511;

I know that it is generally better to introduce a new helper together with its
user, but in this case, these 2 changes belong to different subsystems. So I
think it really may be better to have 2 patches here. Jens can decide about this
though.

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

