Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 586DFC6FA8A
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662970981;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VMtgKCU1lhaHRBjTDdigTaDARFq1VkXSvvYMNBnv5n4=;
	b=KXsIJgEUFa4pRhjEMZvmoE9NkQ4yC/KmM/gXSkkuzuep443EJqb2fg2R3dxUXS3Oy7EKp8
	OtDu+5OWhHF/a7kgwClDLDMiKc1dpyyDVKEyexXVbGlPcFU+XWXVolDlLo+SzI5ajzw563
	/EZyF9m2AggrhLUTofZcP6ZzAWbkV00=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-363-9_dFraP6OIiNDFXoOJJtdA-1; Mon, 12 Sep 2022 04:22:57 -0400
X-MC-Unique: 9_dFraP6OIiNDFXoOJJtdA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00E913C0E22B;
	Mon, 12 Sep 2022 08:22:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E35BC140EBF4;
	Mon, 12 Sep 2022 08:22:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD0C31946A4E;
	Mon, 12 Sep 2022 08:22:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AED3B1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 08:22:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9392A2166B2B; Mon, 12 Sep 2022 08:22:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E0082166B2A
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 713C13810786
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:51 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-lvHxr1mOPsiEZFSyddA5xA-1; Mon, 12 Sep 2022 04:22:50 -0400
X-MC-Unique: lvHxr1mOPsiEZFSyddA5xA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220912082228euoutp025f08749d7dd18ec9e92ffcb0fb7ecf44~UD0RlOQgf2459224592euoutp021
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 08:22:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220912082228euoutp025f08749d7dd18ec9e92ffcb0fb7ecf44~UD0RlOQgf2459224592euoutp021
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220912082217eucas1p2f7bf2d8409887d0b45bb91d5e0838a8b~UD0HPCGjb2080820808eucas1p2G;
 Mon, 12 Sep 2022 08:22:17 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id D7.A3.19378.93CEE136; Mon, 12
 Sep 2022 09:22:17 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220912082217eucas1p15e4ba29d1438990db4acf5c3f6ca5d4f~UD0Gx0szG1088110881eucas1p1_;
 Mon, 12 Sep 2022 08:22:17 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220912082217eusmtrp2054a1249e949edbdccfec0c6c6024005~UD0Gw9xSo3116631166eusmtrp2M;
 Mon, 12 Sep 2022 08:22:17 +0000 (GMT)
X-AuditID: cbfec7f5-a35ff70000014bb2-6b-631eec39b733
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 01.43.10862.93CEE136; Mon, 12
 Sep 2022 09:22:17 +0100 (BST)
