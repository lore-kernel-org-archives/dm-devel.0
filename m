Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5759EE14C5
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694022863;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ITFqXCGBVCtipefrjoS2OP52+uD0G8LLBAxLMMW1FI0=;
	b=bu/34HanoaiDX/3qRZA39goKb1GesXzUCUVge1W+pYpa6SNKlkK0YqAb7ZpbHtWFXuM+ja
	mDGxb0DIqtjqgpUZnwO31IpKkbvbepZveB45ukN76ZR6p6cRC0taRL+n6vL3AUad0284xx
	2SEbNPLTK/MykIEa8a+xp2o0RJpUQPE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-K7X1rqpuPdOlaFXhc_plQg-1; Wed, 06 Sep 2023 13:54:20 -0400
X-MC-Unique: K7X1rqpuPdOlaFXhc_plQg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC6101010429;
	Wed,  6 Sep 2023 17:54:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A8C0F140E964;
	Wed,  6 Sep 2023 17:54:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 78501194658D;
	Wed,  6 Sep 2023 17:54:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B032F194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 17:54:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 95069400F26A; Wed,  6 Sep 2023 17:54:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E5AD40C105A
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E221867940
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:11 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-Dg1QjueyOni5xrlCEQdwZw-1; Wed, 06 Sep 2023 13:54:09 -0400
X-MC-Unique: Dg1QjueyOni5xrlCEQdwZw-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230906175405epoutp030052975068bd75465c5640be8c018555~CYM2HeoC01073410734epoutp03a
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230906175405epoutp030052975068bd75465c5640be8c018555~CYM2HeoC01073410734epoutp03a
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230906175404epcas5p17321abf761d5601a63f98876638a25f2~CYM1YCwmr3144031440epcas5p1-;
 Wed,  6 Sep 2023 17:54:04 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4RgqkM1TwYz4x9Pq; Wed,  6 Sep
 2023 17:54:03 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 95.E9.09638.BBCB8F46; Thu,  7 Sep 2023 02:54:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230906164253epcas5p32862e8384bdd566881d2c155757cb056~CXOrTg7hy2340723407epcas5p3a;
 Wed,  6 Sep 2023 16:42:53 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230906164253epsmtrp17d1a464b7be2b3b6c956ceb2417d9414~CXOrSgaIN0347103471epsmtrp1l;
 Wed,  6 Sep 2023 16:42:53 +0000 (GMT)
X-AuditID: b6c32a4a-92df9700000025a6-3f-64f8bcbbc8d2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 03.D9.18916.D0CA8F46; Thu,  7 Sep 2023 01:42:53 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230906164250epsmtip2679d08d4fd4005d5e89be7677af09db6~CXOoYb_4R0104301043epsmtip2O;
 Wed,  6 Sep 2023 16:42:50 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed,  6 Sep 2023 22:08:26 +0530
