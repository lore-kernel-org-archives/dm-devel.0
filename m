Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 546DDC77B76
	for <dm-devel@archiver.kernel.org>; Wed, 12 Apr 2023 06:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681281568;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vSDwmHaTjz0OsSxbF+e0of1KqHvGeji4sDG6xpK/S3Y=;
	b=XbesgheaxP+0HyuuSUAx5nzTnS6Z48btuEgbFpvnO9Fa4xQNNQMEJLoSn8hXtvoMgZcvDN
	XLnX84cHQ032J1ZTGNzegiNPvAK6UUOlI4hF7XCgMrVaKaPipkq8hpGif769omRbibWeBX
	K7+dSnr2oyvIrileMXDV7D2HMBJx1vU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-GBElRD5RPi6q1tQgAE8a5w-1; Wed, 12 Apr 2023 02:39:24 -0400
X-MC-Unique: GBElRD5RPi6q1tQgAE8a5w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60635101A552;
	Wed, 12 Apr 2023 06:39:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 734052027043;
	Wed, 12 Apr 2023 06:39:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 46E501946A47;
	Wed, 12 Apr 2023 06:39:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5B7FA1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 08:19:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D28D40C83B6; Tue, 11 Apr 2023 08:19:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44F0740C20FA
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24D843C0F196
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:13 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-VNlxtukVMD-FvjyW1qVxng-1; Tue, 11 Apr 2023 04:19:11 -0400
X-MC-Unique: VNlxtukVMD-FvjyW1qVxng-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230411081908epoutp02e7397b906244a4c8bd063080de33bcc3~U04lt2lFb0522705227epoutp02W
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230411081908epoutp02e7397b906244a4c8bd063080de33bcc3~U04lt2lFb0522705227epoutp02W
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230411081907epcas5p14cc7243acedb09df278a7e44c4ca1aa0~U04lG_xqE0857608576epcas5p1z;
 Tue, 11 Apr 2023 08:19:07 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4PwdzF5q6Bz4x9QF; Tue, 11 Apr
 2023 08:19:05 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 4D.1F.09540.9F715346; Tue, 11 Apr 2023 17:19:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230411081252epcas5p3ce3b26d13bbc302a0119c09c34a5eb49~U0zIWmE9l3265932659epcas5p3F;
 Tue, 11 Apr 2023 08:12:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230411081252epsmtrp1c460376282546ec7c44c142812180726~U0zISiMuA1831018310epsmtrp1W;
 Tue, 11 Apr 2023 08:12:52 +0000 (GMT)
X-AuditID: b6c32a4a-70dfa70000002544-fd-643517f93d46
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 F1.ED.08609.48615346; Tue, 11 Apr 2023 17:12:52 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230411081247epsmtip2caf0c01f1eee6b3179f9aef98b1f99ed~U0zDhWjdK2397423974epsmtip2I;
 Tue, 11 Apr 2023 08:12:47 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Apr 2023 13:40:29 +0530
