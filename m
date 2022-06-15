Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77012CCA47D
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 11:54:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-HiydyVL9Pz-71jrduVr2BQ-1; Wed, 15 Jun 2022 07:54:10 -0400
X-MC-Unique: HiydyVL9Pz-71jrduVr2BQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D389E83397B;
	Wed, 15 Jun 2022 11:54:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2FAD04010E4D;
	Wed, 15 Jun 2022 11:54:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CBAB71947040;
	Wed, 15 Jun 2022 11:54:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3168819466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 11:54:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 14363492CA6; Wed, 15 Jun 2022 11:54:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EBF7492C3B
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 11:54:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB39319705BD
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 11:54:05 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-I_VDJ6eDMhmXertnhbClSw-1; Wed, 15 Jun 2022 07:54:04 -0400
X-MC-Unique: I_VDJ6eDMhmXertnhbClSw-1
X-IronPort-AV: E=Sophos;i="5.91,302,1647273600"; d="scan'208";a="208073114"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 15 Jun 2022 19:54:02 +0800
IronPort-SDR: //g/vUrqxLyEGi7fV/NEnPvH8jnwuhFSL8q+ARNWyhbQvaK+y54hZPyHXB2PMttBkAekYQXDOG
 M7q2c341EXknA0oorUshJIqV6ildmV8Sh6Dl9oqAp6GHu2iQY5zLwQeeC3vIip+mOyFUwASr6u
 wxpFLmlp8dzlwRnLJoiBna1RbxLeLP709HUlzUgvNwqxUSyXJFpiuuCQwNCzipXRjsHDZi1hYP
 keL1i8Q6nVGfAHppTMa/9/aOODBnVEH2z9PWTkQ7tSR69UhNd8VjcjcQL64xS5UFgca4DJdVfT
 2kJ1iDs//dAKSb6hPAZw7GrR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 15 Jun 2022 04:12:27 -0700
IronPort-SDR: /Dbsmy33KOmByfn048kImMkVRh3WfdYcmrEb/LIfPNausQqmWIgf8Nr25SxWNPBq50cKOS39i2
 vtsFeYAewMIgBzF9ayi+LTkTuFE8Nh+WweBUz+0Herpr3J5QSeCtChWcpdadZ31WKTwzKG9xaL
 j1PG5HF6/Mv3UPmeF7bCX5xdbxrwBpqjjcu449E1fP9BjVpHtpvCjatuHGv9ZYjIO73wE0Ct9s
 KVC2fDnoViGmncHFUedp5ZBdidOgzM3WpPbDm3cJ51v5iva8oP9Frd9YtP5NAt0LnHKgoMxM0f
 +Lg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 15 Jun 2022 04:54:03 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LNNxk365yz1SVp4
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 04:54:02 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id lEfgdOQwyc7E for <dm-devel@redhat.com>;
 Wed, 15 Jun 2022 04:54:01 -0700 (PDT)
Received: from [10.225.163.82] (unknown [10.225.163.82])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LNNxf0Tpcz1Rvlc;
 Wed, 15 Jun 2022 04:53:57 -0700 (PDT)
Message-ID: <064551fa-4575-87cb-d9da-90a34309f634@opensource.wdc.com>
Date: Wed, 15 Jun 2022 20:53:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102000eucas1p27720aaa3c309327b2b9a33c5f840f498@eucas1p2.samsung.com>
 <20220615101920.329421-11-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220615101920.329421-11-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v7 10/13] dm-table: use bdev_is_zone_start
 helper in device_area_is_invalid()
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
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 jonathan.derrick@linux.dev, Johannes.Thumshirn@wdc.com, dsterba@suse.com,
 jaegeuk@kernel.org, Luis Chamberlain <mcgrof@kernel.org>
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

On 6/15/22 19:19, Pankaj Raghav wrote:
> Use bdev_is_zone_start() helper that uses generic calculation to check
> for zone alignment instead of using po2 based alignment check.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/md/dm-table.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index bd539afbf..b553cdb6d 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -251,7 +251,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  	if (bdev_is_zoned(bdev)) {
>  		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>  
> -		if (start & (zone_sectors - 1)) {
> +		if (blk_queue_is_zone_start(bdev_get_queue(bdev), start)) {

This is wrong. And you are changing this to the correct test in the next
patch.

>  			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
>  			       dm_device_name(ti->table->md),
>  			       (unsigned long long)start,
> @@ -268,7 +268,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  		 * devices do not end up with a smaller zone in the middle of
>  		 * the sector range.
>  		 */
> -		if (len & (zone_sectors - 1)) {
> +		if (blk_queue_is_zone_start(bdev_get_queue(bdev), len)) {
>  			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
>  			       dm_device_name(ti->table->md),
>  			       (unsigned long long)len,


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

