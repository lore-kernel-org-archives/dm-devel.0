Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFA1AC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  4 Mar 2022 18:25:17 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-z1AK9HvOMny1xs-6qkfkjw-1; Fri, 04 Mar 2022 13:25:13 -0500
X-MC-Unique: z1AK9HvOMny1xs-6qkfkjw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D6B0520E;
	Fri,  4 Mar 2022 18:25:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4243B80685;
	Fri,  4 Mar 2022 18:25:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D1C821809C98;
	Fri,  4 Mar 2022 18:25:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 224IOx3N029452 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 13:25:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 46F74202660C; Fri,  4 Mar 2022 18:24:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42097200B67A
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 18:24:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C4803822209
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 18:24:56 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-434-uissfY5XNNSfEoFUQ5B-6Q-1; Fri, 04 Mar 2022 13:24:54 -0500
X-MC-Unique: uissfY5XNNSfEoFUQ5B-6Q-1
Received: from [2001:4bb8:180:5296:cded:8d4b:ace6:f3c] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nQCEw-00BUnE-81; Fri, 04 Mar 2022 18:01:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Fri,  4 Mar 2022 19:00:59 +0100
Message-Id: <20220304180105.409765-5-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-ext4@vger.kernel.org
Subject: [dm-devel] [PATCH 04/10] dm-crypt: stop using bio_devname
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

Use the %pg format specifier to save on stack consuption and code size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-crypt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a5006cb6ee8ad..e2b0af4a2ee84 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1364,11 +1364,10 @@ static int crypt_convert_block_aead(struct crypt_config *cc,
 	}
 
 	if (r == -EBADMSG) {
-		char b[BDEVNAME_SIZE];
 		sector_t s = le64_to_cpu(*sector);
 
-		DMERR_LIMIT("%s: INTEGRITY AEAD ERROR, sector %llu",
-			    bio_devname(ctx->bio_in, b), s);
+		DMERR_LIMIT("%pg: INTEGRITY AEAD ERROR, sector %llu",
+			    ctx->bio_in->bi_bdev, s);
 		dm_audit_log_bio(DM_MSG_PREFIX, "integrity-aead",
 				 ctx->bio_in, s, 0);
 	}
@@ -2169,11 +2168,10 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 		error = cc->iv_gen_ops->post(cc, org_iv_of_dmreq(cc, dmreq), dmreq);
 
 	if (error == -EBADMSG) {
-		char b[BDEVNAME_SIZE];
 		sector_t s = le64_to_cpu(*org_sector_of_dmreq(cc, dmreq));
 
-		DMERR_LIMIT("%s: INTEGRITY AEAD ERROR, sector %llu",
-			    bio_devname(ctx->bio_in, b), s);
+		DMERR_LIMIT("%pg: INTEGRITY AEAD ERROR, sector %llu",
+			    ctx->bio_in->bi_bdev, s);
 		dm_audit_log_bio(DM_MSG_PREFIX, "integrity-aead",
 				 ctx->bio_in, s, 0);
 		io->error = BLK_STS_PROTECTION;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