Message-Id: <20230411081041.5328-3-anuj20.g@samsung.com>
In-Reply-To: <20230411081041.5328-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH+d3b3hY33KWw+BuLiE0YkQ1osbAfCw8XndzBggzmXBYddvQG
 GKVt+pgCS+hsYEhg5SEqLVB1i1OIIoU5BMqW8gYBtUORBMSlnQ8e5ZEtEmGupWXzv88553t+
 5/HLYeOcMpYfO0uipOUSoZhLbGFc794VFLK6LULEu/T4HdQ01IejE+XrOGqc0hJotnsZoNOL
 qzia+TUOmRb0THT/txsY6rxQiaHLjb0Y6ji/hKHeF/MEqjTfBcg2rsOQafJt1GkaZCBLey2B
 DBdtLGSu0mCozfotQNefG3B0ddbOQAOTb6Kx9X7mHkhZfk+kdA9GCOqGbopFjU03MyjLiIoy
 NpwkqJYfC6iO+2qCKtMsEJS9a5ygvm9tAFTLcD61YvSnjNZ5LHnr59nRmbRQRMsDaEm6VJQl
 yYjhJqam7U2LiOTxQ/hR6F1ugESYQ8dw932UHLI/S+zYADfga6FY5XAlCxUKblhstFyqUtIB
 mVKFMoZLy0RimUAWqhDmKFSSjFAJrXyPz+OFRziER7MzuyduMWRnDh23T68z1eBsfAnwZENS
 AIvHG7ESsIXNITsArCnSsVzGMoD1Yz+4jRUAF6rWsc2Umz2PGK5AO4DlhTa3ocHgH2MGplNF
 kEGw51EhcAZ8ySIcLtlObqhw8g4G11rtuFPlQ+6Hy7+sACczyECo11VvZHuRCP7ZaHRo2I56
 YVD7wNvp9iSj4FpdMeGSeMPBGivDyTi5A2p+1uPO9yFp8IT3+kdYrl73QcvTfjf7wKf9rW72
 g0+0RW7OgM8sNvdsMqjp6wIujoOFQ9qNHnByF2xqD3O5t8PqoauYq+5WWPbc6k71gm31m8yF
 312udTOEplG1mynY1WXFXdsqBbC/pwMvBwG6l+bRvTSP7v/S5wDeAN6gZYqcDFoRIQuX0Mf+
 ++d0aY4RbNxFcEIbeDizGGoGGBuYAWTjXF+vv17sFnG8RMLcPFouTZOrxLTCDCIc+67A/V5P
 lzoOS6JM4wuieILIyEhB1O5IPnebV1DMYDqHzBAq6WyaltHyzTyM7emnxpijAwc/PCO7oh7+
 ZioJsnwtmZdq8p6N/XQ3hDUnX11I5Hi8qmoKn7UmFQXegxKNIZ5IqHllu872z+PUr5r9P9Bn
 6wPnTvXemTgwdbi5Y/b4nrcaE/v0KaXTFXWVg6aHU0dyW47Ec7QsjeF90jotV8deq+7Jry0/
 UZHAOpbyJK3+fLNnrz3pdrw5VYtRt+f+vuX/sb1EHGr4tKKgICWYmBw+N1jZFnQxmaReqzMN
 7/CZYC4tjZYO1MKG6cNnjd6Cm815ycX8a2ttqZ1HDx3Y6ZF04Us2yLdn5+zt/mTnsGox2R7L
 js71OjjfVcFZWvSYjLtSPvOZpb2XN6P+IrzudHgVl6HIFPKDcblC+C8ZS2NNoAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHe99zdjxbLY5T6jWrxUgqq2ll8RZl9aE6diOwCxRkq53U1Cmb
 riyklRY1UKdR2px4QYxmFE1bWtNs3lJbrja7rHRR2rqqaRJRak4J+vY8/9+P//PhoQmRlZxF
 xyqSOaVCFi+hBKS5QSJemjFjpTy0Ji8U32prJvBZ3QiBK7qyKfylYRDgKwO/CPz2wXpc21fA
 w6/qayC2lOZCfL2iCeL7Jd8hbhr7RuFc63OAezv1ENe6FmNLbSuJHfcMFC4q7/XB1kvpEFf3
 nAHY/LuIwDe/9JP4kSsQd4y08DYg1uHcxurdNoqt0Xf5sB3dt0nWYUthTcaLFFtZdpq9/0pD
 sZnpfRTbX9dJsVlVRsBWtp9ih0xzWVPPN7hr+n7BWjkXH6vmlCHhhwQxDS/tZFLevhP93SM8
 DcjfogV8GjFh6HGjh9QCAS1iqgGymw3UJECo7VM5mJz90PVRj8+kdAai6rp8wgsoZgFq9JwD
 XuDP6Aj0zK2hvAvBvIWow/OD57X8mM1o8O7QRBXJBKEC/eWJXMhg9KHCNN5Ej58IQdluX2/M
 Z1ajP4UXKG8sGlfKLOSk7Ytar/ZMzAQjRul3CggdYPT/If1/qBhAIwjgklQJ0QmqZUnLFdxx
 qUqWoEpRREuPJCaYwMSbg4OrgcU4ILUCSAMrQDQh8RcOj62Qi4RyWepJTpkYpUyJ51RWEEiT
 kplCu7Y1SsREy5K5OI5L4pT/KKT5szTQr1Peu9vZ0vXTkqYUwtdvujNPl0R9Hqsqc69ZooPN
 VUrbok2rsr4uDcvzlT89mhFQWncwLmBOfYEnom3HrT04+GHFtPbGYn+c/86krrM9tRNqywEo
 zs1xXLJMvWq48TrHEmRz8neubdl2zulI3NRoDqUGIgsV81qa1OdD9FjQqc3QDuydNjzqIy5P
 C3gfEffDGBphv/aEENuk29NGUldEslnLxW61UGF4oRnM+Z6qqf8V/7UvZL4rs/RYeOQo7Dq8
 gJ/6kecaPTDDJdmYvT23eSio6BFXme+84jAML1wcs67dfCGcF/biokyT2DT7vO7N/EWBaVsL
 k6fsqZLG9ktIVYxsWTChVMn+AinWwe5VAwAA
