Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FA1C433B4
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:04:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4407F61057
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 06:04:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4407F61057
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-0IYBb7SvNYSegkAEbF9jJQ-1; Fri, 21 May 2021 02:04:34 -0400
X-MC-Unique: 0IYBb7SvNYSegkAEbF9jJQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E5278030A0;
	Fri, 21 May 2021 06:04:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4565B6C43A;
	Fri, 21 May 2021 06:04:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1529055357;
	Fri, 21 May 2021 06:04:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L64SXv028353 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 02:04:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6456D117DB13; Fri, 21 May 2021 06:04:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F682117DB17
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:04:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47D5A80D0E0
	for <dm-devel@redhat.com>; Fri, 21 May 2021 06:04:28 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-186-ZiH-zzcvNjaqF4qnPZSHpw-1; Fri, 21 May 2021 02:04:26 -0400
X-MC-Unique: ZiH-zzcvNjaqF4qnPZSHpw-1
Received: from [2001:4bb8:180:5add:4fd7:4137:d2f2:46e6] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1ljy4N-00Gpy6-5p; Fri, 21 May 2021 05:51:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>, Jim Paris <jim@jtan.com>,
	Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
Date: Fri, 21 May 2021 07:50:55 +0200
Message-Id: <20210521055116.1053587-6-hch@lst.de>
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
References: <20210521055116.1053587-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: [dm-devel] [PATCH 05/26] block: add blk_alloc_disk and
	blk_cleanup_disk APIs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add two new APIs to allocate and free a gendisk including the
request_queue for use with BIO based drivers.  This is to avoid
boilerplate code in drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c         | 35 +++++++++++++++++++++++++++++++++++
 include/linux/genhd.h | 22 ++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index e4974af3d729..6d4ce962866d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1302,6 +1302,25 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
 }
 EXPORT_SYMBOL(__alloc_disk_node);
 
+struct gendisk *__blk_alloc_disk(int node)
+{
+	struct request_queue *q;
+	struct gendisk *disk;
+
+	q = blk_alloc_queue(node);
+	if (!q)
+		return NULL;
+
+	disk = __alloc_disk_node(0, node);
+	if (!disk) {
+		blk_cleanup_queue(q);
+		return NULL;
+	}
+	disk->queue = q;
+	return disk;
+}
+EXPORT_SYMBOL(__blk_alloc_disk);
+
 /**
  * put_disk - decrements the gendisk refcount
  * @disk: the struct gendisk to decrement the refcount for
@@ -1319,6 +1338,22 @@ void put_disk(struct gendisk *disk)
 }
 EXPORT_SYMBOL(put_disk);
 
+/**
+ * blk_cleanup_disk - shutdown a gendisk allocated by blk_alloc_disk
+ * @disk: gendisk to shutdown
+ *
+ * Mark the queue hanging off @disk DYING, drain all pending requests, then mark
+ * the queue DEAD, destroy and put it and the gendisk structure.
+ *
+ * Context: can sleep
+ */
+void blk_cleanup_disk(struct gendisk *disk)
+{
+	blk_cleanup_queue(disk->queue);
+	put_disk(disk);
+}
+EXPORT_SYMBOL(blk_cleanup_disk);
+
 static void set_disk_ro_uevent(struct gendisk *gd, int ro)
 {
 	char event[] = "DISK_RO=1";
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index a5443f0b139d..03aa12730634 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -278,6 +278,28 @@ extern void put_disk(struct gendisk *disk);
 
 #define alloc_disk(minors) alloc_disk_node(minors, NUMA_NO_NODE)
 
+/**
+ * blk_alloc_disk - allocate a gendisk structure
+ * @node_id: numa node to allocate on
+ *
+ * Allocate and pre-initialize a gendisk structure for use with BIO based
+ * drivers.
+ *
+ * Context: can sleep
+ */
+#define blk_alloc_disk(node_id)						\
+({									\
+	struct gendisk *__disk = __blk_alloc_disk(node_id);		\
+	static struct lock_class_key __key;				\
+									\
+	if (__disk)							\
+		lockdep_init_map(&__disk->lockdep_map,			\
+			"(bio completion)", &__key, 0);			\
+	__disk;								\
+})
+struct gendisk *__blk_alloc_disk(int node);
+void blk_cleanup_disk(struct gendisk *disk);
+
 int __register_blkdev(unsigned int major, const char *name,
 		void (*probe)(dev_t devt));
 #define register_blkdev(major, name) \
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

