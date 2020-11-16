Return-Path: <SRS0=UzxB=EW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C04C4742C
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:06:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1D59722384
	for <dm-devel@archiver.kernel.org>; Mon, 16 Nov 2020 15:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D59722384
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-ysHXoz9mMI-IXf7BqCLKlg-1; Mon, 16 Nov 2020 10:06:33 -0500
X-MC-Unique: ysHXoz9mMI-IXf7BqCLKlg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1909D6D24D;
	Mon, 16 Nov 2020 15:06:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8C2F6198C;
	Mon, 16 Nov 2020 15:06:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BC037183D024;
	Mon, 16 Nov 2020 15:06:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AGF6LLC018110 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Nov 2020 10:06:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 686C4110F726; Mon, 16 Nov 2020 15:06:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61637110F72A
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:06:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8774E185A790
	for <dm-devel@redhat.com>; Mon, 16 Nov 2020 15:06:16 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-239-COjculDSMbGQfWdC5uOgqw-1; Mon, 16 Nov 2020 10:06:12 -0500
X-MC-Unique: COjculDSMbGQfWdC5uOgqw-1
Received: from [2001:4bb8:180:6600:255b:7def:a93:4a09] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kefyD-0003xZ-0p; Mon, 16 Nov 2020 14:59:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Mon, 16 Nov 2020 15:57:30 +0100
Message-Id: <20201116145809.410558-40-hch@lst.de>
In-Reply-To: <20201116145809.410558-1-hch@lst.de>
References: <20201116145809.410558-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [dm-devel] [PATCH 39/78] block: add an optional probe callback to
	major_names
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a callback to the major_names array that allows a driver to override
how to probe for dev_t that doesn't currently have a gendisk registered.
This will help separating the lookup of the gendisk by dev_t vs probe
action for a not currently registered dev_t.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/genhd.c         | 21 ++++++++++++++++++---
 include/linux/genhd.h |  5 ++++-
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 8391e7d83a6920..dc8690bc281c16 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -399,6 +399,7 @@ static struct blk_major_name {
 	struct blk_major_name *next;
 	int major;
 	char name[16];
+	void (*probe)(dev_t devt);
 } *major_names[BLKDEV_MAJOR_HASH_SIZE];
 static DEFINE_MUTEX(major_names_lock);
 
@@ -441,7 +442,8 @@ void blkdev_show(struct seq_file *seqf, off_t offset)
  * See Documentation/admin-guide/devices.txt for the list of allocated
  * major numbers.
  */
-int register_blkdev(unsigned int major, const char *name)
+int __register_blkdev(unsigned int major, const char *name,
+		void (*probe)(dev_t devt))
 {
 	struct blk_major_name **n, *p;
 	int index, ret = 0;
@@ -480,6 +482,7 @@ int register_blkdev(unsigned int major, const char *name)
 	}
 
 	p->major = major;
+	p->probe = probe;
 	strlcpy(p->name, name, sizeof(p->name));
 	p->next = NULL;
 	index = major_to_index(major);
@@ -502,8 +505,7 @@ int register_blkdev(unsigned int major, const char *name)
 	mutex_unlock(&major_names_lock);
 	return ret;
 }
-
-EXPORT_SYMBOL(register_blkdev);
+EXPORT_SYMBOL(__register_blkdev);
 
 void unregister_blkdev(unsigned int major, const char *name)
 {
@@ -1030,6 +1032,19 @@ static ssize_t disk_badblocks_store(struct device *dev,
 
 static void request_gendisk_module(dev_t devt)
 {
+	unsigned int major = MAJOR(devt);
+	struct blk_major_name **n;
+
+	mutex_lock(&major_names_lock);
+	for (n = &major_names[major_to_index(major)]; *n; n = &(*n)->next) {
+		if ((*n)->major == major && (*n)->probe) {
+			(*n)->probe(devt);
+			mutex_unlock(&major_names_lock);
+			return;
+		}
+	}
+	mutex_unlock(&major_names_lock);
+
 	if (request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt)) > 0)
 		/* Make old-style 2.4 aliases work */
 		request_module("block-major-%d", MAJOR(devt));
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 8427ad8bef520d..04f6a6bf577a90 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -366,7 +366,10 @@ extern void blk_unregister_region(dev_t devt, unsigned long range);
 
 #define alloc_disk(minors) alloc_disk_node(minors, NUMA_NO_NODE)
 
-int register_blkdev(unsigned int major, const char *name);
+int __register_blkdev(unsigned int major, const char *name,
+		void (*probe)(dev_t devt));
+#define register_blkdev(major, name) \
+	__register_blkdev(major, name, NULL)
 void unregister_blkdev(unsigned int major, const char *name);
 
 void revalidate_disk_size(struct gendisk *disk, bool verbose);
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

