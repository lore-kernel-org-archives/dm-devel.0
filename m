Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE8FC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:24:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-h-pUYw-mO3GllxlzwOVFtQ-1; Fri, 29 Apr 2022 04:23:55 -0400
X-MC-Unique: h-pUYw-mO3GllxlzwOVFtQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2E39811E80;
	Fri, 29 Apr 2022 08:23:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E2B140D2835;
	Fri, 29 Apr 2022 08:23:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6A0EA194705C;
	Fri, 29 Apr 2022 08:23:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7AE2A1947042
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 16:11:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 58AEE111D7B7; Wed, 27 Apr 2022 16:11:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 216D8111D7B3
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08F761E10B42
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:11:52 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-uN9hpVr5PK2EwqHVL6hnSA-1; Wed, 27 Apr 2022 12:11:50 -0400
X-MC-Unique: uN9hpVr5PK2EwqHVL6hnSA-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220427160315euoutp0201339065fabebe204d40f99454805dc3~pzFL5b1lG1616716167euoutp02Q
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 16:03:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220427160315euoutp0201339065fabebe204d40f99454805dc3~pzFL5b1lG1616716167euoutp02Q
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220427160313eucas1p28f302518de9cf124f9194cc8d376fd43~pzFKbY0Jn2334023340eucas1p2s;
 Wed, 27 Apr 2022 16:03:13 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id C1.E7.10009.14969626; Wed, 27
 Apr 2022 17:03:13 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220427160313eucas1p1feecf74ec15c8c3d9250444710fd1676~pzFJ-Gzll2489024890eucas1p1n;
 Wed, 27 Apr 2022 16:03:13 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220427160313eusmtrp2cea78a3137da11659e89a20f8b5be479~pzFJ_NFx82598325983eusmtrp2p;
 Wed, 27 Apr 2022 16:03:13 +0000 (GMT)
X-AuditID: cbfec7f2-e7fff70000002719-93-62696941346b
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 5E.81.09522.04969626; Wed, 27
 Apr 2022 17:03:12 +0100 (BST)
Received: from localhost (unknown [106.210.248.162]) by eusmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427160312eusmtip1ae2f42acfa009ab15e75927ef0532d22~pzFJnZ99a1317113171eusmtip1M;
 Wed, 27 Apr 2022 16:03:12 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: jaegeuk@kernel.org, axboe@kernel.dk, snitzer@kernel.org, hch@lst.de,
 mcgrof@kernel.org, naohiro.aota@wdc.com, sagi@grimberg.me,
 damien.lemoal@opensource.wdc.com, dsterba@suse.com,
 johannes.thumshirn@wdc.com
