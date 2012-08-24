From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 00/13] Block cleanups
Date: Fri, 24 Aug 2012 05:46:59 -0700
Message-ID: <20120824124659.GA12977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <20120823180041.GK12232@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120823180041.GK12232-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org
List-Id: dm-devel.ids

On Thu, Aug 23, 2012 at 02:00:41PM -0400, Vivek Goyal wrote:
> On Wed, Aug 22, 2012 at 10:03:57AM -0700, Kent Overstreet wrote:
> 
> [..]
> > Kent Overstreet (13):
> >   block: Generalized bio pool freeing
> >   dm: Use bioset's front_pad for dm_rq_clone_bio_info
> >   block: Add bio_reset()
> >   pktcdvd: Switch to bio_kmalloc()
> >   block: Kill bi_destructor
> >   block: Consolidate bio_alloc_bioset(), bio_kmalloc()
> 
> This patch series says "Block Cleanups" in the subject. I think that
> it can be divided in two parts. First part seems to be cleanup where
> we get rid of ->bi_destructor and merge kmalloc() and allocation 
> from bio_set.
> 
> Second part seems to be more of enhancing bio splitting functionality
> and not necessarily a cleanup. So may be breaking this series in two
> parts makes sense. First part is cleanup and second part is enhanced
> bio splitting capabilities of block layer.

Yeah, that's a good idea - will do.
