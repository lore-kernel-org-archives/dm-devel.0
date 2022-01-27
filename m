Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20ED1C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:09:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-jmEvdyAMO-imYqlQDT3g0A-1; Thu, 27 Jan 2022 02:08:59 -0500
X-MC-Unique: jmEvdyAMO-imYqlQDT3g0A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEF67612A0;
	Thu, 27 Jan 2022 07:08:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 562C910589B0;
	Thu, 27 Jan 2022 07:08:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DB2D24BB7C;
	Thu, 27 Jan 2022 07:08:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20R78plD002548 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 02:08:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 505E814582EE; Thu, 27 Jan 2022 07:08:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C6C914582E0
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:08:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33D4910B7223
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:08:51 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-664-_WiovG1NNWudbQ0QHCJ_ug-1; Thu, 27 Jan 2022 02:08:49 -0500
X-MC-Unique: _WiovG1NNWudbQ0QHCJ_ug-1
Received: from 213-225-10-69.nat.highway.a1.net ([213.225.10.69]
	helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nCyOB-00EY87-Sr; Thu, 27 Jan 2022 06:36:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 27 Jan 2022 07:35:38 +0100
Message-Id: <20220127063546.1314111-7-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 06/14] dm: pass the bio instead of tio to
	__map_bio
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This simplifies the callers a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f00c0582a2460..7cc477b2b77e9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1117,11 +1117,11 @@ static noinline void __set_swap_bios_limit(struct mapped_device *md, int latch)
 	mutex_unlock(&md->swap_bios_lock);
 }
 
-static void __map_bio(struct dm_target_io *tio)
+static void __map_bio(struct bio *clone)
 {
+	struct dm_target_io *tio = clone_to_tio(clone);
 	int r;
 	sector_t sector;
-	struct bio *clone = &tio->clone;
 	struct dm_io *io = tio->io;
 	struct dm_target *ti = tio->ti;
 
@@ -1227,7 +1227,7 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
 	if (bio_integrity(bio))
 		bio_integrity_trim(clone);
 
-	__map_bio(tio);
+	__map_bio(clone);
 	return 0;
 free_tio:
 	free_tio(tio);
@@ -1283,11 +1283,9 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 	alloc_multiple_bios(&blist, ci, ti, num_bios, len);
 
 	while ((clone = bio_list_pop(&blist))) {
-		struct dm_target_io *tio = clone_to_tio(clone);
-
 		if (len)
 			bio_setup_sector(clone, ci->sector, *len);
-		__map_bio(tio);
+		__map_bio(clone);
 	}
 }
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

