Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3955DC00140
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660151552;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TDvJlBH8p+/UoNoUMHs/LgcVJm46b0jP83PRQtugCho=;
	b=c17YX8gKsNBnaUyIbXepyW0wAF/dzr05Mkxfwa8OpCQS8zCSmpCfZmJqJGrSau3Q3aLsOg
	hDFPtOEM5sFAzX1JbWhg0/E8EPUzmRp24xQS43lWAOwZlD+QSD6fwLBURAwyBEBL0aLkx/
	Lnbe/xD29LSquj2ibmDmvPqe4XuVk8g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-p7g0VHjdOOm6BYQgQfkA7g-1; Wed, 10 Aug 2022 13:12:30 -0400
X-MC-Unique: p7g0VHjdOOm6BYQgQfkA7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 685978039BA;
	Wed, 10 Aug 2022 17:12:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 555DC404754B;
	Wed, 10 Aug 2022 17:12:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 04BB51946A50;
	Wed, 10 Aug 2022 17:12:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C1ADA1946A4F
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 17:12:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9B720400DFA6; Wed, 10 Aug 2022 17:12:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 97A9040CF8E8
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 17:12:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EB2D804196
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 17:12:26 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-5sKc5q3EPEy56UBP_zTmHw-2; Wed, 10 Aug 2022 13:12:24 -0400
X-MC-Unique: 5sKc5q3EPEy56UBP_zTmHw-2
X-IronPort-AV: E=Sophos;i="5.93,227,1654531200"; d="scan'208";a="213384932"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2022 01:12:21 +0800
IronPort-SDR: QlRJjm5AJTWLPQ0BZBCNhOkp0L8hNz/cP5dhj9n421W9DSzbNeg8nNiN0Yt1tDt8nNmJYe25Ac
 kNIs37rs1upOBQJ2DwnJNnrGuXM0+Kc7ma/vbJEM7SPluVdx4oTy5DFAOGhyVAyAR7X6ApgfN2
 kes/cd17cWnDs9bk0Dryv51IZRkAvtjlnqfZKzGVACbc7tJYSUrcnEEN5VZkul2T1rEXSRvWpa
 t9e/hzKp/OevpBayFcHDqmzR/fLeOtrNMa34gIQnkDEUjY4HFdft3YUdTg0HP+np+0nDcX6zKr
 jtobi0dY34wqGdWUyWXV+3GW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 09:27:58 -0700
IronPort-SDR: rp45LNAGCC/R6dU//INEpEcYp4DgD/Om77RISI4/jTc2GdQqR5684AteyFJ5b15U8kuYFfFsON
 NIgwL5rTrhA997AWv4l9yWn9bcFT6Ody46lwFS66JhY3aS8cp2EHOlFRQGSlbcbws5OEtsHnrT
 bA5pAWKBLa0HjZuR2DjeusZGOBMe3NfpK5vCVWws0/ch2aIaMTFOdltKJm6IicENzM/h3+6lTK
 oo06MET1hjFn/af43J9Nr5rrHAtq/b39I4GXqcggh9gWHqUDKWg6hhZ4Dud6zudKmtu3s62jNd
 Hlg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Aug 2022 10:12:23 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4M2xM965Zsz1Rwqy
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 10:12:21 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 9b77zOLH-Ar9 for <dm-devel@redhat.com>;
 Wed, 10 Aug 2022 10:12:20 -0700 (PDT)
Received: from [10.111.68.99] (c02drav6md6t.sdcorp.global.sandisk.com
 [10.111.68.99])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4M2xM81DwYz1RtVk;
 Wed, 10 Aug 2022 10:12:20 -0700 (PDT)
Message-ID: <40e8f0b2-0bf1-3859-cb97-4da2d34eeab2@opensource.wdc.com>
Date: Wed, 10 Aug 2022 10:12:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
To: Pankaj Raghav <p.raghav@samsung.com>, Johannes.Thumshirn@wdc.com,
 snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094813eucas1p2eab78901e97417ad52be1f8023db3d82@eucas1p2.samsung.com>
 <20220803094801.177490-11-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220803094801.177490-11-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v9 10/13] dm-table: allow zoned devices with
 non power-of-2 zone sizes
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/08/03 2:47, Pankaj Raghav wrote:
> Allow dm to support zoned devices with non power-of-2(po2) zone sizes as
> the block layer now supports it.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/md/dm-table.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 332f96b58252..31eb1d29d136 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -250,7 +250,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  	if (bdev_is_zoned(bdev)) {
>  		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>  
> -		if (start & (zone_sectors - 1)) {
> +		if (!bdev_is_zone_start(bdev, start)) {
>  			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
>  			       dm_device_name(ti->table->md),
>  			       (unsigned long long)start,
> @@ -267,7 +267,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  		 * devices do not end up with a smaller zone in the middle of
>  		 * the sector range.
>  		 */
> -		if (len & (zone_sectors - 1)) {
> +		if (!bdev_is_zone_start(bdev, len)) {
>  			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
>  			       dm_device_name(ti->table->md),
>  			       (unsigned long long)len,
> @@ -1642,8 +1642,7 @@ static int validate_hardware_zoned_model(struct dm_table *t,
>  		return -EINVAL;
>  	}
>  
> -	/* Check zone size validity and compatibility */
> -	if (!zone_sectors || !is_power_of_2(zone_sectors))
> +	if (!zone_sectors)
>  		return -EINVAL;
>  
>  	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

