From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: fix truncated status string
Date: Wed, 27 Feb 2013 17:57:44 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1302271755340.4026@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm: fix truncated status string

When processing table or status request, the function retrieve_status
calls ti->type->status. If ti->type->status returns non-zero,
retrieve_status assumes that buffer overflow occured and sets
DM_BUFFER_FULL_FLAG.

However, targets don't return non-zero values from their status method
on overflow. Most targets returns always zero.

If a bufffer overflow happens in non-last target, it would be noticed in
the next iteration of the loop in retrieve_status; if a buffer overflow
happens in the last target, it would go unnoticed and errorneously
truncated data would be returned.

In the current code, the targets behave in the following way:
* dm-crypt returns -ENOMEM if there is not enough space to store the
  key, but it returns 0 on all other overflows.
* dm-thin returns errors from the status method if disk error happened.
  This is incorrect because retrieve_status doesn't check the error
  code, it assumes that all non-zero values mean buffer overflow.
* all the other targets return always 0.

This patch changes ti->type->status function to return void (because
most targets don't use the return code). Overflow is detected in
retrieve_status - if the status method fills up the remaining space
completely, it is assumed that buffer overflow happened.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c         |   32 ++++-----------------
 drivers/md/dm-delay.c         |    6 +---
 drivers/md/dm-flakey.c        |    5 +--
 drivers/md/dm-ioctl.c         |   14 ++++++---
 drivers/md/dm-linear.c        |    5 +--
 drivers/md/dm-mpath.c         |    6 +---
 drivers/md/dm-raid.c          |    6 +---
 drivers/md/dm-raid1.c         |    6 +---
 drivers/md/dm-snap.c          |   12 ++------
 drivers/md/dm-stripe.c        |    5 +--
 drivers/md/dm-thin.c          |   62 +++++++++++++++++++++++++-----------------
 drivers/md/dm-verity.c        |    6 +---
 include/linux/device-mapper.h |    4 +-
 13 files changed, 75 insertions(+), 94 deletions(-)

Index: linux-3.8-fast/drivers/md/dm-crypt.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-crypt.c	2013-02-27 22:45:14.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-crypt.c	2013-02-27 22:53:19.000000000 +0100
@@ -1246,20 +1246,6 @@ static int crypt_decode_key(u8 *key, cha
 	return 0;
 }
 
-/*
- * Encode key into its hex representation
- */
-static void crypt_encode_key(char *hex, u8 *key, unsigned int size)
-{
-	unsigned int i;
-
-	for (i = 0; i < size; i++) {
-		sprintf(hex, "%02x", *key);
-		hex += 2;
-		key++;
-	}
-}
-
 static void crypt_free_tfms(struct crypt_config *cc)
 {
 	unsigned i;
@@ -1792,8 +1778,8 @@ static int crypt_map(struct dm_target *t
 	return DM_MAPIO_SUBMITTED;
 }
 
-static int crypt_status(struct dm_target *ti, status_type_t type,
-			unsigned status_flags, char *result, unsigned maxlen)
+static void crypt_status(struct dm_target *ti, status_type_t type,
+			 unsigned status_flags, char *result, unsigned maxlen)
 {
 	struct crypt_config *cc = ti->private;
 	unsigned int sz = 0;
@@ -1808,15 +1794,12 @@ static int crypt_status(struct dm_target
 		DMEMIT("%s ", cc->cipher_string);
 
 		if (cc->key_size > 0) {
-			if ((maxlen - sz) < ((cc->key_size << 1) + 1))
-				return -ENOMEM;
-
-			crypt_encode_key(result + sz, cc->key, cc->key_size);
-			sz += cc->key_size << 1;
+			unsigned i;
+			for (i = 0; i < cc->key_size; i++) {
+				DMEMIT("%02x", cc->key[i]);
+			}
 		} else {
-			if (sz >= maxlen)
-				return -ENOMEM;
-			result[sz++] = '-';
+			DMEMIT("-");
 		}
 
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
@@ -1842,7 +1825,6 @@ static int crypt_status(struct dm_target
 
 		break;
 	}
-	return 0;
 }
 
 static void crypt_postsuspend(struct dm_target *ti)
Index: linux-3.8-fast/drivers/md/dm-delay.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-delay.c	2013-02-27 22:48:19.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-delay.c	2013-02-27 22:48:40.000000000 +0100
@@ -293,8 +293,8 @@ static int delay_map(struct dm_target *t
 	return delay_bio(dc, dc->read_delay, bio);
 }
 
-static int delay_status(struct dm_target *ti, status_type_t type,
-			unsigned status_flags, char *result, unsigned maxlen)
+static void delay_status(struct dm_target *ti, status_type_t type,
+			 unsigned status_flags, char *result, unsigned maxlen)
 {
 	struct delay_c *dc = ti->private;
 	int sz = 0;
@@ -314,8 +314,6 @@ static int delay_status(struct dm_target
 			       dc->write_delay);
 		break;
 	}
-
-	return 0;
 }
 
 static int delay_iterate_devices(struct dm_target *ti,
Index: linux-3.8-fast/drivers/md/dm-flakey.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-flakey.c	2013-02-27 22:48:57.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-flakey.c	2013-02-27 22:49:10.000000000 +0100
@@ -337,8 +337,8 @@ static int flakey_end_io(struct dm_targe
 	return error;
 }
 
-static int flakey_status(struct dm_target *ti, status_type_t type,
-			 unsigned status_flags, char *result, unsigned maxlen)
+static void flakey_status(struct dm_target *ti, status_type_t type,
+			  unsigned status_flags, char *result, unsigned maxlen)
 {
 	unsigned sz = 0;
 	struct flakey_c *fc = ti->private;
@@ -368,7 +368,6 @@ static int flakey_status(struct dm_targe
 
 		break;
 	}
-	return 0;
 }
 
 static int flakey_ioctl(struct dm_target *ti, unsigned int cmd, unsigned long arg)
Index: linux-3.8-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-ioctl.c	2013-02-27 22:36:06.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-ioctl.c	2013-02-27 22:38:14.000000000 +0100
@@ -1098,6 +1098,7 @@ static void retrieve_status(struct dm_ta
 	num_targets = dm_table_get_num_targets(table);
 	for (i = 0; i < num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(table, i);
+		size_t l;
 
 		remaining = len - (outptr - outbuf);
 		if (remaining <= sizeof(struct dm_target_spec)) {
@@ -1124,14 +1125,17 @@ static void retrieve_status(struct dm_ta
 		if (ti->type->status) {
 			if (param->flags & DM_NOFLUSH_FLAG)
 				status_flags |= DM_STATUS_NOFLUSH_FLAG;
-			if (ti->type->status(ti, type, status_flags, outptr, remaining)) {
-				param->flags |= DM_BUFFER_FULL_FLAG;
-				break;
-			}
+			ti->type->status(ti, type, status_flags, outptr, remaining);
 		} else
 			outptr[0] = '\0';
 
-		outptr += strlen(outptr) + 1;
+		l = strlen(outptr) + 1;
+		if (l == remaining) {
+			param->flags |= DM_BUFFER_FULL_FLAG;
+			break;
+		}
+
+		outptr += l;
 		used = param->data_start + (outptr - outbuf);
 
 		outptr = align_ptr(outptr);
Index: linux-3.8-fast/drivers/md/dm-linear.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-linear.c	2013-02-27 22:40:11.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-linear.c	2013-02-27 22:40:21.000000000 +0100
@@ -95,8 +95,8 @@ static int linear_map(struct dm_target *
 	return DM_MAPIO_REMAPPED;
 }
 
-static int linear_status(struct dm_target *ti, status_type_t type,
-			 unsigned status_flags, char *result, unsigned maxlen)
+static void linear_status(struct dm_target *ti, status_type_t type,
+			  unsigned status_flags, char *result, unsigned maxlen)
 {
 	struct linear_c *lc = (struct linear_c *) ti->private;
 
@@ -110,7 +110,6 @@ static int linear_status(struct dm_targe
 				(unsigned long long)lc->start);
 		break;
 	}
-	return 0;
 }
 
 static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
Index: linux-3.8-fast/drivers/md/dm-mpath.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-mpath.c	2013-02-27 22:41:01.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-mpath.c	2013-02-27 22:41:20.000000000 +0100
@@ -1378,8 +1378,8 @@ static void multipath_resume(struct dm_t
  *     [priority selector-name num_ps_args [ps_args]*
  *      num_paths num_selector_args [path_dev [selector_args]* ]+ ]+
  */
-static int multipath_status(struct dm_target *ti, status_type_t type,
-			    unsigned status_flags, char *result, unsigned maxlen)
+static void multipath_status(struct dm_target *ti, status_type_t type,
+			     unsigned status_flags, char *result, unsigned maxlen)
 {
 	int sz = 0;
 	unsigned long flags;
@@ -1485,8 +1485,6 @@ static int multipath_status(struct dm_ta
 	}
 
 	spin_unlock_irqrestore(&m->lock, flags);
-
-	return 0;
 }
 
 static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
Index: linux-3.8-fast/drivers/md/dm-raid.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-raid.c	2013-02-27 22:49:24.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-raid.c	2013-02-27 22:49:47.000000000 +0100
@@ -1201,8 +1201,8 @@ static int raid_map(struct dm_target *ti
 	return DM_MAPIO_SUBMITTED;
 }
 
-static int raid_status(struct dm_target *ti, status_type_t type,
-		       unsigned status_flags, char *result, unsigned maxlen)
+static void raid_status(struct dm_target *ti, status_type_t type,
+			unsigned status_flags, char *result, unsigned maxlen)
 {
 	struct raid_set *rs = ti->private;
 	unsigned raid_param_cnt = 1; /* at least 1 for chunksize */
@@ -1344,8 +1344,6 @@ static int raid_status(struct dm_target 
 				DMEMIT(" -");
 		}
 	}
-
-	return 0;
 }
 
 static int raid_iterate_devices(struct dm_target *ti, iterate_devices_callout_fn fn, void *data)
Index: linux-3.8-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-raid1.c	2013-02-27 22:39:51.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-raid1.c	2013-02-27 22:40:42.000000000 +0100
@@ -1350,8 +1350,8 @@ static char device_status_char(struct mi
 }
 
 
-static int mirror_status(struct dm_target *ti, status_type_t type,
-			 unsigned status_flags, char *result, unsigned maxlen)
+static void mirror_status(struct dm_target *ti, status_type_t type,
+			  unsigned status_flags, char *result, unsigned maxlen)
 {
 	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
@@ -1386,8 +1386,6 @@ static int mirror_status(struct dm_targe
 		if (ms->features & DM_RAID1_HANDLE_ERRORS)
 			DMEMIT(" 1 handle_errors");
 	}
-
-	return 0;
 }
 
 static int mirror_iterate_devices(struct dm_target *ti,
Index: linux-3.8-fast/drivers/md/dm-snap.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-snap.c	2013-02-27 22:41:25.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-snap.c	2013-02-27 22:41:46.000000000 +0100
@@ -1840,8 +1840,8 @@ static void snapshot_merge_resume(struct
 	start_merge(s);
 }
 
-static int snapshot_status(struct dm_target *ti, status_type_t type,
-			   unsigned status_flags, char *result, unsigned maxlen)
+static void snapshot_status(struct dm_target *ti, status_type_t type,
+			    unsigned status_flags, char *result, unsigned maxlen)
 {
 	unsigned sz = 0;
 	struct dm_snapshot *snap = ti->private;
@@ -1887,8 +1887,6 @@ static int snapshot_status(struct dm_tar
 					  maxlen - sz);
 		break;
 	}
-
-	return 0;
 }
 
 static int snapshot_iterate_devices(struct dm_target *ti,
@@ -2142,8 +2140,8 @@ static void origin_resume(struct dm_targ
 	ti->max_io_len = get_origin_minimum_chunksize(dev->bdev);
 }
 
-static int origin_status(struct dm_target *ti, status_type_t type,
-			 unsigned status_flags, char *result, unsigned maxlen)
+static void origin_status(struct dm_target *ti, status_type_t type,
+			  unsigned status_flags, char *result, unsigned maxlen)
 {
 	struct dm_dev *dev = ti->private;
 
@@ -2156,8 +2154,6 @@ static int origin_status(struct dm_targe
 		snprintf(result, maxlen, "%s", dev->name);
 		break;
 	}
-
-	return 0;
 }
 
 static int origin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
Index: linux-3.8-fast/drivers/md/dm-stripe.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-stripe.c	2013-02-27 22:40:46.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-stripe.c	2013-02-27 22:40:56.000000000 +0100
@@ -312,8 +312,8 @@ static int stripe_map(struct dm_target *
  *
  */
 
-static int stripe_status(struct dm_target *ti, status_type_t type,
-			 unsigned status_flags, char *result, unsigned maxlen)
+static void stripe_status(struct dm_target *ti, status_type_t type,
+			  unsigned status_flags, char *result, unsigned maxlen)
 {
 	struct stripe_c *sc = (struct stripe_c *) ti->private;
 	char buffer[sc->stripes + 1];
@@ -340,7 +340,6 @@ static int stripe_status(struct dm_targe
 			    (unsigned long long)sc->stripe[i].physical_start);
 		break;
 	}
-	return 0;
 }
 
 static int stripe_end_io(struct dm_target *ti, struct bio *bio, int error)
Index: linux-3.8-fast/drivers/md/dm-thin.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-thin.c	2013-02-27 22:41:58.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-thin.c	2013-02-27 22:52:39.000000000 +0100
@@ -2302,8 +2302,8 @@ static void emit_flags(struct pool_featu
  *    <transaction id> <used metadata sectors>/<total metadata sectors>
  *    <used data sectors>/<total data sectors> <held metadata root>
  */
-static int pool_status(struct dm_target *ti, status_type_t type,
-		       unsigned status_flags, char *result, unsigned maxlen)
+static void pool_status(struct dm_target *ti, status_type_t type,
+			unsigned status_flags, char *result, unsigned maxlen)
 {
 	int r;
 	unsigned sz = 0;
@@ -2331,30 +2331,42 @@ static int pool_status(struct dm_target 
 
 		r = dm_pool_get_metadata_transaction_id(pool->pmd,
 							&transaction_id);
-		if (r)
-			return r;
+		if (r) {
+			DMEMIT("Error %d", r);
+			return;
+		}
 
 		r = dm_pool_get_free_metadata_block_count(pool->pmd,
 							  &nr_free_blocks_metadata);
-		if (r)
-			return r;
+		if (r) {
+			DMEMIT("Error %d", r);
+			return;
+		}
 
 		r = dm_pool_get_metadata_dev_size(pool->pmd, &nr_blocks_metadata);
-		if (r)
-			return r;
+		if (r) {
+			DMEMIT("Error %d", r);
+			return;
+		}
 
 		r = dm_pool_get_free_block_count(pool->pmd,
 						 &nr_free_blocks_data);
-		if (r)
-			return r;
+		if (r) {
+			DMEMIT("Error %d", r);
+			return;
+		}
 
 		r = dm_pool_get_data_dev_size(pool->pmd, &nr_blocks_data);
-		if (r)
-			return r;
+		if (r) {
+			DMEMIT("Error %d", r);
+			return;
+		}
 
 		r = dm_pool_get_metadata_snap(pool->pmd, &held_root);
-		if (r)
-			return r;
+		if (r) {
+			DMEMIT("Error %d", r);
+			return;
+		}
 
 		DMEMIT("%llu %llu/%llu %llu/%llu ",
 		       (unsigned long long)transaction_id,
@@ -2391,8 +2403,6 @@ static int pool_status(struct dm_target 
 		emit_flags(&pt->requested_pf, result, sz, maxlen);
 		break;
 	}
-
-	return 0;
 }
 
 static int pool_iterate_devices(struct dm_target *ti,
@@ -2679,8 +2689,8 @@ static void thin_postsuspend(struct dm_t
 /*
  * <nr mapped sectors> <highest mapped sector>
  */
-static int thin_status(struct dm_target *ti, status_type_t type,
-		       unsigned status_flags, char *result, unsigned maxlen)
+static void thin_status(struct dm_target *ti, status_type_t type,
+			unsigned status_flags, char *result, unsigned maxlen)
 {
 	int r;
 	ssize_t sz = 0;
@@ -2690,7 +2700,7 @@ static int thin_status(struct dm_target 
 
 	if (get_pool_mode(tc->pool) == PM_FAIL) {
 		DMEMIT("Fail");
-		return 0;
+		return;
 	}
 
 	if (!tc->td)
@@ -2699,12 +2709,16 @@ static int thin_status(struct dm_target 
 		switch (type) {
 		case STATUSTYPE_INFO:
 			r = dm_thin_get_mapped_count(tc->td, &mapped);
-			if (r)
-				return r;
+			if (r) {
+				DMEMIT("Error %d", r);
+				return;
+			}
 
 			r = dm_thin_get_highest_mapped_block(tc->td, &highest);
-			if (r < 0)
-				return r;
+			if (r < 0) {
+				DMEMIT("Error %d", r);
+				return;
+			}
 
 			DMEMIT("%llu ", mapped * tc->pool->sectors_per_block);
 			if (r)
@@ -2723,8 +2737,6 @@ static int thin_status(struct dm_target 
 			break;
 		}
 	}
-
-	return 0;
 }
 
 static int thin_iterate_devices(struct dm_target *ti,
Index: linux-3.8-fast/include/linux/device-mapper.h
===================================================================
--- linux-3.8-fast.orig/include/linux/device-mapper.h	2013-02-27 22:35:42.000000000 +0100
+++ linux-3.8-fast/include/linux/device-mapper.h	2013-02-27 22:36:00.000000000 +0100
@@ -68,8 +68,8 @@ typedef void (*dm_postsuspend_fn) (struc
 typedef int (*dm_preresume_fn) (struct dm_target *ti);
 typedef void (*dm_resume_fn) (struct dm_target *ti);
 
-typedef int (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
-			     unsigned status_flags, char *result, unsigned maxlen);
+typedef void (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
+			      unsigned status_flags, char *result, unsigned maxlen);
 
 typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv);
 
Index: linux-3.8-fast/drivers/md/dm-verity.c
===================================================================
--- linux-3.8-fast.orig/drivers/md/dm-verity.c	2013-02-27 23:02:29.000000000 +0100
+++ linux-3.8-fast/drivers/md/dm-verity.c	2013-02-27 23:02:41.000000000 +0100
@@ -508,8 +508,8 @@ static int verity_map(struct dm_target *
 /*
  * Status: V (valid) or C (corruption found)
  */
-static int verity_status(struct dm_target *ti, status_type_t type,
-			 unsigned status_flags, char *result, unsigned maxlen)
+static void verity_status(struct dm_target *ti, status_type_t type,
+			  unsigned status_flags, char *result, unsigned maxlen)
 {
 	struct dm_verity *v = ti->private;
 	unsigned sz = 0;
@@ -540,8 +540,6 @@ static int verity_status(struct dm_targe
 				DMEMIT("%02x", v->salt[x]);
 		break;
 	}
-
-	return 0;
 }
 
 static int verity_ioctl(struct dm_target *ti, unsigned cmd,
