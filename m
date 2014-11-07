From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Fri, 7 Nov 2014 11:20:30 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1411071047430.21255@file01.intranet.prod.int.rdu2.redhat.com>
References: <20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105162912.GA17625@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141105162912.GA17625@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Wed, 5 Nov 2014, Mike Snitzer wrote:

> On Wed, Nov 05 2014 at  9:37am -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > The patch series introduces two suspend mechanisms and it is unclear how 
> > should they interact with each other.
> 
> And this point is not correct.  As you know dm_internal_suspend and
> dm_internal_resume interface predates any of my changes.
> 
> That existing interface was extended them to be (mostly) fully formed
> equivalents of dm_suspend() and dm_resume().
> 
> I say "mostly" because dm_internal_resume() doesn't call into the targets'
> resume hooks because no existing callers (dm-stats or dm-thinp) need
> to.  But obviously dm_resume() does need to so it passes @resume_targets
> as true to __dm_resume().
> 
> I'm not trying to suggest there is a bug or bugs in this new code (you
> already pointed out the locking issue across ioctls that I fixed).
> 
> But a bug doesn't implicitly mean this is an imperfect way forward --
> if/when a bug is found we'll deal with it.. so feel free to pour over
> this code to see if there is a bug or bugs.  I really do welcome your
> review -- I would just like technical issues to be the focus of any
> technical review.

Problems with that patch set:

1. You walk all thin targets in pool_presuspend and call internal_suspend 
on them and then again in pool_resume call internal_resume on them. 
Between calls to pool_presuspend and pool_resume, dm-thin devices may be 
added or removed, resulting in unballanced calls.

2. You walk all thin targets and call internal_suspend on them. If two 
thin targets are in one dm table, it calls internal_suspend twice on the 
same md device. It also calls internal_suspend twice on the same md device 
if the device has both active and inactive table with a thin target.

3. The device may be suspended internally by pool presuspend and by 
statistics at the same time - the code doesn't handle that:
if (WARN_ON(dm_suspended_internally_md(md))) goto out; /* disallow nested 
internal suspends! */

4. when pool_presuspend is called, md->suspend_lock is alrady held. Taking 
md->suspend_lock on another device results in lockdep warning.


For reasons 1 and 2, I wouldn't really deal with "thin" targets at all - 
they may be created or deleted independent on pool status. Instead, we 
should block all active bios inside the pool - the bios are already 
registered in dm_deferred_set or in the prison, so all you need to do is 
to set a flag pool's presuspend method that causes all new bios to be 
queues and the wait until the prison is empty and the counters in 
deferred_set reach zero.


Mikulas
