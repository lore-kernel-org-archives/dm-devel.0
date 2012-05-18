From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/13] block: Add bio_reset()
Date: Fri, 18 May 2012 14:48:01 -0700
Message-ID: <20120518214801.GA32300@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <9953623f6fae97018e59d96971a2612caf6c01e7.1337308722.git.koverstreet@google.com>
 <20120518161608.GF19388@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120518161608.GF19388-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Fri, May 18, 2012 at 09:16:08AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, May 17, 2012 at 10:59:53PM -0400, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:
> > From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> > Reusing bios is something that's been highly frowned upon in the past,
> > but driver code keeps doing it anyways. If it's going to happen anyways,
> > we should provide a generic method.
> > 
> > This'll help with getting rid of bi_destructor.
> 
> It would be nice to explain a bit why this helps bi_destructor
> removal.

drivers/block/pktcdvd.c was open coding this - it was doing a bio_init()
and then resetting bi_destructor (and other stuff). The generic
bio_reset() means it doesn't have to know about bi_destructor anymore.

> 
> > +#define BIO_RESET_OFFSET	offsetof(struct bio, bi_max_vecs)
> 
> Maybe better named BIO_RESET_BYTES?  As offset tends to indicate the
> start of a region.

Yeah, that's a better name.
