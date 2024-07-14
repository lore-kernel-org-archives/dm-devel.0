Received: from smtp.smtpout.orange.fr (smtp-20.smtpout.orange.fr [80.12.242.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF032171A4
	for <dm-devel@lists.linux.dev>; Sun, 14 Jul 2024 07:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720941816; cv=none; b=NPxKHuJ0AfhQw5R6HO/KXdkEGmQv2CgdCGpJrehW7uZn9sWy1wj1q+x0kkEgdvv8rUOgYCrRYK90dzKP4ubagQnVVNuHrEd3mxVCEaiMrvDy901L3oiBOH6jxqfrWskkBYqSW3l5BfFpI4C89NZMxLXdiTcqn/WVaigJ49mPlxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720941816; c=relaxed/simple;
	bh=X9thnM5+8xDDweqmeDo4ppAH3Lq6Tx8w369a9Hxws4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xu8+v8jMPrRqE2EUSTSVIntMIfSPGwcLFHFbKb9aTYBTl1rQESnYDgZ6HXqXsf4YrJZxTX2Y5Bsf+U1xvgOn2C2TvYEtP5rByq4CjD2XbH6s0CNqiFaGDpKWoREG9yI2ANQOgAf9FvLnfEBbN293weSJn3HkbzQ7Y7H0NaWdGaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=Uqk5fpKG; arc=none smtp.client-ip=80.12.242.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="Uqk5fpKG"
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id StQvsafiXxIArStQwsQE5w; Sun, 14 Jul 2024 09:14:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1720941250;
	bh=EV7rWySTzawDQT/aSvME45z4PjLFbc3Ge9KqxqTJ/Ho=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Uqk5fpKGs5BGjk9oGzRJbzBtwwaZhdTZc+Vq1WGxIs77WcpHsTGc/cixXLrk6nHQx
	 XYC9sNwplapVNj2TSFKXwhFX8H6RdwlKj9DqK4hbIbYxiwYEzf2MwrrPgvgDOeflns
	 e0pncTLcMPgOOT4lImcvSltfz1TKCrEiF/hVI/Lu4VmZ1X437mFD/fymSYI4VKg4QW
	 xITDZb1BlSawO7nC72do3a5vI7i6zPPhgl+i5J5TjjD/INzPY3y9XZ668gi/yNV0Y8
	 4xtG4sBP5C/AjG9W38i/S7PZ2Cazg60tdsIEKOg80m2vdSHZfx63iAm/9lYpG3AECa
	 q6X1vtOun6lyQ==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 14 Jul 2024 09:14:10 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	dm-devel@lists.linux.dev
Subject: [PATCH] dm: Constify struct dm_block_validator
Date: Sun, 14 Jul 2024 09:13:56 +0200
Message-ID: <ddffb49d3ba2d274319faa5c4fbeac48a9914524.1720940992.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct dm_block_validator' are not modified in these drivers.

Constifying this structure moves some data to a read-only section, so
increase overall security.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  32047	    920	     16	  32983	   80d7	drivers/md/dm-cache-metadata.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  32075	    896	     16	  32987	   80db	drivers/md/dm-cache-metadata.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile tested-only.
---
 drivers/md/dm-cache-metadata.c                     |  6 +++---
 drivers/md/dm-clone-metadata.c                     |  6 +++---
 drivers/md/dm-era-target.c                         |  6 +++---
 drivers/md/dm-thin-metadata.c                      |  6 +++---
 drivers/md/persistent-data/dm-array.c              |  6 +++---
 drivers/md/persistent-data/dm-block-manager.c      | 12 ++++++------
 drivers/md/persistent-data/dm-block-manager.h      | 14 ++++++++------
 drivers/md/persistent-data/dm-btree-internal.h     |  2 +-
 drivers/md/persistent-data/dm-btree-spine.c        |  6 +++---
 drivers/md/persistent-data/dm-space-map-common.c   | 12 ++++++------
 .../md/persistent-data/dm-transaction-manager.c    |  8 ++++----
 .../md/persistent-data/dm-transaction-manager.h    |  6 +++---
 12 files changed, 46 insertions(+), 44 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 0ad9dc1824fa..24cd87fddf75 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -170,7 +170,7 @@ struct dm_cache_metadata {
  */
 #define SUPERBLOCK_CSUM_XOR 9031977
 
-static void sb_prepare_for_write(struct dm_block_validator *v,
+static void sb_prepare_for_write(const struct dm_block_validator *v,
 				 struct dm_block *b,
 				 size_t sb_block_size)
 {
@@ -195,7 +195,7 @@ static int check_metadata_version(struct cache_disk_superblock *disk_super)
 	return 0;
 }
 
-static int sb_check(struct dm_block_validator *v,
+static int sb_check(const struct dm_block_validator *v,
 		    struct dm_block *b,
 		    size_t sb_block_size)
 {
@@ -228,7 +228,7 @@ static int sb_check(struct dm_block_validator *v,
 	return check_metadata_version(disk_super);
 }
 
-static struct dm_block_validator sb_validator = {
+static const struct dm_block_validator sb_validator = {
 	.name = "superblock",
 	.prepare_for_write = sb_prepare_for_write,
 	.check = sb_check
diff --git a/drivers/md/dm-clone-metadata.c b/drivers/md/dm-clone-metadata.c
index 47c1fa7aad8b..2db84cd2202b 100644
--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -163,7 +163,7 @@ struct dm_clone_metadata {
 /*
  * Superblock validation.
  */
-static void sb_prepare_for_write(struct dm_block_validator *v,
+static void sb_prepare_for_write(const struct dm_block_validator *v,
 				 struct dm_block *b, size_t sb_block_size)
 {
 	struct superblock_disk *sb;
@@ -177,7 +177,7 @@ static void sb_prepare_for_write(struct dm_block_validator *v,
 	sb->csum = cpu_to_le32(csum);
 }
 
-static int sb_check(struct dm_block_validator *v, struct dm_block *b,
+static int sb_check(const struct dm_block_validator *v, struct dm_block *b,
 		    size_t sb_block_size)
 {
 	struct superblock_disk *sb;
@@ -220,7 +220,7 @@ static int sb_check(struct dm_block_validator *v, struct dm_block *b,
 	return 0;
 }
 
-static struct dm_block_validator sb_validator = {
+static const struct dm_block_validator sb_validator = {
 	.name = "superblock",
 	.prepare_for_write = sb_prepare_for_write,
 	.check = sb_check
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index e627781b1420..9c84e9d13eca 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -196,7 +196,7 @@ struct superblock_disk {
  * Superblock validation
  *--------------------------------------------------------------
  */
-static void sb_prepare_for_write(struct dm_block_validator *v,
+static void sb_prepare_for_write(const struct dm_block_validator *v,
 				 struct dm_block *b,
 				 size_t sb_block_size)
 {
@@ -221,7 +221,7 @@ static int check_metadata_version(struct superblock_disk *disk)
 	return 0;
 }
 
-static int sb_check(struct dm_block_validator *v,
+static int sb_check(const struct dm_block_validator *v,
 		    struct dm_block *b,
 		    size_t sb_block_size)
 {
@@ -254,7 +254,7 @@ static int sb_check(struct dm_block_validator *v,
 	return check_metadata_version(disk);
 }
 
-static struct dm_block_validator sb_validator = {
+static const struct dm_block_validator sb_validator = {
 	.name = "superblock",
 	.prepare_for_write = sb_prepare_for_write,
 	.check = sb_check
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 6022189c1388..f90679cfec5b 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -249,7 +249,7 @@ struct dm_thin_device {
  */
 #define SUPERBLOCK_CSUM_XOR 160774
 
-static void sb_prepare_for_write(struct dm_block_validator *v,
+static void sb_prepare_for_write(const struct dm_block_validator *v,
 				 struct dm_block *b,
 				 size_t block_size)
 {
@@ -261,7 +261,7 @@ static void sb_prepare_for_write(struct dm_block_validator *v,
 						      SUPERBLOCK_CSUM_XOR));
 }
 
-static int sb_check(struct dm_block_validator *v,
+static int sb_check(const struct dm_block_validator *v,
 		    struct dm_block *b,
 		    size_t block_size)
 {
@@ -294,7 +294,7 @@ static int sb_check(struct dm_block_validator *v,
 	return 0;
 }
 
-static struct dm_block_validator sb_validator = {
+static const struct dm_block_validator sb_validator = {
 	.name = "superblock",
 	.prepare_for_write = sb_prepare_for_write,
 	.check = sb_check
diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 798c9c53a343..157c9bd2fed7 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -38,7 +38,7 @@ struct array_block {
  */
 #define CSUM_XOR 595846735
 
-static void array_block_prepare_for_write(struct dm_block_validator *v,
+static void array_block_prepare_for_write(const struct dm_block_validator *v,
 					  struct dm_block *b,
 					  size_t size_of_block)
 {
@@ -50,7 +50,7 @@ static void array_block_prepare_for_write(struct dm_block_validator *v,
 						 CSUM_XOR));
 }
 
-static int array_block_check(struct dm_block_validator *v,
+static int array_block_check(const struct dm_block_validator *v,
 			     struct dm_block *b,
 			     size_t size_of_block)
 {
@@ -77,7 +77,7 @@ static int array_block_check(struct dm_block_validator *v,
 	return 0;
 }
 
-static struct dm_block_validator array_validator = {
+static const struct dm_block_validator array_validator = {
 	.name = "array",
 	.prepare_for_write = array_block_prepare_for_write,
 	.check = array_block_check
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index b17b54df673b..1ef71e5fcde7 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -345,7 +345,7 @@ void *dm_block_data(struct dm_block *b)
 EXPORT_SYMBOL_GPL(dm_block_data);
 
 struct buffer_aux {
-	struct dm_block_validator *validator;
+	const struct dm_block_validator *validator;
 	int write_locked;
 
 #ifdef CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING
@@ -441,7 +441,7 @@ dm_block_t dm_bm_nr_blocks(struct dm_block_manager *bm)
 static int dm_bm_validate_buffer(struct dm_block_manager *bm,
 				 struct dm_buffer *buf,
 				 struct buffer_aux *aux,
-				 struct dm_block_validator *v)
+				 const struct dm_block_validator *v)
 {
 	if (unlikely(!aux->validator)) {
 		int r;
@@ -467,7 +467,7 @@ static int dm_bm_validate_buffer(struct dm_block_manager *bm,
 	return 0;
 }
 int dm_bm_read_lock(struct dm_block_manager *bm, dm_block_t b,
-		    struct dm_block_validator *v,
+		    const struct dm_block_validator *v,
 		    struct dm_block **result)
 {
 	struct buffer_aux *aux;
@@ -500,7 +500,7 @@ int dm_bm_read_lock(struct dm_block_manager *bm, dm_block_t b,
 EXPORT_SYMBOL_GPL(dm_bm_read_lock);
 
 int dm_bm_write_lock(struct dm_block_manager *bm,
-		     dm_block_t b, struct dm_block_validator *v,
+		     dm_block_t b, const struct dm_block_validator *v,
 		     struct dm_block **result)
 {
 	struct buffer_aux *aux;
@@ -536,7 +536,7 @@ int dm_bm_write_lock(struct dm_block_manager *bm,
 EXPORT_SYMBOL_GPL(dm_bm_write_lock);
 
 int dm_bm_read_try_lock(struct dm_block_manager *bm,
-			dm_block_t b, struct dm_block_validator *v,
+			dm_block_t b, const struct dm_block_validator *v,
 			struct dm_block **result)
 {
 	struct buffer_aux *aux;
@@ -569,7 +569,7 @@ int dm_bm_read_try_lock(struct dm_block_manager *bm,
 }
 
 int dm_bm_write_lock_zero(struct dm_block_manager *bm,
-			  dm_block_t b, struct dm_block_validator *v,
+			  dm_block_t b, const struct dm_block_validator *v,
 			  struct dm_block **result)
 {
 	int r;
diff --git a/drivers/md/persistent-data/dm-block-manager.h b/drivers/md/persistent-data/dm-block-manager.h
index f706d3de8d5a..b1998968594c 100644
--- a/drivers/md/persistent-data/dm-block-manager.h
+++ b/drivers/md/persistent-data/dm-block-manager.h
@@ -51,12 +51,14 @@ dm_block_t dm_bm_nr_blocks(struct dm_block_manager *bm);
  */
 struct dm_block_validator {
 	const char *name;
-	void (*prepare_for_write)(struct dm_block_validator *v, struct dm_block *b, size_t block_size);
+	void (*prepare_for_write)(const struct dm_block_validator *v,
+				  struct dm_block *b, size_t block_size);
 
 	/*
 	 * Return 0 if the checksum is valid or < 0 on error.
 	 */
-	int (*check)(struct dm_block_validator *v, struct dm_block *b, size_t block_size);
+	int (*check)(const struct dm_block_validator *v,
+		     struct dm_block *b, size_t block_size);
 };
 
 /*----------------------------------------------------------------*/
@@ -73,11 +75,11 @@ struct dm_block_validator {
  * written back to the disk sometime after dm_bm_unlock is called.
  */
 int dm_bm_read_lock(struct dm_block_manager *bm, dm_block_t b,
-		    struct dm_block_validator *v,
+		    const struct dm_block_validator *v,
 		    struct dm_block **result);
 
 int dm_bm_write_lock(struct dm_block_manager *bm, dm_block_t b,
-		     struct dm_block_validator *v,
+		     const struct dm_block_validator *v,
 		     struct dm_block **result);
 
 /*
@@ -85,7 +87,7 @@ int dm_bm_write_lock(struct dm_block_manager *bm, dm_block_t b,
  * available immediately.
  */
 int dm_bm_read_try_lock(struct dm_block_manager *bm, dm_block_t b,
-			struct dm_block_validator *v,
+			const struct dm_block_validator *v,
 			struct dm_block **result);
 
 /*
@@ -93,7 +95,7 @@ int dm_bm_read_try_lock(struct dm_block_manager *bm, dm_block_t b,
  * overwrite the block completely.  It saves a disk read.
  */
 int dm_bm_write_lock_zero(struct dm_block_manager *bm, dm_block_t b,
-			  struct dm_block_validator *v,
+			  const struct dm_block_validator *v,
 			  struct dm_block **result);
 
 void dm_bm_unlock(struct dm_block *b);
diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index 7ed2ce656fcc..acebd32858a7 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -138,7 +138,7 @@ static inline uint64_t value64(struct btree_node *n, uint32_t index)
  */
 int lower_bound(struct btree_node *n, uint64_t key);
 
-extern struct dm_block_validator btree_node_validator;
+extern const struct dm_block_validator btree_node_validator;
 
 /*
  * Value type for upper levels of multi-level btrees.
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index 7540383b7cf3..c46fc50c274e 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -16,7 +16,7 @@
 
 #define BTREE_CSUM_XOR 121107
 
-static void node_prepare_for_write(struct dm_block_validator *v,
+static void node_prepare_for_write(const struct dm_block_validator *v,
 				   struct dm_block *b,
 				   size_t block_size)
 {
@@ -29,7 +29,7 @@ static void node_prepare_for_write(struct dm_block_validator *v,
 					     BTREE_CSUM_XOR));
 }
 
-static int node_check(struct dm_block_validator *v,
+static int node_check(const struct dm_block_validator *v,
 		      struct dm_block *b,
 		      size_t block_size)
 {
@@ -81,7 +81,7 @@ static int node_check(struct dm_block_validator *v,
 	return 0;
 }
 
-struct dm_block_validator btree_node_validator = {
+const struct dm_block_validator btree_node_validator = {
 	.name = "btree_node",
 	.prepare_for_write = node_prepare_for_write,
 	.check = node_check
diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 591d1a43d035..3a19124ee279 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -22,7 +22,7 @@
  */
 #define INDEX_CSUM_XOR 160478
 
-static void index_prepare_for_write(struct dm_block_validator *v,
+static void index_prepare_for_write(const struct dm_block_validator *v,
 				    struct dm_block *b,
 				    size_t block_size)
 {
@@ -34,7 +34,7 @@ static void index_prepare_for_write(struct dm_block_validator *v,
 						 INDEX_CSUM_XOR));
 }
 
-static int index_check(struct dm_block_validator *v,
+static int index_check(const struct dm_block_validator *v,
 		       struct dm_block *b,
 		       size_t block_size)
 {
@@ -59,7 +59,7 @@ static int index_check(struct dm_block_validator *v,
 	return 0;
 }
 
-static struct dm_block_validator index_validator = {
+static const struct dm_block_validator index_validator = {
 	.name = "index",
 	.prepare_for_write = index_prepare_for_write,
 	.check = index_check
@@ -72,7 +72,7 @@ static struct dm_block_validator index_validator = {
  */
 #define BITMAP_CSUM_XOR 240779
 
-static void dm_bitmap_prepare_for_write(struct dm_block_validator *v,
+static void dm_bitmap_prepare_for_write(const struct dm_block_validator *v,
 					struct dm_block *b,
 					size_t block_size)
 {
@@ -84,7 +84,7 @@ static void dm_bitmap_prepare_for_write(struct dm_block_validator *v,
 						       BITMAP_CSUM_XOR));
 }
 
-static int dm_bitmap_check(struct dm_block_validator *v,
+static int dm_bitmap_check(const struct dm_block_validator *v,
 			   struct dm_block *b,
 			   size_t block_size)
 {
@@ -109,7 +109,7 @@ static int dm_bitmap_check(struct dm_block_validator *v,
 	return 0;
 }
 
-static struct dm_block_validator dm_sm_bitmap_validator = {
+static const struct dm_block_validator dm_sm_bitmap_validator = {
 	.name = "sm_bitmap",
 	.prepare_for_write = dm_bitmap_prepare_for_write,
 	.check = dm_bitmap_check,
diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index c88fa6266203..c7ba4e6cbbc7 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -237,7 +237,7 @@ int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *root)
 EXPORT_SYMBOL_GPL(dm_tm_commit);
 
 int dm_tm_new_block(struct dm_transaction_manager *tm,
-		    struct dm_block_validator *v,
+		    const struct dm_block_validator *v,
 		    struct dm_block **result)
 {
 	int r;
@@ -266,7 +266,7 @@ int dm_tm_new_block(struct dm_transaction_manager *tm,
 }
 
 static int __shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
-			  struct dm_block_validator *v,
+			  const struct dm_block_validator *v,
 			  struct dm_block **result)
 {
 	int r;
@@ -306,7 +306,7 @@ static int __shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
 }
 
 int dm_tm_shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
-		       struct dm_block_validator *v, struct dm_block **result,
+		       const struct dm_block_validator *v, struct dm_block **result,
 		       int *inc_children)
 {
 	int r;
@@ -331,7 +331,7 @@ int dm_tm_shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
 EXPORT_SYMBOL_GPL(dm_tm_shadow_block);
 
 int dm_tm_read_lock(struct dm_transaction_manager *tm, dm_block_t b,
-		    struct dm_block_validator *v,
+		    const struct dm_block_validator *v,
 		    struct dm_block **blk)
 {
 	if (tm->is_clone) {
diff --git a/drivers/md/persistent-data/dm-transaction-manager.h b/drivers/md/persistent-data/dm-transaction-manager.h
index 01f7e650118d..61a8d10825ca 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.h
+++ b/drivers/md/persistent-data/dm-transaction-manager.h
@@ -64,7 +64,7 @@ int dm_tm_commit(struct dm_transaction_manager *tm, struct dm_block *superblock)
  * Zeroes the new block and returns with write lock held.
  */
 int dm_tm_new_block(struct dm_transaction_manager *tm,
-		    struct dm_block_validator *v,
+		    const struct dm_block_validator *v,
 		    struct dm_block **result);
 
 /*
@@ -84,7 +84,7 @@ int dm_tm_new_block(struct dm_transaction_manager *tm,
  * it locked when you call this.
  */
 int dm_tm_shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
-		       struct dm_block_validator *v,
+		       const struct dm_block_validator *v,
 		       struct dm_block **result, int *inc_children);
 
 /*
@@ -92,7 +92,7 @@ int dm_tm_shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
  * on it outstanding then it'll block.
  */
 int dm_tm_read_lock(struct dm_transaction_manager *tm, dm_block_t b,
-		    struct dm_block_validator *v,
+		    const struct dm_block_validator *v,
 		    struct dm_block **result);
 
 void dm_tm_unlock(struct dm_transaction_manager *tm, struct dm_block *b);
-- 
2.45.2

