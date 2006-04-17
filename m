From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 08/08] dm: fix ordering of initialization in
	alloc_dev()
Date: Mon, 17 Apr 2006 11:16:02 -0400
Message-ID: <20060417151602.GA18999@locomotive.unixthugs.org>
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


 In alloc_dev(), we register the device with the block layer and then
 continue to initialize the device. register_disk() will have already
 made the device available to userspace, and a potential race exists
 with the device being opened for use and the completion of the
 initialization.

 This patch moves the final bits of the initialization above the disk
 registration.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 drivers/md/dm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -ruNpX ../dontdiff 2.6.17-rc1-staging1/drivers/md/dm.c 2.6.17-rc1-staging2/drivers/md/dm.c
--- 2.6.17-rc1-staging1/drivers/md/dm.c	2006-04-17 10:51:50.000000000 -0400
+++ 2.6.17-rc1-staging2/drivers/md/dm.c	2006-04-17 10:51:50.000000000 -0400
@@ -885,6 +885,10 @@ static struct mapped_device *alloc_dev(u
 	if (!md->disk)
 		goto bad4;
 
+	atomic_set(&md->pending, 0);
+	init_waitqueue_head(&md->wait);
+	init_waitqueue_head(&md->eventq);
+
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
 	md->disk->fops = &dm_blk_dops;
@@ -894,10 +898,6 @@ static struct mapped_device *alloc_dev(u
 	add_disk(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
-	atomic_set(&md->pending, 0);
-	init_waitqueue_head(&md->wait);
-	init_waitqueue_head(&md->eventq);
-
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);
 	old_ide = idr_replace(&_minor_idr, md, minor);
