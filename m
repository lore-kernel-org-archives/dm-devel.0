Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB67EC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 23:32:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-449-2SxsDLJ7PKCU2DEPU0QxqQ-1; Wed, 27 Apr 2022 19:32:03 -0400
X-MC-Unique: 2SxsDLJ7PKCU2DEPU0QxqQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8DDF833962;
	Wed, 27 Apr 2022 23:32:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0DA8840D2828;
	Wed, 27 Apr 2022 23:31:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D6D0D1947046;
	Wed, 27 Apr 2022 23:31:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EBFA91947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 23:31:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C9A682026D64; Wed, 27 Apr 2022 23:31:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C2ACE2011C7B
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 23:31:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF3AB811E7A
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 23:31:45 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-Inf6Yj3gMES4htP-F0Gy-A-2; Wed, 27 Apr 2022 19:31:41 -0400
X-MC-Unique: Inf6Yj3gMES4htP-F0Gy-A-2
X-IronPort-AV: E=Sophos;i="5.90,294,1643644800"; d="scan'208";a="303212385"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 07:31:40 +0800
IronPort-SDR: wcoSwMC8VnVssRLh2/UYb3zfmz0jneVxOPkWAM2c+MnMTcQFPS5QC3NmQNVaXhM5v45MjGaW/p
 Szc+qEb59d97WDYp6Qj7d1ZOJpmUnOnqaS730kqS/WCr81NKgOdLWJsmTdUwb4RsoqV1KyQKzb
 oYrpfpF1jJH9F1DV2UC71l/RxwahHD5QVIarx6G7FSY+Xxq6rfJ8aOlt+Gk9gogRpe2mtm2ysM
 s3aBY+uQPTN9ozOO6IWVgQkLeg+95Avier3nkxz0j6Bdfyz3dfjPBCCbBSuJcUWa45SizVwJxD
 Fb8sipiODU1TOrdidXMMdzes
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 16:02:32 -0700
IronPort-SDR: pZwn4eqbYQ5JcQFERaB9SPjEw3/5adpxxbDGts1YGSKU4Zpts3AZoJmJ7lA4whUMJZH0aZnt6Y
 26/ajRqGAhzSSv5Aldgqo5yn3WsAxQ4SRxKz5nGim/XGf00rA61vIQmhaKuqFW6w7e6WrCkRES
 r/7XyVk1lcyxvD5HHEneQNIaLrOb6eEAuDysrFUrgvClvFS8QK7W7Pfa24nLVP1dlleSj3i008
 U0PpoK+TKRd1+yi/gRI3xMNgQOadSFuUFKrkuPc8Nd/ibxNv3mMViy6yLCdOxjhkjdlg3W/bNg
 Ia8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 16:31:40 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KpZlH2XX1z1SHwl
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:31:39 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id WbJtAoyXf4WE for <dm-devel@redhat.com>;
 Wed, 27 Apr 2022 16:31:38 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KpZlB5PzJz1Rvlc;
 Wed, 27 Apr 2022 16:31:34 -0700 (PDT)
Message-ID: <652c33b5-1d85-e356-05b9-7bd84b768143@opensource.wdc.com>
Date: Thu, 28 Apr 2022 08:31:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Pankaj Raghav <p.raghav@samsung.com>, jaegeuk@kernel.org,
 axboe@kernel.dk, snitzer@kernel.org, hch@lst.de, mcgrof@kernel.org,
 naohiro.aota@wdc.com, sagi@grimberg.me, dsterba@suse.com,
 johannes.thumshirn@wdc.com
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160259eucas1p25aab0637fec229cd1140e6aa08678f38@eucas1p2.samsung.com>
 <20220427160255.300418-4-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220427160255.300418-4-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 03/16] block: add bdev_zone_no helper
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
Cc: jiangbo.365@bytedance.com, kch@nvidia.com, bvanassche@acm.org,
 matias.bjorling@wdc.com, gost.dev@samsung.com, chao@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 clm@fb.com, dm-devel@redhat.com, agk@redhat.com, jonathan.derrick@linux.dev,
 kbusch@kernel.org, linux-fsdevel@vger.kernel.org, josef@toxicpanda.com,
 linux-btrfs@vger.kernel.org
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

On 4/28/22 01:02, Pankaj Raghav wrote:
> Many places in the filesystem for zoned devices open code this function
> to find the zone number for a given sector with power of 2 assumption.
> This generic helper can be used to calculate zone number for a given
> sector in a block device
> 
> This helper internally uses blk_queue_zone_no to find the zone number.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  include/linux/blkdev.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f8f2d2998afb..55293e0a8702 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1392,6 +1392,15 @@ static inline bool bdev_zone_aligned(struct block_device *bdev, sector_t sec)
>  	return false;
>  }
>  
> +static inline unsigned int bdev_zone_no(struct block_device *bdev, sector_t sec)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (q)

q is never NULL. So this can be simplified to:

	return blk_queue_zone_no(bdev_get_queue(bdev), sector);

> +		return blk_queue_zone_no(q, sec);
> +	return 0;
> +}
> +
>  static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
>  {
>  	struct request_queue *q = bdev_get_queue(bdev);


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

