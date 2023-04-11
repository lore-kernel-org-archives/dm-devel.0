Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A5BC77B75
	for <dm-devel@archiver.kernel.org>; Wed, 12 Apr 2023 06:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681281567;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aj8oPbhZAab9pRx9lQhKKLs993lOZXMfFPqgFNiiTBQ=;
	b=HNzpbRi4hsmz8LkWax5JUBcVL7HXriUM2Kmyb/1RlgCvU9i7CZXfEl4DurehLq9wNOws2c
	9VUaR9aX6W7IcqG37WXfi/rDa21cCQZTyghxAZTOPHrTbOXGRCxuSSyjKptKGpGp2pZxS4
	q0x+kZjQ33i6uTbB3NcEK6XBPkiG1DY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-RZyJkgDeNKa2q6BKihuM0g-1; Wed, 12 Apr 2023 02:39:24 -0400
X-MC-Unique: RZyJkgDeNKa2q6BKihuM0g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 623A2100DEC5;
	Wed, 12 Apr 2023 06:39:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1C48A1400C1C;
	Wed, 12 Apr 2023 06:39:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F32719459FC;
	Wed, 12 Apr 2023 06:39:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 57D841946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 08:19:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4A50B492C14; Tue, 11 Apr 2023 08:19:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 42A89492C13
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23F2D1C06ECD
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:18 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-4RuvD-hxNnWkgZHj4Tfi0g-1; Tue, 11 Apr 2023 04:19:16 -0400
X-MC-Unique: 4RuvD-hxNnWkgZHj4Tfi0g-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230411081912epoutp029a98112ee0e3035f0a9efa3927aedf3c~U04qPuTnX0479104791epoutp026
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 08:19:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230411081912epoutp029a98112ee0e3035f0a9efa3927aedf3c~U04qPuTnX0479104791epoutp026
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230411081912epcas5p2fa20847fcb0874f420450a4623b3e033~U04ps1gvw0242802428epcas5p2Q;
 Tue, 11 Apr 2023 08:19:12 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4PwdzL2BYGz4x9Pw; Tue, 11 Apr
 2023 08:19:10 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 C5.5B.09961.EF715346; Tue, 11 Apr 2023 17:19:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230411081303epcas5p2a9bd49cc4cf49257fd7119fcb0739fa2~U0zRzJPW01765917659epcas5p2f;
 Tue, 11 Apr 2023 08:13:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230411081303epsmtrp2b562a2251d012cc891bc0ca02ee50126~U0zRx-S742545625456epsmtrp2t;
 Tue, 11 Apr 2023 08:13:03 +0000 (GMT)
X-AuditID: b6c32a49-2c1ff700000026e9-1d-643517fe3a68
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 E6.ED.08609.E8615346; Tue, 11 Apr 2023 17:13:03 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230411081258epsmtip2c30f0e17964872050b47f9cd2bc99526~U0zNqQkkt2386223862epsmtip2L;
 Tue, 11 Apr 2023 08:12:58 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Apr 2023 13:40:30 +0530
