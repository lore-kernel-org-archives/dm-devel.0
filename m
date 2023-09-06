Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12B1FEE14C1
	for <dm-devel@archiver.kernel.org>; Wed,  6 Sep 2023 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694022872;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B3SqGrqaL9B1rE7U59Cgf7cRqB1hhF7WrvV8rboD+rU=;
	b=iaLKr0jpECpZzUwSLbdY2r6fluM4bnbXo2FR2RGz5nmDx1jF3yw/OP8OFNpAfSCnOYQnCb
	fEm83W+/7dNfs+astYw8fFaki4OVy818kW/+WMHZxxscn6UdTzjffWlExt7xU6msjXArsI
	qO0CnNesXzL0pksDeNnBcr95eZO0bDs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-RN2-yjc-OqeF2PetsEy_PQ-1; Wed, 06 Sep 2023 13:54:29 -0400
X-MC-Unique: RN2-yjc-OqeF2PetsEy_PQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 881A3105EEE2;
	Wed,  6 Sep 2023 17:54:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 70B242026D68;
	Wed,  6 Sep 2023 17:54:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 34ED3194658C;
	Wed,  6 Sep 2023 17:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D936B194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Sep 2023 17:54:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C5788D47819; Wed,  6 Sep 2023 17:54:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BE12FC03292
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DCA28279AA
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:25 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-Ijy_zKYpOzWTAO2DQSrF3g-1; Wed, 06 Sep 2023 13:54:23 -0400
X-MC-Unique: Ijy_zKYpOzWTAO2DQSrF3g-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230906175419epoutp0175a7fa67f6a16a8bb9e5d1cac2ee0e62~CYNCwu-Wk0734607346epoutp01h
 for <dm-devel@redhat.com>; Wed,  6 Sep 2023 17:54:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230906175419epoutp0175a7fa67f6a16a8bb9e5d1cac2ee0e62~CYNCwu-Wk0734607346epoutp01h
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230906175418epcas5p35e2257c8a9f7e1d013aeb4aca3d52906~CYNCIqfdP2681826818epcas5p3t;
 Wed,  6 Sep 2023 17:54:18 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4Rgqkc29Tfz4x9Pv; Wed,  6 Sep
 2023 17:54:16 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 5C.D4.09635.8CCB8F46; Thu,  7 Sep 2023 02:54:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230906164312epcas5p397662c68dde1dbc4dc14c3e80ca260b3~CXO8pz8V02340723407epcas5p3u;
 Wed,  6 Sep 2023 16:43:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230906164312epsmtrp209da0fc220eb8c775e923d6871810929~CXO8oufb_1133211332epsmtrp2M;
 Wed,  6 Sep 2023 16:43:12 +0000 (GMT)
X-AuditID: b6c32a4b-563fd700000025a3-ad-64f8bcc8e9a7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 F5.0B.08742.F1CA8F46; Thu,  7 Sep 2023 01:43:11 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230906164309epsmtip25245d3e436d4490fd8cb3b6fd875a2be~CXO56pnY41829618296epsmtip2X;
 Wed,  6 Sep 2023 16:43:09 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed,  6 Sep 2023 22:08:28 +0530
