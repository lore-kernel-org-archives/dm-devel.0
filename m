From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/2] dm: prevent table type changes after
 initial table load
Date: Tue, 25 May 2010 08:44:57 -0400
Message-ID: <20100525124456.GC7204@redhat.com>
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com>
	<1274744795-9825-2-git-send-email-snitzer@redhat.com>
	<4BFBB186.8080207@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4BFBB186.8080207@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, May 25 2010 at  7:16am -0400,
Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

> Hi Mike,
> 
> On 05/25/2010 08:46 AM +0900, Mike Snitzer wrote:
> > Before table_load() stages an inactive table atomically check if its
> > type conflicts with a previously established device type (md->type).
> > 
> > Introduce 'type_lock' in mapped_device structure and use it to protect
> > md->type access.  table_load() sets md->type without concern for:
> > - another table_load() racing to set conflicting md->type.
> > - do_resume() making a conflicting table live.
> > 
> > Allowed transitions:
> > UNKNOWN_MD_TYPE => BIO_BASED_MD_TYPE
> > UNKNOWN_MD_TYPE => REQUEST_BASED_MD_TYPE
> > 
> > Once a table load occurs the DM device's type is completely immutable.
> > 
> > This prevents a table reload from switching the inactive table directly
> > to a conflicting type (even if the table is explicitly cleared before
> > load).
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> I basically agree with this design.
> But I have some comments.  Please see below.
> 
> By the way, I can't make enough time to review until tomorrow.
> So the following comments may not be all.
> Sorry for the inconvenience.

No problem, thanks again for all your review.

> > Index: linux-2.6/drivers/md/dm-ioctl.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-ioctl.c
> > +++ linux-2.6/drivers/md/dm-ioctl.c
> > @@ -1176,12 +1176,39 @@ static int table_load(struct dm_ioctl *p
> >  		goto out;
> >  	}
> >  
> > +	/*
> > +	 * Protect md->type against concurrent table loads.
> > +	 * Locking strategy:
> > +	 * + Leverage fact that md's type cannot change after initial table load.
> > +	 *   - Only protect type in table_load() -- not in do_resume().
> > +	 *
> > +	 * + Protect type while working to stage an inactive table:
> > +	 *   - check if table's type conflicts with md->type
> > +	 *     (holding: md->type_lock)
> > +	 *   - stage inactive table (hc->new_map)
> > +	 *     (holding: md->type_lock + _hash_lock)
> > +	 */
> 
> I think you don't need to hold md->type_lock while you set the table
> to hc->new_map; If 2 tables of the same type are racing here, we can
> have either table.  If they are different type, the former one will win
> and the latter one will be rejected.

Correct.  This v2 patchset has significantly reduced the complexity (no
longer need to be concerned with md->type transitioning back to
UNKNOWN_MD_TYPE).  I just missed the fact that the locking could be
simplified a bit too.

> > +	dm_lock_md_type(md);
> > +
> > +	if (dm_unknown_md_type(md)) {
> > +		/* initial table load, set md's type based on table's type */
> > +		dm_set_md_type(md, t);
> > +	} else if (!dm_md_type_matches_table(md, t)) {
> > +		DMWARN("can't change device type after initial table load.");
> > +		dm_table_destroy(t);
> > +		dm_unlock_md_type(md);
> > +		r = -EINVAL;
> > +		goto out;
> > +	}
> 
> So you should be able to unlock md->type_lock here.

Yes.

> > Index: linux-2.6/drivers/md/dm.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm.c
> > +++ linux-2.6/drivers/md/dm.c
> > @@ -111,6 +111,15 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
> >  #define DMF_QUEUE_IO_TO_THREAD 6
> >  
> >  /*
> > + * Type for md->type field.
> > + */
> > +enum mapped_device_type {
> > +	UNKNOWN_MD_TYPE,
> > +	BIO_BASED_MD_TYPE,
> > +	REQUEST_BASED_MD_TYPE,
> > +};
> 
> You can use the defined types in drivers/md/dm.h below instead;
> /*
>  * Type of table and mapped_device's mempool
>  */
> #define DM_TYPE_NONE            0
> #define DM_TYPE_BIO_BASED       1
> #define DM_TYPE_REQUEST_BASED   2
> 
> Using them should make type matching easier than making another definition.
> E.g. see below;
> 
> > +bool dm_md_type_matches_table(struct mapped_device *md, struct dm_table* t)
> > +{
> > +	if (dm_request_based_md_type(md))
> > +		return dm_table_request_based(t);
> > +	else if (dm_bio_based_md_type(md))
> > +		return !dm_table_request_based(t);
> > +
> > +	return 0;
> > +}
> 
> You can match type using "md->type == dm_table_get_type(t)" if you use
> the already defined types above.

Ah, yes that'll clean things up nicely.  No idea how I missed the
existing definitions.

Thanks,
Mike
