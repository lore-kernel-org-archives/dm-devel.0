From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] dm: device wasn't putted on error path
Date: Wed, 11 Jul 2007 21:50:00 +0400
Message-ID: <20070711175000.GA509@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765467AbXGKRtk@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

We do care about dev refcount.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-crypt.c |    4 +++-
 drivers/md/dm-delay.c |   14 +++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8030973..59b4d16 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -889,7 +889,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		cc->iv_mode = kmalloc(strlen(ivmode) + 1, GFP_KERNEL);
 		if (!cc->iv_mode) {
 			ti->error = "Error kmallocing iv_mode string";
-			goto bad5;
+			goto bad6;
 		}
 		strcpy(cc->iv_mode, ivmode);
 	} else
@@ -898,6 +898,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->private = cc;
 	return 0;
 
+bad6:
+	dm_put_device(ti, cc->dev);
 bad5:
 	bioset_free(cc->bs);
 bad_bs:
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 7cfe094..4bbdf47 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -170,27 +170,26 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	if (sscanf(argv[4], "%llu", &tmpll) != 1) {
 		ti->error = "Invalid write device sector";
-		goto bad;
+		goto bad2;
 	}
 	dc->start_write = tmpll;
 
 	if (sscanf(argv[5], "%u", &dc->write_delay) != 1) {
 		ti->error = "Invalid write delay";
-		goto bad;
+		goto bad2;
 	}
 
 	if (dm_get_device(ti, argv[3], dc->start_write, ti->len,
 			  dm_table_get_mode(ti->table), &dc->dev_write)) {
 		ti->error = "Write device lookup failed";
-		dm_put_device(ti, dc->dev_read);
-		goto bad;
+		goto bad2;
 	}
 
 out:
 	dc->delayed_pool = mempool_create_slab_pool(128, delayed_cache);
 	if (!dc->delayed_pool) {
 		DMERR("Couldn't create delayed bio pool.");
-		goto bad;
+		goto bad3;
 	}
 
 	setup_timer(&dc->delay_timer, handle_delayed_timer, (unsigned long)dc);
@@ -203,6 +202,11 @@ out:
 	ti->private = dc;
 	return 0;
 
+bad3:
+	if (dc->dev_write)
+		dm_put_device(ti, dc->dev_write);
+bad2:
+	dm_put_device(ti, dc->dev_read);
 bad:
 	kfree(dc);
 	return -EINVAL;
-- 
1.5.2.2
