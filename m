Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18842C04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 03:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658978191;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OA5n4oWaZldohV2X4x3+lLxf0D1pGANcOpzjXsOyOVQ=;
	b=BnSTcumlpIP6uN6NEGfMQLuFjcjNjamA6eFpQxEFsYZnLwP8NdVv7kodojzjy5RUsQsixG
	hPhruzGcEvokSg/qoYRx6Jv7ZE8cEMeCga7WGOGV9jWqFf34lVgV13TzWewDzKE83lTzQ8
	LqhTURKGaelVHN1Gsynj5L94MyLU75U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-SSCcRqIHMfqisJITlnVC_A-1; Wed, 27 Jul 2022 23:16:27 -0400
X-MC-Unique: SSCcRqIHMfqisJITlnVC_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17ED6185A7A4;
	Thu, 28 Jul 2022 03:16:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0785A2026D64;
	Thu, 28 Jul 2022 03:16:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D156E1945DAC;
	Thu, 28 Jul 2022 03:16:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DB16B1945DAB
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 03:16:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BCD6A2166B29; Thu, 28 Jul 2022 03:16:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B84F42166B26
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:16:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C9BC8032F0
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 03:16:24 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-61Lk54nIMeahsx6dmM5VAA-1; Wed, 27 Jul 2022 23:16:19 -0400
X-MC-Unique: 61Lk54nIMeahsx6dmM5VAA-1
X-IronPort-AV: E=Sophos;i="5.93,196,1654531200"; d="scan'208";a="212066997"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 28 Jul 2022 11:16:17 +0800
IronPort-SDR: w4QJAx3xPF/siYsC9I4m8kl7+iyJcJlotGWVoiPSlJj6e2VyeADNVjBAk0bmsstXDN7oX4q9w5
 CWViUv5XYpuyZdiG3YiAjwCeHOjjbHabQyMmYLyYhD0SMfSodi5Xv0/iRJ1u2WE4vn+bz+XhL8
 WYagCE7sy3uqi5MV9N0ElPKHnIiwsLPaV9Qnsi/rYnpIiXdZ+6xPQZbez8U0sr/uU5E3ieu6/g
 XZrNmD/tnfc6PkSQ8O28JpTlB49T+OufSXY3e3+B8UX9MFc8CrKmk17PaXh+mLet1LfcVfTNqW
 Ph00rsINFDwqqN6JeUnc0KT3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 19:37:28 -0700
IronPort-SDR: feCYCmxxzm91VXXNRSLULnEAd0WatuCK9Q6glhW2/hMq/iwMb5ECA6zG9F2kMOHmCsLJA17Cq8
 PWCvmEeV9LSah7jlDlv0dEmjY54L8do+tfYOpdKXbB+AdTqjO+y4xWrHA8/6o9ftLfB2lXht/a
 h6vCRuBn2lum2+Tj5z89k0xjzMzTMdKHUcGHypM0NSQA2ogUXzoAJ1VAP4vhsXMhsMHiG/7QEf
 BA02tUSyY1/Bjg/1t7R6bBKiX8LACaCbGv3UsPS1ig1HYr3KNGxaeHTZXvp266IBp7NvlTRJei
 IZE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 27 Jul 2022 20:16:19 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LtbQT2qbqz1Rwqy
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 20:16:17 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id oAdeEXblSKW4 for <dm-devel@redhat.com>;
 Wed, 27 Jul 2022 20:16:15 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LtbQP5Dsvz1RtVk;
 Wed, 27 Jul 2022 20:16:13 -0700 (PDT)
Message-ID: <cf96b0e4-dbb1-350b-602b-a72682fca2fb@opensource.wdc.com>
Date: Thu, 28 Jul 2022 12:16:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162252eucas1p25be8b79231334fa0c759c2475859e93b@eucas1p2.samsung.com>
 <20220727162245.209794-7-p.raghav@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220727162245.209794-7-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v8 06/11] zonefs: allow non power of 2 zoned
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
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
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

On 7/28/22 01:22, Pankaj Raghav wrote:
> The zone size shift variable is useful only if the zone sizes are known
> to be power of 2. Remove that variable and use generic helpers from
> block layer to calculate zone index in zonefs.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  fs/zonefs/super.c  | 6 ++----
>  fs/zonefs/zonefs.h | 1 -
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 860f0b1032c6..e549ef16738c 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -476,10 +476,9 @@ static void __zonefs_io_error(struct inode *inode, bool write)
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
> @@ -1401,7 +1400,7 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
>  	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>  	int ret = 0;
>  
> -	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
> +	inode->i_ino = bdev_zone_no(sb->s_bdev, zone->start);
>  	inode->i_mode = S_IFREG | sbi->s_perm;
>  
>  	zi->i_ztype = type;
> @@ -1776,7 +1775,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	 * interface constraints.
>  	 */
>  	sb_set_blocksize(sb, bdev_zone_write_granularity(sb->s_bdev));
> -	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
>  	sbi->s_uid = GLOBAL_ROOT_UID;
>  	sbi->s_gid = GLOBAL_ROOT_GID;
>  	sbi->s_perm = 0640;
> diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
> index 4b3de66c3233..39895195cda6 100644
> --- a/fs/zonefs/zonefs.h
> +++ b/fs/zonefs/zonefs.h
> @@ -177,7 +177,6 @@ struct zonefs_sb_info {
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