X-CMS-MailID: 20230411081252epcas5p3ce3b26d13bbc302a0119c09c34a5eb49
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230411081252epcas5p3ce3b26d13bbc302a0119c09c34a5eb49
References: <20230411081041.5328-1-anuj20.g@samsung.com>
 <CGME20230411081252epcas5p3ce3b26d13bbc302a0119c09c34a5eb49@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 12 Apr 2023 06:39:18 +0000
Subject: [dm-devel] [PATCH v9 2/9] block: Add copy offload support
 infrastructure
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
Cc: bvanassche@acm.org, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nitesh Shetty <nj.shetty@samsung.com>

Introduce blkdev_issue_copy which takes similar arguments as
copy_file_range and performs copy offload between two bdevs.
Introduce REQ_COPY copy offload operation flag. Create a read-write
bio pair with a token as payload and submitted to the device in order.
Read request populates token with source specific information which
is then passed with write request.
This design is courtesy Mikulas Patocka's token based copy

Larger copy will be divided, based on max_copy_sectors limit.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-lib.c           | 230 ++++++++++++++++++++++++++++++++++++++
 block/blk.h               |   2 +
 include/linux/blk_types.h |  25 +++++
 include/linux/blkdev.h    |   3 +
 4 files changed, 260 insertions(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e59c3069e835..b5914a357763 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -115,6 +115,236 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
+/*
+ * For synchronous copy offload/emulation, wait and process all in-flight BIOs.
+ * This must only be called once all bios have been issued so that the refcount
+ * can only decrease. This just waits for all bios to make it through
+ * blkdev_copy_write_endio.
+ */
+static int blkdev_copy_wait_completion(struct cio *cio)
+{
+	int ret;
+
+	if (cio->endio)
+		return 0;
+
+	if (atomic_read(&cio->refcount)) {
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		blk_io_schedule();
+	}
+
+	ret = cio->comp_len;
+	kfree(cio);
+
+	return ret;
+}
+
+static void blkdev_copy_offload_write_endio(struct bio *bio)
+{
+	struct copy_ctx *ctx = bio->bi_private;
+	struct cio *cio = ctx->cio;
+	sector_t clen;
+
+	if (bio->bi_status) {
+		clen = (bio->bi_iter.bi_sector << SECTOR_SHIFT) - cio->pos_out;
+		cio->comp_len = min_t(sector_t, clen, cio->comp_len);
+	}
+	__free_page(bio->bi_io_vec[0].bv_page);
+	bio_put(bio);
+
+	kfree(ctx);
+	if (!atomic_dec_and_test(&cio->refcount))
+		return;
+	if (cio->endio) {
+		cio->endio(cio->private, cio->comp_len);
+		kfree(cio);
+	} else
+		blk_wake_io_task(cio->waiter);
+}
+
+static void blkdev_copy_offload_read_endio(struct bio *read_bio)
+{
+	struct copy_ctx *ctx = read_bio->bi_private;
+	struct cio *cio = ctx->cio;
+	sector_t clen;
+
+	if (read_bio->bi_status) {
+		clen = (read_bio->bi_iter.bi_sector << SECTOR_SHIFT)
+				- cio->pos_in;
+		cio->comp_len = min_t(sector_t, clen, cio->comp_len);
+		__free_page(read_bio->bi_io_vec[0].bv_page);
+		bio_put(ctx->write_bio);
+		bio_put(read_bio);
+		kfree(ctx);
+		if (atomic_dec_and_test(&cio->refcount)) {
+			if (cio->endio) {
+				cio->endio(cio->private, cio->comp_len);
+				kfree(cio);
+			} else
+				blk_wake_io_task(cio->waiter);
+		}
+		return;
+	}
+
+	schedule_work(&ctx->dispatch_work);
+	bio_put(read_bio);
+}
+
+static void blkdev_copy_dispatch_work(struct work_struct *work)
+{
+	struct copy_ctx *ctx = container_of(work, struct copy_ctx,
+			dispatch_work);
+
+	submit_bio(ctx->write_bio);
+}
+
+/*
+ * __blkdev_copy_offload	- Use device's native copy offload feature.
+ * we perform copy operation by sending 2 bio.
+ * 1. First we send a read bio with REQ_COPY flag along with a token and source
+ * and length. Once read bio reaches driver layer, device driver adds all the
+ * source info to token and does a fake completion.
+ * 2. Once read operation completes, we issue write with REQ_COPY flag with same
+ * token. In driver layer, token info is used to form a copy offload command.
+ *
+ * returns the length of bytes copied
+ */
+static int __blkdev_copy_offload(struct block_device *bdev_in, loff_t pos_in,
+		struct block_device *bdev_out, loff_t pos_out, size_t len,
+		cio_iodone_t endio, void *private, gfp_t gfp_mask)
+{
+	struct cio *cio;
+	struct copy_ctx *ctx;
+	struct bio *read_bio, *write_bio;
+	struct page *token;
+	sector_t copy_len;
+	sector_t rem, max_copy_len;
+
+	cio = kzalloc(sizeof(struct cio), GFP_KERNEL);
+	if (!cio)
+		return 0;
+	atomic_set(&cio->refcount, 0);
+	cio->waiter = current;
+	cio->endio = endio;
+	cio->private = private;
+
+	max_copy_len = min(bdev_max_copy_sectors(bdev_in),
+			bdev_max_copy_sectors(bdev_out)) << SECTOR_SHIFT;
+
+	cio->pos_in = pos_in;
+	cio->pos_out = pos_out;
+	/* If there is a error, comp_len will be set to least successfully
+	 * completed copied length */
+	cio->comp_len = len;
+	for (rem = len; rem > 0; rem -= copy_len) {
+		copy_len = min(rem, max_copy_len);
+
+		token = alloc_page(gfp_mask);
+		if (unlikely(!token))
+			goto err_token;
+
+		ctx = kzalloc(sizeof(struct copy_ctx), gfp_mask);
+		if (!ctx)
+			goto err_ctx;
+		read_bio = bio_alloc(bdev_in, 1, REQ_OP_READ | REQ_COPY
+			| REQ_SYNC | REQ_NOMERGE, gfp_mask);
+		if (!read_bio)
+			goto err_read_bio;
+		write_bio = bio_alloc(bdev_out, 1, REQ_OP_WRITE
+			| REQ_COPY | REQ_SYNC | REQ_NOMERGE, gfp_mask);
+		if (!write_bio)
+			goto err_write_bio;
+
+		ctx->cio = cio;
+		ctx->write_bio = write_bio;
+		INIT_WORK(&ctx->dispatch_work, blkdev_copy_dispatch_work);
+
+		__bio_add_page(read_bio, token, PAGE_SIZE, 0);
+		read_bio->bi_iter.bi_size = copy_len;
+		read_bio->bi_iter.bi_sector = pos_in >> SECTOR_SHIFT;
+		read_bio->bi_end_io = blkdev_copy_offload_read_endio;
+		read_bio->bi_private = ctx;
+
+		__bio_add_page(write_bio, token, PAGE_SIZE, 0);
+		write_bio->bi_iter.bi_size = copy_len;
+		write_bio->bi_end_io = blkdev_copy_offload_write_endio;
+		write_bio->bi_iter.bi_sector = pos_out >> SECTOR_SHIFT;
+		write_bio->bi_private = ctx;
+
+		atomic_inc(&cio->refcount);
+		submit_bio(read_bio);
+		pos_in += copy_len;
+		pos_out += copy_len;
+	}
+
+	/* Wait for completion of all IO's*/
+	return blkdev_copy_wait_completion(cio);
+
+err_write_bio:
+	bio_put(read_bio);
+err_read_bio:
+	kfree(ctx);
+err_ctx:
+	__free_page(token);
+err_token:
+	cio->comp_len = min_t(sector_t, cio->comp_len, (len - rem));
+	return blkdev_copy_wait_completion(cio);
+}
+
+static inline int blkdev_copy_sanity_check(struct block_device *bdev_in,
+	loff_t pos_in, struct block_device *bdev_out, loff_t pos_out,
+	size_t len)
+{
+	unsigned int align = max(bdev_logical_block_size(bdev_out),
+					bdev_logical_block_size(bdev_in)) - 1;
+
+	if (bdev_read_only(bdev_out))
+		return -EPERM;
+
+	if ((pos_in & align) || (pos_out & align) || (len & align) || !len ||
+		len >= COPY_MAX_BYTES)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * @bdev_in:	source block device
+ * @pos_in:	source offset
+ * @bdev_out:	destination block device
+ * @pos_out:	destination offset
+ * @len:	length in bytes to be copied
+ * @endio:	endio function to be called on completion of copy operation,
+ *		for synchronous operation this should be NULL
+ * @private:	endio function will be called with this private data, should be
+ *		NULL, if operation is synchronous in nature
+ * @gfp_mask:   memory allocation flags (for bio_alloc)
+ *
+ * Returns the length of bytes copied
+ *
+ * Description:
+ *	Copy source offset from source block device to destination block
+ *	device. Max total length of copy is limited to MAX_COPY_TOTAL_LENGTH
+ */
+int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
+		      struct block_device *bdev_out, loff_t pos_out, size_t len,
+		      cio_iodone_t endio, void *private, gfp_t gfp_mask)
+{
+	struct request_queue *q_in = bdev_get_queue(bdev_in);
+	struct request_queue *q_out = bdev_get_queue(bdev_out);
+	int ret = 0;
+
+	if (blkdev_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len))
+		return 0;
+
+	if (blk_queue_copy(q_in) && blk_queue_copy(q_out))
+		ret = __blkdev_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
+			   len, endio, private, gfp_mask);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(blkdev_issue_copy);
+
 static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
 		struct bio **biop, unsigned flags)