Message-Id: <20230411081041.5328-4-anuj20.g@samsung.com>
In-Reply-To: <20230411081041.5328-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbdRTH97u33Ba0y6V08gOj4lVWYQFaoOXHtrKZIV7DTDBMpzCDlV5b
 QmmbtiiKCUgD47GNMQLBwtjLOXlsTF7hDSuvAUGCrCZggD14TAjvoS4MsaWg++9zXr/vOeeX
 w8F5eWx3TpzawOjUMhVFOLHqO70EPv+4iuVCY5ETqurvwVHa+U0cVYznEmi+cxWgwuWnOLrf
 fgS1LhY7oNGORgy1XL2AobKKbgw1X1nBUPfWAoEumH8DaNpiwlDr2AHU0trHQiNNJQS69OM0
 G5nzjRhqmPoOoPqNSzi6Nb/EQnfHXkaPcjIBGtrsdTjqRo/cC6dNk4ME3WgaZ9NDEz+z6JHB
 RLq6PIuga35IoZtHUwn6rHGRoJfaLAR9rrYc0DUDyfRa9at09dQCFrE3Kv6wkpHJGZ0Ho47V
 yOPUCikVHhlzLEYsEYp8RMEoiPJQyxIYKRV6PMInLE5lXQPl8aVMlWh1Rcj0esov5LBOk2hg
 PJQavUFKMVq5Shuo9dXLEvSJaoWvmjEcFAmF/mJr4mfxyvaxAqAdlSZNProBUsFD/2zgyIFk
 INyau+dgYx7ZDOBsRmQ2cLLyKoCduZcd7MYagLnXMsBuxYOKOZY90ARgWVYt224YMbg+UbSd
 RZAC2DWbDmwBPpmBw5XprO0SnPwLg5OzNduKLqQYblU+3mYW6Qnzy8vYNuaSCJZO5WDZgGPV
 84O5k842tyMZDJ9dzCTsKc6w7/splo1x8jVorCvGbe9DssIRtueMsuy9hsKBqkHczi5wrreW
 bWd3uLbYSthZAf8emcbsrIXGnradOY/A9P5c3NYDTnrBqiY/u/sVWNB/C7Pr7oVnN6Z2Srmw
 oXSXKXi6rGSHIWz9JXWHaZgxnAbs2zoD4M0FM/s88DA9N4/puXlM/0tfBng5cGO0+gQFoxdr
 RWrmq/++OVaTUA22b8P7vQYwfn/Z1wwwDjADyMEpPnd9K0DO48plX3/D6DQxukQVozcDsXXf
 ebj7vliN9bjUhhhRYLAwUCKRBAYHSESUK1cg7YvlkQqZgYlnGC2j263DOI7uqZjUhedl4ZdO
 VPJVgpE3xnOOOw/L4zOvJfMnrqSvByxyT9VLyl+QpIaEhK5Fz7zz+53i5Koby/3CJSbBc4aX
 xd2zr/eA8PqA+5NPTB/efqmudLaQ+mn5D77u7Wy9fH8U/lb4+30t87N+aaenu4beDNMqzgjy
 HzPv7h2s2z/sUh3U80HXM+UXBS1/NlwdsWTNR+ft+ZVq/Dzayc272e/EQ0tl9ME7JRvHwuhN
 WVFJmDLlY52r2rnQcorylfE+4jMvvs5q8dfeFbSxJReTTp5Yyc+vi3JMOnS7Y5Wo8lbOZHTf
 HIr59lP2+pMHQebxoIbKiI6T1+snIw95aNoLxa6eR5+mBBnrKJZeKRN54zq97F95XxPCpAQA
 AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsWy7bCSvG6/mGmKQedjRov1p44xWzRN+Mts
 sfpuP5vF68OfGC2mffjJbPFgv73F3nezWS1uHtjJZLFn0SQmi5WrjzJZ7F74kcni6P+3bBaT
 Dl1jtHh6dRaTxd5b2hZ79p5ksbi8aw6bxfxlT9ktDk1uZrLY8aSR0WLb7/nMFutev2exOHFL
 2uJxdwejxfm/x1kdJD0uX/H2mHX/LJvHzll32T3O39vI4nH5bKnHplWdbB6bl9R77L7ZwObR
 2/yOzeP9vqtsHn1bVjF6bD5d7fF5k5zHpidvmQL4orhsUlJzMstSi/TtErgy9t+aylhw07bi
 /uPljA2Mj4y6GDk5JARMJB6ufsXSxcjFISSwg1FizrFWJoiEhMSpl8sYIWxhiZX/nrNDFDUy
 SXTuWwdWxCagLnHkeSsjSEJEYAKzxKX7DWwgDrNAO7PEm2UfWECqhAVMJf6vecEKYrMIqEpM
 XrWSHcTmFbCQmPekG2gSB9AKfYn++4IgYU4BS4k/czvYQMJCQCVL9rBAVAtKnJz5BMxmFpCX
 aN46m3kCo8AsJKlZSFILGJlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEx7WW1g7G
 Pas+6B1iZOJgPMQowcGsJML79b9xihBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n44UE0hNL
 UrNTUwtSi2CyTBycUg1MSewezD9tbl0X0kl0vbh9n2ZhyLwfbd7BEqunHj+7MKrn6Icd5/Ys
 7Q+2e/7mQRl3dkjsygKNf9z/f2wtd3BZk5Yvo5L2+8xKa4bSsKnStYxH7HIPpLXueCm3Rnfa
 vr+uGy47JfO1HNrzpnj9/UviuXN6bhh3zL+Tp/NxpaGaYnPNttznTOUbk4tv1oVs5jcNUvw6
 4cDrTE2r6qCjgQGbXI59v7PWXlZk7k4RvymRppt+a7Xbn/gY6u7yf/vNvg8hZXN/5X/eudOd
 r4Czp6SRYe7TaZNE5RWlJCNZn+tLCAt5ZCjuCzTjYD39cUGWt7ukBDt7c8RnWWslP/lvpk2s
 6/5cCLxi57nMecGpkFwlluKMREMt5qLiRABTy4M5WgMAAA==
