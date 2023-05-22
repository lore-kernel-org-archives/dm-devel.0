Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA70C7EE23
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684772977;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=891paM1cLv4e7h+vlwCKkTvuA9i/vBif7tt7hujffhg=;
	b=P8dV9rCAFtzKy8vKQ52ErApezbqXIkTyWNno2GgW1a1qthLjMw1qvsOrVtbjIQfHFn3uNx
	/kAKovNSmwMNOJAcPPrP5o9wyDU0cDO59Uc7N//PQ8QqO89L5p6oQ0ILe3rm84gh6NWZ1O
	Jlwp05lQkOOWW7zWnRihGlRxXBT6aZI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-CEhPRcXzPxaJTguBujNwSw-1; Mon, 22 May 2023 12:29:33 -0400
X-MC-Unique: CEhPRcXzPxaJTguBujNwSw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6A8E8038E8;
	Mon, 22 May 2023 16:29:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E7532166B26;
	Mon, 22 May 2023 16:29:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 104E819451C9;
	Mon, 22 May 2023 16:29:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 559301946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 11:10:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39C5F7C52; Mon, 22 May 2023 11:10:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 324E77B7C
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:56 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12336800BFF
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:56 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-sbkfB8XLOP2L4sNfsKqnPw-1; Mon, 22 May 2023 07:10:54 -0400
X-MC-Unique: sbkfB8XLOP2L4sNfsKqnPw-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230522111051epoutp034d0b18b48849f8b4ba62bdc1f5ca733f~hcrOMOOLx1091410914epoutp03f
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230522111051epoutp034d0b18b48849f8b4ba62bdc1f5ca733f~hcrOMOOLx1091410914epoutp03f
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230522111050epcas5p21210becde80901bedfb5279ff1dc37df~hcrNhmLR22481324813epcas5p20;
 Mon, 22 May 2023 11:10:50 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4QPvrS5yCpz4x9Q2; Mon, 22 May
 2023 11:10:48 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 F7.03.54880.8BD4B646; Mon, 22 May 2023 20:10:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230522104648epcas5p2286a988d89b1befdb49984ebbefb25fd~hcWON8qBh1654016540epcas5p2X;
 Mon, 22 May 2023 10:46:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230522104647epsmtrp2f54f4efe0a6063ed075b8ef1db5011c5~hcWOMewuQ3249732497epsmtrp2V;
 Mon, 22 May 2023 10:46:47 +0000 (GMT)
X-AuditID: b6c32a49-8c5ff7000001d660-e1-646b4db84c65
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 A2.FF.28392.7184B646; Mon, 22 May 2023 19:46:47 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230522104643epsmtip2f74158f3b9d3a6a02b917f21da70e2c6~hcWKbW10-1645716457epsmtip23;
 Mon, 22 May 2023 10:46:43 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 May 2023 16:11:38 +0530
