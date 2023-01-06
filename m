Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13419C5479D
	for <dm-devel@archiver.kernel.org>; Fri,  6 Jan 2023 08:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672994435;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2KNk+beC1HbAqvylGTCjC688w8+k/MIkj/C3c0PMtmU=;
	b=Y6jX4YyizO3yHSA+DCX4NW3LxpTOUmQwqw+vVqHLxaMuuclYcGIl0lTqZFsZ1sY+JLKOsS
	gYGBfByrDG5KLlDbjDXLUJcamdu+abk8reS1KTsaQVajf+fTcmsUjO3UBRc+QIEk8isVDT
	es4KGfhByEZMELYDMxUiikY3RiLB44A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-T__qGj1gOTqKWjl09JyIQQ-1; Fri, 06 Jan 2023 03:40:34 -0500
X-MC-Unique: T__qGj1gOTqKWjl09JyIQQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D70CE1C05141;
	Fri,  6 Jan 2023 08:40:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 49B6BC15BAD;
	Fri,  6 Jan 2023 08:40:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 05B85194658D;
	Fri,  6 Jan 2023 08:40:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7D7561946595
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 62D0E492B01; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AFA6492B00
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FEE0101B429
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:40:28 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-893YHR4SMtONYzhE0auz9g-1; Fri, 06 Jan 2023 03:40:26 -0500
X-MC-Unique: 893YHR4SMtONYzhE0auz9g-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20230106083322euoutp01b1ae8980247375497e99ebcc983680b0~3qy6Ku7Xc1990519905euoutp018
 for <dm-devel@redhat.com>; Fri,  6 Jan 2023 08:33:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20230106083322euoutp01b1ae8980247375497e99ebcc983680b0~3qy6Ku7Xc1990519905euoutp018
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20230106083322eucas1p1c3c3079982519376276cf618f4614634~3qy5RsdUQ1103011030eucas1p1F;
 Fri,  6 Jan 2023 08:33:22 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 2F.93.56180.1DCD7B36; Fri,  6
 Jan 2023 08:33:21 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20230106083321eucas1p15e9087bcc62bc6a4f5a61467e1c98698~3qy44kw8g2243222432eucas1p1A;
 Fri,  6 Jan 2023 08:33:21 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230106083321eusmtrp2d3f5148d45e550f1ae35a15ae7e369b6~3qy436qaB1128211282eusmtrp2B;
 Fri,  6 Jan 2023 08:33:21 +0000 (GMT)
X-AuditID: cbfec7f2-acbff7000000db74-9f-63b7dcd19fcb
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id AC.AB.52424.1DCD7B36; Fri,  6
 Jan 2023 08:33:21 +0000 (GMT)
