From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Date: Tue, 9 Oct 2012 17:36:26 -0700
Message-ID: <20121010003626.GY26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
 <20121009213111.GE29494@google.com>
 <20121009223210.GR26187@lenny.home.zabbo.net>
 <20121009224428.GH29494@google.com>
 <20121009225836.GU26187@lenny.home.zabbo.net>
 <20121010001630.GC26835@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121010001630.GC26835-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

> The only situation you have to worry about is when the ringbuffer fills
> up and stuff goes on the list, and then completions completely stop -
> this should be a rare enough situation that maybe we could just hack
> around it with a timer that gets flipped on when the list isn't empty.

Right.  And this is when we hopefully realize that we're adding overhead
and complexity (how long's the timer?  always fire it?  MAKE IT STOP)
and are actually making the system worse, not better.

> Also, for this to be an issue at all, _all_ the reaping would have to be
> done from userspace - since existing libaio doesn't do that, there may
> not be any code out there which triggers it.

And there may be.  We default to not breaking interfaces.  Seriously.

- z
