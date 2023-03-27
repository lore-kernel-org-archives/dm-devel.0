Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE1CC761AF
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680157985;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=udBVxxlK6kdhMxq66XAv2mMkze5PE0bw2grhu2CRlwE=;
	b=fezkjcjGMKwogT+SfgqBG3PA+Dj9gz0eB3+thtLtZRWvxM1ELvOVHqra1szp8kgWMz6bKK
	5XSjAhMTkDGlx7LQDxKYbp9c/L/1aX08AC+smUxfyO9vnwHo+bH934m1iK1n2GKhWwvmIF
	H680GvTe9Q5Mg9ZkNasV4WtMfydZwIw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-mZwk2xNJNEu8U24IeHKipw-1; Thu, 30 Mar 2023 02:33:03 -0400
X-MC-Unique: mZwk2xNJNEu8U24IeHKipw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E59A8280BF72;
	Thu, 30 Mar 2023 06:33:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 551581121333;
	Thu, 30 Mar 2023 06:33:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EEB931946A67;
	Thu, 30 Mar 2023 06:32:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3F132194658F
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 08:26:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23B2AFD6E; Wed, 29 Mar 2023 08:26:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C07E18EC6
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:26:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F16EE886462
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:26:11 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-u1lvnfXTMaa_c7VnEfBMWQ-1; Wed, 29 Mar 2023 04:26:10 -0400
X-MC-Unique: u1lvnfXTMaa_c7VnEfBMWQ-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230329081611epoutp020bbb2d7958dab9c2723e80bada927a50~Q1dTr-Jv92861028610epoutp02I
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:16:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230329081611epoutp020bbb2d7958dab9c2723e80bada927a50~Q1dTr-Jv92861028610epoutp02I
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230329081610epcas5p2d7561bc6f101ea54fb5213140dac3bf1~Q1dS9dGIM1664716647epcas5p27;
 Wed, 29 Mar 2023 08:16:10 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4PmfWr1zKQz4x9QD; Wed, 29 Mar
 2023 08:16:08 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 0D.FF.06765.8C3F3246; Wed, 29 Mar 2023 17:16:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230327084235epcas5p495559f907ce39184da72a412c5691e43~QOhyUneER1922519225epcas5p4T;
 Mon, 27 Mar 2023 08:42:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230327084235epsmtrp272391a7d39c94643d70c5131fbca4a5f~QOhyTjvI92690526905epsmtrp2m;
 Mon, 27 Mar 2023 08:42:35 +0000 (GMT)
X-AuditID: b6c32a4b-20fff70000011a6d-b8-6423f3c85b85
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 D2.3C.18071.BF651246; Mon, 27 Mar 2023 17:42:35 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230327084231epsmtip15b2b6358f9832c39a98a2988b37b33a1~QOhu6xmSe2834728347epsmtip1d;
 Mon, 27 Mar 2023 08:42:31 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Mon, 27 Mar 2023 14:10:51 +0530
