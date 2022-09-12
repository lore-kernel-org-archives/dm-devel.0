Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B50CECAAD5
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970959;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GtD+QLCUkAGEt1ATPqW4y11l5FrMyuosGYXU5OjuxbI=;
	b=gYb35cwxB8SA/BkjfvULA/+zH/vxM7dteBICSjaFJKHenp4Fg5YIrBDg3nK14DqRRX+Uoe
	pMybYhu5sSyvhEZK55K4YRpmGjviQV9dsySScp+2NIxz+W8MpLxaWvbLGB1NxFAmDDgug+
	jyzxkvDRbV23u64plm2SoW5wwb44MT8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-hDRaRzkENUajsT-ubVAiXQ-1; Mon, 12 Sep 2022 04:22:36 -0400
X-MC-Unique: hDRaRzkENUajsT-ubVAiXQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A700029AA384;
	Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 93E702027062;
	Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 843A71946A43;
	Mon, 12 Sep 2022 08:22:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4173A1946A44
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2EC0E492B06; Mon, 12 Sep 2022 08:22:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B5DB492B05
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 152213810798
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:33 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-xZNuS2_GMnuC5gAfc4AO5g-1; Mon, 12 Sep 2022 04:22:31 -0400
X-MC-Unique: xZNuS2_GMnuC5gAfc4AO5g-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082215euoutp01eba114e3acd66879032c58195380a901~UD0E9GZuY1428914289euoutp01P
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220912082215euoutp01eba114e3acd66879032c58195380a901~UD0E9GZuY1428914289euoutp01P
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082213eucas1p2f46e7a125861f32b6781e8a09d5f8eb4~UD0DIBvFE2083820838eucas1p2T;
 Mon, 12 Sep 2022 08:22:13 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id E9.98.29727.53CEE136; Mon, 12
 Sep 2022 09:22:13 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220912082212eucas1p1032064dd2ac1638d7d18be7e6fe5344e~UD0CdqmFI1461814618eucas1p1o;
 Mon, 12 Sep 2022 08:22:12 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220912082212eusmtrp2c8b581788d5d7886c123129df284080b~UD0CcrZHl3082830828eusmtrp2g;
 Mon, 12 Sep 2022 08:22:12 +0000 (GMT)
X-AuditID: cbfec7f2-7932da800001741f-fc-631eec35cae0
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 5B.33.10862.43CEE136; Mon, 12
 Sep 2022 09:22:12 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082212eusmtip2ed666c70861a0e51ee5767060b80e032~UD0CGqnNM2388123881eusmtip2h;
 Mon, 12 Sep 2022 08:22:12 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:21:57 +0200
Message-Id: <20220912082204.51189-7-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsWy7djP87qmb+SSDeZ1CVisP3WM2WL13X42
 i2kffjJb/D57ntli77vZrBY3D+xkstizaBKTxcrVR5ksnqyfxWzxt+sek8XeW9oWl3fNYbOY
 v+wpu8WEtq/MFjcmPGW0+Ly0hd1izc2nLBYnbkk7CHlcvuLtsXPWXXaPy2dLPTat6mTz2Lyk
 3mP3zQY2j52t91k93u+7yubRt2UVo8fm09UenzfJebQf6GYK4InisklJzcksSy3St0vgyth+
 eBJzwS/piqWL+1gbGK+IdzFyckgImEic2fmbFcQWEljBKDHlnUgXIxeQ/YVRYsGJCYwQzmdG
 ie//prDBdMxY9poJomM5o8TRz8wQRS8ZJe6dnwKU4OBgE9CSaOxkB6kREUiX+D79HRNIDbPA
 HSaJpkMvGEESwgKREodfbAAbyiKgKrF2zz+wOK+ApUTv8TvsEMvkJWZe+g5mcwpYSbxe1QpV
 IyhxcuYTFhCbGaimeetssCMkBDZzSqw/vZcZotlF4sf6lSwQtrDEq+NboIbKSPzfOZ8Jwq6W
 eHrjN1RzC6NE/871bCAfSAhYS/SdyQExmQU0Jdbv0ocod5RoWTOPHaKCT+LGW0GIE/gkJm2b
 zgwR5pXoaBOCqFaS2PnzCdRSCYnLTXOgjvGQaGj7wD6BUXEWkmdmIXlmFsLeBYzMqxjFU0uL
 c9NTiw3zUsv1ihNzi0vz0vWS83M3MQLT4el/xz/tYJz76qPeIUYmDsZDjBIczEoivCyG0slC
 vCmJlVWpRfnxRaU5qcWHGKU5WJTEeZMzNyQKCaQnlqRmp6YWpBbBZJk4OKUamJI+a+64xVvD
 l9TlunTj0RNSSg0iHx/cmNz4ZXGJ2/LQ0tcz+G5I2ItL7J0n8dNzqs/Kp8yNgqt528M9E3XF
 JvxnDHRwqljefOSF8sN6ZxfBu+X/25pETdIcNtmUPlJbePe3uLd//+MvZxYUH/872X16Ua/H
 tb2G7m7XWZJ7ohqmK82O3CZh0sc7feKTWLvoHbmPNKKFYwwuyH+eu7jWVz/3W7Oa3kyxS89u
 ifo8+HW3tOr40kLleoHVJZ6i64XE+DZcrmqUXt39nFHvSNEPlpX1XfldD6QvVTzKnhezcnrv
 5e4TF3lSz/PMNnjv+eS3/9yVscxybcq6mV5PFV5yfbjLvuSjf/Pewy+37svyU2Ipzkg01GIu
 Kk4EACa4u8b2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t/xe7omb+SSDS5MlLdYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLW5MeMpo8XlpC7vFmptPWSxO3JJ2EPK4fMXbY+esu+wel8+Wemxa1cnmsXlJ
 vcfumw1sHjtb77N6vN93lc2jb8sqRo/Np6s9Pm+S82g/0M0UwBOlZ1OUX1qSqpCRX1xiqxRt
 aGGkZ2hpoWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5egl7H98CTmgl/SFUsX97E2MF4R72Lk
 5JAQMJGYsew1E4gtJLCUUWL6OQOIuITE7YVNjBC2sMSfa11sEDXPGSUerJDpYuTgYBPQkmjs
 ZAcJiwjkSnxe+QOohIuDWeANk8SXJZPAZgoLhEv0/P8OVsQioCqxds8/sJm8ApYSvcfvsEPM
 l5eYeQmihlPASuL1qlZGiF2WEme/3WCHqBeUODnzCQuIzQxU37x1NvMERoFZSFKzkKQWMDKt
 YhRJLS3OTc8tNtIrTswtLs1L10vOz93ECIzcbcd+btnBuPLVR71DjEwcjIcYJTiYlUR4WQyl
 k4V4UxIrq1KL8uOLSnNSiw8xmgLdPZFZSjQ5H5g68kriDc0MTA1NzCwNTC3NjJXEeT0LOhKF
 BNITS1KzU1MLUotg+pg4OKUamDZZXnHcZ8xcKr2+sbe3XGLW7O+Hve8x/ZLb7OF+kD+o7Mvs
 krwzRxOFuS7uuScvPpMrc9/1HQ8/hx4K7b66MHvFg9rbE0Sa/i77+X/2Z3a1jY/5rVKc39Vv
 P71c8Mjp+LhQtU+bKxK5rCe8/2+wVuvF4aYpE9atfPLd7euvpcs23Pty4/enaCOT6wwVVlfT
 7k9U8PSLl4xdG3FJs/bV9Kovy3RKJrQLfP4WvUJ7e8Wso59K76//8yx+ZeGbKycu1jk8zb/J
 6j5j2taKbe1XN5jNPCGWEBfcxmKosHYJ/+5Mx/cfFtoJ3evzLnlw3i1kz/o9H1YLRKZI3hX6
 Kh9qomo26bfqd7Fzh1NecBw13FDWrsRSnJFoqMVcVJwIAIZeR6plAwAA
