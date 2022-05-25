Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAB6AC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 23:14:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-6cuCMX6QPQi7dY12waMLvw-1; Wed, 25 May 2022 19:14:02 -0400
X-MC-Unique: 6cuCMX6QPQi7dY12waMLvw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B72BA101A54E;
	Wed, 25 May 2022 23:14:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 79637492CA2;
	Wed, 25 May 2022 23:13:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 520241932129;
	Wed, 25 May 2022 23:13:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB56F194EB8C
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 23:13:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CCE44C23DC1; Wed, 25 May 2022 23:13:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C8F9BC202D1
 for <dm-devel@redhat.com>; Wed, 25 May 2022 23:13:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DE013C222C2
 for <dm-devel@redhat.com>; Wed, 25 May 2022 23:13:57 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-n8wxLINFMlW_qVtoZyo0WA-1; Wed, 25 May 2022 19:13:55 -0400
X-MC-Unique: n8wxLINFMlW_qVtoZyo0WA-1
X-IronPort-AV: E=Sophos;i="5.91,252,1647273600"; d="scan'208";a="202280927"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 26 May 2022 07:13:55 +0800
IronPort-SDR: rdBRVEJZHOUqsi9nzWJjV9TO3sFlWn9RDx2KTsYt0C1fdke7VD/KAWb/rV3iFGxLT8KRw1itk9
 thM9jRuPAKJQWZlc+p8k9/1HbB6aUVjF851bh2IvzPSbK6j3DeGsHxQm7adWlnLdrLrVx62Y6g
 RmPkHiQhPLYlveH0mbxUgPD2Kjtofp2sTRq02GdS1JvF19XY8+I7zAuJHdKfxVKLHlHKXB0Fqh
 Cx0LQedliqljSp0lUlasOVqv8F75nhpDw9PMUbR+4Ki8xsndu7mZkb+ZplkXMugjgkMGikcXc0
 K2Hne2xlUYi1AL/oYkwAHLgw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 25 May 2022 15:37:49 -0700
IronPort-SDR: /s/XdUcEf6yTbQ6pbAhGIKU4dS8HEJbKoMzStB2qWrgNwD8+HWIatzU7Kh2uLYSzc4OXhpOK3H
 QKMRoG8BWJ5Bl1oyUXKK2EERch4G3C0fGcu0yjTMkKe6qFgeqN24EdL0xNyjnZFtzeCF/20vqE
 pRKIfYxEFUYDPvcK33DzX1T+RcFbg21uOiSar+EY0CwDPKDYqnUjgRdQb/3qhx34HdL5lSI6TK
 Gw9G3TeA7hakBK06rLRFgQHY7MOCQsxDLVb4WYUO19nBJOKVJZj557lMSeT/MBgqZiU6FwPAbr
 Ez4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 25 May 2022 16:13:55 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L7n1s60dnz1Rvlx
 for <dm-devel@redhat.com>; Wed, 25 May 2022 16:13:53 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id k9Z8NNekY491 for <dm-devel@redhat.com>;
 Wed, 25 May 2022 16:13:53 -0700 (PDT)
Received: from [10.225.163.54] (unknown [10.225.163.54])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L7n1p4sHZz1Rvlc;
 Wed, 25 May 2022 16:13:50 -0700 (PDT)
Message-ID: <9703ca4c-33cf-cb3a-b46b-6b0e5537cfd6@opensource.wdc.com>
Date: Thu, 26 May 2022 08:13:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk,
 snitzer@redhat.com, Johannes.Thumshirn@wdc.com, hch@lst.de, hare@suse.de
References: <20220525154957.393656-1-p.raghav@samsung.com>
 <CGME20220525155008eucas1p2c843cc9098f2920e961f80ffaf535789@eucas1p2.samsung.com>
 <20220525154957.393656-9-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220525154957.393656-9-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v6 8/8] dm: ensure only power of 2 zone sizes
 are allowed
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
Cc: gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, dsterba@suse.com,
 jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/26/22 00:49, Pankaj Raghav wrote:
> Ensure that only power of 2 zoned devices are enabled for dm targets that
> supports zoned devices. This constraint can be relaxed once non power of
> 2 zone size support is added to the DM layer.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/md/dm-table.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 03541cfc2317..2a8af70d1d4a 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -251,6 +251,12 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  	if (bdev_is_zoned(bdev)) {
>  		unsigned int zone_sectors = bdev_zone_sectors(bdev);
>  
> +		if (!is_power_of_2(zone_sectors)) {
> +			DMWARN("%s: %pg only power of two zone size supported",
> +			       dm_device_name(ti->table->md), bdev);
> +			return 1;
> +		}
> +
>  		if (start & (zone_sectors - 1)) {
>  			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
>  			       dm_device_name(ti->table->md),

I thought the agreed upon idea is be to add a dm-linear like target to
emulate power of 2 zone size so that we can keep btrfs and f2fs running on
this new class of device. So why this patch ?

The entire series as is will fragment zoned block device support, which is
not a good thing at all. Without the new dm target, none of the current
kernel supported zone stuff will work.

The zonefs patch is also gone from the series. Why ? As is, zonefs will
break if it is passed a non power of 2 zone size drive.

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

