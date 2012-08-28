From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v6 04/13] pktcdvd: Switch to bio_kmalloc()
Date: Tue, 28 Aug 2012 16:19:20 -0700 (PDT)
Message-ID: <alpine.LNX.2.00.1208281608560.22447@pobox.suse.cz>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com> <1345655050-28199-5-git-send-email-koverstreet@google.com> <20120822195546.GG19212@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120822195546.GG19212-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Peter Osterlund <petero2-zq6IREYz3ykAvxtiuMwx3w@public.gmane.org>
List-Id: dm-devel.ids

On Wed, 22 Aug 2012, Tejun Heo wrote:

> (cc'ing Jiri, hi!)

Hi there! :)

> On Wed, Aug 22, 2012 at 10:04:01AM -0700, Kent Overstreet wrote:
> > This is prep work for killing bi_destructor - previously, pktcdvd had
> > its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> > necessitating its own bi_destructor implementation.
> > 
> > v5: Un-reorder some functions, to make the patch easier to review
> > 
> > Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > CC: Peter Osterlund <petero2-zq6IREYz3ykAvxtiuMwx3w@public.gmane.org>
> 
> Apart from bio_reset() not resetting bi_end_io and bi_private, this
> looks fine to me but lack of testing makes me a bit hesitant to ack
> it.
> 
> Peter doesn't want to be the maintainer of pktcdvd anymore.  Maybe
> Jiri can be tricked into taking this one too?  :)

Gah, seems like the floppy saga is going to cause me some more trouble in 
the future ... :)

Well, I definitely have hardware back at home that supports this, so I can 
take it. Doesn't seem to be heavy traffic code either.

Peter, ok with that? Also, how was this usually fed upstream -- through 
Jens' tree?

-- 
Jiri Kosina
SUSE Labs