Message-Id: <20230522104146.2856-8-nj.shetty@samsung.com>
In-Reply-To: <20230522104146.2856-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0xTZxjOd045LWQdR8DsA6MrNQsD5VIs3VeFMQcxB5kRtmXJbikdPdAO
 elkvwkg2uekyGPdJZsVxW5Q7chnBAtPVaLnI2GSANOEyUqYTBVuygWmQFQ5u/nve532f5718
 +Ti4Vxfbj6NQ6WmtSprOJzxYPTcCA4J7T6TJwizzwah9+BaOqtpbCJRbuoGj5pkSAi3dcABU
 +fgJjuavRaOB5QtuaPr6VQz115VjqLH5JoY6Sjior9aOoZubjwhUbp4EaHHCiKEB6wHUPzDE
 QuOmKgLNtmy6oepLi2xUONVLoMuWpxgyV+RhqNeWA1CPsxpHbUsrLDRo3YPGNixuyLleRbyx
 jxr/PZ4yzo0S1FXjDJsam+1gUZXlwwTV1RBEjY8aqM6mrwmq01HOpga/c7Korh9OU33T2QRV
 lLdMUPZFK4ta+WmCoIq7m0CC9wdpkXJaKqO1PFqVrJYpVKlR/Ph3JDGSCFGYIFggRq/xeSqp
 ko7ix76VEHxMke66FJ93SppucFEJUp2OH/p6pFZt0NM8uVqnj+LTGlm6RqgJ0UmVOoMqNURF
 6w8LwsLCI1yFSWlyW3090HT7ZS7cH8SzgWl3AeBwICmEFbPHC4AHx4vsA/CPvAIWEzgAzLWv
 4kywCuDI5ogr476t6OyZIJiECcC6jvkdyRkMNhSbiS1fgjzgUnC2eB/ShsNHpofbVjhpwWHp
 pSF8q8ibFMOLDUe2XFnkK/DsrI3YwlwX7VzKZjPzhcKSuV1btDt5GN7/zYgzJbvg0Hnb9kA4
 +TLM+/HCtj0kre6w/O88wEwaC2dMcwSDveEDSzebwX5wdXlgh8+Ajd82EIw4H0DjlHFHHA3P
 DJdsz4mTgbDdFMrQe+G54TaMafwiLHLaMIbnwt7vn+H9sKW9ZsffF06u5exgCl4ZzQbMsYoA
 bB7oxEsBz/jcQsbnFjL+37oG4E3Al9bolKm0LkIjUNEZ/71yslrZCbZ/T1BcL5iZfxxiBhgH
 mAHk4HwfbmJxssyLK5N+nkVr1RKtIZ3WmUGE6+BluN/uZLXr+6n0EoFQHCYUiURC8SGRgP8S
 NyBqKNmLTJXq6TSa1tDaZzqM4+6XjbFb1XFvn1dc7MhsXKuozyJjJIX9eyYcnu8FfLGwiEWm
 3Lu7Ul+zz6JcJBf//CRJVY3Nm86K162Zp0v/Wm+w/nziTjTt7xdbebtKQ7w/9+mdUVvWUYX8
 BSV3qqIsUSiqqxB+lOCWlfPVUenkA3sbf/7Jl0v9q85aedX0kbZ7ilNlYebjafkHr3mghZMG
 n2NLI++mhPs74vsCp1Kk6zGv2mvF/p9x6/4xrG2A5F8Syk46UmMPDufg+YmHHp5T1uR+Yw5v
 tP+693ZnvU3PI64kZTUO1zSlf4yI2rU3PVsLUyRuyylDXdefxo2Jl1vd+i/n5qbdpTm+nhmJ
 CV23rCsf+vtb+CydXCoIwrU66b+C/c1ixgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTVxiAc+65Pb1tbHYtLhyozqXGmcAG07h4pmaQuZmzEXVsfscEG7gB
 AoWuBRGdUq1zW5kUixi9lLhVg1BQIiArApUUlOJHWkTU8rk5GBiiAi4ZlCCzwyX+e/M8z/v+
 ejmoHGHDudSMLEGfoUlXIzlb36pe+kEoTUv6sGzkI1J96yYktuoqRI4WzkJS2W9BZKx1EpDT
 49OQ/H49hjQ/K5EQf0sDQ5rsVoZUVN5gyBULRxp/nWDIjbmniFjdDwAZ7hYZ0twTSZqaO1jS
 dc2GyEDVnIScKxuWkvyHTkQutr9kiLvIxBDn0BFA6mfOQXJ57DlLPD0q4p1tl5CZKRuKfYd2
 3Y+j4uBdRBvEfin1Dlxh6WnrLURryyNo191sWuP4CdGaSauUes7MsLT2Qh5t9BsRPWF6hujE
 cA9Ln7u6ES2oc4CvQnbL1ycJ6an7BH30J3vlKUPnzwNdXfj+x6MeaATX3jYDGYf51bimvhuZ
 gZxT8k6AS1weOC/CcNls2+s5BFe8HJHORyYGn3L+xZoBxyE+Et+e44J8ET8OcXWdHQQXIN8L
 cf3DncEmhP8Yl5avC2KWX46PDwyh4Kx4hWfGjNJggvlobBlcGMQyfi0e7RRhECtfJYVlq+br
 hbjj7BA7f3wpNl0tgYWAF99Q4hvqF8A4QJigM2iTtYaVulUZQk6UQaM1ZGckRyVmamvAf78Q
 EeEETY7xKDdgOOAGmIPqRYr4gsQkpSJJk3tA0Gcm6LPTBYMbqDhWHarwmTsSlHyyJktIEwSd
 oP/fMpws3MjkS9Y3+r++VHgk50fNFicf6MaPmh+FlbgKVNAnk8E/59r+8cZuMm1cdu/yVjuc
 2FXeN+rc9eVJ3b2EkRfvxuRsPbnG8NbqS1x82zd/L3O7OzYuMG0JfV+ieLDkhbI1zlGMHw/q
 i/fkLn6y7kRfnmyxTdX03W3UcrMoIM93icdO7XXHBIpyI9c2lF/Pq+3foFnzaZXecfhoWq+r
 9z2Zjynt82pt8Snx49/emUr94ucfVkz64zZb4wKJxb2+YZNYamy3+4ySCf/n0xd/s6dFWjot
 nSvaLfe37cjpjF1waEfFweh9Kteh2emsxpbM/YG6zxo8ZGr7btGrvTMt5oWaK0u//0PNGlI0
 KyOg3qD5F3kRmWl6AwAA
