Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98CE8C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:00:23 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-hJOyrASHM5GKkLIQGuqm4Q-1; Thu, 27 Jan 2022 02:00:19 -0500
X-MC-Unique: hJOyrASHM5GKkLIQGuqm4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EC5D2F25;
	Thu, 27 Jan 2022 07:00:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CEDC5E48B;
	Thu, 27 Jan 2022 07:00:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 33A811809CB8;
	Thu, 27 Jan 2022 07:00:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20R70DVp002070 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 02:00:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EDA8540F9D6E; Thu, 27 Jan 2022 07:00:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E979A40F9D68
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:00:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF7E785A5A8
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:00:12 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-77-kK_njfj7PwaED9fHrI4vaA-1; Thu, 27 Jan 2022 02:00:09 -0500
X-MC-Unique: kK_njfj7PwaED9fHrI4vaA-1
Received: from 213-225-10-69.nat.highway.a1.net ([213.225.10.69]
	helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nCyO5-00EY66-Bj; Thu, 27 Jan 2022 06:36:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 27 Jan 2022 07:35:36 +0100
Message-Id: <20220127063546.1314111-5-hch@lst.de>
In-Reply-To: <20220127063546.1314111-1-hch@lst.de>
References: <20220127063546.1314111-1-hch@lst.de>
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
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 04/14] dm: fold __send_duplicate_bios into
	__clone_and_map_simple_bio
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

Fold __send_duplicate_bios into its only caller to prepare for
refactoring.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e1356a4ce0393..b3b60918206b5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1273,29 +1273,24 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 	}
 }
 
-static void __clone_and_map_simple_bio(struct clone_info *ci,
-					   struct dm_target_io *tio, unsigned *len)
-{
-	struct bio *clone = &tio->clone;
-
-	tio->len_ptr = len;
-
-	__bio_clone_fast(clone, ci->bio);
-	if (len)
-		bio_setup_sector(clone, ci->sector, *len);
-	__map_bio(tio);
-}
-
 static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 				  unsigned num_bios, unsigned *len)
 {
 	struct bio_list blist = BIO_EMPTY_LIST;
-	struct bio *bio;
+	struct bio *clone;
 
 	alloc_multiple_bios(&blist, ci, ti, num_bios);
 
-	while ((bio = bio_list_pop(&blist)))
-		__clone_and_map_simple_bio(ci, clone_to_tio(bio), len);
+	while ((clone = bio_list_pop(&blist))) {
+		struct dm_target_io *tio = clone_to_tio(clone);
+
+		tio->len_ptr = len;
+
+		__bio_clone_fast(clone, ci->bio);
+		if (len)
+			bio_setup_sector(clone, ci->sector, *len);
+		__map_bio(tio);
+	}
 }
 
 static int __send_empty_flush(struct clone_info *ci)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

