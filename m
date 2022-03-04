Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17BBDC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  4 Mar 2022 19:47:07 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-GfCZZHK2OKOOuxPOESi7eA-1; Fri, 04 Mar 2022 14:47:02 -0500
X-MC-Unique: GfCZZHK2OKOOuxPOESi7eA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66B40180A088;
	Fri,  4 Mar 2022 19:46:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D13E3058D;
	Fri,  4 Mar 2022 19:46:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 89A9F1809C98;
	Fri,  4 Mar 2022 19:46:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 224Jkt9R004169 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 14:46:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D7B224010FC7; Fri,  4 Mar 2022 19:46:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D386340CFD1B
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 19:46:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC0D0866DFF
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 19:46:55 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-118-xIAXM-WCPGCPnm9l1cunug-1; Fri, 04 Mar 2022 14:46:53 -0500
X-MC-Unique: xIAXM-WCPGCPnm9l1cunug-1
Received: from [2001:4bb8:180:5296:cded:8d4b:ace6:f3c] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nQCF7-00BUwa-6Z; Fri, 04 Mar 2022 18:01:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Fri,  4 Mar 2022 19:01:03 +0100
Message-Id: <20220304180105.409765-9-hch@lst.de>
In-Reply-To: <20220304180105.409765-1-hch@lst.de>
References: <20220304180105.409765-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-ext4@vger.kernel.org
Subject: [dm-devel] [PATCH 08/10] raid5-ppl: stop using bio_devname
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the %pg format specifier to save on stack consuption and code size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5-ppl.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 93d9364a930e3..845db0ba7c17f 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -416,12 +416,10 @@ static void ppl_log_endio(struct bio *bio)
 
 static void ppl_submit_iounit_bio(struct ppl_io_unit *io, struct bio *bio)
 {
-	char b[BDEVNAME_SIZE];
-
-	pr_debug("%s: seq: %llu size: %u sector: %llu dev: %s\n",
+	pr_debug("%s: seq: %llu size: %u sector: %llu dev: %pg\n",
 		 __func__, io->seq, bio->bi_iter.bi_size,
 		 (unsigned long long)bio->bi_iter.bi_sector,
-		 bio_devname(bio, b));
+		 bio->bi_bdev);
 
 	submit_bio(bio);
 }
@@ -589,9 +587,8 @@ static void ppl_flush_endio(struct bio *bio)
 	struct ppl_log *log = io->log;
 	struct ppl_conf *ppl_conf = log->ppl_conf;
 	struct r5conf *conf = ppl_conf->mddev->private;
-	char b[BDEVNAME_SIZE];
 
-	pr_debug("%s: dev: %s\n", __func__, bio_devname(bio, b));
+	pr_debug("%s: dev: %pg\n", __func__, bio->bi_bdev);
 
 	if (bio->bi_status) {
 		struct md_rdev *rdev;
@@ -634,7 +631,6 @@ static void ppl_do_flush(struct ppl_io_unit *io)
 
 		if (bdev) {
 			struct bio *bio;
-			char b[BDEVNAME_SIZE];
 
 			bio = bio_alloc_bioset(bdev, 0, GFP_NOIO,
 					       REQ_OP_WRITE | REQ_PREFLUSH,
@@ -642,8 +638,7 @@ static void ppl_do_flush(struct ppl_io_unit *io)
 			bio->bi_private = io;
 			bio->bi_end_io = ppl_flush_endio;
 
-			pr_debug("%s: dev: %s\n", __func__,
-				 bio_devname(bio, b));
+			pr_debug("%s: dev: %ps\n", __func__, bio->bi_bdev);
 
 			submit_bio(bio);
 			flushed_disks++;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

