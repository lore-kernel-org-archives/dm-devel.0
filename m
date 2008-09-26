From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: Re: [dm-devel] Re: dm-ioband + bio-cgroup benchmarks
Date: Fri, 26 Sep 2008 19:54:29 +0900 (JST)
Message-ID: <20080926.195429.46150284.taka@valinux.co.jp>
References: <20080919.123405.91829935.taka@valinux.co.jp>
	<661de9470809240404i62300942o15337ecec335fe22@mail.gmail.com>
	<661de9470809240407m7f50b6dav897fef3b37295bb2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <661de9470809240407m7f50b6dav897fef3b37295bb2@mail.gmail.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: balbir@linux.vnet.ibm.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, ryov@valinux.co.jp, xemul@openvz.org, fernando@oss.ntt.co.jp, vgoyal@redhat.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

Hi,

> >> > > Currently I have taken code from bio-cgroup to implement cgroups and
> >> > > to
> >> > > provide functionality to associate a bio to a cgroup. I need this to
> >> > > be
> >> > > able to queue the bio's at right node in the rb-tree and then also to
> >> > > be
> >> > > able to take a decision when is the right time to release few
> >> > > requests.
> >> > >
> >> > > Right now in crude implementation, I am working on making system boot.
> >> > > Once patches are at least in little bit working shape, I will send it
> >> > > to you
> >> > > to have a look.
> >> > >
> >> > > Thanks
> >> > > Vivek
> >> >
> >> > I wonder... wouldn't be simpler to just use the memory controller
> >> > to retrieve this information starting from struct page?
> >> >
> >> > I mean, following this path (in short, obviously using the appropriate
> >> > interfaces for locking and referencing the different objects):
> >> >
> >> > cgrp = page->page_cgroup->mem_cgroup->css.cgroup
> >> >
> >> > Once you get the cgrp it's very easy to use the corresponding controller
> >> > structure.
> >> >
> >> > Actually, this is how I'm doing in cgroup-io-throttle to associate a bio
> >> > to a cgroup. What other functionalities/advantages bio-cgroup provide in
> >> > addition to that?
> >>
> >> I've decided to get Ryo to post the accurate dirty-page tracking patch
> >> for bio-cgroup, which isn't perfect yet though. The memory controller
> >> never wants to support this tracking because migrating a page between
> >> memory cgroups is really heavy.
> 
> It depends on the migration. The cost is proportional to the number of
> pages moved. The cost can be brought down (I do have a  design on
> paper  -- from long long ago), where moving mm's will reduce the cost
> of migration, but it adds an additional dereference in the common
> path.

Okay, this will help to track anonymous pages even after processes are
migrated between memory-cgroups.
The rest of my concern is pages in the pagecache, which might be
potentially dirtied by processes in other cgroups. I think bio-cgroups
should also care this case.

> >> I also thought enhancing the memory controller would be good enough,
> >> but a lot of people said they wanted to control memory resource and
> >> block I/O resource separately.
> >
> > Yes, ideally we do want that.
> >
> >>
> >> So you can create several bio-cgroup in one memory-cgroup,
> >> or you can use bio-cgroup without memory-cgroup.
> >>
> >> I also have a plan to implement more acurate tracking mechanism
> >> on bio-cgroup after the memory cgroup team re-implement the
> >> infrastructure,
> >> which won't be supported by memory-cgroup.
> >> When a process are moved into another memory cgroup,
> >> the pages belonging to the process don't move to the new cgroup
> >> because migrating pages is so heavy. It's hard to find the pages
> >> from the process and migrating pages may cause some memory pressure.
> >> I'll implement this feature only on bio-cgroup with minimum overhead
> >
> 
> Kamezawa has also wanted the page migration feature and we've agreed
> to provide a per-cgroup flag to decide to turn migration on/off. I
> would not mind refactoring memcontrol.c if that can help the IO
> controller and if you want migration, force the migration flag to on
> and warn the user if they try to turn it off.

Good news! But I've been wondering whether the IO controller should
have the same feature.
Once Kamezawa-san finished to implement the new page_cgroup
infrastructure which pre-allocates all the memory it needs,
I think I can minimize the cost migrating pages between bio-cgroup
since this migration won't cause any page reclaim unlike that of
memory-cgroup.

In this case I might design it only moves pages between bio-cgroups
while it won't move them between memory-cgroups.

Thanks,
Hirokazu Takahashi.
