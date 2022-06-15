Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29432C43334
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:19:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-TmSAflJqPtiRr3SL3wMfDA-1; Wed, 15 Jun 2022 06:19:47 -0400
X-MC-Unique: TmSAflJqPtiRr3SL3wMfDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B90A23804516;
	Wed, 15 Jun 2022 10:19:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A71492166B29;
	Wed, 15 Jun 2022 10:19:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 78FBA1947B84;
	Wed, 15 Jun 2022 10:19:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A66ED194705C
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:19:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 99A50492CA6; Wed, 15 Jun 2022 10:19:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9580E492CA5
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CE193C025C9
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:44 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-ZtvayhhFN_mrS3WiCjb7Fg-1; Wed, 15 Jun 2022 06:19:42 -0400
X-MC-Unique: ZtvayhhFN_mrS3WiCjb7Fg-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615101941euoutp0185ecbc6df8f6ab4bd0188e833f023419~4xANHF8Y12585525855euoutp01E
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:19:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220615101941euoutp0185ecbc6df8f6ab4bd0188e833f023419~4xANHF8Y12585525855euoutp01E
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220615101939eucas1p2eb2c5ef6e00ebaa4a2acbb8d2deb2eea~4xALZ4g0g1912519125eucas1p2g;
 Wed, 15 Jun 2022 10:19:39 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 5C.69.09580.A32B9A26; Wed, 15
 Jun 2022 11:19:38 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20220615101938eucas1p26ab159a1ffd0fa5a16d7f202ba7206e7~4xAKNP28S2111721117eucas1p2V;
 Wed, 15 Jun 2022 10:19:38 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615101938eusmtrp246a65538e1923130b814cf2be9b59611~4xAKMLDK-0361403614eusmtrp2H;
 Wed, 15 Jun 2022 10:19:38 +0000 (GMT)
X-AuditID: cbfec7f5-9c3ff7000000256c-19-62a9b23a0857
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id BF.45.09095.A32B9A26; Wed, 15
 Jun 2022 11:19:38 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615101937eusmtip1e4794119142cb0d2fedd8d7073fa370c~4xAJR_qbe1151011510eusmtip1D;
 Wed, 15 Jun 2022 10:19:37 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:11 +0200
