Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795561626;
	b=Fe4s4FFbTw1+1sB0IX3C0xgOiw4Bz1yDUUvvskyyH6zPTQuguk8wsyfaKXWMN6I+NeTu
	 nWPWb+IXEAzZCxnraPvslV/dh/1Tdo+33XTJzLfotKUMH/KPyYj/kaQIBpkaeOLOQPIoN
	 IhzSeFQJvRVyAOSvcTPN3iFFKBcoWEnwfSoj+fCL74e3rU6p44UxG5v6EGFyIOOf2D211
	 du7r0BRFjv+1xP1d+TTVfzAxgCU+OJIowMtTqRpXD1twKy7lMMGeYqtQ/pd3fcELqSbwI
	 I61k3Pbmqep/MYtTFZlVnwJtfOsiK4u83wSEN/UwN0IEn3TWfQn2/E7UFWrdFwlgvpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795561626;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=N1C9emfMlcqkHQeSCaMahDT4SkCup2CktAtZ6rAmMTY=;
	b=TNGbfKGFG3/oNJnFITVUSNV0Hw1muo1iQtgspAyC2zdNGcnXgRiJF4oyfi1A5g93pUhh
	 USReedguOw+oG6UYxnJ/kWTDACWGTI3g5r/8dcdbOya8ewlHHCqPEckNLrmAAuZloJJkP
	 xY4IwlwRZX7rAYzal9+Qr1ji2bhnaU9hp2uO39r3UKxAhMeWLbnH2Nwgse+fJk44+lDPH
	 RDvCQ3DIa68WTd5KO0iBC7q/HXRgAdVwqkfq+qPyy8p1FkYdoTDAVLFockAfh0wY2z7gs
	 xS0bDcXpx/28U5XtLxbgmsskm2uwKTclZ2YXZBGfQVYEFZlbllZk1prSB9ybHCOQgag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qfo+SrTY;
	arc=none smtp.remote-ip=209.85.215.173
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C22606A31E
	for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 23:07:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95C22606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qfo+SrTY
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso1956715a12.2
        for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 15:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795561625; x=1796166425; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=N1C9emfMlcqkHQeSCaMahDT4SkCup2CktAtZ6rAmMTY=;
        b=qfo+SrTYXkQgjI/jH5IKTFFddiM0b9jHbuJq+0cvjRIsFFPqKwtliZkbI78M5IsnqJ
         MscM9OSOThESYXJTWcQzzJmEEpViYp8uxz42oLNbc72NaiW2gJoXewfS6gQJQ/4Wscag
         rcKouS+Rlh3qES/1rYAmCSmkqBW0V+X2jns57Tej7wvHgvzgsOo6mzJzpSRx+GCSmgIp
         zCX5trNn1fghK5cbFBbXeAstl2nMcE2vAPRN5e8FXKQTu28K/EzKfEGH73OxWSr7U/Aa
         kaJldXuHuwhDqZQrkp9M4yyOhdA3MNEnAlFBrSrDSMLxx/blQjoPqRNZrfiewRfXtbKp
         Pf6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795561625; x=1796166425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N1C9emfMlcqkHQeSCaMahDT4SkCup2CktAtZ6rAmMTY=;
        b=fUOuFSbtCFdlbE8ghgXi+FdIyEGEDZXLqX3CTpk6o8Bizlei1AwjJlIc5WxSF32ABp
         jsPo7aPmMNlrfO1xlCVYbLT3PWvWjW9C8bZumBaeT5MLjcWtIqVqpk9B8E3oUXPbRApD
         HujbhpkaAB4ss4yZYXkQv1qT2z1PxF3cvaYXi9uPZX9iY/mIY1I4SAv8OJuGOSUFe+J0
         0B8pUb0C7DB4/gOyeQtzpD7P4Zl63YhZg7dq9evcpd+dSWvS4QgyqlNSJkIEcGeAW7ld
         j3fxUqHGer35LGiyaDc9U2OtEpaXoBZYTyPnTFRwWFf/7pVvcqA5DzcBRk1xs9aM5Vwc
         fImg==
X-Gm-Message-State: APuU4Z+poPEI51+adYcDddU/CtDJOjcztGKjZcTT7/wQqK8u5fsJK+Gb
	QHzMnxiY+mPgxo9QFW/fQRRDaeMxQJ2VZOnjVIIDG6cw4Yh+YdSNGsSod/xb0g==
