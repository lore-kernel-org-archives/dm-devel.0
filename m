Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MISSING_HEADERS,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B82C4332B
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C4D02068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C4D02068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-ZIO1A7HSPSiHkZ4XbVoSvQ-1; Mon, 04 Jan 2021 14:03:57 -0500
X-MC-Unique: ZIO1A7HSPSiHkZ4XbVoSvQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1D96801817;
	Mon,  4 Jan 2021 19:03:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B7A8B57;
	Mon,  4 Jan 2021 19:03:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8CE9F50038;
	Mon,  4 Jan 2021 19:03:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BS7EvYp031253 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Dec 2020 02:14:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2DECC2026D49; Mon, 28 Dec 2020 07:14:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28F312026D48
	for <dm-devel@redhat.com>; Mon, 28 Dec 2020 07:14:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D272C101A561
	for <dm-devel@redhat.com>; Mon, 28 Dec 2020 07:14:51 +0000 (UTC)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
	[209.85.219.73]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-202-IIuKHIuSMweURwkoutRpEQ-1; Mon, 28 Dec 2020 02:14:47 -0500
X-MC-Unique: IIuKHIuSMweURwkoutRpEQ-1
Received: by mail-qv1-f73.google.com with SMTP id t17so8540042qvv.17
	for <dm-devel@redhat.com>; Sun, 27 Dec 2020 23:14:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
	:cc; bh=+w8BZ65tjlpdxVh8d2na0pdcvFUUAjnRCf3t4vTPoxA=;
	b=ebLmiv8jHxN+BYRMx6K4eL8sXSwqCx3Ra8B5pv+ZNkEIWu0lLBM6wtN1DaLk8OwsNx
	qkCg/dnuRbR1HSau2NtuAcPt6ixm4A70i+sKKaOpflCLNW86mUea89nnp6Inmm+xN755
	8xQfKNwPVHdvYT91Eo2oLNLZoJghHUhsyHer9aDIN+iOlvy6MTrJ0GRxyp/ZWETmlk/U
	P03p0xAHbOyq5mhAdMkTdv1yOSJyCRXYnjY5cm2nPsaYeIqfLjdD9SDyTYrFO4rjtdPe
	b0+4ZyOy0vwO445u9M5lxfFdlY9NaVNEjQeb+2Ul+RgwW/Fh60nRsjDsc02x7NNQnQ39
	/dHg==
X-Gm-Message-State: AOAM533KUipDM1A4vB+F/ksqA5nCZqlixp8vvbL6i6z0FdPoKk56RYKC
	0rhZWh7+znZkG+vluuLbP67GHubOzo3TRw==
X-Google-Smtp-Source: ABdhPJwYhYXH7IdJV7dMiy+2k7Wa6r+n6ZiCaXAaglrarLLDjIRb1AN6v/I7xiaOhU5MdtB2k6dgZbDAGEARfg==
X-Received: from akailash.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1e6])
	(user=akailash job=sendgmr) by 2002:a05:6214:1754:: with SMTP id
	dc20mr45736851qvb.7.1609139686600; Sun, 27 Dec 2020 23:14:46 -0800 (PST)
Date: Mon, 28 Dec 2020 07:14:07 +0000
Message-Id: <ecb35731d19b41984dd7157d48661f5297a1b668.1609119545.git.akailash@google.com>
Mime-Version: 1.0
From: Akilesh Kailash <akailash@google.com>
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
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, dvander@google.com, akailash@google.com,
	kernel-team@android.com, Alasdair Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH] dm-snapshot: Flush merged data before committing
	metadata
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If the origin device has a volatile write-back
cache and the following events occur:

1: After finishing merge operation of one set of exceptions,
   merge_callback() is invoked.
2: Update the metadata in COW device tracking the merge completion.
   This update to COW device is flushed cleanly.
3: System crashes and the origin device's cache where the recent
   merge was completed has not been flushed.

During the next cycle when we read the metadata from the COW device,
we will skip reading those metadata whose merge was completed in
step (1). This will lead to data loss/corruption.

To address this, flush the origin device post merge IO before
updating the metadata.

Signed-off-by: Akilesh Kailash <akailash@google.com>
---
 drivers/md/dm-snap.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 4668b2cd98f4..11890db71f3f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -141,6 +141,11 @@ struct dm_snapshot {
 	 * for them to be committed.
 	 */
 	struct bio_list bios_queued_during_merge;
+
+	/*
+	 * Flush data after merge.
+	 */
+	struct bio flush_bio;
 };
 
 /*
@@ -1121,6 +1126,17 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
 
 static void error_bios(struct bio *bio);
 
+static int flush_data(struct dm_snapshot *s)
+{
+	struct bio *flush_bio = &s->flush_bio;
+
+	bio_reset(flush_bio);
+	bio_set_dev(flush_bio, s->origin->bdev);
+	flush_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
+
+	return submit_bio_wait(flush_bio);
+}
+
 static void merge_callback(int read_err, unsigned long write_err, void *context)
 {
 	struct dm_snapshot *s = context;
@@ -1134,6 +1150,11 @@ static void merge_callback(int read_err, unsigned long write_err, void *context)
 		goto shut;
 	}
 
+	if (flush_data(s) < 0) {
+		DMERR("Flush after merge failed: shutting down merge");
+		goto shut;
+	}
+
 	if (s->store->type->commit_merge(s->store,
 					 s->num_merging_chunks) < 0) {
 		DMERR("Write error in exception store: shutting down merge");
@@ -1318,6 +1339,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->first_merging_chunk = 0;
 	s->num_merging_chunks = 0;
 	bio_list_init(&s->bios_queued_during_merge);
+	bio_init(&s->flush_bio, NULL, 0);
 
 	/* Allocate hash table for COW data */
 	if (init_hash_tables(s)) {
@@ -1504,6 +1526,8 @@ static void snapshot_dtr(struct dm_target *ti)
 
 	dm_exception_store_destroy(s->store);
 
+	bio_uninit(&s->flush_bio);
+
 	dm_put_device(ti, s->cow);
 
 	dm_put_device(ti, s->origin);
-- 
2.29.2.729.g45daf8777d-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

