Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5A8C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 11:01:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-QkjPq-M8PNOIXel-RXbNcA-1; Wed, 15 Jun 2022 07:01:50 -0400
X-MC-Unique: QkjPq-M8PNOIXel-RXbNcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FEDC811E80;
	Wed, 15 Jun 2022 11:01:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 849001415106;
	Wed, 15 Jun 2022 11:01:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5405A1947040;
	Wed, 15 Jun 2022 11:01:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 975D019466DF
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 11:01:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57EA140334F; Wed, 15 Jun 2022 11:01:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 53543401E68
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 11:01:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ADAE185A7B2
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 11:01:46 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-USq0RiDBMaePjQ7U6_tDRQ-1; Wed, 15 Jun 2022 07:01:44 -0400
X-MC-Unique: USq0RiDBMaePjQ7U6_tDRQ-1
X-IronPort-AV: E=Sophos;i="5.91,302,1647273600"; d="scan'208";a="208069838"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 15 Jun 2022 19:01:41 +0800
IronPort-SDR: 0K3bD6rZB7Ba1fW2RSy11Zas/Q7BAQN/hs8DMHogb4Bto7u7J++WmWhVC5EkrHb9DaICzbOHQx
 MVdzCChoqYI0eyI9596DI4qsIcW05ENTtZODblBi7W5rK4Cc5d2cWXGCAMXEyCjHyqFq4HUi+0
 PS+N5sPBwcnk5tTz9Ol1j3nJ+du75sa9EP3IWS/staBVOsfgIjx1M7MGS02RyhZ23vEBK4ArrG
 iq00x6Mvc9kq+rfvqOO9x0ghpdSsO3bpIheraY0fXM+IsV4V7qA9TZHPbkIva1br8kmD2VM73k
 wXI0Tm1GI4fCDgjAGfL0Do4c
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 15 Jun 2022 03:24:33 -0700
IronPort-SDR: dRwt6Txa2iNTltpnmWvsjQStV43XGMFfuW+vfbeireRE9F3UkbDA+NWBJNWDEYLADm5n+nPL5L
 tHgY9Cj6IktJCRY7w3QUSU6Q/pW42Bzh9P8nj1qxvUQoHbC9D08LCdIltykxp5Yb4qI4ojaEEw
 QieXjZyZheu1L0EIKZXF2hghDeTC2LxKbO9gmHFy2ABPf7h/7No0G2A//5pHCibMDnJLlESy4z
 i0KV6HX1IYxff1hmoONu/jZsN3c9Ddryeaw2/VTD+GpFeECfnWwGSfC/t5OGvginZfHxIBqpCM
 Rdw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 15 Jun 2022 04:01:42 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LNMnK5nR5z1Rwrw
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 04:01:41 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id CEz4siVbDUOy for <dm-devel@redhat.com>;
 Wed, 15 Jun 2022 04:01:40 -0700 (PDT)
Received: from [10.225.163.82] (unknown [10.225.163.82])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LNMnG1fD0z1Rvlc;
 Wed, 15 Jun 2022 04:01:38 -0700 (PDT)
Message-ID: <f7b586a3-5370-f3b9-72dc-f9bea0b63f1f@opensource.wdc.com>
Date: Wed, 15 Jun 2022 20:01:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102007eucas1p1106f9520e2a86beb3792107dffd8071b@eucas1p1.samsung.com>
 <20220615101920.329421-13-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220615101920.329421-13-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v7 12/13] dm: call dm_zone_endio after the
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
 jiangbo.365@bytedance.com, linux-block@vger.kernel.org, dm-devel@redhat.com,
 jonathan.derrick@linux.dev, Johannes.Thumshirn@wdc.com, dsterba@suse.com,
 jaegeuk@kernel.org
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

On 6/15/22 19:19, Pankaj Raghav wrote:
> dm_zone_endio() updates the bi_sector of orig bio for zoned devices that
> uses either native append or append emulation and it is called before the
> endio of the target. But target endio can still update the clone bio
> after dm_zone_endio is called, thereby, the orig bio does not contain
> the updated information anymore. Call dm_zone_endio for zoned devices
> after calling the target's endio function
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
> @Damien and @Hannes: I couldn't come up with a testcase that uses endio callback and
> zone append or append emulation for zoned devices to test for
> regression in this change. It would be great if you can suggest
> something. This change is required for the npo2 target as we update the
> clone bio sector in the endio callback function and the orig bio should
> be updated only after the endio callback for zone appends.

Running zonefs tests on top of dm-crypt will exercise DM zone append
emulation.

> 
>  drivers/md/dm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3f17fe1de..3a74e1038 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1025,10 +1025,6 @@ static void clone_endio(struct bio *bio)
>  			disable_write_zeroes(md);
>  	}
>  
> -	if (static_branch_unlikely(&zoned_enabled) &&
> -	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))
> -		dm_zone_endio(io, bio);
> -
>  	if (endio) {
>  		int r = endio(ti, bio, &error);
>  		switch (r) {
> @@ -1057,6 +1053,10 @@ static void clone_endio(struct bio *bio)
>  		}
>  	}
>  
> +	if (static_branch_unlikely(&zoned_enabled) &&
> +	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))

blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))) ->
bdev_is_zoned(bio->bi_bdev)

> +		dm_zone_endio(io, bio);
> +
>  	if (static_branch_unlikely(&swap_bios_enabled) &&
>  	    unlikely(swap_bios_limit(ti, bio)))
>  		up(&md->swap_bios_semaphore);


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

