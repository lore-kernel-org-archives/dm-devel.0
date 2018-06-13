From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Wed, 13 Jun 2018 10:02:28 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1806131001250.15845@file01.intranet.prod.int.rdu2.redhat.com>
References: <1528790608-19557-1-git-send-email-jing.xia@unisoc.com> <20180612212007.GA22717@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180612212007.GA22717@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jing Xia <jing.xia.mail@gmail.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Tue, 12 Jun 2018, Mike Snitzer wrote:

> On Tue, Jun 12 2018 at  4:03am -0400,
> Jing Xia <jing.xia.mail@gmail.com> wrote:
> 
> > Performance test in android reports that the phone sometimes gets
> > hanged and shows black screen for about several minutes.The sysdump shows:
> > 1. kswapd and other tasks who enter the direct-reclaim path are waiting
> > on the dm_bufio_lock;
> 
> Do you have an understanding of where they are waiting?  Is it in
> dm_bufio_shrink_scan()?
> 
> > 2. the task who gets the dm_bufio_lock is stalled for IO completions,
> > the relevant stack trace as :
> > 
> > PID: 22920  TASK: ffffffc0120f1a00  CPU: 1   COMMAND: "kworker/u8:2"
> >  #0 [ffffffc0282af3d0] __switch_to at ffffff8008085e48
> >  #1 [ffffffc0282af3f0] __schedule at ffffff8008850cc8
> >  #2 [ffffffc0282af450] schedule at ffffff8008850f4c
> >  #3 [ffffffc0282af470] schedule_timeout at ffffff8008853a0c
> >  #4 [ffffffc0282af520] schedule_timeout_uninterruptible at ffffff8008853aa8
> >  #5 [ffffffc0282af530] wait_iff_congested at ffffff8008181b40
> >  #6 [ffffffc0282af5b0] shrink_inactive_list at ffffff8008177c80
> >  #7 [ffffffc0282af680] shrink_lruvec at ffffff8008178510
> >  #8 [ffffffc0282af790] mem_cgroup_shrink_node_zone at ffffff80081793bc
> >  #9 [ffffffc0282af840] mem_cgroup_soft_limit_reclaim at ffffff80081b6040

Please send the full stacktrace of this task.

Then, we can see, why is it waiting here.

Mikulas
