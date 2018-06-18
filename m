From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 3/5] bitmap: Add bitmap_alloc(), bitmap_zalloc() and
 bitmap_free()
Date: Mon, 18 Jun 2018 16:10:56 -0700
Message-ID: <20180618161056.e52efd0e8bd36211e60705a2@linux-foundation.org>
References: <20180618131003.88110-1-andriy.shevchenko@linux.intel.com>
        <20180618131003.88110-4-andriy.shevchenko@linux.intel.com>
        <20180618141404.68124daab97bd0f3a3051544@linux-foundation.org>
        <CAKdAkRTHOORds7aEauv4rp3_=PnGi=Nv-VS3-nAb9MztJPKG=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKdAkRTHOORds7aEauv4rp3_=PnGi=Nv-VS3-nAb9MztJPKG=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, shli@kernel.org, linux-raid@vger.kernel.org, "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>, ynorov@caviumnetworks.com, lkml <linux-kernel@vger.kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>, Joe Perches <joe@perches.com>
List-Id: dm-devel.ids

On Mon, 18 Jun 2018 15:01:43 -0700 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> > > +unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
> > > +{
> > > +     return kmalloc_array(BITS_TO_LONGS(nbits), sizeof(unsigned long), flags);
> > > +}
> > > +EXPORT_SYMBOL(bitmap_alloc);
> > > +
> > > +unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
> > > +{
> > > +     return bitmap_alloc(nbits, flags | __GFP_ZERO);
> > > +}
> > > +EXPORT_SYMBOL(bitmap_zalloc);
> > > +
> > > +void bitmap_free(const unsigned long *bitmap)
> > > +{
> > > +     kfree(bitmap);
> > > +}
> > > +EXPORT_SYMBOL(bitmap_free);
> > > +
> >
> > I suggest these functions are small and simple enough to justify
> > inlining them.
> >
> 
> We can't as we end up including bitmap.h (by the way of cpumask.h)
> form slab.h, so we gen circular dependency.

That info should have been in the changelog, and probably a code
comment.

> Maybe if we removed memcg
> stuff from slab.h so we do not need to include workqueue.h...

Or move the basic slab API stuff out of slab.h into a new header.  Or
create a new, standalone work_struct.h - that looks pretty simple.
