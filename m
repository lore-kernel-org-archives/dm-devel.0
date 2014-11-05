From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Wed, 5 Nov 2014 09:37:30 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
References: <20141028171003.GG25229@redhat.com>
	<20141028224753.GA29288@redhat.com>
	<20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141105141147.GA14285@redhat.com>
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

> On Wed, Nov 05 2014 at  8:05am -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > On Wed, 5 Nov 2014, Mikulas Patocka wrote:
> > 
> > > You can for example set the flag in the prison meaning that the prison is 
> > > suspended and then call dm_internal_suspend immediatelly followed by 
> > > dm_internal_resume - that will clear in-progress bios and prevent new bios 
> > > from coming in (and we don't need to change dm_internal_suspend and 
> > > dm_internal_resume to become so big).
> 
> It may _seem_ like they have gotten big given the code was refactored to
> share code with dm_suspend and dm_resume.  BUT I know you see that the
> actual code complexity isn't big.  I especially wanted you (and/or Bryn)
> to evaluate the performance implications that my changes had on
> dm-stats.  I'm pretty confident there won't be much if any performance
> difference (given the code is identical to what you had, except some
> extra checks are made but ultimately not used, e.g. lockfs/unlockfs).

This is not about performance, it is about unclear behavior.

If someone does internal_suspend followed by remove, what should be the 
correct behavior? The current code deadlocks in this case.

The patch series introduces two suspend mechanisms and it is unclear how 
should they interact with each other.

> The end result of the dm_internal_{suspend,resume} changes is an
> interface that is useful for DM targets in addition to dm-stats.  That
> is the kind of advancement DM needs.
> 
> Please focus on the performance impact of my changes, if any, and we'll
> go from there.
> 
> > No, the correct sequence is this (do this in presuspend handler):
> > 
> > 1. call dm_internal_suspend on all thin devices
> > 2. set the flag in the prison meaning that the prison is blocked
> > 3. call dm_internal_resume on all thin devices
> 
> I really didn't like the idea of reusing the bio-prison to achieve the
> suspend of all thins to begin with.  This proposal is even more suspect
> given the desire to call dm_internal_suspend and dm_internal_resume from
> pool_presuspend.
> 
> It just isn't code that I want to see making its way into the tree.
> Sets bad precedent of hacking around problems within a target for
> questionable gain (questionable in that there really isn't a
> pattern/infrastructure for other more complex targets to follow so
> they'd need to invent their own hack should they have a comparable
> problem).

At least the hack stays within dm-thin and generic dm code isn't 
contaminated by it.

Mikulas