Message-Id: <20230906163844.18754-4-nj.shetty@samsung.com>
In-Reply-To: <20230906163844.18754-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te1BUVRzu3Hu53GXc5rLA7BFT8FoWb9aF9YLycHSY60hKQ5MTU+LG3mGJ
 ZXdnH2BZtoAEkrI8smR98JZXAi6mBC4ZRMAWwxDjEgyJQ2AogTwmwDGlXRbK/77v+53v9zrn
 ECjvb9ydSJJrWJVcLKNwJ+xmp9frfj23VySBObUcutH8E0pn5D9D6frf9Tg93bkA6Ik72YA2
 zV50oIfvfIfQtfVdCF3YYQH05F0DQptGfOiyzysx+rapF6MHWy/hdMnVSUe6uvs5Qv+WPwno
 m09LULph+jFG94xsofufdTtEujH9965jzGCfljHWncGZ5srPmLZhHc5U5BU5MOcyZ3FmfnIE
 Yx6338WZvBt1gFk0bmOMEzNIzKa45L1SVixhVZ6sPEEhSZInhlGHYuP3xweLAgV+ghB6N+Up
 F6ewYdSB6Bi/qCSZdVbKM1Us01qlGLFaTQWE71UptBrWU6pQa8IoVimRKYOU/mpxilorT/SX
 s5pQQWDgrmDrwePJUt0/K7gyI/LE4NkcTAeeCHMBh4BkEJzvmURygRPBI9sALE5fWicLAOor
 RlE7WQLw+WgfsmEpKrrgaA+YACx6WLNOshBYW55pJQSBkz7w51XCpruSOhQ2tVUAG0HJBgQW
 V/6K2lK5kKHwSn4XZsMY+RocHNXhNsy16unmQdSWCJIBUD/mbJM55B6YkT4A7EecYW/xxJoV
 JT1g5rcX11qFZDYH6m5VA7v3AJwa4Nu7doGPum842rE7XJw14XacBmu/rMHt3tMAGoYMwB6I
 gFlm/VoPKOkFG1sD7PJWeN7cgNjrvgzPPZ1Y3woXtlzZwDvgN42l6/k3Q8ty+jpm4MTytbUe
 eGQegOVlx/KBp+GFcQwvjGP4v3IpQOvAZlapTklk1cFKoZxN+++WExQpRrD2/r0PtYDx+3P+
 HQAhQAeABEq5cmc9liQ8rkT80cesShGv0spYdQcItq67AHV3S1BYP5BcEy8ICgkMEolEQSFC
 kYDic6ezLkt4ZKJYwyazrJJVbfgQguOuQ/4c+tQ3InzscJzHnsxOh+FNp8x9TaX7oD4i9et3
 vvcdYE92jN3K/uCHt+tFA6WxpoMPhGddi3lCVWjase3j5BdR/LbtzSeCQ+ZruEts1YO5yDdM
 zv01hUd63/Id/zAup3pVREYLvzr8o2Pu+1uimy1/vOqN+LU3JBEJw8uhwrAnxjMLu2XvIk7b
 pnZSluMc3r36azPv9XpZsCG3gqbF8vBPqq669swxgpJ9EbEtfDf94szJiiNvmrtXLrS3Ppqy
 SM+bm10cD95fMpXHSfmqXwpXnHY077ouW/jrVNUI3nd0/HRBX1ZsnmFaFGVcjWQut/K7tK9w
 I5Whqe5bjya8VFnl87CMwtRSscAbVanF/wKBF6htiAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWy7bCSvK78mh8pBjs7bSzWnzrGbNE04S+z
 xeq7/WwWrw9/YrR4cqCd0WLvu9msFjcP7GSyWLn6KJPFpEPXGC2eXp3FZLH3lrbFwrYlLBZ7
 9p5ksbi8aw6bxfxlT9ktlh//x2RxY8JTRottv+czW6x7/Z7F4sQtaYvzf4+zOoh6nL+3kcXj
 8tlSj02rOtk8Ni+p99h9s4HNY3HfZFaP3uZ3bB4fn95i8Xi/7yqbR9+WVYwenzfJeWx68pYp
 gCeKyyYlNSezLLVI3y6BK6Phzw+2giaHiss9HSwNjD+Nuxg5OSQETCQmT57B3sXIxSEksJtR
 4sqNncwQCUmJZX+PQNnCEiv/PYcqamaSWHzhEFMXIwcHm4C2xOn/HCBxEYEuZonOne9YQBxm
 gR1MEs//t7GDdAsLWEnMm3CUBcRmEVCVuHyngQ3E5gWKN566zAwySEJAX6L/viBImFPAWqKp
 8SIjiC0EVHJn1WtGiHJBiZMzn4CNYRaQl2jeOpt5AqPALCSpWUhSCxiZVjFKphYU56bnFhsW
 GOallusVJ+YWl+al6yXn525iBEeoluYOxu2rPugdYmTiYDzEKMHBrCTC+07+W4oQb0piZVVq
 UX58UWlOavEhRmkOFiVxXvEXvSlCAumJJanZqakFqUUwWSYOTqkGpnUfAqz1ZYqcNsRd7DW5
 uTdTe+vhTxOd93nYpuXc+Xp/2nK+oymhz2rZnS7Oeqtt4P89fp5Hk/3CLXpmR75t8zuk6M5h
 wPH0Au+KTqeZ4sFn5B5Yn+fMnXONa1uHdsinmT+2pfTU7VlqJPujvvzjdNOARac0I2/9ffJD
 fO/lyBWzLHe1dP6Jk4lteNHGz7y2Y339hgjeAutXvG2re58v2/Fhdlvn2kVHq0JnXhIK5w+6
 97Vhz7Q5gtv3Rc3bJuuld+N7/yrZ1fJS0RwJ/r+Y7986Yit3el260a7D8+zLjRs/14bMmfFn
 Zav12be7XXzXKV5mzt9Wfzp8h2U9W+0alWXW6hudvbyfCVVJFOhmP1FiKc5INNRiLipOBABx
 kMRwPwMAAA==
