From: Matt Domsch <Matt_Domsch@dell.com>
Subject: [PATCH 2.6.11-rc2] dm-ioctl.c: use new kstrdup() from
	library
Date: Mon, 31 Jan 2005 13:28:59 -0600
Message-ID: <20050131192859.GB24164@lists.us.dell.com>
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
To: dm-devel@redhat.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Removes private kstrdup() function, uses new implementation in lib/string.c.

Required to build.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com


-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

===== drivers/md/dm-ioctl.c 1.42 vs edited =====
--- 1.42/drivers/md/dm-ioctl.c	2004-11-15 21:29:26 -06:00
+++ edited/drivers/md/dm-ioctl.c	2005-01-27 19:27:26 -06:00
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/devfs_fs_kernel.h>
 #include <linux/dm-ioctl.h>
 
@@ -122,14 +123,6 @@
 /*-----------------------------------------------------------------
  * Inserting, removing and renaming a device.
  *---------------------------------------------------------------*/
-static inline char *kstrdup(const char *str)
-{
-	char *r = kmalloc(strlen(str) + 1, GFP_KERNEL);
-	if (r)
-		strcpy(r, str);
-	return r;
-}
-
 static struct hash_cell *alloc_cell(const char *name, const char *uuid,
 				    struct mapped_device *md)
 {
@@ -139,7 +132,7 @@
 	if (!hc)
 		return NULL;
 
-	hc->name = kstrdup(name);
+	hc->name = kstrdup(name, GFP_KERNEL);
 	if (!hc->name) {
 		kfree(hc);
 		return NULL;
@@ -149,7 +142,7 @@
 		hc->uuid = NULL;
 
 	else {
-		hc->uuid = kstrdup(uuid);
+		hc->uuid = kstrdup(uuid, GFP_KERNEL);
 		if (!hc->uuid) {
 			kfree(hc->name);
 			kfree(hc);
@@ -273,7 +266,7 @@
 	/*
 	 * duplicate new.
 	 */
-	new_name = kstrdup(new);
+	new_name = kstrdup(new, GFP_KERNEL);
 	if (!new_name)
 		return -ENOMEM;
 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
