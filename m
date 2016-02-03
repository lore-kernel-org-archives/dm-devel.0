From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Wed, 3 Feb 2016 13:04:06 -0500
Message-ID: <20160203180406.GA11591@redhat.com>
References: <20160125214016.GA10060@redhat.com>
	<20160125233717.GQ24960@octiron.msp.redhat.com>
	<20160126132939.GA23967@redhat.com>
	<56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com>
	<56A904B6.50407@dev.mellanox.co.il>
	<20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56AEFF63.7050606@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Mon, Feb 01 2016 at  1:46am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/30/2016 08:12 PM, Mike Snitzer wrote:
> > On Sat, Jan 30 2016 at  3:52am -0500,
> > Hannes Reinecke <hare@suse.de> wrote:
> > > 
> >> So nearly on par with your null-blk setup. but with real hardware.
> >> (Which in itself is pretty cool. You should get faster RAM :-)
> > 
> > You've misunderstood what I said my null_blk (RAM) performance is.
> > 
> > My null_blk test gets ~1900K read IOPs.  But dm-mpath ontop only gets
> > between 600K and 1000K IOPs depending on $FIO_QUEUE_DEPTH and if I
> > use multiple $NULL_BLK_HW_QUEUES.
> > 
> Right.
> We're using two 16G FC links, each talking to 4 LUNs.
> With dm-mpath on top. The FC HBAs have a hardware queue depth
> of roughly 2000, so we might need to tweak the queue depth of the
> multipath devices, too.
> 
> 
> Will be having a look at your patches.

I have staged quite a few patches in linux-next for the 4.6 merge window:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.6

I'm open to posting them to dm-devel if it would ease review.  Let me
know.

These changes range from:
- defaulting to queue_depth of 2048 (rather than 64) request per blk-mq
  hw queue -- fixed stalls waiting for finite amount of tags (in bt_get)
- making additional use of the DM-multipath blk-mq device's pdu for
  mpath per-io data structures
- using blk-mq interfaces rather than generic wrappers (mainly just
  helps document the nature of the requests in blk-mq specific code
  paths)
- avoiding running the blk-mq hw queues on request completion (doesn't
  seem to help like it does for .request_fn multipath; only serves to
  generate extra kblockd work for no observed gain)
- optimize both .request_fn (dm_request_fn) and blk-mq (dm_mq_queue_rq)
  so they don't bother with the bio-based DM pattern of finding which
  target is used to map IO at the particular offset -- request-based DM
  only ever has a single immutable target associated with it
- removal of dead code and code comment improvements

I've seen blk-mq DM-multipath performance improvement but _not_ enough
to consider this line of work "done".  I'd be very interested to see
what kind of improvements you (Hannes) and Sagi can realize with your
respective testbeds.

I'm still not clear on where the considerable performance loss is coming
from (on null_blk devices I see ~1900K read IOPs but I'm still only
seeing ~1000K read IOPs when blk-mq DM-multipath is layered ontop).
What is very much apparent is layering dm-mq multipath ontop of null_blk
results in a HUGE amount of additional context switches.  I can only
infer that the request completion for this stacked device (blk-mq queue
ontop of blk-mq queue, with 2 completions: 1 for clone completing on
underlying device and 1 for original request completing) is the reason
for all the extra context switches.

Here are pictures of 'perf report' for perf datat collected using
'perf record -ag -e cs'.

Against null_blk:
http://people.redhat.com/msnitzer/perf-report-cs-null_blk.png
Against dm-mpath ontop of the same null_blk:
http://people.redhat.com/msnitzer/perf-report-cs-dm_mq.png

Looks like there may be some low-hanging fruit associated with steering
completion to reduce all the excessive ksoftirq and kworker context
switching.  Pin-pointing the reason these tasks are context switching is
my next focus.

I've yet to actually test on DM-multipath device with more than one
path.  Hannes, Sagi, and/or others: on such a setup it would be
interesting to see if increasing the 'blk_mq_nr_hw_queues' helps at all.
Any 'perf report' traces that shed light on bottlenecks you might be
experiencing would obviously be appreciated.  I'm skeptical there is
enough parallelism in the dm-mpath.c code to allow for proper scaling --
switching to RCU could help this.

Mike

p.s.
I experimented with using the top-level DM multipath blk-mq queue's
pdu for the underlying clone 'struct request' that is implicitly needed
when issuing the request to the underlying path -- by (ab)using
blk_mq_tag_set_rq that is used by blk-flush.c.  blk-mq hated me for
trying this.  I kept getting list corruption on unplug with this (and
many variants on work along these lines):
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=devel2&id=7b7203c93cec7ad3a0ae2a2da567d45f46fe8098

I stopped that line of work due to inability to make it function.. but
it was a skunk-works experiment that needed to die anyway (as I'm sure
Jens will agree).