X-CMS-MailID: 20220912082212eucas1p1032064dd2ac1638d7d18be7e6fe5344e
X-Msg-Generator: CA
X-RootMTR: 20220912082212eucas1p1032064dd2ac1638d7d18be7e6fe5344e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082212eucas1p1032064dd2ac1638d7d18be7e6fe5344e
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082212eucas1p1032064dd2ac1638d7d18be7e6fe5344e@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v13 06/13] null_blk: allow zoned devices with non
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
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert the power-of-2(po2) based calculation with zone size to be generic
in null_zone_no with optimization for po2 zone sizes.

The nr_zones calculation in null_init_zoned_dev has been replaced with a
division without special handling for po2 zone sizes as this function is
called only during the initialization and will not be invoked in the hot
path.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/block/null_blk/main.c     |  5 ++---
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/block/null_blk/zoned.c    | 18 +++++++++++-------
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 1f154f92f4c2..3b24125d8594 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1976,9 +1976,8 @@ static int null_validate_conf(struct nullb_device *dev)
 	if (dev->queue_mode == NULL_Q_BIO)
 		dev->mbps = 0;
 
-	if (dev->zoned &&
-	    (!dev->zone_size || !is_power_of_2(dev->zone_size))) {
-		pr_err("zone_size must be power-of-two\n");
+	if (dev->zoned && !dev->zone_size) {
+		pr_err("Invalid zero zone size\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 94ff68052b1e..f63b6bed1bb3 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -83,6 +83,7 @@ struct nullb_device {
 	unsigned int imp_close_zone_no;
 	struct nullb_zone *zones;
 	sector_t zone_size_sects;
+	unsigned int zone_size_sects_shift;
 	bool need_zone_res_mgmt;
 	spinlock_t zone_res_lock;
 
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 55a69e48ef8b..015f6823706c 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -16,7 +16,10 @@ static inline sector_t mb_to_sects(unsigned long mb)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
-	return sect >> ilog2(dev->zone_size_sects);
+	if (dev->zone_size_sects_shift)
+		return sect >> dev->zone_size_sects_shift;
+
+	return div64_u64(sect, dev->zone_size_sects);
 }
 
 static inline void null_lock_zone_res(struct nullb_device *dev)
@@ -65,10 +68,6 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	sector_t sector = 0;
 	unsigned int i;
 
-	if (!is_power_of_2(dev->zone_size)) {
-		pr_err("zone_size must be power-of-two\n");
-		return -EINVAL;
-	}
 	if (dev->zone_size > dev->size) {
 		pr_err("Zone size larger than device capacity\n");
 		return -EINVAL;
@@ -86,9 +85,14 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
-	dev->nr_zones = round_up(dev_capacity_sects, dev->zone_size_sects)
-		>> ilog2(dev->zone_size_sects);
 
+	if (is_power_of_2(dev->zone_size_sects))
+		dev->zone_size_sects_shift = ilog2(dev->zone_size_sects);
+	else
+		dev->zone_size_sects_shift = 0;
+
+	dev->nr_zones =	DIV_ROUND_UP_SECTOR_T(dev_capacity_sects,
+					      dev->zone_size_sects);
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct nullb_zone),
 				    GFP_KERNEL | __GFP_ZERO);
 	if (!dev->zones)
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