Message-Id: <20230327084103.21601-4-anuj20.g@samsung.com>
In-Reply-To: <20230327084103.21601-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfzCbdxzH7/s8+UWne0TLVzodj/UchqRFv6rMrd32bHqbq223H7cjk4cg
 kiyJru1sfqTR0qWsuq6CorV2uGPDShHTaKk41U650VNmUaVFMdaeU0ua2Prf6/O59/v7+fG9
 DwfnnmbzOIlSFa2QCiUky55xqcPbx+/6oqeIf/HJBlRr7MRRVv4qjqpH8ljoQccCQKcfPcHR
 Sm8fjvSzRUw01H4ZQ63nTmKosvoahlrK5zF0bW2GhU4aBgGaGNBhSD/si1r13QzU31zMQqUX
 JtjIUKDGUJMpE6BLK6U4qnkwx0DXh7egv44fA6hvtYsZ4Ur1346kdKO9LOqyboRN9d39hUH1
 96ZSdVU5LKq+Ip1qGcpgUVr1rFmgGWVSc20DLOpEQxWg6nu+ohbrtlJ1phks6sVPkneLaaGI
 VrjT0jiZKFGaEEZGRsfsiQkK5gv8BCFoJ+kuFabQYeTefVF+byZKzMsg3Q8IJanmVJRQqSQD
 wncrZKkq2l0sU6rCSFouksgD5f5KYYoyVZrgL6VVuwR8/vYgszA2WdxjzAVyY8TBM0+b2Rkg
 OygX2HEgEQiXCtuYucCewyVaALzdtoRZgwUAcwqmcIuKSywD+MM573WH8ewUyyrSA1jXeA9Y
 RWoMTt8iLcwivODVSQ2wiDYR2Ticn8hhWAKc0ODQ1N7EtqiciCDYdbHimZtBbIOTT++wLOxA
 hMCynmIzc8zlAmDeqKMlbUfsgsVNRqZV4gi7C00MC+PEy1D9axFueR8StXZwyDAHrK3uhVnD
 apaVneB0VwPbyjy4OKu35RPg4/4JzMpyqO5ss3lfgxpjHm7pASe8YW1zgDXtBr831mDWuhuh
 dsVkszrAprPrTMKjlcU2hlB/I8PGFCz5O9u2Xi2ArRfa2fnAXffcPLrn5tH9X7oM4FXAlZYr
 UxJoZZB8h5T+8r9fjpOl1IFnB+IT2QTGxx75GwDGAQYAOTi5yWFlkBRxHUTCQ4dphSxGkSqh
 lQYQZN73dzhvc5zMfGFSVYwgMIQfGBwcHBiyI1hAujh4hXXHcYkEoYpOpmk5rVj3YRw7Xga2
 dacnXvhbB3TO+kkpjvL49p721c/HRiuSPoh/P3pPo29J/Hhow9vB9++uZW97Pab2fjzv8adj
 goD5L/r2b6hO2Vz0oXhLw589sQ2N8741zq6D6Uf2Lad5X3Hanz6g154oV3XeEXh+7fHu75yp
 xTXksj060/m9NM8ISThW8xG/bNyn/OEbeUTXqVnuzZxbk7zzbzWHMk9VuWEH08pfCcv+MZln
 WDi/8UhLbt1nqw9NWp+jq+IMzDHt4xv/eF05vJg1blo6M5M2cTXTLcn5QP0MeySrsiM84nhS
 AbjZ+4dL/gv8Ug9lR8lLY2WHJKsRoSbZtH+zxin+5zaRBtpLv2kNjF1OnHunlGQoxUKBD65Q
 Cv8Fi8niWqkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRzGec85O+e4GJ1ml1fNzNGorLxExpuEmlAdsg8SaRiUjXZwyznX
 pl0/uDS7LEoxum1imlZqYbmZmXMRq2Vu2cSVaWV2UZZZZuYkk1Y6Cfr28Px+PP8PfxoXPiMC
 abkym1MrJQoRyScaHooWrJhICZVG5t1m0C37YxzlFf3G0Y2eQhINPhwB6PzwOI4m2pw4sgwZ
 eKj7wT0MNV8pxlD1DRuGzOXfMWT785VExdZOgPpf6DFkebUMNVtaCeRqKiHR5Wv9FLKezcdQ
 Y98RgBomLuOodvAbgZ68CkIfT50AyPm7hRcfwLqeJ7L63jaSvafvoVjn2zqCdbXlsMaakyRr
 qsxlzd1akj2dPzQpFPTy2G/3X5DsmfoawJoch9kfxgWsse8rljRzO3+tlFPI93HqiNhdfJnD
 rgMqe/yBi94mSguOReuAHw2ZVdBeOkDqAJ8WMmYA+yo6yWkAoX3gGpjO/rDa66ampSMYfDx+
 lJgCJLMYPnIXgCkwmynCYUev1jeFM+dw6DF/8U35M9Gw5Xqlb4pgxNDtfe3rBcwaWOYomcz0
 5IkIWNg7a6r2Y2JgSaOdN5WFk0rh8SZsWp8FWy/1+Q7jTAjMv2PAiwCj/w/p/0NlAKsBAZxK
 k5meqYlSRSm5/eEaSaYmR5kevjsr0wh8Lw9b2gju1gyHWwFGAyuANC6aLTAlhkqFAqnk4CFO
 nZWmzlFwGisIognRPEG7rjVNyKRLsrkMjlNx6n8Uo/0CtZjB5alfV7JSVlA0ESftCI+1icFo
 V+rGKwLK9T0kqONzZLBj4TvxDnvQMmdenMcQVeUIDj5dNSe1as/80qRN6tzRhL1S5dXm7qR2
 e0aic+6SRdHZh1/Hem7qyqVK1bERWUKqw52cG0KVbY2rNPI9pp+dxZb38vVv6iLCLjRF140N
 hw6cRzFpB9DH+RcGqSX99Suy2s/OWPQrI/DSqpeecW31h+CM+JgAhzhyy85t8jrpTzmVwmtY
 11U21PLlnX9Xbc+GpybB/R7zIZuCeO81yKiKNeq5+YbBkaEKd3kyerow4MdiW2pB7SfF6IwE
 LzF2ZvlmS8xqmFA1JjaoRLs3iAiNTBIVhqs1kr9diRZoYQMAAA==
