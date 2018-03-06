From: Patrik Torstensson <totte@google.com>
Subject: [PATCH] Add an option to dm-verity to validate hashes at most once
Date: Tue,  6 Mar 2018 15:14:56 -0800
Message-ID: <20180306231456.210504-1-totte@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, ebiggers@google.com, samitolvanen@google.com, gkaiser@google.com, paulcrowley@google.com, Patrik Torstensson <totte@google.com>
List-Id: dm-devel.ids

Add an option to dm-verity to validate hashes at most once
to allow platforms that is CPU/memory contraint to be
protected by dm-verity against offline attacks.

The option introduces a bitset that is used to check if
a block has been validated before or not. A block can
be validated more than once as there is no thread protection
for the bitset.

This patch has been developed and tested on entry-level
Android Go devices.

Signed-off-by: Patrik Torstensson <totte@google.com>
---
 drivers/md/dm-verity-target.c | 58 +++++++++++++++++++++++++++++++++--
 drivers/md/dm-verity.h        |  1 +
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index aedb8222836b..479d0af212bf 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -32,6 +32,7 @@
 #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
 #define DM_VERITY_OPT_RESTART		"restart_on_corruption"
 #define DM_VERITY_OPT_IGN_ZEROES	"ignore_zero_blocks"
+#define DM_VERITY_OPT_AT_MOST_ONCE	"check_at_most_once"
 
 #define DM_VERITY_OPTS_MAX		(2 + DM_VERITY_OPTS_FEC)
 
@@ -432,6 +433,19 @@ static int verity_bv_zero(struct dm_verity *v, struct dm_verity_io *io,
 	return 0;
 }
 
+/*
+ * Moves the bio iter one data block forward.
+ */
+static inline void verity_bv_skip_block(struct dm_verity *v,
+					struct dm_verity_io *io,
+					struct bvec_iter *iter)
+{
+	struct bio *bio = dm_bio_from_per_bio_data(io,
+						   v->ti->per_io_data_size);
+
+	bio_advance_iter(bio, iter, 1 << v->data_dev_block_bits);
+}
+
 /*
  * Verify one "dm_verity_io" structure.
  */
@@ -445,8 +459,15 @@ static int verity_verify_io(struct dm_verity_io *io)
 
 	for (b = 0; b < io->n_blocks; b++) {
 		int r;
+		sector_t cur_block = io->block + b;
 		struct ahash_request *req = verity_io_hash_req(v, io);
 
+		if (v->validated_blocks &&
+		    likely(test_bit(cur_block, v->validated_blocks))) {
+			verity_bv_skip_block(v, io, &io->iter);
+			continue;
+		}
+
 		r = verity_hash_for_block(v, io, io->block + b,
 					  verity_io_want_digest(v, io),
 					  &is_zero);
@@ -481,13 +502,17 @@ static int verity_verify_io(struct dm_verity_io *io)
 			return r;
 
 		if (likely(memcmp(verity_io_real_digest(v, io),
-				  verity_io_want_digest(v, io), v->digest_size) == 0))
+				  verity_io_want_digest(v, io),
+				  v->digest_size) == 0)) {
+			if (v->validated_blocks)
+				set_bit(cur_block, v->validated_blocks);
 			continue;
+		}
 		else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
-					   io->block + b, NULL, &start) == 0)
+					   cur_block, NULL, &start) == 0)
 			continue;
 		else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
-					   io->block + b))
+					   cur_block))
 			return -EIO;
 	}
 
@@ -740,6 +765,7 @@ static void verity_dtr(struct dm_target *ti)
 	if (v->bufio)
 		dm_bufio_client_destroy(v->bufio);
 
+	kvfree(v->validated_blocks);
 	kfree(v->salt);
 	kfree(v->root_digest);
 	kfree(v->zero_digest);
@@ -760,6 +786,26 @@ static void verity_dtr(struct dm_target *ti)
 	kfree(v);
 }
 
+static int verity_alloc_most_once(struct dm_verity *v)
+{
+	struct dm_target *ti = v->ti;
+
+	/* the bitset can only handle INT_MAX blocks */
+	if (v->data_blocks > INT_MAX) {
+		ti->error = "device too large to use check_at_most_once";
+		return -E2BIG;
+	}
+
+	v->validated_blocks = kvzalloc(BITS_TO_LONGS(v->data_blocks)
+				     * sizeof(unsigned long), GFP_KERNEL);
+	if (!v->validated_blocks) {
+		ti->error = "failed to allocate bitset for check_at_most_once";
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static int verity_alloc_zero_digest(struct dm_verity *v)
 {
 	int r = -ENOMEM;
@@ -829,6 +875,12 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v)
 			}
 			continue;
 
+		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_AT_MOST_ONCE)) {
+			r = verity_alloc_most_once(v);
+			if (r)
+				return r;
+			continue;
+
 		} else if (verity_is_fec_opt_arg(arg_name)) {
 			r = verity_fec_parse_opt_args(as, v, &argc, arg_name);
 			if (r)
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index b675bc015512..ace5ec781b5f 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -63,6 +63,7 @@ struct dm_verity {
 	sector_t hash_level_block[DM_VERITY_MAX_LEVELS];
 
 	struct dm_verity_fec *fec;	/* forward error correction */
+	unsigned long *validated_blocks; /* bitset blocks validated */
 };
 
 struct dm_verity_io {
-- 
2.16.2.395.g2e18187dfd-goog
