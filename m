Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D17C64E7D
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:29:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4B82E206F9
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:29:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B82E206F9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-nhTEnFIQPMGWg-EEjSP4XA-1; Tue, 24 Nov 2020 08:29:27 -0500
X-MC-Unique: nhTEnFIQPMGWg-EEjSP4XA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11C88192202D;
	Tue, 24 Nov 2020 13:29:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC9075D9CA;
	Tue, 24 Nov 2020 13:29:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 98E825002C;
	Tue, 24 Nov 2020 13:29:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AODTE1m018178 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 08:29:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C109A80566; Tue, 24 Nov 2020 13:29:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BB5AE82877
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:29:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A1EA108C09C
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:29:11 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-59--I0pwP9RO3ms-Dwqmqr4qg-1; Tue, 24 Nov 2020 08:29:09 -0500
X-MC-Unique: -I0pwP9RO3ms-Dwqmqr4qg-1
Received: from [2001:4bb8:180:5443:c70:4a89:bc61:3] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1khYNJ-0006ft-Oa; Tue, 24 Nov 2020 13:28:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 24 Nov 2020 14:27:41 +0100
Message-Id: <20201124132751.3747337-36-hch@lst.de>
In-Reply-To: <20201124132751.3747337-1-hch@lst.de>
References: <20201124132751.3747337-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-mm@kvack.org
Subject: [dm-devel] [PATCH 35/45] block: move make_it_fail to struct
	block_device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move the make_it_fail flag to struct block_device an turn it into a bool
in preparation of killing struct hd_struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c          | 3 ++-
 block/genhd.c             | 4 ++--
 include/linux/blk_types.h | 3 +++
 include/linux/genhd.h     | 3 ---
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9a3793d5ce38d4..9121390be97a76 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -668,7 +668,8 @@ __setup("fail_make_request=", setup_fail_make_request);
 
 static bool should_fail_request(struct hd_struct *part, unsigned int bytes)
 {
-	return part->make_it_fail && should_fail(&fail_make_request, bytes);
+	return part->bdev->bd_make_it_fail &&
+		should_fail(&fail_make_request, bytes);
 }
 
 static int __init fail_make_request_debugfs(void)
diff --git a/block/genhd.c b/block/genhd.c
index a991f0122e53d8..8c734a4e8ff31c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1276,7 +1276,7 @@ ssize_t part_fail_show(struct device *dev,
 {
 	struct hd_struct *p = dev_to_part(dev);
 
-	return sprintf(buf, "%d\n", p->make_it_fail);
+	return sprintf(buf, "%d\n", p->bdev->bd_make_it_fail);
 }
 
 ssize_t part_fail_store(struct device *dev,
@@ -1287,7 +1287,7 @@ ssize_t part_fail_store(struct device *dev,
 	int i;
 
 	if (count > 0 && sscanf(buf, "%d", &i) > 0)
-		p->make_it_fail = (i == 0) ? 0 : 1;
+		p->pdev->bd_make_it_fail = (i == 0) ? 0 : 1;
 
 	return count;
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index c0591e52d7d7ce..b237f1e4081405 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -52,6 +52,9 @@ struct block_device {
 	struct super_block	*bd_fsfreeze_sb;
 
 	struct partition_meta_info *bd_meta_info;
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+	bool			bd_make_it_fail;
+#endif
 } __randomize_layout;
 
 #define bdev_whole(_bdev) \
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index c2a8cf12c5cab5..5d46ea7be7e4f0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -56,9 +56,6 @@ struct hd_struct {
 	struct block_device *bdev;
 	struct device __dev;
 	int policy, partno;
-#ifdef CONFIG_FAIL_MAKE_REQUEST
-	int make_it_fail;
-#endif
 	struct rcu_work rcu_work;
 };
 
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

