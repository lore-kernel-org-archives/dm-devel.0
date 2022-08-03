Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFCD4C25B06
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520100;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jamXr8quZrda2gm/OeXqwXaoHJv1i7HvaixEeOY243M=;
	b=Wgl9IINf1kbcYXmUY+hFa08Tg8tnXPYcciLrWDKQxMfZzSGfoFAaYC8Thv1zyUx1gL+K7S
	14rEUDXTEQwyp9KQv0LBY3y/seHJmS9KbbfDPdKlNOaHU1vDIjiIhLQSKB5e/uXGxk2rhT
	cUM4jCnCi8jLMgfKo7Vl1rZShiKqzig=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-BNAsFB_bN7qPrsPMPj1ODQ-1; Wed, 03 Aug 2022 05:48:17 -0400
X-MC-Unique: BNAsFB_bN7qPrsPMPj1ODQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A22F280F2AA;
	Wed,  3 Aug 2022 09:48:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 76E2640CFD0A;
	Wed,  3 Aug 2022 09:48:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5BFDB1946A53;
	Wed,  3 Aug 2022 09:48:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC0CC1946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC5B718EAA; Wed,  3 Aug 2022 09:48:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B818718EA8
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C1DD3C0D859
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:15 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-g-Cltl6FNp-L8zNDt70sqg-1; Wed, 03 Aug 2022 05:48:14 -0400
X-MC-Unique: g-Cltl6FNp-L8zNDt70sqg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094812euoutp021222b63d583198baff9668f3b9e7cf2d~HzLtc9lYX1921619216euoutp02M
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220803094812euoutp021222b63d583198baff9668f3b9e7cf2d~HzLtc9lYX1921619216euoutp02M
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220803094810eucas1p13ef520e51d3ca7b5822a11e2d1d1af1b~HzLrqKrSc1447714477eucas1p1G;
 Wed,  3 Aug 2022 09:48:10 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 11.06.10067.A544AE26; Wed,  3
 Aug 2022 10:48:10 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220803094810eucas1p1304a82ba94d0265c3f6a8a371e5127a7~HzLq8-nPY3109731097eucas1p1S;
 Wed,  3 Aug 2022 09:48:10 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220803094810eusmtrp2d87915093087080592522be7fa4346e1~HzLq8LrDT0972009720eusmtrp2d;
 Wed,  3 Aug 2022 09:48:10 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-4c-62ea445afc23
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 10.EB.09095.9544AE26; Wed,  3
 Aug 2022 10:48:09 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094809eusmtip1d73b9053f698e1f43a7bd40d4f7d177b~HzLqlR4Nk2555925559eusmtip1j;
 Wed,  3 Aug 2022 09:48:09 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:47:55 +0200
Message-Id: <20220803094801.177490-8-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djPc7pRLq+SDA6c0LVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlfFg
 QmJBi2DFij/VDYyT+LoYOTkkBEwkjq34xdrFyMUhJLCCUeLY34VQzhdGiZf/PzFBOJ8ZJT71
 rmeFabnz6jUzRGI5o8TN7n0sIAkhgZeMEl3zKrsYOTjYBLQkGjvZQWpEBJoZJe7+7QEbyyxw
 gEni5pZbTCANwgIuEn+2/WAEsVkEVCUeTnkJNohXwEri8aVfjBDb5CVmXvrODmJzClhLTPn3
 jxmiRlDi5MwnYPXMQDXNW2eDXSQhsJ1T4u2OdWwQzS4SXSueQdnCEq+Ob2GHsGUk/u+czwRh
 V0s8vfEbqrmFUaJ/53o2kBckgLb1nckBMZkFNCXW79KHKHeUWD77HhNEBZ/EjbeCECfwSUza
 Np0ZIswr0dEmBFGtJLHz5xOopRISl5vmsEDYHhKdv/6zTGBUnIXkmVlInpmFsHcBI/MqRvHU
 0uLc9NRio7zUcr3ixNzi0rx0veT83E2MwHR4+t/xLzsYl7/6qHeIkYmD8RCjBAezkgjvHZfn
 SUK8KYmVValF+fFFpTmpxYcYpTlYlMR5kzM3JAoJpCeWpGanphakFsFkmTg4pRqYmnd1eUTu
 2+z6Tq2totb4/C8P7+6Af7NmzOsoY3SR5Crrj7L72dCnbqAa2OVQvM1tnsUp/X/hlqF/Xm6T
 ORrgE6x/rHWHNreHRueKxYn8mktCt1xoz1Y9xrqwWqJz1+pL91jXn1u/UmB2uaWpWfUFa7lF
 ma91jOZu/5524dPWxe6HezfM+NTNmsZat+jnjL9RRRG7rmstvuZcZxulXyKflKihUn/ywI77
 k58uWLCqeGn8ElZm+w2q/MVF3qaTfs75cdC3dybjJEuPyL+5B9st/VzO1GVrMXydbMSR2vOL
 j+0Zy7OI9w+ELnnvMA7bKv9MOW/zkq3Gz+7M9j3C3823JkQ+UaKaK+G2Rahynr0SS3FGoqEW
 c1FxIgA9FYvp9gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xu7qRLq+SDJ5csLFYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl/FgQmJBi2DFij/VDYyT+LoYOTkk
 BEwk7rx6zdzFyMUhJLCUUWLr4elsEAkJidsLmxghbGGJP9e62CCKnjNKXO/fBNTBwcEmoCXR
 2MkOEhcR6GaUuHzmHCuIwyxwjkliztMHYJOEBVwk/mz7ATaJRUBV4uGUlywgNq+AlcTjS7+g
 NshLzLz0nR3E5hSwlpjy7x8ziC0EVLPu7yxWiHpBiZMzn4D1MgPVN2+dzTyBUWAWktQsJKkF
 jEyrGEVSS4tz03OLDfWKE3OLS/PS9ZLzczcxAmN327Gfm3cwznv1Ue8QIxMH4yFGCQ5mJRHe
 Oy7Pk4R4UxIrq1KL8uOLSnNSiw8xmgLdPZFZSjQ5H5g88kriDc0MTA1NzCwNTC3NjJXEeT0L
 OhKFBNITS1KzU1MLUotg+pg4OKUamGKr9Wa18c/aqVT53lNYiv2J/k6Pdub/U6MuhG9fpddu
 cXvW1+O787ZEn16pvysqhzHBpnOhdFBW1vVzi40eMRn4bo2I1DLfdEPv4FPfxdrzTXpKt5+L
 qLOKqz8189mLROUwdelniXO53iqs89h8L+S6u/qZTPUMhcLw/Qzaq02n/wtOO3X5tPGFuPTZ
 9zSnsrl929M82XfWtB+3+/p69/1fGDIv5a3OrXm+bFbvNLiUllbKb//Q8/WayKscsY0fhW0y
 gxKuM3BJWPOxVqocn7cgeZfQdhOO4w9lt0SueRb6K2mRWc+u+LI/XGxmoremL2hzCpihvGfn
 6wPrXWfN4VgkPfHb7ScPf6fOsT+lma7EUpyRaKjFXFScCAAFxu0AZgMAAA==
X-CMS-MailID: 20220803094810eucas1p1304a82ba94d0265c3f6a8a371e5127a7
X-Msg-Generator: CA
X-RootMTR: 20220803094810eucas1p1304a82ba94d0265c3f6a8a371e5127a7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094810eucas1p1304a82ba94d0265c3f6a8a371e5127a7
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094810eucas1p1304a82ba94d0265c3f6a8a371e5127a7@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH v9 07/13] zonefs: allow non power of 2 zoned
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

