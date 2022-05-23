Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2B8FC4167B
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 16:16:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-dyigREDVNlCau5bdjaqSYA-1; Mon, 23 May 2022 12:16:17 -0400
X-MC-Unique: dyigREDVNlCau5bdjaqSYA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 259BA1C0CE67;
	Mon, 23 May 2022 16:16:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3AB7C7C4F;
	Mon, 23 May 2022 16:16:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 52F92194705A;
	Mon, 23 May 2022 16:16:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 081771947059
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 16:16:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EFF9A112131E; Mon, 23 May 2022 16:16:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EB5A41121314
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1BBD1C0CE60
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:12 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-A3UuqilXMYSVzKk3ZMpJ6A-1; Mon, 23 May 2022 12:16:11 -0400
X-MC-Unique: A3UuqilXMYSVzKk3ZMpJ6A-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220523161609euoutp0223046015911dcf52e80d9c269264f728~xyB4fqiIS1880118801euoutp02K
 for <dm-devel@redhat.com>; Mon, 23 May 2022 16:16:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220523161609euoutp0223046015911dcf52e80d9c269264f728~xyB4fqiIS1880118801euoutp02K
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220523161608eucas1p143166bad2bfc87c8a63cae98d3176bc9~xyB2_9lVd1546315463eucas1p1P;
 Mon, 23 May 2022 16:16:08 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id 37.7E.09887.843BB826; Mon, 23
 May 2022 17:16:08 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220523161607eucas1p2b6245eafb81dee3e2efbec3ab86a854d~xyB2jZFqS0957009570eucas1p2Y;
 Mon, 23 May 2022 16:16:07 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220523161607eusmtrp233ab159abe41b38a4d3ff39500eb5828~xyB2inzO30219402194eusmtrp2F;
 Mon, 23 May 2022 16:16:07 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-16-628bb3482653
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id FA.92.09522.743BB826; Mon, 23
 May 2022 17:16:07 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220523161607eusmtip2323c9d601f46486d915afc977081c585~xyB2MHWoU0812708127eusmtip2M;
 Mon, 23 May 2022 16:16:07 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, hare@suse.de, Johannes.Thumshirn@wdc.com
Date: Mon, 23 May 2022 18:15:57 +0200
Message-Id: <20220523161601.58078-4-p.raghav@samsung.com>
In-Reply-To: <20220523161601.58078-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7djP87oem7uTDF4s5rdYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBZ7Fk1isli5+iiTxZP1s5gteg58YLH423WPyWLvLW2Ly7vmsFnM
 X/aU3eLGhKeMFp+XtrBbtG38yugg4PHvxBo2j8tnSz02repk89i8pN5j980GNo+drfdZPd7v
 u8rm0bdlFaPH+i1XWTw2n672+LxJzqP9QDdTAE8Ul01Kak5mWWqRvl0CV8bXiydYCq6IVly9
 vZ61gfGZYBcjJ4eEgInEupmTmLsYuTiEBFYwShzc9pkFJCEk8IVR4vQ0H4jEZ0aJeTNPscF1
 zJnKApFYzijx80MjG4TzglFiRv8exi5GDg42AS2Jxk52kLiIQCOjxPuj81hBHGaB2UwS5x5c
 YwUZJSwQIfHw0m4wm0VAVaJn1hx2EJtXwFJiYfMPVoh18hIzL30Hi3MKWElcv3qVDaJGUOLk
 zCdgtzID1TRvnQ32hITAak6JM/MvMUM0u0ise3kcapCwxKvjW9ghbBmJ/zvnM0HY1RJPb/yG
 am5hlOjfuZ4N5AUJAWuJvjM5ICazgKbE+l36EOWOEm1PJzNCVPBJ3HgrCHECn8SkbdOZIcK8
 Eh1tQhDVShI7fz6BWiohcblpDguE7SFxuf0j6wRGxVlInpmF5JlZCHsXMDKvYhRPLS3OTU8t
 NspLLdcrTswtLs1L10vOz93ECEyBp/8d/7KDcfmrj3qHGJk4GA8xSnAwK4nwbk/sSBLiTUms
 rEotyo8vKs1JLT7EKM3BoiTOm5y5IVFIID2xJDU7NbUgtQgmy8TBKdXA1CgV+trUNi5xhvIr
 4e0fftSdtNi0S/eg/O8fDzLOLJErizTzC3pgPTF7XmfWWzcB//wlG8/amkxc832a+qYCNcNm
 E/3fi4505y8JLfqZN2F7166DBdkN3UZNxl9vrenmLFntuWOrhZ3YQpPjYY2y/g1LX5r66x1m
 tWLZVsW4rFza5tjUzanLN5Y2b1r5uOrzg4kXS/9/vHunM6Py7GvRXwbVHyXc7wdclNTsuHyn
 dsvR9h6HI+Y+TWJOv+N/3ePY2bnv0RrjeZ1ex+S/TUzUn3lsZYzv1vjXRyN652yUC/j+aPqX
 WsGExu5J84NkX3t8X70vYmvK64f7tM93d8m//7lp/VKZn71zy77kXtbWsFFiKc5INNRiLipO
 BACvjWFD8AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t/xe7rum7uTDP7f1rFYfbefzeL32fPM
 FnvfzWa1uPCjkcni5oGdTBZ7Fk1isli5+iiTxZP1s5gteg58YLH423WPyWLvLW2Ly7vmsFnM
 X/aU3eLGhKeMFp+XtrBbtG38yugg4PHvxBo2j8tnSz02repk89i8pN5j980GNo+drfdZPd7v
 u8rm0bdlFaPH+i1XWTw2n672+LxJzqP9QDdTAE+Unk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6R
 iaWeobF5rJWRqZK+nU1Kak5mWWqRvl2CXsbXiydYCq6IVly9vZ61gfGZYBcjJ4eEgInEujlT
 WboYuTiEBJYySqxeeoYFIiEhcXthEyOELSzx51oXG0TRM0aJz3snADkcHGwCWhKNnewgcRGB
 TkaJoytOgU1iFljOJPFyzWKwbmGBMIm7k/ezgdgsAqoSPbPmsIPYvAKWEgubf7BCbJCXmHnp
 O1icU8BK4vrVq2D1QkA1p9ZPgKoXlDg58wnYdcxA9c1bZzNPYBSYhSQ1C0lqASPTKkaR1NLi
 3PTcYkO94sTc4tK8dL3k/NxNjMB43Xbs5+YdjPNefdQ7xMjEwXiIUYKDWUmEd3tiR5IQb0pi
 ZVVqUX58UWlOavEhRlOguycyS4km5wMTRl5JvKGZgamhiZmlgamlmbGSOK9nQUeikEB6Yklq
 dmpqQWoRTB8TB6dUA1Ou8GyW5w7e4U2MEbvZffiyuzc5c892XjyJWd90PxN3+2quz32Hfqa6
 F/X8+Trl24UnlyT1PE1XbYyZHLAr6pcf2/mr169/77uV8/7QwVe51TsPhpmLCc9afPQrX+Tr
 bVP/PS++ZNN9q7DzTKjhtgefu28V16a+v6viOVG+ceoBnqWreh73z1zXyJl60/Tcwa9q/pUb
 +J705756PVt2m2zPibXPJgsk3fx6zcZVt/2L2Hql5L1FIlPP31KukK9c5a56fZYME39SWW0U
 d/f+1ttrUyQWH364+/vcCB7GfbMdjv4Iz5/p22Ntbup8fdfm3Qevy0d/PaOz6d2l90xKMxOs
 lTb8bQl4tEZ+x4VO7nIOJZbijERDLeai4kQA/5ecNWADAAA=
