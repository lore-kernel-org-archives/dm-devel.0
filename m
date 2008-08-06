From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: RFC: I/O bandwidth controller
Date: Wed, 06 Aug 2008 15:18:24 +0900 (JST)
Message-ID: <20080806.151824.104049463.ryov@valinux.co.jp>
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
Cc: taka@valinux.co.jp, xen-devel@lists.xensource.com, uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp, dm-devel@redhat.com, agk@sourceware.org, virtualization@lists.linux-foundation.org, ngupta@google.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

Hi Fernando,

> This RFC ended up being a bit longer than I had originally intended, but
> hopefully it will serve as the start of a fruitful discussion.

Thanks a lot for posting the RFC.

> *** Goals
>   1. Cgroups-aware I/O scheduling (being able to define arbitrary
> groupings of processes and treat each group as a single scheduling
> entity).
>   2. Being able to perform I/O bandwidth control independently on each
> device.
>   3. I/O bandwidth shaping.
>   4. Scheduler-independent I/O bandwidth control.
>   5. Usable with stacking devices (md, dm and other devices of that
> ilk).
>   6. I/O tracking (handle buffered and asynchronous I/O properly).
>
> The list of goals above is not exhaustive and it is also likely to
> contain some not-so-nice-to-have features so your feedback would be
> appreciated.

I'd like to add the following item to the goals.

  7. Selectable from multiple bandwidth control policy (proportion,
     maximum rate limiting, ...) like I/O scheduler.

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
>   - Fix CFQ and AS to use the new I/O tracking functionality to show its
> benefits. If the performance impact is acceptable this should suffice to
> convince the respective maintainer and get the I/O tracking patches
> merged.
>   - Implement a block layer resource controller. dm-ioband is a working
> solution and feature rich but its dependency on the dm infrastructure is
> likely to find opposition (the dm layer does not handle barriers
> properly and the maximum size of I/O requests can be limited in some
> cases). In such a case, we could either try to build a standalone
> resource controller based on dm-ioband (which would probably hook into
> generic_make_request) or try to come up with something new.
>   - If the I/O tracking patches make it into the kernel we could move on
> and try to get the Cgroup extensions to CFQ and AS mentioned before (see
> (1), (2), and (3) above for details) merged.
>   - Delegate the task of controlling the rate at which a task can
> generate dirty pages to the memory controller.

I agree with your plan.
We keep bio-cgroup improving and porting to the latest kernel.

Thanks,
Ryo Tsuruta
