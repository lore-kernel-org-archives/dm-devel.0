Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFEBC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 23:39:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-HKfD1RWJO4qqnn5UJ7CLUg-1; Wed, 27 Apr 2022 19:39:37 -0400
X-MC-Unique: HKfD1RWJO4qqnn5UJ7CLUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E055D29AA2ED;
	Wed, 27 Apr 2022 23:39:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CED8B40D1B99;
	Wed, 27 Apr 2022 23:39:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9C27B1947046;
	Wed, 27 Apr 2022 23:39:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 942B51947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 23:39:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 83E2C550868; Wed, 27 Apr 2022 23:39:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F7B655085D
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 23:39:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65FA7101AA44
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 23:39:34 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-NThz70-jM3mckkVeq4YGFA-2; Wed, 27 Apr 2022 19:39:33 -0400
X-MC-Unique: NThz70-jM3mckkVeq4YGFA-2
X-IronPort-AV: E=Sophos;i="5.90,294,1643644800"; d="scan'208";a="303212730"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2022 07:39:31 +0800
IronPort-SDR: IRaQVY9WtESSdGsjZmSm9L4qXGECa93jTWcDWJNaFCbDrbRGvkrz0m8N7QKKz7dG9MkzGlGLmI
 wqf5H16ymmAH65bmk8ohHf42uDtur1u4De8emkryNlaFowc1+hVNkkrTrMEPEB0RraGXyMbZwR
 DGAQXOUs5Uf8S8ce/OJ+CgDRg1WJcx4IVEYMpni2Y1SRtHlTIwSUfbs8Z6RKtEQ0ZoJI7ehpgl
 euhZ6OGPXwT+pe/zpcITlUXUJflY2el7ygG04Lun2luI316+tcV/ZkbVv8AT01iFH8Il58WNV1
 ZA7st5WGgr500kh2CCPl18u4
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 16:10:23 -0700
IronPort-SDR: DlErNgstoCFffa2icIl4768jAX5mn+rrUOzjgfmcMvlVQV0wphmMXIAkAD5SNPrs7sZHagTeyN
 sUqAtZVindPQ9VpVOGEd8pmRkuyv1dyY1QA5s5wiydBwxlD5lzf9v7OM6vKdUcacczWAcWQLq2
 8NQinoie/R7fupM4HCpxLsgL67PWikfWfDhXFnmPP9vtHwKZT/jML1Dwy+cHPIIUw0rlj0aCuW
 VW58nJLJVmblPGfHkivM5N/txYCDepdM9nxCK4n/koHcnoZGqmFUo4eyOYkDjw1yiABRpHaWcZ
 I5M=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Apr 2022 16:39:32 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KpZwL5l5zz1SVp1
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:39:30 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id Jm_xtF5SvtJC for <dm-devel@redhat.com>;
 Wed, 27 Apr 2022 16:39:29 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KpZwF5hMDz1Rvlc;
 Wed, 27 Apr 2022 16:39:25 -0700 (PDT)
Message-ID: <bfc1ddc3-5db3-6879-b6ab-210a00b82c6b@opensource.wdc.com>
Date: Thu, 28 Apr 2022 08:39:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Pankaj Raghav <p.raghav@samsung.com>, jaegeuk@kernel.org,
 axboe@kernel.dk, snitzer@kernel.org, hch@lst.de, mcgrof@kernel.org,
 naohiro.aota@wdc.com, sagi@grimberg.me, dsterba@suse.com,
 johannes.thumshirn@wdc.com
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160309eucas1p2f677c8db581616f994473f17c4a5bd44@eucas1p2.samsung.com>
 <20220427160255.300418-13-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220427160255.300418-13-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 12/16] zonefs: allow non power of 2 zoned
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
> The zone size shift variable is useful only if the zone sizes are known
> to be power of 2. Remove that variable and use generic helpers from
> block layer to calculate zone index in zonefs

Period missing at the end of the sentence.

What about zonefs-tools and its test suite ? Is everything still OK on
that front ? I suspect not...

> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/zonefs/super.c  | 6 ++----
>  fs/zonefs/zonefs.h | 1 -
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 3614c7834007..5422be2ca570 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -401,10 +401,9 @@ static void __zonefs_io_error(struct inode *inode, bool write)
>  {
>  	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>  	struct super_block *sb = inode->i_sb;
> -	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
>  	unsigned int noio_flag;
>  	unsigned int nr_zones =
> -		zi->i_zone_size >> (sbi->s_zone_sectors_shift + SECTOR_SHIFT);
> +		bdev_zone_no(sb->s_bdev, zi->i_zone_size >> SECTOR_SHIFT);
>  	struct zonefs_ioerr_data err = {
>  		.inode = inode,
>  		.write = write,
> @@ -1300,7 +1299,7 @@ static void zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
>  	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
>  	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>  
> -	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
> +	inode->i_ino = bdev_zone_no(sb->s_bdev, zone->start);
>  	inode->i_mode = S_IFREG | sbi->s_perm;
>  
>  	zi->i_ztype = type;
> @@ -1647,7 +1646,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	 * interface constraints.
>  	 */
>  	sb_set_blocksize(sb, bdev_zone_write_granularity(sb->s_bdev));
> -	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
>  	sbi->s_uid = GLOBAL_ROOT_UID;
>  	sbi->s_gid = GLOBAL_ROOT_GID;
>  	sbi->s_perm = 0640;
> diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
> index 7b147907c328..2d5ea3be3a8e 100644
> --- a/fs/zonefs/zonefs.h
> +++ b/fs/zonefs/zonefs.h
> @@ -175,7 +175,6 @@ struct zonefs_sb_info {
>  	kgid_t			s_gid;
>  	umode_t			s_perm;
>  	uuid_t			s_uuid;
> -	unsigned int		s_zone_sectors_shift;
>  
>  	unsigned int		s_nr_files[ZONEFS_ZTYPE_MAX];
>  


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