Received: from localhost (unknown [106.210.248.191]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220912082216eusmtip12dbcb83e6c6a0b4a645929a361eb1f31~UD0GZZdty0898808988eusmtip1i;
 Mon, 12 Sep 2022 08:22:16 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, agk@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk, snitzer@kernel.org
Date: Mon, 12 Sep 2022 10:22:01 +0200
Message-Id: <20220912082204.51189-11-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWy7djP87qWb+SSDXbfULVYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDIevLnKUvCO
 t2LP7CamBsaZ3F2MnBwSAiYSq5YuZe5i5OIQEljBKPHv9ldGCOcLo8T9eYdYQKqEBD4zSkxf
 5QjTcWv7RiaIouWMEl93NrNDOC8ZJT682QTUwcHBJqAl0djJDtIgIpAu8X36O7AGZoFtTBL3
 H75gBkkIC0RKTPvbwARiswioSsyb3swIYvMKWEk8OryVGWKbvMTMS9/BBnECxV+vaoWqEZQ4
 OfMJ2HXMQDXNW2dD1W/mlHg7RQjCdpHo7jvHBGELS7w6voUdwpaR+L9zPlS8WuLpjd9g/0sI
 tDBK9O9czwbygISAtUTfmRwQk1lAU2L9Ln2IckeJ13enM0FU8EnceCsIcQGfxKRt05khwrwS
 HW1QByhJ7Pz5BGqphMTlpjksELaHxO21b9knMCrOQvLLLCS/zELYu4CReRWjeGppcW56arFx
 Xmq5XnFibnFpXrpecn7uJkZgEjz97/jXHYwrXn3UO8TIxMF4iFGCg1lJhJfFUDpZiDclsbIq
 tSg/vqg0J7X4EKM0B4uSOG9y5oZEIYH0xJLU7NTUgtQimCwTB6dUA5PeA77TFkoSQvp2pZH6
 b49wfVVeGLD+9rRTLWvDj3C8YFcrK678JbXmXcPNCkO2Wb43eZbqvxD/GT9HPmHd5QOfv4dH
 XC294sVq8u+391n398Zic/RuvSgPlV1zJOzzCTtVju6lsx823Mts1nGQn7Pmz6y6KX6/Dy+a
 vpPNM7BG98SuhxcOpHxiY97gfcn/4c8mGVlHweDXLxeV/Eh+XGBtXXw42Pif+s4TC1042TND
 7ZSVv26dKiLHl7HuwQvN6Uz5G8o1zSZ3pit/W/T0EPv28tcnZbqLDivFzDSTmFVrI9v/jIcx
 0F39odbpN0fPzumy/nlop5jU/flBj57v/7TEZIUtd/nO67eyGlIvTbBUYinOSDTUYi4qTgQA
 DhdU2/EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/xu7qWb+SSDea8YrNYf+oYs8Xqu/1s
 FtM+/GS2+H32PLPF3nezWS1uHtjJZLFn0SQmi5WrjzJZPFk/i9nib9c9Jou9t7QtLu+aw2Yx
 f9lTdosJbV+ZLT4vbWG3WHPzKYvFiVvSDoIel694e+ycdZfd4/LZUo9NqzrZPDYvqffYfbOB
 zWNn631Wj/f7rrJ59G1Zxeix+XS1x+dNch7tB7qZAnii9GyK8ktLUhUy8otLbJWiDS2M9Awt
 LfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DIevLnKUvCOt2LP7CamBsaZ3F2MnBwSAiYS
 t7ZvZOpi5OIQEljKKDH/yz8WiISExO2FTYwQtrDEn2tdbCC2kMBzRonjt6u7GDk42AS0JBo7
 2UHCIgK5Ep9X/mADmcMscIRJ4u+rFcwgCWGBcInb6w+D2SwCqhLzpjeDzeQVsJJ4dHgrM8R8
 eYmZl76DDeIEir9e1coIsctS4uy3G+wQ9YISJ2c+AbuNGai+eets5gmMArOQpGYhSS1gZFrF
 KJJaWpybnltspFecmFtcmpeul5yfu4kRGLHbjv3csoNx5auPeocYmTgYDzFKcDArifCyGEon
 C/GmJFZWpRblxxeV5qQWH2I0Bbp7IrOUaHI+MGXklcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJ
 pCeWpGanphakFsH0MXFwSjUw7cmqNvL9e3jp6Sfnexp9apbMenLnXMI+mbK3XsvmsuU/DfsX
 MUXB/Sf3EnatbOUzgryLme8v5n2/1GWOF+vuJ6Gpf34svCrVs9LQIYy3UPbcnZMzMrfP13oc
 4qfapeomteDY586pC5q7ZV/ufrbbJSKwWfBtgdGcBTdOWkifmaWjfeL/5aj8Y1cN82Y63ec7
 eLFl5tw90w/sv6v/b93U75rH/3atE/5jE/9Tqundg43fkh4/V5wqVqxTt9T+80INja9eS+z3
 Hmm/GvLw/TXRzOO8JtdTORqXbX0seX1lZk+1fsWfQ4KlZYI1mfyJAWtPc516f9HM4vnNHZn1
 PCmu+2ed2fbx2p8I1oIr93dru79UYinOSDTUYi4qTgQAPQVwpmEDAAA=
X-CMS-MailID: 20220912082217eucas1p15e4ba29d1438990db4acf5c3f6ca5d4f
X-Msg-Generator: CA
X-RootMTR: 20220912082217eucas1p15e4ba29d1438990db4acf5c3f6ca5d4f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220912082217eucas1p15e4ba29d1438990db4acf5c3f6ca5d4f
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082217eucas1p15e4ba29d1438990db4acf5c3f6ca5d4f@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v13 10/13] dm-table: allow zoned devices with non
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
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Allow dm to support zoned devices with non power-of-2(po2) zone sizes as
the block layer now supports it.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
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

