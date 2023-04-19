Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE3FC77B73
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973845;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IFfoekX43bw99MO6bcpfiNGIKYdEy2oSEjQTiow4nrU=;
	b=JuPKZ6BoIBiVfpmAJxbSXbp+xLd3paGq50oIbmHfjbZsGo+4H1tcMAeQAjclXfLOqkeRqe
	KPm3tpUIuaDx9kxIlR5LdqRxbfa3+dQmVlABy6iwA/eMEDNkk0+WbNuRhGaP+PbRMbp9+P
	9V6wgfzjQqnvwl/7wO31k5adNbg7rqA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-3sUoMtKpOYKROkwXMxVbfQ-1; Thu, 20 Apr 2023 02:57:22 -0400
X-MC-Unique: 3sUoMtKpOYKROkwXMxVbfQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BACE6800047;
	Thu, 20 Apr 2023 06:57:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9DB501410F24;
	Thu, 20 Apr 2023 06:57:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 73E7F19472C9;
	Thu, 20 Apr 2023 06:57:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 786EC19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 11:54:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 66FED4014E82; Wed, 19 Apr 2023 11:54:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EDD94014E81
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DCAC28043C5
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:33 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215--nqwdgQNNgGEib1uRFJtVA-1; Wed, 19 Apr 2023 07:54:31 -0400
X-MC-Unique: -nqwdgQNNgGEib1uRFJtVA-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230419115427epoutp0140a6aaf622b2378080ddcefb4d651baa~XU_4XvsVf1427214272epoutp012
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 11:54:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230419115427epoutp0140a6aaf622b2378080ddcefb4d651baa~XU_4XvsVf1427214272epoutp012
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230419115427epcas5p4cb4a56e7e55f15087e9498b3a825bef5~XU_3oi3bu0896108961epcas5p4M;
 Wed, 19 Apr 2023 11:54:27 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4Q1fN12tJMz4x9Pp; Wed, 19 Apr
 2023 11:54:25 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 4C.04.09987.176DF346; Wed, 19 Apr 2023 20:54:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230419114705epcas5p376d05f7c5f892d82590c2137650dd291~XU4cZ_fLw0477504775epcas5p33;
 Wed, 19 Apr 2023 11:47:05 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230419114705epsmtrp29b292ae34f628324de1701f82e39a126~XU4cYkyw22700627006epsmtrp2k;
 Wed, 19 Apr 2023 11:47:05 +0000 (GMT)
X-AuditID: b6c32a4b-7fbff70000002703-11-643fd6718857
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 EF.87.08279.9B4DF346; Wed, 19 Apr 2023 20:47:05 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230419114701epsmtip1854900c6066e7cb09f6e4078a2838c2d~XU4Y5mivx2050920509epsmtip1K;
 Wed, 19 Apr 2023 11:47:01 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Wed, 19 Apr 2023 17:13:07 +0530
