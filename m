From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 03/11] [PATCH 18/19] [dm-thin] [bio prison]
 Don't use the bi_next field for the holder of a cell.
Date: Fri, 10 Feb 2012 14:55:48 +0000
Message-ID: <20120210145548.GB8599@ubuntu>
References: <1328200754-13642-1-git-send-email-ejt@redhat.com>
	<1328200754-13642-4-git-send-email-ejt@redhat.com>
	<20120207231819.GA12139@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120207231819.GA12139@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 07, 2012 at 06:18:21PM -0500, Mike Snitzer wrote:
> On Thu, Feb 02 2012 at 11:39am -0500,
> Joe Thornber <ejt@redhat.com> wrote:
> 
> > The holder can be passed down to lower devices which may want to use
> > bi_next themselves.  Also added BUG_ON checks to confirm fix.
> 
> Aside from not (ab)using bi_next; do any other patches in the series
> depend on this patch?  I don't think so but figured I'd explicitly ask.

No.  I found the issue while chasing a discard problem.

> bio_detain() never returns < 0, so I've updated the above comment block.

Fine.

> 
> > @@ -256,21 +256,25 @@ static int bio_detain(struct bio_prison *prison, struct cell_key *key,
> >  
> >  			cell->prison = prison;
> >  			memcpy(&cell->key, key, sizeof(cell->key));
> > -			cell->count = 0;
> > +			cell->holder = inmate;
> >  			bio_list_init(&cell->bios);
> >  			hlist_add_head(&cell->list, prison->cells + hash);
> > +			r = 0;
> 
> So in this case where there is no existing inmate in the cell, and
> you're allocating the cell, you aren't adding the lone inmate (the
> holder) to the cell->bios.  But you did previously [1].

Correct, the bio that hold the cell previously went into the
cell->bios list.  But these ios are sometimes issued before the cell
is released (eg, if the io totally overwrites a data block, we can use
it to 'zero' or 'copy').  The bio is still retained in the cell
however, just in the 'holder' field.

> 
> > +
> > +		} else {
> > +			mempool_free(cell2, prison->cell_pool);
> > +			cell2 = NULL;
> > +			r = 1;
> > +			bio_list_add(&cell->bios, inmate);
> >  		}
> > -	}
> >  
> > -	r = cell->count++;
> > -	bio_list_add(&cell->bios, inmate);
> 
> [1] So you only added it in all cases before because you were looking to
>     get bio->bi_next to reflect the holder?  Thing is bio_list_add()
>     will set: bio->bi_next = NULL; -- so I'm not seeing how overloading
>     bi_next to imply holder was reliable.

Hmm, not really.  The holder was known outside the cell (release_except ...)

> I'll need to look closer at the bigger picture of how a cell is used;
> but it is clear that cell->holder isn't on the cell->bios bio_list now.

Correct.

> 
> > @@ -286,6 +290,7 @@ static void __cell_release(struct cell *cell, struct bio_list *inmates)
> >  	if (inmates)
> >  		bio_list_merge(inmates, &cell->bios);
> >  
> > +	bio_list_add_head(inmates, cell->holder);
> >  	mempool_free(cell, prison->cell_pool);
> >  }
> 
> __cell_release() assumes @inmates is a properly initialized bio_list.
> So why the check for inmates != NULL?

This is a bug, that bio_list_add_head() should be inside the if too, thx.

> And why is this bio_list_add_head() outside that inmates != NULL check?

exactly.

> But most important question: why is it so important to put the
> cell->holder at the head of the @inmates list?

I don't want to reorder the ios.  The holder was definitely the first io originally.

> Especially considering @inmates _could_ already be non-empty, so you're
> appending the cell->bios to the end of the @inmates list
> (e.g. pool->deferred_bios), but then putting the holder of the cell at
> the head of the @inmates list.. leaving the cell's holder disjoint from
> it's other cell members... why?  Was this intended?

Not really, I guess we should add the holder, then do the merge.

> 
> (Maybe I'm not reading the code right).
> 
> > @@ -1302,8 +1309,10 @@ static void process_deferred_bios(struct pool *pool)
> >  		return;
> >  	}
> >  
> > -	while ((bio = bio_list_pop(&bios)))
> > +	while ((bio = bio_list_pop(&bios))) {
> > +		BUG_ON(bio->bi_next);
> >  		generic_make_request(bio);
> > +	}
> 
> bio_list_pop() will always: bio->bi_next = NULL;
> 
> so there is no need for the BUG_ON() here.

ok.
