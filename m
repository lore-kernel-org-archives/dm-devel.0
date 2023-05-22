Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C50CC7EE26
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684772966;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GaA91q874MY0gYQBvkBcco8BfqJJ5cjW+aeh4IU1MLU=;
	b=aulYmowJeaAWaAvaiwxudmjVFzB4zs2PfbE3/meAH0UQh1mIwjO4mrxQYqn78tGU3imdu5
	maYAyReIpG6oi+0NV6NirUKYznTe8eub9Sqj6EI4FPMEuNyQyRNWfn2NhbHmriiGAIJu3h
	2KF59M6l+NIeln5siNL3KtuT6yU0Pc4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-4hGdG_28Mv-BG-G_JBas6A-1; Mon, 22 May 2023 12:29:22 -0400
X-MC-Unique: 4hGdG_28Mv-BG-G_JBas6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEC70101A55C;
	Mon, 22 May 2023 16:29:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 91B9540C6CDD;
	Mon, 22 May 2023 16:29:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C03019465A0;
	Mon, 22 May 2023 16:29:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A159F194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 11:10:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 906B12029F93; Mon, 22 May 2023 11:10:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 87BCB2029F6E
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:40 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66FF7185A793
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:40 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-2ct7FljmMlibTdWlGLXQGg-1; Mon, 22 May 2023 07:10:37 -0400
X-MC-Unique: 2ct7FljmMlibTdWlGLXQGg-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230522111033epoutp034b9fb16370849d20ba4f95ac50646e4e~hcq97fJ_m1225012250epoutp03R
 for <dm-devel@redhat.com>; Mon, 22 May 2023 11:10:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230522111033epoutp034b9fb16370849d20ba4f95ac50646e4e~hcq97fJ_m1225012250epoutp03R
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230522111032epcas5p316964144d58f4375f55a2da2a8222391~hcq9VsDLX2983029830epcas5p3I;
 Mon, 22 May 2023 11:10:32 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4QPvr71LKzz4x9Pt; Mon, 22 May
 2023 11:10:31 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 92.9E.44881.6AD4B646; Mon, 22 May 2023 20:10:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8~hcVLq1bVn0618606186epcas5p2K;
 Mon, 22 May 2023 10:45:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230522104536epsmtrp191a88594e0902b23cc508ff2e23402c8~hcVLoljLz1351813518epsmtrp1h;
 Mon, 22 May 2023 10:45:36 +0000 (GMT)
X-AuditID: b6c32a4a-ea9fa7000001af51-90-646b4da60e8d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 AE.DF.28392.0D74B646; Mon, 22 May 2023 19:45:36 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230522104532epsmtip2839b424711300915eee77a57ffa0f158~hcVH0JBQe1645416454epsmtip22;
 Mon, 22 May 2023 10:45:32 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 May 2023 16:11:33 +0530
