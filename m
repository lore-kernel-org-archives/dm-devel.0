From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/5] aio: kiocb_cancel()
Date: Wed, 10 Oct 2012 19:21:51 -0400
Message-ID: <20121010232151.GC11468@thunk.org>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-2-git-send-email-koverstreet@google.com>
 <20121009182625.GM26187@lenny.home.zabbo.net>
 <20121009213700.GF29494@google.com>
 <20121010110356.GA11468@thunk.org>
 <20121010212051.GD6371@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121010212051.GD6371-fypN+1c5dIyjpB87vu3CluTW4wlIGRCZ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, Oct 10, 2012 at 02:20:51PM -0700, Zach Brown wrote:
> 
> I sympathize, but the reality is that the current infrastructure
> is very bad and no one is using it.
> 
> It's not like we're getting rid of the syscall.  I'll be behaving
> exactly as it does today: returning the error code that indicates that
> cancellation failed because it lost the race with completion.  Every
> caller has to cope with that to use cancel safely.

Yes, I realize it doesn't work today.  But hopefully we'll be able to
reimplement it in a cleaner way.  That's why I said, I hope we don't
give up on the functionality of aio_cancel --- not that I'm against
removing what we currently have.

Cheers,

					- Ted
