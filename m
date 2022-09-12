Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67E67ECAAD5
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970971;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jamXr8quZrda2gm/OeXqwXaoHJv1i7HvaixEeOY243M=;
	b=WaazbWBujq2NjCC1R4il0iLMP2wY31W3ttxWVPlcB4oXIU6qlXhyWrj5IC/QLcs7MQPPAv
	OHGFGKrzSi2ZzumqvK1YCmElk8Ed+5BgvHFDcrKoCoGUC5LPrquN+rIr1Owe3ZUvRp0uVk
	17KYeK1+Sv7LTo7izwJ3hIaC4CA8otQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-W9PzIL4FMIeoZ3LH_VzHZA-1; Mon, 12 Sep 2022 04:22:48 -0400
X-MC-Unique: W9PzIL4FMIeoZ3LH_VzHZA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D8D03810780;
	Mon, 12 Sep 2022 08:22:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4D3704B3FC6;
	Mon, 12 Sep 2022 08:22:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 285131946A43;
	Mon, 12 Sep 2022 08:22:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CAF201946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AE60B140EBF4; Mon, 12 Sep 2022 08:22:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AA4BB140EBF3
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 942FD29AA386
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:44 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-XVmcv-00OdOwk7LqlKPLPQ-1; Mon, 12 Sep 2022 04:22:43 -0400
X-MC-Unique: XVmcv-00OdOwk7LqlKPLPQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082217euoutp0258a3669732d08313bb479922694ae640~UD0GvIISK2358423584euoutp02V
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220912082217euoutp0258a3669732d08313bb479922694ae640~UD0GvIISK2358423584euoutp02V
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220912082214eucas1p1fe9e48688d1aefa40607bc4cc9294b9a~UD0EFzgI90906209062eucas1p1B;
 Mon, 12 Sep 2022 08:22:14 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id B2.56.07817.63CEE136; Mon, 12
 Sep 2022 09:22:14 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220912082213eucas1p239d6095dab9b042f05efd3a6e82bac9c~UD0DkP-K02081220812eucas1p2P;
 Mon, 12 Sep 2022 08:22:13 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220912082213eusmtrp1ae03dc8384dea2e319579ddbafd34d1e~UD0DjXLuz1362513625eusmtrp1G;
 Mon, 12 Sep 2022 08:22:13 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-c9-631eec360d9a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id AF.2F.07473.53CEE136; Mon, 12
 Sep 2022 09:22:13 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082213eusmtip23aaa9f11837ef80f79a5eabca7495574~UD0DIzWiX2847028470eusmtip2Q;
 Mon, 12 Sep 2022 08:22:13 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:21:58 +0200
