From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Date: Tue, 9 Oct 2012 18:09:03 -0700
Message-ID: <20121010010903.GC24174@moria.home.lan>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
 <20121009213111.GE29494@google.com>
 <20121009223210.GR26187@lenny.home.zabbo.net>
 <20121009224428.GH29494@google.com>
 <20121009225836.GU26187@lenny.home.zabbo.net>
 <20121010001630.GC26835@google.com>
 <20121010003626.GY26187@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121010003626.GY26187-fypN+1c5dIyjpB87vu3CluTW4wlIGRCZ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 09, 2012 at 05:36:26PM -0700, Zach Brown wrote:
> > The only situation you have to worry about is when the ringbuffer fills
> > up and stuff goes on the list, and then completions completely stop -
> > this should be a rare enough situation that maybe we could just hack
> > around it with a timer that gets flipped on when the list isn't empty.
> 
> Right.  And this is when we hopefully realize that we're adding overhead
> and complexity (how long's the timer?  always fire it?  MAKE IT STOP)
> and are actually making the system worse, not better.

Can still prototype it, and if it's that ugly... I throw away code all
the time :P

> > Also, for this to be an issue at all, _all_ the reaping would have to be
> > done from userspace - since existing libaio doesn't do that, there may
> > not be any code out there which triggers it.
> 
> And there may be.  We default to not breaking interfaces.  Seriously.

All the more reason to think about it now so we don't screw up the next
interfaces :)
