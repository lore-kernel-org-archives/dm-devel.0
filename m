From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 07/08] dm: proper module reference counting
Date: Mon, 17 Apr 2006 11:16:02 -0400
Message-ID: <20060417151602.GA18988@locomotive.unixthugs.org>
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
To: Device Mapper Development List <dm-devel@redhat.com>
List-Id: dm-devel.ids


 Module reference counting appropriately occurs when the block device is
 opened, but dm devices exist outside of the device actually being opened.

 Currently, in certain situations, unloading the dm-mod module will result
 in an oops. This patch claims a reference to the module when a device
 is created, and drops it when the device is freed.

 This is one possible implementation. Another could be to do an internal
 "dmsetup remove_all" when the module is unloaded. Comments welcome.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 drivers/md/dm.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -ruNpX ../dontdiff 2.6.17-rc1-staging1/drivers/md/dm.c 2.6.17-rc1-staging2/drivers/md/dm.c
--- 2.6.17-rc1-staging1/drivers/md/dm.c	2006-04-17 10:51:49.000000000 -0400
+++ 2.6.17-rc1-staging2/drivers/md/dm.c	2006-04-17 10:51:49.000000000 -0400
@@ -846,6 +846,9 @@ static struct mapped_device *alloc_dev(u
 		return NULL;
 	}
 
+	if (!try_module_get(THIS_MODULE))
+		goto bad0;
+
 	/* get a minor number for the dev */
 	r = persistent ? specific_minor(md, minor) : next_free_minor(md, &minor);
 	if (r < 0)
@@ -912,6 +915,8 @@ static struct mapped_device *alloc_dev(u
 	blk_cleanup_queue(md->queue);
 	free_minor(minor);
  bad1:
+	module_put(THIS_MODULE);
+ bad0:
 	kfree(md);
 	return NULL;
 }
@@ -935,6 +940,7 @@ static void free_dev(struct mapped_devic
 
 	put_disk(md->disk);
 	blk_cleanup_queue(md->queue);
+	module_put(THIS_MODULE);
 	kfree(md);
 }
 
