Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA30C00140
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660151814;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cCbM3lTh14iiPcK5IWy5UG/YERgL/FRhPmAJqrZA584=;
	b=jM6Hth8fdReZDyc7rebKJJ1o8LYdArL+mQUF9KpGRfz0L2+O6sx/u2kNZy7Q0vuR2HL64O
	pF4B206QZwEOtTdaQZeQMS8V8bDkwnJK2pvNPdMbOkEmEcwFGkOts09o5fjMj5oGRF7d3d
	JRI2FjE0LeO6pYZAodNHc2P4FHN4KFs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-N3YgHvDdNgiAsqO99Rd2VQ-1; Wed, 10 Aug 2022 13:16:53 -0400
X-MC-Unique: N3YgHvDdNgiAsqO99Rd2VQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEF711C1A950;
	Wed, 10 Aug 2022 17:16:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7D870C15BA1;
	Wed, 10 Aug 2022 17:16:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0AC1D1946A50;
	Wed, 10 Aug 2022 17:16:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 191D41946A4F
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 17:16:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B27BB492C3B; Wed, 10 Aug 2022 17:16:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AEA00492CA4
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 17:16:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 957242A59562
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 17:16:49 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-VTT_HUMSPvaWJeBI8pmsRw-1; Wed, 10 Aug 2022 13:16:47 -0400
X-MC-Unique: VTT_HUMSPvaWJeBI8pmsRw-1
X-IronPort-AV: E=Sophos;i="5.93,227,1654531200"; d="scan'208";a="208364292"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2022 01:16:44 +0800
IronPort-SDR: 2m1LyF81RjXlyL3uFkrknjTpMAXgIbZNeWWtEz0drfg+7cgV8SHwO9f8vK1vmEHQpIplf0EKC2
 kh18D8cPgkw/c+wejsA3tQ1oTr5huLzxNs0CMbEHuibgRaGNekZ2/Nxam8VZ+SledBtpDYpN7p
 623wO3QZ88m0UaQyN1/fvxv9QJYGOzKtL904mD4OnpTj681nntzOIXZH/LcLMoypFP9mi5iqCE
 xXKpAKYKpg46463AljHLzwil1ds/0m+EWNcpnuwFoma/o80cHdGJDO+5cDjMavAGy06VTP1Gke
 PNYq8KWpU9ZGBC3fFYZfhlUV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 09:37:40 -0700
IronPort-SDR: WYioiPEa72hmJLMq7PBMk6CUOjjemqIQh5uBto+rdgyqqy+6BWnSmcD90ZkLp0qK8nqdsbHn/d
 mBvYlempXiZgm0DPWOvzH+ZKv0wjtp5odL0SvUu+DBQyef9ZJyUsroVWZeLl0CHcLH0vZ36Re4
 rsCCwa5ViaFx1gVoJpj/q9f7oT+Z5zKLJgCON1r8WrHDR7tHyIkKwCBJvWCD82MnBk5DaYfckL
 KVRyPsEZrLhQqlai+34acA6ZARsNZ/LbLQ3qehuci8oJhSdNz+ErrHbPfM3EOvA4jzVqeuWK2Y
 Q2A=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 10:16:46 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4M2xSF0YXlz1Rwnl
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 10:16:44 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id IHvo9qLmFIQ0 for <dm-devel@redhat.com>;
 Wed, 10 Aug 2022 10:16:43 -0700 (PDT)
Received: from [10.111.68.99] (c02drav6md6t.sdcorp.global.sandisk.com
 [10.111.68.99])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4M2xSC1pJVz1RtVk;
 Wed, 10 Aug 2022 10:16:43 -0700 (PDT)
Message-ID: <3ee96421-94b2-12d8-9aa2-83d4f7027694@opensource.wdc.com>
Date: Wed, 10 Aug 2022 10:16:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094815eucas1p2dfab477daf4f2eb05342d756fdf7f14d@eucas1p2.samsung.com>
 <20220803094801.177490-13-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220803094801.177490-13-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v9 12/13] dm: introduce DM_EMULATED_ZONES
 target type
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
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/08/03 2:48, Pankaj Raghav wrote:
> Introduce a new target type DM_EMULATED_ZONES for targets with
> a different zone number of sectors than the underlying device zone
> number of sectors.

"zone number of sectors" is strange. "number of sectors per zone (aka zone
size)" is simpler and clear.

> 
> This target type is introduced as the existing zoned targets assume
> that the target and the underlying device have the same zone
> number of sectors. The new target: dm-po2zone will use this new target
> type as it emulates the zone boundary that is different from the
> underlying zoned device.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

With that text fixed, looks OK to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/md/dm-table.c         | 13 ++++++++++---
>  include/linux/device-mapper.h |  9 +++++++++
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 31eb1d29d136..b37991ea3ffb 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1614,13 +1614,20 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>  	return true;
>  }
>  
> -static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
> +/*
> + * Callback function to check for device zone sector across devices. If the
> + * DM_TARGET_EMULATED_ZONES target feature flag is not set, then the target
> + * should have the same zone sector as the underlying devices.
> + */
> +static int check_valid_device_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
>  					   sector_t start, sector_t len, void *data)
>  {
>  	unsigned int *zone_sectors = data;
>  
> -	if (!bdev_is_zoned(dev->bdev))
> +	if (!bdev_is_zoned(dev->bdev) ||
> +	    dm_target_supports_emulated_zones(ti->type))
>  		return 0;
> +
>  	return bdev_zone_sectors(dev->bdev) != *zone_sectors;
>  }
>  
> @@ -1645,7 +1652,7 @@ static int validate_hardware_zoned_model(struct dm_table *t,
>  	if (!zone_sectors)
>  		return -EINVAL;
>  
> -	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
> +	if (dm_table_any_dev_attr(t, check_valid_device_zone_sectors, &zone_sectors)) {
>  		DMERR("%s: zone sectors is not consistent across all zoned devices",
>  		      dm_device_name(t->md));
>  		return -EINVAL;
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 04c6acf7faaa..83e20de264c9 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -294,6 +294,15 @@ struct target_type {
>  #define dm_target_supports_mixed_zoned_model(type) (false)
>  #endif
>  
> +#ifdef CONFIG_BLK_DEV_ZONED
> +#define DM_TARGET_EMULATED_ZONES	0x00000400
> +#define dm_target_supports_emulated_zones(type) \
> +	((type)->features & DM_TARGET_EMULATED_ZONES)
> +#else
> +#define DM_TARGET_EMULATED_ZONES	0x00000000
> +#define dm_target_supports_emulated_zones(type) (false)
> +#endif
> +
>  struct dm_target {
>  	struct dm_table *table;
>  	struct target_type *type;


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