Message-Id: <20230906163844.18754-2-nj.shetty@samsung.com>
In-Reply-To: <20230906163844.18754-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02TaVATZxjH++5uloU2ZQGVV5hqmtIPxHKEq8tlodJ2R+3AFGrVjqUp2QGG
 kGSyiaidKshVzgAqSiinXImMKIojAToMiKmkLdOhYMURkSY9AIPFKi1CaUKg9dvv/T/3885D
 oK45Dh5EqlTJKKQiCR93wq4Negt8enr/EvsX1WBUx/BNlDpZtoJSF+6pcWp2cAFQpv58QPVZ
 qjnUnf5uhOptrEAo7YUhhBpafYhTFQPjgDKPaRCqb2IH1ZDXhFG9fbcwalT/FU7VtZgdqFbD
 Pwj1U5kZUNee1aHUxdl5jPpmwpMaWTFwotzpkcnLGD36nYru1BXg9JWmE3TPnUycPl96ikOX
 ZFtw+g/zBEbPfz2G06VXdYC+Yvycfty5je40PUTiuAfTIlIYkZhR8BhpkkycKk2O5O+JT9yV
 GBziL/QRhlJv8nlSUToTyY/ZG+fzbqrEOjmfd1gkUVmlOBHL8v12RihkKiXDS5Gxykg+IxdL
 5EFyX1aUzqqkyb5SRhkm9PcPCLY6fpqWcu9BFkf+Y8QRXfHfnEyQF1gIHAlIBsGphm85hcCJ
 cCV7ACw7k43YDK7kAoBz+YF2g5VXV/KRjYinHWeB3dANYMXNacz+yEVgdeVdtBAQBE7ugMZV
 wqZvIjNReKnn/FoESj5BoPHXYgdbKjfyELxr0OM2xsjX4cKfBaiNuWQYHCxeXEsEST+ovu9i
 kx3JcHgy6wdgd3GBt6pMmI1RcjvM7qpGbfkhecoRdp1rd7C3GgOHurSond3gjOHquu4Bf1fn
 rXMG1J5uw+3BOQBqbmuA3fAWzB1WrzWBkt6wQ+9nl1+BZ4YvIvbCL8OSZ6b1tXDh9doNfg22
 d9Tjdt4Kxxez1pmGZnPd+rZKAdSOtYEywNM8N5DmuYE0/5euB6gObGXkbHoywwbLA6RMxn/f
 nCRL7wRr5yDYfR08mHrkOwAQAgwASKD8TVzL9qdiV65YdPQYo5AlKlQShh0AwdaFl6Mem5Nk
 1nuSKhOFQaH+QSEhIUGhgSFCvjt3NrdG7Eomi5RMGsPIGcVGHEI4emQiqowkj8Zm9w9Mlqhp
 zNh22+lVX8/fsM17nnxhRLS15fubGnYWdM97tZzLbvJCBo48rg0r8qlbbu2Pnk1w4zv2fe9d
 ou6V6D/Lia2cBPsMqrejPtZlsCOxh1Leyy+ci64P33c63ivsUZGFqNEORfpFexYKbsTrdD7m
 yy9qLWUfVYYvb9kfP7F6IKaxzriq31JzKZfj3lIe1+w8JR9fSlDPjv8y08RtC3/h7EuCn0e7
 NHsPLgd4vm/q7OYh458449k5b3CGheWGvC+HMwPfEXx4PErhcuD+jUXP2pXd04eJolbnyXa/
 BCJgic2KdembO+F09PhMqH4bgZvSqqqajxmYpX4+xqaIhAJUwYr+BTHN11CXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWy7bCSvC7vmh8pBideilmsP3WM2aJpwl9m
 i9V3+9ksXh/+xGjx5EA7o8Xed7NZLW4e2MlksWfRJCaLlauPMlkc/f+WzWLSoWuMFk+vzmKy
 2HtL22Jh2xIWiz17T7JYXN41h81i/rKn7BbLj/9jsrgx4Smjxbbf85kt1r1+z2Jx4pa0xfm/
 x1kdxD3O39vI4nH5bKnHplWdbB6bl9R77L7ZwOaxuG8yq0dv8zs2j49Pb7F4vN93lc2jb8sq
 Ro/Np6s9Pm+S89j05C1TAG8Ul01Kak5mWWqRvl0CV8bdh42sBVdsKlb1/GRtYGwz7mLk5JAQ
 MJH4tn46YxcjF4eQwHZGicauPSwQCUmJZX+PMEPYwhIr/z1nhyhqZpJ49nQqUIKDg01AW+L0
 fw6QuIhAF7NE5853LCAOs0Ajs8SxfR1g3cIC0RIdDTeZQGwWAVWJT186weK8AlYSh3u+gw2S
 ENCX6L8vCBLmFLCWaGq8yAhiCwGV3Fn1mhGiXFDi5MwnYMcxC8hLNG+dzTyBUWAWktQsJKkF
 jEyrGEVTC4pz03OTCwz1ihNzi0vz0vWS83M3MYKjVitoB+Oy9X/1DjEycTAeYpTgYFYS4X0n
 /y1FiDclsbIqtSg/vqg0J7X4EKM0B4uSOK9yTmeKkEB6YklqdmpqQWoRTJaJg1OqgWkmq5xk
 0fcMTw331/X7p5pt8v96qr4nvmJH3Sr/3h9ZBfv7p1dsPHn+QWmXvBHj/018H1i++7e+eVjT
 LnBtW6S1m67XwzscCsvdexzO/eTsvM2je0fmy82vGpzZP6IsEr8fTkxYNOvNr8rre54x9zaV
 rdh2z7E5+KNQewNjBNe3eQvM7rzNzSzMfHnK3+6BU3DdZ/Z1xTPklLeIswbq75A+ddPnxf1F
 fy5IGHh4Pt/z2kjK58iTe3mC642qLpe9mPMjov1nBmfks/eNp2xrvTfOMCg8YSo3SfSzgteu
 iuI7usz8fbJP6y6WpcwoW+u+tdq07elEE6/z1b9XRK3YunmvhYfs1AXHbevsnR65MSixFGck
 GmoxFxUnAgDyunsgSQMAAA==
