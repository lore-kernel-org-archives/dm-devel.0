Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A27C04A68
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jul 2022 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658940931;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NtJLDGard3WlabG5uU6bPQNOOafvaaUg6AWJUqvWBKU=;
	b=C67ZA4msvqDEQH7BvcgcMhyH7FQ2HbYz7W2yKhshmxwPyQomKmHktMzwQ8lbQhK4mnkltY
	9A5Qgnw5F/smg7b0EFuBWNvhbUX4ovUgYsOricEXv+I/HWGaC49r76ALqADsJlmBr9qRi3
	fzod62e3SKU2jC78wI2GDjVwWdlhMDw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-ZPKsh9VNM6a7GahVZ8pxYg-1; Wed, 27 Jul 2022 12:55:30 -0400
X-MC-Unique: ZPKsh9VNM6a7GahVZ8pxYg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CBD83C0F372;
	Wed, 27 Jul 2022 16:55:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 19C21403166;
	Wed, 27 Jul 2022 16:55:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BEC4A1945DAD;
	Wed, 27 Jul 2022 16:55:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 87EBC1945DA2
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6CE81C27D95; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 685F0C15D67
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51DBB804197
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:31:25 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-jBMlDWeOMLSektrVmuRgRQ-1; Wed, 27 Jul 2022 12:31:23 -0400
X-MC-Unique: jBMlDWeOMLSektrVmuRgRQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220727162254euoutp01b3be3664695e2adc978c755a53bc7d9f~FvDU1SbCY2257722577euoutp01h
 for <dm-devel@redhat.com>; Wed, 27 Jul 2022 16:22:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220727162254euoutp01b3be3664695e2adc978c755a53bc7d9f~FvDU1SbCY2257722577euoutp01h
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220727162253eucas1p2a6bcc6cca5d6d1d4bf2b80cbf4d27b41~FvDTjs7Vb2238722387eucas1p2f;
 Wed, 27 Jul 2022 16:22:53 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 61.C3.09664.C5661E26; Wed, 27
 Jul 2022 17:22:52 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220727162252eucas1p25be8b79231334fa0c759c2475859e93b~FvDTFOskz2220522205eucas1p23;
 Wed, 27 Jul 2022 16:22:52 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220727162252eusmtrp11fd545a5a67eb51354f0461a908b515d~FvDTEgYLZ0298902989eusmtrp1M;
 Wed, 27 Jul 2022 16:22:52 +0000 (GMT)
X-AuditID: cbfec7f2-d81ff700000025c0-ee-62e1665cbb98
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id D7.8D.09038.C5661E26; Wed, 27
 Jul 2022 17:22:52 +0100 (BST)
