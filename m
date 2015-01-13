From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq request allocation stalls
Date: Tue, 13 Jan 2015 10:41:39 -0500
Message-ID: <20150113154139.GB30700@redhat.com>
References: <54B3F255.5080802@sandisk.com> <54B3F78D.2020704@kernel.dk>
	<54B3FE89.200@sandisk.com> <54B3FFAE.4070609@kernel.dk>
	<alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
	<54B532EE.20700@kernel.dk>
	<alpine.LNX.2.00.1501131507570.4026@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501131507570.4026@localhost.lm.intel.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Tue, Jan 13 2015 at 10:11am -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Tue, 13 Jan 2015, Jens Axboe wrote:
> >On 01/12/2015 11:35 AM, Keith Busch wrote:
> >>On Mon, 12 Jan 2015, Keith Busch wrote:
> >>>Oh, let's look at "__blk_rq_prep_clone". dm calls that after
> >>>blk_get_request() for the blk-mq based multipath types and overrides the
> >>>destinations cmd_flags with the source's even though the source was not
> >>>allocated from a blk-mq based queue, much less a shared tag.
> >>
> >>Untested patch. This will also preserve the failfast cmd_flag dm-mpath
> >>set after allocating.
> >>
> >>---
> >>diff --git a/block/blk-core.c b/block/blk-core.c
> >>index 7e78931..6201090 100644
> >>--- a/block/blk-core.c
> >>+++ b/block/blk-core.c
> >>@@ -2895,7 +2895,10 @@ EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
> >>  static void __blk_rq_prep_clone(struct request *dst, struct request *src)
> >>  {
> >>      dst->cpu = src->cpu;
> >>-    dst->cmd_flags = (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
> >>+    if (dst->q->mq_ops)
> >>+        dst->cmd_flags |= (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
> >>+    else
> >>+        dst->cmd_flags = (src->cmd_flags & REQ_CLONE_MASK) | REQ_NOMERGE;
> >
> >Making the two cases different is a bit... nonsensical. We should
> >do this for both cases, if safe, or move the MQ_INFLIGHT flag and
> >expand the CLONE_MASK.
> 
> Expanding the clone mask won't do any good since the src doesn't come
> from blk-mq and wouldn't ever have MQ_INFLIGHT set. Blk-mq initializes
> the cmd_flags when you get one so I assumed OR'ing was safe. For the
> non-blk-mq case, we have no guarantees how the req was initialized and
> could have nonsense cmd_flags.

It _could_ but the only consumer of blk_rq_prep_clone() is request-based
DM, and the non-blk-mq case uses blk_rq_init() prior to calling
blk_rq_prep_clone() so the cmd_flags will be 0.

I've revised the patch to just do it for both cases since it will be
safe, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.20-blk-mq&id=6a55c9861326dc2a731c7978d93567dd4e62d2f7
