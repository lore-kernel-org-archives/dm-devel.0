From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5/6] dm ioctl: introduce dm_get_verified_mdptr
Date: Sun, 23 May 2010 17:45:00 -0400
Message-ID: <1274651101-9784-6-git-send-email-snitzer@redhat.com>
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

Factor all appropriate consumers of dm_get_mdptr() to use the
dm_get_verified_mdptr() rather than duplicate code.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -174,6 +174,19 @@ static void free_cell(struct hash_cell *
 	}
 }
 
+static struct hash_cell *dm_get_verified_mdptr(struct mapped_device *md)
+{
+	struct hash_cell *hc;
+
+	hc = dm_get_mdptr(md);
+	if (!hc || hc->md != md) {
+		DMWARN("device has been removed from the dev hash table.");
+		return NULL;
+	}
+
+	return hc;
+}
+
 /*
  * The kdev_t and uuid of a device can never change once it is
  * initially inserted.
@@ -546,11 +559,9 @@ static struct dm_table *dm_get_inactive_
 	struct dm_table *table = NULL;
 
 	down_read(&_hash_lock);
-	hc = dm_get_mdptr(md);
-	if (!hc || hc->md != md) {
-		DMWARN("device has been removed from the dev hash table.");
+	hc = dm_get_verified_mdptr(md);
+	if (!hc)
 		goto out;
-	}
 
 	table = hc->new_map;
 	if (table)
@@ -876,8 +887,8 @@ static int do_resume(struct dm_ioctl *pa
 	dm_lock_resume(md);
 
 	down_write(&_hash_lock);
-	if (!hc || hc->md != md) {
-		DMWARN("device has been removed from the dev hash table.");
+	hc = dm_get_verified_mdptr(md);
+	if (!hc) {
 		up_write(&_hash_lock);
 		r = -ENXIO;
 		goto out;
@@ -1226,9 +1237,8 @@ static int table_load(struct dm_ioctl *p
 
 	/* stage inactive table */
 	down_write(&_hash_lock);
-	hc = dm_get_mdptr(md);
-	if (!hc || hc->md != md) {
-		DMWARN("device has been removed from the dev hash table.");
+	hc = dm_get_verified_mdptr(md);
+	if (!hc) {
 		dm_table_destroy(t);
 		up_write(&_hash_lock);
 		if (initial_table_load)
@@ -1277,9 +1287,8 @@ static int table_clear(struct dm_ioctl *
 	dm_lock_md_type(md); /* May need to clear md's type */
 
 	down_write(&_hash_lock);
-	hc = dm_get_mdptr(md);
-	if (!hc || hc->md != md) {
-		DMWARN("device has been removed from the dev hash table.");
+	hc = dm_get_verified_mdptr(md);
+	if (!hc) {
 		up_write(&_hash_lock);
 		r = -ENXIO;
 		goto out;
@@ -1736,8 +1745,8 @@ int dm_copy_name_and_uuid(struct mapped_
 		return -ENXIO;
 
 	mutex_lock(&dm_hash_cells_mutex);
-	hc = dm_get_mdptr(md);
-	if (!hc || hc->md != md) {
+	hc = dm_get_verified_mdptr(md);
+	if (!hc) {
 		r = -ENXIO;
 		goto out;
 	}
