From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM ATTEND] multipath redesign and dm blk-mq
	issues
Date: Thu, 28 Jan 2016 21:48:19 -0500
Message-ID: <20160129024819.GA8242@redhat.com>
References: <20160128212315.GX24960@octiron.msp.redhat.com>
	<20160128223732.GA7060@redhat.com>
	<20160129013316.GY24960@octiron.msp.redhat.com>
	<20160129021132.GZ24960@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160129021132.GZ24960@octiron.msp.redhat.com>
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

On Thu, Jan 28 2016 at  9:11pm -0500,
Benjamin Marzinski <bmarzins@redhat.com> wrote:

> On Thu, Jan 28, 2016 at 07:33:16PM -0600, Benjamin Marzinski wrote:
> > On Thu, Jan 28, 2016 at 05:37:33PM -0500, Mike Snitzer wrote:
> > > On Thu, Jan 28 2016 at  4:23pm -0500,
> > > Benjamin Marzinski <bmarzins@redhat.com> wrote:
> 
> > > blk-mq's .queue_rq hook is the logical place to do the mpath mapping, as
> > > it deals with getting a request from the underlying paths.
> > > 
> > > blk-mq's .map_queue is all about mapping sw to hw queues.  It is very
> > > blk-mq specific and isn't something DM has a roll in -- cannot yet see
> > > why it'd need to.
> > 
> > At the moment, we only have one hwqueue.  But we could have one hwqueue
> > per path. Then queue_rq would just be in charge of handing the requst
> > down to the underlying device.  In that setup, instead using a default
> > mapping of all swqueues to one hwqueue in .map_queue, we would be
> > mapping to the hardware queue for the path.  I'd have to look through
> > the blk-mq code more to know if one of these methods has an obvious
> > advantage, but it seems like this way, if different cpus were using
> > different paths (with the per-cpu load-balancing), you wouldn't
> > constantly be accessing the hwqueue from different cpus. Although I
> > suppose you may do better just by leaving multipath_map where it is now,
> > and just adjusting the number of hardware queues. Speaking of which,
> > have you tried fiddling around with that in your tests?
> > 
> 
> O.k. a quick look shows that map_queue get called so often that any sort
> of dynamic mapping there would be a pain.  But constantly having all the
> cpus accessing one hwqueue seems like it could be part of the
> performance issue. So, it would definitely be worth playing around with
> that.

Yeah, I have a patch that makes both hw_queues and queue_depth tunable:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=devel2&id=99ebcaf36d9d1fa3acec98492c36664d57ba8fbd

Increasing nr_hw_queues doesn't help (in fact it hurts, going from 1 to
2 results in a drop from ~970K to ~945K IOPs, to 4 I get ~930K).

Will need to revisit the blk-mq code in general to appreciate how the
sw -> hw mapping will scale, etc.

And verify assumptions like: the top-level dm-mpath rq->mq_ctx->cpu
matches the underlying path's clone->mq_ctx->cpu
