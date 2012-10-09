From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Date: Tue, 9 Oct 2012 14:27:24 -0700
Message-ID: <20121009212724.GD29494@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-5-git-send-email-koverstreet@google.com>
 <20121009183753.GP26187@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121009183753.GP26187-fypN+1c5dIyjpB87vu3CluTW4wlIGRCZ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 09, 2012 at 11:37:53AM -0700, Zach Brown wrote:
> On Mon, Oct 08, 2012 at 11:39:20PM -0700, Kent Overstreet wrote:
> > Bunch of cleanup
> 
> Ugh.  That's way too much noisy change for one patch with no
> description.  Break it up into functional pieces and actually describe
> them.

Heh, I actually didn't mean to send these patches out to lkml just yet
(though now I'm glad I did). There definitely is too much in this patch,
it kinda snowballed.

> > events off the ringbuffer without racing with io_getevents().
> 
> Are you sure this is safe in the presence of wrapping indices?  It's
> been a very long time since I've looked at this, but I could never
> convince myself that it was safe.
> 
> What I'm worried about is cmpxchg()s caller sampling, say, and index of
> 0, having another task GO NUTS and wrap that index all the way around
> back to 0, and then having that initial cmpchg() caller see the wrapped
> 0 index and think that's nothing's changed in the interim.
> 
> Is this a problem?

Ohhhh, yeah it is - ABA. That's easily solved though, we do the head %
nr when we're using the head pointer, and let the stored value use the
full 32 bits.

If libaio is the only thing in userspace looking at the ringbuffer, and
if I'm looking at the latest libaio code this shouldn't break
anything...

> (I wish I could find the comment I wrote in a very old patch to tear out
> the mapped ring entirely.. It was a great list of its design mistakes.)

Sticking the head and tail pointers on the same cacheline is one of my
main complaints. If you could find that comment I'd be interested in
reading it, though.
