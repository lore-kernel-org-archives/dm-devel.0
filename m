From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [dm-devel] [PATCH 03/13] block: Add bio_clone_bioset()
Date: Fri, 18 May 2012 11:55:35 -0700
Message-ID: <20120518185535.GB9673@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <eb6a7d3fe7ae203202bc365d7274ee531631a9ca.1337308722.git.koverstreet@google.com>
 <20120518161130.GG25708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120518161130.GG25708@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk, agk@redhat.com
List-Id: dm-devel.ids

On Fri, May 18, 2012 at 12:11:30PM -0400, Vivek Goyal wrote:
> On Thu, May 17, 2012 at 10:59:50PM -0400, koverstreet@google.com wrote:
> 
> [..]
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index a5a524e..47605e7 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -178,23 +178,7 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
> >  	if (!mddev || !mddev->bio_set)
> >  		return bio_clone(bio, gfp_mask);
> >  
> > -	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, mddev->bio_set);
> > -	if (!b)
> > -		return NULL;
> > -
> > -	__bio_clone(b, bio);
> > -	if (bio_integrity(bio)) {
> > -		int ret;
> > -
> > -		ret = bio_integrity_clone(b, bio, gfp_mask, mddev->bio_set);
> > -
> > -		if (ret < 0) {
> > -			bio_put(b);
> > -			return NULL;
> > -		}
> > -	}
> > -
> > -	return b;
> > +	return bio_clone_bioset(gfp_mask, bio_segments(bio), mddev->bio_set);
> 
> Are we passing wrong arguments to bio_clone_bioset()?

Uh - whoops, yes. Good catch, thanks.
