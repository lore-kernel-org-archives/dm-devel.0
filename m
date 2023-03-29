Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE8EC74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 08:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680079291;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7oO0BIVroumudanE65oeNdTzC5sATuy8tO1OJWDBh+I=;
	b=QBmjHJ1L8rXM5AusDg2hTY/jV0KpXOxW08FXtSgLXX0LpOLUfAeZXKoYxc2unCfGCt/Xj0
	0hMAOpaYb4yxfPBFTbKZF365SY6UXKDCMsBNPE62NvXlqmPvBbKkhXfAB3DQOjjiwIQukM
	aDj74pmqxN7shiekHYaLnNXAR7yW9hY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-oyCdClF9MFGiHZ1opEX0mQ-1; Wed, 29 Mar 2023 04:41:28 -0400
X-MC-Unique: oyCdClF9MFGiHZ1opEX0mQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C016101A531;
	Wed, 29 Mar 2023 08:41:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 94B31C15BA0;
	Wed, 29 Mar 2023 08:41:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5FD81194658D;
	Wed, 29 Mar 2023 08:41:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B4887194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 08:41:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7B3E7C15BB8; Wed, 29 Mar 2023 08:41:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 73DB0C15BA0
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:41:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57099101A552
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:41:22 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-dSYmcVugO92ybQDg1kQFjg-2; Wed, 29 Mar 2023 04:41:20 -0400
X-MC-Unique: dSYmcVugO92ybQDg1kQFjg-2
X-IronPort-AV: E=Sophos;i="5.98,300,1673884800"; d="scan'208";a="231749342"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2023 16:40:16 +0800
IronPort-SDR: 97aGgXYC0pfuRn9FnHcN0YIcAlqqqMj67dS4d/Izi9/FDJQw5vx6Ms24KDJVSBHtTcBfamhW47
 qelIOa0CBMbVsQUlrjZTW9s+Sak11SL0vxxxoT2+w4DLr57/+F77tp1QGlOMOchDQE+5PEN+CX
 9forJPvGCMUkWC92qlo7oWySfI9awOywMEwUg7H/pK/3XvZQDnNcl0UuqqB5ckV776tJPyJqIN
 kWsXxuLtQe2jEqy4iKrXLC9bOZ2glq3m51AmAK/X6d4dqPuGvUzbQo2/ZklUO2FJAAR9VsoyXX
 h4o=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 00:56:25 -0700
IronPort-SDR: h7LNVuMKCk2XdBfmAZaiXQNvn0TYiCAQjFNtxYiGXWlbPVNcnKU4G1y8yVU12rpetgIji6Oner
 Y/fpgo8/FOoFxZHRRRNciaFVK6qI20W2lGfDAAlITl94eB+WPL3TXoi/H1CBjMyCj5XBTA6jre
 SsK5JubvNne8ryt9hqZjypibTUyUeprV8z96gf+/NzokFTGPid1vj9yyHBhazzgtam/R6vERFN
 FTE+IWJIEl7BZb9FQ3QQqaBVu7S5SEOy3VvUBOp2Df20xGH6+7BnNO6j7aAgKWpkWMZUGK8hlH
 zPY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 01:40:17 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pmg3g5Lrbz1RtVx
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 01:40:15 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 0_mz5PFEDpKD for <dm-devel@redhat.com>;
 Wed, 29 Mar 2023 01:40:14 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pmg3Z3bThz1RtVm;
 Wed, 29 Mar 2023 01:40:10 -0700 (PDT)
Message-ID: <e725768d-19f5-a78a-2b05-c0b189624fea@opensource.wdc.com>
Date: Wed, 29 Mar 2023 17:40:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084216epcas5p3945507ecd94688c40c29195127ddc54d@epcas5p3.samsung.com>
 <20230327084103.21601-2-anuj20.g@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230327084103.21601-2-anuj20.g@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v8 1/9] block: Introduce queue limits for
 copy-offload support
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
Cc: bvanassche@acm.org, joshi.k@samsung.com, gost.dev@samsung.com,
 nitheshshetty@gmail.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: opensource.wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/27/23 17:40, Anuj Gupta wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 