Date: Wed, 27 Apr 2022 18:02:55 +0200
Message-Id: <20220427160255.300418-17-p.raghav@samsung.com>
In-Reply-To: <20220427160255.300418-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTVxzHc+69vb3tVrgUI2e1Y1pn5tDx2Ng8CQtItmRXpwvGLTJxj4J3
 hQ0KawEH/kF5jGHdpJDgRoEIhJcULJROKRUFlllQCYS3JOJwsEU6XrZqUWFruZj53+f3O5/f
 +Z5fcihc3ExKqARlKqtSyhNlpJC4eG1l4I3IhITY4Mc1UmS8fg1HhtuFJDq7tIKjGyX9GCou
 /IWPnvQP4KhzoYyHBl3ZGLrVZcHQecPvGJox6nH0Y9cSgVa1U+5e3jSOnk6HoOKeMYBmR/UY
 6pzchYb+bOCjoeoP0OXOPgINd5ST6FzdLB/p8h/gaEI3C1CRrY2HHLV5fHTBvkig3skte19m
 hkc+ZNZ6m0imKHeBzwxMtRLMcH8aY2o8RTJVmhKcaavJYqyVDoyx3tKQzE+5CyRj+f4Oj1m8
 MkoyZ8yNgDGaRwlG19bKixIfFb57nE1MSGdVQeFfCuPryoxEyrzgu0sFDzENyKO0QEBBOhTa
 SisJLRBSYroBQPu4nccVTgDbR+oxrnAA+EPjIHg2Ml1TtzFSD+BvRZb1AzF9D8A5p1ILKIqk
 A2D2Kb7H2URPAFjU0rJ+E07P4XDQPI55BnzpKPhHdf46E/QO6Bpq4nlYRIfB5SUXyaW9AkuH
 HvE9lwrcfd39aE7xgX2lM4SHcbeS+2sZzum1Qthu9+H4fdhgG+Nz7AvnbOYNlsJ/Lecwjk/C
 2YknuOdtkM4DsNBiJD1Z0J115maiB3H6dWjsCOL0SPjXdQfGGV5wYt6He4EXLL74M861RbAg
 X8zZMmhZmdkIhXA4p5zgFAZe1r2jA9v0z62if24V/f+xlQBvBH5smjpJwapDlOyJQLU8SZ2m
 VATGJSeZgPtH31iz3W8HFXPLgT0Ao0APgBQu2yRyWuNjxaLj8oxMVpX8hSotkVX3gC0UIfMT
 xSW0yMW0Qp7KfsOyKazq2SlGCSQa7Jh3Lf1S5NhK+af1wuj0Kv+srpgLV2JPRGdcOhauurcv
 Y+shA89bMGhojWiLPuJUEgFd+49Id2pHMr3uvnZwsysn5p895x9L3+KFer25q2nRdNuQ0lKd
 vtk389Cib+DuCeeL3acP7ow5/HXEV93DyhrF4ZAK6tHRSWnHAe+n+7P7pmxT1u4X/Bci4+6o
 k3M+X9B+RFRJVicfzMsVMyaXJHxv8dVtwj6rYfuy78c7RpAWCwt+uEfhqDLFBDVkn/b7NnZR
 39wqk7+3dTUr6TNBlKRkjfcq1bzvb7s2dcnsH3Gy0REWerVA8HbsJ7kH7vJ2a3pzyWDnzbLt
 FVnN5vHx/HmTVCcj1PHykABcpZb/B7EFCq9ABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t/xu7oOmZlJBn+mW1usP3WM2WL13X42
 i2kffjJbnJ56lsliUv8MdovfZ88zW+x9N5vV4sKPRiaLmwd2MlmsXH2UyeLJ+lnMFj0HPrBY
 /O26BxRrechs8eehocWkQ9cYLZ5encVksfeWtsWlxyvYLS4tcrfYs/cki8XlXXPYLOYve8pu
 MaHtK7PFjQlPGS0mHt/MavF5aQu7xbrX71ksTtySdpD1uHzF2+PfiTVsHhOb37F7nL+3kcXj
 8tlSj02rOtk8FjZMZfbYvKTeY/eCz0weu282sHn0Nr9j89jZep/V4/2+q2wefVtWMXqs33KV
 xWPC5o2sAUJRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYpqTmZZalF
 +nYJehnLZq9nKXjLWbG94xtTA2MLRxcjJ4eEgInEwyXLWLoYuTiEBJYySmxYMJEdIiEhcXth
 EyOELSzx51oXG4gtJPCcUeLhKrUuRg4ONgEticZOdpBeEYEnjBL3fz4GG8Qs0MAicWviLiaQ
 BmEBP4mn+2+DDWIRUJX4cWkNK4jNK2At8fHDDzaIBfISMy99ZwcZygkUn/ApAmKXlUT3oltQ
 5YISJ2c+YQGxmYHKm7fOZp7AKDALSWoWktQCRqZVjCKppcW56bnFhnrFibnFpXnpesn5uZsY
 gQll27Gfm3cwznv1Ue8QIxMH4yFGCQ5mJRHeL7szkoR4UxIrq1KL8uOLSnNSiw8xmgKdPZFZ
 SjQ5H5jS8kriDc0MTA1NzCwNTC3NjJXEeT0LOhKFBNITS1KzU1MLUotg+pg4OKUamOoNztk7
 676Vqz9ou6rw0tv1akJitqWbtj5JydrfKbNS7pTm13VZmWtnX80QzUgviwhx+f3njLLFRY4H
 jus3m76TDZhgq6r+UPdQkuSxF7I3Zcwf3M17EnTt2zJPO9mQLFPZw3oZlwr7ZVi6uDnXvMs2
 Wxa0IffyTJUuqaayzraXsiaq269fZ/inmPLOu8n/eTr7t097n/vxftx9T0v1LJf242WN58+m
 SjQ7Nd7scpjsoOQ7WZ9dwfHHeqO3cY1nzVYZ5T+dK6I3ycX+YP08SYNW7d7iz4xzeOabMp/t
 jprluMSX1+T2XuHk96+iPz+a3B5yquyNt/+Xusthrvxz76zynMgj9TUtJHbX1z1NSizFGYmG
 WsxFxYkA506w3bEDAAA=
X-CMS-MailID: 20220427160313eucas1p1feecf74ec15c8c3d9250444710fd1676
X-Msg-Generator: CA
X-RootMTR: 20220427160313eucas1p1feecf74ec15c8c3d9250444710fd1676
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220427160313eucas1p1feecf74ec15c8c3d9250444710fd1676
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160313eucas1p1feecf74ec15c8c3d9250444710fd1676@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: [dm-devel] [PATCH 16/16] dm-zoned: ensure only power of 2 zone
 sizes are allowed
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
Cc: jiangbo.365@bytedance.com, Pankaj Raghav <p.raghav@samsung.com>,
 kch@nvidia.com, bvanassche@acm.org, matias.bjorling@wdc.com,
 gost.dev@samsung.com, chao@kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-block@vger.kernel.org, clm@fb.com, dm-devel@redhat.com, agk@redhat.com,
 jonathan.derrick@linux.dev, kbusch@kernel.org, linux-fsdevel@vger.kernel.org,
 josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luis Chamberlain <mcgrof@kernel.org>

Today dm-zoned relies on the assumption that you have a zone size
with a power of 2. Even though the block layer today enforces this
requirement, these devices do exist and so provide a stop-gap measure
to ensure these devices cannot be used by mistake

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 drivers/md/dm-zone.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 57daa86c19cf..221e0aa0f1a7 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -231,6 +231,18 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
 	struct request_queue *q = md->queue;
 	unsigned int noio_flag;
 	int ret;
+	struct block_device *bdev = md->disk->part0;
+	sector_t zone_sectors;
+	char bname[BDEVNAME_SIZE];
+
+	zone_sectors = bdev_zone_sectors(bdev);
+
+	if (!is_power_of_2(zone_sectors)) {
+		DMWARN("%s: %s only power of two zone size supported\n",
+		       dm_device_name(md),
+		       bdevname(bdev, bname));
+		return 1;
+	}
 
 	/*
 	 * Check if something changed. If yes, cleanup the current resources
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