Message-Id: <20230522104146.2856-3-nj.shetty@samsung.com>
In-Reply-To: <20230522104146.2856-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TaUxUVxjlvje8GdCxD9B4WVTyxLAJzCBMLyJihZZX1BRD05D+oSM8GYRZ
 OosUEsOmtEW2ohAciCJt2URGAQlrWxbLVjJStjANS1NoZMeBWpFQyjDY+u98555zz/2+m4+D
 W9aybTjREiUjlwhjKcKcVd/h7OxWdiEmkjdehSFN7884KtJUESglZxNHD8azCTTfoQcof2Ud
 R1M/+qPWpUJTNPZTI4ZaSnIxVPHgKYYeZ3NQ8/0XGHq6tUig3PYRgGaG1Rhq1bmiltYeFhps
 KiLQRNWWKbpXOsNGN0cbCFTW9Q+G2m+lYqhhOhmg+o17OKqeX2ahbp0t0m52maKNV0XEmcP0
 4NA5Wj3ZT9CN6nE2rZ14zKLzc3sJurbchR7sV9E1lV8TdI0+l013F2yw6NrvEunmsSSCzkxd
 IugXMzoWvfzDMEFn1VWCEKtPY06JGGEkI7dnJBHSyGhJlB91LjQ8INxbwOO78X3Qu5S9RChm
 /KjA8yFuH0THbk+Ksr8qjFVtUyFChYLyOH1KLlUpGXuRVKH0oxhZZKzMS+auEIoVKkmUu4RR
 nuTzeJ7e28LPYkRPFtowWW7YF5OVnawksB6UDsw4kPSCw1+WsdKBOceSbAZwQf/XbqEHUPMq
 jTAWqwAWaPrZ6YCzY7n9+qiRbwKwo3wWNxY3MFhYXs8yiAjSFfZtcQz8fnIah4tNCzsinOzC
 YU5pD24ItyKD4K/aR8CAWeQxuKYb3Engkj6woemYMcwDZk9aGBRm5En4fEC94+SSFrDnzjTL
 gHHyCEx9UrhzPSQnzODi/U3M2FsgbHy5xDZiKzjXVbeLbeBsdtoujoMVt8sJo/k6gOpRNTAe
 +MMbvdm44RE46Qw1TR5G+hDM663GjMH7YObG9G4WFzbcfYOPwipNMWHE1nDk7+RdTMO1tBa2
 cViZAM7lz5jmAHv1Ww2p32pI/X90McArgTUjU4ijGIW3zFPCxP33yxFScQ3Y2R6X4Abw+9SK
 ezvAOKAdQA5O7edezIqItORGCuMTGLk0XK6KZRTtwHt73t/gNgcipNvrJ1GG8718eF4CgcDL
 54SATx3kOvr1RFiSUUIlE8MwMkb+xodxzGySMKlrD+blOevY8nLkj7IPf9sz5Hk+rOBbdsys
 dC/zidjHMnqqd/N4vcrSNsW8Ku90zjMuUnVWUctrRz63ZXyvVCtT3z/4UNuX6HTNmr6Cd2sP
 e7+XoI+/k+wQsq/7KqcgMOjycMbYqtOmxbNUrEBgM7Ua2/lOtl3cgctYnR2ZuMfBNSGg4oxE
 bFLef7FPccFbP+HcVohNfl8PQgdQ29CjRbPy8Yx0342g4i3HoI98F+4WHTf5ZU0XcC3jrF+3
 z+uvSp/H7OWm8LUm1y9t+U6ulxzh1eU5rPBDu0o+zim5dUIUHP/noTp/Ox09IhI6bS1fujka
 nkVFDwjmgh+GxdfwRS3zFEshEvJdcLlC+C8EdyfRxgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsWy7bCSvO4F9+wUg0n3RS3WnzrGbDFn/Ro2
 i6YJf5ktVt/tZ7N4ffgTo8W0Dz+ZLR7st7fY+242q8XNAzuZLPYsmsRksXL1USaLjf0cFrsX
 fmSyOPr/LZvFpEPXGC2eXp3FZLH3lrbFnr0nWSwu75rDZnFvzX9Wi/nLnrJbdF/fwWax/Pg/
 JotDk5uZLHY8aWS02PZ7PrPFutfvWSxO3JK2OP/3OKvF7x9z2BzkPC5f8faYdf8sm8fOWXfZ
 Pc7f28jiMW3SKTaPzSu0PC6fLfXYtKqTzWPTp0nsHidm/Gbx2Lyk3mP3zQY2j97md2weH5/e
 YvF4v+8qm0ffllWMAcJRXDYpqTmZZalF+nYJXBlb3xxkKpgUUXF/1RGWBsaf7l2MHBwSAiYS
 U34pdzFycggJ7GCU+HFCHcSWEJCUWPb3CDOELSyx8t9z9i5GLqCaZiaJjZ+nsoD0sgloS5z+
 zwESFxH4wCyxfssiRpAGZoHbzBLbrkeA2MIC7hKXzm8Ai7MIqEp8uXWZHaSXV8BSYscuVYgT
 9CX67wuCVHAKWEm8uDiLGSQsBFQxYZkRSJhXQFDi5MwnLBDD5SWat85mnsAoMAtJahaS1AJG
 plWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMEpQUtrB+OeVR/0DjEycTAeYpTgYFYS
 4Q3sS04R4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6YklqdmpqQWoRTJaJg1OqgUlL
 1n/6yXROxbMh/j2P3k/ecs00P2tFpz/rhuaIGQ17r84pP79hn0x1RQfP4aolz/aYtlruWDXz
 eG1v8s7IM9sNYpLMnk7csljGKvm0+PfL4lqrfu9Yc3fdN6Gt0vLWf4PckwTTKwtdFsZsn1De
 Nm3rv5gmQznGCVfkjKJ2i6mHpOzsZriYpfs6m3eiZXYX74/Vf2vb0zOmeloelZ522V73xadg
 VVvn1KWRdy4lHc9ILPjk0XzLtaGuNsXQqORnoby4lt35j198L+byKMtzJ4c+5on5Y9fwcu7t
 rOVz1muZJaR/jHpxL/gAc0+QZaPkjK8pG7my/lef0jyfbBEnUDpX01+uQcBvjeOc65N0lFiK
 MxINtZiLihMB06tcTXgDAAA=
