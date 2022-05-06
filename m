Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C6FC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  6 May 2022 15:42:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-tkb-N0quNbydbuxhDw9FHg-1; Fri, 06 May 2022 11:42:13 -0400
X-MC-Unique: tkb-N0quNbydbuxhDw9FHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 555E280418C;
	Fri,  6 May 2022 15:42:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CA25E2024CB9;
	Fri,  6 May 2022 15:42:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8981C1947057;
	Fri,  6 May 2022 15:42:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1617C1947056
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 May 2022 15:42:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 012A42024CB9; Fri,  6 May 2022 15:42:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F05CA200C0F4
 for <dm-devel@redhat.com>; Fri,  6 May 2022 15:42:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACEE88002B2
 for <dm-devel@redhat.com>; Fri,  6 May 2022 15:42:03 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-akSBNJ9sMqODZgI9_WP_0w-2; Fri, 06 May 2022 11:42:02 -0400
X-MC-Unique: akSBNJ9sMqODZgI9_WP_0w-2
X-IronPort-AV: E=Sophos;i="5.91,203,1647273600"; d="scan'208";a="199701349"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 06 May 2022 23:41:58 +0800
IronPort-SDR: fbbDzVFg0HbdYcB4cl8CJ3P5zN5pOM/DWzPh8p5blVPz2QhxOj1Hts9xIPFG+QHQ+b7L5e8D6I
 OPRwnQZblpk3eWJawz47lXw6x62jyVuwwXcj334yGgO+x61VYjVHMQ2NVLaW48HuUQhxwcEWDv
 ili7VqUiGgdsHmg+Ivx9SJFRX2TqEsUxmQ0OmhtrCBOQEUmxHh61RH2yQSimSYWGyTylCGvmIq
 c8HGw4N9GDvXrDx0B7GFBpw2AJ6Oe68vt5qO0lmZ0qteKtYuOY//09QIrFt4jh6NMkeJbDi1dl
 gYz3UUs0kwUUXUx7SlQ8a2s1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 May 2022 08:11:36 -0700
IronPort-SDR: tG5dA628doK1QDcFZT/5AZw8z6L5QggPxh3s3MYO1dynbcM+pJc5aA2b6TvW7gEA+I9yP3jJNK
 r1SAiBZTcBeJAPXw61cXhjr5vMPmeQm+L7T4/76fW4wkvmIpuQB+R//IgGjllfWDyXU9idXwJA
 j4vSYpxh93Ayh4j8YpEkPesqrQpNBhGIfQpYfLmes2R1JkFd47evA0IcJtHRO6U68eDpPnBtRW
 yW45TKfiBxzHu1VqdUE0U0qlgtFMgWmM779VeNWVYFdUFC4uI8jJZ5MAmzStLezmyzlb/zBdeR
 BHU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 May 2022 08:41:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KvvvB0d2tz1SVp0
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:41:57 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id k4hGuYgk-DaK for <dm-devel@redhat.com>;
 Fri,  6 May 2022 08:41:56 -0700 (PDT)
Received: from [10.225.103.215] (hn9j2j3.ad.shared [10.225.103.215])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kvvv75djhz1Rvlc;
 Fri,  6 May 2022 08:41:55 -0700 (PDT)
Message-ID: <7f1bd653-6f75-7c0d-9a82-e8992b1476e4@opensource.wdc.com>
Date: Sat, 7 May 2022 00:41:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
To: Pankaj Raghav <p.raghav@samsung.com>, jaegeuk@kernel.org, hare@suse.de,
 dsterba@suse.com, axboe@kernel.dk, hch@lst.de, snitzer@kernel.org
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081118eucas1p17f3c29cc36d748c3b5a3246f069f434a@eucas1p1.samsung.com>
 <20220506081105.29134-12-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220506081105.29134-12-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v3 11/11] dm-zoned: ensure only power of 2
 zone sizes are allowed
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
Cc: Naohiro Aota <naohiro.aota@wdc.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bvanassche@acm.org,
 Luis Chamberlain <mcgrof@kernel.org>, gost.dev@samsung.com,
 Josef Bacik <josef@toxicpanda.com>, linux-nvme@lists.infradead.org,
 jiangbo.365@bytedance.com, Jens Axboe <axboe@fb.com>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, linux-btrfs@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, jonathan.derrick@linux.dev,
 linux-fsdevel@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
 Johannes Thumshirn <jth@kernel.org>, Keith Busch <kbusch@kernel.org>,
 matias.bjorling@wdc.com, Sagi Grimberg <sagi@grimberg.me>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/05/06 17:11, Pankaj Raghav wrote:
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> Today dm-zoned relies on the assumption that you have a zone size
> with a power of 2. Even though the block layer today enforces this
> requirement, these devices do exist and so provide a stop-gap measure
> to ensure these devices cannot be used by mistake
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/md/dm-zone.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 3e7b1fe15..27dc4ddf2 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -231,6 +231,18 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
>  	struct request_queue *q = md->queue;
>  	unsigned int noio_flag;
>  	int ret;
> +	struct block_device *bdev = md->disk->part0;
> +	sector_t zone_sectors;
> +	char bname[BDEVNAME_SIZE];
> +
> +	zone_sectors = bdev_zone_sectors(bdev);
> +
> +	if (!is_power_of_2(zone_sectors)) {
> +		DMWARN("%s: %s only power of two zone size supported\n",
> +		       dm_device_name(md),
> +		       bdevname(bdev, bname));
> +		return 1;

return -EINVAL;

The error propagates to dm_table_set_restrictions() so a proper error code must
be returned.


> +	}
>  
>  	/*
>  	 * Check if something changed. If yes, cleanup the current resources


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

