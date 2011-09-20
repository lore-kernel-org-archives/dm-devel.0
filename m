From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH v2] dm mpath: maintain reference count for
 underlying devices
Date: Tue, 20 Sep 2011 14:29:47 +0900
Message-ID: <4E7824CB.9030405@ce.jp.nec.com>
References: <1316181571-4691-1-git-send-email-snitzer@redhat.com>
	<4E76E5E8.9040701@ce.jp.nec.com> <20110919143411.GA7965@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110919143411.GA7965@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, jbottomley@parallels.com, roland@purestorage.com, device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mike,

On 09/19/11 23:34, Mike Snitzer wrote:
> On Mon, Sep 19 2011 at  2:49am -0400,
> Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:
>> DM opens underlying devices and it should be sufficient to keep
>> request_queue from being freed.
> 
> I welcome your review but please be more specific in the future.
> 
> Sure DM opens the underlying devices:
> 
> dm_get_device()
>   -> open_dev()
>      -> blkdev_get_by_dev()
>      	-> bdget()
> 	-> blkdev_get()
> 
> But DM only gets a reference on the associated block_device.

Point is the above should be sufficient to keep the queue from freeing.
Otherwise, 'q->_something_' everywhere could cause invalid pointer access
as the queue is freed.


Below are additional details replying to your comments:

> 
> DM multipath makes use of the request_queue of each paths'
> block_device.  Having a reference on the block_device isn't the same as
> having a reference on the request_queue.

Yes. But it does not necessarily mean we have to raise
a reference count of the request_queue.

> 
> Point is, blk_cleanup_queue() could easily be called by the SCSI
> subsystem for a device that is removed -- a request_queue reference is
> taken by the underlying driver at blk_alloc_queue_node() time.  So SCSI
> is free to drop the only reference in blk_cleanup_queue() which frees
> the request_queue (unless upper layer driver like mpath also takes a
> request_queue reference).

As for SCSI, it takes another reference count and drops it
in scsi_device_dev_release.
So blk_cleanup_queue is not dropping the last reference.

> 
> FYI, I got looking at mpath's request_queue references, or lack thereof,
> because of this report/patch on LKML from Roland Drier:
> https://lkml.org/lkml/2011/7/8/457
> 
> here was my follow-up to Roland:
> https://lkml.org/lkml/2011/7/11/410

For that problem, taking a reference count is not a remedy.
The problem occurs because elevator is freed regardless of the
reference count.

The cause of the problem was:
  a) SCSI has moved blk_cleanup_queue() to earlier stage
     where there still is a opener
  b) blk_cleanup_queue() frees elevator after marking
     the queue DEAD
  c) blk_insert_cloned_request() uses elevator without
     checking QUEUE_FLAG_DEAD

Roland's patch was to fix c) by adding QUEUE_FLAG_DEAD check.
However, it's not possible to do it safely because
QUEUE_FLAG_DEAD means we can't even access q->queue_lock.
(See Vivek's comment in the same thread)
And without queue_lock, there's a window for a race.

James's suggestion was to fix b) by not freeing elevator
until blk_release_queue() is called:
  https://lkml.org/lkml/2011/8/10/421
But it would hit the same issue that there's no guarantee
of q->queue_lock validity after blk_cleanup_queue().
James's other suggestion was to add a callback mechanism
for driver to free q->queue_lock.

I was trying to fix a) in the following thread:
  https://lkml.org/lkml/2011/8/18/103
but haven't gotten response from James so it seems rejected.


> 
> James Bottomley points out that we should always have a reference on the
> request_queue (otherwise final put frees the request_queue on us):
> https://lkml.org/lkml/2011/7/12/265

SCSI is taking a reference count of device being used.

> 
>> If it was not enough, any other openers would have to get the reference
>> count, too, and that should be done in more generic place.
> 
> For DM, dm-multipath is the only direct consumer of request_queue(s)
> that DM didn't allocate.

In DM, there are various users of underlying request_queue's member;
e.g. device_flush_capable(), dm_table_any_congested(), etc.

They would not be safe if request_queue was suddenly freed when
someone accessing 'q->something'.

> 
> We have no intention of adding another request-based target (in fact
> there is serious doubt that request-based DM was ever worth it).  So I
> avoided complicating the DM core (even if only slightly) for rq-based
> concerns that are localized to dm-multipath.

Where to put the code is about the maintainability.
So I don't mind if that's the maintainers' preference.

But for this specific patch, I don't understand why it is necessary
nor sufficient.

> p.s. it should be noted that AFAIK this patch is already part of Oracle
> Linux's uek kernel...

The patch should be harmless except for the extra complexity and
possible future maintenance burden.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
