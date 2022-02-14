Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F510C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 08:04:05 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-nHVyinW3NPuiTHSSRGtZFg-1; Tue, 15 Feb 2022 03:03:55 -0500
X-MC-Unique: nHVyinW3NPuiTHSSRGtZFg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 201C21091DA2;
	Tue, 15 Feb 2022 08:03:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AAB655F62;
	Tue, 15 Feb 2022 08:03:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9A3584A7C8;
	Tue, 15 Feb 2022 08:03:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21E8vAT1011575 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 03:57:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8FE681466C42; Mon, 14 Feb 2022 08:57:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B1441466C41
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:57:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D5F51800746
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:57:10 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-653-VHmBJHuIOV-sUStGKa9pHw-1; Mon, 14 Feb 2022 03:57:08 -0500
X-MC-Unique: VHmBJHuIOV-sUStGKa9pHw-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20220214085705epoutp028949dbcb2b9a5f51b53fb31f6de78f90~Tm0igiQe10681406814epoutp02K;
	Mon, 14 Feb 2022 08:57:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20220214085705epoutp028949dbcb2b9a5f51b53fb31f6de78f90~Tm0igiQe10681406814epoutp02K
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20220214085704epcas5p433fe0ae635ce463ec33978f2d52c11fc~Tm0h5kZTU2118621186epcas5p48;
	Mon, 14 Feb 2022 08:57:04 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4JxylC1ZzFz4x9Q9;
	Mon, 14 Feb 2022 08:56:55 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	57.3D.06423.6591A026; Mon, 14 Feb 2022 17:56:55 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080612epcas5p2228606969011ce88a94d3b1be30d0614~TmIH9V4h72142721427epcas5p2N;
	Mon, 14 Feb 2022 08:06:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20220214080612epsmtrp21dcf801d7107998893711767c2b140d0~TmIH7gD1L2568725687epsmtrp2f;
	Mon, 14 Feb 2022 08:06:12 +0000 (GMT)
X-AuditID: b6c32a49-31b55a8000001917-52-620a195679c1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	70.D1.29871.47D0A026; Mon, 14 Feb 2022 17:06:12 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080608epsmtip2df35a273e58e2cb2ae994af95e1eaa21~TmIDdugLd2250822508epsmtip2u;
	Mon, 14 Feb 2022 08:06:08 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Mon, 14 Feb 2022 13:29:53 +0530