X-CMS-MailID: 20230906164253epcas5p32862e8384bdd566881d2c155757cb056
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230906164253epcas5p32862e8384bdd566881d2c155757cb056
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164253epcas5p32862e8384bdd566881d2c155757cb056@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v15 01/12] block: Introduce queue limits and
 sysfs for copy-offload support
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
Cc: martin.petersen@oracle.com, Kanchan Joshi <joshi.k@samsung.com>,
 linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add device limits as sysfs entries,
	- copy_max_bytes (RW)
	- copy_max_hw_bytes (RO)

Above limits help to split the copy payload in block layer.
copy_max_bytes: maximum total length of copy in single payload.
copy_max_hw_bytes: Reflects the device supported maximum limit.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 Documentation/ABI/stable/sysfs-block | 23 ++++++++++++++++++
 block/blk-settings.c                 | 24 +++++++++++++++++++
 block/blk-sysfs.c                    | 36 ++++++++++++++++++++++++++++
 include/linux/blkdev.h               | 13 ++++++++++
 4 files changed, 96 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 1fe9a553c37b..96ba701e57da 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -155,6 +155,29 @@ Description:
 		last zone of the device which may be smaller.
 
 
+What:		/sys/block/<disk>/queue/copy_max_bytes
+Date:		August 2023
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RW] This is the maximum number of bytes that the block layer
+		will allow for a copy request. This is always smaller or
+		equal to the maximum size allowed by the hardware, indicated by
+		'copy_max_hw_bytes'. An attempt to set a value higher than
+		'copy_max_hw_bytes' will truncate this to 'copy_max_hw_bytes'.
+		Writing '0' to this file will disable offloading copies for this
+		device, instead copy is done via emulation.
+
+
+What:		/sys/block/<disk>/queue/copy_max_hw_bytes
+Date:		August 2023
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RO] This is the maximum number of bytes that the hardware
+		will allow for single data copy request.
+		A value of 0 means that the device does not support
+		copy offload.
+
+
 What:		/sys/block/<disk>/queue/crypto/
 Date:		February 2022
 Contact:	linux-block@vger.kernel.org
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 0046b447268f..4441711ac364 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -59,6 +59,8 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->zoned = BLK_ZONED_NONE;
 	lim->zone_write_granularity = 0;
 	lim->dma_alignment = 511;
