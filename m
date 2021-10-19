Return-Path: <SRS0=V8Hk=PH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B419C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 19 Oct 2021 13:52:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E44BD60E8B
	for <dm-devel@archiver.kernel.org>; Tue, 19 Oct 2021 13:52:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E44BD60E8B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-3yH5y5_NOMC3o1McIr2XPA-1; Tue, 19 Oct 2021 09:52:08 -0400
X-MC-Unique: 3yH5y5_NOMC3o1McIr2XPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78C6E80982E;
	Tue, 19 Oct 2021 13:52:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C5DC708E2;
	Tue, 19 Oct 2021 13:52:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2A7964EA38;
	Tue, 19 Oct 2021 13:52:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19JDpv6b027632 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Oct 2021 09:51:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7CFB640CFD11; Tue, 19 Oct 2021 13:51:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7815B40CFD10
	for <dm-devel@redhat.com>; Tue, 19 Oct 2021 13:51:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E067802A5E
	for <dm-devel@redhat.com>; Tue, 19 Oct 2021 13:51:57 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-79-IAoqThuLPkubllJ4JlEyWg-1; Tue, 19 Oct 2021 09:51:55 -0400
X-MC-Unique: IAoqThuLPkubllJ4JlEyWg-1
Received: from [2001:4bb8:180:8777:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mcpPd-001Se5-T5; Tue, 19 Oct 2021 13:44:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 19 Oct 2021 15:44:05 +0200
Message-Id: <20211019134406.2501181-4-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH 3/4] dm-log-writes: use memcpy_from_bvec in
	log_writes_map
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

Use memcpy_from_bvec instead of open coding the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-log-writes.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index d93a4db235124..eeaf729287f06 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -753,7 +753,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	 */
 	bio_for_each_segment(bv, bio, iter) {
 		struct page *page;
-		void *src, *dst;
+		void *dst;
 
 		page = alloc_page(GFP_NOIO);
 		if (!page) {
@@ -765,11 +765,9 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 			return DM_MAPIO_KILL;
 		}
 
-		src = kmap_atomic(bv.bv_page);
 		dst = kmap_atomic(page);
-		memcpy(dst, src + bv.bv_offset, bv.bv_len);
+		memcpy_from_bvec(dst, &bv);
 		kunmap_atomic(dst);
-		kunmap_atomic(src);
 		block->vecs[i].bv_page = page;
 		block->vecs[i].bv_len = bv.bv_len;
 		block->vec_cnt++;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

