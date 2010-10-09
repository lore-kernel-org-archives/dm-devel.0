From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio-blk: put request that was created to retrieve the device id
Date: Sat, 9 Oct 2010 12:11:04 +1030
Message-ID: <201010091211.05478.rusty@rustcorp.com.au>
References: <20100909152658.GA8118@redhat.com> <20100909203052.GL30086@us.ibm.com> <20100909210042.GA22092@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20100909210042.GA22092@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ryan Harper <ryanh@us.ibm.com>, dm-devel@redhat.com, kvm@vger.kernel.org, john.cooper@redhat.com
List-Id: dm-devel.ids

On Fri, 10 Sep 2010 06:30:42 am Mike Snitzer wrote:
> On Thu, Sep 09 2010 at  4:30pm -0400,
> Ryan Harper <ryanh@us.ibm.com> wrote:
> 
> > * Mike Snitzer <snitzer@redhat.com> [2010-09-09 15:15]:
> > > On Thu, Sep 09 2010 at  3:43pm -0400,
> > > Mike Snitzer <snitzer@redhat.com> wrote:
> > > # while true ; do cat /sys/block/vda/queue/nr_requests_used && cat /sys/block/vda/serial && date && sleep 1 ; done
> > > 10
> > > Thu Sep  9 16:04:40 EDT 2010
> > > 11
...
> > The qemu on the host isn't new enough to handle the request.  This
> > serial attribute should have had a feature bit with it (it did at one
> > point in one of the previous forms of the virtio-blk serial patch
> > series, but it isn't present now) so we don't expose the attribute
> > unless backend can handle the request type.
> 
> Be that as it may, it doesn't change the fact that the request created
> in virtblk_get_id (via blk_make_request) isn't being properly cleaned
> up.

Thanks for re-sending Mike.

This patch confused me at first, but it's correct.  Took me a few
minutes of checking though.

For those not familiar with the block layer, here are the key points:

1) blk_execute_rq waits for the request to finish.
2) blk_execute_rq grabs its own reference to the req.
3) Once qemu finishes with it and sends an interrupt blk_done()
   releases that reference via __blk_end_request_all()
4) As caller of blk_make_request, it is our responsibility to
   free it after it's finished, ie. after blk_execute_rq.

> This patch fixes the issue for me; Rusty and/or Christoph please
> review/advise.

Thanks, applied, and CC'd stable@kernel.org (it's in 2.6.35 as well).

From: Mike Snitzer <snitzer@redhat.com>
Subject: virtio-blk: fix request leak.

Must drop reference taken by blk_make_request().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: stable@kernel.org # .35.x
---
 drivers/block/virtio_blk.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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
