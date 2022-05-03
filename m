Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A54C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  3 May 2022 20:05:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-uw_vMWy_POy4owvDgDGNlQ-1; Tue, 03 May 2022 16:05:05 -0400
X-MC-Unique: uw_vMWy_POy4owvDgDGNlQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F5D429AB3E2;
	Tue,  3 May 2022 20:05:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E23240D2820;
	Tue,  3 May 2022 20:05:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D1F281947049;
	Tue,  3 May 2022 20:05:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A2E81947043
 for <dm-devel@listman.corp.redhat.com>; Tue,  3 May 2022 20:04:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EEDDB5517C8; Tue,  3 May 2022 20:04:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EAFF855119C
 for <dm-devel@redhat.com>; Tue,  3 May 2022 20:04:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3BD8811E76
 for <dm-devel@redhat.com>; Tue,  3 May 2022 20:04:58 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-HFW9IQfhMU-Wpu5-B_as_A-1; Tue, 03 May 2022 16:04:13 -0400
X-MC-Unique: HFW9IQfhMU-Wpu5-B_as_A-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 3137CB82061;
 Tue,  3 May 2022 20:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F65C385A4;
 Tue,  3 May 2022 20:04:10 +0000 (UTC)
Date: Tue, 3 May 2022 13:04:08 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Message-ID: <YnGKuET79JQ+ssPp@google.com>
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160311eucas1p151141fc73adc590b40ad6f935b1ac214@eucas1p1.samsung.com>
 <20220427160255.300418-15-p.raghav@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220427160255.300418-15-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 14/16] f2fs: call bdev_zone_sectors() only
 once on init_blkz_info()
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
Cc: jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, hch@lst.de, agk@redhat.com, naohiro.aota@wdc.com,
 sagi@grimberg.me, gost.dev@samsung.com, damien.lemoal@opensource.wdc.com,
 jonathan.derrick@linux.dev, kch@nvidia.com, chao@kernel.org,
 snitzer@kernel.org, josef@toxicpanda.com, linux-block@vger.kernel.org,
 dsterba@suse.com, kbusch@kernel.org, matias.bjorling@wdc.com,
 bvanassche@acm.org, axboe@kernel.dk, johannes.thumshirn@wdc.com,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Applied to f2fs tree. Thanks,

On 04/27, Pankaj Raghav wrote:
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> Instead of calling bdev_zone_sectors() multiple times, call
> it once and cache the value locally. This will make the
> subsequent change easier to read.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/f2fs/super.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index ea939db18f88..f64761a15df7 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -3678,22 +3678,25 @@ static int init_blkz_info(struct f2fs_sb_info *sbi, int devi)
>  	struct block_device *bdev = FDEV(devi).bdev;
>  	sector_t nr_sectors = bdev_nr_sectors(bdev);
>  	struct f2fs_report_zones_args rep_zone_arg;
> +	u64 zone_sectors;
>  	int ret;
>  
>  	if (!f2fs_sb_has_blkzoned(sbi))
>  		return 0;
>  
> +	zone_sectors = bdev_zone_sectors(bdev);
> +
>  	if (sbi->blocks_per_blkz && sbi->blocks_per_blkz !=
> -				SECTOR_TO_BLOCK(bdev_zone_sectors(bdev)))
> +				SECTOR_TO_BLOCK(zone_sectors))
>  		return -EINVAL;
> -	sbi->blocks_per_blkz = SECTOR_TO_BLOCK(bdev_zone_sectors(bdev));
> +	sbi->blocks_per_blkz = SECTOR_TO_BLOCK(zone_sectors);
>  	if (sbi->log_blocks_per_blkz && sbi->log_blocks_per_blkz !=
>  				__ilog2_u32(sbi->blocks_per_blkz))
>  		return -EINVAL;
>  	sbi->log_blocks_per_blkz = __ilog2_u32(sbi->blocks_per_blkz);
>  	FDEV(devi).nr_blkz = SECTOR_TO_BLOCK(nr_sectors) >>
>  					sbi->log_blocks_per_blkz;
> -	if (nr_sectors & (bdev_zone_sectors(bdev) - 1))
> +	if (nr_sectors & (zone_sectors - 1))
>  		FDEV(devi).nr_blkz++;
>  
>  	FDEV(devi).blkz_seq = f2fs_kvzalloc(sbi,
> -- 
> 2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

