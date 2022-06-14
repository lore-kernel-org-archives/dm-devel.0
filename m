Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 077E0C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 09:48:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-WAE_JPvSNT6ei-U2VsJalA-1; Tue, 14 Jun 2022 05:48:23 -0400
X-MC-Unique: WAE_JPvSNT6ei-U2VsJalA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07DF818E530D;
	Tue, 14 Jun 2022 09:48:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A071D1121314;
	Tue, 14 Jun 2022 09:48:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5298D194706D;
	Tue, 14 Jun 2022 09:48:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 43C8C1947067
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 09:48:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 128FAC50943; Tue, 14 Jun 2022 09:48:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EF18C50941
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:48:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB3F61C0513E
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:48:19 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-EXLKLHM2PQSCIw4sRSwk8Q-1; Tue, 14 Jun 2022 05:48:18 -0400
X-MC-Unique: EXLKLHM2PQSCIw4sRSwk8Q-1
Received: from [2001:4bb8:180:36f6:1fed:6d48:cf16:d13c] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o12YS-008Zea-QX; Tue, 14 Jun 2022 09:09:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 14 Jun 2022 11:09:30 +0200
Message-Id: <20220614090934.570632-3-hch@lst.de>
In-Reply-To: <20220614090934.570632-1-hch@lst.de>
References: <20220614090934.570632-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 2/6] dm: open code blk_max_size_offset in
 max_io_len
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

max_io_len always passes an explicitly non-zero chunk_sectors into
blk_max_size_offset.  That means much of blk_max_size_offset is not
needed and can be open coded to simplify the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d8f16183bf27c..0514358a1f8e5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1079,23 +1079,18 @@ static sector_t max_io_len(struct dm_target *ti, sector_t sector)
 {
 	sector_t target_offset = dm_target_offset(ti, sector);
 	sector_t len = max_io_len_target_boundary(ti, target_offset);
-	sector_t max_len;
 
 	/*
 	 * Does the target need to split IO even further?
 	 * - varied (per target) IO splitting is a tenet of DM; this
 	 *   explains why stacked chunk_sectors based splitting via
-	 *   blk_max_size_offset() isn't possible here. So pass in
-	 *   ti->max_io_len to override stacked chunk_sectors.
+	 *   blk_queue_split() isn't possible here.
 	 */
-	if (ti->max_io_len) {
-		max_len = blk_max_size_offset(ti->table->md->queue,
-					      target_offset, ti->max_io_len);
-		if (len > max_len)
-			len = max_len;
-	}
-
-	return len;
+	if (!ti->max_io_len)
+		return len;
+	return min_t(sector_t, len,
+		min(queue_max_sectors(ti->table->md->queue),
+		    blk_chunk_sectors_left(target_offset, ti->max_io_len)));
 }
 
 int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

