From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: RFC: I/O bandwidth controller
Date: Fri, 08 Aug 2008 15:21:19 +0900 (JST)
Message-ID: <20080808.152119.43521725.taka@valinux.co.jp>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	<1217870433.20260.101.camel@nimitz>
	<1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: fernando@oss.ntt.co.jp
Cc: xen-devel@lists.xensource.com, uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp, dm-devel@redhat.com, agk@sourceware.org, ryov@valinux.co.jp, virtualization@lists.linux-foundation.org, ngupta@google.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

Hi, Fernando,

It's a good work!

> *** How to move on
> 
> As discussed before, it probably makes sense to have both a block layer
> I/O controller and a elevator-based one, and they could certainly
> cohabitate. As discussed before, all of them need I/O tracking
> capabilities so I would like to suggest the plan below to get things
> started:
> 
>   - Improve the I/O tracking patches (see (6) above) until they are in
> mergeable shape.

The current implementation of bio-cgroup is quite basic that a certain
page is owned by the cgroup that allocated the page, that is the same
way as the memory controller does. In most of cases this is enough and
it helps minimize the overhead. 

I think you many want to add some feature to change the owner of a page.
It will be ok we implement it step by step. I know there will be some
tradeoff between the overhead and the accuracy to track pages.

We also try to reduce the overhead of the tracking, whose code comes
from the memory controller though. We all should help the memory
controller team do this.

>   - Fix CFQ and AS to use the new I/O tracking functionality to show its
> benefits. If the performance impact is acceptable this should suffice to
> convince the respective maintainer and get the I/O tracking patches
> merged.

Yes.

>   - Implement a block layer resource controller. dm-ioband is a working
> solution and feature rich but its dependency on the dm infrastructure is
> likely to find opposition (the dm layer does not handle barriers
> properly and the maximum size of I/O requests can be limited in some
> cases). In such a case, we could either try to build a standalone
> resource controller based on dm-ioband (which would probably hook into
> generic_make_request) or try to come up with something new.

I doubt about the maximum size of I/O requests problem. You can't avoid
this problem as far as you use device mapper modules with such a bad
manner, even if the controller is implemented as a stand-alone controller.
There is no limitation if you only use dm-ioband without any other device
mapper modules.

And I think the device mapper team just started designing barriers support.
I guess it won't take long. Right, Alasdair?
We should know it is logically impossible to support barriers on some
types of device mapper modules such as LVM. You can't avoid the barrier
problem when you use this kind of multiple devices even if you implement
the controller in the block layer.

But I think a stand-alone implementation will have a merit that it
makes it easier to setup the configuration rather than dm-ioband.
From this point of view, it would be good that you move the algorithm
of dm-ioband into the block layer.
On the other hand, we should know it will make it impossible to use
the dm infrastructure from the controller, though it isn't so rich.

>   - If the I/O tracking patches make it into the kernel we could move on
> and try to get the Cgroup extensions to CFQ and AS mentioned before (see
> (1), (2), and (3) above for details) merged.
>   - Delegate the task of controlling the rate at which a task can
> generate dirty pages to the memory controller.
> 
> This RFC is somewhat vague but my feeling is that we build some
> consensus on the goals and basic design aspects before delving into
> implementation details.
> 
> I would appreciate your comments and feedback.
> 
> - Fernando
> 
