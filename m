From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/3] dm-ioctl: introduce __get_dev_cell
Date: Fri, 1 Jul 2011 15:05:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1107011504580.32620@hs20-bc2-1.build.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

dm-ioctl: introduce __get_dev_cell

Move logic to find device based on major/minor number to a separate
function __get_dev_cell (similar to __get_uuid_cell and __get_name_cell).
As a result,  function __find_device_hash_cell is more straightforward.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-ioctl.c	2011-06-30 20:31:15.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-ioctl.c	2011-06-30 20:43:22.000000000 +0200
@@ -128,6 +128,24 @@ static struct hash_cell *__get_uuid_cell
 	return NULL;
 }
 
+static struct hash_cell *__get_dev_cell(__u64 dev)
+{
+	struct mapped_device *md;
+	struct hash_cell *hc;
+
+	md = dm_get_md(huge_decode_dev(dev));
+	if (!md)
+		return NULL;
+
+	hc = dm_get_mdptr(md);
+	if (!hc) {
+		dm_put(md);
+		return NULL;
+	}
+
+	return hc;
+}
+
 /*-----------------------------------------------------------------
  * Inserting, removing and renaming a device.
  *---------------------------------------------------------------*/
@@ -718,34 +736,24 @@ static int dev_create(struct dm_ioctl *p
  */
 static struct hash_cell *__find_device_hash_cell(struct dm_ioctl *param)
 {
-	struct mapped_device *md;
 	struct hash_cell *hc = NULL;
 
 	if (*param->uuid) {
 		hc = __get_uuid_cell(param->uuid);
 		if (!hc)
 			return NULL;
-		goto fill_params;
-	}
-
-	if (*param->name) {
+	} else if (*param->name) {
 		hc = __get_name_cell(param->name);
 		if (!hc)
 			return NULL;
-		goto fill_params;
-	}
-
-	md = dm_get_md(huge_decode_dev(param->dev));
-	if (!md)
-		return NULL;
-
-	hc = dm_get_mdptr(md);
-	if (!hc) {
-		dm_put(md);
+	} else if (param->dev) {
+		hc = __get_dev_cell(param->dev);
+		if (!hc)
+			return NULL;
+	} else {
 		return NULL;
 	}
 
-fill_params:
 	/*
 	 * Sneakily write in both the name and the uuid
 	 * while we have the cell.
