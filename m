Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E7AC43334
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656989709;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kZsKIUpqg97qLF5gsBz2Kb9L89KWz0MtvDTp2gR6ZlU=;
	b=Hy5j8etIDkPV4sP3j2BDpZpCsi/RSwGPaVFOFj54PuCWicGKEKeJ4qOAKyzS6yly3pO6LV
	ED3tb5mRz5wv6lOYyXJGcyUdLzufwn+TO1MIxJR4DZxRciCCQ0m94cLSzKmyg5mqoUTYnh
	xofpotrLbCJYuFuoJlwBzidWCAc88wM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-p3jUZWuZMmiTlJ0QanIqCw-1; Mon, 04 Jul 2022 22:55:06 -0400
X-MC-Unique: p3jUZWuZMmiTlJ0QanIqCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CD661C05EB5;
	Tue,  5 Jul 2022 02:55:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3BCF140B40C6;
	Tue,  5 Jul 2022 02:55:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BBAF5194704A;
	Tue,  5 Jul 2022 02:55:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C67A1947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:55:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 201DD40B40C6; Tue,  5 Jul 2022 02:55:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B46340CF8EB
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:55:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 024F12999B52
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:55:03 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-OtjKvCz0PWCAZwR1j7YYDg-1; Mon, 04 Jul 2022 22:55:01 -0400
X-MC-Unique: OtjKvCz0PWCAZwR1j7YYDg-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="205520951"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:55:00 +0800
IronPort-SDR: c/tPgqUWfAXSgRHRpKP6rEcUkXAWp3Q7zF7dXgdahk6pemXoYKVkO3P2ruKU0Y7x8q/qMUu2s4
 zIzGkNvaUpBdwSibAJSHmuEqz+YA4NrHYhPwCYcbfj03m5ao/2FAlxnXVuaRKKkWhcZ0rrqf7f
 /WHGqWcLDOrGc1uLGWhpvracxamODmW1gYZlHWN/qlAy3iGgo7SLy/0HI7mTYolEO+HuKLZ1Fo
 7TAsK5N4omDQG+uFsNVBbvcZmaiCSvMSaIPiBOEL4EU3EJOTStBs6bUst3cEXd4VRh5qcPhYJQ
 przrdEAxfvMKjB/eCKscw/gz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:16:51 -0700
IronPort-SDR: okPGMFpCJsJCn7H3kdjHRwymlxyXkAq2kdwlevDNsrLdpR1N/2c60Uh4EoPdF/Fy047WfQeWi/
 /C2iEMo5Xo68D34Q7D+UENC3kqp5kYHGXvEanqSxFX949U2E7rxAZqb8RmAL59/gmoE7DqteHi
 S0KIIu+UE7PrQFowMEK3N12kF5FygfsnCWabSbGMA8B3B7QvJDwAvzxWKqWcfjTVz/pxNY+2vQ
 ehSa2HyugH45QH8aDxZAFtgIhxji1APdfh4uFdkH+EN4n++Uqe/rNiBvunHTTbh70WPmuTiSiF
 TcE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:55:00 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcS2W6R6tz1Rwnm
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:54:59 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id D8qb8cUpBTCo for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:54:59 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcS2V2zgZz1RtVk;
 Mon,  4 Jul 2022 19:54:58 -0700 (PDT)
Message-ID: <535739b6-ee61-eccb-1dfc-3c57eab21cea@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:54:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-16-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-16-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 15/17] dm-zoned: cleanup dmz_fixup_devices
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:44, Christoph Hellwig wrote:
> Use the bdev based helpers where applicable and move the zoned_dev
> into the scope where it is actually used.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/md/dm-zoned-target.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 6ba6ef44b00e2..95b132b52f332 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -764,8 +764,7 @@ static void dmz_put_zoned_device(struct dm_target *ti)
>  static int dmz_fixup_devices(struct dm_target *ti)
>  {
>  	struct dmz_target *dmz = ti->private;
> -	struct dmz_dev *reg_dev, *zoned_dev;
> -	struct request_queue *q;
> +	struct dmz_dev *reg_dev = NULL;
>  	sector_t zone_nr_sectors = 0;
>  	int i;
>  
> @@ -780,31 +779,32 @@ static int dmz_fixup_devices(struct dm_target *ti)
>  			return -EINVAL;
>  		}
>  		for (i = 1; i < dmz->nr_ddevs; i++) {
> -			zoned_dev = &dmz->dev[i];
> +			struct dmz_dev *zoned_dev = &dmz->dev[i];
> +			struct block_device *bdev = zoned_dev->bdev;
> +
>  			if (zoned_dev->flags & DMZ_BDEV_REGULAR) {
>  				ti->error = "Secondary disk is not a zoned device";
>  				return -EINVAL;
>  			}
> -			q = bdev_get_queue(zoned_dev->bdev);
>  			if (zone_nr_sectors &&
> -			    zone_nr_sectors != blk_queue_zone_sectors(q)) {
> +			    zone_nr_sectors != bdev_zone_sectors(bdev)) {
>  				ti->error = "Zone nr sectors mismatch";
>  				return -EINVAL;
>  			}
> -			zone_nr_sectors = blk_queue_zone_sectors(q);
> +			zone_nr_sectors = bdev_zone_sectors(bdev);
>  			zoned_dev->zone_nr_sectors = zone_nr_sectors;
> -			zoned_dev->nr_zones = bdev_nr_zones(zoned_dev->bdev);
> +			zoned_dev->nr_zones = bdev_nr_zones(bdev);
>  		}
>  	} else {
> -		reg_dev = NULL;
> -		zoned_dev = &dmz->dev[0];
> +		struct dmz_dev *zoned_dev = &dmz->dev[0];
> +		struct block_device *bdev = zoned_dev->bdev;
> +
>  		if (zoned_dev->flags & DMZ_BDEV_REGULAR) {
>  			ti->error = "Disk is not a zoned device";
>  			return -EINVAL;
>  		}
> -		q = bdev_get_queue(zoned_dev->bdev);
> -		zoned_dev->zone_nr_sectors = blk_queue_zone_sectors(q);
> -		zoned_dev->nr_zones = bdev_nr_zones(zoned_dev->bdev);
> +		zoned_dev->zone_nr_sectors = bdev_zone_sectors(bdev);
> +		zoned_dev->nr_zones = bdev_nr_zones(bdev);
>  	}
>  
>  	if (reg_dev) {


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

