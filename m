Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272EB26D4DF
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 01:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772154733; cv=none; b=jh1tclDewSwbxFtSCEvrg+W+o+v7hjAPmhuJUjOF4o2tliq+Fy5iIo6usVHSuRiuuVPIWzdkgyH92yWXnsFvJrafLSlzWdgI1EEbVW1jFm/bC2hXuw+VZTK5WW0/LL0aYDtDRLZNXDPv8Yj8v4I3V5KDFqxMSBz41dvYxRikzvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772154733; c=relaxed/simple;
	bh=Zrgogxbo7g8lT8bEXl+On6HnKvqjOCbozx5CjD4FtP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=bCdDPsQPrUQXDgX6h5NGsTtgDN6TAnj0V6VpLXQdTDMSsNzdfjmGKM1UlxfJS/nzY3kX4ykOtPMWPfO9rWC1bufCSRmML45aAh+67CbVYJqVBFYhDSYiaM4JyGGRsj2x+gCQzosM68vVDs9fJIWl1C5E5dluXn5EDexLuElCc8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=er9UcmRH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="er9UcmRH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772154731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W3CMTPWPKxEiIAotfxrL0v8A18iVwls/LeGJbVnF/OI=;
	b=er9UcmRHnzOCNxb7b50YNZuiErj6Q9lzUTTrwHrEmXlw5BNiWLm3JaG2LzUNMmeji7M/Tk
	5OfsKquciOeOYKmMc98+6YorzM+x/cW8POmVIG8OKjXepuPLzBHr0E+sGKJ7AI7mlkHBU5
	KLi8H+EzFNeqq79u9fYWVcFXouxIanw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-VcAeCs_0OgCyYp-QJwcboQ-1; Thu,
 26 Feb 2026 20:12:09 -0500