X-Gm-Gg: AZFdTZdZcByZtrzcHljBvhzr5O9dFSAuWnUI4M+5HfHB4lV03JMi1aUEou1Z4m92IFX
	irAbGlz2pCFG79R3vjlj+8u1qtvQdJVn8x/z8qn4i2pg4gh82JQ+3y0+GOWhbu8+l0tjhdbIwKE
	SLL7Ly9Ik4/Gp/8+Q9BuoKhdJC0kmcVFqM0IEKgv7CIsTqxdrFdLrJFC7OVvOhE3immwlHUJ2DQ
	BR09qYXV7j8OtTrRjLbDNlP53DrIUMlYjSPBkSdVOum4fG67bk+EXwpe/JWdmlei6VNUd8tjnyW
	e/YwjRSwgF7pCZw99omIjmbC8hV4y2h1wRXUp+aIDueHhHLdMT7iK8aOitgcY6ErhEl9Isbwhoy
	jIFo7kNTP9AM5scXKLSHKAAH4lz0y9ZgOHC9C/NyG2tXFqmjSNtwr3yS6j7XrUS2qy9EoET2OLE
	y1XUOoGnTDYlw4GE754ZDb988VRzkIoMx0YtYidUxZodPAinuLCJ8GUozbWm2Pk1vlk6iXcLz1J
	/iCgONDmueyn9XE8cYXEbgxjVt1r6V+hDhIXwLNWiM+avYUK0KITsav+aXkv5827fZQfHCPTM55
	ogkZdPlrb74/LDJdKkzpOSgH8OrRO5UVoOtMzTmSs0RCGDY5bM6LPOjvdgmNUDoYcnRu/wvpAh4
	A6HtWXvWcouoZM6WcuZKyZfXehWfG7t1Jd/DBaEngVU7BXdLVg4ZD+g==
X-Received: by 2002:a17:90b:390b:b0:3b3:b858:cc92 with SMTP id 98e67ed59e1d1-3b41c97ac6bmr14728424a91.63.1795561624403;
        Tue, 24 Nov 2026 15:07:04 -0800 (PST)
