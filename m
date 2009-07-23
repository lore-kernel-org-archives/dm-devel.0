From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [Xen-devel] Re: [PATCH 7/9] blkio-cgroup-v9: Page
 tracking hooks
Date: Thu, 23 Jul 2009 19:02:53 +0900 (JST)
Message-ID: <20090723.190253.226783703.ryov@valinux.co.jp>
References: <20090723091841.81ff2432.kamezawa.hiroyu@jp.fujitsu.com>
	<20090723.153843.193704010.ryov@valinux.co.jp>
	<20090723164935.e97a3ccf.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090723164935.e97a3ccf.kamezawa.hiroyu@jp.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 23 Jul 2009 15:38:43 +0900 (JST)
> Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> 
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > On Wed, 22 Jul 2009 18:40:55 +0900 (JST)
> > > Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> > > 
> > > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > > On Tue, 21 Jul 2009 23:23:16 +0900 (JST)
> > > > > Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> > > > > 
> > > > > > This patch contains several hooks that let the blkio-cgroup framework to know
> > > > > > which blkio-cgroup is the owner of a page before starting I/O against the page.
> > > > > 
> > > > > > @@ -464,6 +465,7 @@ int add_to_page_cache_locked(struct page
> > > > > >  					gfp_mask & GFP_RECLAIM_MASK);
> > > > > >  	if (error)
> > > > > >  		goto out;
> > > > > > +	blkio_cgroup_set_owner(page, current->mm);
> > > > > >  
> > > > > 
> > > > > This part is doubtful...Is this necessary ? 
> > > > > I recommend you that the caller should attach owner by itself.
> > > > 
> > > > I think that it is reasonable to add the hook right here rather than
> > > > to add many hooks to a variety of places.
> > > > 
> > > Why ? at writing, it's will be overwriten soon, IIUC. Then, this information
> > > is misleading. plz add a hook like this when it means something. In this case,
> > > read/write callers.
> > > IMO, you just increase patch's readbility but decrease easiness of maintaince.
> > 
> > Even though the owner is overwritten soon at writing, I'm not sure why
> > inserting the hook here causes the misleading. I think that it is easy
> > to understand when and where the owner is set by blkio-cgroup, and it
> > does not decrease maintainability, rather than put many hooks to each
> > caller.
> >  
> Are there _many_ callers ? I don't think so. 
> But okay, I don't say strong objections more if other ones say ok.
> 
> BTW, a sad information for you.
> you can't call lock_page_cgroup() under radix_tree->lock.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e767e0561d7fd2333df1921f1ab4176211f9036b
> 
> plz update.

Thank you for letting me know. I'll fix it.

> 
> > > 
> > > Consider following situation.
> > > 
> > > - A process "A" has big memory. When several threads requests memory, all 
> > >   of them are caught by a blockio cgroup of "A".
> > > - A process "B" has read big file caches. When several threads requests memory, 
> > >   all  of them are caught by a blockio cgroup of "B".
> > > 
> > > If "A" and "B" 's threshold is small, you'll see big slow down.
> > > But it's not _planned_ behavior in many cases.
> > > 
> > > If you charges agaisnt memory owner, the admin has to set _big_ priority of I/O
> > > controller to "A" and "B" if it uses much memory. I think the admin can't design
> > > his system. It's nonsense to say "plz set I/O limit propotional to memory usage of
> > > your apps even if it never do I/O in usual."
> > >
> > > If this blockio cgroup is introduced, people will see *unexpected* very
> > > terrible slow down and the user will see heartbeat warnings/failover by cluster
> > > management software. Please do I/O at the priority of memory reclaiming requester.
> > 
> > dm-ioband gives high priority to I/O for swap-out by checking whether
> > PG_swapcache flag is set on the I/O page, regardless of the assigned
> > I/O bandwidth, and the bandwidth consumed for swap-out is charged to
> > the owner of the pages as a debt.
> > How about this approach?
> 
> I don't think it's reasonable. Why I/O device, scheduler should know about
> such mm-related information ? I think layering is wrong.

I think that urgent I/O requests such as swap-out should be notified
by setting a special flag in the struct bio, but there is no such
mechanism at this time. That is why dm-ioband uses this approach.

> And your approatch cannot be a workaround.
> 
> In follwing _typical_ case,
>  
>   - A process does small logging to /var/log/mylog, once in a sec.
>     but it uses some amount of cold memory or shmem.
> 
> This process's logging will be delayed _unexpectedly_ by some buggy process
> which does memory leak.

Do you mean that the delay in logging is caused since the small process
is swapped out unexpectedly by the buggy processes?
How about using memory cgroup to prevent the small process from swap-out?
I would appreciate it if you could tell me more about this.

Thanks,
Ryo Tsuruta

> 
> Thanks,
> -Kame
