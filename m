Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9B1C07E9D
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663954604;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8w07r74GgA7Uyd8ojEZv8X0WK3gEgHX+x2NcLOEBLhA=;
	b=inaiECV2ejW5fznFWZ5/Z1TEEgBkkjlUwaAq7BLLRUHLzCFcpP9h1lHyWvoiZNYM6OcRq7
	9vILtuBT8xrab9G3KUkOi0mCCwF2UQP8VtFjZSCy45C4xKvjcVtoqYRqGceRGGTTFV7Yb4
	LzavFITofoej6A3PL2F8cyyarMKBTVY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-k8Kc6VBfPmKCi5QtCjUt6Q-1; Fri, 23 Sep 2022 13:36:42 -0400
X-MC-Unique: k8Kc6VBfPmKCi5QtCjUt6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24D50857D10;
	Fri, 23 Sep 2022 17:36:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 149CD17593;
	Fri, 23 Sep 2022 17:36:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F24BE1946A5A;
	Fri, 23 Sep 2022 17:36:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3CB5319465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 17:36:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2FAD4C15BAB; Fri, 23 Sep 2022 17:36:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 286A8C15BA8
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0EAEC858F17
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:36 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-ym1jkTbCMOG6AIUcJYuq0g-1; Fri, 23 Sep 2022 13:36:34 -0400
X-MC-Unique: ym1jkTbCMOG6AIUcJYuq0g-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220923173633euoutp0126907bebbc7252d8a1cd743186f1a71f~XjeL8LT891803218032euoutp01O
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 17:36:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220923173633euoutp0126907bebbc7252d8a1cd743186f1a71f~XjeL8LT891803218032euoutp01O
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220923173631eucas1p270e18bb3079ae98a1dabe39d5c523112~XjeJ3s-8e2090220902eucas1p2j;
 Fri, 23 Sep 2022 17:36:31 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 8A.97.19378.E9EED236; Fri, 23
 Sep 2022 18:36:30 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220923173630eucas1p2bae6918f0c165051464e62c5172a80e0~XjeJaXYe12090620906eucas1p2q;
 Fri, 23 Sep 2022 17:36:30 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220923173630eusmtrp237cccf5026ff5eaef52d2f5f142c38f2~XjeJZrk661023410234eusmtrp2_;
 Fri, 23 Sep 2022 17:36:30 +0000 (GMT)
X-AuditID: cbfec7f5-a35ff70000014bb2-c0-632dee9e0e20
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id CB.5F.10862.E9EED236; Fri, 23
 Sep 2022 18:36:30 +0100 (BST)
