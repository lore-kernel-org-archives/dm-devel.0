Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B028BC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:24:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-NNUdcqGmMpKqJq6mX_HzyQ-1; Thu, 27 Jan 2022 02:24:04 -0500
X-MC-Unique: NNUdcqGmMpKqJq6mX_HzyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1869E1083F62;
	Thu, 27 Jan 2022 07:24:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC92D78DE0;
	Thu, 27 Jan 2022 07:23:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BC2D04CA93;
	Thu, 27 Jan 2022 07:23:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20R7NwE5004579 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 02:23:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E614C2166B3F; Thu, 27 Jan 2022 07:23:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE0E02166B18
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:23:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3293811E98
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:23:54 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-562-9eUCxMz2PQS3VS72DsvoPQ-1; Thu, 27 Jan 2022 02:23:51 -0500
X-MC-Unique: 9eUCxMz2PQS3VS72DsvoPQ-1
Received: from 213-225-10-69.nat.highway.a1.net ([213.225.10.69]
	helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nCyOI-00EYAI-C2; Thu, 27 Jan 2022 06:36:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 27 Jan 2022 07:35:40 +0100
Message-Id: <20220127063546.1314111-9-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 08/14] dm: simplify the single bio fast path in
	__send_duplicate_bios
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Most targets just need a single flush bio.  Open code that case in
__send_duplicate_bios without the need to add the bio to a list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 030270b770eb0..ee2d92ec7c9fc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1241,15 +1241,6 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 	struct bio *bio;
 	int try;
 
-	if (!num_bios)
-		return;
-
-	if (num_bios == 1) {
-		bio = alloc_tio(ci, ti, 0, len, GFP_NOIO);
-		bio_list_add(blist, bio);
-		return;
-	}
-
 	for (try = 0; try < 2; try++) {
 		int bio_nr;
 
@@ -1279,12 +1270,23 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 	struct bio_list blist = BIO_EMPTY_LIST;
 	struct bio *clone;
 
-	alloc_multiple_bios(&blist, ci, ti, num_bios, len);
-
-	while ((clone = bio_list_pop(&blist))) {
+	switch (num_bios) {
+	case 0:
+		break;
+	case 1:
+		clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
 		if (len)
 			bio_setup_sector(clone, ci->sector, *len);
 		__map_bio(clone);
+		break;
+	default:
+		alloc_multiple_bios(&blist, ci, ti, num_bios, len);
+		while ((clone = bio_list_pop(&blist))) {
+			if (len)
+				bio_setup_sector(clone, ci->sector, *len);
+			__map_bio(clone);
+		}
+		break;
 	}
 }
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

