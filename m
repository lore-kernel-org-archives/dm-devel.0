From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/7] dm-crypt: make it possible to disable
 offload to thread
Date: Fri, 13 Feb 2015 08:27:08 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502130826050.6449@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

There are some situation where offloading bios to a thread degrades
performance twice, so we make an option to disable this feature. The
feature can be disabled by passing performance_no_offload as an optional
table argument performance_no_offload.

We increase target version to 14 so that userspace can be aware of this
feature.

The default is to offload bios because for CFQ it is benefical to do so.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   46 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 13 deletions(-)

Index: linux-3.19/drivers/md/dm-crypt.c
===================================================================
--- linux-3.19.orig/drivers/md/dm-crypt.c	2015-02-12 17:52:40.000000000 +0100
+++ linux-3.19/drivers/md/dm-crypt.c	2015-02-12 19:01:41.000000000 +0100
@@ -110,7 +110,7 @@ struct iv_tcw_private {
  * Crypt: maps a linear range of a block device
  * and encrypts / decrypts at the same time.
  */
-enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID };
+enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID, DM_CRYPT_NO_OFFLOAD };
 
 /*
  * The fields in here must be read only after initialization.
@@ -1239,6 +1239,11 @@ static void kcryptd_crypt_write_io_submi
 
 	clone->bi_iter.bi_sector = cc->start + io->sector;
 
+	if (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags) && likely(!async)) {
+		generic_make_request(clone);
+		return;
+	}
+
 	spin_lock_irqsave(&cc->write_thread_wait.lock, flags);
 	list_add_tail(&io->list, &cc->write_thread_list);
 	wake_up_locked(&cc->write_thread_wait);
@@ -1693,7 +1698,7 @@ static int crypt_ctr(struct dm_target *t
 	char dummy;
 
 	static struct dm_arg _args[] = {
-		{0, 1, "Invalid number of feature args"},
+		{0, 2, "Invalid number of feature args"},
 	};
 
 	if (argc < 5) {
@@ -1789,15 +1794,21 @@ static int crypt_ctr(struct dm_target *t
 		if (ret)
 			goto bad;
 
-		opt_string = dm_shift_arg(&as);
+		while (opt_params--) {
+			opt_string = dm_shift_arg(&as);
+			if (!opt_string) {
+				ti->error = "Not enough feature arguments";
+				goto bad;
+			}
 
-		if (opt_params == 1 && opt_string &&
-		    !strcasecmp(opt_string, "allow_discards"))
-			ti->num_discard_bios = 1;
-		else if (opt_params) {
-			ret = -EINVAL;
-			ti->error = "Invalid feature arguments";
-			goto bad;
+			if (!strcasecmp(opt_string, "allow_discards")) {
+				ti->num_discard_bios = 1;
+			} else if (!strcasecmp(opt_string, "performance_no_offload")) {
+				set_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
+			} else {
+				ti->error = "Invalid feature arguments";
+				goto bad;
+			}
 		}
 	}
 
@@ -1873,6 +1884,7 @@ static void crypt_status(struct dm_targe
 {
 	struct crypt_config *cc = ti->private;
 	unsigned i, sz = 0;
+	int n_feature_args;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -1891,8 +1903,16 @@ static void crypt_status(struct dm_targe
 		DMEMIT(" %llu %s %llu", (unsigned long long)cc->iv_offset,
 				cc->dev->name, (unsigned long long)cc->start);
 
-		if (ti->num_discard_bios)
-			DMEMIT(" 1 allow_discards");
+		n_feature_args = 0;
+		n_feature_args += !!ti->num_discard_bios;
+		n_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
+		if (n_feature_args) {
+			DMEMIT(" %d", n_feature_args);
+			if (ti->num_discard_bios)
+				DMEMIT(" allow_discards");
+			if (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags))
+				DMEMIT(" performance_no_offload");
+		}
 
 		break;
 	}
@@ -1989,7 +2009,7 @@ static int crypt_iterate_devices(struct 
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 13, 0},
+	.version = {1, 14, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