Received: from localhost (unknown [106.210.248.8]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220727162252eusmtip17ef798f82e8d69146375b573ae97431a~FvDSufloN0050700507eusmtip1g;
 Wed, 27 Jul 2022 16:22:52 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: damien.lemoal@opensource.wdc.com, hch@lst.de, axboe@kernel.dk,
 snitzer@kernel.org, Johannes.Thumshirn@wdc.com
Date: Wed, 27 Jul 2022 18:22:40 +0200
Message-Id: <20220727162245.209794-7-p.raghav@samsung.com>
In-Reply-To: <20220727162245.209794-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djP87oxaQ+TDJ7121isvtvPZjHtw09m
 i99nzzNb7H03m9Xi5oGdTBZ7Fk1isli5+iiTxZP1s5gt/nbdY7LYe0vb4vKuOWwW85c9ZbeY
 0PaV2eLGhKeMFp+XtrBbrLn5lMXixC1pB0GPy1e8PXbOusvucflsqcemVZ1sHpuX1HvsvtnA
 5rGz9T6rx/t9V9k8+rasYvTYfLra4/MmOY/2A91MATxRXDYpqTmZZalF+nYJXBkTJ0xgKTgu
 UPGw7zZrA+Nt3i5GDg4JAROJQ5+kuxi5OIQEVjBKvGy6wAThfGGUuPVlKyuE85lR4vXXh+xd
 jJxgHX9ut0NVLWeU6Hx/hB3Cec4osWD+VGaQuWwCWhKNnWANIgLFEg/ftbKA1DALHGCSeHC7
 hQ0kISzgIrH39QMwm0VAVeLpsTfMIDavgJXEr0MfmSG2yUvMvPQdbBCngLXE5inzmCBqBCVO
 znzCAmIzA9U0b53NDLJAQmA9p8TVNWtZIJpdJA5c72CDsIUlXh3fAvWCjMTpyT1QNdUST2/8
 hmpuYZTo37meDRIy1hJ9Z3JATGYBTYn1u/Qhyh0l7t+6ygpRwSdx460gxAl8EpO2TWeGCPNK
 dLQJQVQrSez8+QRqqYTE5aY5UEs9JM7f3Mk0gVFxFpJnZiF5ZhbC3gWMzKsYxVNLi3PTU4sN
 81LL9YoTc4tL89L1kvNzNzEC0+Dpf8c/7WCc++qj3iFGJg7GQ4wSHMxKIrwJ0feThHhTEiur
 Uovy44tKc1KLDzFKc7AoifMmZ25IFBJITyxJzU5NLUgtgskycXBKNTBxfX6s9PPWmnMf/dkz
 IlzPptezeO+oPz5J6JQQu8QkT7bCGWabXb7d+c7WMSeWQX3p1GkeHB9jVuSZ3BKQfmgysdCz
 cJVU0sm3+wJ43tnF/2u6YMP2ZfLGsl88Kr+ji58lR75yVlHjszW6c/375blLS2cmzpq5rtvi
 lOpN1WuvdGfk6u6/qV0jMDObfZe4Xfr16spNzcGT76zK2MBTnW8Xkv35+cmTNy16inwOfN8T
 /vlTW9rZyfzJX2bzffmlfKyvxdKHo+nbOvHUmtgutt81RQxrtNY0bpQNsWc6+4JZRp9x7a/I
 s69mO0lGnfql3lF9z3OJsvAjvknHd0jYTXy7gTFjV3bO672s93J3b1ZVYinOSDTUYi4qTgQA
 FFGOwPIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/xu7oxaQ+TDM7/l7VYfbefzWLah5/M
 Fr/Pnme22PtuNqvFzQM7mSz2LJrEZLFy9VEmiyfrZzFb/O26x2Sx95a2xeVdc9gs5i97ym4x
 oe0rs8WNCU8ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DImTpjAUnBcoOJh323WBsbbvF2MnBwSAiYS
 f263M3UxcnEICSxllNhy4yYbREJC4vbCJkYIW1jiz7UuNoiip4wSZ2+vAerg4GAT0JJo7GQH
 MUUEKiXOfpEFKWEWOMckcfPiNbA5wgIuEntfPwCzWQRUJZ4ee8MMYvMKWEn8OvSRGWK+vMTM
 S9/ZQWxOAWuJzVPmMYHYQkA1zx58ZIOoF5Q4OfMJC4jNDFTfvHU28wRGgVlIUrOQpBYwMq1i
 FEktLc5Nzy020itOzC0uzUvXS87P3cQIjNhtx35u2cG48tVHvUOMTByMhxglOJiVRHgTou8n
 CfGmJFZWpRblxxeV5qQWH2I0Bbp7IrOUaHI+MGXklcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJ
 pCeWpGanphakFsH0MXFwSjUwhXY3NORf8LUoOtQ6Y/m+q2Ut05qORPsd+KYaLVJ4LH2KGdu8
 PRpLNyUHMS9k+LJQ+dpK78OS+29duHxj21QPd8ZbcxoV/uy6phW7/b92k5rRAYm3XZZeJl1P
 VW3OnN+wlt13rfuDghPzZGb88TcovbSGiVe4SX/yRC6jjWHGpe+nnCzzrkjxrNwu+CPcuP3T
 AnaXUn/30zbbfe+d+b3+9T/ZaS1/97pKrs9LMNtl2N0genfNmVf3Mtq3RGx6U1x+0FtJMZ45
 3WhX5G7D/raPS45nrNo7x45N7Pr0Kuf9JRybDxw74Pbe2Kxl7XOHtce9jl9IKFO+vojnuCWf
 42UuxRYD4z/rt5xTZj3hpD3joRJLcUaioRZzUXEiAHUhaWZhAwAA
X-CMS-MailID: 20220727162252eucas1p25be8b79231334fa0c759c2475859e93b
X-Msg-Generator: CA
X-RootMTR: 20220727162252eucas1p25be8b79231334fa0c759c2475859e93b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220727162252eucas1p25be8b79231334fa0c759c2475859e93b
References: <20220727162245.209794-1-p.raghav@samsung.com>
 <CGME20220727162252eucas1p25be8b79231334fa0c759c2475859e93b@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v8 06/11] zonefs: allow non power of 2 zoned
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
 pankydev8@gmail.com, gost.dev@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The zone size shift variable is useful only if the zone sizes are known
to be power of 2. Remove that variable and use generic helpers from
block layer to calculate zone index in zonefs.

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

