From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] virtio-blk: put request that was created to retrieve the
 device id
Date: Thu, 9 Sep 2010 17:00:42 -0400
Message-ID: <20100909210042.GA22092@redhat.com>
References: <20100909152658.GA8118@redhat.com>
 <20100909154442.GI30086@us.ibm.com>
 <20100909155726.GA9081@redhat.com>
 <20100909160324.GJ30086@us.ibm.com>
 <20100909175537.GA9589@redhat.com>
 <20100909183554.GK30086@us.ibm.com>
 <20100909191555.GA14486@redhat.com>
 <20100909194300.GA16908@redhat.com>
 <20100909201445.GA19656@redhat.com>
 <20100909203052.GL30086@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100909203052.GL30086@us.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Ryan Harper <ryanh@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Vivek Goyal <vgoyal@redhat.com>, john.cooper@redhat.com, rusty@rustcorp.com.au, hch@infradead.org, kvm@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Sep 09 2010 at  4:30pm -0400,
Ryan Harper <ryanh@us.ibm.com> wrote:

> * Mike Snitzer <snitzer@redhat.com> [2010-09-09 15:15]:
> > On Thu, Sep 09 2010 at  3:43pm -0400,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> > > Interestingly, just this loop:
> > > 
> > > while true ; do cat /sys/block/vda/serial && date && sleep 1 ; done
> > > Thu Sep  9 15:29:30 EDT 2010
> > > ...
> > > Thu Sep  9 15:31:19 EDT 2010
> > > 
> > > caused the following hang:
> > ...
> > > So it seems like the virtio requests aren't being properly cleaned up?
> > 
> > Yeap, here is the result with the attached debug patch that Vivek wrote
> > last week to help chase this issue (which adds 'nr_requests_used').  We
> > thought the mpath device might be leaking requests; concern for other
> > devices wasn't on our radar:
> > 
> > # cat /sys/block/vda/queue/nr_requests
> > 128
> > 
> > # while true ; do cat /sys/block/vda/queue/nr_requests_used && cat /sys/block/vda/serial && date && sleep 1 ; done
> > 10
> > Thu Sep  9 16:04:40 EDT 2010
> > 11
> > Thu Sep  9 16:04:41 EDT 2010
> > ...
> > Thu Sep  9 16:06:38 EDT 2010
> > 127
> > Thu Sep  9 16:06:39 EDT 2010
> > 128
> > 
> > I'll have a quick look at the virtio-blk code to see if I can spot where
> > the request isn't getting cleaned up.  But I welcome others to have a
> > look too (I've already spent entirely way to much time on this issue).
> 
> The qemu on the host isn't new enough to handle the request.  This
> serial attribute should have had a feature bit with it (it did at one
> point in one of the previous forms of the virtio-blk serial patch
> series, but it isn't present now) so we don't expose the attribute
> unless backend can handle the request type.

Be that as it may, it doesn't change the fact that the request created
in virtblk_get_id (via blk_make_request) isn't being properly cleaned
up.
 
> For immediate relief, it's probably easiest to revert the kernel-side
> commit (or comment out the device_create_file() call after add_disk() in
> virtblk_probe().

This patch fixes the issue for me; Rusty and/or Christoph please
review/advise.


From: Mike Snitzer <snitzer@redhat.com>
Subject: virtio-blk: put request that was created to retrieve the device id

Must drop reference taken by blk_make_request().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/block/virtio_blk.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 1260628..831e75c 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -199,6 +199,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	struct virtio_blk *vblk = disk->private_data;
 	struct request *req;
 	struct bio *bio;
+	int err;
 
 	bio = bio_map_kern(vblk->disk->queue, id_str, VIRTIO_BLK_ID_BYTES,
 			   GFP_KERNEL);
@@ -212,7 +213,10 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	}
 
 	req->cmd_type = REQ_TYPE_SPECIAL;
-	return blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
+	err = blk_execute_rq(vblk->disk->queue, vblk->disk, req, false);
+	blk_put_request(req);
+
+	return err;
 }
 
 static int virtblk_locked_ioctl(struct block_device *bdev, fmode_t mode,
