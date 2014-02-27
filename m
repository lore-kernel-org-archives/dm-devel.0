From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-crypt: remove per-cpu structure
Date: Wed, 26 Feb 2014 20:12:40 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1402261955320.19557@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1402201758190.28312@file01.intranet.prod.int.rdu2.redhat.com>
	<20140220235935.GA32743@redhat.com>
	<alpine.LRH.2.02.1402201907120.29698@file01.intranet.prod.int.rdu2.redhat.com>
	<20140221023240.GA338@redhat.com>
	<alpine.LRH.2.02.1402210238470.5846@file01.intranet.prod.int.rdu2.redhat.com>
	<53087BD3.1000900@gmail.com> <20140222142526.GA12207@redhat.com>
	<5308DF91.6030003@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5308DF91.6030003@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, device-mapper development <dm-devel@redhat.com>, Lisa Du <chunlingdu1@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On Sat, 22 Feb 2014, Milan Broz wrote:

> On 02/22/2014 03:25 PM, Mike Snitzer wrote:
> > On Sat, Feb 22 2014 at  5:28am -0500,
> > Milan Broz <gmazyland@gmail.com> wrote:
> > 
> >> On 02/21/2014 08:41 AM, Mikulas Patocka wrote:
> >>>>>> Hi Mikulas,
> >>>>>>
> >>>>>> Obviously avoiding crashes is more important than performance.
> >>
> >> Yes, but please keep these changes in linux-next for a while
> >> before submitting this for stable or you will fix one rare bug and
> >> slow down all existing users (with possible another fix to fix later)...
> >>
> >> I know that taking cpu offline becomes more used these days
> >> but still the performance is critical attribute for dmcrypt.
> >>
> >> (And IIRC this cpu work relocation problem is there for years.)
> > 
> > Unfortunately, we cannot leave the code in its current state.  Sure it
> > has been this way for years but taking cpus offline is _much_ more
> > common.
> > 
> > As I said here:
> > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=fba2d94c5e0f3d848792981977b1f62ce96377ac
> > 
> > This change may undermine performance improvements intended by commit
> > c0297721 ("dm crypt: scale to multiple cpus").  But correctness is more
> > important than performance.  The use of per-cpu structures may be
> > revisited later (by using cpu hot-plug notifiers to make them safe).
> 
> Correctness? Yes. I think Tejun said how to fix it correctly.
> 
> I have nothing against removal of percpu structure - but please assess
> what it breaks, how it will slow down dmcrypt and mention it in patch
> header if you want quick fix.

With the patch applied, dm-crypt uses one more mempool_alloc and 
mempool_free call per requests.

With 512-byte requests and ramdisk as a backing device, dm-crypt can 
process up to 25000 requests per second. On the same machine, you can do 
19000000 mempool_alloc+mempool_free calls per second. So, the slowdown 
caused by mempool_alloc+mempool_free is negligable - in theory, every 
request is slowed down by 1/760.

I and Mike measured it and we didn't see any slowdown caused by the patch.

> I couldn't resist but "may undermine" in patch header sounds like
> "we have no idea what it breaks but it no longer crashes".
> 
> Removal of headache by removing head is always 100% solution to
> the particular problem but it has usually also some side effects :-)
> 
> ...
> 
> > Mikulas does have an alternative approach that should be revisited ASAP
> > given that it also fixes this cpu hotplug issue:
> > http://people.redhat.com/mpatocka/patches/kernel/dm-crypt-paralelizace/current/series.html
> 
> Yes, and I spent many hours testing it and while it helped somewhere
> it was not perfect solution in every situation. And I wish it works!
> Unfortunately, the tests output was not convincing.
> But it was described in thread you referenced.

The parallelization patches help in sequential reading.

In other workloads - such as concurrent access by multiple threads or bulk 
data writing - encryption is already parallelized by the current dm-crypt 
implementation, so there's nothing to gain. The new implementation can't 
improve parallelization, if it is already parallelized with the current 
imeplemtation.

> And if he just repost the same patchset few month later without any
> more data and no changes, why should I change my opinion?
> I can just shut up of course and just maintain userspace and watch
> people complaining.
> 
> > context/timeline:
> > http://www.redhat.com/archives/dm-devel/2011-October/msg00127.html
> > http://www.redhat.com/archives/dm-devel/2012-March/msg00181.html
> > http://www.redhat.com/archives/dm-devel/2013-March/msg00103.html
> > 
> > Christoph pointed out there is precendence for sorting:
> > http://www.redhat.com/archives/dm-devel/2013-March/msg00104.html
> 
> My opinion is that fixing io scheduler work (sorting) in dmcrypt is
> just ugly hack and could lead to more problems in future because
> it can increase latency and it anticipates some IO access patterns.
> Dm-crypt should be (ideally) completely transparent and "invisible"
> to IO processing...

The problem is that the cfq scheduler doesn't merge adjacent requests 
submitted by different thread. You don't have to sort it in dm-crypt, but 
you must submit all the requests from a single thread.

Mikulas
