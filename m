From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/1] dm: do not allocate any mempools for
 blk-mq request-based DM
Date: Tue, 28 Apr 2015 06:22:04 -0400
Message-ID: <20150428102204.GB15131@redhat.com>
References: <1429957432-20672-1-git-send-email-hch@lst.de>
	<20150428005950.GA31039@redhat.com>
	<20150428010303.GB31039@redhat.com> <20150428062843.GA19065@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150428062843.GA19065@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Apr 28 2015 at  2:28am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Mon, Apr 27, 2015 at 09:03:04PM -0400, Mike Snitzer wrote:
> > Do not allocate the io_pool mempool for blk-mq request-based DM
> > (DM_TYPE_MQ_REQUEST_BASED) in dm_alloc_rq_mempools().
> > 
> > Also refine __bind_mempools() to have more precise awareness of which
> > mempools each type of DM device uses -- avoids mempool churn when
> > reloading DM tables (particularly for DM_TYPE_REQUEST_BASED).
> 
> Btw, I looked into this code and didn't dare to touch it before I
> understood how we deal with the case of dm-mpath using blk-mq and
> low level driver not or the other way around.

Current code does deal with:
1) blk-mq queue on non-blk-mq underlying devices
2) blk-mq queue on blk-mq underlying devices
3) non-blk-mq queue on non-blk-mq underlying devices
4) non-blk-mq queue on blk-mq underlying devices

But all these permutations do definitely make the code less
approachable and maintainable.

> As far as I can see we'd need the request mempool as long as the
> low level driver does not use dm-mq, independent of what dm-mpath
> itsel uses.
> 
> The code doesn't seem to handle this right, but as mentioned I'm not
> 100% sure and need to dive deeper into this.  Is there a place enforcing
> dm-mpath is using the same request type as the underlying devices?

It is dm-table.c:dm_table_set_type() that determines whether a given DM
table load references underlying devices that are all blk-mq or not.
Based on what it finds it either establishes the type as
DM_TYPE_REQUEST_BASED or DM_TYPE_MQ_REQUEST_BASED.

DM_TYPE_REQUEST_BASED will make use of io_pool, whereas
DM_TYPE_MQ_REQUEST_BASED won't.  There is an awkward duality where
use_blk_mq governs which mempools are created based on filter_md_type().
filter_md_type() is needed because the table's type is really only
concerned with the underlying devices' types -- not the top-level DM
queue.  So things are awkward until we establish the top-level queue
(then we just make use of q->mq_ops like normal).

It is dm.c:dm_setup_md_queue() that establishes the top-level DM queue
based on the type.

How the DM queue's requests are cloned depends the underlying devices
(e.g. blk-mq vs not).

Top-level blk-mq DM device uses the md's type (DM_TYPE_REQUEST_BASED vs
DM_TYPE_MQ_REQUEST_BASED) to judge how to clone the request.
DM_TYPE_REQUEST_BASED implies legacy path.

There is still some awkward branching in the IO path but it ended up
being surprisingly manageable.  Only concern I have is: in the long-run
will all this duality in the code compromise maintainability?  But
hopefully we can kill the old request_fn path in block core (if/when
blk-mq IO scheduling lands) and the DM code can be cleaned up
accordingly.
