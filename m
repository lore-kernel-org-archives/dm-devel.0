Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7802CC3DA7A
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 11:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673002944;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eCHsht8dYwKvkDsVf5Fc/9eQt0TPPWnds1PwXt2VnAY=;
	b=QpOtOx3QpBInftvLJAB1KUJCyDZ9dChPJ7xEfmUC+MaI88oLrlE5xmLhahok+m8/4DeP2x
	FAHQA9OIEr602Ygw4pdSEUts6G36d1sUOn/Nnq8Cn9G3m66slYBjpUUt3eKbINtB1VE+Do
	srRSnH2CZPxXatA9dUwRp44dVf1z63A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-nF44K21qN3i28RiDMVLD1w-1; Fri, 06 Jan 2023 06:02:21 -0500
X-MC-Unique: nF44K21qN3i28RiDMVLD1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 430BD1C0898A;
	Fri,  6 Jan 2023 11:02:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3257DC15BAD;
	Fri,  6 Jan 2023 11:02:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C73919465B9;
	Fri,  6 Jan 2023 11:02:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6DB551946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 11:02:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3FEFB1121318; Fri,  6 Jan 2023 11:02:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3907F1121315
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 11:02:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AB133810788
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 11:02:17 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610--KHaFmocOiewZqhFY2z9rw-1; Fri, 06 Jan 2023 06:02:15 -0500
X-MC-Unique: -KHaFmocOiewZqhFY2z9rw-1
X-IronPort-AV: E=Sophos;i="5.96,305,1665417600"; d="scan'208";a="218433897"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 06 Jan 2023 19:01:10 +0800
IronPort-SDR: iJvsLdQMvh5AXjz212D4h7omUh+FlPOOwPOrbG/aMBacUiTmBWgaUGnD45YtHxOXC1f3t9wSYS
 xc5mJwnNbWgEXmEF4vlCkCY2bWvxBHgIJGB1zVV9g/U41mzDURdo22e+vZSAM6cE8zxCLATAE8
 rlnH0tNcnqlnn9EBlWCrqI0cvIwJ7S063bJUE/Gevk8m4+/DYi++G1rZuTRpdWHxFMlUoOlbQV
 4MDpVpHYSxOx88eIQZDs7AiMH7RYcBHyjaQv3i7AZwBlRgPKrm6SCsQJ1hNDj4D/zghuqQWT7G
 hRw=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jan 2023 02:13:20 -0800
IronPort-SDR: eZ8vaTLRqEjQx3UZCYROVHH6HcuGYW9trb7Gyk1w/5F0OtOJF32B4HcsgzMDIXQ6U/W+X0ihRT
 3ykUwgruO4vvGJDRF5lz6/xvaFi9mV13rayZ2W13TQ2Hd8lCpqvly3hOGJPWhIhGtKCXg5nHnA
 Pnf0Hx+qMaePFbTmczTmLPH6HrmHrwGVNTGurVTd+S2OSvZt5UFVbXXH4WPnxReCP/PUPInFQH
 p9WADwm512mf7G9vWayRC54eYK+6wfcIAkrc0jcBQp0EIyvk0ZYX+jNJaSXUOBe5WApB4fAss0
 7U0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jan 2023 03:01:12 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NpL4622Vnz1Rwrq
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 03:01:10 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id gAkxA4fO8g7k for <dm-devel@redhat.com>;
 Fri,  6 Jan 2023 03:01:09 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NpL436MGRz1RvTp;
 Fri,  6 Jan 2023 03:01:07 -0800 (PST)
Message-ID: <22e12d95-d00d-270d-8119-8587672976a7@opensource.wdc.com>
Date: Fri, 6 Jan 2023 20:01:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083319eucas1p1e58f4ab0d3ff59a328a2da2922d76038@eucas1p1.samsung.com>
 <20230106083317.93938-2-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230106083317.93938-2-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 1/7] block: remove superfluous check for
 request queue in bdev_is_zoned
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
Cc: bvanassche@acm.org, gost.dev@samsung.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/6/23 17:33, Pankaj Raghav wrote:
> Remove the superfluous request queue check in bdev_is_zoned() as the
> bdev_get_queue can never return NULL.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  include/linux/blkdev.h | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 43d4e073b111..0e40b014c40b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1283,12 +1283,7 @@ static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
>  
>  static inline bool bdev_is_zoned(struct block_device *bdev)
>  {
> -	struct request_queue *q = bdev_get_queue(bdev);
> -
> -	if (q)
> -		return blk_queue_is_zoned(q);
> -
> -	return false;
> +	return blk_queue_is_zoned(bdev_get_queue(bdev));
>  }
>  
>  static inline bool bdev_op_is_zoned_write(struct block_device *bdev,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

