From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 09/13] block: Add an explicit bio flag for bios that own
 their bvec
Date: Fri, 18 May 2012 14:49:28 -0700
Message-ID: <20120518214928.GB32300@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <363875943e9d0e13bee6ed28239280543e6e5055.1337308722.git.koverstreet@google.com>
 <20120518163018.GI19388@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120518163018.GI19388@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

On Fri, May 18, 2012 at 09:30:18AM -0700, Tejun Heo wrote:
> On Thu, May 17, 2012 at 10:59:56PM -0400, koverstreet@google.com wrote:
> > From: Kent Overstreet <koverstreet@google.com>
> > 
> > This is for the new bio splitting code. When we split a bio, if the
> > split occured on a bvec boundry we reuse the bvec for the new bio. But
> > that means bio_free() can't free it, hence the explicit flag.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > ---
> >  fs/bio.c                  |    3 ++-
> >  include/linux/blk_types.h |    1 +
> >  2 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index ecc9088..3332800 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -234,7 +234,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
> >  {
> >  	void *p;
> >  
> > -	if (bio_has_allocated_vec(bio))
> > +	if (bio_flagged(bio, BIO_HAS_VEC))
> >  		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
> 
> We can remove bio_has_allocated_vec()?

Yep! Adding that to the patch.
