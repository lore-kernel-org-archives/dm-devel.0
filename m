From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] RFC: Changing dm core (4/5): remove dm_get_md()
Date: Thu, 16 Mar 2006 19:28:06 -0500
Message-ID: <441A0296.2070101@ce.jp.nec.com>
References: <4419FF61.9050501@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090800020807000600010600"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4419FF61.9050501@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------090800020807000600010600
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Remove dm_get_md(), which is no longer used.

Thanks,
-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------090800020807000600010600
Content-Type: text/x-patch;
 name="04-remove-dm-get-md.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04-remove-dm-get-md.patch"

Remove dm_get_md(), which is no longer used.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

 dm.c |   31 -------------------------------
 dm.h |    1 -
 2 files changed, 32 deletions(-)

--- linux-2.6.16-rc6-mm1-dm.03-hc-open-count/drivers/md/dm.c	2006-03-16 18:23:51.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.04-remove-dm-get-md/drivers/md/dm.c	2006-03-16 18:15:58.000000000 -0500
@@ -938,37 +938,6 @@ int dm_create_with_minor(unsigned int mi
 	return create_aux(minor, 1, result);
 }
 
-static struct mapped_device *dm_find_md(dev_t dev)
-{
-	struct mapped_device *md;
-	unsigned minor = MINOR(dev);
-
-	if (MAJOR(dev) != _major || minor >= (1 << MINORBITS))
-		return NULL;
-
-	mutex_lock(&_minor_lock);
-
-	md = idr_find(&_minor_idr, minor);
-	if (!md || (dm_disk(md)->first_minor != minor))
-		md = NULL;
-
-	mutex_unlock(&_minor_lock);
-
-	return md;
-}
-
-struct mapped_device *dm_get_md(dev_t dev)
-{
-	struct mapped_device *md = dm_find_md(dev);
-
-	if (!md || !md->interface_ptr)
-		return NULL;
-
-	dm_get(md);
-
-	return md;
-}
-
 void *dm_get_mdptr(struct mapped_device *md)
 {
 	return md->interface_ptr;
--- linux-2.6.16-rc6-mm1-dm.03-hc-open-count/drivers/md/dm.h	2006-03-16 18:19:28.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.04-remove-dm-get-md/drivers/md/dm.h	2006-03-16 18:19:35.000000000 -0500
@@ -48,7 +48,6 @@ int dm_create(struct mapped_device **md)
 int dm_create_with_minor(unsigned int minor, struct mapped_device **md);
 void dm_set_mdptr(struct mapped_device *md, void *ptr);
 void *dm_get_mdptr(struct mapped_device *md);
-struct mapped_device *dm_get_md(dev_t dev);
 
 /*
  * Reference counting for md.

--------------090800020807000600010600
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090800020807000600010600--
