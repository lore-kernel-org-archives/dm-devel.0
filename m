From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] aio: Rewrite refcounting
Date: Tue, 9 Oct 2012 11:27:55 -0700
Message-ID: <20121009182755.GN26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-3-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349764760-21093-3-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

On Mon, Oct 08, 2012 at 11:39:18PM -0700, Kent Overstreet wrote:
> The refcounting before wasn't very clear; there are two refcounts in
> struct kioctx, with an unclear relationship between them (or between
> them and ctx->dead).
> 
> Now, reqs_active holds a refcount on users (when reqs_active is
> nonzero), and the initial refcount is taken on reqs_active - when
> ctx->dead goes to 1, we drop that initial refcount.

I agree that it's a mess, but let's rethink this work on top of the
series I'm sending out that gets rid of the retry and cancel code.  It
makes the code a lot easier to follow.  (And Jens also has some patches
to take fewer locks in the submission path, we'll want to take them into
account too.)

- z
