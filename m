Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EC66C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 11:56:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-1ei3-EM-OvGJp5TFDO0bJA-1; Wed, 15 Jun 2022 07:56:36 -0400
X-MC-Unique: 1ei3-EM-OvGJp5TFDO0bJA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6C4C3810793;
	Wed, 15 Jun 2022 11:56:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 502382166B26;
	Wed, 15 Jun 2022 11:56:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6B721947040;
	Wed, 15 Jun 2022 11:56:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0FA7E1947040
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 11:56:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D1EC71415108; Wed, 15 Jun 2022 11:56:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE01C1415107
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 11:56:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5F0A811E75
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 11:56:32 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-2WQKkRhkOlaD2ECTpZ8deQ-1; Wed, 15 Jun 2022 07:56:31 -0400
X-MC-Unique: 2WQKkRhkOlaD2ECTpZ8deQ-1
X-IronPort-AV: E=Sophos;i="5.91,302,1647273600"; d="scan'208";a="203985910"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 15 Jun 2022 19:56:31 +0800
IronPort-SDR: cYvczkokbWWEBJRo7pKxdJdqVu3JxSKMD27gGumjdpTlQzaxFY+HTvohwdRHRG68qi6Y6WfZ+X
 OlJs08VN7+gvzp6EWg+Ky7iH9jsOtIUIaaquLNeNqTaNYJn2pFwMXUJQp5DR2E1PZhZUo28nKs
 SqP2EEiBIFXu6BF6NBcMvVSgW7r7Vj31wCw2ZKCMwuX1LEK0pASHWRHjPrnwsUq7hGlzvzY47P
 84RwvcswkpbwQTN/vDf1c9nC1Foy6A1P7m/DgmkIRMCqA6nUAeyqlicRFqIvoH6DBM/6/tTQiY
 p12CQW8Zp9nb7Kih7WkjxlEr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 15 Jun 2022 04:14:54 -0700
IronPort-SDR: Bpn2V3MX5CtH63Q67fFUWDSrvtu3V/dKsuGftRRfP1QXT2a3FlwlUyeOHMwJ18ZYE7nTbGsalS
 nooQ2U//z4pYMGJYUUz02zFbM0/CSlsZHjUbju3zSYTz0d3mJYLFZSM9YcIcQvTdKs4Nf9/SkC
 cmCX74mx5P+bMmdbvsk9hnF9ES4Lsytpiymov9ngyK0Q6S22rhHqtjqNS27oK8bBqhRdHdcinq
 zxUMLaYJRE6UmHQ8Qx6GQGd6Dub/cvE5rRTbwJyIH1ULV9mwchXLJvTMjo0CkD+lADFrwRGkeM
 iR8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 15 Jun 2022 04:56:30 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LNP0Y0Hltz1SVny
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 04:56:28 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id F7PKblfyFHou for <dm-devel@redhat.com>;
 Wed, 15 Jun 2022 04:56:27 -0700 (PDT)
Received: from [10.225.163.82] (unknown [10.225.163.82])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LNP0S6n1Sz1Rvlc;
 Wed, 15 Jun 2022 04:56:24 -0700 (PDT)
Message-ID: <4bafa68f-46b3-7a76-de70-377a0f9cf130@opensource.wdc.com>
Date: Wed, 15 Jun 2022 20:56:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101945eucas1p16fa264e81d9b6027ff131dd311ed91e2@eucas1p1.samsung.com>
 <20220615101920.329421-7-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220615101920.329421-7-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v7 06/13] null_blk: use zone_size_sects_shift
 for power of 2 zoned devices
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/15/22 19:19, Pankaj Raghav wrote:
> Instead of doing is_power_of_2 and ilog2 operation for every IO, cache
> the zone_size_sects_shift variable and use it for power of 2 zoned
> devices.
> 
> This variable will be set to zero for non power of 2 zoned devices.
> 
> Suggested-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/block/null_blk/null_blk.h |  6 ++++++
>  drivers/block/null_blk/zoned.c    | 11 ++++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
> index 8359b4384..3bc7cbf25 100644
> --- a/drivers/block/null_blk/null_blk.h
> +++ b/drivers/block/null_blk/null_blk.h
> @@ -83,6 +83,12 @@ struct nullb_device {
>  	unsigned int imp_close_zone_no;
>  	struct nullb_zone *zones;
>  	sector_t zone_size_sects;
> +	/*
> +	 * zone_size_sects_shift is only useful when the zone size is
> +	 * power of 2. This variable is set to zero when zone size is non
> +	 * power of 2.
> +	 */
> +	unsigned int zone_size_sects_shift;
>  	bool need_zone_res_mgmt;
>  	spinlock_t zone_res_lock;
>  
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index daf327015..5f929944b 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -16,8 +16,8 @@ static inline sector_t mb_to_sects(unsigned long mb)
>  
>  static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
>  {
> -	if (is_power_of_2(dev->zone_size_sects))
> -		return sect >> ilog2(dev->zone_size_sects);
> +	if (dev->zone_size_sects_shift)
> +		return sect >> dev->zone_size_sects_shift;
>  
>  	return div64_u64(sect, dev->zone_size_sects);
>  }
> @@ -85,9 +85,14 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
>  	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
>  	dev_capacity_sects = mb_to_sects(dev->size);
>  	dev->zone_size_sects = mb_to_sects(dev->zone_size);
> +
> +	if (is_power_of_2(dev->zone_size_sects))
> +		dev->zone_size_sects_shift = ilog2(dev->zone_size_sects);
> +	else
> +		dev->zone_size_sects_shift = 0;
> +
>  	dev->nr_zones =	DIV_ROUND_UP_SECTOR_T(dev_capacity_sects,
>  					      dev->zone_size_sects);
> -

white line change.

This patch should be squashed with the previous one.

>  	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct nullb_zone),
>  				    GFP_KERNEL | __GFP_ZERO);
>  	if (!dev->zones)


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

