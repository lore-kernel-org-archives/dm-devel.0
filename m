Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B29C6FA83
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970976;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4lMGY7l0ydKW54nfZUaveVqR3g2fMMGLOcmcFwBtR9k=;
	b=WAwi3RrnHK1AzyEjXVAfEGwut7qWkiLRdoz4oGMRnu2onWUvMxKHW6V6xSBIkd7427fw/w
	sux3dNq723FlcNRxNkL1CiKAm9KVG/6e8dZPf1vY066Nwd6ntrbS0BOu/SSjU/c//qrEzF
	kLB8WCmsF2l4D0aEaVebUeSkANHM9tE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-0u1mn-FzOVCk2BaIkOvd-Q-1; Mon, 12 Sep 2022 04:22:53 -0400
X-MC-Unique: 0u1mn-FzOVCk2BaIkOvd-Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 379F080D2A2;
	Mon, 12 Sep 2022 08:22:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 25D6020290A5;
	Mon, 12 Sep 2022 08:22:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1AE0D1946A43;
	Mon, 12 Sep 2022 08:22:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7E5E81946A43
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 725C240C2065; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E5F640C2064
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56662811E81
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:49 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-jW4eav4jNq-tM-8IQeYnKQ-1; Mon, 12 Sep 2022 04:22:47 -0400
X-MC-Unique: jW4eav4jNq-tM-8IQeYnKQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082221euoutp011ca9378dcca3b011741af71f44e80bce~UD0K7Q6F81402514025euoutp01L
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220912082221euoutp011ca9378dcca3b011741af71f44e80bce~UD0K7Q6F81402514025euoutp01L
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220912082220eucas1p1402aa614a51566e2ee2e71ffbf935a8f~UD0JXW-uL1769017690eucas1p1V;
 Mon, 12 Sep 2022 08:22:20 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 09.56.07817.B3CEE136; Mon, 12
 Sep 2022 09:22:19 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220912082219eucas1p28467ed150230da8a65e4c957975fe438~UD0I7Dey-2083820838eucas1p2f;
 Mon, 12 Sep 2022 08:22:19 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220912082219eusmtrp266415810c8995ef489f25a93864d6eae~UD0I6NLGZ3116631166eusmtrp2T;
 Mon, 12 Sep 2022 08:22:19 +0000 (GMT)
X-AuditID: cbfec7f4-893ff70000011e89-e0-631eec3b1050
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 63.43.10862.B3CEE136; Mon, 12
 Sep 2022 09:22:19 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082219eusmtip1336c390f7f0bc0eb05deaa3e17686406~UD0ImHDEQ1320313203eusmtip1n;
 Mon, 12 Sep 2022 08:22:19 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:22:03 +0200