Message-Id: <20220912082204.51189-8-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djP87pmb+SSDT62ClqsP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFjcmPGW0+Ly0hd1izc2nLBYnbkk7CHlcvuLtsXPWXXaPy2dLPTat6mTz2Lyk
 3mP3zQY2j52t91k93u+7yubRt2UVo8fm09UenzfJebQf6GYK4InisklJzcksSy3St0vgyngw
 IbGgRbBixZ/qBsZJfF2MnBwSAiYS56c3MHUxcnEICaxglFh66R4LhPOFUWJF5112kCohgc+M
 EvP2ScJ0XDtynxWiaDmjxL2fM5khnJeMEld3bgPKcHCwCWhJNHaCNYsIpEt8n/4ObAWzwB0m
 iaZDLxhBEsICrhLTjjWygdSzCKhKfJnnDRLmFbCUWLF9ExvEMnmJmZe+g83hFLCSeL2qlRGi
 RlDi5MwnLCA2M1BN89bZYDdICGzmlJg4YRIzyEwJAReJzin6EHOEJV4d38IOYctInJ7cwwJh
 V0s8vfEbqreFUaJ/53o2iF5rib4zOSAms4CmxPpd+hBRR4n7d2ohTD6JG28FIQ7gk5i0bTrU
 Tl6JjjYhiNlKEjt/PoHaKSFxuWkO1E4PiZu7v7FNYFScheSVWUhemYWwdgEj8ypG8dTS4tz0
 1GKjvNRyveLE3OLSvHS95PzcTYzANHj63/EvOxiXv/qod4iRiYPxEKMEB7OSCC+LoXSyEG9K
 YmVValF+fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkmDk6pBiZvv2WCc1qnXLmw
 MK1camLzByu/lQ4yKS0fXxVKLvHWYpF06dyt1fJNg+n4jdcnzs70a1Lh/cx0sb428a3HgpcF
 /7YUJC5Tv3f96LZIz2LV5vYr9Wad9w69Lsl6InuUSfOohkTGI5afG9aHHuMu7lQ4zuxxISlJ
 KGH2K+dgHjspnhAnxld9sR4zXaR6mQPKxdIf5nl3HToS6FN0dVq8uSPfD8se7isrmRV2N95f
 uW1575R7Dhvlzc/+On6LPXbHvu3rlN82VM+afbosPfRQw7XjHR9F9384cMbr4bxjL/PXpJ9a
 P0kwrG3JselPjfyr+iO+Z9ia+BSabwpj/qVQ/LTt6e7wt8sWdS/6uFhMsl6JpTgj0VCLuag4
 EQCMwpNy8gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t/xe7qmb+SSDWY9U7dYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl/FgQmJBi2DFij/VDYyT+LoYOTkk
 BEwkrh25z9rFyMUhJLCUUeLTrG52iISExO2FTYwQtrDEn2tdbBBFzxklpvbfB0pwcLAJaEk0
 doLViwjkSnxe+QOshlngDZPElyWTmEASwgKuEtOONbKB1LMIqEp8mecNEuYVsJRYsX0TG8R8
 eYmZl76DzeEUsJJ4vaoVbK8QUM3ZbzfYIeoFJU7OfMICYjMD1Tdvnc08gVFgFpLULCSpBYxM
 qxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQLjdtuxn5t3MM579VHvECMTB+MhRgkOZiURXhZD
 6WQh3pTEyqrUovz4otKc1OJDjKZAZ09klhJNzgcmjrySeEMzA1NDEzNLA1NLM2MlcV7Pgo5E
 IYH0xJLU7NTUgtQimD4mDk6pBibPrJqiTu8vglNPPWXWc5lVFBGewDvFVcFDKXXX5/2rBQ5X
 LbrGvsWyJCC54fjc9PO/4j5FP5rLsNDhZ0Xs9q49LDN2lYmKzdE22Ltm3ffldsclLDb8/+97
 WX3byp13LZIuFQhUXFet6T3A+aX36qea6ed72eftNZhu+6gxUEfZes37JZ537n+dKNPafnKJ
 8PzL//ZVG5/mTD0RWnzWeFF2/SnnPa/dG+84OHueKpde8YvjSfsLQ4kTVk63W2SWe2VFFHMx
 /fhxma0mZdHBlccubj2Z4RHT7+xe7SqQ0jnv7byF517EFjJbRi3Ju5ax7kUso3OH6sPtTsWB
 FqoOM1odxG3+3PeoCWD8lbJj7W0lluKMREMt5qLiRAB9lbokZAMAAA==
X-CMS-MailID: 20220912082213eucas1p239d6095dab9b042f05efd3a6e82bac9c
X-Msg-Generator: CA
X-RootMTR: 20220912082213eucas1p239d6095dab9b042f05efd3a6e82bac9c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082213eucas1p239d6095dab9b042f05efd3a6e82bac9c
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082213eucas1p239d6095dab9b042f05efd3a6e82bac9c@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v13 07/13] zonefs: allow non power of 2 zoned
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The zone size shift variable is useful only if the zone sizes are known
to be power of 2. Remove that variable and use generic helpers from
block layer to calculate zone index in zonefs.

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/zonefs/super.c  | 6 ++----
 fs/zonefs/zonefs.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 860f0b1032c6..e549ef16738c 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -476,10 +476,9 @@ static void __zonefs_io_error(struct inode *inode, bool write)
 {
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct super_block *sb = inode->i_sb;
-	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
 	unsigned int noio_flag;
 	unsigned int nr_zones =
-		zi->i_zone_size >> (sbi->s_zone_sectors_shift + SECTOR_SHIFT);
+		bdev_zone_no(sb->s_bdev, zi->i_zone_size >> SECTOR_SHIFT);
 	struct zonefs_ioerr_data err = {
 		.inode = inode,
 		.write = write,
@@ -1401,7 +1400,7 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	int ret = 0;
 
-	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
+	inode->i_ino = bdev_zone_no(sb->s_bdev, zone->start);
 	inode->i_mode = S_IFREG | sbi->s_perm;
 
 	zi->i_ztype = type;
@@ -1776,7 +1775,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	 * interface constraints.
 	 */
 	sb_set_blocksize(sb, bdev_zone_write_granularity(sb->s_bdev));
-	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
 	sbi->s_uid = GLOBAL_ROOT_UID;
 	sbi->s_gid = GLOBAL_ROOT_GID;
 	sbi->s_perm = 0640;
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index 4b3de66c3233..39895195cda6 100644
--- a/fs/zonefs/zonefs.h
+++ b/fs/zonefs/zonefs.h
@@ -177,7 +177,6 @@ struct zonefs_sb_info {
 	kgid_t			s_gid;
 	umode_t			s_perm;
 	uuid_t			s_uuid;
-	unsigned int		s_zone_sectors_shift;
 
 	unsigned int		s_nr_files[ZONEFS_ZTYPE_MAX];
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

