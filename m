From: Frederik Deweerdt <deweerdt@free.fr>
Subject: [patch] minor dm.c cleanup
Date: Fri, 18 Apr 2008 17:40:45 +0200
Message-ID: <20080418154045.GI7134@slug>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Alasdair,

The small patch below:
- Removes the unused md argument from both specific_minor() and next_free_minor()
- Folds kmalloc + memset(0) into a single kzalloc call in alloc_dev()

This has been compile tested on x86.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 11f4ffe..a4b217e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -924,7 +924,7 @@ static void free_minor(int minor)
 /*
  * See if the device with a specific minor # is free.
  */
-static int specific_minor(struct mapped_device *md, int minor)
+static int specific_minor(int minor)
 {
 	int r, m;
 
@@ -957,7 +957,7 @@ out:
 	return r;
 }
 
-static int next_free_minor(struct mapped_device *md, int *minor)
+static int next_free_minor(int *minor)
 {
 	int r, m;
 
@@ -993,7 +993,7 @@ static struct block_device_operations dm_blk_dops;
 static struct mapped_device *alloc_dev(int minor)
 {
 	int r;
-	struct mapped_device *md = kmalloc(sizeof(*md), GFP_KERNEL);
+	struct mapped_device *md = kzalloc(sizeof(*md), GFP_KERNEL);
 	void *old_md;
 
 	if (!md) {
@@ -1006,13 +1006,12 @@ static struct mapped_device *alloc_dev(int minor)
 
 	/* get a minor number for the dev */
 	if (minor == DM_ANY_MINOR)
-		r = next_free_minor(md, &minor);
+		r = next_free_minor(&minor);
 	else
-		r = specific_minor(md, minor);
+		r = specific_minor(minor);
 	if (r < 0)
 		goto bad_minor;
 
-	memset(md, 0, sizeof(*md));
 	init_rwsem(&md->io_lock);
 	mutex_init(&md->suspend_lock);
 	spin_lock_init(&md->pushback_lock);
