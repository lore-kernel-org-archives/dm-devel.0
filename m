Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B4BC6FA82
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 09:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663665107;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kpxQJpQMe3cETRILIpabL+z4fJiDnp9euPjmnoYojlE=;
	b=G+RGM4A1n3Efafw2XcPOth/ETIf8gbGLprcE9OMzoPlaVPHeOe0lCAse59NCFZhH3Smib6
	fo8NstWTddghTYJM2lB0KQ0DLCgDQsaz616jrIG4PhZZlu1JY8kMt5L4ORnANYXTFzMYzy
	D6tZv9FRhix0XOehTkENLMXK6903RnA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-XyzmuPmQNdqYG1dqs4bDoQ-1; Tue, 20 Sep 2022 05:11:38 -0400
X-MC-Unique: XyzmuPmQNdqYG1dqs4bDoQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDED33C0D847;
	Tue, 20 Sep 2022 09:11:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDD581121314;
	Tue, 20 Sep 2022 09:11:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AFA3A19465A3;
	Tue, 20 Sep 2022 09:11:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 566C919465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 09:11:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 481622166B36; Tue, 20 Sep 2022 09:11:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 401982166B2E
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22C0C83394D
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:35 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-OJcUcth8ONiIdR1K0Bz5YQ-1; Tue, 20 Sep 2022 05:11:31 -0400
X-MC-Unique: OJcUcth8ONiIdR1K0Bz5YQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220920091130euoutp0269f7b6025c2af54be7a07bac1042f898~WhpXPeTEd2699126991euoutp02I
 for <dm-devel@redhat.com>; Tue, 20 Sep 2022 09:11:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220920091130euoutp0269f7b6025c2af54be7a07bac1042f898~WhpXPeTEd2699126991euoutp02I
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220920091128eucas1p2ab112bba0a3f4a149aac7d36c114aad5~WhpVZe2_x1342313423eucas1p2P;
 Tue, 20 Sep 2022 09:11:28 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id B8.98.19378.0C389236; Tue, 20
 Sep 2022 10:11:28 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220920091127eucas1p252a2edaae00ff379bc6f9fbcc2791487~WhpUzhpm01764517645eucas1p28;
 Tue, 20 Sep 2022 09:11:27 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220920091127eusmtrp10e93ece4d54c44a424c3150da44ebb76~WhpUynYVV0212802128eusmtrp1b;
 Tue, 20 Sep 2022 09:11:27 +0000 (GMT)
X-AuditID: cbfec7f5-a35ff70000014bb2-c0-632983c08a0f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id D6.53.10862.FB389236; Tue, 20
 Sep 2022 10:11:27 +0100 (BST)
