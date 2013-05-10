From: Hannes Reinecke <hare@suse.de>
Subject: Re: [git pull] device-mapper updates for 3.10
Date: Fri, 10 May 2013 12:40:34 +0200
Message-ID: <518CCEA2.7060205@suse.de>
References: <20130510102029.GE1396@agk-dp.fab.redhat.com>
	<518CCCBD.7050609@suse.de>
	<20130510103524.GG1396@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000500020409070402000608"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130510103524.GG1396@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000500020409070402000608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id r4AAecfs021775

On 05/10/2013 12:35 PM, Alasdair G Kergon wrote:
> On Fri, May 10, 2013 at 12:32:29PM +0200, Hannes Reinecke wrote:
>> "dm-multipath: Drop table when retrying ioctl"
> =20
> That one's not showing up: direct link or mail me it?
>=20
Here it is.

I _thought_ to have it sent to dm-devel, but apparently not.
Wonder what happened there...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

--------------000500020409070402000608
Content-Type: text/x-patch;
	name="dm-multipath-drop-table-when-retrying-ioctl.patch"
Content-Disposition: attachment;
	filename="dm-multipath-drop-table-when-retrying-ioctl.patch"
Content-Transfer-Encoding: 7bit

From 3e501ba7080d7913e85361ea0cef5b5c8fd1f153 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Tue, 23 Apr 2013 12:33:52 +0200
Subject: [PATCH] dm-multipath: Drop table when retrying ioctl

When multipath needs to retry an ioctl the reference to the
current live table needs to be dropped. Otherwise a deadlock
occurs when all paths are down:
- dm_blk_ioctl takes a reference to the current table
  and spins in multipath_iotcl().
- A new table is being loaded, but upon resume the process
  hangs in dm_table_destroy() waiting for references to
  drop to zero.

With this patch the reference to the old table is dropped
prior to retry, thereby avoiding the deadlock.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 51bb816..fb27edc 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1578,7 +1578,7 @@ again:
 	}
 
 	if ((pgpath && m->queue_io) || (!pgpath && m->queue_if_no_path))
-		r = -EAGAIN;
+		r = -ENOTCONN;
 	else if (!bdev)
 		r = -EIO;
 
@@ -1590,11 +1590,8 @@ again:
 	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
 		r = scsi_verify_blk_ioctl(NULL, cmd);
 
-	if (r == -EAGAIN && !fatal_signal_pending(current)) {
+	if (r == -ENOTCONN && !fatal_signal_pending(current))
 		queue_work(kmultipathd, &m->process_queued_ios);
-		msleep(10);
-		goto again;
-	}
 
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9a0bdad..cd749bf 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -388,10 +388,12 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long arg)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
-	struct dm_table *map = dm_get_live_table(md);
+	struct dm_table *map;
 	struct dm_target *tgt;
 	int r = -ENOTTY;
 
+retry:
+	map = dm_get_live_table(md);
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
@@ -412,6 +414,11 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 out:
 	dm_table_put(map);
 
+	if (r == -ENOTCONN) {
+		msleep(10);
+		goto retry;
+	}
+
 	return r;
 }
 

--------------000500020409070402000608
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--------------000500020409070402000608--