Message-Id: <20220214080002.18381-4-nj.shetty@samsung.com>
In-Reply-To: <20220214080002.18381-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTVxjm3NveXtjQu6Ls0ITYFQzjUzqgHhCmi0CuYjImyxZJFCtcgQGl
	a4tsM9uEBvxgKh+CUIbUiVZ0AYHJykeZYNChVjAVRhFQBsQojg9RAQFZ4cLmv+d5zvOe9zzv
	yUvi/Ls8ARkvUzEKmTRRRNhwaq+7unl+6WCzz/tRFoYqb93AUaN5kosu950kUMH4DI7Gmge5
	KPdkIQ+ZhlYhw2gxF3VMp2FosHoBQ42/5GKo/HIrhh7rzgHUcHYCQ0dvd2BobkCMWhf+IVBu
	SxdAw50aDBl63FGjoY2DTPU/E6j0wjAPZf2lJ1DTiAFHuptvMHRXM0cg/VAaQLWzpTi63t/J
	QRUjYxw0Mt1GoMyqlwBl/DTDQ+3zN7lbnGjT/TBa89BI0DnqUR5dp+nj0e39VRxare3l0CZj
	Cl196ShB15T9SOd16wDdYD5E0Ol3WnG68PkLgj6uHiXoieEeDj3W1EmE20cmBMYx0hhGIWRk
	0ckx8bLYIFFYRNTWKD+Jt9hT7I82ioQyaRITJAreEe4ZGp9oGaJIeECamGKRwqVKpWjDx4GK
	5BQVI4xLVqqCRIw8JlHuK/dSSpOUKbJYLxmjChB7e3/kZzHuTYhraTfz5M+++Kbn3jz3ENCH
	HgPWJKR8YU3PG+IYsCH5VAOA9/VVGEueA1jR3MdZdPGpVwBmPA5ZqSjpasJZkwHAtMEFDksy
	MJhfV2QhJElQ7vD2ArlYsIbiwPKpqSUPTp3hwfI/5sDigR1Fw4oXvfgi5lDrYXH54JJuSwXA
	7pK/AdvNCZ4daOYuYmtqE7w2osNZz3uwrWho6XU4tQ6qrxbjrD/dBo5X7GdxMCytXVi+xw4+
	vfkbj8UCODlqWMoMqSwAp+88xFhSCKA6W02wrs3wXuM8tpgGp1xhZf0GVnaE+bcqMLbxKnh8
	dghjdVuoP7OCneCvldrlaxxg11TaMqZhs7qSy470BIAdD3ZmA6HmrTyat/Jo/u+sBfgl4MDI
	lUmxjNJPLpYxqf/9cnRyUjVYWiy3bXrQ92jcqwVgJGgBkMRFa2z3GK338W1jpN9+xyiSoxQp
	iYyyBfhZBp6DC9ZGJ1s2U6aKEvv6e/tKJBJffx+JWPS+7e3YK1I+FStVMQkMI2cUK3UYaS04
	hJ24MjliH3BqxrnecXWq18U8gbOH+QfBPlm9+PuSq7OB8dXNblRuubw5VUuFnH71xNFwWF0k
	mAk4fzDH2vnTPx9szdx1vsgcPXZEItFlCnGFR7pUG2ma36yNsH+5Ov6inY/Lhzv4V7up4K+g
	JGzL542rgrvP7dZecx8W1F0L1JV9HVdmPJKXPWFl3eHe7xBYYKrv3YPymjJmhwcu9PvVhmRa
	7axdGA85bQzT5H+QN7ZfYzYerPHr7KPmT/kwAR57Uw98Frw71PXs2j2R6+KYTe1mrdX09rJP
	nugPZ+4S9pFtox4Fz8aN5PobES661tdkkcvv7/rzVRuf1gbYv97+DqnsShRxlHFSsRuuUEr/
	BdfCf+XhBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxiGfc93m9UdC5SD07DUNOIHaFWyN5sjhBF9Iy7ZfswtDMQ6zwqT
	lqYtMjVGsFjXsk2Hm2KBoXOjUgkORKgWmBSYq1jAYKFlgEEguHXy4UAgCmyFLfHflVxX7ufP
	w+Dik+RKJk2t57VqRbqUEhI1TdLwSL1IuH/z074t8NrdX3FY5/ubhFf7TlPw3PgsDscaB0mY
	f7qAhp1Dy2H9aCEJO2ZyMDhYtYDBuh/yMVh2tQWDI9bLADouTWDQ1NqBwRcDctiy8ISC+c4u
	AIc9FgzW92yAdfUuAnbeKqJgSekwDfO67RRs8Nfj0HpnHoNtlhcUtA/lAFjzvASHTf0eAlb4
	xwjon3FR0Fg5BeDJL2dp2D53h4xdgzofJCDLQzeFvjGM0uimpY9G7f2VBDJc7CVQpzsTVdlM
	FLr+43F01msFyOHLptCJey04Kng6SaGvDKMUmhjuIdBYg4d6T5Io3H6AT087xGs3xewTpjrb
	fbTmrz2f99yfI7OBfYcZCBiO3cYVdzXgZiBkxKwDcL1WH74kwrjSueb/OIgrmx+hlyIDxplq
	ZykzYBiK3cC1LjCBJpgluLLpaSLQ4OxvNDdWUk4HRBCLuIrJ3sUhgpVxhWWDIMAi9k3OW/wI
	LB1Yw10aaCQDLGDf4m77rYu9+N+mwOOkl/oVnOvCEBFgnA3nDDcK8TOAtbykLC+piwCzgTBe
	o1MpVTq5Rq7ms6J0CpUuU62M+iRDVQUWP2X9OjuotY1HOQHGACfgGFwaLNrrFuwXiw4oDh/h
	tRkp2sx0XucErzGENFTUYXaliFmlQs8f5HkNr/3fYoxgZTaWGl4TtK7I97p/16dHx1tVBtOf
	dJ47Wdbf/bXmUK1x5+9hs/zxPEGo/QrWdOrwnubYFcaiIxPdPdac7UR16XcPNv+ye/Xbabcm
	+Y9DvMtylO+kSG58oGnSflH0SkxXwpWkkJrz+tuW4mR126uiVSHHJLEpDcgzsFW2fCKD/Wnq
	gmR3W7Aqtys/9Ki+WpkceTO62LDMuzraXT4j2WhzVc4ffKPPyL4r+z6k8KO45izmYUd2TO6p
	qj/IEYfy2lRjfFLW4/hnkunIXNuHe983VehVhtjG2p2X196LSJx0RCcmGX+OSPxWtulRXP9n
	z50JO7aI5Gvjy737zjwuNVeHRazaZcbJOCmhS1XI1+NaneIfIKwiXZgDAAA=
