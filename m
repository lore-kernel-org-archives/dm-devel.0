Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E531C19F28
	for <dm-devel@archiver.kernel.org>; Wed,  3 Aug 2022 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659551370;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=O56QWMyduS6pLnspQjUxd976r3sPXZ5OggeNf5J3HJk=;
	b=b6J1B7DaAjYuf3sPx5hyGh6ICpAM+ZowF7vEBZY1uVwN/wmgtMS31royZt1ygyV4/id0jj
	N0Mx52iKRDFKdZbs1LADaiFvdtjPmI+NoePZXytC/bgChPZnVNepJsJA5cmZaQ9GgO8EQu
	y3oroSQV+hRIbJ5YorNGtJo2+Nc4bfk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-poeBbx3KPdOY-4b8Mf0rlQ-1; Wed, 03 Aug 2022 14:29:26 -0400
X-MC-Unique: poeBbx3KPdOY-4b8Mf0rlQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 018D61C1BD36;
	Wed,  3 Aug 2022 18:29:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E10C82166B2A;
	Wed,  3 Aug 2022 18:29:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BB10E1946A53;
	Wed,  3 Aug 2022 18:29:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C88DE1946A53
 for <dm-devel@listman.corp.redhat.com>; Wed,  3 Aug 2022 18:29:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9E88240C124A; Wed,  3 Aug 2022 18:29:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AE1940C128A
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 18:29:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8133E3C0ED5B
 for <dm-devel@redhat.com>; Wed,  3 Aug 2022 18:29:23 +0000 (UTC)
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com
 [209.85.221.202]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-1j0IEIaoMlSZgR3xmoAdiA-1; Wed, 03 Aug 2022 14:29:21 -0400
X-MC-Unique: 1j0IEIaoMlSZgR3xmoAdiA-1
Received: by mail-vk1-f202.google.com with SMTP id
 o84-20020a1f2857000000b00377a278cd4bso1533678vko.13
 for <dm-devel@redhat.com>; Wed, 03 Aug 2022 11:29:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=3kZjk4XqY+9+XqfazvP7y6hW7g1W9LxfLjQbea+Yvmw=;
 b=gHa+9AYu7SAs1XoBzMRNgCVYu8gQqLnGzmYq16d+cNflweAg6HCTQTWEgyA9Cu8EyX
 csZMryNolQ7+vhWbtwylPnsKhsliCBtZG+zrsYd1kpAOJ35am2Gm8YtLwBQVP//Gwevy
 eZzItl5gXR/EjqsKCcmb7tUCEGzSYD623vhNdLcrb5PCfkzUPILws61RXHq5LMYRFOx+
 dNLP5e9RHaRGMschh/Dh7uQUIJ0JvnUm8JxvdOh9UtMTQf2p+3YzbwQfL9/8GhLqTagP
 OyfIfG8nK5tm245733QqkyertPu5E0c0OxsgDBt8fs9JvK907mVPkV7YbM7wSUIeJKaO
 hYoA==
X-Gm-Message-State: ACgBeo0cwIM/UrtL/DBPiYbzY3c2cLV8jc+u/Wat0Lhpmp2CVs/54Us4
 SbM1zEbOE+w7MdRlLqItxOt9xL6LEg==
X-Google-Smtp-Source: AA6agR6lNICAbuEeRnswkhlOhyZdbX//I3hoo+Ks7zAwwBckOI8PKJ+3S5ZLUDn/npR6NaW0QzzWZOHf8g==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:ab0:3786:0:b0:384:d413:5c41 with
 SMTP id
 d6-20020ab03786000000b00384d4135c41mr10135104uav.98.1659551361285; Wed, 03
 Aug 2022 11:29:21 -0700 (PDT)
Date: Wed,  3 Aug 2022 18:29:05 +0000
In-Reply-To: <YuqffhXctdt9vM0i@redhat.com>
Message-Id: <20220803182905.3279728-1-nhuck@google.com>
Mime-Version: 1.0
References: <YuqffhXctdt9vM0i@redhat.com>
From: Nathan Huckleberry <nhuck@google.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] Fixes
 6890e9b8c7d0a1062bbf4f854b6be3723836ad9a
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 Milan Broz <gmazyland@gmail.com>, Sami Tolvanen <samitolvanen@google.com>,
 Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The previous patch had a bug when hash verification failed in the
