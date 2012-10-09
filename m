From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] aio: kiocb_cancel()
Date: Tue, 9 Oct 2012 14:37:00 -0700
Message-ID: <20121009213700.GF29494@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-2-git-send-email-koverstreet@google.com>
 <20121009182625.GM26187@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121009182625.GM26187-fypN+1c5dIyjpB87vu3CluTW4wlIGRCZ@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

On Tue, Oct 09, 2012 at 11:26:25AM -0700, Zach Brown wrote:
> On Mon, Oct 08, 2012 at 11:39:17PM -0700, Kent Overstreet wrote:
> > Minor refactoring, to get rid of some duplicated code
> 
> Honestly: I wouldn't bother.  Nothing of consequence uses cancel.
> 
> I have an RFC patch series that tears it out.  Let me polish that up
> send it out, I'll cc: you.

Even better :)

I've been looking at aio locking the past few days, and I was getting
ready to write something up about cancellation to the lists.

Short version, supporting cancellation without global sychronization is
possible but it'd require help from the allocator.

If we can just rip it out though that'd really make me happy.