Received: from localhost (unknown [106.210.248.168]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220923173630eusmtip22323d39c07b74819b2046f769f84a3ef~XjeJFAcbY2300023000eusmtip2l;
 Fri, 23 Sep 2022 17:36:30 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: snitzer@kernel.org, axboe@kernel.dk, agk@redhat.com, hch@lst.de,
 damien.lemoal@opensource.wdc.com
Date: Fri, 23 Sep 2022 19:36:15 +0200
Message-Id: <20220923173618.6899-11-p.raghav@samsung.com>
In-Reply-To: <20220923173618.6899-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWy7djP87rz3ukmG6xcZmOx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW3xe2sJusebmUxaLE7ekHQQ9Ll/x9tg56y67x+WzpR6bVnWyeWxeUu+x+2YD
 m8fO1vusHu/3XWXz6NuyitFj8+lqj8+b5DzaD3QzBfBEcdmkpOZklqUW6dslcGV8WP6XrWAN
 X8X8DxcYGxgvcXcxcnJICJhI9J9+wdrFyMUhJLCCUeLY9pdsEM4XRomHy6dDOZ8ZJSZNvsYM
 07Lr9QJ2iMRyRon2zdcYIZyXjBIbzk4GynBwsAloSTR2soM0iAikSxzfehOsgVngJZPEg9N3
 WUASwgKREo8eXACbyiKgKrGou5EJpJdXwFJi8m5HiGXyEjMvfQcbyQkU7m+sAQnzCghKnJz5
 BGwKM1BJ89bZzCDjJQQ2c0rc/HyPBaLXReL3nLtQRwtLvDq+hR3ClpH4v3M+E4RdLfH0xm+o
 5hZGif6d69lAlkkIWEv0nckBMZkFNCXW79KHKHeU2POtlRWigk/ixltBiBP4JCZtm84MEeaV
 6GgTgqhWktj58wnUUgmJy01zoA7zkNi7/iPLBEbFWUiemYXkmVkIexcwMq9iFE8tLc5NTy02
 zkst1ytOzC0uzUvXS87P3cQITIKn/x3/uoNxxauPeocYmTgYDzFKcDArifCmXNRNFuJNSays
 Si3Kjy8qzUktPsQozcGiJM7LNkMrWUggPbEkNTs1tSC1CCbLxMEp1cC0rK30/gwXTonKFr3/
 tjs0du+6oncv9j/zRQXNo21zGa0Yd4ml5f86brWttOGw3LLlG5oeJznn/vZs36G2tp3x4Wnj
 G0rfouff4r7Q7py7yq70V7Ot9/OQzW8+qqfzND0KN1sjV7DIM1c/98KnPc/27b5y8UbrrVVV
 G3LfWoda21SuPup6VmO+foPe1K8XLx+f5Fl93Z7RUePYwwWuq9ecOGb+Wl63a8syzY/KQo0N
 um2Tg72PCL+akvO8ZfpJdu0Koaagd22CRoqteuafDTbsXNrycJLPJC9Pk19b/f2PZ/GE6nZe
 6NjG3vQ2WH1HeNVhv3VbEhkTv7o6lp98FhB5XKJh+eRZ2/j+ZE1e53JBiaU4I9FQi7moOBEA
 wEKFZvEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t/xe7rz3ukmG7TvVbJYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DI+LP/LVrCGr2L+hwuMDYyXuLsYOTkkBEwk
 dr1ewN7FyMUhJLCUUWLK/3/MEAkJidsLmxghbGGJP9e62CCKnjNKXDy9DMjh4GAT0JJo7GQH
 qRERyJU4tvYeK0gNs8B3JomrzVfZQWqEBcIlts4wAalhEVCVWNTdyAQS5hWwlJi82xFivLzE
 zEvfwao5gcL9jTUgYSEBC4nzix+BTecVEJQ4OfMJC4jNDFTevHU28wRGgVlIUrOQpBYwMq1i
 FEktLc5Nzy020itOzC0uzUvXS87P3cQIjNZtx35u2cG48tVHvUOMTByMhxglOJiVRHhTLuom
 C/GmJFZWpRblxxeV5qQWH2I0Bbp6IrOUaHI+MF3klcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJ
 pCeWpGanphakFsH0MXFwSjUw+SzfFNuwhLX13NGVG56JCEf5Bm+2673H7fouS3POXOsZCSwL
 VbMnhF8y+3tsPmuAzsNX1uv6u2znpid/6Fbbd/dvut/hnOq7Boz/Jj/e0xtq97HfvXDn2cnP
 zzHufsnw5Jfnjrip8pF9/47PvMXG4zOv6ch6ji1z8+pXPzPkfRkzZX/OVLeHrtyMlq++lyX+
 izwfkbUrwWCbxb+SOaE/zEXOBd38e/zp8dsts7dNYPs43UlNN/jTzw+/I4x3fDmtXC+UdPKU
 WkHHs6TDfycUyya+OOoaamG848ivKy47D8kflLHoKhBoy/F/77lgG2/XgkcTjk7k2m6lsik1
 LIdpzbepPBUtLz7zvLPdtbrsBocSS3FGoqEWc1FxIgDY+CU0XwMAAA==
X-CMS-MailID: 20220923173630eucas1p2bae6918f0c165051464e62c5172a80e0
X-Msg-Generator: CA
X-RootMTR: 20220923173630eucas1p2bae6918f0c165051464e62c5172a80e0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220923173630eucas1p2bae6918f0c165051464e62c5172a80e0
References: <20220923173618.6899-1-p.raghav@samsung.com>
 <CGME20220923173630eucas1p2bae6918f0c165051464e62c5172a80e0@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v15 10/13] dm-table: allow zoned devices with non
 power-of-2 zone sizes
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
 dm-devel@redhat.com, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Allow dm to support zoned devices with non power-of-2(po2) zone sizes as
the block layer now supports it.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e42016359a77..38b83c383e8f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -250,7 +250,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
-		if (start & (zone_sectors - 1)) {
+		if (!bdev_is_zone_start(bdev, start)) {
 			DMERR("%s: start=%llu not aligned to h/w zone size %u of %pg",
 			      dm_device_name(ti->table->md),
 			      (unsigned long long)start,
@@ -267,7 +267,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		 * devices do not end up with a smaller zone in the middle of
 		 * the sector range.
 		 */
-		if (len & (zone_sectors - 1)) {
+		if (!bdev_is_zone_start(bdev, len)) {
 			DMERR("%s: len=%llu not aligned to h/w zone size %u of %pg",
 			      dm_device_name(ti->table->md),
 			      (unsigned long long)len,
@@ -1647,8 +1647,7 @@ static int validate_hardware_zoned_model(struct dm_table *t,
 		return -EINVAL;
 	}
 
-	/* Check zone size validity and compatibility */
-	if (!zone_sectors || !is_power_of_2(zone_sectors))
+	if (!zone_sectors)
 		return -EINVAL;
 
 	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

