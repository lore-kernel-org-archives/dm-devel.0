Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC12C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 03:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658978772;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lYUaOyi469XjTSZzkJcHVvODCV3Bp73vihKVQxFJqkA=;
	b=bEhuQrA8WVA3TZgNWE6XNnT9vv1JnIDaU+30fvI/Yo1EZ/FtYPrUzWl9rwwwmmBpnQu++8
	Bno4CGO1+f+mxmVW8YKRFlFo6NBZpgTAdzkOU0srYGulzmmXYp2rHrimPxsS2Wiqkbqs/q
	Nkee27zmplOBvOFteXCV6IaspgLF68g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-Kq5fkSWoP1qGAwWCz5C5eQ-1; Wed, 27 Jul 2022 23:26:07 -0400
X-MC-Unique: Kq5fkSWoP1qGAwWCz5C5eQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5726A185A7BA;
	Thu, 28 Jul 2022 03:26:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 00E8340357BA;
	Thu, 28 Jul 2022 03:26:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A15A71945DAB;
	Thu, 28 Jul 2022 03:26:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 285561945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 03:26:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EE2DF18ECC; Thu, 28 Jul 2022 03:26:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA1F118EB7
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:26:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBC968001EA
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:26:03 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-DR0pDDItOtyma7ll3NNVAQ-1; Wed, 27 Jul 2022 23:26:01 -0400
X-MC-Unique: DR0pDDItOtyma7ll3NNVAQ-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="207731675"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 11:26:00 +0800
IronPort-SDR: 6/5jrdWqDWKd1PSfBXsYfZj6Ghft2aOjUyQcDOc+E/VO4MVwvetJ5qOiCQj7awar+iHLej4J2d
 /IIl0Yn6MX7kyKHc8iMPErDPUnuadsDmYjc/ny70WbLCjzQuDRDS4dBd+CUXqU3JkwimSkroof
 qkIjHxB9mZOK3A8LMgJI/zE72Gc3O2NaFAnIirF8j7AG/oE13oUdQLojPywdd/WirQzLXXh6Wh
 zvkGrGaSLG1KjWp+mA9tQSHbZfXPC5fiklFgdsd8DR8O6458LL+mDkFrFo20EWFqFTsOZuzMWk
 dL8fpbcrFZqbuPBTpyzFZ1tT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 19:42:08 -0700
IronPort-SDR: IQNP8ujj0eqoz85w0OIkCpMb+ZNOLJu94hoh63/FqRUnugP1q09/2TapQpN/2zSetgnJ7VS0Xk
 1tS063GZCZFJBHDblSsSuNKdOk8uYJNNwsc9gL7YqXWRa5tvn+eDAPfZPwT6R5JviBptz7alar
 Mii4PfXcQnxXq6eR69wCmFmrwAI/lsnSXm0gHtGybEza+w+y7CpgpMnz/s9FdS3KLbl/DKcItS
 /Q+Jnm2rxC8Z6xTN547Hrnwbr0xFWXxektXlNistlN2+VJVhMlM/M9Vn/0jvZUTQyiJvYTswme
 z/o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 20:26:00 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Ltbdg2bvzz1Rwnx
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 20:25:59 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id WsL7-NBWYN0B for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 20:25:58 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Ltbdb6fMYz1RtVk;
 Wed, 27 Jul 2022 20:25:55 -0700 (PDT)
Message-ID: <2b1ab4ac-a355-dfb4-6ca4-82fe36a38433@opensource.wdc.com>
Date: Thu, 28 Jul 2022 12:25:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162256eucas1p284a15532173cce3eca46eee0cee3acdd@eucas1p2.samsung.com>
 <20220727162245.209794-11-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220727162245.209794-11-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v8 10/11] dm: call dm_zone_endio after the
 target endio callback for zoned devices
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/28/22 01:22, Pankaj Raghav wrote:
> dm_zone_endio() updates the bi_sector of orig bio for zoned devices that
> uses either native append or append emulation and it is called before the
> endio of the target. But target endio can still update the clone bio
> after dm_zone_endio is called, thereby, the orig bio does not contain
> the updated information anymore. Call dm_zone_endio for zoned devices
> after calling the target's endio function
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/md/dm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 03ac6143b8aa..bc410ee04004 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1123,10 +1123,6 @@ static void clone_endio(struct bio *bio)
>  			disable_write_zeroes(md);
>  	}
>  
> -	if (static_branch_unlikely(&zoned_enabled) &&
> -	    unlikely(bdev_is_zoned(bio->bi_bdev)))
> -		dm_zone_endio(io, bio);
> -
>  	if (endio) {
>  		int r = endio(ti, bio, &error);
>  		switch (r) {
> @@ -1155,6 +1151,10 @@ static void clone_endio(struct bio *bio)
>  		}
>  	}
>  
> +	if (static_branch_unlikely(&zoned_enabled) &&
> +	    unlikely(bdev_is_zoned(bio->bi_bdev)))
> +		dm_zone_endio(io, bio);
> +
>  	if (static_branch_unlikely(&swap_bios_enabled) &&
>  	    unlikely(swap_bios_limit(ti, bio)))
>  		up(&md->swap_bios_semaphore);

This patch seems completely unrelated to the series topic. Is that a bug
fix ? How do you trigger it ? Our tests do not show any issues here...
If this triggers only with non power of 2 zone size devices, then this
should be squashed in patch 8. And patch 9 could also be squashed with
patch 8 too.

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

