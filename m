Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9928DC43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:20:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-mwUOd_weN6aLHdSkFvpPAg-1; Wed, 15 Jun 2022 06:19:57 -0400
X-MC-Unique: mwUOd_weN6aLHdSkFvpPAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE3A2800971;
	Wed, 15 Jun 2022 10:19:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD8B41121315;
	Wed, 15 Jun 2022 10:19:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F12B1947B84;
	Wed, 15 Jun 2022 10:19:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 997EC194705C
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:19:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7C1CC1415107; Wed, 15 Jun 2022 10:19:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 77F501415106
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 611553804516
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:53 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-8gDZB2cLMGGSZ1RenzTZGA-1; Wed, 15 Jun 2022 06:19:51 -0400
X-MC-Unique: 8gDZB2cLMGGSZ1RenzTZGA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615101950euoutp01c6e03c88b665d4e0514c96643cad31f9~4xAV2JlO52585525855euoutp01O
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220615101950euoutp01c6e03c88b665d4e0514c96643cad31f9~4xAV2JlO52585525855euoutp01O
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220615101948eucas1p2db62e1a1d72812c89f83ad4da9df0d80~4xAUIacym1910819108eucas1p2s;
 Wed, 15 Jun 2022 10:19:48 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id C4.77.10067.442B9A26; Wed, 15
 Jun 2022 11:19:48 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220615101948eucas1p2d8d801735c39b25256a019134adb0c6f~4xATjX3Rj2114221142eucas1p2W;
 Wed, 15 Jun 2022 10:19:48 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615101948eusmtrp2a7a7cca347d91d529dfe7e6734f73b3f~4xATiefYB0361403614eusmtrp2f;
 Wed, 15 Jun 2022 10:19:48 +0000 (GMT)
X-AuditID: cbfec7f4-dd7ff70000002753-93-62a9b2444355
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 58.55.09095.442B9A26; Wed, 15
 Jun 2022 11:19:48 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615101947eusmtip13c89af2230fa641d50955a11bfcf71c9~4xASsSOCP1144211442eusmtip1M;
 Wed, 15 Jun 2022 10:19:47 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:14 +0200
