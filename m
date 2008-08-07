From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory
 subsystem into two parts
Date: Thu, 07 Aug 2008 17:45:10 +0900 (JST)
Message-ID: <20080807.174510.103839374.taka@valinux.co.jp>
References: <16255819.1218030343593.kamezawa.hiroyu@jp.fujitsu.com>
	<20080807.162512.22162413.taka@valinux.co.jp>
	<20080807172113.0788f800.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20080807172113.0788f800.kamezawa.hiroyu@jp.fujitsu.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi,

> > > >I've just noticed that most of overhead comes from the spin-locks
> > > >when reclaiming the pages inside mem_cgroups and the spin-locks to
> > > >protect the links between pages and page_cgroups.
> > > Overhead between page <-> page_cgroup lock is cannot be catched by
> > > lock_stat now.Do you have numbers ?
> > > But ok, there are too many locks ;(
> > 
> > The problem is that every time the lock is held, the associated
> > cache line is flushed.
> I think "page" and "page_cgroup" is not so heavly shared object in fast path.
> foot-print is also important here.
> (anyway, I'd like to remove lock_page_cgroup() when I find a chance)

OK.

> > > >The latter overhead comes from the policy your team has chosen
> > > >that page_cgroup structures are allocated on demand. I still feel
> > > >this approach doesn't make any sense because linux kernel tries to
> > > >make use of most of the pages as far as it can, so most of them
> > > >have to be assigned its related page_cgroup. It would make us happy
> > > >if page_cgroups are allocated at the booting time.
> > > >
> > > Now, multi-sizer-page-cache is discussed for a long time. If it's our
> > > direction, on-demand page_cgroup make sense.
> > 
> > I don't think I can agree to this.
> > When multi-sized-page-cache is introduced, some data structures will be
> > allocated to manage multi-sized-pages. 
> maybe no. it will be encoded into struct page.

It will nice and simple if it will be.

> > I think page_cgroups should be allocated at the same time.
> > This approach will make things simple.
> yes, of course.
> 
> > 
> > It seems like the on-demand allocation approach leads not only
> > overhead but complexity and a lot of race conditions.
> > If you allocate page_cgroups when allocating page structures,
> > You can get rid of most of the locks and you don't have to care about
> > allocation error of page_cgroups anymore.
> > 
> > And it will also give us flexibility that memcg related data can be
> > referred/updated inside critical sections.
> > 
> But it's not good for the systems with small "NORMAL" pages.

Even when it happens to be a system with small "NORMAL" pages, if you
want to use memcg feature, you have to allocate page_groups for most of
the pages in the system. It's impossible to avoid the allocation as far
as you use memcg.

> This discussion should be done again when more users of page_group appears and
> it's overhead is obvious.

Thanks,
Hirokazu Takahashi.
