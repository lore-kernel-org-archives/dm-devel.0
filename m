From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 7/9] block: Add bio_clone_bioset(),
 bio_clone_kmalloc()
Date: Fri, 31 Aug 2012 19:19:16 -0700
Message-ID: <20120901021916.GD19535@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-8-git-send-email-koverstreet@google.com>
 <20120828204401.GF24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828220532.GB1048@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120828220532.GB1048-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>
List-Id: dm-devel.ids

Hello,

On Tue, Aug 28, 2012 at 03:05:32PM -0700, Kent Overstreet wrote:
> On Tue, Aug 28, 2012 at 01:44:01PM -0700, Tejun Heo wrote:
> > On Tue, Aug 28, 2012 at 10:37:34AM -0700, Kent Overstreet wrote:
> > > +static inline struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
> > > +{
> > > +	return bio_clone_bioset(bio, gfp_mask, fs_bio_set);
> > > +}
> > > +
> > ...
> > > +static inline struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
> > > +{
> > > +	return bio_clone_bioset(bio, gfp_mask, NULL);
> > > +
> > > +}
> > 
> > Do we really need these wrappers?  I'd prefer requiring users to
> > explicit choose @bioset when cloning.
> 
> bio_clone() is an existing api, I agree but I'd prefer to convert
> existing users in a separate patch and when I do that I want to spend
> some time actually looking at the existing code instead of doing the
> conversion blindly (at least some of the existing users are incorrect
> and I'll have to add bio_sets for them).

Aren't there like three users in kernel?  If you wanna clean it up
later, that's fine too but I don't think it would make much difference
either way.

Thanks.

-- 
tejun
