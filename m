From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/4] dm-snapshot-refactor-associations
Date: Thu, 8 Oct 2009 13:32:18 -0400
Message-ID: <20091008173217.GA11142@redhat.com>
References: <1254769231-12053-1-git-send-email-snitzer@redhat.com>
	<1254769231-12053-3-git-send-email-snitzer@redhat.com>
	<F284D478-E4DA-4410-AF2B-5343FC4246BB@redhat.com>
	<20091007182433.GB29197@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091007182433.GB29197@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 07 2009 at  2:24pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Oct 07 2009 at  1:38pm -0400,
> Jonathan Brassow <jbrassow@redhat.com> wrote:
> 
> > If this is really something that we have to do, then fine.  However, it 
> > appears that you are doing this to pull out 'ti' and 'cow'... things that 
> > are separate by structure from the underlying exception store... which is 
> > ultimately what you want to hand over.  It seems to me that there is 
> > probably a better/cleaner way to do this, while simultaneously leaving 
> > 'ti' and 'cow' in their current place.
> 
> Yes, both 'ti' and 'cow' are seperate structures within the exception store.
> Yes, we want to handover the exception store itself (but keeping 'ti' and
> 'cow' fixed).
> 
> So you're saying have the handover be:
> 1) swap the 'complete' exception_table
> 2) swap the 'cow' and 'ti' in the 2 exception stores
> 3) swap the exception stores
> 
> Something like the following?:
> 
> static void handover_exceptions(struct dm_snapshot *old,
>                                 struct dm_snapshot *new)
> {
>         union {
>                 struct exception_table table_swap;
>                 struct dm_target *ti_swap;
>                 struct dm_dev *cow_swap;
>                 struct dm_exception_store *store_swap;
>         } u;
> 
>         u.table_swap = new->complete;
>         new->complete = old->complete;
>         old->complete = u.table_swap;
> 
>         u.ti_swap = new->store->ti;
>         new->store->ti = old->store->ti;
>         old->store->ti = u.ti_swap;
> 
>         u.cow_swap = new->store->cow;
>         new->store->cow = old->store->cow;
>         old->store->cow = u.cow_swap;
> 
>         u.store_swap = new->store;
>         new->store = old->store;
>         old->store = u.store_swap;
> 
>         old->active = 0;
>         new->handover = 0;
> }

Jon,

I discussed this with Mikulas and he agreed that the above would work.
But he raised the fact that reverting dm-snapshot-refactor-associations
leaves the dm_snapshot and  dm_exception_store structures muddled with
regard to where per-target members are located.  I'm inclined to agree
with him.

The dm-snapshot-refactor-associations patch offers cleanup so that:
1) dm_exception_store only contains exception store-specific members
2) dm_snapshot is the structure that contains per-target members

So while this dm-snapshot-refactor-associations patch could be viewed as
"avoidable churn" it actually takes the data structures in a more
controlled direction.

I would rather dm-snapshot-refactor-associations be applied.

Mike