> Add device limits as sysfs entries,
>         - copy_offload (RW)
>         - copy_max_bytes (RW)
>         - copy_max_bytes_hw (RO)
> 
> Above limits help to split the copy payload in block layer.
> copy_offload: used for setting copy offload(1) or emulation(0).
> copy_max_bytes: maximum total length of copy in single payload.
> copy_max_bytes_hw: Reflects the device supported maximum limit.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  Documentation/ABI/stable/sysfs-block | 36 ++++++++++++++++
>  block/blk-settings.c                 | 24 +++++++++++
>  block/blk-sysfs.c                    | 64 ++++++++++++++++++++++++++++
>  include/linux/blkdev.h               | 12 ++++++
>  include/uapi/linux/fs.h              |  3 ++
>  5 files changed, 139 insertions(+)
> 
> diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
> index c57e5b7cb532..f5c56ad91ad6 100644
> --- a/Documentation/ABI/stable/sysfs-block
> +++ b/Documentation/ABI/stable/sysfs-block
> @@ -155,6 +155,42 @@ Description:
>  		last zone of the device which may be smaller.
>  
>  
> +What:		/sys/block/<disk>/queue/copy_offload
> +Date:		November 2022
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RW] When read, this file shows whether offloading copy to
> +		device is enabled (1) or disabled (0). Writing '0' to this

...to a device...

> +		file will disable offloading copies for this device.
> +		Writing any '1' value will enable this feature. If device

If the device does...

> +		does not support offloading, then writing 1, will result in
> +		error.
> +
> +
> +What:		/sys/block/<disk>/queue/copy_max_bytes
> +Date:		November 2022
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RW] While 'copy_max_bytes_hw' is the hardware limit for the
> +		device, 'copy_max_bytes' setting is the software limit.
> +		Setting this value lower will make Linux issue smaller size
> +		copies from block layer.

		This is the maximum number of bytes that the block
                layer will allow for a copy request. Must be smaller than
                or equal to the maximum size allowed by the hardware indicated
		by copy_max_bytes_hw. Write 0 to use the default kernel
		settings.

> +
> +
> +What:		/sys/block/<disk>/queue/copy_max_bytes_hw
> +Date:		November 2022
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RO] Devices that support offloading copy functionality may have
> +		internal limits on the number of bytes that can be offloaded
> +		in a single operation. The `copy_max_bytes_hw`
> +		parameter is set by the device driver to the maximum number of
> +		bytes that can be copied in a single operation. Copy
> +		requests issued to the device must not exceed this limit.
> +		A value of 0 means that the device does not
> +		support copy offload.

		[RO] This is the maximum number of kilobytes supported in a
                single data copy offload operation. A value of 0 means that the
		device does not support copy offload.

> +
> +
>  What:		/sys/block/<disk>/queue/crypto/
>  Date:		February 2022
>  Contact:	linux-block@vger.kernel.org
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 896b4654ab00..350f3584f691 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -59,6 +59,8 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->zoned = BLK_ZONED_NONE;
>  	lim->zone_write_granularity = 0;
>  	lim->dma_alignment = 511;
> +	lim->max_copy_sectors_hw = 0;
> +	lim->max_copy_sectors = 0;
>  }
>  
>  /**
> @@ -82,6 +84,8 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>  	lim->max_dev_sectors = UINT_MAX;
>  	lim->max_write_zeroes_sectors = UINT_MAX;
>  	lim->max_zone_append_sectors = UINT_MAX;
> +	lim->max_copy_sectors_hw = ULONG_MAX;
> +	lim->max_copy_sectors = ULONG_MAX;
>  }
>  EXPORT_SYMBOL(blk_set_stacking_limits);
>  
> @@ -183,6 +187,22 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
>  }
>  EXPORT_SYMBOL(blk_queue_max_discard_sectors);
>  
> +/**
> + * blk_queue_max_copy_sectors_hw - set max sectors for a single copy payload
> + * @q:  the request queue for the device
> + * @max_copy_sectors: maximum number of sectors to copy
> + **/
> +void blk_queue_max_copy_sectors_hw(struct request_queue *q,
> +		unsigned int max_copy_sectors)
> +{
> +	if (max_copy_sectors >= MAX_COPY_TOTAL_LENGTH)

Confusing name as LENGTH may be interpreted as bytes. MAX_COPY_SECTORS would be
better.

> +		max_copy_sectors = MAX_COPY_TOTAL_LENGTH;
> +
> +	q->limits.max_copy_sectors_hw = max_copy_sectors;
> +	q->limits.max_copy_sectors = max_copy_sectors;
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_max_copy_sectors_hw);


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