Message-Id: <20220615101920.329421-5-p.raghav@samsung.com>
In-Reply-To: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7djPc7rWm1YmGWxcw2qx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 AvijuGxSUnMyy1KL9O0SuDI2X1zFWrCXv+LD2t1sDYyTeLsYOTkkBEwk1u/tZO5i5OIQEljB
 KPG0s5EVwvnCKHGl5z8ThPOZUeLayoksMC03X56DqlrOKDF5YQ9U/0tGiVO/moAyHBxsAloS
 jZ3sIA0iAuESR/fcA5vELHCQWeL9/pmsIAlhgQiJgx+fsoHYLAKqEq+OtYA18ApYSSzb/B5q
 m7zEzEvfweKcAtYSO2b3sELUCEqcnPkErIYZqKZ562xmiPpznBJvV6tB2C4SD65uZ4SwhSVe
 Hd/CDmHLSPzfOZ8Jwq6WeHrjN9gDEgItjBL9O9ezgTwgAbSs70wOiMksoCmxfpc+RLmjxKTj
 IKeBVPBJ3HgrCHEBn8SkbdOZIcK8Eh1tQhDVShI7fz6BWiohcblpDlSnh8Tkh7kTGBVnIXll
 FpJXZiGsXcDIvIpRPLW0ODc9tdg4L7Vcrzgxt7g0L10vOT93EyMwcZ7+d/zrDsYVrz7qHWJk
 4mA8xCjBwawkwmsWvDJJiDclsbIqtSg/vqg0J7X4EKM0B4uSOG9y5oZEIYH0xJLU7NTUgtQi
 mCwTB6dUA5N/t3HgaoG5k679EHGMKOWfLW1etU94ugPn0bgz/2efXNX5Ve8bU4rX6+q9Yrfq
 G4PvCnUp9r9+xmHjU3Oy4WDQg2iDnTxVE/a+uxd0mGE+x/Vnpdc/sz/feK/8o7ymYs4nNelL
 P0PfWS2P8X5vdlXpvdBUS8Giv18ERd4qrM220egw1+xe07qp9Qzz5jexy6c/Lo3KZ7BYXvEr
 bbqQxxNVmYN3Ze5dTPU/EWuXeWxL1MlbZXKOOllTXkx4ded2fssPad7W6q1b9jhYOT6euu+e
 1ctjJSbs/7c85L+Q9b30UeHjKYeOFp1kq026nKd2jGWuZ0x2iWTlO7WN4Que7/jR1d0uF+tU
 tS/t962PGRpKLMUZiYZazEXFiQADHUwPCwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t/xu7pWm1YmGfw4x2Wx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFjcmPGW0+Ly0hd1izc2nLBZtG78yOgh7XL7i7fHvxBo2j52z7rJ7XD5b
 6rFpVSebx8KGqcwem5fUe+y+2QCUa73P6vF+31U2j74tqxg91m+5yuKx+XS1x+dNch7tB7qZ
 Avij9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxSUnMyy1KL9O0S9DI2
 X1zFWrCXv+LD2t1sDYyTeLsYOTkkBEwkbr48x9rFyMUhJLCUUWL26vvsEAkJidsLmxghbGGJ
 P9e62CCKnjNK/Dl2C6iIg4NNQEuisROsXkQgWqLz5nuwGmaBy8wS+268AEsIC4RJXPn9lAXE
 ZhFQlXh1rAUszitgJbFs83sWiAXyEjMvfQeLcwpYS+yY3cMKMl8IqGbXu3iIckGJkzOfgJUz
 A5U3b53NPIFRYBaS1CwkqQWMTKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzECo3zbsZ+bdzDO
 e/VR7xAjEwfjIUYJDmYlEV6z4JVJQrwpiZVVqUX58UWlOanFhxhNgc6eyCwlmpwPTDN5JfGG
 ZgamhiZmlgamlmbGSuK8ngUdiUIC6YklqdmpqQWpRTB9TBycUg1MAY/2C/UfWLa0aekdkzMP
 PTpKTsv/ncZfMHXJacuEIx3vPu7IUio98pxX/2PYnZBP02O/ikU1F5ml8RQY3HAX+/n5nZ5h
 2DS2qeUBPw8vybNgSnwzzW7nrp1rLp3oaVO33CTtb5W//x2LDoO9ceIntu0lkim2bJ6btXfn
 KzLomQR2iLRZnG2at+C6n//8rzb5y6ZUWH4yXXFHNszZe0M2d3XyyzT5eZPCuSZPXX5j85JL
 T4Vi7n3Z/0f+cuolMU1tg2+bKtcsY1oabTjp30rh7DPaSdPUOO8+ehl78fTxjYe9JKJs9nZK
 F2/iPLAx73JEJFuuXOUm540N+RryT1a8+HDexPS8vofY5r2e59XLlViKMxINtZiLihMB1fs6
 AXsDAAA=
X-CMS-MailID: 20220615101938eucas1p26ab159a1ffd0fa5a16d7f202ba7206e7
X-Msg-Generator: CA
X-RootMTR: 20220615101938eucas1p26ab159a1ffd0fa5a16d7f202ba7206e7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615101938eucas1p26ab159a1ffd0fa5a16d7f202ba7206e7
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101938eucas1p26ab159a1ffd0fa5a16d7f202ba7206e7@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v7 04/13] nvmet: Allow ZNS target to support
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, dsterba@suse.com,
 jaegeuk@kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
index 3c106dba1..e09d73473 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1387,6 +1387,13 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
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