X-CMS-MailID: 20230327084235epcas5p495559f907ce39184da72a412c5691e43
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230327084235epcas5p495559f907ce39184da72a412c5691e43
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084235epcas5p495559f907ce39184da72a412c5691e43@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: [dm-devel] [PATCH v8 3/9] block: add emulation for copy
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
 ming.lei@redhat.com, linux-block@vger.kernel.org, nitheshshetty@gmail.com,
 linux-fsdevel@vger.kernel.org, damien.lemoal@opensource.wdc.com,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 block/blk-lib.c        | 171 ++++++++++++++++++++++++++++++++++++++++-
 block/blk-map.c        |   4 +-
 include/linux/blkdev.h |   3 +
 3 files changed, 175 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index cbc6882d1e7a..a21819e59b29 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -289,6 +289,169 @@ static int __blk_copy_offload(struct block_device *bdev_in, loff_t pos_in,
 	return cio_await_completion(cio);
 }
 
+static void *blk_alloc_buf(sector_t req_size, sector_t *alloc_size,
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
+static void blk_copy_emulate_write_end_io(struct bio *bio)
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
+static void blk_copy_emulate_read_end_io(struct bio *read_bio)
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
+ * returns the length of bytes copied or negative error value
+ */
+static int __blk_copy_emulate(struct block_device *bdev_in, loff_t pos_in,
+		      struct block_device *bdev_out, loff_t pos_out, size_t len,
+		      cio_iodone_t end_io, void *private, gfp_t gfp_mask)
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
+		return -ENOMEM;
+	atomic_set(&cio->refcount, 0);
+	cio->pos_in = pos_in;
+	cio->pos_out = pos_out;
+	cio->waiter = current;
+	cio->endio = end_io;
+	cio->private = private;
+
+	for (rem = len; rem > 0; rem -= buf_len) {
+		req_len = min_t(int, max_hw_len, rem);
+
+		buf = blk_alloc_buf(req_len, &buf_len, gfp_mask);
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
+		INIT_WORK(&ctx->dispatch_work, blk_copy_dispatch_work_fn);
+
+		read_bio->bi_iter.bi_sector = pos_in >> SECTOR_SHIFT;
+		read_bio->bi_iter.bi_size = buf_len;
+		read_bio->bi_opf = REQ_OP_READ | REQ_SYNC;
+		bio_set_dev(read_bio, bdev_in);
+		read_bio->bi_end_io = blk_copy_emulate_read_end_io;
+		read_bio->bi_private = ctx;
+
+		write_bio->bi_iter.bi_size = buf_len;
+		write_bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
+		bio_set_dev(write_bio, bdev_out);
+		write_bio->bi_end_io = blk_copy_emulate_write_end_io;
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
+	return cio_await_completion(cio);
+
+err_write_bio:
+	bio_put(read_bio);
+err_read_bio:
+	kfree(ctx);
+err_ctx:
+	kvfree(buf);
+err_alloc_buf:
+	cio->comp_len -= min_t(sector_t, cio->comp_len, len - rem);
+	return cio_await_completion(cio);
+}
+
 static inline int blk_copy_sanity_check(struct block_device *bdev_in,
 	loff_t pos_in, struct block_device *bdev_out, loff_t pos_out,
 	size_t len)
@@ -338,15 +501,21 @@ int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
 	struct request_queue *q_in = bdev_get_queue(bdev_in);
 	struct request_queue *q_out = bdev_get_queue(bdev_out);
 	int ret = -EINVAL;
+	bool offload = false;
 
 	ret = blk_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len);
 	if (ret)
 		return ret;
 
-	if (blk_check_copy_offload(q_in, q_out))
+	offload = blk_check_copy_offload(q_in, q_out);
+	if (offload)
 		ret = __blk_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
 			   len, end_io, private, gfp_mask);
 
+	if ((ret != len) || !offload)
+		ret = __blk_copy_emulate(bdev_in, pos_in + ret, bdev_out,
+			 pos_out + ret, len - ret, end_io, private, gfp_mask);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blkdev_issue_copy);
diff --git a/block/blk-map.c b/block/blk-map.c
index 7b12f4bb4d4c..be2414904319 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -362,7 +362,7 @@ static void bio_invalidate_vmalloc_pages(struct bio *bio)
 #endif
 }
 
-static void bio_map_kern_endio(struct bio *bio)
+void bio_map_kern_endio(struct bio *bio)
 {
 	bio_invalidate_vmalloc_pages(bio);
 	bio_uninit(bio);
@@ -379,7 +379,7 @@ static void bio_map_kern_endio(struct bio *bio)
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