Received: from localhost (unknown [106.210.248.192]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220920091127eusmtip2e02176de341f10041ea4709d5e83230e~WhpUdx1WJ3037630376eusmtip2M;
 Tue, 20 Sep 2022 09:11:27 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 20 Sep 2022 11:11:13 +0200
Message-Id: <20220920091119.115879-8-p.raghav@samsung.com>
In-Reply-To: <20220920091119.115879-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Sf1CTZRz3ed/t3cu6rZd3dj6ipszMhgQW/vGEXRFi996pJ/2jd+Kla7w3
 oP2Aja1MKwyihgUcnsIG4g4hlIGzATuHQUAK6NitGkuGRx4duxJz1M1drIXFePHyv8/z+fH9
 fL93D4nTD/hJZKGmlNVp5CopIeQ5R6LeFwfLZYrtp300st8awZFtuoZAZ/+I4ijm8eKoP9TI
 R4FBF4a+aanD0CXbDQzN2i04Wqz6GUNBvwVD/VPbkK+viUDnvwoKUG1lBEeTtUGAwm0VAtQZ
 CPLQ2NS6LAnjm9jDuCzTAsbnMTCODhPBdLd+zFwLlBHMl+UhgnF9epfPzA/4Caa6pwMw3e7j
 TNjxLPPZ4CksV3RI+Go+qyo0srr0144KC8YWwljxw8T3feFKQRlYEFeBBBJSO+DYRANWBYQk
 TV0EcOLf3/C4QFMPAez5J48TwgDebr4JHie8LR18TmgH0DTr4nGPewCWe5qXZpEkQaXAkyZB
 PLCaUsJI5AqIe3DKiUNP9/yyIKF2w946Cz+OedQWeMtmW+ZFVCZ0tvTyubaN0PzjX8t8ArUT
 Nl2rIDhPIrxpnuXFMb7kKe9txOMFkPouAQ4M3+Fx4Rx4OThJcFgC50Z7BBxeD92nv1jxHIfB
 ydhKuALAGpediF8Al9qqx1VxiFMyaO9L59g3YGf1Wg6K4eSDRG4DMaxz1uMcLYKfV9LcbCl0
 RWdXOiH0fdK00slAj7UTqwXJlidusTxxi+X/WivAO8Aa1qBXK1l9hoZ9L00vV+sNGmWaQqt2
 gKUf6X40GrkKLs79mTYMMBIMA0ji0tWiiv0yBS3Klx/7gNVpj+gMKlY/DNaRPOkakaLwipym
 lPJS9l2WLWZ1j1WMTEgqw3ae7N/bqhK3mVM1l8/J2rS7XrCNy6LZQVpx953s3KkZQ97ZCL34
 /a6h4taYf9OqUsnX4lP2LO/I7juOvo15WzNfFzxfbyg5Y/bPF903NusUqQvunPHSGOzZKoK1
 54/9FGWTvhWfGMrsSnlGazw3fa9o7abDZwJz2lj2hQ8D5m1OxjfK8LOOGIuiktDm9h2PpELj
 hfzw9eSZPcnpJfWvrMol/YO/k0Pjz4Xs/Vb16PpLGxpN4oKPSkwU3ZCjK/yV2ux1JG94e+jp
 26HDGZ6ZjP0vN9f9Pf2UdN+Brol9b/1yf679TbW1S9lrJcw3Du693rq4PSA9UWN1D5T90JBW
 nxqV8vQF8pdScJ1e/h+JhhjBAAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t/xe7r7mzWTDR6vUbdYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9JounV2cxWey9pW1x
 edccNov5y56yW0xo+8pscWPCU0aLz0tb2C3W3HzKYnHilrSDsMflK94eO2fdZfe4fLbUY9Oq
 TjaPzUvqPXbfbGDz6G1+x+axs/U+q8f7fVfZPPq2rGL02Hy62uPzJjmP9gPdTAG8UXo2Rfml
 JakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZJ358Zir4Ilhx
 +XMbewPjD74uRk4OCQETifOLVrF2MXJxCAksZZRon/aOCSIhIXF7YRMjhC0s8edaFxtE0XNG
 idvPF7J3MXJwsAloSTR2soPUiAjkShzePAGsl1ngGLNEU28FiC0s4CqxddIsVhCbRUBV4tTq
 1WD1vAJWEtsWbWWFmC8vMfPSd7A4p4C1xJzdLWwgthBQTceszWwQ9YISJ2c+YYGYLy/RvHU2
 8wRGgVlIUrOQpBYwMq1iFEktLc5Nzy020itOzC0uzUvXS87P3cQIjOdtx35u2cG48tVHvUOM
 TByMhxglOJiVRHhb/DWThXhTEiurUovy44tKc1KLDzGaAt09kVlKNDkfmFDySuINzQxMDU3M
 LA1MLc2MlcR5PQs6EoUE0hNLUrNTUwtSi2D6mDg4pRqYZpldSpoTw84tz9x1mU89IfSDLKul
 4ps1aWWbr5bKvp3f+yF7DU+p/ZGN2137+u5WzIvq2TYz4O2uRYtWHphst3XjQlWWV6sdr58Q
 eHolnkm+8YLz8tzdYcvtCvd+uHKv3/LmFOcebj6pLI3Xez96HHnvlrjUt+P5zAt3/jmXzPym
 sity42RJjatfHsnMSlaauDSguH1Jei6ftVN/lrLkbknlTZ5fZlwQ+bnM4N7tWX9SZ36z+3pe
 5Zd9jIPP7f1Zue/VHkybxbukh09oJedR0x9XOfawLNBjyY5rCfjRLZrA8tB3Ts4hd73f2hoL
 FOb5eCUxvpl28T+L1hmuxvnRXkw9Lc25qw8kaD/pPGujpMRSnJFoqMVcVJwIAFf8QJJwAwAA
X-CMS-MailID: 20220920091127eucas1p252a2edaae00ff379bc6f9fbcc2791487
X-Msg-Generator: CA
X-RootMTR: 20220920091127eucas1p252a2edaae00ff379bc6f9fbcc2791487
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220920091127eucas1p252a2edaae00ff379bc6f9fbcc2791487
References: <20220920091119.115879-1-p.raghav@samsung.com>
 <CGME20220920091127eucas1p252a2edaae00ff379bc6f9fbcc2791487@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v14 07/13] zonefs: allow non power of 2 zoned
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The zone size shift variable is useful only if the zone sizes are known
to be power of 2. Remove that variable and use generic helpers from
block layer to calculate zone index in zonefs.

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
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