Received: from localhost (unknown [106.210.248.66]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230106083321eusmtip134788efdb299072ab1171e30bcf8eb04~3qy4l1qIF1412914129eusmtip1J;
 Fri,  6 Jan 2023 08:33:21 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk
Date: Fri,  6 Jan 2023 09:33:14 +0100
Message-Id: <20230106083317.93938-5-p.raghav@samsung.com>
In-Reply-To: <20230106083317.93938-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7djPc7oX72xPNljYZWWx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLmwd2MlnsWTSJyWLl6qNMFmdefmax2HtL2+LyrjlsFvOXPWW3+Ly0hd3i
 xC1pB16Py1e8PS6fLfXYtKqTzWPzknqP3Tcb2Dx2tt5n9Ti70tHj/b6rbB59W1Yxemw+Xe3x
 eZNcAHcUl01Kak5mWWqRvl0CV8bP3ZeYCw4IVjz++Zy5gXE7XxcjJ4eEgInE1KOX2bsYuTiE
 BFYwSly+uYQJwvnCKNH2Zj8LhPOZUWLy1ZmsMC3t675CVS1nlGi8fQDKeQFUtecTYxcjBweb
 gJZEYyc7SIOIgLDE/o5WsEnMApuZJG7/XssIkhAWCJL4d3ceC4jNIqAqsefcNrANvAKWEg/2
 LYTaJi8x89J3sEGcAlYSz6evYYKoEZQ4OfMJWC8zUE3z1tnMIAskBLo5JdpnbWOBaHaR+Hz8
 HiOELSzx6vgWdghbRuL/zvlMEHa1xNMbv6GaWxgl+neuZwP5QELAWqLvTA6IySygKbF+lz5E
 uaNEU+sfqAo+iRtvBSFO4JOYtG06M0SYV6KjTQiiWkli588nUEslJC43zYE6zEPi/ocrTBMY
 FWcheWYWkmdmIexdwMi8ilE8tbQ4Nz212DAvtVyvODG3uDQvXS85P3cTIzCpnf53/NMOxrmv
 PuodYmTiYDzEKMHBrCTCW9a/LVmINyWxsiq1KD++qDQntfgQozQHi5I474yt85OFBNITS1Kz
 U1MLUotgskwcnFINTIrFHZ0t6uuvVNYH2CY7nPaab67Ppqr7otxcqZX5r26/7/XDlVza0pc/
 Jl3Qv3P/D3/P7OmhyhI7XV/sPBSdnbIg027mxy/WmZqsuWFeevOfKXM2HDNkefyq9+ytRyHb
 d6pWHX5uzLV7pb+76V+N8v2LpBKSJvjYiL5atCRZeUKi/IRdti1PBVWv3Qg9Gc18p7Zly4nH
 l+38fnRtfNZrXXGgfpr+tn9tM1cGfbp5eF7Wt79RR3adr0v597/8fMXWWzfXsbBf2lbKejuh
 4n2PeNfWyf+n97j+/yW9cfp1zrKJU9a0PSxYt/blbNF/7ncd+NdN0/m+7vHCssRqMwuthjK3
 y9YKzjNEc/4mSfwv5VJiKc5INNRiLipOBABUXKzy2QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t/xu7oX72xPNug6K26x+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLmwd2MlnsWTSJyWLl6qNMFmdefmax2HtL2+LyrjlsFvOXPWW3+Ly0hd3i
 xC1pB16Py1e8PS6fLfXYtKqTzWPzknqP3Tcb2Dx2tt5n9Ti70tHj/b6rbB59W1Yxemw+Xe3x
 eZNcAHeUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2C
 XsbP3ZeYCw4IVjz++Zy5gXE7XxcjJ4eEgIlE+7qvTF2MXBxCAksZJaZsu8sMkZCQuL2wiRHC
 Fpb4c62LDaLoGaNEz6tW9i5GDg42AS2Jxk52kBoRoJr9Ha0sIDXMAgeZJJ5N+Q42SFggQKLz
 0282EJtFQFViz7ltrCA2r4ClxIN9C1khFshLzLz0HWwQp4CVxPPpa5hAbCGgmo6PvWwQ9YIS
 J2c+YQGxmYHqm7fOZp7AKDALSWoWktQCRqZVjCKppcW56bnFRnrFibnFpXnpesn5uZsYgfG3
 7djPLTsYV776qHeIkYmD8RCjBAezkghvWf+2ZCHelMTKqtSi/Pii0pzU4kOMpkB3T2SWEk3O
 ByaAvJJ4QzMDU0MTM0sDU0szYyVxXs+CjkQhgfTEktTs1NSC1CKYPiYOTqkGJlGOhx+rLt4T
 fHKhOv0Oq8zv3A8mViY7pycpP1ZjPzyjxKLw5pnMyR27ZjGdWFLoszLUwdLK8esNa9lZIsUn
 Mw+6cMxcl635nv2Z5dTdRS/L2P+s3Hm3VTn90gSeJYdDZFP2PgttMkmJnrzt5s/HTalO8nq/
 AuyeWDmlf717l9Nkrs2k0q2bmrNOtyw7le/hdlRP4OHEzXYBPadLGUL6taclPn7uf1rz8RrJ
 WN0J1i0zJ1ytXyU753Lu2gyfbJNinUk6vkrH7MPNm5LvSm099CTRPXffy+SnPCvTJoS+fZC9
 eFKa/78w767exJhzXCZndmwW2TJ3r0NJOYPBJZs/zGJ6sYduLil/m95z0l5knRJLcUaioRZz
 UXEiAM7UemJIAwAA
X-CMS-MailID: 20230106083321eucas1p15e9087bcc62bc6a4f5a61467e1c98698
X-Msg-Generator: CA
X-RootMTR: 20230106083321eucas1p15e9087bcc62bc6a4f5a61467e1c98698
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230106083321eucas1p15e9087bcc62bc6a4f5a61467e1c98698
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083321eucas1p15e9087bcc62bc6a4f5a61467e1c98698@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 4/7] zonefs: use bdev_zone_no helper to calculate
 the zone index
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
 gost.dev@samsung.com, damien.lemoal@opensource.wdc.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, kernel@pankajraghav.com, dm-devel@redhat.com,
 hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use bdev_zone_no() helper instead of opencoding the logic to find the
zone index.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/zonefs/super.c  | 8 +++-----
 fs/zonefs/zonefs.h | 1 -
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 2c53fbb8d918..c2ddc62e99dc 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -487,7 +487,6 @@ static void __zonefs_io_error(struct inode *inode, bool write)
 {
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	struct super_block *sb = inode->i_sb;
-	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
 	unsigned int noio_flag;
 	unsigned int nr_zones = 1;
 	struct zonefs_ioerr_data err = {
@@ -502,8 +501,8 @@ static void __zonefs_io_error(struct inode *inode, bool write)
 	 * size is always larger than the device zone size.
 	 */
 	if (zi->i_zone_size > bdev_zone_sectors(sb->s_bdev))
-		nr_zones = zi->i_zone_size >>
-			(sbi->s_zone_sectors_shift + SECTOR_SHIFT);
+		nr_zones =
+			bdev_zone_no(sb->s_bdev, zi->i_zone_size >> SECTOR_SHIFT);
 
 	/*
 	 * Memory allocations in blkdev_report_zones() can trigger a memory
@@ -1420,7 +1419,7 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	int ret = 0;
 
-	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
+	inode->i_ino = bdev_zone_no(sb->s_bdev, zone->start);
 	inode->i_mode = S_IFREG | sbi->s_perm;
 
 	zi->i_ztype = type;
@@ -1804,7 +1803,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	 * interface constraints.
 	 */
 	sb_set_blocksize(sb, bdev_zone_write_granularity(sb->s_bdev));
-	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
 	sbi->s_uid = GLOBAL_ROOT_UID;
 	sbi->s_gid = GLOBAL_ROOT_GID;
 	sbi->s_perm = 0640;
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index 1dbe78119ff1..703bc4505b29 100644
--- a/fs/zonefs/zonefs.h
+++ b/fs/zonefs/zonefs.h
@@ -179,7 +179,6 @@ struct zonefs_sb_info {
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

