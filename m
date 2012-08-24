From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 05/13] block: Kill bi_destructor
Date: Thu, 23 Aug 2012 22:09:36 -0700
Message-ID: <20120824050935.GB11977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-6-git-send-email-koverstreet@google.com>
 <20120822200032.GH19212@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120822200032.GH19212-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Aug 22, 2012 at 01:00:32PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 22, 2012 at 10:04:02AM -0700, Kent Overstreet wrote:
> > +#define BIO_KMALLOC_POOL NULL
> 
> I would much prefer just doing
> 
> 	if (!bs) {
> 		/* do kmalloc/kfree thing */
> 	} else {
> 		/* do bioset thing */
> 	}
> 
> NULL @bs indicating no bioset is perfectly natural and so is using
> generic memory allocation in the absense of bioset.  I don't see any
> value in defining Bio_KMALLOC_POOL to be NULL.

Eh, kind of disagree but at this point I don't care that much, I'll
change it.