X-CMS-MailID: 20230522104648epcas5p2286a988d89b1befdb49984ebbefb25fd
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230522104648epcas5p2286a988d89b1befdb49984ebbefb25fd
References: <20230522104146.2856-1-nj.shetty@samsung.com>
 <CGME20230522104648epcas5p2286a988d89b1befdb49984ebbefb25fd@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Mon, 22 May 2023 16:29:19 +0000
Subject: [dm-devel] [PATCH v11 7/9] dm: Add support for copy offload
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
Cc: linux-block@vger.kernel.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 James.Bottomley@HansenPartnership.com, linux-fsdevel@vger.kernel.org,
 dlemoal@kernel.org, Nitesh Shetty <nj.shetty@samsung.com>, joshi.k@samsung.com,
 nitheshshetty@gmail.com, bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Before enabling copy for dm target, check if underlying devices and
dm target support copy. Avoid split happening inside dm target.
Fail early if the request needs split, currently splitting copy
request is not supported.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-table.c         | 41 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  7 ++++++
 include/linux/device-mapper.h |  5 +++++
 3 files changed, 53 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 1398f1d6e83e..b3269271e761 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1867,6 +1867,39 @@ static bool dm_table_supports_nowait(struct dm_table *t)
 	return true;
 }
 
+static int device_not_copy_capable(struct dm_target *ti, struct dm_dev *dev,
+				      sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return !blk_queue_copy(q);
+}
+
+static bool dm_table_supports_copy(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	for (i = 0; i < t->num_targets; i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (!ti->copy_offload_supported)
+			return false;
+
+		/*
+		 * target provides copy support (as implied by setting
+		 * 'copy_offload_supported')
+		 * and it relies on _all_ data devices having copy support.
+		 */
+		if (!ti->type->iterate_devices ||
+		     ti->type->iterate_devices(ti,
+			     device_not_copy_capable, NULL))
+			return false;
+	}
+
+	return true;
+}
+
 static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				      sector_t start, sector_t len, void *data)
 {
@@ -1949,6 +1982,14 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		q->limits.discard_misaligned = 0;
 	}
 
+	if (!dm_table_supports_copy(t)) {
+		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
+		q->limits.max_copy_sectors = 0;
+		q->limits.max_copy_sectors_hw = 0;
+	} else {
+		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
+	}
+
 	if (!dm_table_supports_secure_erase(t))
 		q->limits.max_secure_erase_sectors = 0;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3b694ba3a106..ab9069090a7d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1720,6 +1720,13 @@ static blk_status_t __split_and_process_bio(struct clone_info *ci)
 	if (unlikely(ci->is_abnormal_io))
 		return __process_abnormal_io(ci, ti);
 
+	if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
+			max_io_len(ti, ci->sector) < ci->sector_count)) {
+		DMERR("Error, IO size(%u) > max target size(%llu)\n",
+			ci->sector_count, max_io_len(ti, ci->sector));
+		return BLK_STS_IOERR;
+	}
+
 	/*
 	 * Only support bio polling for normal IO, and the target io is
 	 * exactly inside the dm_io instance (verified in dm_poll_dm_io)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a52d2b9a6846..04016bd76e73 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -398,6 +398,11 @@ struct dm_target {
 	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
 	 */
 	bool needs_bio_set_dev:1;
+
+	/*
+	 * copy offload is supported
+	 */
+	bool copy_offload_supported:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

