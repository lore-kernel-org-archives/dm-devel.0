From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [k-ueda@ct.jp.nec.com: Re: request-based
	dm-multipath]
Date: Thu, 16 Apr 2009 18:30:45 +0900
Message-ID: <49E6FAC5.2080807@ce.jp.nec.com>
References: <20090410151914.GA3800@redhat.com>
	<20090410153102.GC3800@redhat.com>
	<Pine.LNX.4.64.0904151443170.23593@hs20-bc2-1.build.redhat.com>
	<20090415201829.GB9064@redhat.com>
	<Pine.LNX.4.64.0904151757160.23374@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904151757160.23374@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Michael Christie <mchristi@redhat.com>, agk@redhat.com
List-Id: dm-devel.ids

Mikulas Patocka wrote:
>>> What is the exact reason for your patch? I suppose that it's some 
>>> performance degradation caused by the fact that dm-multipath doesn't 
>>> distributes requests optimally across both paths. dm-multipath has 
>>> pluggable path selectors, so you could improve dm-round-robin.c (or write 
>>> alternate path selector module) and you don't have to touch generic dm 
>>> code to solve this problem.
>>>
>>> The point is that improving dm-multipath target with better path selector 
>>> is much less intrusive than patching device mapper core. If you improve 
>>> dm-multipath target, only people hacking on dm-multipath will have to 
>>> learn about your code. If you modify generic dm.c file, anyone doing 
>>> anything on device mapper must learn about your code --- so human time 
>>> consumed in much worse in this case.
>>>
>>> So, try the alternate solution (write new path selector for dm-multipath) 
>>> and then you can compare them and see the result --- and then it can be 
>>> consisdered if the high human time consumed by patching dm.c is worth the 
>>> performance improvement.

The main purpose of request-based dm patches is to provide a framework
to implement optimal path selectors in non-intrusive way.

As you mentioned, it might be possible to implement a good path
selector at bio-level by checking internals of underlying devices' 
request queues and/or I/O schedulers.

However, requiring knowledge/assumptions of internals of other layer
is not a right approach.
Or, splitting the request-based multipath driver out of dm would trash
the existing userspace tools and libraries, so that's not good either.
Thus we chose the design of 'adding request-based mapping feature to dm'.
It doesn't break existing target drivers and userspace tools.
The feature is enabled only for request-based target drivers.
If you want to add a bio-specific new feature, it's still possible.

The design has been discussed in several mailing lists, Ottawa Linux Symposium
and Linux Storage/Filesystem workshop including maintainers
of related subsystems for these few years,
and I think we got basic agreement on this direction.


As for your barrier works, we are looking into the patches
to make them work on request-based dm as well.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