Message-Id: <20230419114320.13674-3-nj.shetty@samsung.com>
In-Reply-To: <20230419114320.13674-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzeubfctmZlV2DjAJtrasYEVmhnYQcUOx/oTWAJw2wYJqlNuQFG
 aUsfMNFlIANB5TEqRgsTgeGQMojAHIIwKamMgjHjNZCBblAzdbwXGXHgKBc3//vO9/u+3+vk
 x8FdTrI9OYkqPa1VyZUCYhPrWpePrzBlWBonmq9zRg22Wzg6UbSCI/N4IYEedy0AdG5uGUf3
 f5Si9plSJzR68zqGblQWY+iK2Yqhtop5DFmfTROo2DIMkH3IhKH2u37oRnsPCw20lhGo/LKd
 jSzGLAy1TGUCdO1pOY7qH8+y0E93vdCdlW6n9yE1MBhOme7dJqjrpnE2dWfiKosauG2gGmvz
 CKrpmy+ottEMgsrPmiGo2Y4hgiporgVUU+8xarFxC9U4NY1FOsck7Uyg5XG0lk+rFOq4RFV8
 qCD8oGyvLDBIJBaKg9F7Ar5KnkyHCvZFRAr3JyrXNiDgp8qVhjUqUq7TCQJ27dSqDXqan6DW
 6UMFtCZOqZFo/HXyZJ1BFe+vovUhYpHo3cA14ZGkhKrcVUxTfOizhr6UDLB84BTgciApgaeX
 RlgO7EK2ATiWHX4KbFrDCwCW2cws5vEEwNWpZvYpwFl3VK6oGEM7gDl/ezOabAzaW35wcmgI
 0g/2PuM4eDcyB4fz9rz1RDjZj8F/mmdxh9uVPABzLvxBODCLfAs+Kq5eN/PIEJhZE83UCoCF
 9zY7FFxyB/y2w7ju5JGbYc+FqfWmcfJNmPV9Ke5ID8kqLizMLWEzk+2DqxcHcQa7wkfdzRu8
 J1ycaScYnAavnK0hGPOXAJp+MQEmIIXZtkLc0QRO+sCG1gCGfgOW2OoxprAzzH86hTE8D7Zc
 fI63wrqGSxv5PeDwUuYGpmDlZDdgFlcAYP+irAjwTS/MY3phHtP/lS8BvBZ40BpdcjytC9Rs
 V9Fp//2wQp3cCNYvwje8Bfx+f87fAjAOsADIwQVuvL6wkDgXXpz8aDqtVcu0BiWts4DAtXV/
 hXu+qlCvnZRKLxNLgkWSoKAgSfD2ILHAnfd2aI/ChYyX6+kkmtbQ2uc+jMP1zMD4HVGW5fqA
 WKPd62Hi54t15sgHvhL/aez4YEeAV2MM+aTi2M8xZdsGS0Q3Rw59F+lenfWxMbo0Raz5JKpp
 6bj0aFJA1/y5BeVoIS6ILhN+PWGzlcfuvryVmPTMjKjJOG3uId129G+LMpxNz08f4XB2H77K
 Ixf2jL+uqKvIa/2woJMj7RTlhp2srmmTjt068xfbNbVIY431CKuYT+389U/viYixg6/sCjQ2
 263c0hw9ErvX9MXmtghrjcLQInvf/rIY9/O51tc+cPfhDrgm9E7+NuR9/qXYtpYj75jDpfmH
 93j7b3FSnEgzZM8MiObSRh5+ekYym/lAVmUOWf7IavB7eU7A0iXIxb64Vif/FziYlyeaBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWy7bCSnO7OK/YpBrdPiFusP3WM2aJpwl9m
 i9V3+9ksXh/+xGgx7cNPZosH++0t9r6bzWpx88BOJos9iyYxWaxcfZTJYvfCj0wWR/+/ZbOY
 dOgao8XTq7OYLPbe0rbYs/cki8XlXXPYLOYve8pucWhyM5PFjieNjBbbfs9ntlj3+j2LxYlb
 0hbn/x5ndZDwuHzF22PW/bNsHjtn3WX3OH9vI4vH5bOlHptWdbJ5bF5S77H7ZgObR2/zOzaP
 9/uusnn0bVnF6LH5dLXH501yHpuevGUK4IvisklJzcksSy3St0vgyljc8Y+pYFJExfozhQ2M
 P927GDk4JARMJBb9zeti5OIQEtjNKHHx+jLGLkZOoLikxLK/R5ghbGGJlf+es0MUNTNJdN/a
 xwTSzCagLXH6PwdIXERgArPEpfsNbCAOs8ADJonzz7+wgnQLC7hLtM18wQZiswioSryatJQV
 pJlXwEqicUU4xBH6Ev33BUEqOAWsJZbvmwy2VwiooufQP7B7eAUEJU7OfMICYjMLyEs0b53N
 PIFRYBaS1CwkqQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYLjWEtzB+P2VR/0
 DjEycTAeYpTgYFYS4XW3sUsR4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh62S8kEB6Yklqdmpq
 QWoRTJaJg1OqgWmCSzjXLB7RohYOdd26w9kiy0qD5QsfRTyb0Frk3MN3P5lRsn7OTU2+N0sD
 0j72fbl2+F16ftmNS5mvO8VOdk7JZH3Bl6woumymWnN5Pfe/pXv5r0ebcPv9j2SuqgrhcXtg
 wjHxYOTue9qCv9vKzc2qfk0I29eWzll2plfM0OtW2v/n+4Nrp/Bz/331ryLFjsnXxOhc7euZ
 7/+rqp/x+57+XGHdsR3Pgnul46TyDKsmpT+9dO2ol4vv9nU7FBf8OcC7a/J8X/N/nmuy0+rX
 G1a8vjZr8UnxPzUiDyvF/BdIGuZFL7i26ZzvubUneWzUnpxde1M7zHzpPU299r1G+f92puf8
 2POrPHn5iWmtR5RYijMSDbWYi4oTAXRMuvZSAwAA
X-CMS-MailID: 20230419114705epcas5p376d05f7c5f892d82590c2137650dd291
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230419114705epcas5p376d05f7c5f892d82590c2137650dd291
References: <20230419114320.13674-1-nj.shetty@samsung.com>
 <CGME20230419114705epcas5p376d05f7c5f892d82590c2137650dd291@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: [dm-devel] [PATCH v10 2/9] block: Add copy offload support
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
index 62fca868bc61..d245817d2242 100644
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
index 8ef209e3aa96..f8aa539dc4c8 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -421,6 +421,7 @@ enum req_flag_bits {
 	 */
 	/* for REQ_OP_WRITE_ZEROES: */
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
+	__REQ_COPY,		/* copy request */
 
 	__REQ_NR_BITS,		/* stops here */
 };
@@ -445,6 +446,7 @@ enum req_flag_bits {
 #define REQ_POLLED	(__force blk_opf_t)(1ULL << __REQ_POLLED)
 #define REQ_ALLOC_CACHE	(__force blk_opf_t)(1ULL << __REQ_ALLOC_CACHE)
 #define REQ_SWAP	(__force blk_opf_t)(1ULL << __REQ_SWAP)
+#define REQ_COPY	((__force blk_opf_t)(1ULL << __REQ_COPY))
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 
@@ -475,6 +477,11 @@ static inline bool op_is_write(blk_opf_t op)
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
@@ -534,4 +541,22 @@ struct blk_rq_stat {
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

