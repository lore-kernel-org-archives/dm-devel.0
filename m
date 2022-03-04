Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34B3AC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Mar 2022 19:36:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-55-9Ibo-yBMOUuxYxLjLO1mjg-1; Fri, 04 Mar 2022 14:36:31 -0500
X-MC-Unique: 9Ibo-yBMOUuxYxLjLO1mjg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ECEB824FA7;
	Fri,  4 Mar 2022 19:36:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C5FEC1078650;
	Fri,  4 Mar 2022 19:36:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8531E1809C98;
	Fri,  4 Mar 2022 19:36:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 224JaLir003580 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 14:36:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C75E92166BDD; Fri,  4 Mar 2022 19:36:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C11662166BCC
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 19:36:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 659B482A682
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 19:36:15 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-79-VeG-7KQzOAeJU6pR95r1EA-1; Fri, 04 Mar 2022 14:36:13 -0500
X-MC-Unique: VeG-7KQzOAeJU6pR95r1EA-1
Received: from [2001:4bb8:180:5296:cded:8d4b:ace6:f3c] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nQCEq-00BUjX-Jo; Fri, 04 Mar 2022 18:01:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Fri,  4 Mar 2022 19:00:57 +0100
Message-Id: <20220304180105.409765-3-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-ext4@vger.kernel.org
Subject: [dm-devel] [PATCH 02/10] block: remove handle_bad_sector
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

Use the %pg format specifier instead of the stack hungry bdevname
function, and remove handle_bad_sector given that it is not pointless.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 34e1b7fdb7c89..4d858fc08f8ba 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -540,17 +540,6 @@ bool blk_get_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_get_queue);
 
-static void handle_bad_sector(struct bio *bio, sector_t maxsector)
-{
-	char b[BDEVNAME_SIZE];
-
-	pr_info_ratelimited("%s: attempt to access beyond end of device\n"
-			    "%s: rw=%d, want=%llu, limit=%llu\n",
-			    current->comm,
-			    bio_devname(bio, b), bio->bi_opf,
-			    bio_end_sector(bio), maxsector);
-}
-
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 
 static DECLARE_FAULT_ATTR(fail_make_request);
@@ -612,7 +601,11 @@ static inline int bio_check_eod(struct bio *bio)
 	if (nr_sectors && maxsector &&
 	    (nr_sectors > maxsector ||
 	     bio->bi_iter.bi_sector > maxsector - nr_sectors)) {
-		handle_bad_sector(bio, maxsector);
+		pr_info_ratelimited("%s: attempt to access beyond end of device\n"
+				    "%pg: rw=%d, want=%llu, limit=%llu\n",
+				    current->comm,
+				    bio->bi_bdev, bio->bi_opf,
+				    bio_end_sector(bio), maxsector);
 		return -EIO;
 	}
 	return 0;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

