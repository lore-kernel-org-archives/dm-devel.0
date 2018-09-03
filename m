From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Mon, 3 Sep 2018 18:23:17 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1809031816120.27063@file01.intranet.prod.int.rdu2.redhat.com>
References: <1528790608-19557-1-git-send-email-jing.xia@unisoc.com> <20180612212007.GA22717@redhat.com> <alpine.LRH.2.02.1806131001250.15845@file01.intranet.prod.int.rdu2.redhat.com> <CAN=25QMQiJ7wvfvYvmZnEnrkeb-SA7_hPj+N2RnO8y-aVO8wOQ@mail.gmail.com>
 <20180614073153.GB9371@dhcp22.suse.cz> <CAN=25QNrENVFbb9UAAAJJqKsEeMY+qNs5cQA4EGwgB2dMYTZug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAN=25QNrENVFbb9UAAAJJqKsEeMY+qNs5cQA4EGwgB2dMYTZug@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jing xia <jing.xia.mail@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Wed, 1 Aug 2018, jing xia wrote:

> We reproduced this issue again and found out the root cause.
> dm_bufio_prefetch() with dm_bufio_lock enters the direct reclaim and
> takes a long time to do the soft_limit_reclaim, because of the huge
> number of memory excess of the memcg.
> Then, all the task who do shrink_slab() wait for  dm_bufio_lock.
> 
> Any suggestions for this?Thanks.

There's hardly any solution because Michal Hocko refuses to change 
__GFP_NORETRY behavior.

The patches 41c73a49df31151f4ff868f28fe4f129f113fa2c and 
d12067f428c037b4575aaeb2be00847fc214c24a could reduce the lock contention 
on the dm-bufio lock - the patches don't fix the high CPU consumption 
inside the memory allocation, but the kernel code should wait less on the 
bufio lock.

Mikulas


> On Thu, Jun 14, 2018 at 3:31 PM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Thu 14-06-18 15:18:58, jing xia wrote:
> > [...]
> >> PID: 22920  TASK: ffffffc0120f1a00  CPU: 1   COMMAND: "kworker/u8:2"
> >>  #0 [ffffffc0282af3d0] __switch_to at ffffff8008085e48
> >>  #1 [ffffffc0282af3f0] __schedule at ffffff8008850cc8
> >>  #2 [ffffffc0282af450] schedule at ffffff8008850f4c
> >>  #3 [ffffffc0282af470] schedule_timeout at ffffff8008853a0c
> >>  #4 [ffffffc0282af520] schedule_timeout_uninterruptible at ffffff8008853aa8
> >>  #5 [ffffffc0282af530] wait_iff_congested at ffffff8008181b40
> >
> > This trace doesn't provide the full picture unfortunately. Waiting in
> > the direct reclaim means that the underlying bdi is congested. The real
> > question is why it doesn't flush IO in time.
> >
> >>  #6 [ffffffc0282af5b0] shrink_inactive_list at ffffff8008177c80
> >>  #7 [ffffffc0282af680] shrink_lruvec at ffffff8008178510
> >>  #8 [ffffffc0282af790] mem_cgroup_shrink_node_zone at ffffff80081793bc
> >>  #9 [ffffffc0282af840] mem_cgroup_soft_limit_reclaim at ffffff80081b6040
> >> #10 [ffffffc0282af8f0] do_try_to_free_pages at ffffff8008178b6c
> >> #11 [ffffffc0282af990] try_to_free_pages at ffffff8008178f3c
> >> #12 [ffffffc0282afa30] __perform_reclaim at ffffff8008169130
> >> #13 [ffffffc0282afab0] __alloc_pages_nodemask at ffffff800816c9b8
> >> #14 [ffffffc0282afbd0] __get_free_pages at ffffff800816cd6c
> >> #15 [ffffffc0282afbe0] alloc_buffer at ffffff8008591a94
> >> #16 [ffffffc0282afc20] __bufio_new at ffffff8008592e94
> >> #17 [ffffffc0282afc70] dm_bufio_prefetch at ffffff8008593198
> >> #18 [ffffffc0282afd20] verity_prefetch_io at ffffff8008598384
> >> #19 [ffffffc0282afd70] process_one_work at ffffff80080b5b3c
> >> #20 [ffffffc0282afdc0] worker_thread at ffffff80080b64fc
> >> #21 [ffffffc0282afe20] kthread at ffffff80080bae34
> >>
> >> > Mikulas
> >
> > --
> > Michal Hocko
> > SUSE Labs
> 