X-MC-Unique: VcAeCs_0OgCyYp-QJwcboQ-1
X-Mimecast-MFC-AGG-ID: VcAeCs_0OgCyYp-QJwcboQ_1772154728
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFE751956054
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 01:12:08 +0000 (UTC)
Received: from vdo-builder-raeburn.permabit.com (unknown [10.0.101.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B321D1956053;
	Fri, 27 Feb 2026 01:12:08 +0000 (UTC)
Received: by vdo-builder-raeburn.permabit.com (Postfix, from userid 1065)
	id 40A2325696; Thu, 26 Feb 2026 20:12:08 -0500 (EST)
From: Ken Raeburn <raeburn@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>
Subject: [PATCH 3/3] dm vdo: add __counted_by attribute to a number of structures
Date: Thu, 26 Feb 2026 20:12:08 -0500
Message-ID: <d46ff584e8e77c7d45eaab993169ba837d97ce26.1772153845.git.raeburn@redhat.com>
In-Reply-To: <cover.1772153845.git.raeburn@redhat.com>
References: <cover.1772153845.git.raeburn@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bzPRO98fg2tja5X9HBMGkEfjQPQ0l0du4HvcwjETbBw_1772154728
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This attribute allows the compiler to refine compile-time diagnostics
and run-time sanitizer features with information about the size of the
flexible arrays.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
---
 drivers/md/dm-vdo/block-map.h            | 2 +-
 drivers/md/dm-vdo/dedupe.c               | 2 +-
 drivers/md/dm-vdo/indexer/index.h        | 2 +-
 drivers/md/dm-vdo/indexer/open-chapter.h | 2 +-
 drivers/md/dm-vdo/logical-zone.h         | 2 +-
 drivers/md/dm-vdo/physical-zone.c        | 2 +-
 drivers/md/dm-vdo/repair.c               | 2 +-
 drivers/md/dm-vdo/slab-depot.h           | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.h b/drivers/md/dm-vdo/block-map.h
index 39a13039e4a3..4fd24043b0d7 100644
--- a/drivers/md/dm-vdo/block-map.h
+++ b/drivers/md/dm-vdo/block-map.h
@@ -276,7 +276,7 @@ struct block_map {
 	block_count_t next_entry_count;
 
 	zone_count_t zone_count;
-	struct block_map_zone zones[];
+	struct block_map_zone zones[] __counted_by(zone_count);
 };
 
 /**
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 4e0fefd077d0..5f5639d89bc6 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -296,7 +296,7 @@ struct hash_zones {
 	/* The number of zones */
 	zone_count_t zone_count;
 	/* The hash zones themselves */
-	struct hash_zone zones[];
+	struct hash_zone zones[] __counted_by(zone_count);
 };
 
 /* These are in milliseconds. */
diff --git a/drivers/md/dm-vdo/indexer/index.h b/drivers/md/dm-vdo/indexer/index.h
index edabb239548e..1891f2de508e 100644
--- a/drivers/md/dm-vdo/indexer/index.h
+++ b/drivers/md/dm-vdo/indexer/index.h
@@ -53,7 +53,7 @@ struct uds_index {
 
 	index_callback_fn callback;
 	struct uds_request_queue *triage_queue;
-	struct uds_request_queue *zone_queues[];
+	struct uds_request_queue *zone_queues[] __counted_by(zone_count);
 };
 
 enum request_stage {
diff --git a/drivers/md/dm-vdo/indexer/open-chapter.h b/drivers/md/dm-vdo/indexer/open-chapter.h
index a4250bb19525..ea6d7336aea0 100644
--- a/drivers/md/dm-vdo/indexer/open-chapter.h
+++ b/drivers/md/dm-vdo/indexer/open-chapter.h
@@ -40,7 +40,7 @@ struct open_chapter_zone {
 	/* The number of slots in the hash table */
 	unsigned int slot_count;
 	/* The hash table slots, referencing virtual record numbers */
-	struct open_chapter_zone_slot slots[];
+	struct open_chapter_zone_slot slots[] __counted_by(slot_count);
 };
 
 int __must_check uds_make_open_chapter(const struct index_geometry *geometry,
diff --git a/drivers/md/dm-vdo/logical-zone.h b/drivers/md/dm-vdo/logical-zone.h
index 1b666c84a193..a36a864c6836 100644
--- a/drivers/md/dm-vdo/logical-zone.h
+++ b/drivers/md/dm-vdo/logical-zone.h
@@ -60,7 +60,7 @@ struct logical_zones {
 	/* The number of zones */
 	zone_count_t zone_count;
 	/* The logical zones themselves */
-	struct logical_zone zones[];
+	struct logical_zone zones[] __counted_by(zone_count);
 };
 
 int __must_check vdo_make_logical_zones(struct vdo *vdo,
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index a8c7a57516eb..d6ad8f1a33bb 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -200,7 +200,7 @@ struct pbn_lock_pool {
 	/** @idle_list: A list containing all idle PBN lock instances. */
 	struct list_head idle_list;
 	/** @locks: The memory for all the locks allocated by this pool. */
-	idle_pbn_lock locks[];
+	idle_pbn_lock locks[] __counted_by(capacity);
 };
 
 /**
diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index 43ce65a69e61..bfed62260280 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -127,7 +127,7 @@ struct repair_completion {
 	 * The page completions used for playing the journal into the block map, and, during
 	 * read-only rebuild, for rebuilding the reference counts from the block map.
 	 */
-	struct vdo_page_completion page_completions[];
+	struct vdo_page_completion page_completions[] __counted_by(page_count);
 };
 
 /*
diff --git a/drivers/md/dm-vdo/slab-depot.h b/drivers/md/dm-vdo/slab-depot.h
index fadc0c9d4dc4..6bfd61c937b6 100644
--- a/drivers/md/dm-vdo/slab-depot.h
+++ b/drivers/md/dm-vdo/slab-depot.h
@@ -509,7 +509,7 @@ struct slab_depot {
 	struct slab_summary_entry *summary_entries;
 
 	/* The block allocators for this depot */
-	struct block_allocator allocators[];
+	struct block_allocator allocators[] __counted_by(zone_count);
 };
 
 struct reference_updater;
-- 
2.53.0