Message-Id: <20220912082204.51189-13-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsWy7djP87rWb+SSDdbfsrRYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDJ+XX3AXHBK
 rOL/+jbmBsa/Ql2MnBwSAiYSW9/vYOxi5OIQEljBKDH573I2COcLo8SXja+gnM+MEmubZ7LB
 tOzcdYMJIrGcUeL2m21Q/S8ZJWZvWgKU4eBgE9CSaOxkB2kQEUiX+D79HVgDs8A2Jon7D18w
 gySEBQIkVn85CDaVRUBVYtfjKWANvAJWEk+2zoXaJi8x89J3sDgnUPz1qlZGiBpBiZMzn7CA
 2MxANc1bZzODLJAQWM0p8WfZUiaIZheJ/Quns0DYwhKvjm9hh7BlJP7vnA9VUy3x9MZvqOYW
 Ron+nevZQD6QELCW6DuTA2IyC2hKrN+lD1HuKHF632Z2iAo+iRtvBSFO4JOYtG06M0SYV6Kj
 DRq8ShI7fz6BWiohcblpDtQxHhJrFt5gn8CoOAvJM7OQPDMLYe8CRuZVjOKppcW56anFRnmp
 5XrFibnFpXnpesn5uZsYgYnw9L/jX3YwLn/1Ue8QIxMH4yFGCQ5mJRFeFkPpZCHelMTKqtSi
 /Pii0pzU4kOM0hwsSuK8yZkbEoUE0hNLUrNTUwtSi2CyTBycUg1M62bl2lzNrfjrs+7vQZ/j
 z6N6E88xaMnGXQ7Zl//htc6R4oYTqkLy+4oe7fVr067KcdinPXmTf3znktQPfyRV5n80O7g9
 8VBXhLVI74vkGuVTPssuRNVe2rZjYvmav9Y8K1Okg2cwBrxPiP2yrPHY891CHkk+S+/s1dSN
 WcNytUOm43pMp2mYlmPVzYs2kWmJJT56fSX3OBNDj2evfsN7eNduiZLfRlXdVpkT2rVPf51d
 mSFh0s03d7vio2u7Tgcfti8LXcpefH/i79yZ0hMtX65RY3B1nf5Mg7mmgNPeTWjbjRCdDAbR
 W9vWKqvKNyzmCKt6t4vjorw3a1D1k8TCi0XR/QllwVo//5S2syixFGckGmoxFxUnAgDX21HR
 8wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xu7rWb+SSDb58lLJYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DJ+XX3AXHBKrOL/+jbmBsa/Ql2MnBwSAiYS
 O3fdYAKxhQSWMkqsPsQDEZeQuL2wiRHCFpb4c62LDaLmOaPEksuhXYwcHGwCWhKNnewgYRGB
 XInPK38AlXBxMAscYZL4+2oFM0hCWMBP4uS3iywgNouAqsSux1PAGngFrCSebJ3LBjFfXmLm
 pe9gcU6g+OtVrYwQuywlzn67AVUvKHFy5hOwOcxA9c1bZzNPYBSYhSQ1C0lqASPTKkaR1NLi
 3PTcYiO94sTc4tK8dL3k/NxNjMB43Xbs55YdjCtffdQ7xMjEwXiIUYKDWUmEl8VQOlmINyWx
 siq1KD++qDQntfgQoynQ3ROZpUST84EJI68k3tDMwNTQxMzSwNTSzFhJnNezoCNRSCA9sSQ1
 OzW1ILUIpo+Jg1OqgWlf9+4Eo3qWWWsvOcrFxV17yrzlZ9xNfaP0A+wnH4U/trFenaJy6IhL
 UMyqr9HXRM/HqNyYpbzsmPAc8bfzTs7fcLpz39Tg7D/Zwdw6D7fwNkyfflMlyYn3Y7Lq5s/u
 2z9wv36XId284uGdaULta2ryTsifkeyOqtirPFVs7qFDlg8Sb//pZsrZX6co13LlRddxVhnP
 SXcs5i6btPileUCa8uby/KWmn6oOnn526OqF+zW2bqtY20988li4pfn6W+//xVd/NcuudPbn
 OeO0q0yf5UnkxG32M+c8+LFm2UcLC5ltj3bwvDy+bPmnBcmpD/dH5z8siGNlm7Nwxdfp1yKP
 Psj8mFwVYOV5bnv5ju9CU5RYijMSDbWYi4oTAcuK/MhgAwAA
X-CMS-MailID: 20220912082219eucas1p28467ed150230da8a65e4c957975fe438
X-Msg-Generator: CA
X-RootMTR: 20220912082219eucas1p28467ed150230da8a65e4c957975fe438
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082219eucas1p28467ed150230da8a65e4c957975fe438
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082219eucas1p28467ed150230da8a65e4c957975fe438@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v13 12/13] dm: introduce DM_EMULATED_ZONES target
 feature flag
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
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce a new target feature flag: DM_EMULATED_ZONES for targets with
a different number of sectors per zone (aka zone size) than the underlying
device zone size.

This target feature flag is introduced as the existing zoned targets assume
that the target and the underlying device have the same zone size.
The new target: dm-po2zoned will use this new target feature flag
as it emulates the zone boundary that is different from the underlying
zoned device.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c         | 13 ++++++++++---
 include/linux/device-mapper.h |  9 +++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 38b83c383e8f..8324bd660f09 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1619,13 +1619,20 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
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
 
@@ -1650,7 +1657,7 @@ static int validate_hardware_zoned_model(struct dm_table *t,
 	if (!zone_sectors)
 		return -EINVAL;
 
-	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
+	if (dm_table_any_dev_attr(t, check_valid_device_zone_sectors, &zone_sectors)) {
 		DMERR("%s: zone sectors is not consistent across all zoned devices",
 		      dm_device_name(t->md));
 		return -EINVAL;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index f8e3a96b97b0..8504da98e829 100644
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

