From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Re: [PATCH 7/9] blkio-cgroup-v9: Page tracking hooks
Date: Thu, 23 Jul 2009 15:38:43 +0900 (JST)
Message-ID: <20090723.153843.193704010.ryov@valinux.co.jp>
References: <20090722111714.8af6c5d8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090722.184055.226788113.ryov@valinux.co.jp>
	<20090723091841.81ff2432.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20090723091841.81ff2432.kamezawa.hiroyu@jp.fujitsu.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 22 Jul 2009 18:40:55 +0900 (JST)
> Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> 
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > On Tue, 21 Jul 2009 23:23:16 +0900 (JST)
> > > Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> > > 
> > > > This patch contains several hooks that let the blkio-cgroup framework to know
> > > > which blkio-cgroup is the owner of a page before starting I/O against the page.
> > > 
> > > > @@ -464,6 +465,7 @@ int add_to_page_cache_locked(struct page
> > > >  					gfp_mask & GFP_RECLAIM_MASK);
> > > >  	if (error)
> > > >  		goto out;
> > > > +	blkio_cgroup_set_owner(page, current->mm);
> > > >  
> > > 
> > > This part is doubtful...Is this necessary ? 
> > > I recommend you that the caller should attach owner by itself.
> > 
> > I think that it is reasonable to add the hook right here rather than
> > to add many hooks to a variety of places.
> > 
> Why ? at writing, it's will be overwriten soon, IIUC. Then, this information
> is misleading. plz add a hook like this when it means something. In this case,
> read/write callers.
> IMO, you just increase patch's readbility but decrease easiness of maintaince.

Even though the owner is overwritten soon at writing, I'm not sure why
inserting the hook here causes the misleading. I think that it is easy
to understand when and where the owner is set by blkio-cgroup, and it
does not decrease maintainability, rather than put many hooks to each
caller.
 
> > > IMHO, later io for swap-out is caused by the caller of swapout, not page's
> > > owner. plz charge to them or,
> > >   - add special BLOCK CGROUP ID for the kernel's swap out. 
> > 
> > I think that it is not too bad to charge the owner of a page for
> > swap-out. From another perspective, it can be considered that swap-out
> > is caused by a process which uses a large amount of memory.
> > 
> No. swap-out is caused by a thread who requests memory even while memory is
> in short. IMHO, I/O by memory reqraim should work in priority of memory requester.


> 
> Consider following situation.
> 
> - A process "A" has big memory. When several threads requests memory, all 
>   of them are caught by a blockio cgroup of "A".
> - A process "B" has read big file caches. When several threads requests memory, 
>   all  of them are caught by a blockio cgroup of "B".
> 
> If "A" and "B" 's threshold is small, you'll see big slow down.
> But it's not _planned_ behavior in many cases.
> 
> If you charges agaisnt memory owner, the admin has to set _big_ priority of I/O
> controller to "A" and "B" if it uses much memory. I think the admin can't design
> his system. It's nonsense to say "plz set I/O limit propotional to memory usage of
> your apps even if it never do I/O in usual."
>
> If this blockio cgroup is introduced, people will see *unexpected* very
> terrible slow down and the user will see heartbeat warnings/failover by cluster
> management software. Please do I/O at the priority of memory reclaiming requester.

dm-ioband gives high priority to I/O for swap-out by checking whether
PG_swapcache flag is set on the I/O page, regardless of the assigned
I/O bandwidth, and the bandwidth consumed for swap-out is charged to
the owner of the pages as a debt.
How about this approach?

Thanks,
Ryo Tsuruta

> 
> 
> Thanks,
> -Kame
> 
> 
> 
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