X-CMS-MailID: 20220523161607eucas1p2b6245eafb81dee3e2efbec3ab86a854d
X-Msg-Generator: CA
X-RootMTR: 20220523161607eucas1p2b6245eafb81dee3e2efbec3ab86a854d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220523161607eucas1p2b6245eafb81dee3e2efbec3ab86a854d
References: <20220523161601.58078-1-p.raghav@samsung.com>
 <CGME20220523161607eucas1p2b6245eafb81dee3e2efbec3ab86a854d@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH v5 3/7] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the condition which disallows non-power_of_2 zone size ZNS drive
to be updated and use generic method to calculate number of zones
instead of relying on log and shift based calculation on zone size.

The power_of_2 calculation has been replaced directly with generic
calculation without special handling. Both modified functions are not
used in hot paths, they are only used during initialization &
revalidation of the ZNS device.

As rounddown macro from math.h does not work for 32 bit architectures,
round down operation is open coded.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/host/zns.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 9f81beb4df4e..d92f937d5cb9 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -101,13 +101,6 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
 	}
 
 	ns->zsze = nvme_lba_to_sect(ns, le64_to_cpu(id->lbafe[lbaf].zsze));
-	if (!is_power_of_2(ns->zsze)) {
-		dev_warn(ns->ctrl->device,
-			"invalid zone size:%llu for namespace:%u\n",
-			ns->zsze, ns->head->ns_id);
-		status = -ENODEV;
-		goto free_data;
-	}
 
 	blk_queue_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
@@ -128,8 +121,13 @@ static void *nvme_zns_alloc_report_buffer(struct nvme_ns *ns,
 	const size_t min_bufsize = sizeof(struct nvme_zone_report) +
 				   sizeof(struct nvme_zone_descriptor);
 
+	/*
+	 * Division is used to calculate nr_zones with no special handling
+	 * for power of 2 zone sizes as this function is not invoked in a
+	 * hot path
+	 */
 	nr_zones = min_t(unsigned int, nr_zones,
-			 get_capacity(ns->disk) >> ilog2(ns->zsze));
+			 div64_u64(get_capacity(ns->disk), ns->zsze));
 
 	bufsize = sizeof(struct nvme_zone_report) +
 		nr_zones * sizeof(struct nvme_zone_descriptor);
@@ -182,6 +180,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	int ret, zone_idx = 0;
 	unsigned int nz, i;
 	size_t buflen;
+	u64 remainder = 0;
 
 	if (ns->head->ids.csi != NVME_CSI_ZNS)
 		return -EINVAL;
@@ -197,7 +196,11 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	c.zmr.zrasf = NVME_ZRASF_ZONE_REPORT_ALL;
 	c.zmr.pr = NVME_REPORT_ZONE_PARTIAL;
 
-	sector &= ~(ns->zsze - 1);
+	/*
+	 * Round down the sector value to the nearest zone start
+	 */
+	div64_u64_rem(sector, ns->zsze, &remainder);
+	sector -= remainder;
 	while (zone_idx < nr_zones && sector < get_capacity(ns->disk)) {
 		memset(report, 0, buflen);
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

