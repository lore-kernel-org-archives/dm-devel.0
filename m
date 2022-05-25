Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DAB6C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 15:53:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-zyWMYdYPOcWN2zw_zj_smQ-1; Wed, 25 May 2022 11:53:52 -0400
X-MC-Unique: zyWMYdYPOcWN2zw_zj_smQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E46EA29DD9AC;
	Wed, 25 May 2022 15:53:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D2C7B2026D07;
	Wed, 25 May 2022 15:53:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4EBCF1932129;
	Wed, 25 May 2022 15:53:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ADE23194EB82
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 May 2022 15:50:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9CB77492CA2; Wed, 25 May 2022 15:50:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 989E0492C3B
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81DCF39F9CA2
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:09 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-8qAYxLvVNRK7Qqr37-GBpw-1; Wed, 25 May 2022 11:50:07 -0400
X-MC-Unique: 8qAYxLvVNRK7Qqr37-GBpw-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220525155006euoutp01a41b58f0ea44e26bbf7bec17dfb2079e~yY9sqTCyt0320303203euoutp01P
 for <dm-devel@redhat.com>; Wed, 25 May 2022 15:50:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220525155006euoutp01a41b58f0ea44e26bbf7bec17dfb2079e~yY9sqTCyt0320303203euoutp01P
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220525155004eucas1p2dfa1a7a6b945f9b09d92979e69409947~yY9rKj9GH0574305743eucas1p2V;
 Wed, 25 May 2022 15:50:04 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id D8.43.09887.C205E826; Wed, 25
 May 2022 16:50:04 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220525155004eucas1p162c6f43536424f93800ba788ed045363~yY9qwmLNY1064710647eucas1p1p;
 Wed, 25 May 2022 15:50:04 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220525155004eusmtrp26fd7b673c6e99ce337989ba209192d6f~yY9qvwSZQ0177001770eusmtrp2Z;
 Wed, 25 May 2022 15:50:04 +0000 (GMT)
X-AuditID: cbfec7f4-45bff7000000269f-6c-628e502c8c17
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id A0.9E.09404.B205E826; Wed, 25
 May 2022 16:50:03 +0100 (BST)
