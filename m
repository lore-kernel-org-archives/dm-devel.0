From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Fri, 10 Jun 2011 09:44:25 +0100
Message-ID: <20110610084424.GA3672@ubuntu>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
	<Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
	<20110609094746.GA3152@ubuntu>
	<Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 09, 2011 at 12:08:08PM -0400, Mikulas Patocka wrote:
> 
> 
> On Thu, 9 Jun 2011, Joe Thornber wrote:
> > What we're trying to do is avoid kcopyd issuing so much io that it
> > interferes with userland io.
> 
> But you don't know if there is some userland IO or not to the same disk.

None the less, this was the motivation Alasdair gave for wanting this
throttling.

> > i) If there is lots of memory available can your throttling patch
> > still manage to issue too much io in the time that kcopyd is active?
> 
> It issues as much IO as it can in the active period.

Exactly, it can issue too much.

> > ii) If there is little memory available few ios will be issued.  But
> > your throttling will still occur, slowing things down even more.
> 
> Yes. Memory pressure and throttiling are independent things.

True, but if kcopyd has only managed to submit 50k of io in it's last
timeslice why on earth would you decide to put it to sleep rather than
try and issue some more?  I don't believe your time based throttling
behaves the same under different memory pressure situations.  So the
sys admin could set up your throttle parameters under one set of
conditions.  Then these conditions could change and result in either
too much or too little throttling.

> 
> > I think it makes much more sense to throttle based on amount of io
> > issued by kcopyd.  Either tracking throughput,
> 
> You don't know what is the throughput of the device. So throttling to 
> something like "50% throughput" can't be done.

I agree we don't know what the throughput on the devices is.  What I
meant was to throttle the volume of io that kcopyd generates against
an absolute value.  eg.  "The mirror kcopyd client cannot submit more
than 100M of io per second."  So you don't have to measure and
calculate any theoretical maximum throughput and calculate percentages
off that.

> > or even just putting a
> > limit on the amount of io that can be in flight at any one time.
> 
> Which is much less reliable throttling than time slots.
> the resync spee is:
> 8 sub jobs --- 76MB/s
> 2 sub jobs --- 74MB/s
> 1 sub job --- 65MB/s

I really don't understand these figures.  Why doesn't it scale
linearly with the number of sub jobs?  Are the sub jobs all the same
size in these cases?  Is this with your throttling?  Are the sub jobs
so large that memory pressure is imposing a max limit of in flight io?

- Joe
