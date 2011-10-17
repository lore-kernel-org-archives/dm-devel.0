From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm mpath: maintain reference count for
 underlying devices
Date: Mon, 17 Oct 2011 16:15:14 -0400
Message-ID: <20111017201514.GA21731@redhat.com>
References: <1316181571-4691-1-git-send-email-snitzer@redhat.com>
	<4E76E5E8.9040701@ce.jp.nec.com> <20110919143411.GA7965@redhat.com>
	<4E7824CB.9030405@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E7824CB.9030405@ce.jp.nec.com>
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, jbottomley@parallels.com, roland@purestorage.com, device-mapper development <dm-devel@redhat.com>, tj@kernel.org, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 20 2011 at  1:29am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi Mike,
> 
> On 09/19/11 23:34, Mike Snitzer wrote:
> > On Mon, Sep 19 2011 at  2:49am -0400,
> > Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:
> >> DM opens underlying devices and it should be sufficient to keep
> >> request_queue from being freed.
> > 
> > I welcome your review but please be more specific in the future.
> > 
> > Sure DM opens the underlying devices:
> > 
> > dm_get_device()
> >   -> open_dev()
> >      -> blkdev_get_by_dev()
> >      	-> bdget()
> > 	-> blkdev_get()
> > 
> > But DM only gets a reference on the associated block_device.
> 
> Point is the above should be sufficient to keep the queue from freeing.
> Otherwise, 'q->_something_' everywhere could cause invalid pointer access
> as the queue is freed.
> 
> 
> Below are additional details replying to your comments:
> 
> > 
> > DM multipath makes use of the request_queue of each paths'
> > block_device.  Having a reference on the block_device isn't the same as
> > having a reference on the request_queue.
> 
> Yes. But it does not necessarily mean we have to raise
> a reference count of the request_queue.
> 
> > 
> > Point is, blk_cleanup_queue() could easily be called by the SCSI
> > subsystem for a device that is removed -- a request_queue reference is
> > taken by the underlying driver at blk_alloc_queue_node() time.  So SCSI
> > is free to drop the only reference in blk_cleanup_queue() which frees
> > the request_queue (unless upper layer driver like mpath also takes a
> > request_queue reference).
> 
> As for SCSI, it takes another reference count and drops it
> in scsi_device_dev_release.
> So blk_cleanup_queue is not dropping the last reference.

FYI, this patch from Tejun should also fix the concern I had relative to
mpath's underlying devices' request_queues:
https://lkml.org/lkml/2011/10/16/148