X-CMS-MailID: 20230411081303epcas5p2a9bd49cc4cf49257fd7119fcb0739fa2
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230411081303epcas5p2a9bd49cc4cf49257fd7119fcb0739fa2
References: <20230411081041.5328-1-anuj20.g@samsung.com>
 <CGME20230411081303epcas5p2a9bd49cc4cf49257fd7119fcb0739fa2@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Wed, 12 Apr 2023 06:39:18 +0000
Subject: [dm-devel] [PATCH v9 3/9] block: add emulation for copy
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
Cc: Vincent Fu <vincent.fu@samsung.com>, bvanassche@acm.org,
 joshi.k@samsung.com, gost.dev@samsung.com, anuj20.g@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, dlemoal@kernel.org,
 Nitesh Shetty <nj.shetty@samsung.com>, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nitesh Shetty <nj.shetty@samsung.com>

For the devices which does not support copy, copy emulation is added.
It is required for in-kernel users like fabrics, where file descriptor is
not available and hence they can't use copy_file_range.
Copy-emulation is implemented by reading from source into memory and
writing to the corresponding destination asynchronously.
Also emulation is used, if copy offload fails or partially completes.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-lib.c        | 167 +++++++++++++++++++++++++++++++++++++++++
 block/blk-map.c        |   4 +-
 include/linux/blkdev.h |   3 +
 3 files changed, 172 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index b5914a357763..2b6e0f5b1f31 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -291,6 +291,169 @@ static int __blkdev_copy_offload(struct block_device *bdev_in, loff_t pos_in,
 	return blkdev_copy_wait_completion(cio);
 }
 
