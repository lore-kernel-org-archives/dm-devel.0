From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH] io-controller: Add io group reference handling for
 request
Date: Wed, 27 May 2009 20:53:29 +0900 (JST)
Message-ID: <20090527.205329.189719252.ryov@valinux.co.jp>
References: <20090526.203424.39179999.ryov@valinux.co.jp>
	<20090527.155631.226800550.ryov@valinux.co.jp>
	<20090527081749.GA7237@linux>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761775AbZE0Lxl@vger.kernel.org>
In-Reply-To: <20090527081749.GA7237@linux>
Sender: linux-kernel-owner@vger.kernel.org
To: righi.andrea@gmail.com
Cc: vgoyal@redhat.com, guijianfeng@cn.fujitsu.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

Andrea Righi <righi.andrea@gmail.com> wrote:
> On Wed, May 27, 2009 at 03:56:31PM +0900, Ryo Tsuruta wrote:
> > > I think that only putting the hook in try_to_unmap() doesn't work
> > > correctly, because IOs will be charged to reclaiming processes or
> > > kswapd. These IOs should be charged to processes which cause memory
> > > pressure.
> > 
> > Consider the following case:
> > 
> >   (1) There are two processes Proc-A and Proc-B.
> >   (2) Proc-A maps a large file into many pages by mmap() and writes
> >       many data to the file.
> >   (3) After (2), Proc-B try to get a page, but there are no available
> >       pages because Proc-A has used them.
> >   (4) kernel starts to reclaim pages, call try_to_unmap() to unmap
> >       a page which is owned by Proc-A, then blkio_cgroup_set_owner()
> >       sets Proc-B's ID on the page because the task's context is Proc-B.
> >   (5) After (4), kernel writes the page out to a disk. This IO is
> >       charged to Proc-B.
> > 
> > In the above case, I think that the IO should be charged to a Proc-A,
> > because the IO is caused by Proc-A's memory pressure. 
> > I think we should consider in the case without memory and swap
> > isolation.
> 
> mmmh.. even if they're strictly related I think we're mixing two
> different problems in this way: memory pressure control and IO control.
> 
> It seems you're proposing something like the badness() for OOM
> conditions to charge swap IO depending on how bad is a cgroup in terms
> of memory consumption. I don't think this is the right way to proceed,
> also because we already have the memory and swap control.

cgroups support multiple hierarchy and it allows to have different
divisions of tasks among hierarchy like below:

                                 PIDs
   mem+swap /hier1/grp1/tasks <= 1, 2, 3, 4
   blkio    /hier2/grp2/tasks <= 1, 2
                   grp3/tasks <= 3, 4

Don't we need to consider this case?

Thanks,
Ryo Tsuruta
