From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] dm-integrity: revert adc0daad366b to fix
 recalculation
Date: Thu, 23 Jul 2020 14:39:29 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2007231438470.1796@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2007221444390.6426@file01.intranet.prod.int.rdu2.redhat.com>
	<20200722194536.GA28682@redhat.com>
	<alpine.LRH.2.02.2007221601140.16826@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2007231036570.17947@file01.intranet.prod.int.rdu2.redhat.com>
	<20200723182328.GA3753@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200723182328.GA3753@redhat.com>
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
Cc: dm-devel@redhat.com, Marian Csontos <mcsontos@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Thu, 23 Jul 2020, Mike Snitzer wrote:

> On Thu, Jul 23 2020 at 10:42am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > In order to fix this race condition, we add a function dm_suspending that
> > is only true during the postsuspend phase and use it instead of
> > dm_suspended.
> > 
> 
> ...
> 
> > Index: rhel8/drivers/md/dm.c
> > ===================================================================
> > --- rhel8.orig/drivers/md/dm.c
> > +++ rhel8/drivers/md/dm.c
> > @@ -140,6 +140,7 @@ EXPORT_SYMBOL_GPL(dm_bio_get_target_bio_
> >  #define DMF_NOFLUSH_SUSPENDING 5
> >  #define DMF_DEFERRED_REMOVE 6
> >  #define DMF_SUSPENDED_INTERNALLY 7
> > +#define DMF_SUSPENDING 8
> 
> Think I prefer DMF_POST_SUSPENDING.  If you're OK with that I can fix up
> the code while I stage your commit.
> 
> Thanks,
> Mike

Yes - you can change it.

Mikulas
