Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6780BC43219
	for <dm-devel@archiver.kernel.org>; Fri,  6 May 2022 08:11:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-4GCSeZo5ORCiTMbaNIgK-Q-1; Fri, 06 May 2022 04:11:19 -0400
X-MC-Unique: 4GCSeZo5ORCiTMbaNIgK-Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67F4C3C01C04;
	Fri,  6 May 2022 08:11:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 47EA240D2830;
	Fri,  6 May 2022 08:11:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AFFBD1947B84;
	Fri,  6 May 2022 08:11:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC0931947B8C
 for <dm-devel@listman.corp.redhat.com>; Fri,  6 May 2022 08:11:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AA32948FB05; Fri,  6 May 2022 08:11:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A615B5D4CE5
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FDCF801210
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:15 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-GyZE3FOtNySNm2i0-RKOpA-1; Fri, 06 May 2022 04:11:14 -0400
X-MC-Unique: GyZE3FOtNySNm2i0-RKOpA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220506081112euoutp023b5697c4157e4223720dc52343444261~sdcnPBvqH2349323493euoutp02z
 for <dm-devel@redhat.com>; Fri,  6 May 2022 08:11:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220506081112euoutp023b5697c4157e4223720dc52343444261~sdcnPBvqH2349323493euoutp02z
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220506081110eucas1p29f4ec4b6163302f91ffd1654e9132bc4~sdclV3MUy0616806168eucas1p2n;
 Fri,  6 May 2022 08:11:10 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id C8.05.09887.E18D4726; Fri,  6
 May 2022 09:11:10 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220506081110eucas1p1b6c624ddca1c41b9838bb5b85f8ca5ff~sdck9wLVm1797017970eucas1p1B;
 Fri,  6 May 2022 08:11:10 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220506081110eusmtrp222f0eafc663deb2c7f6b2252e5b9e61c~sdck8jKjJ2593625936eusmtrp2X;
 Fri,  6 May 2022 08:11:10 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-31-6274d81ece15
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 82.F2.09522.E18D4726; Fri,  6
 May 2022 09:11:10 +0100 (BST)
