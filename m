From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/5] aio: kiocb_cancel()
Date: Wed, 10 Oct 2012 07:03:56 -0400
Message-ID: <20121010110356.GA11468@thunk.org>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-2-git-send-email-koverstreet@google.com>
 <20121009182625.GM26187@lenny.home.zabbo.net>
 <20121009213700.GF29494@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121009213700.GF29494-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 09, 2012 at 02:37:00PM -0700, Kent Overstreet wrote:
> > Honestly: I wouldn't bother.  Nothing of consequence uses cancel.
> > 
> > I have an RFC patch series that tears it out.  Let me polish that up
> > send it out, I'll cc: you.
> 
> Even better :)
> 
> I've been looking at aio locking the past few days, and I was getting
> ready to write something up about cancellation to the lists.

I can definitely think of use cases (inside of Google) where we could
really use aio_cancel.  The issue is it's hard use it safely (i.e., we
need to know whether the file system has already extended the file
before we can know whether or not we can safely cancel the I/O).

> Short version, supporting cancellation without global sychronization is
> possible but it'd require help from the allocator.

Well, we would need some kind of flag to indicate whether cancellation
is possible, yes.  But if we're doing AIO to a raw disk, or we're
talking about a read request, we wouldn't need any help from the
file system's block allocator.

And maybe the current way of doing things isn't the best way.  But it
would be nice if we didn't completely give up on the functionality of
aio_cancel.

						- Ted
