From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Date: Tue, 9 Oct 2012 11:29:49 -0700
Message-ID: <20121009182949.GO26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349764760-21093-4-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

On Mon, Oct 08, 2012 at 11:39:19PM -0700, Kent Overstreet wrote:
> It simplifies a lot of stuff if the ringbuffer is contiguously mapped
> into kernel space, and we can delete a lot of code - in particular, this
> is useful for converting read_events() to cmpxchg.

1) I'm concerned that Our Favourite Database Benchmarkers will see an
effect of having more TLB pressure from that mapping.  kmap_atomic()
should be cheaper.  We'll need to measure the difference.

2) I'm not at all convinced that the current ring semantics are safe
with cmpxchg(), more in the next patch.

- z
