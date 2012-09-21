From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v2 15/26] block: Add bio_copy_data()
Date: Thu, 20 Sep 2012 17:09:45 -0700
Message-ID: <20120921000945.GK5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-16-git-send-email-koverstreet@google.com>
 <20120921000632.GS7264@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120921000632.GS7264@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
List-Id: dm-devel.ids

On Thu, Sep 20, 2012 at 05:06:32PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Sep 10, 2012 at 05:22:26PM -0700, Kent Overstreet wrote:
> > +void bio_copy_data(struct bio *dst, struct bio *src)
> > +{
> ...
> > +		src_p = kmap_atomic(src_bv->bv_page);
> > +		dst_p = kmap_atomic(dst_bv->bv_page);
> > +
> > +		memcpy(dst_p + dst_bv->bv_offset,
> > +		       src_p + src_bv->bv_offset,
> > +		       bytes);
> > +
> > +		kunmap_atomic(dst_p);
> > +		kunmap_atomic(src_p);
> 
> Wrap these in preempt_disable/enable() to allow the function to be
> called from any context?

I checked the implementation of kmap_atomic(), it already does
preempt_disable() so it's safe in process context - if I understand
correctly it needs local_irq_save()/restore() to be safe in any context
and I figured calling this from irq context is not the norm so that
should be the caller's responsibility.
