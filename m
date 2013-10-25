From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 06/24] dm cache policy mq: return NULL if
 mq->free list is empty in alloc_entry
Date: Fri, 25 Oct 2013 16:44:43 -0400
Message-ID: <20131025204442.GF4804@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-7-git-send-email-snitzer@redhat.com>
	<20131025163701.GH17070@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131025163701.GH17070@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 25 2013 at 12:37pm -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Oct 24, 2013 at 02:30:19PM -0400, Mike Snitzer wrote:
> > From: Heinz Mauelshagen <heinzm@redhat.com>
> > Addresses callers' (insert_in*cache()) requirement that alloc_entry()
> > return NULL when an entry isn't able to be allocated.
>  
> What is the code path that leads to the requirement for this patch?
> 
> > +++ b/drivers/md/dm-cache-policy-mq.c
> >  static struct entry *alloc_entry(struct mq_policy *mq)
> 
> > +	struct entry *e = NULL;
> >  
> >  	if (mq->nr_entries_allocated >= mq->nr_entries) {
> >  		BUG_ON(!list_empty(&mq->free));
> >  		return NULL;
> >  	}
> >  
> > -	e = list_entry(list_pop(&mq->free), struct entry, list);
> > -	INIT_LIST_HEAD(&e->list);
> > -	INIT_HLIST_NODE(&e->hlist);
> > +	if (!list_empty(&mq->free)) {
> > +		e = list_entry(list_pop(&mq->free), struct entry, list);
> > +		INIT_LIST_HEAD(&e->list);
> > +		INIT_HLIST_NODE(&e->hlist);
> > +		mq->nr_entries_allocated++;
> > +	}
> 
> In other words, under what circumstances is mq->nr_entries_allocated
> less then mq->nr_entries, yet the mq->free list is empty?
> 
> Is it better to apply a patch like this, or rather to fix whatever situation
> leads to those circumstances?  Has the bug/race always been there or is it a
> regression?

Fair questions, Heinz should explain further.

IIRC this change was needed as a prereq for the conversion of his
out-of-tree "background" policy to a shim (layered ontop of mq).

So will drop for now, can revisit if/when the need is clearer (e.g. when
background policy goes upstream).  TBD if we need it in the near-term,
but will table this for now.  Dropping patch until more context from
Heinz is provided.
