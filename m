Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F57C3DA7A
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 11:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673003199;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TEXcyL2rBGb42hXWjSL/4UQpOBPQwxPyj1C4Jx1dv3A=;
	b=IcFFbWnxiOWui4/QPAsnpxmn4IBRDN3gH2ZC+FX4y70QHIPq/1bmGacv1Jjrx1149PMOxn
	JcN8XJXRHyPe2B4vwu/Y5zI4jzqZIoy/HGwPLUG9UE95WmdbAoRIy1Uq/PvgyMjk7bQ6n4
	7eCW6XV/kciksq3mDjyKQdCsgfVMf8o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-tzBiAf_mPouh1oTYmo5Peg-1; Fri, 06 Jan 2023 06:06:37 -0500
X-MC-Unique: tzBiAf_mPouh1oTYmo5Peg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A77B8100F904;
	Fri,  6 Jan 2023 11:06:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 348B7492C1B;
	Fri,  6 Jan 2023 11:06:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C81EB19465B9;
	Fri,  6 Jan 2023 11:06:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32BC01946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 11:06:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2266D40C2004; Fri,  6 Jan 2023 11:06:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A5EB40C2064
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 11:06:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3FC73C0D843
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 11:06:32 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-PHyNlalZNwaTrPykiuJdeQ-1; Fri, 06 Jan 2023 06:06:31 -0500
X-MC-Unique: PHyNlalZNwaTrPykiuJdeQ-1
X-IronPort-AV: E=Sophos;i="5.96,305,1665417600"; d="scan'208";a="332177095"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 06 Jan 2023 19:05:26 +0800
IronPort-SDR: +EpT6n96syHHAXuiK0vUp5fCKkEIhidvtrjgfkIaX8mjsWbPhxeLdzaZ9PJh9czoCa/+pPv2b0
 GT3K+5qpYJPmU7RElZk3JVpNmsJ27Z0VRWFZGKo891oCxZd7aW3sSV43TTEiTlNHH4zkFR8sG5
 Trjc2AIqfEiMXkLa5QNKr9GU1en25lp/jrkWL8dybgFhiZjKCs8E8J9ZAe6I8aCVaBU7pxvjKE
 CZLbcIUJy6xUu3v2eln7BdkLvqmlXLalF0DnSNG0d8ePFag2rnRCCPnmHOPvfCu35LwR82l194
 U54=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jan 2023 02:23:21 -0800
IronPort-SDR: ZNN5I+uj/tcf9MyKhh296WZaaCCB46sTfXu7O8PEIrnEccpdAlzUlmNFdrH1Iz7zzIdKQZ7Pw1
 zfAPg2tDeEhaKvpQ8rUzKXPo+nSt/6FYKiFNxKAwz0kxz0HC7BrYE501fcGId66QVQ/4ibLS8I
 5aBnuTE3Y+6lfLnYJ6s/7BLClJRLXEU/mrObWw1UUq9jP5O+UB3OafRCnnGQXGxgX/pNl5eJcE
 algV0u8btNV04+o6D6UmIyDKrV/p9/U3D8YIb1D+cjrkJh+AnFJjZm/9kJIIYypx9w8MBpXrLY
 FXc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jan 2023 03:05:26 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NpL92441Tz1RvTp
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 03:05:26 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 1FrIvf8-MczI for <dm-devel@redhat.com>;
 Fri,  6 Jan 2023 03:05:25 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NpL8z4YCqz1RvLy;
 Fri,  6 Jan 2023 03:05:23 -0800 (PST)
Message-ID: <c9cdd392-f4b6-1500-30b5-7a04bdf83786@opensource.wdc.com>
Date: Fri, 6 Jan 2023 20:05:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To: Pankaj Raghav <p.raghav@samsung.com>, axboe@kernel.dk
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083321eucas1p15e9087bcc62bc6a4f5a61467e1c98698@eucas1p1.samsung.com>
 <20230106083317.93938-5-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230106083317.93938-5-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 4/7] zonefs: use bdev_zone_no helper to
 calculate the zone index
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
Cc: bvanassche@acm.org, gost.dev@samsung.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/6/23 17:33, Pankaj Raghav wrote:
> Use bdev_zone_no() helper instead of opencoding the logic to find the
> zone index.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/zonefs/super.c  | 8 +++-----
>  fs/zonefs/zonefs.h | 1 -
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 2c53fbb8d918..c2ddc62e99dc 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -487,7 +487,6 @@ static void __zonefs_io_error(struct inode *inode, bool write)
>  {
>  	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>  	struct super_block *sb = inode->i_sb;
> -	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
>  	unsigned int noio_flag;
>  	unsigned int nr_zones = 1;
>  	struct zonefs_ioerr_data err = {
> @@ -502,8 +501,8 @@ static void __zonefs_io_error(struct inode *inode, bool write)
>  	 * size is always larger than the device zone size.
>  	 */
>  	if (zi->i_zone_size > bdev_zone_sectors(sb->s_bdev))
> -		nr_zones = zi->i_zone_size >>
> -			(sbi->s_zone_sectors_shift + SECTOR_SHIFT);
> +		nr_zones =
> +			bdev_zone_no(sb->s_bdev, zi->i_zone_size >> SECTOR_SHIFT);

This is a number of zones, not a zone number. So this at least needs a
comment to make clear. Otherwise, I find this confusing.

I would also prefer you hold on this patch. I am about to post a big
series reworking many things in zonefs. That will conflict.

>  
>  	/*
>  	 * Memory allocations in blkdev_report_zones() can trigger a memory
> @@ -1420,7 +1419,7 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
>  	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>  	int ret = 0;
>  
> -	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
> +	inode->i_ino = bdev_zone_no(sb->s_bdev, zone->start);
>  	inode->i_mode = S_IFREG | sbi->s_perm;
>  
>  	zi->i_ztype = type;
> @@ -1804,7 +1803,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	 * interface constraints.
>  	 */
>  	sb_set_blocksize(sb, bdev_zone_write_granularity(sb->s_bdev));
> -	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
>  	sbi->s_uid = GLOBAL_ROOT_UID;
>  	sbi->s_gid = GLOBAL_ROOT_GID;
>  	sbi->s_perm = 0640;
> diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
> index 1dbe78119ff1..703bc4505b29 100644
> --- a/fs/zonefs/zonefs.h
> +++ b/fs/zonefs/zonefs.h
> @@ -179,7 +179,6 @@ struct zonefs_sb_info {
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

