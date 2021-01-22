Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15C3C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:20:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1A7FD235DD
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A7FD235DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-DgvAiZDaPEafzZLseJ95Vg-1; Fri, 22 Jan 2021 10:20:04 -0500
X-MC-Unique: DgvAiZDaPEafzZLseJ95Vg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A066879500;
	Fri, 22 Jan 2021 15:19:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5813A1992D;
	Fri, 22 Jan 2021 15:19:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A64C6180954D;
	Fri, 22 Jan 2021 15:19:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10MFJtYP028012 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 10:19:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 486DC2026D36; Fri, 22 Jan 2021 15:19:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43E152026D13
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:19:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E97491875049
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:19:52 +0000 (UTC)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
	[209.85.221.43]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-256-fKAbuwSPOAefDZPM1Au55w-1; Fri, 22 Jan 2021 10:19:49 -0500
X-MC-Unique: fKAbuwSPOAefDZPM1Au55w-1
Received: by mail-wr1-f43.google.com with SMTP id c12so5436925wrc.7
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 07:19:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=Ulah0K7SrMNMKywK6lw8eGDPVXApitKEUnAzjXT2k40=;
	b=WDc7zpo7Ou9iLGglF08U1GBJCcmcCwoQmb6cAAIm+H46kLdic9zDyUbhEdj4IgowX/
	WZNGNQjJhhY5IFFRChg5Xwi3BwOio6hb9WvWoAKIPeWLXmLCoVZ7SqNu32VKMUhldxIC
	bcYWjyVWACyLxfbYdBUHWOitTnfMCMfiZ6vGPtk8dgeOoIkTI8fXg37SorLgk4V7oc4z
	9zzGDhULPiamoAwKef9GGvqyi1PUERD3Sjea23OSBjnoDXSteycZSHpVCOMnVun5POh5
	t5uUO/NnJ5tF5ra54R9GAe5aEZI5gbgZJ13jRxuKN8joelUvvm0zaP5NwN3ETC9rR/f6
	3wuQ==
X-Gm-Message-State: AOAM531vkvFi4lLLxR1Pi/VWZJPaeJ5E4W6LENb/xUAPxVQXbgWO87rc
	dm0fnV+Pby1Cc7nwyFYwXU/sR9mcmq/rbA==
X-Google-Smtp-Source: ABdhPJxKaaAVlERPkD9agMPce2xxkgAt3tnYPmnLak8eiwG+S7RMkQ5md7wYQj78bkFs2pP3x3K2iQ==
X-Received: by 2002:adf:9d48:: with SMTP id o8mr5069152wre.408.1611328787994; 
	Fri, 22 Jan 2021 07:19:47 -0800 (PST)
Received: from snf-864.vm.snf.arr ([31.177.62.212])
	by smtp.gmail.com with ESMTPSA id
	j13sm11526650wmi.24.2021.01.22.07.19.45
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 22 Jan 2021 07:19:46 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Date: Fri, 22 Jan 2021 17:19:31 +0200
Message-Id: <20210122151931.24645-3-ntsironis@arrikto.com>
In-Reply-To: <20210122151931.24645-1-ntsironis@arrikto.com>
References: <20210122151931.24645-1-ntsironis@arrikto.com>
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
Cc: ejt@redhat.com, ntsironis@arrikto.com
Subject: [dm-devel] [PATCH 2/2] dm era: Update in-core bitset after
	committing the metadata
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In case of a system crash, dm-era might fail to mark blocks as written
in its metadata, although the corresponding writes to these blocks were
passed down to the origin device and completed successfully.

Consider the following sequence of events:

1. We write to a block that has not been yet written in the current era
2. era_map() checks the in-core bitmap for the current era and sees
   that the block is not marked as written.
3. The write is deferred for submission after the metadata have been
   updated and committed.
4. The worker thread processes the deferred write
   (process_deferred_bios()) and marks the block as written in the
   in-core bitmap, **before** committing the metadata.
5. The worker thread starts committing the metadata.
6. We do more writes that map to the same block as the write of step (1)
7. era_map() checks the in-core bitmap and sees that the block is marked
   as written, **although the metadata have not been committed yet**.
8. These writes are passed down to the origin device immediately and the
   device reports them as completed.
9. The system crashes, e.g., power failure, before the commit from step
   (5) finishes.

When the system recovers and we query the dm-era target for the list of
written blocks it doesn't report the aforementioned block as written,
although the writes of step (6) completed successfully.

The issue is that era_map() decides whether to defer or not a write
based on non committed information. The root cause of the bug is that we
update the in-core bitmap, **before** committing the metadata.

Fix this by updating the in-core bitmap **after** successfully
committing the metadata.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-era-target.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 854b1be8b452..62f679faf9e7 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -134,7 +134,7 @@ static int writeset_test_and_set(struct dm_disk_bitset *info,
 {
 	int r;
 
-	if (!test_and_set_bit(block, ws->bits)) {
+	if (!test_bit(block, ws->bits)) {
 		r = dm_bitset_set_bit(info, ws->md.root, block, &ws->md.root);
 		if (r) {
 			/* FIXME: fail mode */
@@ -1226,8 +1226,10 @@ static void process_deferred_bios(struct era *era)
 	int r;
 	struct bio_list deferred_bios, marked_bios;
 	struct bio *bio;
+	struct blk_plug plug;
 	bool commit_needed = false;
 	bool failed = false;
+	struct writeset *ws = era->md->current_writeset;
 
 	bio_list_init(&deferred_bios);
 	bio_list_init(&marked_bios);
@@ -1237,9 +1239,11 @@ static void process_deferred_bios(struct era *era)
 	bio_list_init(&era->deferred_bios);
 	spin_unlock(&era->deferred_lock);
 
+	if (bio_list_empty(&deferred_bios))
+		return;
+
 	while ((bio = bio_list_pop(&deferred_bios))) {
-		r = writeset_test_and_set(&era->md->bitset_info,
-					  era->md->current_writeset,
+		r = writeset_test_and_set(&era->md->bitset_info, ws,
 					  get_block(era, bio));
 		if (r < 0) {
 			/*
@@ -1247,7 +1251,6 @@ static void process_deferred_bios(struct era *era)
 			 * FIXME: finish.
 			 */
 			failed = true;
-
 		} else if (r == 0)
 			commit_needed = true;
 
@@ -1263,9 +1266,19 @@ static void process_deferred_bios(struct era *era)
 	if (failed)
 		while ((bio = bio_list_pop(&marked_bios)))
 			bio_io_error(bio);
-	else
-		while ((bio = bio_list_pop(&marked_bios)))
+	else {
+		blk_start_plug(&plug);
+		while ((bio = bio_list_pop(&marked_bios))) {
+			/*
+			 * Only update the in-core writeset if the on-disk one
+			 * was updated too.
+			 */
+			if (commit_needed)
+				set_bit(get_block(era, bio), ws->bits);
 			submit_bio_noacct(bio);
+		}
+		blk_finish_plug(&plug);
+	}
 }
 
 static void process_rpc_calls(struct era *era)
-- 
2.11.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

