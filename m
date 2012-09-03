From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v6 04/13] pktcdvd: Switch to bio_kmalloc()
Date: Mon, 3 Sep 2012 18:15:52 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1209031814050.20709@pobox.suse.cz>
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

I have just tested this v6 patchset (and it works for pktcddvd), only to 
see that Kent has sent out v7 (unfortunately he hasn't CCed me on it).

v6 works nicely, bus as far as I understand it, even in v7 we are not 
resetting bi_end_io and bi_private properly, right?

-- 
Jiri Kosina
SUSE Labs
