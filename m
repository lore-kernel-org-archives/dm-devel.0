From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM ATTEND] multipath redesign and dm blk-mq
	issues
Date: Thu, 28 Jan 2016 17:37:33 -0500
Message-ID: <20160128223732.GA7060@redhat.com>
References: <20160128212315.GX24960@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160128212315.GX24960@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, lsf-pc@lists.linux-foundation.org
List-Id: dm-devel.ids

On Thu, Jan 28 2016 at  4:23pm -0500,
Benjamin Marzinski <bmarzins@redhat.com> wrote:

> I'd like to attend LSF/MM 2016 to participate in any discussions about 
> redesigning how device-mapper multipath operates. I spend a significant
> chunk of time dealing with issues around multipath and I'd like to
> be part of any discussion about redesigning it.
> 
> In addition, I'd be interesting in disucssions that deal with how
> device-mapper targets are dealing with blk-mq in general.  For instance,
> it looks like the current dm-multipath blk-mq implementation is running
> into performance bottlenecks, and changing how path selection works into
> something that allows for more parallelism is a worthy discussion.

At this point this isn't the sexy topic we'd like it to be -- not too
sure how a 30 minute session on this will go.  The devil is really in
the details.  Hopefully we can have more details once LSF rolls around
to make an in-person discussion productive.

I've spent the past few days working on this and while there are
certainly various questions it is pretty clear that DM multipath's
m->lock (spinlock) is really _not_ a big bottleneck.  It is an obvious
one for sure, but I removed the spinlock entirely (debug only) and then
the 'perf report -g' was completely benign -- no obvious bottlenecks.
Yet DM mpath performance on a really fast null_blk device, ~1850K read
IOPs, was still only ~950K -- as Jens rightly pointed out to me today:

"sure, it's slower but taking a step back, it's about making sure we
have a pretty low overhead, so actual application workloads don't spend
a lot of time in the kernel

~1M IOPS is a _lot_".

But even still, DM mpath is dropping 50% of potential IOPs on the floor.
There must be something inherently limiting in all the extra work done
to: 1) stack blk-mq devices (2 completely different sw -> hw mappings)
2) clone top-level blk-mq requests for submission on the underlying
blk-mq paths.

Anyway, my goal is to have my contribution to this LSF session be all
about what was wrong and how it has been fixed ;)

But given how much harder analyzing this problem has become I'm less
encouraged I'll be able to do so.

> But it would also be worth looking into changes about how the dm blk-mq
> impementation deals with the mapping between it's swqueues and
> hwqueue(s). Right now all the dm mapping is done in .queue_rq, instead
> of in .map_queue, but I'm not convinced it belongs there.

blk-mq's .queue_rq hook is the logical place to do the mpath mapping, as
it deals with getting a request from the underlying paths.

blk-mq's .map_queue is all about mapping sw to hw queues.  It is very
blk-mq specific and isn't something DM has a roll in -- cannot yet see
why it'd need to.

> There's also the issue that the bio targets may scale better on blk-mq
> devices than the blk-mq targets.

Why is that surprising?  request-based DM (and block core) has quite a
bit more work that it does.

bio-based DM targets take a ~20% IOPs hit, whereas blk-mq request-based
DM takes a ~50% hit.  I'd _love_ for request-based DM to get to only a
~20% hit.  (And for the bio-based 20% hit to be reduced further).
