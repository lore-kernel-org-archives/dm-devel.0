Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1B0C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 03:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658978577;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9XSgklYF3A4bFonfqjE0zCKaELlRXU8vi9/5IIg6U98=;
	b=PtdcSOvO/uoJI4DcoxK3U4tzY1KbDiWGNH1+UPtg/VnttWHPwM1z5a0hxFR9Cv63jOQ6IQ
	nqRsJ33t5nzHwjyXk0WCfSWDRmn2KudoJlo2d8/a0rRfeMdM64WJWGcsOgBkacSninHXjs
	Wl/ULkBQA9V+w19OEk+bMbMOAc5hHbU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-5uhjt5WuOhSIDs3XgGQ1JA-1; Wed, 27 Jul 2022 23:22:56 -0400
X-MC-Unique: 5uhjt5WuOhSIDs3XgGQ1JA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67C73101A54E;
	Thu, 28 Jul 2022 03:22:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 57ACC1121319;
	Thu, 28 Jul 2022 03:22:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14FDA1945DAB;
	Thu, 28 Jul 2022 03:22:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E03F81945DA7
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 03:22:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C2335C1D3AD; Thu, 28 Jul 2022 03:22:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE24AC15D4F
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:22:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4C05185A7BA
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:22:52 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-fJR7AyEVOoGLhhOiE14P_w-1; Wed, 27 Jul 2022 23:22:47 -0400
X-MC-Unique: fJR7AyEVOoGLhhOiE14P_w-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="319203047"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 11:22:46 +0800
IronPort-SDR: 2vShwYnWZPH9UgxXyBpPim/WcqfKfwIUqGsp9n/Bv2PvNA/DNkrS7llzYWt9fbTddXTUrUq654
 b5s12TpU9Rl5UyDbw4uB4YBwgN2m7dr2vLU3F7JsgkbViTQAiv0E9Ws/uXX7ywAYo2dbG3uGPL
 O1gKYAiYviuobWCOL2jr8D3sooWuij9yhQCkyG7KHLVbhmkmX9Uj3WND4zICLQOccNoanbmDwL
 uCovWxL9MrDFI24B24MWIgvbvo7n+txVzSjvngIc0/j1HSJyDZZSFtorNRDnZRuPMT9N9aqLzt
 +/CpS15rQ8nnLNEz3XRMTHqg
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 19:38:54 -0700
IronPort-SDR: Af6tYcVmkOsX33d2VlFPXqjrO3JSKzRxT/PqmDUzDQcpSjgd0KSyQkA91eNYWaEMegV54Lmm4M
 EOGAMHNgIg80RGBabCfvOU1XerRRtS8m54rpROlad4eNoyg0kdU2eypAil2NEPat9mZBKdf8wd
 zUNQuoCV2NsTPBzAJHesAtI9PTJiNCQ4thvehbf9LqtbRbXCV7Nz9PzVkIxDJuUVC/LIaOVN5R
 7vJJkVQhqIGauiEDCCLq8gGpw/3RzHajFgh8+W0EuTbfTK8+YZETHhPPdp0Dvfw13mjIiQ5fs5
 /kk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 20:22:46 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LtbYx4zv1z1Rwry
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 20:22:45 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id AjKihD8yo8sz for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 20:22:44 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LtbYt2Q7Fz1RtVk;
 Wed, 27 Jul 2022 20:22:42 -0700 (PDT)
Message-ID: <65a336f0-ecd7-e9d5-2646-37cf9f157d53@opensource.wdc.com>
Date: Thu, 28 Jul 2022 12:22:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162255eucas1p2945c6dca42b799bb3b4abf3edb83dde8@eucas1p2.samsung.com>
 <20220727162245.209794-10-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220727162245.209794-10-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v8 09/11] dm-table: allow non po2 zoned
 devices
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/28/22 01:22, Pankaj Raghav wrote:
> As the block layer now supports non po2 zoned devices, allow dm to
> support non po2 zoned device.

Please rephrase "non po2 zoned devices" here and in the title to correctly
refer to the zone size of zoned devices. Because "non po2 zoned devices"
means absolutely nothing. Let's be clear please.

> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/md/dm-table.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 332f96b58252..534fddfc2b42 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -250,7 +250,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  	if (bdev_is_zoned(bdev)) {
>  		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>  
> -		if (start & (zone_sectors - 1)) {
> +		if (!bdev_is_zone_aligned(bdev, start)) {
>  			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
>  			       dm_device_name(ti->table->md),
>  			       (unsigned long long)start,
> @@ -267,7 +267,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  		 * devices do not end up with a smaller zone in the middle of
>  		 * the sector range.
>  		 */
> -		if (len & (zone_sectors - 1)) {
> +		if (!bdev_is_zone_aligned(bdev, len)) {
>  			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
>  			       dm_device_name(ti->table->md),
>  			       (unsigned long long)len,
> @@ -1642,8 +1642,8 @@ static int validate_hardware_zoned_model(struct dm_table *t,
>  		return -EINVAL;
>  	}
>  
> -	/* Check zone size validity and compatibility */
> -	if (!zone_sectors || !is_power_of_2(zone_sectors))
> +	/* Check zone size validity */

The comment is not super useful now given the trivial test.

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

