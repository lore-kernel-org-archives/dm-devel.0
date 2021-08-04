Return-Path: <SRS0=Qr9I=M3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC28C43216
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 10:03:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8AB8261073
	for <dm-devel@archiver.kernel.org>; Wed,  4 Aug 2021 10:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8AB8261073
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-tg2hVc08Oi-VUXHCU3vQpw-1; Wed, 04 Aug 2021 06:02:58 -0400
X-MC-Unique: tg2hVc08Oi-VUXHCU3vQpw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0EE68799E0;
	Wed,  4 Aug 2021 10:02:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 65FE85D6B1;
	Wed,  4 Aug 2021 10:02:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E027E4BB7C;
	Wed,  4 Aug 2021 10:02:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1749xjtA007158 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Aug 2021 05:59:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 95AE32077FD7; Wed,  4 Aug 2021 09:59:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 914C22077FD3
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 09:59:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA6FE802812
	for <dm-devel@redhat.com>; Wed,  4 Aug 2021 09:59:42 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-478-g38VjHXeOym78PRqVW6NvQ-1; Wed, 04 Aug 2021 05:59:41 -0400
X-MC-Unique: g38VjHXeOym78PRqVW6NvQ-1
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mBDet-005ewi-MZ; Wed, 04 Aug 2021 09:58:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed,  4 Aug 2021 11:56:21 +0200
Message-Id: <20210804095634.460779-3-hch@lst.de>
In-Reply-To: <20210804095634.460779-1-hch@lst.de>
References: <20210804095634.460779-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Ilya Dryomov <idryomov@gmail.com>, linux-um@lists.infradead.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, ceph-devel@vger.kernel.org,
	linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Geoff Levand <geoff@infradead.org>,
	Phillip Lougher <phillip@squashfs.org.uk>
Subject: [dm-devel] [PATCH 02/15] block: use bvec_virt in
	bio_integrity_{process, free}
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the bvec_virt helper to clean up the bio integrity processing a
little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 8f54d49dc500..6b47cddbbca1 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -104,8 +104,7 @@ void bio_integrity_free(struct bio *bio)
 	struct bio_set *bs = bio->bi_pool;
 
 	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
-		kfree(page_address(bip->bip_vec->bv_page) +
-		      bip->bip_vec->bv_offset);
+		kfree(bvec_virt(bip->bip_vec));
 
 	__bio_integrity_free(bs, bip);
 	bio->bi_integrity = NULL;
@@ -163,13 +162,11 @@ static blk_status_t bio_integrity_process(struct bio *bio,
 	struct bio_vec bv;
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	blk_status_t ret = BLK_STS_OK;
-	void *prot_buf = page_address(bip->bip_vec->bv_page) +
-		bip->bip_vec->bv_offset;
 
 	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	iter.interval = 1 << bi->interval_exp;
 	iter.seed = proc_iter->bi_sector;
-	iter.prot_buf = prot_buf;
+	iter.prot_buf = bvec_virt(bip->bip_vec);
 
 	__bio_for_each_segment(bv, bio, bviter, *proc_iter) {
 		void *kaddr = bvec_kmap_local(&bv);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

