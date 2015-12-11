From: Tejun Heo <tj@kernel.org>
Subject: Re: corruption causing crash in __queue_work
Date: Fri, 11 Dec 2015 12:08:05 -0500
Message-ID: <20151211170805.GT30240@mtj.duckdns.org>
References: <566819D8.5090804@kyup.com>
 <20151209160803.GK30240@mtj.duckdns.org>
 <56685573.1020805@kyup.com>
 <20151209162744.GN30240@mtj.duckdns.org>
 <566945A2.1050208@kyup.com>
 <20151210152901.GR30240@mtj.duckdns.org>
 <566AF262.8050009@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <566AF262.8050009@kyup.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikolay Borisov <kernel@kyup.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, SiteGround Operations <operations@siteground.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello, Nikolay.

On Fri, Dec 11, 2015 at 05:57:22PM +0200, Nikolay Borisov wrote:
> So I had a server with the patch just crash on me:
> 
> Here is how the queue looks like:
>  crash> struct workqueue_struct 0xffff8802420a4a00
> struct workqueue_struct {
>   pwqs = {
>     next = 0xffff8802420a4c00,
>     prev = 0xffff8802420a4a00

Hmmm... pwq list is already corrupt.  ->prev is terminated but ->next
isn't.

>   },
>   list = {
>     next = 0xffff880351f9b210,
>     prev = 0xdead000000200200

Followed by by 0xdead000000200200 which is likely from
CONFIG_ILLEGAL_POINTER_VALUE.

...
>   name =
> "dm-thin\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
>   rcu = {
>     next = 0xffff8802531c4c20,
>     func = 0xffffffff810692e0 <rcu_free_wq>

and call_rcu_sched() already called.  The workqueue has already been
destroyed.

>   },
>   flags = 131082,
>   cpu_pwqs = 0x0,
>   numa_pwq_tbl = 0xffff8802420a4b10
> }
> 
> crash> rd 0xffff8802420a4b10 2 (the machine has 2 NUMA nodes hence the
> '2' argument)
> ffff8802420a4b10:  0000000000000000 0000000000000000   ................
> 
> At the same time searching for 0xffff8802420a4a00 in the debug output
> shows nothing IOW it seems that the numa_pwq_tbl is never installed for
> this workqueue apparently:
> 
> [root@smallvault8 ~]# grep 0xffff8802420a4a00 /var/log/messages
> 
> Also dumping all the logs from the dmesg contained in the vmcore image I
> find nothing and when I do the following correlation:
> [root@smallvault8 ~]# grep \(null\) wq.log | wc -l
> 1940
> [root@smallvault8 ~]# wc -l wq.log
> 1940 wq.log
> 
> It seems what's happening is really just changing the numa_pwq_tbl on
> workqueue creation i.e. it is never re-assigned. So at this point I
> think it seems that there is a situation where the wqattr are not being
> applied at all.

Hmmm... No idea why it didn't show up in the debug log but the only
way a workqueue could be in the above state is either it got
explicitly destroyed or somehow pwq refcnting is messed up, in both
cases it should have shown up in the log.

cc'ing dm people.  Is there any chance dm-think could be using
workqueue after destroying it?

Thanks.

-- 
tejun
