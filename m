From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] dm-mpath: Improve handling of busy paths
Date: Thu, 21 Sep 2017 09:41:06 +0800
Message-ID: <20170921014102.GA6854@ming.t460p>
References: <20170920181212.5532-1-bart.vanassche@wdc.com>
	<20170920223605.GC5105@ming.t460p>
	<1505949968.2509.32.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1505949968.2509.32.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>, "snitzer@redhat.com" <snitzer@redhat.com>, "hare@suse.com" <hare@suse.com>
List-Id: dm-devel.ids

On Wed, Sep 20, 2017 at 11:26:09PM +0000, Bart Van Assche wrote:
> On Thu, 2017-09-21 at 06:36 +0800, Ming Lei wrote:
> > Actually with GFP_ATOMIC, dispatch in dm-rq can't move on and no request
> > will be dequeued from IO scheduler queue if this allocation fails, that
> > means IO merge is still working at that time if the patchset of
> > 'blk-mq-sched: improve SCSI-MQ performance' is applied.
> > 
> > As my test done, the sequential I/O performance is still not good
> > even though the patchset is applied.
> > 
> > That isn't strange because queue depth of IO scheduler queue can be
> > much bigger than either q->queue_depth or .cmd_per_lun, that means
> > the underlying queue has been busy for a while before the allocation
> > fails.
> 
> Hello Ming,
> 
> This patch is intended as an alternative for your patch series "dm-mpath:
> improve I/O schedule". I wanted to show that it is possible to reduce

Hi Bart,

As I explained, this patch can't fix the I/O merge issue since it is easy
to trigger queue busy before running out of requests, that is why I
changes the 'nr_request' in the patch 5 of 'dm-mpath: improve I/O schedule'.

> dm-mpath request submission latency if the underlying driver returns
> "busy" frequently without touching the "return DM_MAPIO_DELAY_REQUEUE"

I already explained, the DM_MAPIO_DELAY_REQUEUE can be changed
to DM_MAPIO_REQUEUE at least for dm-rq-mq via SCHED_RESTART, even
for dm-rq-sq, it should be possible but need to make sure there
is in-flight requests because we run queue in rq_completed().

-- 
Ming
