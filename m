From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Wed, 17 Dec 2014 18:06:23 -0500
Message-ID: <20141217230622.GC15390@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
	<alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>
	<5491F906.1090004@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5491F906.1090004@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: hch@infradead.org, bvanassche@acm.org, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On Wed, Dec 17 2014 at  4:43pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 12/17/2014 02:42 PM, Keith Busch wrote:
> > On Tue, 16 Dec 2014, Mike Snitzer wrote:
> >> Here is v3 of the request-based DM blk-support patchset.  I've also
> >> published a git repo here:
> >> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.20-blk-mq
> >>
> >>
> >> I found quite a few issues with v2 for both blk-mq and old
> >> request-based DM.  I've still attributed the original patches from
> >> Keith to him even though I fixed/rewrote significant portions.  Keith,
> >> I'm happy to leave attribution like this unless you'd prefer I change
> >> it.
> > 
> > Thanks a bunch, Mike! I'll need to merge your tree with Jens' for nvme
> > blk-mq, and one patch for a nvme scsi translation fix, then I can test
> > this out. I get my dual ported nvme controller back tomorrow, so should
> > have results before the end of the week.
> 
> All the juicy nvme bits are in Linus' tree now, so that should work!
> 
> BTW, Mike, do you have any perf numbers? Just curious how far along this is.

No, not yet.  I'll be focusing on the old request-based (non-blk-mq)
performance first though to make sure we haven't killed the common case
-- which obviously isn't what you're interested in ;)

The primary concerns for the old request-based path are:
1) does submission through a new dedicated (per rq-based DM device)
   kthread hurt? 
   https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20-blk-mq&id=aec254b435c9ee78103b90c229644be810274a33

2) does spliiting the request structure out from dm_rq_target_io
   structure hurt?
   https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20-blk-mq&id=a46bee4179e804b19e581d1b745e467d0ba946c1

I'm suspecting these changes should be fine but we'll see.

(Hannes, Christoph, Bart and/or Junichi: if you have some performant
multipath setups I'd love for you to try this code to make sure they
still perform well).

As for blk-mq support... I don't have access to any NVMe hardware, etc.
I only tested with virtio-blk (to a ramdisk, scsi-debug, device on the
host) so I'm really going to need to lean on Keith and others to
validate blk-mq performance.

So if you know someone with relevant blk-mq hardware who might benefit
from blk-mq multipathing please point them at this code and have them
report back!
