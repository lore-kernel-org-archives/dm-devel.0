Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC135C64ED6
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319332;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bPVseQPHFOMCvwNGTnQBktU9SZBccIcwKK4UaInM4js=;
	b=EROLOKXOZoMyUl2pKCNJxJZtfSHEYwE6PEadQVYmRs4Rv4nssG0S22TrCnE24joGBE+vUq
	x2DzA3PhLhH4Q2AGjbqshPo69FsgQzVjv3B/v3T/FNETPenxBFzeCjnobZkN0qU3beoe1W
	dxsgXIDQxd70fACPbSaY/CGAeC4GWxA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-Pl_aEM6JMIW2AB6HC9GD9w-1; Mon, 13 Feb 2023 15:15:29 -0500
X-MC-Unique: Pl_aEM6JMIW2AB6HC9GD9w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD7931C02D4E;
	Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C80D3403D0CF;
	Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 99CCE19465A4;
	Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8375B1946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 59CAE40C83B6; Mon, 13 Feb 2023 20:15:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 524C240CF8ED
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBCD218E528D
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:14 +0000 (UTC)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com
 [209.85.160.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-450-1QNh8ZxpM_GJpEcYJwhbXA-2; Mon, 13 Feb 2023 15:15:09 -0500
X-MC-Unique: 1QNh8ZxpM_GJpEcYJwhbXA-2
Received: by mail-qt1-f170.google.com with SMTP id cr22so15169317qtb.10
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=iE2AES2rt4SzC2HmCkYIjbxs6qvhGIB9lMuSOB7BQpc=;
 b=C5UO72J1HabesMfbs/MPSUc4xCxGItHe5QGE+sqezSdBmCat+L2uefn9opx/lAXt+k
 jvL39gJI/vvAFTZU+Eio/S0KDsBlZjxIWoXGpxDSNSSjHrmpGcg34jVcJUHawAPfqC6I
 l+5LpeUCvTj4rWuF4SwXFK6Nv8l2+yAx0ZehWQEhY6azTAfuA9zcAIkQsPr+lWg55Lqo
 c7NtF4qW+pj6OlElIUy/ajUzkZ7HM4l+U/dtXTY7g0Ri58I2K/oo8Q9AtImxEwveMmYw
 UkiYLNRbI4mrqd+a8ER9huy+CnydZn1HD/J0PsJ0Eu4egIGiU9Ud3oFwkJPuH5L9HjLr
 PA5w==
X-Gm-Message-State: AO0yUKWyEuLBBNJU5e7+WHfoLtBg639jbL5S+2TfnaAASjkHw6i44hq4
 mr+lkkmCoYRGR160cr1is7tK3WA1Hvg0m+md2HB0NK+hrtJmDkxnkaNHHKrJhar6lmmBY/JwG2r
 ObVl3DIX9WnUxyYAk2ry28wY/R0+0FbFkh15E3FB5GknoLCIIdsme5hmOU635P1mNUjXINw==
X-Google-Smtp-Source: AK7set8InHpPZnwILFAwWxTVAx6jRf52rLKXbkgNqj8hiPa6Dt6F4UoKztyASsBdoFd3aKC9+JN11g==
X-Received: by 2002:a05:622a:588:b0:3b9:b7c9:f0d3 with SMTP id
 c8-20020a05622a058800b003b9b7c9f0d3mr37273695qtb.43.1676319302778; 
 Mon, 13 Feb 2023 12:15:02 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 m127-20020a37bc85000000b00720750365b9sm10433373qkf.129.2023.02.13.12.15.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:02 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:43 -0500
Message-Id: <20230213201401.45973-22-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 21/39] dm: prefer '"%s...", __func__'
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-cache-metadata.c                   | 12 ++++++------
 drivers/md/dm-era-target.c                       | 12 ++++++------
 drivers/md/dm-integrity.c                        |  4 ++--
 drivers/md/dm-ioctl.c                            |  2 +-
 drivers/md/dm-mpath.c                            | 14 +++++++-------
 drivers/md/dm-thin-metadata.c                    | 12 ++++++------
 drivers/md/dm-verity-target.c                    |  4 ++--
 drivers/md/persistent-data/dm-array.c            |  4 ++--
 drivers/md/persistent-data/dm-btree-spine.c      | 10 +++++-----
 drivers/md/persistent-data/dm-space-map-common.c |  4 ++--
 10 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 8161943fe360..30b95f6bf499 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -203,15 +203,15 @@ static int sb_check(struct dm_block_validator *v,
 	__le32 csum_le;
 
 	if (dm_block_location(b) != le64_to_cpu(disk_super->blocknr)) {
-		DMERR("sb_check failed: blocknr %llu: wanted %llu",
-		      le64_to_cpu(disk_super->blocknr),
+		DMERR("%s failed: blocknr %llu: wanted %llu",
+		      __func__, le64_to_cpu(disk_super->blocknr),
 		      (unsigned long long)dm_block_location(b));
 		return -ENOTBLK;
 	}
 
 	if (le64_to_cpu(disk_super->magic) != CACHE_SUPERBLOCK_MAGIC) {
-		DMERR("sb_check failed: magic %llu: wanted %llu",
-		      le64_to_cpu(disk_super->magic),
+		DMERR("%s failed: magic %llu: wanted %llu",
+		      __func__, le64_to_cpu(disk_super->magic),
 		      (unsigned long long)CACHE_SUPERBLOCK_MAGIC);
 		return -EILSEQ;
 	}
@@ -220,8 +220,8 @@ static int sb_check(struct dm_block_validator *v,
 					     sb_block_size - sizeof(__le32),
 					     SUPERBLOCK_CSUM_XOR));
 	if (csum_le != disk_super->csum) {
-		DMERR("sb_check failed: csum %u: wanted %u",
-		      le32_to_cpu(csum_le), le32_to_cpu(disk_super->csum));
+		DMERR("%s failed: csum %u: wanted %u",
+		      __func__, le32_to_cpu(csum_le), le32_to_cpu(disk_super->csum));
 		return -EILSEQ;
 	}
 
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index f8f7994f4f27..c2e7780cdd2d 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -229,15 +229,15 @@ static int sb_check(struct dm_block_validator *v,
 	__le32 csum_le;
 
 	if (dm_block_location(b) != le64_to_cpu(disk->blocknr)) {
-		DMERR("sb_check failed: blocknr %llu: wanted %llu",
-		      le64_to_cpu(disk->blocknr),
+		DMERR("%s failed: blocknr %llu: wanted %llu",
+		      __func__, le64_to_cpu(disk->blocknr),
 		      (unsigned long long)dm_block_location(b));
 		return -ENOTBLK;
 	}
 
 	if (le64_to_cpu(disk->magic) != SUPERBLOCK_MAGIC) {
-		DMERR("sb_check failed: magic %llu: wanted %llu",
-		      le64_to_cpu(disk->magic),
+		DMERR("%s failed: magic %llu: wanted %llu",
+		      __func__, le64_to_cpu(disk->magic),
 		      (unsigned long long) SUPERBLOCK_MAGIC);
 		return -EILSEQ;
 	}
@@ -246,8 +246,8 @@ static int sb_check(struct dm_block_validator *v,
 					     sb_block_size - sizeof(__le32),
 					     SUPERBLOCK_CSUM_XOR));
 	if (csum_le != disk->csum) {
-		DMERR("sb_check failed: csum %u: wanted %u",
-		      le32_to_cpu(csum_le), le32_to_cpu(disk->csum));
+		DMERR("%s failed: csum %u: wanted %u",
+		      __func__, le32_to_cpu(csum_le), le32_to_cpu(disk->csum));
 		return -EILSEQ;
 	}
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 76a518f54bd2..4729e641bf8b 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3093,7 +3093,7 @@ static void replay_journal(struct dm_integrity_c *ic)
 
 static void dm_integrity_enter_synchronous_mode(struct dm_integrity_c *ic)
 {
-	DEBUG_print("dm_integrity_enter_synchronous_mode\n");
+	DEBUG_print("%s\n", __func__);
 
 	if (ic->mode == 'B') {
 		ic->bitmap_flush_interval = msecs_to_jiffies(10) + 1;
@@ -3109,7 +3109,7 @@ static int dm_integrity_reboot(struct notifier_block *n, unsigned long code, voi
 {
 	struct dm_integrity_c *ic = container_of(n, struct dm_integrity_c, reboot_notifier);
 
-	DEBUG_print("dm_integrity_reboot\n");
+	DEBUG_print("%s\n", __func__);
 
 	dm_integrity_enter_synchronous_mode(ic);
 
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index eac73b0d3bfa..ec278675a8ca 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1402,7 +1402,7 @@ static int populate_table(struct dm_table *table,
 	char *target_params;
 
 	if (!param->target_count) {
-		DMERR("populate_table: no targets specified");
+		DMERR("%s: no targets specified", __func__);
 		return -EINVAL;
 	}
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 9669162a38ae..c15cc7f54bd2 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -739,15 +739,15 @@ static void process_queued_bios(struct work_struct *work)
 /*
  * If we run out of usable paths, should we queue I/O or error it?
  */
-static int queue_if_no_path(struct multipath *m, bool queue_if_no_path,
+static int queue_if_no_path(struct multipath *m, bool f_queue_if_no_path,
 			    bool save_old_value, const char *caller)
 {
 	unsigned long flags;
 	bool queue_if_no_path_bit, saved_queue_if_no_path_bit;
 	const char *dm_dev_name = dm_table_device_name(m->ti->table);
 
-	DMDEBUG("%s: %s caller=%s queue_if_no_path=%d save_old_value=%d",
-		dm_dev_name, __func__, caller, queue_if_no_path, save_old_value);
+	DMDEBUG("%s: %s caller=%s f_queue_if_no_path=%d save_old_value=%d",
+		dm_dev_name, __func__, caller, f_queue_if_no_path, save_old_value);
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -760,11 +760,11 @@ static int queue_if_no_path(struct multipath *m, bool queue_if_no_path,
 			      dm_dev_name);
 		} else
 			assign_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags, queue_if_no_path_bit);
-	} else if (!queue_if_no_path && saved_queue_if_no_path_bit) {
+	} else if (!f_queue_if_no_path && saved_queue_if_no_path_bit) {
 		/* due to "fail_if_no_path" message, need to honor it. */
 		clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
 	}
-	assign_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags, queue_if_no_path);
+	assign_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags, f_queue_if_no_path);
 
 	DMDEBUG("%s: after %s changes; QIFNP = %d; SQIFNP = %d; DNFS = %d",
 		dm_dev_name, __func__,
@@ -774,7 +774,7 @@ static int queue_if_no_path(struct multipath *m, bool queue_if_no_path,
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	if (!queue_if_no_path) {
+	if (!f_queue_if_no_path) {
 		dm_table_run_md_queue_async(m->ti->table);
 		process_queued_io_list(m);
 	}
@@ -1468,7 +1468,7 @@ static int switch_pg_num(struct multipath *m, const char *pgstr)
 
 	if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
 	    !m->nr_priority_groups || (pgnum > m->nr_priority_groups)) {
-		DMWARN("invalid PG number supplied to switch_pg_num");
+		DMWARN("invalid PG number supplied to %s", __func__);
 		return -EINVAL;
 	}
 
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index afa574799461..ddd0718fcf81 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -269,15 +269,15 @@ static int sb_check(struct dm_block_validator *v,
 	__le32 csum_le;
 
 	if (dm_block_location(b) != le64_to_cpu(disk_super->blocknr)) {
-		DMERR("sb_check failed: blocknr %llu: wanted %llu",
-		      le64_to_cpu(disk_super->blocknr),
+		DMERR("%s failed: blocknr %llu: wanted %llu",
+		      __func__, le64_to_cpu(disk_super->blocknr),
 		      (unsigned long long)dm_block_location(b));
 		return -ENOTBLK;
 	}
 
 	if (le64_to_cpu(disk_super->magic) != THIN_SUPERBLOCK_MAGIC) {
-		DMERR("sb_check failed: magic %llu: wanted %llu",
-		      le64_to_cpu(disk_super->magic),
+		DMERR("%s failed: magic %llu: wanted %llu",
+		      __func__, le64_to_cpu(disk_super->magic),
 		      (unsigned long long)THIN_SUPERBLOCK_MAGIC);
 		return -EILSEQ;
 	}
@@ -286,8 +286,8 @@ static int sb_check(struct dm_block_validator *v,
 					     block_size - sizeof(__le32),
 					     SUPERBLOCK_CSUM_XOR));
 	if (csum_le != disk_super->csum) {
-		DMERR("sb_check failed: csum %u: wanted %u",
-		      le32_to_cpu(csum_le), le32_to_cpu(disk_super->csum));
+		DMERR("%s failed: csum %u: wanted %u",
+		      __func__, le32_to_cpu(csum_le), le32_to_cpu(disk_super->csum));
 		return -EILSEQ;
 	}
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index f4955c4dbe47..1db64a24623d 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -165,7 +165,7 @@ static int verity_hash_final(struct dm_verity *v, struct ahash_request *req,
 		r = verity_hash_update(v, req, v->salt, v->salt_size, wait);
 
 		if (r < 0) {
-			DMERR("verity_hash_final failed updating salt: %d", r);
+			DMERR("%s failed updating salt: %d", __func__, r);
 			goto out;
 		}
 	}
@@ -423,7 +423,7 @@ static int verity_for_io_block(struct dm_verity *v, struct dm_verity_io *io,
 		r = crypto_wait_req(crypto_ahash_update(req), wait);
 
 		if (unlikely(r < 0)) {
-			DMERR("verity_for_io_block crypto op failed: %d", r);
+			DMERR("%s crypto op failed: %d", __func__, r);
 			return r;
 		}
 
diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 30d77f0f7b83..7821bf106fa7 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -58,7 +58,7 @@ static int array_block_check(struct dm_block_validator *v,
 	__le32 csum_disk;
 
 	if (dm_block_location(b) != le64_to_cpu(bh_le->blocknr)) {
-		DMERR_LIMIT("array_block_check failed: blocknr %llu != wanted %llu",
+		DMERR_LIMIT("%s failed: blocknr %llu != wanted %llu", __func__,
 			    (unsigned long long) le64_to_cpu(bh_le->blocknr),
 			    (unsigned long long) dm_block_location(b));
 		return -ENOTBLK;
@@ -68,7 +68,7 @@ static int array_block_check(struct dm_block_validator *v,
 					       size_of_block - sizeof(__le32),
 					       CSUM_XOR));
 	if (csum_disk != bh_le->csum) {
-		DMERR_LIMIT("array_block_check failed: csum %u != wanted %u",
+		DMERR_LIMIT("%s failed: csum %u != wanted %u", __func__,
 			    (unsigned int) le32_to_cpu(csum_disk),
 			    (unsigned int) le32_to_cpu(bh_le->csum));
 		return -EILSEQ;
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index f44bf974f5a5..1de913c59f58 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -40,7 +40,7 @@ static int node_check(struct dm_block_validator *v,
 	uint32_t flags, nr_entries, max_entries;
 
 	if (dm_block_location(b) != le64_to_cpu(h->blocknr)) {
-		DMERR_LIMIT("node_check failed: blocknr %llu != wanted %llu",
+		DMERR_LIMIT("%s failed: blocknr %llu != wanted %llu", __func__,
 			    le64_to_cpu(h->blocknr), dm_block_location(b));
 		return -ENOTBLK;
 	}
@@ -49,7 +49,7 @@ static int node_check(struct dm_block_validator *v,
 					       block_size - sizeof(__le32),
 					       BTREE_CSUM_XOR));
 	if (csum_disk != h->csum) {
-		DMERR_LIMIT("node_check failed: csum %u != wanted %u",
+		DMERR_LIMIT("%s failed: csum %u != wanted %u", __func__,
 			    le32_to_cpu(csum_disk), le32_to_cpu(h->csum));
 		return -EILSEQ;
 	}
@@ -60,12 +60,12 @@ static int node_check(struct dm_block_validator *v,
 
 	if (sizeof(struct node_header) +
 	    (sizeof(__le64) + value_size) * max_entries > block_size) {
-		DMERR_LIMIT("node_check failed: max_entries too large");
+		DMERR_LIMIT("%s failed: max_entries too large", __func__);
 		return -EILSEQ;
 	}
 
 	if (nr_entries > max_entries) {
-		DMERR_LIMIT("node_check failed: too many entries");
+		DMERR_LIMIT("%s failed: too many entries", __func__);
 		return -EILSEQ;
 	}
 
@@ -74,7 +74,7 @@ static int node_check(struct dm_block_validator *v,
 	 */
 	flags = le32_to_cpu(h->flags);
 	if (!(flags & INTERNAL_NODE) && !(flags & LEAF_NODE)) {
-		DMERR_LIMIT("node_check failed: node is neither INTERNAL or LEAF");
+		DMERR_LIMIT("%s failed: node is neither INTERNAL or LEAF", __func__);
 		return -EILSEQ;
 	}
 
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 01a82b17c07c..cc7e06a026ae 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -42,7 +42,7 @@ static int index_check(struct dm_block_validator *v,
 	__le32 csum_disk;
 
 	if (dm_block_location(b) != le64_to_cpu(mi_le->blocknr)) {
-		DMERR_LIMIT("index_check failed: blocknr %llu != wanted %llu",
+		DMERR_LIMIT("%s failed: blocknr %llu != wanted %llu", __func__,
 			    le64_to_cpu(mi_le->blocknr), dm_block_location(b));
 		return -ENOTBLK;
 	}
@@ -51,7 +51,7 @@ static int index_check(struct dm_block_validator *v,
 					       block_size - sizeof(__le32),
 					       INDEX_CSUM_XOR));
 	if (csum_disk != mi_le->csum) {
-		DMERR_LIMIT("index_check failed: csum %u != wanted %u",
+		DMERR_LIMIT("i%s failed: csum %u != wanted %u", __func__,
 			    le32_to_cpu(csum_disk), le32_to_cpu(mi_le->csum));
 		return -EILSEQ;
 	}
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