Message-Id: <20220615101920.329421-8-p.raghav@samsung.com>
In-Reply-To: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7djP87oum1YmGby7aGKx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 AvijuGxSUnMyy1KL9O0SuDI+LNjAWLBboOLYmg7GBsbzvF2MnBwSAiYSx2a8ZOti5OIQEljB
 KPFk3ioWCOcLo8SSO/fZIZzPjBLbXx5n7WLkAGs53ysMEV/OKPFu2TKo9peMEmtfnGYBKWIT
 0JJo7GQHWSEiEC5xdM89JhCbWaCPWeLJyzoQW1jAReLN3a1gNSwCqhLnd+1mBrF5Bawkfh37
 yARxnrzEzEvfwWo4BawldszuYYWoEZQ4OfMJC8RMeYnmrbOZQW6QELjEKdF1fgEbRLOLRNus
 f6wQtrDEq+Nb2CFsGYn/O+dDLaiWeHrjN1RzC6NE/871bBBfWkv0nckBMZkFNCXW79KHKHeU
 2DbzFVQFn8SNt4IQJ/BJTNo2nRkizCvR0SYEUa0ksfPnE6ilEhKXm+awQJR4SJxpKZ/AqDgL
 yS+zkPwyC2HtAkbmVYziqaXFuempxUZ5qeV6xYm5xaV56XrJ+bmbGIFp8/S/4192MC5/9VHv
 ECMTB+MhRgkOZiURXrPglUlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZMzNyQKCaQnlqRmp6YW
 pBbBZJk4OKUamCo2sG+Z1Xm0J+Dvg81vmUpVbn+rt3z8aXv38401S7zi3DZ/yay8O4tPM/eM
 pu6Gt3reYcFC+Sa9wpFli6t7I/6oTTvO7Xd4+m/ubWlnFfPLF3KlP/vuc2e7I4PopPaCndxp
 qZFt01azGyjsOnqydvvSHMnem8U9P2wfqXjMPLWq8cxUN7Mib+u2qXc9V5zWiPg77a7G7iMz
 Piw4tlDu0ekLWls81j19vGUd57HWOdfSt8RnrfmTfmrO35Sl+YWxOw7L1qw/b/DsUoTY3l0b
 qxeIrBW7xlejd+xVmHzW2bozldO6Z6/Rihc5Od1y1+HrnWUnrn9p6Tnr71U6TYv5mJ+2y8NP
 Mss8us2tjTpq5H8rsRRnJBpqMRcVJwIA1xcFgAoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t/xu7oum1YmGXQuF7BYfbefzWLah5/M
 Fr/Pnme22PtuNqvFhR+NTBY3D+xkstizaBKTxcrVR5ksnqyfxWzRc+ADi8XfrntAsZaHQMW3
 tC0u75rDZjF/2VN2ixsTnjJafF7awm6x5uZTFou2jV8ZHYQ9Ll/x9vh3Yg2bx85Zd9k9Lp8t
 9di0qpPNY2HDVGaPzUvqPXbfbADKtd5n9Xi/7yqbR9+WVYwe67dcZfHYfLra4/MmOY/2A91M
 AfxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF+nYJehkf
 FmxgLNgtUHFsTQdjA+N53i5GDg4JAROJ873CXYxcHEICSxklVh3bz97FyAkUl5C4vbCJEcIW
 lvhzrYsNoug5o8SHnSuYQJrZBLQkGjvB6kUEoiU6b74Hq2EWWMAscfrOBLCEsICLxJu7W8Fs
 FgFVifO7djOD2LwCVhK/jn1kglggLzHz0newGk4Ba4kds3tYQeYLAdXsehcPUS4ocXLmExYQ
 mxmovHnrbOYJjAKzkKRmIUktYGRaxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJERjj24793LyD
 cd6rj3qHGJk4GA8xSnAwK4nwmgWvTBLiTUmsrEotyo8vKs1JLT7EaAp09kRmKdHkfGCSySuJ
 NzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhPLEnNTk0tSC2C6WPi4JRqYDp6wkLb9f5ri9yV76b9
 TbxxUqXM4NWmt6aqr/fdSV1wbHWzrv+tqUyBO/+pJSXsuvA+/sAjb+EFL8t6S6sKVspezrr5
 0W5bzosEMwPxMx08q2bfkysXmpnOyPp5xn6r2756F4T3OrzcX894YL9o1IR+LxHhWK60wEf6
 W2VE+2938U7JfqVitk989pqNSjFlrsnlTZ2hzfNmc829/fuaaHKYtZ/n8pqp1wKX81Wfuchh
 t9DT6vlm456WD4cqMw5U/Z48pULVoPGf9jFnthdrqr+v387JvXaBZ2POgh7B+bGTPj6pW6c7
 6aStIbdkgjSPB3fbi949j9ncNTk0z+/7ud0oacb+Bwo7z9jN9cwxaFZiKc5INNRiLipOBAA/
 +S8iegMAAA==
X-CMS-MailID: 20220615101948eucas1p2d8d801735c39b25256a019134adb0c6f
X-Msg-Generator: CA
X-RootMTR: 20220615101948eucas1p2d8d801735c39b25256a019134adb0c6f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615101948eucas1p2d8d801735c39b25256a019134adb0c6f
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101948eucas1p2d8d801735c39b25256a019134adb0c6f@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH v7 07/13] zonefs: allow non power of 2 zoned
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
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
index cc6d4cf58..0b737c2fb 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -485,10 +485,9 @@ static void __zonefs_io_error(struct inode *inode, bool write)
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
@@ -1410,7 +1409,7 @@ static int zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 	int ret = 0;
 
-	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
+	inode->i_ino = bdev_zone_no(sb->s_bdev, zone->start);
 	inode->i_mode = S_IFREG | sbi->s_perm;
 
 	zi->i_ztype = type;
@@ -1787,7 +1786,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	 * interface constraints.
 	 */
 	sb_set_blocksize(sb, bdev_zone_write_granularity(sb->s_bdev));
-	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
 	sbi->s_uid = GLOBAL_ROOT_UID;
 	sbi->s_gid = GLOBAL_ROOT_GID;
 	sbi->s_perm = 0640;
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
index 4b3de66c3..39895195c 100644
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

