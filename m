From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 15/26] block: Add bio_copy_data()
Date: Thu, 20 Sep 2012 17:13:23 -0700
Message-ID: <20120921001323.GL5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-16-git-send-email-koverstreet@google.com>
 <20120921000632.GS7264@google.com>
 <20120921000947.GT7264@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120921000947.GT7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Thu, Sep 20, 2012 at 05:09:47PM -0700, Tejun Heo wrote:
> On Thu, Sep 20, 2012 at 05:06:32PM -0700, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Sep 10, 2012 at 05:22:26PM -0700, Kent Overstreet wrote:
> > > +void bio_copy_data(struct bio *dst, struct bio *src)
> > > +{
> > ...
> > > +		src_p = kmap_atomic(src_bv->bv_page);
> > > +		dst_p = kmap_atomic(dst_bv->bv_page);
> > > +
> > > +		memcpy(dst_p + dst_bv->bv_offset,
> > > +		       src_p + src_bv->bv_offset,
> > > +		       bytes);
> > > +
> > > +		kunmap_atomic(dst_p);
> > > +		kunmap_atomic(src_p);
> > 
> > Wrap these in preempt_disable/enable() to allow the function to be
> > called from any context?
> 
> Ooh, and maybe return the amount of copied data?

Possibly, but I think I want to wait until a user needs it before adding
something like that.

From looking at other code that copies bio data, a parameter that
specifies the amount of data to be copied might be more useful.

I'm not sure I've seen all the places where bio data is copied yet, so
I've just been waiting until I find more uses to make it do more.
