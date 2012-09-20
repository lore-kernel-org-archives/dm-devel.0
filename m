From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/26] block: Refactor blk_update_request()
Date: Thu, 20 Sep 2012 16:41:33 -0700
Message-ID: <20120920234133.GM7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-4-git-send-email-koverstreet@google.com>
 <20120920232000.GG7264@google.com>
 <20120920233632.GC5519@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120920233632.GC5519-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hey,

On Thu, Sep 20, 2012 at 04:36:32PM -0700, Kent Overstreet wrote:
> > Other than that, I definitely like this.  It would be nice to note
> > that the custom partial bio advancing in blk_update_request() is
> > replaced with multiple calls to req_bio_endio().  I don't think it has
> > any meaningful performance implications.  It's just nice to future
> > readers of the commit.
> 
> The number of calls to req_bio_endio() isn't changing...
> blk_update_request() called it for partial completions before. It's just
> where the bio itself is updated that's getting shuffled around.
>
> Or did you mean that bio_advance() is getting called on every bio
> instead of the custom advancing in blk_update_request() before? That is
> different, yeah - it's now always looping over the iovec, not just for
> partial completions.
> 
> Yeah, I will note that in the commit message, in case Jens sees a
> performance regression from it :)

I don't think there's any performance implication.  It's just nice to
explain how the complexity went away.  If for nothing else, to point
out how silly the original code was. :)

> > Also, it would be really nice if you can verify this actually works
> > with partial blk_update_request().  sector update bug in the previous
> > patch scares me a bit.  Implementing some debug hacks in the
> > completion path might be the easiest way to verify.  A subtle bug here
> > could be pretty painful.
> 
> Any suggestions on how to trigger partial updates?

ide along with many legacy drivers do it.  Any SCSI driver including
libata only does full completion.  I don't know.  Even just trying to
call the function and comparing before & after with the original code
would be good.  I'd like to see at least some form of verification
because the manifested bugs could be extremely nasty and difficult to
track down.

Thanks.

-- 
tejun
