Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B52C19F2C
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 09:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659520108;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=D5x6FXx63zvTQK5nRI/vVTHN9IaGSKBi/uK99dLT41E=;
	b=UzotE7fBxCvIzLDD7UtJAt3ijQwykRdFCqNCR5jXeSMkb9r7hCetGXr/7ngHKWOL2Z+pnY
	uiwVYI/wckSFpoqQQ3ZDepwtW2HVGLN2i82FqT1Ive0IDWUTqB+VGvTlkZpYhngxpc/p+A
	gIqtUKEkDoXLDzL4T4Xk8QK5rIIPJwo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-cfaLyIVpN5qkvZYiitsu2Q-1; Wed, 03 Aug 2022 05:48:24 -0400
X-MC-Unique: cfaLyIVpN5qkvZYiitsu2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 291AA8037AE;
	Wed,  3 Aug 2022 09:48:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 180CF40D282F;
	Wed,  3 Aug 2022 09:48:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DEC921946A52;
	Wed,  3 Aug 2022 09:48:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 52A631946A4E
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 09:48:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4531718EAA; Wed,  3 Aug 2022 09:48:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4081A90A00
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A9C73C0D85B
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:20 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-Ddgv8A9oPseg-NvLer0C1A-1; Wed, 03 Aug 2022 05:48:18 -0400
X-MC-Unique: Ddgv8A9oPseg-NvLer0C1A-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220803094817euoutp027d279616530fb5cfe3b9f4f548096a82~HzLx4C9Jh1921619216euoutp02U
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 09:48:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220803094817euoutp027d279616530fb5cfe3b9f4f548096a82~HzLx4C9Jh1921619216euoutp02U
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220803094815eucas1p1bd55c673d1b14f80f9ba075b862f4c30~HzLwNksfA3109731097eucas1p1c;
 Wed,  3 Aug 2022 09:48:15 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 2D.06.10067.F544AE26; Wed,  3
 Aug 2022 10:48:15 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220803094815eucas1p2dfab477daf4f2eb05342d756fdf7f14d~HzLvvi38C1528815288eucas1p2r;
 Wed,  3 Aug 2022 09:48:15 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220803094815eusmtrp12a4dd3bd318933996e4c815d9bdf1bd0~HzLvuqSpX2000320003eusmtrp1o;
 Wed,  3 Aug 2022 09:48:15 +0000 (GMT)
X-AuditID: cbfec7f4-dc1ff70000002753-69-62ea445fd98a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id EE.9B.09038.F544AE26; Wed,  3
 Aug 2022 10:48:15 +0100 (BST)