Received: from fedora (n49-177-87-40.rdl1.qld.optusnet.com.au. [49.177.87.40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a34asm24184445a91.3.2026.11.24.15.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 15:07:03 -0800 (PST)
From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	ejt@redhat.com,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [PATCH v2] dm era: add lazy mode
Date: Wed, 25 Nov 2026 09:06:51 +1000
Message-ID: <20261124230651.494303-1-ronniesahlberg@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first write to a block in each era is deferred to the worker, which
records the block in the on-disk writeset and commits the metadata before
the write is issued.  This makes tracking crash safe, but every batch of
first writes waits for a metadata commit, including two cache flushes of
the metadata device.

Add an optional "lazy" mode which trades that cost for a full resync
after a crash, the same trade MD RAID makes without a write-intent
bitmap:

  era <metadata dev> <origin dev> <block size> [<#feature args> [lazy]
      [clean_delay <ms>]]

In lazy mode era_map() marks new blocks in core only and lets the write
through.  The bits are recorded in a second "pending" bitmap and written
to the on-disk writeset with the next metadata commit.

While in-core bits may not be on disk, the superblock carries a new
dirty flag (bit 1; bit 0 is "clean shutdown" in thin-provisioning-tools)
and is written as metadata version 2, so kernels without lazy mode
refuse to open it instead of trusting incomplete writesets.  Clean
metadata is still written as version 1.

The metadata is marked dirty by the worker before the first write to a
new block after it was clean; until that commit has succeeded such bios
are deferred as before.  It is marked clean on suspend, and after
clean_delay milliseconds (default 1000, 0 disables) without writes to
new blocks: era_map() is stopped from marking new blocks, an RCU grace
period waits for calls already marking, and the pending bits are
committed together with the clean flag.  So a crash while idle loses
nothing, and each idle to busy transition costs one commit.

If the metadata is found dirty on activation, with or without lazy mode,
the new era starts with every block marked, on disk and in core, in the
same commit that clears the flag.  era_invalidate then reports every
block for any era since the crash.

Because era_map() no longer goes through the worker, an era rollover in
lazy mode switches era_map() to the new writeset, and waits for an RCU
grace period, before writing out and archiving the old one.  If
archiving fails the metadata is kept marked dirty, and the next era,
whether started by a message or on activation, has every block marked
instead of losing writes.

Without the lazy feature argument the target behaves as before.

Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
Changes in v2 (from the Sashiko review of v1):
 - Keep the superblock dirty while the invalidation is pending, so the
   resize commit in era_preresume() can't mark crashed metadata clean
   before the invalidated era is committed.
 - After a failed archive, the next rollover (also one started by a
   checkpoint or take_metadata_snap message) starts an era with every
   block marked, not only the next activation.
 - Clear the invalidation flags before the rollover's commit, so the
   metadata is marked clean afterwards.
 - Free the old writeset's on-disk bitset if archiving it fails.
 - Wake the worker after messages archived writesets, so they are
   digested in lazy mode, where writes don't go through the worker.
 - Only set lazy_activity if it isn't set already.

v1: https://lore.kernel.org/dm-devel/20261124051653.346631-1-ronniesahlberg@gmail.com/

This depends on a matching thin-provisioning-tools change, so that
era_check, era_dump, era_restore and era_repair handle the new dirty
flag and version 2 metadata, and era_invalidate reports every block
for crashed metadata:
https://github.com/jthornber/thin-provisioning-tools/pull/332

The two only make sense together: without the tools change, era_check
rejects dirty metadata, and era_restore/era_repair would silently mark
crashed metadata clean.

This patch was developed with an AI coding assistant (Claude), which
wrote the implementation and documentation from my design notes; I
reviewed and directed the changes.

Tested on 7.4-rc4 in a VM with lockdep and PROVE_RCU enabled:
 - table parsing,
 - dirty/clean transitions, checked on the on-disk superblock,
 - era_invalidate accuracy across checkpoints,
 - simulated crashes (metadata device swapped to dm-error) while
   dirty and while clean,
 - a non-lazy table on dirty metadata,
 - digestion of writesets archived by a checkpoint in lazy mode
   (new in v2, fails on v1),
 - fio random writes covering every block once while checkpoint and
   take_metadata_snap run concurrently.
The archive and commit failure paths changed in v2 are not covered by
tests; they need a metadata write failure at an exact point.
No performance numbers: the test VM's disk is not suitable.

 .../admin-guide/device-mapper/era.rst         |  35 +-
 drivers/md/dm-era-target.c                    | 431 ++++++++++++++++--
 2 files changed, 437 insertions(+), 29 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/era.rst b/Documentation/admin-guide/device-mapper/era.rst
index 90dd5c670b9f..8de71cff25b9 100644
--- a/Documentation/admin-guide/device-mapper/era.rst
+++ b/Documentation/admin-guide/device-mapper/era.rst
@@ -18,15 +18,48 @@ coherency after rolling back a vendor snapshot.
 Constructor
 ===========
 
-era <metadata dev> <origin dev> <block size>
+era <metadata dev> <origin dev> <block size> [<#feature args> [<arg>]*]
 
  ================ ======================================================
  metadata dev     fast device holding the persistent metadata
  origin dev	  device holding data blocks that may change
  block size       block size of origin data device, granularity that is
 		  tracked by the target
+ #feature args    number of feature arguments that follow
  ================ ======================================================
 
+Optional feature arguments are:
+
+ ================ ======================================================
+ lazy             Track writes in memory only, and write the tracking
+		  information to the metadata device later.  See
+		  "Lazy mode" below.
+ clean_delay <ms> Lazy mode only.  Mark the metadata clean after this
+		  many milliseconds without a write to a block that is
+		  not already marked in the current era.  0 means the
+		  metadata is only marked clean on suspend.  Default 1000.
+ ================ ======================================================
+
+Lazy mode
+=========
+
+By default the first write to each block in an era waits for the block to
+be recorded on the metadata device, which costs a metadata commit.
+
+In lazy mode writes are never delayed by metadata updates.  Instead, the
+metadata is marked dirty before the first write after it was clean, and
+marked clean again once all tracking information has been written: on
+suspend, and after clean_delay milliseconds without writes to new blocks.
+
+If the target is activated and the metadata is still marked dirty, the
+tracking information from before the unclean shutdown may be incomplete.
+The new era then starts with every block marked as written, so the next
+era_invalidate reports the whole device.
+
+This check is done whether or not the new table uses lazy mode.  While
+the metadata is dirty it carries metadata format version 2, which kernels
+without lazy mode support refuse to open.  Clean metadata uses version 1.
+
 Messages
 ========
 
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index ea499adca4ce..298b376ff785 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -18,10 +18,19 @@
 #define SUPERBLOCK_MAGIC 2126579579
 #define SUPERBLOCK_CSUM_XOR 146538381
 #define MIN_ERA_VERSION 1
-#define MAX_ERA_VERSION 1
+#define MAX_ERA_VERSION 2
 #define INVALID_WRITESET_ROOT SUPERBLOCK_LOCATION
 #define MIN_BLOCK_SIZE 8
 
+/*
+ * A dirty superblock is written as version 2, so kernels without lazy mode
+ * refuse to open it.  Flag bit 0 is "clean shutdown" in the userland tools.
+ */
+#define ERA_VERSION_LAZY_DIRTY 2
+#define SUPERBLOCK_FLAG_LAZY_DIRTY (1U << 1)
+
+#define DEFAULT_CLEAN_DELAY_MS 1000
+
 /*
  *--------------------------------------------------------------
  * Writeset
@@ -40,6 +49,11 @@ struct writeset {
 	 * disk.
 	 */
 	unsigned long *bits;
+
+	/*
+	 * Lazy mode only: bits set in core, but not yet in the on disk bitset.
+	 */
+	unsigned long *pending;
 };
 
 /*
@@ -50,10 +64,13 @@ static void writeset_free(struct writeset *ws)
 {
 	vfree(ws->bits);
 	ws->bits = NULL;
+	vfree(ws->pending);
+	ws->pending = NULL;
 }
 
 static int setup_on_disk_bitset(struct dm_disk_bitset *info,
-				unsigned int nr_bits, dm_block_t *root)
+				unsigned int nr_bits, bool value,
+				dm_block_t *root)
 {
 	int r;
 
@@ -61,7 +78,7 @@ static int setup_on_disk_bitset(struct dm_disk_bitset *info,
 	if (r)
 		return r;
 
-	return dm_bitset_resize(info, *root, 0, nr_bits, false, root);
+	return dm_bitset_resize(info, *root, 0, nr_bits, value, root);
 }
 
 static size_t bitset_size(unsigned int nr_bits)
@@ -72,7 +89,7 @@ static size_t bitset_size(unsigned int nr_bits)
 /*
  * Allocates memory for the in core bitset.
  */
-static int writeset_alloc(struct writeset *ws, dm_block_t nr_blocks)
+static int writeset_alloc(struct writeset *ws, dm_block_t nr_blocks, bool lazy)
 {
 	ws->bits = vzalloc(bitset_size(nr_blocks));
 	if (!ws->bits) {
@@ -80,21 +97,33 @@ static int writeset_alloc(struct writeset *ws, dm_block_t nr_blocks)
 		return -ENOMEM;
 	}
 
+	if (lazy) {
+		ws->pending = vzalloc(bitset_size(nr_blocks));
+		if (!ws->pending) {
+			DMERR("%s: couldn't allocate pending bitset", __func__);
+			writeset_free(ws);
+			return -ENOMEM;
+		}
+	}
+
 	return 0;
 }
 
 /*
- * Wipes the in-core bitset, and creates a new on disk bitset.
+ * Resets the in-core bitset, and creates a new on disk bitset, with every
+ * bit set to value.
  */
 static int writeset_init(struct dm_disk_bitset *info, struct writeset *ws,
-			 dm_block_t nr_blocks)
+			 dm_block_t nr_blocks, bool value)
 {
 	int r;
 
-	memset(ws->bits, 0, bitset_size(nr_blocks));
+	memset(ws->bits, value ? 0xff : 0, bitset_size(nr_blocks));
+	if (ws->pending)
+		memset(ws->pending, 0, bitset_size(nr_blocks));
 
 	ws->md.nr_bits = nr_blocks;
-	r = setup_on_disk_bitset(info, ws->md.nr_bits, &ws->md.root);
+	r = setup_on_disk_bitset(info, ws->md.nr_bits, value, &ws->md.root);
 	if (r) {
 		DMERR("%s: setup_on_disk_bitset failed", __func__);
 		return r;
@@ -301,6 +330,20 @@ struct era_metadata {
 	 */
 	bool archived_writesets;
 
+	/*
+	 * Lazy mode.  lazy_dirty is the dirty flag for the next commit, and
+	 * era_map() only marks new blocks itself while lazy_gate_open is set.
+	 */
+	bool lazy;
+	bool lazy_dirty;
+	bool lazy_gate_open;
+	atomic_t lazy_activity;
+
+	/* Writes may have been lost, so never mark the metadata clean. */
+	bool tracking_lost;
+
+	bool needs_invalidate;
+
 	/*
 	 * Reading the space map root can fail, so we read it into this
 	 * buffer before the superblock is locked and updated.
@@ -505,11 +548,17 @@ static void copy_sm_root(struct era_metadata *md, struct superblock_disk *disk)
 static void prepare_superblock(struct era_metadata *md, struct superblock_disk *disk)
 {
 	disk->magic = cpu_to_le64(SUPERBLOCK_MAGIC);
-	disk->flags = cpu_to_le32(0ul);
+
+	if (md->lazy_dirty || md->tracking_lost || md->needs_invalidate) {
+		disk->flags = cpu_to_le32(SUPERBLOCK_FLAG_LAZY_DIRTY);
+		disk->version = cpu_to_le32(ERA_VERSION_LAZY_DIRTY);
+	} else {
+		disk->flags = cpu_to_le32(0ul);
+		disk->version = cpu_to_le32(MIN_ERA_VERSION);
+	}
 
 	/* FIXME: can't keep blanking the uuid (uuid is currently unused though) */
 	memset(disk->uuid, 0, sizeof(disk->uuid));
-	disk->version = cpu_to_le32(MAX_ERA_VERSION);
 
 	copy_sm_root(md, disk);
 
@@ -609,6 +658,12 @@ static int open_metadata(struct era_metadata *md)
 	md->metadata_snap = le64_to_cpu(disk->metadata_snap);
 	md->archived_writesets = true;
 
+	if (le32_to_cpu(disk->version) >= ERA_VERSION_LAZY_DIRTY ||
+	    (le32_to_cpu(disk->flags) & SUPERBLOCK_FLAG_LAZY_DIRTY)) {
+		DMWARN("metadata was not shut down cleanly, all blocks will be marked as written");
+		md->needs_invalidate = true;
+	}
+
 	dm_bm_unlock(sblock);
 
 	return 0;
@@ -805,7 +860,7 @@ static int metadata_digest_start(struct era_metadata *md, struct digest *d)
  */
 static struct era_metadata *metadata_open(struct block_device *bdev,
 					  sector_t block_size,
-					  bool may_format)
+					  bool may_format, bool lazy)
 {
 	int r;
 	struct era_metadata *md = kzalloc_obj(*md);
@@ -817,6 +872,8 @@ static struct era_metadata *metadata_open(struct block_device *bdev,
 
 	md->bdev = bdev;
 	md->block_size = block_size;
+	md->lazy = lazy;
+	atomic_set(&md->lazy_activity, 0);
 
 	md->writesets[0].md.root = INVALID_WRITESET_ROOT;
 	md->writesets[1].md.root = INVALID_WRITESET_ROOT;
@@ -863,13 +920,13 @@ static int metadata_resize(struct era_metadata *md, void *arg)
 	writeset_free(&md->writesets[0]);
 	writeset_free(&md->writesets[1]);
 
-	r = writeset_alloc(&md->writesets[0], *new_size);
+	r = writeset_alloc(&md->writesets[0], *new_size, md->lazy);
 	if (r) {
 		DMERR("%s: writeset_alloc failed for writeset 0", __func__);
 		return r;
 	}
 
-	r = writeset_alloc(&md->writesets[1], *new_size);
+	r = writeset_alloc(&md->writesets[1], *new_size, md->lazy);
 	if (r) {
 		DMERR("%s: writeset_alloc failed for writeset 1", __func__);
 		writeset_free(&md->writesets[0]);
@@ -892,22 +949,60 @@ static int metadata_resize(struct era_metadata *md, void *arg)
 	return 0;
 }
 
-static int metadata_era_archive(struct era_metadata *md)
+/*
+ * Lazy mode: copy the pending bits to the on disk bitset.  Bits set while
+ * we're doing this stay pending for the next commit.
+ */
+static int writeset_sync_pending(struct era_metadata *md, struct writeset *ws)
+{
+	int r;
+	unsigned int i, nr_words;
+	unsigned long word, bit;
+
+	if (!ws->pending || ws->md.root == INVALID_WRITESET_ROOT)
+		return 0;
+
+	nr_words = dm_div_up(min_t(dm_block_t, ws->md.nr_bits, md->nr_blocks),
+			     BITS_PER_LONG);
+	for (i = 0; i < nr_words; i++) {
+		if (!READ_ONCE(ws->pending[i]))
+			continue;
+
+		word = xchg(&ws->pending[i], 0);
+		while (word) {
+			bit = __ffs(word);
+			r = dm_bitset_set_bit(&md->bitset_info, ws->md.root,
+					      i * BITS_PER_LONG + bit,
+					      &ws->md.root);
+			if (r) {
+				DMERR("%s: dm_bitset_set_bit failed", __func__);
+				for_each_set_bit(bit, &word, BITS_PER_LONG)
+					set_bit(i * BITS_PER_LONG + bit, ws->pending);
+				return r;
+			}
+			word &= word - 1;
+		}
+	}
+
+	return 0;
+}
+
+static int __metadata_era_archive(struct era_metadata *md,
+				  struct writeset *ws, uint32_t era)
 {
 	int r;
 	uint64_t keys[1];
 	struct writeset_disk value;
 
-	r = dm_bitset_flush(&md->bitset_info, md->current_writeset->md.root,
-			    &md->current_writeset->md.root);
+	r = dm_bitset_flush(&md->bitset_info, ws->md.root, &ws->md.root);
 	if (r) {
 		DMERR("%s: dm_bitset_flush failed", __func__);
 		return r;
 	}
 
-	ws_pack(&md->current_writeset->md, &value);
+	ws_pack(&ws->md, &value);
 
-	keys[0] = md->current_era;
+	keys[0] = era;
 	__dm_bless_for_disk(&value);
 	r = dm_btree_insert(&md->writeset_tree_info, md->writeset_tree_root,
 			    keys, &value, &md->writeset_tree_root);
@@ -917,12 +1012,23 @@ static int metadata_era_archive(struct era_metadata *md)
 		return r;
 	}
 
-	md->current_writeset->md.root = INVALID_WRITESET_ROOT;
+	ws->md.root = INVALID_WRITESET_ROOT;
 	md->archived_writesets = true;
 
 	return 0;
 }
 
+static int metadata_era_archive(struct era_metadata *md)
+{
+	int r;
+
+	r = writeset_sync_pending(md, md->current_writeset);
+	if (r)
+		return r;
+
+	return __metadata_era_archive(md, md->current_writeset, md->current_era);
+}
+
 static struct writeset *next_writeset(struct era_metadata *md)
 {
 	return (md->current_writeset == &md->writesets[0]) ?
@@ -934,7 +1040,8 @@ static int metadata_new_era(struct era_metadata *md)
 	int r;
 	struct writeset *new_writeset = next_writeset(md);
 
-	r = writeset_init(&md->bitset_info, new_writeset, md->nr_blocks);
+	r = writeset_init(&md->bitset_info, new_writeset, md->nr_blocks,
+			  md->needs_invalidate);
 	if (r) {
 		DMERR("%s: writeset_init failed", __func__);
 		return r;
@@ -946,7 +1053,47 @@ static int metadata_new_era(struct era_metadata *md)
 	return 0;
 }
 
-static int metadata_era_rollover(struct era_metadata *md)
+/*
+ * era_map() sets bits without the worker in lazy mode, so switch it to the
+ * new writeset before archiving the old one.
+ */
+static int metadata_era_rollover_lazy(struct era_metadata *md)
+{
+	int r;
+	struct writeset *old_writeset = md->current_writeset;
+	struct writeset *new_writeset = next_writeset(md);
+
+	r = writeset_init(&md->bitset_info, new_writeset, md->nr_blocks,
+			  md->needs_invalidate);
+	if (r) {
+		DMERR("%s: writeset_init failed", __func__);
+		return r;
+	}
+
+	swap_writeset(md, new_writeset);
+
+	if (old_writeset->md.root != INVALID_WRITESET_ROOT) {
+		r = writeset_sync_pending(md, old_writeset);
+		if (!r)
+			r = __metadata_era_archive(md, old_writeset,
+						   md->current_era);
+		if (r) {
+			DMERR("%s: couldn't archive era %u", __func__,
+			      md->current_era);
+			md->tracking_lost = true;
+			dm_disk_bitset_init(md->tm, &md->bitset_info);
+			dm_bitset_del(&md->bitset_info, old_writeset->md.root);
+			old_writeset->md.root = INVALID_WRITESET_ROOT;
+			return r;
+		}
+	}
+
+	md->current_era++;
+
+	return 0;
+}
+
+static int __metadata_era_rollover(struct era_metadata *md)
 {
 	int r;
 
@@ -969,6 +1116,28 @@ static int metadata_era_rollover(struct era_metadata *md)
 	return 0;
 }
 
+static int metadata_era_rollover(struct era_metadata *md)
+{
+	int r;
+
+	/* Writes may have been lost, so mark every block in the new era. */
+	if (md->tracking_lost)
+		md->needs_invalidate = true;
+
+	if (md->lazy)
+		r = metadata_era_rollover_lazy(md);
+	else
+		r = __metadata_era_rollover(md);
+
+	/* Cleared before the commit, which marks the metadata clean. */
+	if (!r && md->needs_invalidate) {
+		md->needs_invalidate = false;
+		md->tracking_lost = false;
+	}
+
+	return r;
+}
+
 static bool metadata_current_marked(struct era_metadata *md, dm_block_t block)
 {
 	bool r;
@@ -982,12 +1151,42 @@ static bool metadata_current_marked(struct era_metadata *md, dm_block_t block)
 	return r;
 }
 
+/*
+ * Returns false if the bio must wait for the metadata to be marked dirty.
+ */
+static bool metadata_lazy_mark(struct era_metadata *md, dm_block_t block)
+{
+	bool r = true;
+	struct writeset *ws;
+
+	rcu_read_lock();
+	ws = rcu_dereference(md->current_writeset);
+	if (!test_bit(block, ws->bits)) {
+		if (!READ_ONCE(md->lazy_gate_open))
+			r = false;
+		else if (!test_and_set_bit(block, ws->bits)) {
+			set_bit(block, ws->pending);
+			if (!atomic_read(&md->lazy_activity))
+				atomic_set(&md->lazy_activity, 1);
+		}
+	}
+	rcu_read_unlock();
+
+	return r;
+}
+
 static int metadata_commit(struct era_metadata *md)
 {
 	int r;
 	struct dm_block *sblock;
 
 	if (md->current_writeset->md.root != INVALID_WRITESET_ROOT) {
+		r = writeset_sync_pending(md, md->current_writeset);
+		if (r) {
+			DMERR("%s: writing pending bits failed", __func__);
+			return r;
+		}
+
 		r = dm_bitset_flush(&md->bitset_info, md->current_writeset->md.root,
 				    &md->current_writeset->md.root);
 		if (r) {
@@ -1019,6 +1218,25 @@ static int metadata_commit(struct era_metadata *md)
 	return dm_tm_commit(md->tm, sblock);
 }
 
+static int metadata_lazy_close(struct era_metadata *md)
+{
+	int r;
+
+	WRITE_ONCE(md->lazy_gate_open, false);
+
+	/* Wait for era_map() calls that saw the gate open. */
+	synchronize_rcu();
+
+	md->lazy_dirty = false;
+	r = metadata_commit(md);
+	if (r) {
+		/* Unknown state on disk, keep the gate closed. */
+		md->lazy_dirty = true;
+	}
+
+	return r;
+}
+
 static int metadata_checkpoint(struct era_metadata *md)
 {
 	/*
@@ -1190,6 +1408,9 @@ struct era {
 	struct workqueue_struct *wq;
 	struct work_struct worker;
 
+	unsigned int clean_delay_ms;
+	struct delayed_work clean_work;
+
 	spinlock_t deferred_lock;
 	struct bio_list deferred_bios;
 
@@ -1266,6 +1487,63 @@ static void process_old_eras(struct era *era)
 		wake_worker(era);
 }
 
+static void schedule_clean(struct era *era)
+{
+	if (era->clean_delay_ms && !atomic_read(&era->suspended))
+		queue_delayed_work(era->wq, &era->clean_work,
+				   msecs_to_jiffies(era->clean_delay_ms));
+}
+
+static void do_clean(struct work_struct *ws)
+{
+	struct era *era = container_of(to_delayed_work(ws), struct era, clean_work);
+	struct era_metadata *md = era->md;
+
+	if (atomic_read(&era->suspended) || !md->lazy_gate_open)
+		return;
+
+	if (atomic_xchg(&md->lazy_activity, 0)) {
+		schedule_clean(era);
+		return;
+	}
+
+	if (metadata_lazy_close(md))
+		DMERR_LIMIT("%s: couldn't mark metadata clean", __func__);
+}
+
+static void process_deferred_bios_lazy(struct era *era, struct bio_list *bios)
+{
+	struct era_metadata *md = era->md;
+	struct writeset *ws;
+	struct blk_plug plug;
+	struct bio *bio;
+	dm_block_t block;
+
+	if (!md->lazy_gate_open) {
+		md->lazy_dirty = true;
+		if (metadata_commit(md)) {
+			DMERR_LIMIT("%s: couldn't mark metadata dirty", __func__);
+			while ((bio = bio_list_pop(bios)))
+				bio_io_error(bio);
+			return;
+		}
+		WRITE_ONCE(md->lazy_gate_open, true);
+		schedule_clean(era);
+	}
+
+	ws = md->current_writeset;
+	blk_start_plug(&plug);
+	while ((bio = bio_list_pop(bios))) {
+		block = get_block(era, bio);
+		if (!test_and_set_bit(block, ws->bits))
+			set_bit(block, ws->pending);
+		submit_bio_noacct(bio);
+	}
+	blk_finish_plug(&plug);
+
+	atomic_set(&md->lazy_activity, 1);
+}
+
 static void process_deferred_bios(struct era *era)
 {
 	int r;
@@ -1286,6 +1564,11 @@ static void process_deferred_bios(struct era *era)
 	if (bio_list_empty(&deferred_bios))
 		return;
 
+	if (era->md->lazy) {
+		process_deferred_bios_lazy(era, &deferred_bios);
+		return;
+	}
+
 	while ((bio = bio_list_pop(&deferred_bios))) {
 		r = writeset_test_and_set(&era->md->bitset_info, ws,
 					  get_block(era, bio));
@@ -1369,6 +1652,10 @@ static void do_work(struct work_struct *ws)
 	process_old_eras(era);
 	process_deferred_bios(era);
 	process_rpc_calls(era);
+
+	/* Lazy mode writes don't wake the worker to digest these. */
+	if (era->md->archived_writesets)
+		wake_worker(era);
 }
 
 static void defer_bio(struct era *era, struct bio *bio)
@@ -1428,6 +1715,7 @@ static void start_worker(struct era *era)
 static void stop_worker(struct era *era)
 {
 	atomic_set(&era->suspended, 1);
+	cancel_delayed_work_sync(&era->clean_work);
 	drain_workqueue(era->wq);
 }
 
@@ -1466,17 +1754,78 @@ static bool valid_block_size(dm_block_t block_size)
 	return greater_than_zero && multiple_of_min_block_size;
 }
 
+static int parse_features(struct era *era, struct dm_arg_set *as,
+			  char **error)
+{
+	int r;
+	unsigned int argc;
+	const char *arg;
+	bool lazy = false, clean_delay_set = false;
+	static const struct dm_arg _args[] = {
+		{0, 3, "Invalid number of feature arguments"},
+	};
+
+	era->clean_delay_ms = 0;
+
+	if (!as->argc)
+		return 0;
+
+	r = dm_read_arg_group(_args, as, &argc, error);
+	if (r)
+		return -EINVAL;
+
+	while (argc) {
+		arg = dm_shift_arg(as);
+		argc--;
+
+		if (!strcasecmp(arg, "lazy")) {
+			lazy = true;
+
+		} else if (!strcasecmp(arg, "clean_delay") && argc) {
+			arg = dm_shift_arg(as);
+			argc--;
+			if (kstrtouint(arg, 10, &era->clean_delay_ms)) {
+				*error = "Invalid clean_delay";
+				return -EINVAL;
+			}
+			clean_delay_set = true;
+
+		} else {
+			*error = "Unrecognised era feature requested";
+			return -EINVAL;
+		}
+	}
+
+	if (as->argc) {
+		*error = "Invalid argument count";
+		return -EINVAL;
+	}
+
+	if (clean_delay_set && !lazy) {
+		*error = "clean_delay requires lazy";
+		return -EINVAL;
+	}
+
+	if (lazy && !clean_delay_set)
+		era->clean_delay_ms = DEFAULT_CLEAN_DELAY_MS;
+
+	return lazy;
+}
+
 /*
  * <metadata dev> <data dev> <data block size (sectors)>
+ * [<#feature args> [lazy] [clean_delay <ms>]]
  */
 static int era_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r;
 	char dummy;
+	bool lazy;
 	struct era *era;
 	struct era_metadata *md;
+	struct dm_arg_set as;
 
-	if (argc != 3) {
+	if (argc < 3) {
 		ti->error = "Invalid argument count";
 		return -EINVAL;
 	}
@@ -1489,6 +1838,15 @@ static int era_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	era->ti = ti;
 
+	as.argc = argc - 3;
+	as.argv = argv + 3;
+	r = parse_features(era, &as, &ti->error);
+	if (r < 0) {
+		era_destroy(era);
+		return r;
+	}
+	lazy = r;
+
 	r = dm_get_device(ti, argv[0], BLK_OPEN_READ | BLK_OPEN_WRITE,
 			  &era->metadata_dev);
 	if (r) {
@@ -1529,7 +1887,8 @@ static int era_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	else
 		era->sectors_per_block_shift = __ffs(era->sectors_per_block);
 
-	md = metadata_open(era->metadata_dev->bdev, era->sectors_per_block, true);
+	md = metadata_open(era->metadata_dev->bdev, era->sectors_per_block,
+			   true, lazy);
 	if (IS_ERR(md)) {
 		ti->error = "Error reading metadata";
 		era_destroy(era);
@@ -1544,6 +1903,7 @@ static int era_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -ENOMEM;
 	}
 	INIT_WORK(&era->worker, do_work);
+	INIT_DELAYED_WORK(&era->clean_work, do_clean);
 
 	spin_lock_init(&era->deferred_lock);
 	bio_list_init(&era->deferred_bios);
@@ -1582,10 +1942,15 @@ static int era_map(struct dm_target *ti, struct bio *bio)
 	 * REQ_PREFLUSH bios carry no data, so we're not interested in them.
 	 */
 	if (!(bio->bi_opf & REQ_PREFLUSH) &&
-	    (bio_data_dir(bio) == WRITE) &&
-	    !metadata_current_marked(era->md, block)) {
-		defer_bio(era, bio);
-		return DM_MAPIO_SUBMITTED;
+	    (bio_data_dir(bio) == WRITE)) {
+		bool marked = era->md->lazy ?
+			metadata_lazy_mark(era->md, block) :
+			metadata_current_marked(era->md, block);
+
+		if (!marked) {
+			defer_bio(era, bio);
+			return DM_MAPIO_SUBMITTED;
+		}
 	}
 
 	return DM_MAPIO_REMAPPED;
@@ -1600,10 +1965,18 @@ static void era_postsuspend(struct dm_target *ti)
 	if (r) {
 		DMERR("%s: couldn't archive current era", __func__);
 		/* FIXME: fail mode */
+		if (era->md->lazy)
+			era->md->tracking_lost = true;
 	}
 
 	stop_worker(era);
 
+	if (era->md->lazy) {
+		/* No io is in flight, and every marked block is on disk. */
+		WRITE_ONCE(era->md->lazy_gate_open, false);
+		era->md->lazy_dirty = false;
+	}
+
 	r = metadata_commit(era->md);
 	if (r) {
 		DMERR("%s: metadata_commit failed", __func__);
@@ -1682,6 +2055,8 @@ static void era_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%s ", buf);
 		format_dev_t(buf, era->origin_dev->bdev->bd_dev);
 		DMEMIT("%s %u", buf, era->sectors_per_block);
+		if (era->md->lazy)
+			DMEMIT(" 3 lazy clean_delay %u", era->clean_delay_ms);
 		break;
 
 	case STATUSTYPE_IMA:
@@ -1751,7 +2126,7 @@ static void era_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type era_target = {
 	.name = "era",
-	.version = {1, 0, 0},
+	.version = {1, 1, 0},
 	.module = THIS_MODULE,
 	.ctr = era_ctr,
 	.dtr = era_dtr,
-- 
2.56.0

