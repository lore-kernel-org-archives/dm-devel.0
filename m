From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH} dm-throttle: new device mapper target to
 throttle reads and writes
Date: Fri, 13 Aug 2010 13:19:41 +0200
Message-ID: <1281698381.17581.11.camel@o>
References: <1281447742.4964.46.camel@o> <20100810144457.GA9028@redhat.com>
	<1281604089.4964.346.camel@o>  <20100812164636.GC8831@redhat.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100812164636.GC8831@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, 2010-08-12 at 12:46 -0400, Vivek Goyal wrote:
> On Thu, Aug 12, 2010 at 11:08:09AM +0200, Heinz Mauelshagen wrote:
> > On Tue, 2010-08-10 at 10:44 -0400, Vivek Goyal wrote:
> > > On Tue, Aug 10, 2010 at 03:42:22PM +0200, Heinz Mauelshagen wrote:
> > > > 
> > > > This is a new device mapper "throttle" target which allows for
> > > > throttling reads and writes (ie. enforcing throughput limits) in units
> > > > of kilobytes per second.
> > > > 
> > > 
> > > Hi Heinz,
> > > 
> > > How about extending this stuff to handle cgroups also. So instead of
> > > having deivice wide throttling policy, we throttle cgroups. That will
> > > be a much more useful thing and will serve well the use case of throttling
> > > virtual machines in cgroup.
> > 
> > 
> > Hi Vivek,
> > 
> > needs a serious design discussion but I think we could leverage it to
> > allow for throttling of cgroups.
> > 
> 
> We need to parse cgroup information inside the dm taget (as CFQ does) and
> just prepare one queue per group and queue the IO there (If we exceeded
> the IO rate of group) and dispatch it later.
> 
> We also need to get the per cgroup rules from cgroup interface and not
> with the help of static device mapper tables at the device creation
> time.
> 
> I can write some code for dm-throttle for cgroup functioinality once
> basic dm-throttle is in.

Ok.

> 
> I am not sure that how to keep both the modes in dm-throttle taget
> 
> - cgroup mode
> - the whole device limitation mode. (you just created).

Need to learn more about cgroup internals to tell...

> 
> Mike Snitzer suggested that we can have both the modes and specify the
> mode at the time of device creation.

Yes, can be optional selected by a target constructor argument.

> 
> > > 
> > > Yesterday I had raised the issue of cgroup IO bandwidth throttling at
> > > Linux Storage and Filesystem session. I thought that a device mapper
> > > target will be the easiest thing to because I can make use of lots
> > > of existing infrastructure.
> > > 
> > > Christoph did not like it because of configuration concerns. He preferred
> > > something in block layer/request queue. It was also hinted that there
> > > were some ideas floating of better integation of device mapper
> > > infrastructure with request queue and this thing should go behind that.
> > 
> > Right, if a block layer change of that kind will be pending, we should
> > wait for it to settle.
> 
> I don't have details but to me it sounds as if it is just a concept at
> this point of time. So waiting for that to happen might take too long
> and we want max bw control feature as soon as possible. IMHO, converting
> the dm-throttle later to use that new infrastructure will be a much
> better option.

Ok.

BTW:
I added the stashing/dispatching of bios to my repository.
Testing right now.

Tackling the bi_size > bps support next.

> 
> > 
> > > But the problem is I am not sure how long it is going to take before
> > > this new infrastructure becomes a reality and it will not be practical
> > > to wait for that.
> > 
> > Did any reliable plans come out of the discussion or will there be any
> > in the near future?
> 
> I am not aware of any. Alasdair will know more about it.

Ok, waiting for his summary once he got back.

> 
> > 
> > > 
> > > There is a possibility that we can put a hook in __make_request function
> > > and first take out all the bios and subject them to bandwidth limitation
> > > and then pass it to lower layers. But that will mean redoing lots of
> > > common infrastructure which has already been done. For example,
> > > 
> > > - What happens to queue congestion semantics.
> > > 
> > > 	- Request queue already has it based on requests and device mapper
> > > 	  seems to have its own congestion functions.
> > 
> > Yes, dm does.
> 
> I was looking into the dm code and found dm_any_congested(). So it looks
> like that dm just calls underlying devices to find out if any of the device
> is congested or not.

Right.

> 
> Thinking more about it, congestion semantics seem to have been defined
> for a thread which does not want to sleep because of request descriptor
> allocation. In case of bandwidth control, we will not be allocating
> any request descriptors. Bios will be handed to us. No cloning operation
> required so no bio allocations required. I might have to do some
> allocation of internal structures though like group, queue etc when a new 
> request comes in.
> 
> So because I will not be putting any artificial restrictions on number
> if bios queued for throttling (unlike request descriptors), I probably
> don't require any congestion semantics. The only time a thread might
> be put to sleep if mempool_alloc() puts it to sleep because of some
> memory reclaim taking place. That's how dm seems to be handling it and
> if that is acceptable then it should be acceptable for bandwidth
> controller on request queue?

I think so. We'll have to figure it out when we proceed.

> 
> > 
> > > 
> > > 	- If I go for taking the bio out on request queue and hold them
> > >    	  back then I am not sure how to define congestion semantics.
> > > 	  To keep congestion semantcs simple, it would make sense to
> > >  	  create a new request queue (with the help of dm target), and
> > > 	  use that.
> > 
> > Yes, that's an obvious approach to stay with the same congestion
> > semantics.
> 
> See above? If I am not putting an artificial limit on number of bios that
> can be submitted on request queue, then I don't require any additional
> congestion semantics. The only time a thread will put to sleep if we
> are not able to allocate some objects like group and per group queue etc.
> Otherwise, a thread will submit the bio and go back and do something else
> or wait for io to finish.

Ok.

> 
> > 
> > > 
> > > - I have yet to think through it but I think I wil be doing other common
> > >   operations like holding back requests in internal queues, dispatching
> > >   these later with the help of a kernel thread, allowing some to dispatch
> > >   immediately as these come in, Putting processes to sleep and waking
> > >   them later if we are already holding too many bios etc.
> > > 
> > > To me it sounds that doing it is lot simpler with the help of device
> > > mapper target. Though the not so nice part is the need of configuring
> > > another device mapper target on every block device we want to control.
> > 
> > Yes, we'd need identity mappings in the stack to be prepared.
> > 
> > Or we need some __generic_make_request() hack ala bcache to hijack the
> > request function on the fly.
> 
> I will look at bcache but yes it would be a hook in __generic_make_request()
> if bandwidth control has to be done in request queue/block layer and not
> as device mapper target.

This is back to the general discussion where bandwidth control should be
layered. The more generically things like bandwidth control are possible
to do, the better.

dm-throttle OTOH is only meant to be for testing purposes so far.

If the decision goes to do it in the block layer for production, we have
to see if we can drop such testing targets,

Heinz

> 
> Vivek