X-CMS-MailID: 20230906164312epcas5p397662c68dde1dbc4dc14c3e80ca260b3
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230906164312epcas5p397662c68dde1dbc4dc14c3e80ca260b3
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164312epcas5p397662c68dde1dbc4dc14c3e80ca260b3@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v15 03/12] block: add copy offload support
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
Cc: martin.petersen@oracle.com, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org, Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce blkdev_copy_offload to perform copy offload.
Issue REQ_OP_COPY_SRC with source info along with taking a plug.
This flows till request layer and waits for dst bio to arrive.
Issue REQ_OP_COPY_DST with destination info and this bio reaches request
layer and merges with src request.
For any reason, if a request comes to the driver with only one of src/dst
bio, we fail the copy offload.

Larger copy will be divided, based on max_copy_sectors limit.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 block/blk-lib.c        | 202 +++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |   4 +
 2 files changed, 206 insertions(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e59c3069e835..d22e1e7417ca 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -10,6 +10,22 @@
 
 #include "blk.h"
 
+/* Keeps track of all outstanding copy IO */
+struct blkdev_copy_io {
+	atomic_t refcount;
+	ssize_t copied;
+	int status;
+	struct task_struct *waiter;
+	void (*endio)(void *private, int status, ssize_t copied);
+	void *private;
+};
+
+/* Keeps track of single outstanding copy offload IO */
+struct blkdev_copy_offload_io {
+	struct blkdev_copy_io *cio;
+	loff_t offset;
+};
+
 static sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
 {
 	unsigned int discard_granularity = bdev_discard_granularity(bdev);
@@ -115,6 +131,192 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
 
+static inline ssize_t blkdev_copy_sanity_check(struct block_device *bdev_in,
+					       loff_t pos_in,
+					       struct block_device *bdev_out,
+					       loff_t pos_out, size_t len)
+{
+	unsigned int align = max(bdev_logical_block_size(bdev_out),
+				 bdev_logical_block_size(bdev_in)) - 1;
+
+	if ((pos_in & align) || (pos_out & align) || (len & align) || !len ||
+	    len >= BLK_COPY_MAX_BYTES)
+		return -EINVAL;
+
+	return 0;
+}
+
+static inline void blkdev_copy_endio(struct blkdev_copy_io *cio)
+{
+	if (cio->endio) {
+		cio->endio(cio->private, cio->status, cio->copied);
+		kfree(cio);
+	} else {
+		struct task_struct *waiter = cio->waiter;
+
+		WRITE_ONCE(cio->waiter, NULL);
+		blk_wake_io_task(waiter);
+	}
+}
+
+/*
+ * This must only be called once all bios have been issued so that the refcount
+ * can only decrease. This just waits for all bios to complete.
+ * Returns the length of bytes copied or error
+ */
+static ssize_t blkdev_copy_wait_io_completion(struct blkdev_copy_io *cio)
+{
+	ssize_t ret;
+
+	for (;;) {
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!READ_ONCE(cio->waiter))
+			break;
+		blk_io_schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+	ret = cio->copied;
+	kfree(cio);
+
+	return ret;
+}
+
+static void blkdev_copy_offload_dst_endio(struct bio *bio)
+{
+	struct blkdev_copy_offload_io *offload_io = bio->bi_private;
+	struct blkdev_copy_io *cio = offload_io->cio;
+
+	if (bio->bi_status) {
+		cio->copied = min_t(ssize_t, offload_io->offset, cio->copied);
+		if (!cio->status)
+			cio->status = blk_status_to_errno(bio->bi_status);
+	}
+	bio_put(bio);
+
+	if (atomic_dec_and_test(&cio->refcount))
+		blkdev_copy_endio(cio);
+}
+
+/*
+ * @bdev:	block device
+ * @pos_in:	source offset
+ * @pos_out:	destination offset
+ * @len:	length in bytes to be copied
+ * @endio:	endio function to be called on completion of copy operation,
+ *		for synchronous operation this should be NULL
+ * @private:	endio function will be called with this private data,
+ *		for synchronous operation this should be NULL
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * For synchronous operation returns the length of bytes copied or error
+ * For asynchronous operation returns -EIOCBQUEUED or error
+ *
+ * Description:
+ *	Copy source offset to destination offset within block device, using
+ *	device's native copy offload feature. This function can fail, and
+ *	in that case the caller can fallback to emulation.
+ *	We perform copy operation using 2 bio's.
+ *	1. We take a plug and send a REQ_OP_COPY_SRC bio along with source
+ *	sector and length. Once this bio reaches request layer, we form a
+ *	request and wait for dst bio to arrive.
+ *	2. We issue REQ_OP_COPY_DST bio along with destination sector, length.
+ *	Once this bio reaches request layer and find a request with previously
+ *	sent source info we merge the destination bio and return.
+ *	3. Release the plug and request is sent to driver
+ *	This design works only for drivers with request queue.
+ */
+ssize_t blkdev_copy_offload(struct block_device *bdev, loff_t pos_in,
+			    loff_t pos_out, size_t len,
+			    void (*endio)(void *, int, ssize_t),
+			    void *private, gfp_t gfp)
+{
+	struct blkdev_copy_io *cio;
+	struct blkdev_copy_offload_io *offload_io;
+	struct bio *src_bio, *dst_bio;
+	ssize_t rem, chunk, ret;
+	ssize_t max_copy_bytes = bdev_max_copy_sectors(bdev) << SECTOR_SHIFT;
+	struct blk_plug plug;
+
+	if (!max_copy_bytes)
+		return -EINVAL;
+
+	ret = blkdev_copy_sanity_check(bdev, pos_in, bdev, pos_out, len);
+	if (ret)
+		return ret;
+
+	cio = kzalloc(sizeof(*cio), GFP_KERNEL);
+	if (!cio)
+		return -ENOMEM;
+	atomic_set(&cio->refcount, 1);
+	cio->waiter = current;
+	cio->endio = endio;
+	cio->private = private;
+
+	/*
+	 * If there is a error, copied will be set to least successfully
+	 * completed copied length
+	 */
+	cio->copied = len;
+	for (rem = len; rem > 0; rem -= chunk) {
+		chunk = min(rem, max_copy_bytes);
+
+		offload_io = kzalloc(sizeof(*offload_io), GFP_KERNEL);
+		if (!offload_io)
+			goto err_free_cio;
+		offload_io->cio = cio;
+		/*
+		 * For partial completion, we use offload_io->offset to truncate
+		 * successful copy length
+		 */
+		offload_io->offset = len - rem;
+
+		src_bio = bio_alloc(bdev, 0, REQ_OP_COPY_SRC, gfp);
+		if (!src_bio)
+			goto err_free_offload_io;
+		src_bio->bi_iter.bi_size = chunk;
+		src_bio->bi_iter.bi_sector = pos_in >> SECTOR_SHIFT;
+
+		blk_start_plug(&plug);
+		dst_bio = blk_next_bio(src_bio, bdev, 0, REQ_OP_COPY_DST, gfp);
+		if (!dst_bio)
+			goto err_free_src_bio;
+		dst_bio->bi_iter.bi_size = chunk;
+		dst_bio->bi_iter.bi_sector = pos_out >> SECTOR_SHIFT;
+		dst_bio->bi_end_io = blkdev_copy_offload_dst_endio;
+		dst_bio->bi_private = offload_io;
+
+		atomic_inc(&cio->refcount);
+		submit_bio(dst_bio);
+		blk_finish_plug(&plug);
+		pos_in += chunk;
+		pos_out += chunk;
+	}
+
+	if (atomic_dec_and_test(&cio->refcount))
+		blkdev_copy_endio(cio);
+	if (cio->endio)
+		return -EIOCBQUEUED;
+
+	return blkdev_copy_wait_io_completion(cio);
+
+err_free_src_bio:
+	bio_put(src_bio);
+err_free_offload_io:
+	kfree(offload_io);
+err_free_cio:
+	cio->copied = min_t(ssize_t, cio->copied, (len - rem));
+	cio->status = -ENOMEM;
+	if (rem == len) {
+		kfree(cio);
+		return cio->status;
+	}
+	if (cio->endio)
+		return cio->status;
+
+	return blkdev_copy_wait_io_completion(cio);
+}
+EXPORT_SYMBOL_GPL(blkdev_copy_offload);
+
 static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
 		struct bio **biop, unsigned flags)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7548f1685ee9..5405499bcf22 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1042,6 +1042,10 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp);
+ssize_t blkdev_copy_offload(struct block_device *bdev, loff_t pos_in,
+			    loff_t pos_out, size_t len,
+			    void (*endio)(void *, int, ssize_t),
+			    void *private, gfp_t gfp_mask);
 
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