Received: from localhost (unknown [106.210.248.112]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220803094814eusmtip145d6ac2a5c84936e935c88f18387aeec~HzLvY-4Yi2555925559eusmtip1m;
 Wed,  3 Aug 2022 09:48:14 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes.Thumshirn@wdc.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, agk@redhat.com, hch@lst.de
Date: Wed,  3 Aug 2022 11:48:00 +0200
Message-Id: <20220803094801.177490-13-p.raghav@samsung.com>
In-Reply-To: <20220803094801.177490-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djP87rxLq+SDD7f0LRYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDK+vV7LUnBM
 tOLWkQOsDYztQl2MHBwSAiYSt/7ldzFycQgJrGCU2PvvGjOE84VR4siDbWwQzmdGibnXVrHB
 dOxdEQARX84o8eHuRFYI5yWjxMZF18CK2AS0JBo72UHiIgLNjBJ3//aAFTELzGCS6PjYx9LF
 yMkhLOAqsb/pJDuIzSKgKvH+1Ccwm1fAWuLU2ctgNRIC8hIzL30Hi3MCxaf8+8cMUSMocXLm
 E7AaZqCa5q2zwe6WENjMKfHo52ZmiGYXiaNL1zJB2MISr45vYYewZSROT+6BWlAt8fTGb6jm
 FkaJ/p3rof60lug7kwNiMgtoSqzfpQ9R7ijRN6WLBaKCT+LGW0GIE/gkJm2bzgwR5pXoaBOC
 qFaS2PnzCdRSCYnLTXOglnpIfNj4jGUCo+IsJM/MQvLMLIS9CxiZVzGKp5YW56anFhvlpZbr
 FSfmFpfmpesl5+duYgSmwdP/jn/Zwbj81Ue9Q4xMHIyHGCU4mJVEeO+4PE8S4k1JrKxKLcqP
 LyrNSS0+xCjNwaIkzpucuSFRSCA9sSQ1OzW1ILUIJsvEwSnVwJThfUD9Rm/su6gpiyIzA/i9
 N1ntisj553Rrsf9n7VVqn2xXy6pqyEguVDkjXMD9nT/QJv7pxI18e8Q28JTJlWvZa4ptmRrT
 8vn15DbjxMqwhabWNVVLrBenmffLaN06f4hZ7sbsqNjX4ZrZh23mh1jt0ZwfubBVipPFxsrz
 mt5jp/SO3R1mmh4aKu3sRhyKT1KZp02Zmdd2++RdvT+VLMJnm73uLN0soGa81VkupY99vqP+
 gjkXnVoinjFqunAJTPbtdVk47cLb0K/Tl5vIPn6poWDOoGm8g6lz7d1MbzGTi/aRVXOU2Pva
 RZVur/pc0HDzGB9XgERN5nNupsPzFj9Qe+jzP1/B/VB+4VElluKMREMt5qLiRAAwZMLo8gMA
 AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t/xu7rxLq+SDHae5rRYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DK+vV7LUnBMtOLWkQOsDYztQl2MHBwSAiYS
 e1cEdDFycQgJLGWUOHFrOVMXIydQXELi9sImRghbWOLPtS42iKLnjBLzjz1nAmlmE9CSaOxk
 B4mLCHQzSlw+c44VxGEWWMYk0fTlOhtIt7CAq8T+ppPsIDaLgKrE+1OfwGxeAWuJU2cvs0Bs
 kJeYeek7WJwTKD7l3z9mEFtIwEpi3d9ZrBD1ghInZz4Bq2cGqm/eOpt5AqPALCSpWUhSCxiZ
 VjGKpJYW56bnFhvpFSfmFpfmpesl5+duYgTG7LZjP7fsYFz56qPeIUYmDsZDjBIczEoivHdc
 nicJ8aYkVlalFuXHF5XmpBYfYjQFunsis5Rocj4waeSVxBuaGZgamphZGphamhkrifN6FnQk
 CgmkJ5akZqemFqQWwfQxcXBKNTBZ6veHz7ZQivwh/ePr8sgFG3t2urb8Wnv7C19oqKuwfIrM
 q6+zz07fonMspcXWSOyVwiOTnI4n83hcNomu2+mycCqrcf5UMxdWx5Cnq5Vuvsuo3/JDZ1f7
 JEup4Cr2X+Yn303a75/mv6H10RrTfVZRH6ebSM4VNtyvo857a7FLT+odGeEu3tk89SE/PixU
 O3LiVMt/wZeFL6axXNu4iTf+ztfHPOVSe47cbpJdZJlTlsibMvOrTsKJ6c+uWcp5ea7I/pvQ
 YbsstldPYOPF2+3LfjLIrEmZKPpxm8XeOM62fdb3fCZdkTpuuc/qXbBIdqPdihVznyc7vP35
 Xe3R/J2lD9Mjd9i4eVaovF0c+ZtNiaU4I9FQi7moOBEAmzuTD2IDAAA=
X-CMS-MailID: 20220803094815eucas1p2dfab477daf4f2eb05342d756fdf7f14d
X-Msg-Generator: CA
X-RootMTR: 20220803094815eucas1p2dfab477daf4f2eb05342d756fdf7f14d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220803094815eucas1p2dfab477daf4f2eb05342d756fdf7f14d
References: <20220803094801.177490-1-p.raghav@samsung.com>
 <CGME20220803094815eucas1p2dfab477daf4f2eb05342d756fdf7f14d@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH v9 12/13] dm: introduce DM_EMULATED_ZONES target
 type
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
 dm-devel@redhat.com, jaegeuk@kernel.org, matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce a new target type DM_EMULATED_ZONES for targets with
a different zone number of sectors than the underlying device zone
number of sectors.

This target type is introduced as the existing zoned targets assume
that the target and the underlying device have the same zone
number of sectors. The new target: dm-po2zone will use this new target
type as it emulates the zone boundary that is different from the
underlying zoned device.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-table.c         | 13 ++++++++++---
 include/linux/device-mapper.h |  9 +++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 31eb1d29d136..b37991ea3ffb 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1614,13 +1614,20 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
 	return true;
 }
 
-static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
+/*
+ * Callback function to check for device zone sector across devices. If the
+ * DM_TARGET_EMULATED_ZONES target feature flag is not set, then the target
+ * should have the same zone sector as the underlying devices.
+ */
+static int check_valid_device_zone_sectors(struct dm_target *ti, struct dm_dev *dev,
 					   sector_t start, sector_t len, void *data)
 {
 	unsigned int *zone_sectors = data;
 
-	if (!bdev_is_zoned(dev->bdev))
+	if (!bdev_is_zoned(dev->bdev) ||
+	    dm_target_supports_emulated_zones(ti->type))
 		return 0;
+
 	return bdev_zone_sectors(dev->bdev) != *zone_sectors;
 }
 
@@ -1645,7 +1652,7 @@ static int validate_hardware_zoned_model(struct dm_table *t,
 	if (!zone_sectors)
 		return -EINVAL;
 
-	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
+	if (dm_table_any_dev_attr(t, check_valid_device_zone_sectors, &zone_sectors)) {
 		DMERR("%s: zone sectors is not consistent across all zoned devices",
 		      dm_device_name(t->md));
 		return -EINVAL;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 04c6acf7faaa..83e20de264c9 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -294,6 +294,15 @@ struct target_type {
 #define dm_target_supports_mixed_zoned_model(type) (false)
 #endif
 
+#ifdef CONFIG_BLK_DEV_ZONED
+#define DM_TARGET_EMULATED_ZONES	0x00000400
+#define dm_target_supports_emulated_zones(type) \
+	((type)->features & DM_TARGET_EMULATED_ZONES)
+#else
+#define DM_TARGET_EMULATED_ZONES	0x00000000
+#define dm_target_supports_emulated_zones(type) (false)
+#endif
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