X-CMS-MailID: 20220214080612epcas5p2228606969011ce88a94d3b1be30d0614
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080612epcas5p2228606969011ce88a94d3b1be30d0614
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080612epcas5p2228606969011ce88a94d3b1be30d0614@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21E8vAT1011575
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 15 Feb 2022 03:03:41 -0500
Cc: Sagi, Nitesh, Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	Chaitanya Kulkarni <kch@nvidia.com>, osandov@fb.com,
	Alasdair Kergon <agk@redhat.com>, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
	hch@lst.de, Shetty <nj.shetty@samsung.com>,
	chaitanyak@nvidia.com, SelvaKumar S <selvakuma.s1@samsung.com>,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, Grimberg <sagi@grimberg.me>,
	axboe@kernel.dk, tytso@mit.edu, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [dm-devel] [PATCH v3 03/10] block: Add copy offload support
	infrastructure
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce blkdev_issue_copy which supports source and destination bdevs,
and an array of (source, destination and copy length) tuples.
Introduce REQ_COPY copy offload operation flag. Create a read-write
bio pair with a token as payload and submitted to the device in order.
Read request populates token with source specific information which
is then passed with write request.
This design is courtesy Mikulas Patocka's token based copy

Larger copy will be divided, based on max_copy_sectors,
max_copy_range_sector limits.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
Signed-off-by: Arnav Dawn <arnav.dawn@samsung.com>
---
 block/blk-lib.c           | 227 ++++++++++++++++++++++++++++++++++++++
 block/blk.h               |   2 +
 include/linux/blk_types.h |  21 ++++
 include/linux/blkdev.h    |   2 +
 include/uapi/linux/fs.h   |  14 +++
 5 files changed, 266 insertions(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 1b8ced45e4e5..efa7e2a5fab7 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -135,6 +135,233 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
+/*
+ * Wait on and process all in-flight BIOs.  This must only be called once
+ * all bios have been issued so that the refcount can only decrease.
+ * This just waits for all bios to make it through bio_copy_end_io. IO
+ * errors are propagated through cio->io_error.
+ */
+static int cio_await_completion(struct cio *cio)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cio->lock, flags);
+	if (cio->refcount) {
+		cio->waiter = current;
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock_irqrestore(&cio->lock, flags);
+		blk_io_schedule();
+		/* wake up sets us TASK_RUNNING */
+		spin_lock_irqsave(&cio->lock, flags);
+		cio->waiter = NULL;
+		ret = cio->io_err;
+	}
+	spin_unlock_irqrestore(&cio->lock, flags);
+	kvfree(cio);
+
+	return ret;
+}
+
+static void bio_copy_end_io(struct bio *bio)
+{
+	struct copy_ctx *ctx = bio->bi_private;
+	struct cio *cio = ctx->cio;
+	sector_t clen;
+	int ri = ctx->range_idx;
+	unsigned long flags;
+
+	if (bio->bi_status) {
+		cio->io_err = bio->bi_status;
+		clen = (bio->bi_iter.bi_sector - ctx->start_sec) << SECTOR_SHIFT;
+		cio->rlist[ri].comp_len = min_t(sector_t, clen, cio->rlist[ri].comp_len);
+	}
+	__free_page(bio->bi_io_vec[0].bv_page);
+	kfree(ctx);
+	bio_put(bio);
+
+	spin_lock_irqsave(&cio->lock, flags);
+	if (!--cio->refcount && cio->waiter)
+		wake_up_process(cio->waiter);
+	spin_unlock_irqrestore(&cio->lock, flags);
+}
+
+/*
+ * blk_copy_offload	- Use device's native copy offload feature
+ * Go through user provide payload, prepare new payload based on device's copy offload limits.
+ */
+int blk_copy_offload(struct block_device *src_bdev, int nr_srcs,
+		struct range_entry *rlist, struct block_device *dst_bdev, gfp_t gfp_mask)
+{
+	struct request_queue *sq = bdev_get_queue(src_bdev);
+	struct request_queue *dq = bdev_get_queue(dst_bdev);
+	struct bio *read_bio, *write_bio;
+	struct copy_ctx *ctx;
+	struct cio *cio;
+	struct page *token;
+	sector_t src_blk, copy_len, dst_blk;
+	sector_t remaining, max_copy_len = LONG_MAX;
+	unsigned long flags;
+	int ri = 0, ret = 0;
+
+	cio = kzalloc(sizeof(struct cio), GFP_KERNEL);
+	if (!cio)
+		return -ENOMEM;
+	cio->rlist = rlist;
+	spin_lock_init(&cio->lock);
+
+	max_copy_len = min_t(sector_t, sq->limits.max_copy_sectors, dq->limits.max_copy_sectors);
+	max_copy_len = min3(max_copy_len, (sector_t)sq->limits.max_copy_range_sectors,
+			(sector_t)dq->limits.max_copy_range_sectors) << SECTOR_SHIFT;
+
+	for (ri = 0; ri < nr_srcs; ri++) {
+		cio->rlist[ri].comp_len = rlist[ri].len;
+		src_blk = rlist[ri].src;
+		dst_blk = rlist[ri].dst;
+		for (remaining = rlist[ri].len; remaining > 0; remaining -= copy_len) {
+			copy_len = min(remaining, max_copy_len);
+
+			token = alloc_page(gfp_mask);
+			if (unlikely(!token)) {
+				ret = -ENOMEM;
+				goto err_token;
+			}
+
+			ctx = kzalloc(sizeof(struct copy_ctx), gfp_mask);
+			if (!ctx) {
+				ret = -ENOMEM;
+				goto err_ctx;
+			}
+			ctx->cio = cio;
+			ctx->range_idx = ri;
+			ctx->start_sec = rlist[ri].src;
+
+			read_bio = bio_alloc(src_bdev, 1, REQ_OP_READ | REQ_COPY | REQ_NOMERGE,
+					gfp_mask);
+			if (!read_bio) {
+				ret = -ENOMEM;
+				goto err_read_bio;
+			}
+			read_bio->bi_iter.bi_sector = src_blk >> SECTOR_SHIFT;
+			read_bio->bi_iter.bi_size = copy_len;
+			__bio_add_page(read_bio, token, PAGE_SIZE, 0);
+			ret = submit_bio_wait(read_bio);
+			bio_put(read_bio);
+			if (ret)
+				goto err_read_bio;
+
+			write_bio = bio_alloc(dst_bdev, 1, REQ_OP_WRITE | REQ_COPY | REQ_NOMERGE,
+					gfp_mask);
+			if (!write_bio) {
+				ret = -ENOMEM;
+				goto err_read_bio;
+			}
+			write_bio->bi_iter.bi_sector = dst_blk >> SECTOR_SHIFT;
+			write_bio->bi_iter.bi_size = copy_len;
+			__bio_add_page(write_bio, token, PAGE_SIZE, 0);
+			write_bio->bi_end_io = bio_copy_end_io;
+			write_bio->bi_private = ctx;
+
+			spin_lock_irqsave(&cio->lock, flags);
+			++cio->refcount;
+			spin_unlock_irqrestore(&cio->lock, flags);
+
+			submit_bio(write_bio);
+			src_blk += copy_len;
+			dst_blk += copy_len;
+		}
+	}
+
+	/* Wait for completion of all IO's*/
+	return cio_await_completion(cio);
+
+err_read_bio:
+	kfree(ctx);
+err_ctx:
+	__free_page(token);
+err_token:
+	rlist[ri].comp_len = min_t(sector_t, rlist[ri].comp_len, (rlist[ri].len - remaining));
+
+	cio->io_err = ret;
+	return cio_await_completion(cio);
+}
+
+static inline int blk_copy_sanity_check(struct block_device *src_bdev,
+		struct block_device *dst_bdev, struct range_entry *rlist, int nr)
+{
+	unsigned int align_mask = max(
+			bdev_logical_block_size(dst_bdev), bdev_logical_block_size(src_bdev)) - 1;
+	sector_t len = 0;
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		if (rlist[i].len)
+			len += rlist[i].len;
+		else
+			return -EINVAL;
+		if ((rlist[i].dst & align_mask) || (rlist[i].src & align_mask) ||
+				(rlist[i].len & align_mask))
+			return -EINVAL;
+		rlist[i].comp_len = 0;
+	}
+
+	if (len && len >= MAX_COPY_TOTAL_LENGTH)
+		return -EINVAL;
+
+	return 0;
+}
+
+static inline bool blk_check_copy_offload(struct request_queue *src_q,
+		struct request_queue *dest_q)
+{
+	if (blk_queue_copy(dest_q) && blk_queue_copy(src_q))
+		return true;
+
+	return false;
+}
+
+/*
+ * blkdev_issue_copy - queue a copy
+ * @src_bdev:	source block device
+ * @nr_srcs:	number of source ranges to copy
+ * @rlist:	array of source/dest/len
+ * @dest_bdev:	destination block device
+ * @gfp_mask:   memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *	Copy source ranges from source block device to destination block device.
+ *	length of a source range cannot be zero.
+ */
+int blkdev_issue_copy(struct block_device *src_bdev, int nr,
+		struct range_entry *rlist, struct block_device *dest_bdev, gfp_t gfp_mask)
+{
+	struct request_queue *src_q = bdev_get_queue(src_bdev);
+	struct request_queue *dest_q = bdev_get_queue(dest_bdev);
+	int ret = -EINVAL;
+
+	if (!src_q || !dest_q)
+		return -ENXIO;
+
+	if (!nr)
+		return -EINVAL;
+
+	if (nr >= MAX_COPY_NR_RANGE)
+		return -EINVAL;
+
+	if (bdev_read_only(dest_bdev))
+		return -EPERM;
+
+	ret = blk_copy_sanity_check(src_bdev, dest_bdev, rlist, nr);
+	if (ret)
+		return ret;
+
+	if (blk_check_copy_offload(src_q, dest_q))
+		ret = blk_copy_offload(src_bdev, nr, rlist, dest_bdev, gfp_mask);
+
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_copy);
+
 /**
  * __blkdev_issue_write_same - generate number of bios with same page
  * @bdev:	target blockdev
diff --git a/block/blk.h b/block/blk.h
index abb663a2a147..94d2b055750b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -292,6 +292,8 @@ static inline bool blk_may_split(struct request_queue *q, struct bio *bio)
 		break;
 	}
 
+	if (unlikely(op_is_copy(bio->bi_opf)))
+		return false;
 	/*
 	 * All drivers must accept single-segments bios that are <= PAGE_SIZE.
 	 * This is a quick and dirty check that relies on the fact that
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 5561e58d158a..e5c967c9f174 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -418,6 +418,7 @@ enum req_flag_bits {
 	/* for driver use */
 	__REQ_DRV,
 	__REQ_SWAP,		/* swapping request. */
