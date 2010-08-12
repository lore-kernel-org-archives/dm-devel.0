From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH} dm-throttle: new device mapper target to
 throttle reads and writes
Date: Thu, 12 Aug 2010 16:32:33 -0400
Message-ID: <20100812203233.GE8831@redhat.com>
References: <1281447742.4964.46.camel@o> <20100810144457.GA9028@redhat.com>
	<1281604089.4964.346.camel@o> <20100812164636.GC8831@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Aug 12, 2010 at 12:46:36PM -0400, Vivek Goyal wrote:

[..]
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

I guess I shall have to define some kind of congestion notion for bw
controlller also and reason being that with thorottling it might happen
that underlying devices are not congested at all and in that case some
process can keep on submitting the bios and consume ton of memory. So
to prevent that at some point of time I shall have to stop accepting
more bios and put the submitting process to sleep.

Vivek
