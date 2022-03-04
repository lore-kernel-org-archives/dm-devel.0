Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163DCC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Mar 2022 19:37:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-1s12rPH-NIymkoO9PW1aRw-1; Fri, 04 Mar 2022 14:37:34 -0500
X-MC-Unique: 1s12rPH-NIymkoO9PW1aRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EEBA1006AA6;
	Fri,  4 Mar 2022 19:37:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EBC2D19652;
	Fri,  4 Mar 2022 19:37:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7C85646F98;
	Fri,  4 Mar 2022 19:37:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 224JbOnR003629 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 14:37:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 50EF5442904; Fri,  4 Mar 2022 19:37:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CCF142D3C0
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 19:37:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34D2385A5BC
	for <dm-devel@redhat.com>; Fri,  4 Mar 2022 19:37:24 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-487-bpAL4UgoMdu1Ot9cjqiaPg-1; Fri, 04 Mar 2022 14:37:22 -0500
X-MC-Unique: bpAL4UgoMdu1Ot9cjqiaPg-1
Received: from [2001:4bb8:180:5296:cded:8d4b:ace6:f3c] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nQCF1-00BUru-RD; Fri, 04 Mar 2022 18:01:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Fri,  4 Mar 2022 19:01:01 +0100
Message-Id: <20220304180105.409765-7-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-ext4@vger.kernel.org
Subject: [dm-devel] [PATCH 06/10] md-multipath: stop using bio_devname
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
 drivers/md/md-multipath.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index c056a7d707b09..bc38a6133cda3 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -294,7 +294,6 @@ static void multipathd(struct md_thread *thread)
 
 	md_check_recovery(mddev);
 	for (;;) {
-		char b[BDEVNAME_SIZE];
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (list_empty(head))
 			break;
@@ -306,13 +305,13 @@ static void multipathd(struct md_thread *thread)
 		bio->bi_iter.bi_sector = mp_bh->master_bio->bi_iter.bi_sector;
 
 		if ((mp_bh->path = multipath_map (conf))<0) {
-			pr_err("multipath: %s: unrecoverable IO read error for block %llu\n",
-			       bio_devname(bio, b),
+			pr_err("multipath: %pg: unrecoverable IO read error for block %llu\n",
+			       bio->bi_bdev,
 			       (unsigned long long)bio->bi_iter.bi_sector);
 			multipath_end_bh_io(mp_bh, BLK_STS_IOERR);
 		} else {
-			pr_err("multipath: %s: redirecting sector %llu to another IO path\n",
-			       bio_devname(bio, b),
+			pr_err("multipath: %pg: redirecting sector %llu to another IO path\n",
+			       bio->bi_bdev,
 			       (unsigned long long)bio->bi_iter.bi_sector);
 			*bio = *(mp_bh->master_bio);
 			bio->bi_iter.bi_sector +=
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