+	lim->max_copy_hw_sectors = 0;
+	lim->max_copy_sectors = 0;
 }
 
 /**
@@ -82,6 +84,8 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_dev_sectors = UINT_MAX;
 	lim->max_write_zeroes_sectors = UINT_MAX;
 	lim->max_zone_append_sectors = UINT_MAX;
+	lim->max_copy_hw_sectors = UINT_MAX;
+	lim->max_copy_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -183,6 +187,22 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
 }
 EXPORT_SYMBOL(blk_queue_max_discard_sectors);
 
+/*
+ * blk_queue_max_copy_hw_sectors - set max sectors for a single copy payload
+ * @q:	the request queue for the device
+ * @max_copy_sectors: maximum number of sectors to copy
+ */
+void blk_queue_max_copy_hw_sectors(struct request_queue *q,
+				   unsigned int max_copy_sectors)
+{
+	if (max_copy_sectors > (BLK_COPY_MAX_BYTES >> SECTOR_SHIFT))
+		max_copy_sectors = BLK_COPY_MAX_BYTES >> SECTOR_SHIFT;
+
+	q->limits.max_copy_hw_sectors = max_copy_sectors;
+	q->limits.max_copy_sectors = max_copy_sectors;
+}
+EXPORT_SYMBOL_GPL(blk_queue_max_copy_hw_sectors);
+
 /**
  * blk_queue_max_secure_erase_sectors - set max sectors for a secure erase
  * @q:  the request queue for the device
@@ -578,6 +598,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_segment_size = min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
 
+	t->max_copy_sectors = min(t->max_copy_sectors, b->max_copy_sectors);
+	t->max_copy_hw_sectors = min(t->max_copy_hw_sectors,
+				     b->max_copy_hw_sectors);
+
 	t->misaligned |= b->misaligned;
 
 	alignment = queue_limit_alignment_offset(b, start);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 63e481262336..4840e21adefa 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -199,6 +199,37 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
 	return queue_var_show(0, page);
 }
 
+static ssize_t queue_copy_hw_max_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)
+		       q->limits.max_copy_hw_sectors << SECTOR_SHIFT);
+}
+
+static ssize_t queue_copy_max_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)
+		       q->limits.max_copy_sectors << SECTOR_SHIFT);
+}
+
+static ssize_t queue_copy_max_store(struct request_queue *q, const char *page,
+				    size_t count)
+{
+	unsigned long max_copy;
+	ssize_t ret = queue_var_store(&max_copy, page, count);
+
+	if (ret < 0)
+		return ret;
+
+	if (max_copy & (queue_logical_block_size(q) - 1))
+		return -EINVAL;
+
+	max_copy >>= SECTOR_SHIFT;
+	q->limits.max_copy_sectors = min_t(unsigned int, max_copy,
+					   q->limits.max_copy_hw_sectors);
+
+	return count;
+}
+
 static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
 {
 	return queue_var_show(0, page);
@@ -517,6 +548,9 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
 QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
 QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
 
+QUEUE_RO_ENTRY(queue_copy_hw_max, "copy_max_hw_bytes");
+QUEUE_RW_ENTRY(queue_copy_max, "copy_max_bytes");
+
 QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
 QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
 QUEUE_RW_ENTRY(queue_poll, "io_poll");
@@ -633,6 +667,8 @@ static struct attribute *queue_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_max_hw_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_copy_hw_max_entry.attr,
+	&queue_copy_max_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_zone_append_max_entry.attr,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index eef450f25982..7548f1685ee9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -309,6 +309,9 @@ struct queue_limits {
 	unsigned int		discard_alignment;
 	unsigned int		zone_write_granularity;
 
+	unsigned int		max_copy_hw_sectors;
+	unsigned int		max_copy_sectors;
+
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
@@ -893,6 +896,8 @@ extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_discard_segments(struct request_queue *,
 		unsigned short);
+extern void blk_queue_max_copy_hw_sectors(struct request_queue *q,
+					  unsigned int max_copy_sectors);
 void blk_queue_max_secure_erase_sectors(struct request_queue *q,
 		unsigned int max_sectors);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
@@ -1211,6 +1216,14 @@ static inline unsigned int bdev_discard_granularity(struct block_device *bdev)
 	return bdev_get_queue(bdev)->limits.discard_granularity;
 }
 
+/* maximum copy offload length, this is set to 128MB based on current testing */
+#define BLK_COPY_MAX_BYTES		(1 << 27)
+
+static inline unsigned int bdev_max_copy_sectors(struct block_device *bdev)
+{
+	return bdev_get_queue(bdev)->limits.max_copy_sectors;
+}
+
 static inline unsigned int
 bdev_max_secure_erase_sectors(struct block_device *bdev)
 {
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