Received: from localhost (unknown [106.210.248.174]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220506081110eusmtip15b4e6a476e2eada8a56f7f54296837f1~sdckpd6-70578205782eusmtip1b;
 Fri,  6 May 2022 08:11:10 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, hare@suse.de, dsterba@suse.com, axboe@kernel.dk,
 hch@lst.de, damien.lemoal@opensource.wdc.com, snitzer@kernel.org
Date: Fri,  6 May 2022 10:10:58 +0200
Message-Id: <20220506081105.29134-5-p.raghav@samsung.com>
In-Reply-To: <20220506081105.29134-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTGee+9vf2IhUsx8I6KbE38A9AqCyHv3MJcYrYbF3XZ5sY+xBW5
 KwQorB8ONZlFEAU2Cjj5KCwwMq1QRylldYWiWGOBOQZrh2mZwxFoNqlUhmWTyGSUi5n//d5z
 nuc950kODxeZyFhejkLNKBWyPAkpIKzOpZ+2bfaoM3fYXCnI9IMTRyt2J4mMv+lIVDe/hKNa
 XQMXPRoZxVF/oImDxh4WY8g7YMOQva0WQ+3GGxiaMelx9PnAPIHaS6dwtDyVjKaCEwSqddwC
 yDeux1D/RBJyTV/kInv/MIHcvc0karng46LqskUceap9ANUMWjjowflSLur03yfQ0IR4Vxzt
 /uV1+vHQJZKuKQlw6dFJM0G7RzR0d0c5SX+tPYfTlm9O0H1eLUl/URIgadupOxz6/pVxkq7q
 6QC0qWecoC03j9PVFjPnDdH7gpeymLycI4xye9pHguzRuTGscCW8qNE7CbTAu6EC8HmQSoHX
 7ee5IRZRFwH0GndUAMEqBwH0BTtw9vEAwFOuL7lPHP7pWYJtGACsCbasq+4CWD+s41QAHo+k
 EmFxOTdU30hVAqi7c3rNjVMWDhz79uMQR1Hp8EabA4SYoLbAleILeIiF1Avwz7lJDjstHja6
 /lnz8qmd8OTZuySriYTDjTME+2c8LPmuaW0JSLUL4Omys+vm3bB6QIuzHAVnB3vWI2yCK7YW
 jOXj0Od5tG4uXd3UZiJDCSD1Iqz6MS+EOJUATb3bWfkr8O/Wa4BVhEPPXCS7QjistdbjbFkI
 z5SJWLUE2pZm1odC6D7ZTLBMw4WuK2Q1eE7/VBj9U2H0/89tBXgHiGE0qnw5o3pewXwqVcny
 VRqFXHq4IL8brN70zceDwe+BYfYvqQNgPOAAkIdLNgqj9OpMkTBLdvQYoyw4pNTkMSoHEPMI
 SYzwcE6XTETJZWoml2EKGeWTLsbjx2qxjF3vGqRZ0fHSpA/S2nTl5xaj34zYKmxXfCYVH3UG
 Ot17mH3Wd7wjEwcv31tIPwBeuy09sbnyKiqb69TVmypTwu7tHPRsoxPNL/fz+xr3120NuxY9
 vf/YkYjmQ6NXnTXZ3SXaZyczvGpRqsuYkBvm3lcnDiQdjH3vkp/j35Tx4YZke3hu+eKWhoaY
 fyeWL3cV/RppDBoc4z+n9jpbsd2jaU65/C1r3ZRZY5jXwczpRdycWMA8RCsHqnSxYqaG3BuH
 RpLyFUUx/E863TPP1F1veru471aL/fbynq/0fzhsCb/vDbcOtaf7o+J8EeLxwjOvauYWdJI+
 X31etLSwIZgqIVTZsuREXKmS/QdttR9ZQgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t/xu7pyN0qSDC4flbRYf+oYs8X/PcfY
 LFbf7WezmPbhJ7PFpP4Z7Ba/z55nttj7bjarxYUfjUwWNw/sZLLYs2gSk8XK1UeZLJ6sn8Vs
 0XPgA4vFypaHzBZ/HhpaPPxyi8Vi0qFrjBZPr85isth7S9vi0uMV7BZ79p5ksbi8aw6bxfxl
 T9ktJrR9Zba4MeEpo8XE45tZLT4vbWG3WPf6PYvFiVvSDrIel694e/w7sYbNY2LzO3aP8/c2
 snhcPlvqsWlVJ5vHwoapzB6bl9R77L7ZwObR2/yOzWNn631Wj/f7rrJ59G1ZxeixfstVFo/N
 p6s9JmzeyBogFKVnU5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9nk5Kak1mW
 WqRvl6CXcf7tBaaC/3wVM2/eY2xgvMnTxcjJISFgIvH68SuWLkYuDiGBpYwSZ+/0skIkJCRu
 L2xihLCFJf5c62KDKHrOKHF0xWHmLkYODjYBLYnGTnaQuIjAVEaJS+tOgk1iFjjNKrF10wEm
 kG5hgTCJK28/gE1iEVCV+N+4jBnE5hWwlHjx9h7UNnmJmZe+s4PYnAJWEk2TX7KB2EJANfOX
 7GGFqBeUODnzCQuIzQxU37x1NvMERoFZSFKzkKQWMDKtYhRJLS3OTc8tNtQrTswtLs1L10vO
 z93ECEwq24793LyDcd6rj3qHGJk4GA8xSnAwK4nwCs8qSRLiTUmsrEotyo8vKs1JLT7EaAp0
 90RmKdHkfGBayyuJNzQzMDU0MbM0MLU0M1YS5/Us6EgUEkhPLEnNTk0tSC2C6WPi4JRqYDr2
 PHHpwSvPW/YWXRGZuOLZruxaqZBKSXGJpry7BRmdi8/2sussnObANj3jmKR27dyYo2FW9nPe
 Kxg+83my3yj2QBCP6vKKh/cPLL50uD5ApnPz26VMv4IETk7lqhDRuXPzke68vn29jqsDmpyX
 h81emz/DqGrSjdu5T7rnaPXUmPuGLyjV1A4VPz1N5db6V1LpYV9yHRZWCLOtu17/10nBr97g
 zLnosx/e+bTL+LsdVXaNt01oaj/Z+D76WL6GhLrhPDf2V4H5jmKV99gNAydtWZhsdnHJoh5h
 7dYHL263X50gX3L35OwdMS6Cyfe+rkl3es9nxT01UfnC57jEt9zbeqQicg7bPU+w2b0oSoml
 OCPRUIu5qDgRABxkWpSzAwAA
X-CMS-MailID: 20220506081110eucas1p1b6c624ddca1c41b9838bb5b85f8ca5ff
X-Msg-Generator: CA
X-RootMTR: 20220506081110eucas1p1b6c624ddca1c41b9838bb5b85f8ca5ff
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220506081110eucas1p1b6c624ddca1c41b9838bb5b85f8ca5ff
References: <20220506081105.29134-1-p.raghav@samsung.com>
 <CGME20220506081110eucas1p1b6c624ddca1c41b9838bb5b85f8ca5ff@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v3 04/11] nvmet: Allow ZNS target to support
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
Cc: jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 Chris Mason <clm@fb.com>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 bvanassche@acm.org, gost.dev@samsung.com, jonathan.derrick@linux.dev,
 Pankaj Raghav <p.raghav@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org,
 Keith Busch <kbusch@kernel.org>, matias.bjorling@wdc.com,
 Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>,
 linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
 linux-fsdevel@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/nvme/target/zns.c | 2 +-
 include/linux/blkdev.h    | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
index 82b61acf7..5516dd6cc 100644
--- a/drivers/nvme/target/zns.c
+++ b/drivers/nvme/target/zns.c
@@ -242,7 +242,7 @@ static unsigned long nvmet_req_nr_zones_from_slba(struct nvmet_req *req)
 	unsigned int sect = nvmet_lba_to_sect(req->ns, req->cmd->zmr.slba);
 
 	return blkdev_nr_zones(req->ns->bdev->bd_disk) -
-		(sect >> ilog2(bdev_zone_sectors(req->ns->bdev)));
+	       bdev_zone_no(req->ns->bdev, sect);
 }
 
 static unsigned long get_nr_zones_from_buf(struct nvmet_req *req, u32 bufsize)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 32d7bd7b1..967790f51 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1370,6 +1370,13 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
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

