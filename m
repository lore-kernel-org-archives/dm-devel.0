Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04BAFC19F28
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 03:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658978445;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=48g8VNvVdNa4qAhNYWK/ELfsvXLFleru+NMVq96pXTg=;
	b=R3gc4cOF3SMUQhh0vUOjpgBXexsMx40gGY9WsD53FS6POC4tNch9+pvE6r8lRaHttD7fWu
	mRZplNb/PRCYQTcD2+1b/6F+92lv8LJCLXsnsa5EqCy8fg6ZfxcWHU/SCr1gqxwXHNa0UP
	DIbJLPlOCqx9IzSFI189WhZ3n56uZLU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-527-A46bGQ_wOTePYC4T6um8HA-1; Wed, 27 Jul 2022 23:20:41 -0400
X-MC-Unique: A46bGQ_wOTePYC4T6um8HA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1E2A802D1C;
	Thu, 28 Jul 2022 03:20:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8195E1410F3C;
	Thu, 28 Jul 2022 03:20:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F6BA1945DAB;
	Thu, 28 Jul 2022 03:20:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6100F1945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 03:20:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 418B61415121; Thu, 28 Jul 2022 03:20:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D66B1415118
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:20:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21206801231
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:20:37 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-Rg3jhGZnOQGP_M4xSVnnJA-1; Wed, 27 Jul 2022 23:20:34 -0400
X-MC-Unique: Rg3jhGZnOQGP_M4xSVnnJA-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="319202839"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 11:20:33 +0800
IronPort-SDR: zyEEJZyNlCtxzyj33JK5l5qLa2NnIAP81xcp60gvdD0FdNr8fDABrqcHo/Px3p/84A3ssQ3krr
 hzylMlOq32pDM9yySSw5f1b+3JJbM8KxUpYEqp4Af5bscCMFO/HbEHKGgjoxhMLSN6o8WbBy3Y
 LwuUlJoY4DWRR+P1hztYOpLU/xn4yE0uqLAAi5+VXsBnKUYdJYZXLvm+GDaA07rmAZ+YZGcg9k
 8d6XOwCCzns9eeHwdB2XnSxFl98KM+rw1kcUzTdJhrh/RRxQig86Fu7dv3GnGzCDIRCZ65b1Sl
 JbeAExqcIKnb4xxv2BC5QxhF
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 19:41:44 -0700
IronPort-SDR: beaAbrO4n1a9CMouFMuZr8lYuplHHnv4OYvy8hTdzTy5azkkojmuICjM1ltVEM8DC09WQQL1s+
 Je1YUaJUrJDqqTuEp3ueyxlVHTSUhGm20oidasbFfshLLZ1lBGD2Jfv8qf1mo1QcEIry9vqUds
 sjKqfleY8a23ve1fHupykl+JWS3OfJLj5fX8Le3uFaRjAvQ+f8iRvXwpq/0Vbk/YW9oEpXxNxR
 KA0yHA4lLkRYjgn1naXmXeAeW5YGsrT4V9FO5KGivPf2DMW+GEYBnVUIwNjxgRVl54Dr9cytAS
 wew=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 20:20:33 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LtbWP1RCCz1Rwnx
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 20:20:33 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id lzW-Osya0iGO for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 20:20:32 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LtbWK6WzGz1RtVk;
 Wed, 27 Jul 2022 20:20:29 -0700 (PDT)
Message-ID: <63350fdc-9cc8-3034-c8d6-8dcff50780f4@opensource.wdc.com>
Date: Thu, 28 Jul 2022 12:20:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162254eucas1p1fd990f746d9f9870b8d58ee0bd01fedd@eucas1p1.samsung.com>
 <20220727162245.209794-9-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220727162245.209794-9-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v8 08/11] dm-zone: use generic helpers to
 calculate offset from zone start
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
> Use the bdev_offset_from_zone_start() helper function to calculate
> the offset from zone start instead of using power of 2 based
> calculation.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/md/dm-zone.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 3dafc0e8b7a9..31c16aafdbfc 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -390,7 +390,9 @@ static bool dm_zone_map_bio_begin(struct mapped_device *md,
>  	case REQ_OP_WRITE_ZEROES:
>  	case REQ_OP_WRITE:
>  		/* Writes must be aligned to the zone write pointer */
> -		if ((clone->bi_iter.bi_sector & (zsectors - 1)) != zwp_offset)
> +		if ((bdev_offset_from_zone_start(md->disk->part0,
> +						 clone->bi_iter.bi_sector)) != zwp_offset)
> +
>  			return false;
>  		break;
>  	case REQ_OP_ZONE_APPEND:
> @@ -602,11 +604,8 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
>  		 */
>  		if (clone->bi_status == BLK_STS_OK &&
>  		    bio_op(clone) == REQ_OP_ZONE_APPEND) {
> -			sector_t mask =
> -				(sector_t)bdev_zone_sectors(disk->part0) - 1;
> -
>  			orig_bio->bi_iter.bi_sector +=
> -				clone->bi_iter.bi_sector & mask;
> +				bdev_offset_from_zone_start(disk->part0, clone->bi_iter.bi_sector);
>  		}
>  
>  		return;


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

