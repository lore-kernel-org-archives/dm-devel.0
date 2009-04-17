From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [k-ueda@ct.jp.nec.com: Re: request-based
	dm-multipath]
Date: Thu, 16 Apr 2009 22:01:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904161952340.312@hs20-bc2-1.build.redhat.com>
References: <20090410151914.GA3800@redhat.com>
	<20090410153102.GC3800@redhat.com>
	<Pine.LNX.4.64.0904151443170.23593@hs20-bc2-1.build.redhat.com>
	<20090415201829.GB9064@redhat.com>
	<Pine.LNX.4.64.0904151757160.23374@hs20-bc2-1.build.redhat.com>
	<49E6FAC5.2080807@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49E6FAC5.2080807@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Michael Christie <mchristi@redhat.com>, agk@redhat.com
List-Id: dm-devel.ids



On Thu, 16 Apr 2009, Jun'ichi Nomura wrote:

> The main purpose of request-based dm patches is to provide a framework
> to implement optimal path selectors in non-intrusive way.
> 
> As you mentioned, it might be possible to implement a good path
> selector at bio-level by checking internals of underlying devices' 
> request queues and/or I/O schedulers.
> 
> However, requiring knowledge/assumptions of internals of other layer
> is not a right approach.

There is also a number of functions that any driver can call on queue to 
access the queue state (see blkdev.h).

So if you add one more function (something like 
blk_queue_can_merge_at_this_point(struct request_queue *, sector_t), 
there's nothing wrong about it, it's much less intrusive than adding an 
alternate i/o path.

> Or, splitting the request-based multipath driver out of dm would trash
> the existing userspace tools and libraries, so that's not good either.
> Thus we chose the design of 'adding request-based mapping feature to dm'.
> It doesn't break existing target drivers and userspace tools.
> The feature is enabled only for request-based target drivers.
> If you want to add a bio-specific new feature, it's still possible.

I don't want to pull multipath out of dm. I want it to use the standard 
i/o path in dm.

I am convinced that the path balacing can be solved without using 
requests.

> The design has been discussed in several mailing lists, Ottawa Linux Symposium
> and Linux Storage/Filesystem workshop including maintainers
> of related subsystems for these few years,
> and I think we got basic agreement on this direction.

That is groupthink (http://en.wikipedia.org/wiki/Groupthink). It is not 
valid argument to support your point with opinions of other people. You 
should either support it with *your own* opinion or not supoprt it at all 
:)

> As for your barrier works, we are looking into the patches
> to make them work on request-based dm as well.

So you'll have to write barriers and maybe you start to see why this 
approach is not so good.

Basically, suppose that you have a feature A and it takes "t(A)" time to 
implement it. You have a feature B and it takes "t(B)" time to implement 
it. Now --- if the software is correctly designed, the time to implement 
both features A and B is equal to t(A)+t(B). This is the ideal case how it 
should be. If the time to implement both A and B t(A and B) is grossly 
greater than t(A)+t(B), there is some trouble. If such disruptive features 
were added frequently, you end up with a system where programming time is 
exponentially dependent on the number of features --- i.e. something 
totally unmaintainable.

And this double-i/o path is exactly the same case. t(barriers) is some 
time. t(rq-based mpath) takes another time.
t(barriers & rq-based mpath) > t(barriers) + t(rq-based mpath) (because 
the barriers basically have to be reimplemented from scratch for 
the request-based i/o path). And any new features that come into the i/o 
path after barriers will also be twice harder.

See for example the thread with bugs here: 
https://www.redhat.com/archives/dm-devel/2009-March/thread.html#00026 It 
shows that that debugging-time-doubling that I talked about is already 
hapenning, you are fixing bugs that were already fixed in generic dm core 
long time ago. And I don't believe that those bugs are the last. If this 
patch goes in, we all will just double our maintenance time.


So I'm saying that if there's an alternate solution for multipath 
request-dispatching that doesn't have this maintenance-time-increasing 
problem, it should be tried.

Mikulas

> Thanks,
> -- 
> Jun'ichi Nomura, NEC Corporation
> 
