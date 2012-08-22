From: Milan Broz <mbroz@redhat.com>
Subject: Re: [RFC PATCH 00/20] dm-crypt: parallel processing
Date: Wed, 22 Aug 2012 12:28:41 +0200
Message-ID: <5034B459.1000107@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<503356E7.4080604@redhat.com> <20120821182340.GA24861@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120821182340.GA24861@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On 08/21/2012 08:23 PM, Tejun Heo wrote:
> Hello,
> 
> (cc'ing Jens and Vivek, hi!)
> 
> On Tue, Aug 21, 2012 at 11:37:43AM +0200, Milan Broz wrote:
>> Better adding cc to Tejun here, I still think there are several things
>> which perhaps should be done through kernel wq...
>>
>> (I would prefer to use kernel wq as well btw.)
> 
> What do you mean by kernel wq?  One of the system_*_wq's?  If not,
> from scanning the patch names, it seems like it's converting to
> unbound workqueue from bound one.

I meant just extend bound workqueue as you mentioned below.

...

>>> 2) Could be kernel workqueue used/fixed here instead? Basically all it needs
>>> is to prefer submitting CPU, if it is busy just move work to another CPU.
> 
> The problem, I suppose, is that w/ wq, it's either bound or completely
> unbound.  If bound, the local CPU can become the bottleneck.  If
> unbound, wq doesn't discern local and remote at all and thus loses any
> benefit from locality association.
> 
> It would be nice if workqueue can somehow accomodate the situation
> better - maybe by migrating the worker to the issuing CPU before
> setting it loose so that the scheduler needs to migrate it away
> explicitly.  Maybe we can do it opportunistically - e.g. record which
> CPU an unbound worker was on before entering idle and queue to local
> one if it exists.  It wouldn't be trivial to implement tho.  I'll
> think more about it.

Yes, something like this.

dmcrypt basically should have parameter which says how it will use workqueue(s)

IMHO three basic cases:

1) just use bound 1 wq per device. (this mode is usual for specific cases,
some people have several dmcrypt devices with RAID on top - it was workaround
to 1 thread per dmcrypt device in older kernel. This increased throughput
but with recent kernel it does exact opposite... So this mode provides
workaround for them.)

2) Use all CPU possible just prefer local CPU if available
(something between bound and unbound wq)

3) the same as 2) just with limited # of CPU per crypt device.

(but Mikulas' code uses also some batching of request - not sure how
to incorporate this)

Whatever, if logic is implemented in workqueue code, others can use t as well.
I would really prefer not to have "too smart" dmcrypt...
(Someone mentioned btrfs on top of it with all workqueues - how it can behave nicely
if every layer will try to implement own smart logic.)

Anyway, thanks for discussion, this is exactly what was missing here :)

Milan
