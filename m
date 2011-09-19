From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm mpath: maintain reference count for
 underlying devices
Date: Mon, 19 Sep 2011 10:34:13 -0400
Message-ID: <20110919143411.GA7965@redhat.com>
References: <1316181571-4691-1-git-send-email-snitzer@redhat.com>
	<4E76E5E8.9040701@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E76E5E8.9040701@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, jbottomley@parallels.com, roland@purestorage.com, device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 19 2011 at  2:49am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi Mike,
> 
> On 09/16/11 22:59, Mike Snitzer wrote:
> > When processing a request, DM-mpath's map_io() set the cloned request's
> > request_queue to the appropriate underlying device's request_queue
> > without getting a reference on that request_queue.
> > 
> > DM-mpath now maintains a reference count on the underlying devices'
> > request_queue.  This change wasn't motivated by a specific report but
> > code, like blk_insert_cloned_request(), will access the request_queue
> > with the understanding that the request_queue is valid.
> 
> Umm, I think it doesn't make sense.
> 
> DM opens underlying devices and it should be sufficient to keep
> request_queue from being freed.

I welcome your review but please be more specific in the future.

Sure DM opens the underlying devices:

dm_get_device()
  -> open_dev()
     -> blkdev_get_by_dev()
     	-> bdget()
	-> blkdev_get()

But DM only gets a reference on the associated block_device.

DM multipath makes use of the request_queue of each paths'
block_device.  Having a reference on the block_device isn't the same as
having a reference on the request_queue.

Point is, blk_cleanup_queue() could easily be called by the SCSI
subsystem for a device that is removed -- a request_queue reference is
taken by the underlying driver at blk_alloc_queue_node() time.  So SCSI
is free to drop the only reference in blk_cleanup_queue() which frees
the request_queue (unless upper layer driver like mpath also takes a
request_queue reference).

FYI, I got looking at mpath's request_queue references, or lack thereof,
because of this report/patch on LKML from Roland Drier:
https://lkml.org/lkml/2011/7/8/457

here was my follow-up to Roland:
https://lkml.org/lkml/2011/7/11/410

James Bottomley points out that we should always have a reference on the
request_queue (otherwise final put frees the request_queue on us):
https://lkml.org/lkml/2011/7/12/265

> If it was not enough, any other openers would have to get the reference
> count, too, and that should be done in more generic place.

For DM, dm-multipath is the only direct consumer of request_queue(s)
that DM didn't allocate.

We have no intention of adding another request-based target (in fact
there is serious doubt that request-based DM was ever worth it).  So I
avoided complicating the DM core (even if only slightly) for rq-based
concerns that are localized to dm-multipath.

Mike

p.s. it should be noted that AFAIK this patch is already part of Oracle
Linux's uek kernel...