tasklet.  This happened because the tasklet has already advanced the
bvec_iter when it falls back to the work-queue implementation.  When the
work-queue job begins running, it attempts to restart verifiying at
block i, but the bvec_iter is at block i+1.

This causes several failures, the most noticeable is that there are not
enough bytes in the bvec_iter to finish verification.  Since there are
not enough bytes to finish, the work queue gets stuck in an infinite
loop in verity_for_io_block.

To fix this, we can make a local copy of the bvec_iter struct in
verity_verify_io.  This requires that we restart verification from the
first block when deferring to a work-queue rather than starting from the
last block verified in the tasklet.

This patch also fixes what appears to be a memory leak when FEC is
enabled.  The call to verity_fec_init_io should only be made if we are
in a work-queue since a tasklet does not use FEC and is unable to free
the memory.

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/md/dm-verity-target.c | 23 ++++++++++++++---------
 drivers/md/dm-verity.h        |  1 -
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 144889ba43ea..0677795454d7 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -499,17 +499,23 @@ static int verity_verify_io(struct dm_verity_io *io)
 	bool is_zero;
 	struct dm_verity *v = io->v;
 	struct bvec_iter start;
+	/*
+	 * Copy the iterator in case we need to restart verification in a
+	 * work-queue.
+	 */
+	struct bvec_iter iter_copy = io->iter;
 	struct crypto_wait wait;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
+	unsigned int b;
 
-	for (; io->block_idx < io->n_blocks; io->block_idx++) {
+	for (b = 0; b < io->n_blocks; b++) {
 		int r;
-		sector_t cur_block = io->block + io->block_idx;
+		sector_t cur_block = io->block + b;
 		struct ahash_request *req = verity_io_hash_req(v, io);
 
 		if (v->validated_blocks &&
 		    likely(test_bit(cur_block, v->validated_blocks))) {
-			verity_bv_skip_block(v, io, &io->iter);
+			verity_bv_skip_block(v, io, &iter_copy);
 			continue;
 		}
 
@@ -524,7 +530,7 @@ static int verity_verify_io(struct dm_verity_io *io)
 			 * If we expect a zero block, don't validate, just
 			 * return zeros.
 			 */
-			r = verity_for_bv_block(v, io, &io->iter,
+			r = verity_for_bv_block(v, io, &iter_copy,
 						verity_bv_zero);
 			if (unlikely(r < 0))
 				return r;
@@ -536,8 +542,8 @@ static int verity_verify_io(struct dm_verity_io *io)
 		if (unlikely(r < 0))
 			return r;
 
-		start = io->iter;
-		r = verity_for_io_block(v, io, &io->iter, &wait);
+		start = iter_copy;
+		r = verity_for_io_block(v, io, &iter_copy, &wait);
 		if (unlikely(r < 0))
 			return r;
 
@@ -608,6 +614,8 @@ static void verity_work(struct work_struct *w)
 	struct dm_verity_io *io = container_of(w, struct dm_verity_io, work);
 
 	io->in_tasklet = false;
+	verity_fec_init_io(io);
+
 	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
 }
 
@@ -638,7 +646,6 @@ static void verity_end_io(struct bio *bio)
 		return;
 	}
 
-	io->block_idx = 0;
 	if (static_branch_unlikely(&use_tasklet_enabled) && io->v->use_tasklet) {
 		tasklet_init(&io->tasklet, verity_tasklet, (unsigned long)io);
 		tasklet_schedule(&io->tasklet);
@@ -756,8 +763,6 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 	bio->bi_private = io;
 	io->iter = bio->bi_iter;
 
-	verity_fec_init_io(io);
-
 	verity_submit_prefetch(v, io);
 
 	submit_bio_noacct(bio);
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index e73a7972c3e9..fb92b22a6404 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -78,7 +78,6 @@ struct dm_verity_io {
 
 	sector_t block;
 	unsigned n_blocks;
-	unsigned int block_idx;
 	bool in_tasklet;
 
 	struct bvec_iter iter;
-- 
2.37.1.455.g008518b4e5-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

