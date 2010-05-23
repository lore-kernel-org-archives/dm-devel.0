From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 6/6] dm ioctl: introduce find_device_noinit
Date: Sun, 23 May 2010 17:45:01 -0400
Message-ID: <1274651101-9784-7-git-send-email-snitzer@redhat.com>
References: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Factor all appropriate consumers of __find_device_hash_cell() to use
find_device_noinit().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c |   51 +++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -718,23 +718,40 @@ static struct mapped_device *find_device
 	return md;
 }
 
+static struct mapped_device *find_device_noinit(struct dm_ioctl *param)
+{
+	struct hash_cell *hc;
+	struct mapped_device *md = NULL;
+
+	down_write(&_hash_lock);
+	hc = __find_device_hash_cell(param);
+	if (hc)
+		md = hc->md;
+	else
+		DMWARN("device doesn't appear to be in the dev hash table.");
+	up_write(&_hash_lock);
+
+	return md;
+}
+
 static int dev_remove(struct dm_ioctl *param, size_t param_size)
 {
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	int r;
 
-	down_write(&_hash_lock);
-	hc = __find_device_hash_cell(param);
+	md = find_device_noinit(param);
+	if (!md)
+		return -ENXIO;
 
+	down_write(&_hash_lock);
+	hc = dm_get_verified_mdptr(md);
 	if (!hc) {
-		DMWARN("device doesn't appear to be in the dev hash table.");
 		up_write(&_hash_lock);
+		dm_put(md);
 		return -ENXIO;
 	}
 
-	md = hc->md;
-
 	/*
 	 * Ensure the device is not open and nothing further can open it.
 	 */
@@ -872,17 +889,9 @@ static int do_resume(struct dm_ioctl *pa
 	struct mapped_device *md;
 	struct dm_table *new_map, *old_map = NULL;
 
-	down_write(&_hash_lock);
-
-	hc = __find_device_hash_cell(param);
-	if (!hc) {
-		DMWARN("device doesn't appear to be in the dev hash table.");
-		up_write(&_hash_lock);
+	md = find_device_noinit(param);
+	if (!md)
 		return -ENXIO;
-	}
-
-	md = hc->md;
-	up_write(&_hash_lock);
 
 	dm_lock_resume(md);
 
@@ -1271,17 +1280,9 @@ static int table_clear(struct dm_ioctl *
 	struct mapped_device *md;
 	struct dm_table *live_table;
 
-	down_write(&_hash_lock);
-
-	hc = __find_device_hash_cell(param);
-	if (!hc) {
-		DMWARN("device doesn't appear to be in the dev hash table.");
-		up_write(&_hash_lock);
+	md = find_device_noinit(param);
+	if (!md)
 		return -ENXIO;
-	}
-
-	md = hc->md;
-	up_write(&_hash_lock);
 
 	dm_lock_resume(md);
 	dm_lock_md_type(md); /* May need to clear md's type */