diff --git a/block/blk.h b/block/blk.h
index d65d96994a94..684b8fa121db 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -311,6 +311,8 @@ static inline bool bio_may_exceed_limits(struct bio *bio,
 		break;
 	}
 
+	if (unlikely(op_is_copy(bio->bi_opf)))
+		return false;
 	/*
 	 * All drivers must accept single-segments bios that are <= PAGE_SIZE.
 	 * This is a quick and dirty check that relies on the fact that
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 80670a641cc2..da07ce399881 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -416,6 +416,7 @@ enum req_flag_bits {
 	 */
 	/* for REQ_OP_WRITE_ZEROES: */
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
+	__REQ_COPY,		/* copy request */
 
 	__REQ_NR_BITS,		/* stops here */
 };
@@ -440,6 +441,7 @@ enum req_flag_bits {
 #define REQ_POLLED	(__force blk_opf_t)(1ULL << __REQ_POLLED)
 #define REQ_ALLOC_CACHE	(__force blk_opf_t)(1ULL << __REQ_ALLOC_CACHE)
 #define REQ_SWAP	(__force blk_opf_t)(1ULL << __REQ_SWAP)
+#define REQ_COPY	((__force blk_opf_t)(1ULL << __REQ_COPY))
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 
@@ -470,6 +472,11 @@ static inline bool op_is_write(blk_opf_t op)
 	return !!(op & (__force blk_opf_t)1);
 }
 
+static inline bool op_is_copy(blk_opf_t op)
+{
+	return op & REQ_COPY;
+}
+
 /*
  * Check if the bio or request is one that needs special treatment in the
  * flush state machine.
@@ -529,4 +536,22 @@ struct blk_rq_stat {
 	u64 batch;
 };
 
+typedef void (cio_iodone_t)(void *private, int comp_len);
+
+struct cio {
+	struct task_struct *waiter;     /* waiting task (NULL if none) */
+	atomic_t refcount;
+	loff_t pos_in;
+	loff_t pos_out;
+	size_t comp_len;
+	cio_iodone_t *endio;		/* applicable for async operation */
+	void *private;			/* applicable for async operation */
+};
+
+struct copy_ctx {
+	struct cio *cio;
+	struct work_struct dispatch_work;
+	struct bio *write_bio;
+};
+
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 200338f2ec2e..1bb43697d43d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1054,6 +1054,9 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp);
+int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
+		      struct block_device *bdev_out, loff_t pos_out, size_t len,
+		      cio_iodone_t end_io, void *private, gfp_t gfp_mask);
 
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

