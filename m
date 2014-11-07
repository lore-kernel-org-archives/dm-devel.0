From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Suspend all active bios when the pool is suspended
 (was: staged dm_internal_{suspend, resume} related changes for wider review)
Date: Fri, 7 Nov 2014 18:29:14 -0500
Message-ID: <20141107232913.GA1044@redhat.com>
References: <alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105162912.GA17625@redhat.com>
	<alpine.LRH.2.02.1411071047430.21255@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411071804030.8597@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1411071804030.8597@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 07 2014 at  6:16pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 7 Nov 2014, Mikulas Patocka wrote:
> 
> > For reasons 1 and 2, I wouldn't really deal with "thin" targets at all - 
> > they may be created or deleted independent on pool status. Instead, we 
> > should block all active bios inside the pool - the bios are already 
> > registered in dm_deferred_set or in the prison, so all you need to do is 
> > to set a flag pool's presuspend method that causes all new bios to be 
> > queues and the wait until the prison is empty and the counters in 
> > deferred_set reach zero.
> 
> Here I'm sending a proof-of-concept patch that makes it possible to 
> prevent bios from coming into the thin pool when the pool is suspended. It 
> doesn't modify any generic dm code.
> 
> This patch may not be perfect (I don't know all bio paths in dm-thin in 
> detail, so I may have missed something), but it shows that it is possible 
> to suspend all bios without modifying the common dm code. I hope Joe 
> reviewes it and possibly fixes it.
> 
> The patch is for 3.18-rc3, it needs other thin patches, the full patch 
> series is at 
> http://people.redhat.com/~mpatocka/patches/kernel/dm-thin-suspend/series.html

Happy to consider your solution, thanks for taking the time to work on
it.

I also revised my dm_internal_{suspend,resume} changes based on your
feedback and have published the changes here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19
(rebased so the top ~11 patches are the ones to look at)

I'm happy with how this code turned out, but it is certainly a fair
amount of code churn in DM core.

All said, I'll work with Joe to figure out the best way forward next
week.  Could easily be that your approach wins out.

BTW, have a great break.
Mike
