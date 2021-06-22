Return-Path: <SRS0=sUdA=LQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73061C2B9F4
	for <dm-devel@archiver.kernel.org>; Tue, 22 Jun 2021 16:30:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0AE4660720
	for <dm-devel@archiver.kernel.org>; Tue, 22 Jun 2021 16:30:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AE4660720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=126.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-6vRCs8NcPA61AZ8mON9HPg-1; Tue, 22 Jun 2021 12:30:13 -0400
X-MC-Unique: 6vRCs8NcPA61AZ8mON9HPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A07DC800685;
	Tue, 22 Jun 2021 16:30:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A8B0100164A;
	Tue, 22 Jun 2021 16:30:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AB8441809C99;
	Tue, 22 Jun 2021 16:30:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15MGU3kQ031548 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Jun 2021 12:30:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AAC692141DF2; Tue, 22 Jun 2021 16:30:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A647F2141DEC
	for <dm-devel@redhat.com>; Tue, 22 Jun 2021 16:30:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 978F7800FFB
	for <dm-devel@redhat.com>; Tue, 22 Jun 2021 16:30:00 +0000 (UTC)
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111]) by
	relay.mimecast.com with ESMTP id us-mta-46-ruEctEORNq2f-xTdGgVIGQ-1;
	Tue, 22 Jun 2021 12:29:57 -0400
X-MC-Unique: ruEctEORNq2f-xTdGgVIGQ-1
Received: from 192.168.137.133 (unknown [112.10.75.196])
	by smtp1 (Coremail) with SMTP id C8mowADXblu1B9JgHvJTSg--.5696S3;
	Tue, 22 Jun 2021 23:54:31 +0800 (CST)
From: Xianting Tian <xianting_tian@126.com>
To: colyli@suse.de, kent.overstreet@gmail.com, agk@redhat.com,
	snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org
Date: Tue, 22 Jun 2021 11:54:01 -0400
Message-Id: <1624377241-8642-1-git-send-email-xianting_tian@126.com>
X-CM-TRANSID: C8mowADXblu1B9JgHvJTSg--.5696S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFWDGFWkKF47ZryUXFyfCrg_yoWrCFy8pa
	9rXrWfAw4rJw4UZF4DZaykua4rt3Z0grW7CFyxu3s3uFy5CF98ZF4UJFWUXr1DJFW3Ga42
	q3WDtw4DuF45tr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jaiifUUUUU=
X-Originating-IP: [112.10.75.196]
X-CM-SenderInfo: h0ld03plqjs3xldqqiyswou0bp/1tbi5he5pFpEBKr-xAAAsn
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
Cc: linux-raid@vger.kernel.org, Xianting Tian <xianting.tian@linux.alibaba.com>,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] md: use BLK_STS_OK instead of hardcode
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When setting io status, sometimes it uses BLK_STS_*, sometimes,
it uses hardcode 0.
Use the macro to replace hardcode in multiple places.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
 drivers/md/bcache/request.c  | 2 +-
 drivers/md/dm-clone-target.c | 2 +-
 drivers/md/dm-integrity.c    | 2 +-
 drivers/md/dm-mpath.c        | 2 +-
 drivers/md/dm-raid1.c        | 2 +-
 drivers/md/dm.c              | 2 +-
 drivers/md/raid1.c           | 4 ++--
 drivers/md/raid10.c          | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 6d1de88..73ba5a6 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -790,7 +790,7 @@ static void cached_dev_read_error(struct closure *cl)
 		/* Retry from the backing device: */
 		trace_bcache_read_retry(s->orig_bio);
 
-		s->iop.status = 0;
+		s->iop.status = BLK_STS_OK;
 		do_bio_hook(s, s->orig_bio, backing_request_endio);
 
 		/* XXX: invalidate cache */
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index a90bdf9..d3f1c67 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -684,7 +684,7 @@ static void hydration_init(struct dm_clone_region_hydration *hd, unsigned long r
 	hd->region_nr = region_nr;
 	hd->overwrite_bio = NULL;
 	bio_list_init(&hd->deferred_bios);
-	hd->status = 0;
+	hd->status = BLK_STS_OK;
 
 	INIT_LIST_HEAD(&hd->list);
 	INIT_HLIST_NODE(&hd->h);
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 20f2510..179e126 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1848,7 +1848,7 @@ static int dm_integrity_map(struct dm_target *ti, struct bio *bio)
 	sector_t area, offset;
 
 	dio->ic = ic;
-	dio->bi_status = 0;
+	dio->bi_status = BLK_STS_OK;
 	dio->op = bio_op(bio);
 
 	if (unlikely(dio->op == REQ_OP_DISCARD)) {
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bced42f..50f5945 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -648,7 +648,7 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 
 	mpio->pgpath = pgpath;
 
-	bio->bi_status = 0;
+	bio->bi_status = BLK_STS_OK;
 	bio_set_dev(bio, pgpath->path.dev->bdev);
 	bio->bi_opf |= REQ_FAILFAST_TRANSPORT;
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index b0a82f2..bf4d875 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1283,7 +1283,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio,
 
 			dm_bio_restore(bd, bio);
 			bio_record->details.bi_bdev = NULL;
-			bio->bi_status = 0;
+			bio->bi_status = BLK_STS_OK;
 
 			queue_bio(ms, bio, rw);
 			return DM_ENDIO_INCOMPLETE;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca2aedd..3d2fe23 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -649,7 +649,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 
 	io = container_of(tio, struct dm_io, tio);
 	io->magic = DM_IO_MAGIC;
-	io->status = 0;
+	io->status = BLK_STS_OK;
 	atomic_set(&io->io_count, 1);
 	io->orig_bio = bio;
 	io->md = md;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ced076b..418d789 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2081,7 +2081,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		idx ++;
 	}
 	set_bit(R1BIO_Uptodate, &r1_bio->state);
-	bio->bi_status = 0;
+	bio->bi_status = BLK_STS_OK;
 	return 1;
 }
 
@@ -2144,7 +2144,7 @@ static void process_checks(struct r1bio *r1_bio)
 		if (sbio->bi_end_io != end_sync_read)
 			continue;
 		/* Now we can 'fixup' the error value */
-		sbio->bi_status = 0;
+		sbio->bi_status = BLK_STS_OK;
 
 		bio_for_each_segment_all(bi, sbio, iter_all)
 			page_len[j++] = bi->bv_len;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 13f5e6b..c9a146b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3797,7 +3797,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 		if (bio->bi_end_io == end_sync_read) {
 			md_sync_acct_bio(bio, nr_sectors);
-			bio->bi_status = 0;
+			bio->bi_status = BLK_STS_OK;
 			submit_bio_noacct(bio);
 		}
 	}
-- 
1.8.3.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