+static void *blkdev_copy_alloc_buf(sector_t req_size, sector_t *alloc_size,
+		gfp_t gfp_mask)
+{
+	int min_size = PAGE_SIZE;
+	void *buf;
+
+	while (req_size >= min_size) {
+		buf = kvmalloc(req_size, gfp_mask);
+		if (buf) {
+			*alloc_size = req_size;
+			return buf;
+		}
+		/* retry half the requested size */
+		req_size >>= 1;
+	}
+
+	return NULL;
+}
+
+static void blkdev_copy_emulate_write_endio(struct bio *bio)
+{
+	struct copy_ctx *ctx = bio->bi_private;
+	struct cio *cio = ctx->cio;
+	sector_t clen;
+
+	if (bio->bi_status) {
+		clen = (bio->bi_iter.bi_sector << SECTOR_SHIFT) - cio->pos_out;
+		cio->comp_len = min_t(sector_t, clen, cio->comp_len);
+	}
+	kvfree(page_address(bio->bi_io_vec[0].bv_page));
+	bio_map_kern_endio(bio);
+	kfree(ctx);
+	if (atomic_dec_and_test(&cio->refcount)) {
+		if (cio->endio) {
+			cio->endio(cio->private, cio->comp_len);
+			kfree(cio);
+		} else
+			blk_wake_io_task(cio->waiter);
+	}
+}
+
+static void blkdev_copy_emulate_read_endio(struct bio *read_bio)
+{
+	struct copy_ctx *ctx = read_bio->bi_private;
+	struct cio *cio = ctx->cio;
+	sector_t clen;
+
+	if (read_bio->bi_status) {
+		clen = (read_bio->bi_iter.bi_sector << SECTOR_SHIFT) -
+						cio->pos_in;
+		cio->comp_len = min_t(sector_t, clen, cio->comp_len);
+		__free_page(read_bio->bi_io_vec[0].bv_page);
+		bio_map_kern_endio(read_bio);
+		kfree(ctx);
+
+		if (atomic_dec_and_test(&cio->refcount)) {
+			if (cio->endio) {
+				cio->endio(cio->private, cio->comp_len);
+				kfree(cio);
+			} else
+				blk_wake_io_task(cio->waiter);
+		}
+	}
+	schedule_work(&ctx->dispatch_work);
+	kfree(read_bio);
+}
+
+/*
+ * If native copy offload feature is absent, this function tries to emulate,
+ * by copying data from source to a temporary buffer and from buffer to
+ * destination device.
+ * returns the length of bytes copied
+ */
+static int __blkdev_copy_emulate(struct block_device *bdev_in, loff_t pos_in,
+		      struct block_device *bdev_out, loff_t pos_out, size_t len,
+		      cio_iodone_t endio, void *private, gfp_t gfp_mask)
+{
+	struct request_queue *in = bdev_get_queue(bdev_in);
+	struct request_queue *out = bdev_get_queue(bdev_out);
+	struct bio *read_bio, *write_bio;
+	void *buf = NULL;
+	struct copy_ctx *ctx;
+	struct cio *cio;
+	sector_t buf_len, req_len, rem = 0;
+	sector_t max_src_hw_len = min_t(unsigned int,
+			queue_max_hw_sectors(in),
+			queue_max_segments(in) << (PAGE_SHIFT - SECTOR_SHIFT))
+			<< SECTOR_SHIFT;
+	sector_t max_dst_hw_len = min_t(unsigned int,
+		queue_max_hw_sectors(out),
+			queue_max_segments(out) << (PAGE_SHIFT - SECTOR_SHIFT))
+			<< SECTOR_SHIFT;
+	sector_t max_hw_len = min_t(unsigned int,
+			max_src_hw_len, max_dst_hw_len);
+
+	cio = kzalloc(sizeof(struct cio), GFP_KERNEL);
+	if (!cio)
+		return 0;
+	atomic_set(&cio->refcount, 0);
+	cio->pos_in = pos_in;
+	cio->pos_out = pos_out;
+	cio->waiter = current;
+	cio->endio = endio;
+	cio->private = private;
+
+	for (rem = len; rem > 0; rem -= buf_len) {
+		req_len = min_t(int, max_hw_len, rem);
+
+		buf = blkdev_copy_alloc_buf(req_len, &buf_len, gfp_mask);
+		if (!buf)
+			goto err_alloc_buf;
+
+		ctx = kzalloc(sizeof(struct copy_ctx), gfp_mask);
+		if (!ctx)
+			goto err_ctx;
+
+		read_bio = bio_map_kern(in, buf, buf_len, gfp_mask);
+		if (IS_ERR(read_bio))
+			goto err_read_bio;
+
+		write_bio = bio_map_kern(out, buf, buf_len, gfp_mask);
+		if (IS_ERR(write_bio))
+			goto err_write_bio;
+
+		ctx->cio = cio;
+		ctx->write_bio = write_bio;
+		INIT_WORK(&ctx->dispatch_work, blkdev_copy_dispatch_work);
+
+		read_bio->bi_iter.bi_sector = pos_in >> SECTOR_SHIFT;
+		read_bio->bi_iter.bi_size = buf_len;
+		read_bio->bi_opf = REQ_OP_READ | REQ_SYNC;
+		bio_set_dev(read_bio, bdev_in);
+		read_bio->bi_end_io = blkdev_copy_emulate_read_endio;
+		read_bio->bi_private = ctx;
+
+		write_bio->bi_iter.bi_size = buf_len;
+		write_bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
+		bio_set_dev(write_bio, bdev_out);
+		write_bio->bi_end_io = blkdev_copy_emulate_write_endio;
+		write_bio->bi_iter.bi_sector = pos_out >> SECTOR_SHIFT;
+		write_bio->bi_private = ctx;
+
+		atomic_inc(&cio->refcount);
+		submit_bio(read_bio);
+
+		pos_in += buf_len;
+		pos_out += buf_len;
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
+	kvfree(buf);
+err_alloc_buf:
+	cio->comp_len -= min_t(sector_t, cio->comp_len, len - rem);
+	return blkdev_copy_wait_completion(cio);
+}
+
 static inline int blkdev_copy_sanity_check(struct block_device *bdev_in,
 	loff_t pos_in, struct block_device *bdev_out, loff_t pos_out,
 	size_t len)
@@ -341,6 +504,10 @@ int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
 		ret = __blkdev_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
 			   len, endio, private, gfp_mask);
 
+	if (ret != len)
+		ret = __blkdev_copy_emulate(bdev_in, pos_in + ret, bdev_out,
+			 pos_out + ret, len - ret, endio, private, gfp_mask);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blkdev_issue_copy);
diff --git a/block/blk-map.c b/block/blk-map.c
index 3551c3ff17cf..e75bae459cfa 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -363,7 +363,7 @@ static void bio_invalidate_vmalloc_pages(struct bio *bio)
 #endif
 }
 
-static void bio_map_kern_endio(struct bio *bio)
+void bio_map_kern_endio(struct bio *bio)
 {
 	bio_invalidate_vmalloc_pages(bio);
 	bio_uninit(bio);
@@ -380,7 +380,7 @@ static void bio_map_kern_endio(struct bio *bio)
  *	Map the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-static struct bio *bio_map_kern(struct request_queue *q, void *data,
+struct bio *bio_map_kern(struct request_queue *q, void *data,
 		unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long kaddr = (unsigned long)data;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1bb43697d43d..a54153610800 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1057,6 +1057,9 @@ int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
 		      struct block_device *bdev_out, loff_t pos_out, size_t len,
 		      cio_iodone_t end_io, void *private, gfp_t gfp_mask);
+struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
+		gfp_t gfp_mask);
+void bio_map_kern_endio(struct bio *bio);
 
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

