From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: Work with blk multi-queue drivers
Date: Wed, 24 Sep 2014 14:34:54 -0400
Message-ID: <20140924183453.GA23052@redhat.com>
References: <1411491802-7356-1-git-send-email-keith.busch@intel.com>
	<20140924145215.GA26398@infradead.org>
	<alpine.LRH.2.03.1409241020540.4696@AMR>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.03.1409241020540.4696@AMR>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Sep 23 2014 at  1:03pm -0400,
Keith Busch <keith.busch@intel.com> wrote:

> I hear there may be some resistance to add blk-mq support to dm-mpath
> anyway, but it seems too easy to add support to not at least try. :)

Why?  Not sure who you heard that from but I'm not opposed to it if it
is done properly.


On Wed, Sep 24 2014 at  1:20pm -0400,
Keith Busch <keith.busch@intel.com> wrote:

> On Wed, 24 Sep 2014, Christoph Hellwig wrote:
> >>index bf930f4..4c5952b 100644
> >>--- a/block/blk-core.c
> >>+++ b/block/blk-core.c
> >
... 
> >> 	unsigned long flags;
> >> 	struct pgpath *pgpath;
> >> 	struct block_device *bdev;
> >>@@ -410,9 +411,11 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
> >> 		goto out_unlock;
> >>
> >> 	bdev = pgpath->path.dev->bdev;
> >>-	clone->q = bdev_get_queue(bdev);
> >>-	clone->rq_disk = bdev->bd_disk;
> >>-	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
> >>+	*clone = blk_get_request(bdev_get_queue(bdev), rq_data_dir(rq),
> >>+							GFP_KERNEL);
> >
> >I suspect this should be GFP_NOWAIT so that we can push the request back
> >up the stack if none are available.
> 
> Aha, nice catch. I'd have hit the BUG_ON() in dm_request_fn() the way
> I wrote this since irq's could have been re-enabled if a request wasn't
> immediately available.
> 
> Thanks for the feedback!

We have never allowed new memory allocation in a DM target's .map or
.map_rq method.  The only allocations that are allowed are those backed
by a mempool (see md->io_pool usage in alloc_rq_tio, before the clone's
struct request was embedded in struct dm_rq_target_io).  This was done
to allow request-based DM devices to be stacked on each other.  Even
though nothing ever made use of stacking request-based DM devices; doing
so is still a DM design possibility.  Could be we can simply say "kill
request-based DM device stacking, it isn't needed".. if we went that far
then the per-rq-based-device mempool becomes much less important.

But building on this concern, historically each request-based DM device
has maintained a reserve for cloning a request (so that forward progress
can be ensured even if system memory is unavailable).  So AFAICT
Christoph's suggestion to switch to GFP_NOWAIT from GFP_KERNEL still
doesn't do enough to preserve the higher standards rq-based DM had
established for guaranteed ability to clone a request.

Taking a step back, I'm really _not_ liking the duality of the DM core
with regard to the cloning of a request.  Where a request-based DM
target (e.g. mpath) is tasked with calling blk_get_request() but then DM
core is left to manage the life-cycle of that clone that the target
allocated.  If anything a new dm_get_request() wrapper should be added
to DM core, subtle difference but then at least one can easily see
balanced request management within the DM core?

In general I'd really like to see a bit more care taken to improve the
block interface that DM is using for request-based DM.  What I mean is,
Hannes proposed a series that eliminated request-based DM's cloning of
requests (and associated bios), see thread:
http://www.redhat.com/archives/dm-devel/2014-June/msg00023.html

(that series was just a "test balloon" as Hannes put it, but it offered
some serious "cleanup" by nuking a lot of fiddly block layer code in DM
core)

I never did take the time to properly review Hannes' proposal but now
that you're floating this blk-mq support for DM core (and DM mpath) I'm
clearly going to have to take this all on in a much more focused way.

Christoph/Hannes/Junichi/Keith/others, can you see a way forward that
offers a lighter request-based DM that makes required callouts to (new?)
block interfaces that helps us abstract the old request and blk-mq
request allocation, etc?

Mike
