From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 9 Sep 2009 13:30:03 -0400
Message-ID: <20090909173003.GE8256@redhat.com>
References: <20090904231129.GA3689@redhat.com>
	<20090907.200222.193693062.ryov@valinux.co.jp>
	<4AA51065.6050000@redhat.com>
	<20090908.120119.71095369.ryov@valinux.co.jp>
	<4AA6AF58.3050501@redhat.com>
	<20090909000900.GK17468@gandalf.sssup.it>
	<20090909020620.GC3594@redhat.com>
	<20090909154126.GG17468@gandalf.sssup.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090909154126.GG17468@gandalf.sssup.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, nauman@google.com, jens.axboe@oracle.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Wed, Sep 09, 2009 at 05:41:26PM +0200, Fabio Checconi wrote:
> > From: Vivek Goyal <vgoyal@redhat.com>
> > Date: Tue, Sep 08, 2009 10:06:20PM -0400
> >
> > On Wed, Sep 09, 2009 at 02:09:00AM +0200, Fabio Checconi wrote:
> > > Hi,
> > > 
> > > > From: Rik van Riel <riel@redhat.com>
> > > > Date: Tue, Sep 08, 2009 03:24:08PM -0400
> > > >
> > > > Ryo Tsuruta wrote:
> > > > >Rik van Riel <riel@redhat.com> wrote:
> > > > 
> > > > >>Are you saying that dm-ioband is purposely unfair,
> > > > >>until a certain load level is reached?
> > > > >
> > > > >Not unfair, dm-ioband(weight policy) is intentionally designed to
> > > > >use bandwidth efficiently, weight policy tries to give spare bandwidth
> > > > >of inactive groups to active groups.
> > > > 
> > > > This sounds good, except that the lack of anticipation
> > > > means that a group with just one task doing reads will
> > > > be considered "inactive" in-between reads.
> > > > 
> > > 
> > >   anticipation helps in achieving fairness, but CFQ currently disables
> > > idling for nonrot+NCQ media, to avoid the resulting throughput loss on
> > > some SSDs.  Are we really sure that we want to introduce anticipation
> > > everywhere, not only to improve throughput on rotational media, but to
> > > achieve fairness too?
> > 
> > That's a good point. Personally I think that fairness requirements for
> > individual queues and groups are little different. CFQ in general seems
> > to be focussing more on latency and throughput at the cost of fairness.
> > 
> > With groups, we probably need to put a greater amount of emphasis on group
> > fairness. So group will be a relatively a slower entity (with anticiaption
> > on and more idling), but it will also give you a greater amount of
> > isolation. So in practice, one will create groups carefully and they will
> > not proliferate like queues. This can mean overall reduced throughput on
> > SSD.
> > 
> 
> Ok, I personally agree on that, but I think it's something to be documented.
> 

Sure. I will document it in documentation file.

> 
> > Having said that, group idling is tunable and one can always reduce it to
> > achieve a balance between fairness vs throughput depending on his need.
> > 
> 
> This is good, however tuning will not be an easy task (at least, in my
> experience with BFQ it has been a problem): while for throughput usually
> there are tradeoffs, as soon as a queue/group idles and then timeouts,
> from the fairness perspective the results soon become almost random
> (i.e., depending on the rate of successful anticipations, but in the
> common case they are unpredictable)...

I am lost in last few lines. I guess you are suggesting that static tuning
is hard and dynamically adjusting idling has limitations that it might not
be accurate all the time?

I will explain how things are working in current set of io scheduler
patches.

Currently on top of queue idling, I have implemented group idling also.
Queue idling is dynamic and io scheduler like CFQ keeps track of
traffic pattern on the queue and disables/enables idling dynamically. So
in this case fairness depends on rate of successful anticipations by the
io scheduler.

Group idling currently is static in nature and purely implemented in
elevator fair queuing layer. Group idling kicks in only when a group is
empty at the time of queue expiration and underlying ioscheduler has not
chosen to enable idling on the queue. This provides us the gurantee that
group will keep on getting its fair share of disk as long as a new request
comes in the group with-in that idling period.

Implementing group idling ensures that it does not bog down the io scheduler
and with-in group queue switching can still be very fast (no idling on many of
the queues by cfq).

Now in case of SSD if group idling is really hurting somebody, I would
expect him to set it to either 1 or 0. You might get better throughput
but then expect fairness for the group only if the group is continuously
backlogged. (Something what dm-ioband guys seem to be doing).

So do you think that adjusting this "group_idling" tunable is too
complicated and there are better ways to handle it in case of SSD+NCQ?

Thanks
Vivek
