From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/3] dm-ioctl: fill parameters in
 __find_device_hash_cell instead of find_device
Date: Fri, 1 Jul 2011 15:04:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1107011503570.32620@hs20-bc2-1.build.redhat.com>
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

Hi

Here I'm sending the patches for ioctl parameter cleanup. I tested them 
with lvm testsuite.

Mikulas

---

dm-ioctl: fill parameters in __find_device_hash_cell instead of find_device

Move parameter filling from find_device to __find_device_hash_cell.

This patch causes that ioctls using __find_device_hash_cell
(DM_DEV_REMOVE_CMD, DM_DEV_SUSPEND_CMD - resume, DM_TABLE_CLEAR_CMD)
return device parameters.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |   63 ++++++++++++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 27 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-ioctl.c	2011-06-30 18:23:38.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-ioctl.c	2011-06-30 18:40:50.000000000 +0200
@@ -719,24 +719,49 @@ static int dev_create(struct dm_ioctl *p
 static struct hash_cell *__find_device_hash_cell(struct dm_ioctl *param)
 {
 	struct mapped_device *md;
-	void *mdptr = NULL;
+	struct hash_cell *hc = NULL;
 
-	if (*param->uuid)
-		return __get_uuid_cell(param->uuid);
+	if (*param->uuid) {
+		hc = __get_uuid_cell(param->uuid);
+		if (!hc)
+			return NULL;
+		goto fill_params;
+	}
 
-	if (*param->name)
-		return __get_name_cell(param->name);
+	if (*param->name) {
+		hc = __get_name_cell(param->name);
+		if (!hc)
+			return NULL;
+		goto fill_params;
+	}
 
 	md = dm_get_md(huge_decode_dev(param->dev));
 	if (!md)
-		goto out;
+		return NULL;
 
-	mdptr = dm_get_mdptr(md);
-	if (!mdptr)
+	hc = dm_get_mdptr(md);
+	if (!hc) {
 		dm_put(md);
+		return NULL;
+	}
 
-out:
-	return mdptr;
+fill_params:
+	/*
+	 * Sneakily write in both the name and the uuid
+	 * while we have the cell.
+	 */
+	strlcpy(param->name, hc->name, sizeof(param->name));
+	if (hc->uuid)
+		strlcpy(param->uuid, hc->uuid, sizeof(param->uuid));
+	else
+		param->uuid[0] = '\0';
+
+	if (hc->new_map)
+		param->flags |= DM_INACTIVE_PRESENT_FLAG;
+	else
+		param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
+
+	return hc;
 }
 
 static struct mapped_device *find_device(struct dm_ioctl *param)
@@ -746,24 +771,8 @@ static struct mapped_device *find_device
 
 	down_read(&_hash_lock);
 	hc = __find_device_hash_cell(param);
-	if (hc) {
+	if (hc)
 		md = hc->md;
-
-		/*
-		 * Sneakily write in both the name and the uuid
-		 * while we have the cell.
-		 */
-		strlcpy(param->name, hc->name, sizeof(param->name));
-		if (hc->uuid)
-			strlcpy(param->uuid, hc->uuid, sizeof(param->uuid));
-		else
-			param->uuid[0] = '\0';
-
-		if (hc->new_map)
-			param->flags |= DM_INACTIVE_PRESENT_FLAG;
-		else
-			param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
-	}
 	up_read(&_hash_lock);
 
 	return md;