X-CMS-MailID: 20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8
References: <20230522104146.2856-1-nj.shetty@samsung.com>
 <CGME20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 22 May 2023 16:29:19 +0000
Subject: [dm-devel] [PATCH v11 2/9] block: Add copy offload support
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
Cc: linux-block@vger.kernel.org, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, ming.lei@redhat.com,
 James.Bottomley@HansenPartnership.com, linux-fsdevel@vger.kernel.org,
 dlemoal@kernel.org, Nitesh Shetty <nj.shetty@samsung.com>, joshi.k@samsung.com,
 nitheshshetty@gmail.com, bvanassche@acm.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

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
 block/blk-lib.c           | 235 ++++++++++++++++++++++++++++++++++++++
 block/blk.h               |   2 +
 include/linux/blk_types.h |  25 ++++
 include/linux/blkdev.h    |   3 +
 4 files changed, 265 insertions(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e59c3069e835..ed089e703cb1 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -115,6 +115,241 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
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
+ * Returns the length of bytes copied or error if encountered
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
+		return -ENOMEM;
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
+	 * completed copied length
+	 */
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
+	if (!atomic_read(&cio->refcount))
+		return -ENOMEM;
+	/* Wait for submitted IOs to complete */
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
+ * Returns the length of bytes copied or error if encountered
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
+	int ret;
+
+	ret = blkdev_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len);
+	if (ret)
+		return ret;
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
index 45547bcf1119..ec48a237fe12 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -303,6 +303,8 @@ static inline bool bio_may_exceed_limits(struct bio *bio,
 		break;
 	}
 
+	if (unlikely(op_is_copy(bio->bi_opf)))
+		return false;
 	/*
 	 * All drivers must accept single-segments bios that are <= PAGE_SIZE.
 	 * This is a quick and dirty check that relies on the fact that
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 740afe80f297..0117e33087e1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -420,6 +420,7 @@ enum req_flag_bits {
 	 */
 	/* for REQ_OP_WRITE_ZEROES: */
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
+	__REQ_COPY,		/* copy request */
 
 	__REQ_NR_BITS,		/* stops here */
 };
@@ -444,6 +445,7 @@ enum req_flag_bits {
 #define REQ_POLLED	(__force blk_opf_t)(1ULL << __REQ_POLLED)
 #define REQ_ALLOC_CACHE	(__force blk_opf_t)(1ULL << __REQ_ALLOC_CACHE)
 #define REQ_SWAP	(__force blk_opf_t)(1ULL << __REQ_SWAP)
+#define REQ_COPY	((__force blk_opf_t)(1ULL << __REQ_COPY))
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 
@@ -474,6 +476,11 @@ static inline bool op_is_write(blk_opf_t op)
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
@@ -533,4 +540,22 @@ struct blk_rq_stat {
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
index c9bf11adccb3..6f2814ab4741 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1051,6 +1051,9 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
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

