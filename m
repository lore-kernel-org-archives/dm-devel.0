Return-Path: <SRS0=V8Hk=PH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6DEC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 19 Oct 2021 13:51:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1117D61374
	for <dm-devel@archiver.kernel.org>; Tue, 19 Oct 2021 13:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1117D61374
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-Df2QRU81PrWLPBo_UhmjCg-1; Tue, 19 Oct 2021 09:51:29 -0400
X-MC-Unique: Df2QRU81PrWLPBo_UhmjCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81FE31006AA2;
	Tue, 19 Oct 2021 13:51:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6804369CBF;
	Tue, 19 Oct 2021 13:51:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BFD0A4EA2F;
	Tue, 19 Oct 2021 13:51:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19JDpMxW027569 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Oct 2021 09:51:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E6F0E4047279; Tue, 19 Oct 2021 13:51:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E37424047272
	for <dm-devel@redhat.com>; Tue, 19 Oct 2021 13:51:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC33E800B29
	for <dm-devel@redhat.com>; Tue, 19 Oct 2021 13:51:21 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-19-oIqJSjXrOlSEdSaRVKSDzA-1; Tue, 19 Oct 2021 09:51:20 -0400
X-MC-Unique: oIqJSjXrOlSEdSaRVKSDzA-1
Received: from [2001:4bb8:180:8777:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcpPa-001SdT-NH; Tue, 19 Oct 2021 13:44:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 19 Oct 2021 15:44:04 +0200
Message-Id: <20211019134406.2501181-3-hch@lst.de>
In-Reply-To: <20211019134406.2501181-1-hch@lst.de>
References: <20211019134406.2501181-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH 2/4] dm-integrity: use bvec_kmap_local in
	__journal_read_write
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

Using local kmaps slightly reduces the chances to stray writes, and
the bvec interface cleans up the code a little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-integrity.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 77c1f645f8438..86350d7c1175f 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1953,7 +1953,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 		n_sectors -= bv.bv_len >> SECTOR_SHIFT;
 		bio_advance_iter(bio, &bio->bi_iter, bv.bv_len);
 retry_kmap:
-		mem = kmap_atomic(bv.bv_page);
+		mem = bvec_kmap_local(&bv);
 		if (likely(dio->op == REQ_OP_WRITE))
 			flush_dcache_page(bv.bv_page);
 
@@ -1967,7 +1967,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 
 				if (unlikely(journal_entry_is_inprogress(je))) {
 					flush_dcache_page(bv.bv_page);
-					kunmap_atomic(mem);
+					kunmap_local(mem);
 
 					__io_wait_event(ic->copy_to_journal_wait, !journal_entry_is_inprogress(je));
 					goto retry_kmap;
@@ -2058,7 +2058,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 
 		if (unlikely(dio->op == REQ_OP_READ))
 			flush_dcache_page(bv.bv_page);
-		kunmap_atomic(mem);
+		kunmap_local(mem);
 	} while (n_sectors);
 
 	if (likely(dio->op == REQ_OP_WRITE)) {
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