Received: from localhost (unknown [106.210.248.20]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220525155003eusmtip11ab0a9c1aac41be6c73f997f027f7090~yY9qdZ3lV1835018350eusmtip1C;
 Wed, 25 May 2022 15:50:03 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: axboe@kernel.dk, damien.lemoal@opensource.wdc.com, snitzer@redhat.com,
 Johannes.Thumshirn@wdc.com, hch@lst.de, hare@suse.de
Date: Wed, 25 May 2022 17:49:53 +0200
Message-Id: <20220525154957.393656-5-p.raghav@samsung.com>
In-Reply-To: <20220525154957.393656-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKKsWRmVeSWpSXmKPExsWy7djP87o6AX1JBgcOy1isvtvPZjHtw09m
 i99nzzNb7H03m9Xiwo9GJoubB3YyWexZNInJYuXqo0wWT9bPYrboOfCBxeJv1z0mi723tC0u
 75rDZjF/2VN2ixsTnjJafF7awm7RtvEro4Ogx+Ur3h7/Tqxh87h8ttRj06pONo/NS+o9dt9s
 YPPY2Xqf1eP9vqtsHn1bVjF6rN9ylcVj8+lqj8+b5DzaD3QzBfBGcdmkpOZklqUW6dslcGWc
 XGNZcJK/Yte5x+wNjPN4uxg5OSQETCS+7VjN3sXIxSEksIJRYu+u86wQzhdGiWNrGpkhnM+M
 EksvdrHDtOxeepcNIrGcUeLhrP2MEM4LRom+DXOYuhg5ONgEtCQaO8Hmigg0MkpMfXkCrIhZ
 4BuTxJI53Uwgo4QFwiS+vl0DNpZFQFXi6MWP7CDNvAJWEvPnREFsk5eYeek7WAmngLXE/P2f
 mUFsXgFBiZMzn7CA2MxANc1bZ4OdKiGwnVNiydU9bBDNLhIn9m+EsoUlXh3fAvWCjMT/nfOZ
 IOxqiac3fkM1tzBK9O9czwZyhATQtr4zOSAms4CmxPpd+hDljkD3fGCHqOCTuPFWEOIEPolJ
 26YzQ4R5JTrahCCqlSR2/nwCtVRC4nLTHBYI20Pix6OJTBMYFWcheWYWkmdmIexdwMi8ilE8
 tbQ4Nz212CgvtVyvODG3uDQvXS85P3cTIzAlnv53/MsOxuWvPuodYmTiYDzEKMHBrCTCe+Fp
 b5IQb0piZVVqUX58UWlOavEhRmkOFiVx3uTMDYlCAumJJanZqakFqUUwWSYOTqkGpqqEc/Mc
 zy2ou3L5HN9ttYl8J5Lf+s6RKHoc6xg+U+nNiV/Bvsm6X1L04oOu3W/IDWbJtVMQ6ntfYHhV
 LeSB0vmrqw81Ky6MyPfcuuMEV4vuC6ZnkkeYTBVeNL6I3MZ3V0oi4xC71d8k1vg8rq9boucV
 TFlTb/uA/8CNrdumbFI6W+z8WOCwxWqL5yndvV1CYY6/DtzN3bhFc+a3L60MS2ceOHq9ZsW5
 8k+XTBtEl94pffvuXV9Cg1bGvBcRP57L/FKPlN0bf+jpzVyL6PL9rQ9WMty5wpuix+XJXi65
 d8X36K38exJ87x803rApYH/m3Ud23iv/XpWde3teF7Ojn96pdXMcLnw8yfhAeU6US64SS3FG
 oqEWc1FxIgAWfEAC+AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t/xu7raAX1JBqcf2lisvtvPZjHtw09m
 i99nzzNb7H03m9Xiwo9GJoubB3YyWexZNInJYuXqo0wWT9bPYrboOfCBxeJv1z0mi723tC0u
 75rDZjF/2VN2ixsTnjJafF7awm7RtvEro4Ogx+Ur3h7/Tqxh87h8ttRj06pONo/NS+o9dt9s
 YPPY2Xqf1eP9vqtsHn1bVjF6rN9ylcVj8+lqj8+b5DzaD3QzBfBG6dkU5ZeWpCpk5BeX2CpF
 G1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GWcXGNZcJK/Yte5x+wNjPN4uxg5
 OSQETCR2L73LBmILCSxllFh6IwciLiFxe2ETI4QtLPHnWhdQDRdQzTNGiYYnF4ESHBxsAloS
 jZ3sIHERgU5GiTn7WsEcZoEmZolzC9czgxQJC4RIvG3jABnEIqAqcfTiR3aQMK+AlcT8OVEQ
 8+UlZl76zg5icwpYS8zf/5kZ4h4ria93vrKC2LwCghInZz5hAbGZgeqbt85mnsAoMAtJahaS
 1AJGplWMIqmlxbnpucVGesWJucWleel6yfm5mxiBkbvt2M8tOxhXvvqod4iRiYPxEKMEB7OS
 CO+Fp71JQrwpiZVVqUX58UWlOanFhxhNgc6eyCwlmpwPTB15JfGGZgamhiZmlgamlmbGSuK8
 ngUdiUIC6YklqdmpqQWpRTB9TBycUg1M3JOrAro0JyveN36aE7Q8uXR/7N4vigU7mxfWMifo
 8r8PZFLqeBS8VmmefMwJM80HkkbLtigt8uQvyD/9bWuLKO9mLzHpxq2MnKeFXEv2CKjb/wj+
 tmT2nLDoRxceKlWVXJn7ZL/vZGOf7gp/EVH5lksN/cqPXXZOritM1HjEU2j+o0Y1S3JvfuT5
 qDef77y+M3vmry1lphNNfhcsc9n2/yXfrNPP4rMChefc/CeSLKMwY/muZ1xHzoa+msRTtcVl
 a/n/vXWGGdPaJPQ0hbWu1l5YaLn99L27CgI+LTXf2Gc7nNhfs32S0Vu5ZxXvO57FZczdvv8u
 Y25qV/wLmwdX/z33LPv+azO3g5aRdliMEktxRqKhFnNRcSIANKoc7WUDAAA=
X-CMS-MailID: 20220525155004eucas1p162c6f43536424f93800ba788ed045363
X-Msg-Generator: CA
X-RootMTR: 20220525155004eucas1p162c6f43536424f93800ba788ed045363
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220525155004eucas1p162c6f43536424f93800ba788ed045363
References: <20220525154957.393656-1-p.raghav@samsung.com>
 <CGME20220525155004eucas1p162c6f43536424f93800ba788ed045363@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v6 4/8] nvmet: Allow ZNS target to support
 non-power_of_2 zone sizes
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, Bart Van Assche <bvanassche@acm.org>,
 gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, dsterba@suse.com,
 jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A generic bdev_zone_no helper is added to calculate zone number for a given
sector in a block device. This helper internally uses blk_queue_zone_no to
find the zone number.

Use the helper bdev_zone_no() to calculate nr of zones. This let's us
make modifications to the math if needed in one place and adds now
support for npo2 zone devices.

Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/target/zns.c | 2 +-
 include/linux/blkdev.h    | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index e34718b09550..e41b6a6ef048 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -243,7 +243,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
 	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
 
 	return blkdev_nr_zones(req->ns->bdev->bd_disk) -
-		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
+	       bdev_zone_no(req->ns->bdev, sect);
 }
 
 static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f5c7a41032ba..ed8742a72dcb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1382,6 +1382,13 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 	return 0;
 }
 
+static inline unsigned int bdev_zone_no(struct block_device *bdev, sector_t sec)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	return blk_queue_zone_no(q, sec);
+}
+
 static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

