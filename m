From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [k-ueda@ct.jp.nec.com: Re: request-based
	dm-multipath]
Date: Fri, 17 Apr 2009 18:46:36 +0900
Message-ID: <49E84FFC.3050709@ce.jp.nec.com>
References: <20090410151914.GA3800@redhat.com>
	<20090410153102.GC3800@redhat.com>
	<Pine.LNX.4.64.0904151443170.23593@hs20-bc2-1.build.redhat.com>
	<20090415201829.GB9064@redhat.com>
	<Pine.LNX.4.64.0904151757160.23374@hs20-bc2-1.build.redhat.com>
	<49E6FAC5.2080807@ce.jp.nec.com>
	<Pine.LNX.4.64.0904161952340.312@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904161952340.312@hs20-bc2-1.build.redhat.com>
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
> On Thu, 16 Apr 2009, Jun'ichi Nomura wrote:
>> The main purpose of request-based dm patches is to provide a framework
>> to implement optimal path selectors in non-intrusive way.
>>
>> As you mentioned, it might be possible to implement a good path
>> selector at bio-level by checking internals of underlying devices' 
>> request queues and/or I/O schedulers.
>>
>> However, requiring knowledge/assumptions of internals of other layer
>> is not a right approach.
> 
> There is also a number of functions that any driver can call on queue to 
> access the queue state (see blkdev.h).
> 
> So if you add one more function (something like 
> blk_queue_can_merge_at_this_point(struct request_queue *, sector_t), 
> there's nothing wrong about it, it's much less intrusive than adding an 
> alternate i/o path.

And it means exposing the I/O scheduler internal to let
the path selector guess its behavior, which is what I would like to avoid.

I think existing block layer interfaces are not doing that.


>> Or, splitting the request-based multipath driver out of dm would trash
>> the existing userspace tools and libraries, so that's not good either.
>> Thus we chose the design of 'adding request-based mapping feature to dm'.
>> It doesn't break existing target drivers and userspace tools.
>> The feature is enabled only for request-based target drivers.
>> If you want to add a bio-specific new feature, it's still possible.
> 
> I don't want to pull multipath out of dm. I want it to use the standard 
> i/o path in dm.
> 
> I am convinced that the path balacing can be solved without using 
> requests.

The point is not about 'can' or 'cannot'.

My point is that by adding the request-based mapping interface,
path selectors can be implemented in a clean and maintainable way.


Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