+	__REQ_COPY,		/* copy request*/
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -442,6 +443,7 @@ enum req_flag_bits {
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
 #define REQ_SWAP		(1ULL << __REQ_SWAP)
+#define REQ_COPY		(1ULL << __REQ_COPY)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
@@ -498,6 +500,11 @@ static inline bool op_is_discard(unsigned int op)
 	return (op & REQ_OP_MASK) == REQ_OP_DISCARD;
 }
 
+static inline bool op_is_copy(unsigned int op)
+{
+	return (op & REQ_COPY);
+}
+
 /*
  * Check if a bio or request operation is a zone management operation, with
  * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a special case
@@ -532,4 +539,18 @@ struct blk_rq_stat {
 	u64 batch;
 };
 
+struct cio {
+	struct range_entry *rlist;
+	struct task_struct *waiter;     /* waiting task (NULL if none) */
+	spinlock_t lock;		/* protects refcount and waiter */
+	int refcount;
+	blk_status_t io_err;
+};
+
+struct copy_ctx {
+	int range_idx;
+	sector_t start_sec;
+	struct cio *cio;
+};
+
 #endif /* __LINUX_BLK_TYPES_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 792e6d556589..1c2f65f1f143 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1121,6 +1121,8 @@ extern int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		struct bio **biop);
 struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 		gfp_t gfp_mask);
+int blkdev_issue_copy(struct block_device *src_bdev, int nr_srcs,
+		struct range_entry *src_rlist, struct block_device *dest_bdev, gfp_t gfp_mask);
 
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index bdf7b404b3e7..55bca8f6e8ed 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -64,6 +64,20 @@ struct fstrim_range {
 	__u64 minlen;
 };
 
+/* Maximum no of entries supported */
+#define MAX_COPY_NR_RANGE	(1 << 12)
+
+/* maximum total copy length */
+#define MAX_COPY_TOTAL_LENGTH	(1 << 21)
+
+/* Source range entry for copy */
+struct range_entry {
+	__u64 src;
+	__u64 dst;
+	__u64 len;
+	__u64 comp_len;
+};
+
 /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
 #define FILE_DEDUPE_RANGE_SAME		0
 #define FILE_DEDUPE_RANGE_DIFFERS	1
-- 
2.30.0-rc0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

