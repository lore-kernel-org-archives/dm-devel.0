From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Date: Tue, 9 Oct 2012 15:32:10 -0700
Message-ID: <20121009223210.GR26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
 <20121009213111.GE29494@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121009213111.GE29494-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

> If it is measurable I'll take another stab at using memory from
> __get_free_pages() for the ringbuffer. That really would be the ideal
> solution.

No, then you'll run into high order allocation failures with rings that
don't fit in a single page.

> The other reason I wanted to do this was for the aio attributes stuff -
> for return values, I think the only sane way is for the return values to
> go in the ringbuffer, which means records are no longer fixed size so
> dealing with pages is even more of a pain.

Then let's see that, please.

And can we please stop calling them attributes?  They're inputs and
outputs that change behaviour -- they're interfaces.

And no, just for the record, I don't think generic packed variable size
structs are worth the trouble.

If we're going to do a generic interface extension mechanism then we
should put it in its own well thought out system calls, not staple it on
to the side of aio because it's there.  It's a really crummy base to
work from.

- z
