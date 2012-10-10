From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] aio: kiocb_cancel()
Date: Wed, 10 Oct 2012 14:20:51 -0700
Message-ID: <20121010212051.GD6371@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-2-git-send-email-koverstreet@google.com>
 <20121009182625.GM26187@lenny.home.zabbo.net>
 <20121009213700.GF29494@google.com>
 <20121010110356.GA11468@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121010110356.GA11468-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

> And maybe the current way of doing things isn't the best way.  But it
> would be nice if we didn't completely give up on the functionality of
> aio_cancel.

I sympathize, but the reality is that the current infrastructure
is very bad and no one is using it.

It's not like we're getting rid of the syscall.  I'll be behaving
exactly as it does today: returning the error code that indicates that
cancellation failed because it lost the race with completion.  Every
caller has to cope with that to use cancel safely.

So if someone eventually implements iocb cancel safely we'll be able to
plumb it back under the aio syscalls.  But until that day I see no
reason to carry around buggy infrastructure that is only slowing down
the fast path.

- z
