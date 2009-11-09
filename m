From: malahal@us.ibm.com
Subject: Re: [PATCH] a deadlock bug in the kernel-side device
	mapper code
Date: Mon, 9 Nov 2009 14:24:25 -0800
Message-ID: <20091109222425.GA3577@us.ibm.com>
References: <4AF2D176.4010000@actcom.co.il>
	<20091105142435.GQ13375@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911052157170.18661@hs20-bc2-1.build.redhat.com>
	<20091109085142.GA4432@linux.vnet.ibm.com>
	<20091109175730.GA12556@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091109175730.GA12556@us.ibm.com>
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
List-Id: dm-devel.ids

malahal@us.ibm.com [malahal@us.ibm.com] wrote:
> dm_get_from_kobject() seems to be a culprit though. It checks
> DMF_FREEING without a lock and then calls dm_get. Here is an untested
> patch. Made on top of _name_read_lock patch.

Found another place where the lock is not held correctly. This is an
update to my previous patch [dmf_freeing_lock.patch]

Description:

There are places where the code checks for DMF_FREEING bit flag and
conditionally calls dm_get(). This should be done under _minor_lock,
otherwise there is no point in checking for the bit flag.

Signed-off-by: malahal@us.ibm.com

diff -r e4c5c66b9a17 drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c	Mon Nov 09 13:38:38 2009 -0800
+++ b/drivers/md/dm-ioctl.c	Mon Nov 09 14:21:13 2009 -0800
@@ -1595,7 +1595,6 @@
 	if (!md)
 		return -ENXIO;
 
-	dm_get(md);
 	mutex_lock(&_name_read_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
@@ -1610,7 +1609,6 @@
 
 out:
 	mutex_unlock(&_name_read_lock);
-	dm_put(md);
 
 	return r;
 }
diff -r e4c5c66b9a17 drivers/md/dm.c
--- a/drivers/md/dm.c	Mon Nov 09 13:38:38 2009 -0800
+++ b/drivers/md/dm.c	Mon Nov 09 14:21:13 2009 -0800
@@ -1998,28 +1998,24 @@
 	if (MAJOR(dev) != _major || minor >= (1 << MINORBITS))
 		return NULL;
 
-	spin_lock(&_minor_lock);
-
 	md = idr_find(&_minor_idr, minor);
 	if (md && (md == MINOR_ALLOCED ||
 		   (MINOR(disk_devt(dm_disk(md))) != minor) ||
-		   test_bit(DMF_FREEING, &md->flags))) {
-		md = NULL;
-		goto out;
-	}
-
-out:
-	spin_unlock(&_minor_lock);
+		   test_bit(DMF_FREEING, &md->flags)))
+		return NULL;
 
 	return md;
 }
 
 struct mapped_device *dm_get_md(dev_t dev)
 {
-	struct mapped_device *md = dm_find_md(dev);
+	struct mapped_device *md;
 
+	spin_lock(&_minor_lock);
+	md = dm_find_md(dev);
 	if (md)
 		dm_get(md);
+	spin_unlock(&_minor_lock);
 
 	return md;
 }
@@ -2584,11 +2580,17 @@
 	if (&md->kobj != kobj)
 		return NULL;
 
+	spin_lock(&_minor_lock);
+
 	if (test_bit(DMF_FREEING, &md->flags) ||
 	    test_bit(DMF_DELETING, &md->flags))
-		return NULL;
+		md = NULL;
 
-	dm_get(md);
+	if (md)
+		dm_get(md);
+
+	spin_unlock(&_minor_lock);
+
 	return md;
 }
 
