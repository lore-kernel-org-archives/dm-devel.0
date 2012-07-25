From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 01/12] block: Generalized bio pool freeing
Date: Wed, 25 Jul 2012 16:38:29 -0700
Message-ID: <20120725233829.GE8673@moria.home.lan>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
 <1343160689-12378-2-git-send-email-koverstreet@google.com>
 <500FD32F.2010809@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <500FD32F.2010809-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Wed, Jul 25, 2012 at 02:06:23PM +0300, Boaz Harrosh wrote:
> On 07/24/2012 11:11 PM, Kent Overstreet wrote:
> 
> > With the old code, when you allocate a bio from a bio pool you have to
> > implement your own destructor that knows how to find the bio pool the
> > bio was originally allocated from.
> > 
> > This adds a new field to struct bio (bi_pool) and changes
> > bio_alloc_bioset() to use it. This makes various bio destructors
> > unnecessary, so they're then deleted.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> <snip>
> 
> > diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> > index fd47950..be65582 100644
> > --- a/drivers/target/target_core_iblock.c
> > +++ b/drivers/target/target_core_iblock.c
> > @@ -447,14 +447,6 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
> >  	kfree(ibr);
> >  }
> >  
> > -static void iblock_bio_destructor(struct bio *bio)
> > -{
> > -	struct se_cmd *cmd = bio->bi_private;
> > -	struct iblock_dev *ib_dev = cmd->se_dev->dev_ptr;
> > -
> > -	bio_free(bio, ib_dev->ibd_bio_set);
> > -}
> > -
> >  static struct bio *
> >  iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
> >  {
> > @@ -475,8 +467,15 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
> >  	}
> >  
> >  	bio->bi_bdev = ib_dev->ibd_bd;
> > +<<<<<<< HEAD
> >  	bio->bi_private = cmd;
> >  	bio->bi_destructor = iblock_bio_destructor;
> > +||||||| merged common ancestors
> > +	bio->bi_private = task;
> > +	bio->bi_destructor = iblock_bio_destructor;
> > +=======
> > +	bio->bi_private = task;
> > +>>>>>>> block: Generalized bio pool freeing
> >  	bio->bi_end_io = &iblock_bio_done;
> >  	bio->bi_sector = lba;
> >  	return bio;
> 
> 
> You left out a rebase merge conflict. Did you allmodconfig compile
> these patches?

Argh, clearly not. And I even fixed that rebase merge conflict at one
point, that's distressing.
