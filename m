From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: WARNING: at fs/block_dev.c:5 when removing LV on removed device
Date: Mon, 22 Jun 2015 13:46:48 -0400
Message-ID: <20150622174648.GA2965@redhat.com>
References: <20150618165713.GB19417@two.firstfloor.org>
 <20150618180408.GD2321@redhat.com>
 <20150618180804.GC19417@two.firstfloor.org>
 <20150618181619.GE2321@redhat.com>
 <20150618190815.GA6390@redhat.com>
 <20150618192821.GA4027@redhat.com>
 <20150619064721.GA1183@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150619064721.GA1183@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

On Fri, Jun 19, 2015 at 08:47:21AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 18, 2015 at 03:28:21PM -0400, Mike Snitzer wrote:
> > > WARN_ON_ONCE(write_inode_now(inode, true))
> > > 
> > > If we failed to write back inode, then warning about it sounds right?
> > 
> > A warning is fine.. not a WARN_ON().  Pretty alarming backtrace spew but
> > maybe I'm missing something and DM's blkdev refcount mgmt couldn't
> > trigger this WARN_ON()?  I fail to see how to avoid it given the device
> > isn't thre so write_inode_now() fails.
> > 
> > > What's wrong with that? Should it be just a kernel log of level KERN_WARN
> > > instead?
> > 
> > Ideally, but I honestly don't have all the details paged in my head to
> > say definitively.  First need to answer how vitrio-blk isn't hitting
> > this (and DM is).  Could it be that __blkdev_put isn't getting called
> > for virtio-blk!?
> 
> Just a warnings if fine.  In fact we can probably remove that as well
> as it will happen after a hot removal all the time.

[CC Tejun]

Does following patch look good?

Thanks
Vivek


Subject: fs/block_dev.c: Warn on inode writeback failure instead of WARN_ON()

If a block device is hot removed and later last reference to devices
is put, we try to writeback the dirty inode. But device is gone and
that writeback fails.

Currently we do a WARN_ON() which does not seem to be the right thing.
Convert it to a ratelimited kernel warning.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/block_dev.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: rhvgoyal-linux/fs/block_dev.c
===================================================================
--- rhvgoyal-linux.orig/fs/block_dev.c	2015-06-18 15:54:52.339383237 -0400
+++ rhvgoyal-linux/fs/block_dev.c	2015-06-22 12:55:47.642504742 -0400
@@ -48,12 +48,17 @@ inline struct block_device *I_BDEV(struc
 }
 EXPORT_SYMBOL(I_BDEV);
 
-static void bdev_write_inode(struct inode *inode)
+static void bdev_write_inode(struct block_device *bdev)
 {
+	struct inode *inode = bdev->bd_inode;
+
 	spin_lock(&inode->i_lock);
 	while (inode->i_state & I_DIRTY) {
 		spin_unlock(&inode->i_lock);
-		WARN_ON_ONCE(write_inode_now(inode, true));
+		if (write_inode_now(inode, true)) {
+			char name[BDEVNAME_SIZE] = "";
+			pr_warn_ratelimited("VFS: Dirty inode writeback failed for block device %s.\n", bdevname(bdev, name));
+		}
 		spin_lock(&inode->i_lock);
 	}
 	spin_unlock(&inode->i_lock);
@@ -1489,7 +1494,7 @@ static void __blkdev_put(struct block_de
 		 * ->release can cause the queue to disappear, so flush all
 		 * dirty data before.
 		 */
-		bdev_write_inode(bdev->bd_inode);
+		bdev_write_inode(bdev);
 	}
 	if (bdev->bd_contains == bdev) {
 		if (disk->fops->release)
