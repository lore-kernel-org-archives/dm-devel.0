From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Tue, 4 Sep 2012 11:26:33 -0700
Message-ID: <20120904182633.GB3638@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120903004927.GM15292@dastard>
 <20120904135422.GC13768@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120904135422.GC13768-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

Hello,

On Tue, Sep 04, 2012 at 09:54:23AM -0400, Vivek Goyal wrote:
> > Given that we are working around stack depth issues in the
> > filesystems already in several places, and now it seems like there's
> > a reason to work around it in the block layers as well, shouldn't we
> > simply increase the default stack size rather than introduce
> > complexity and performance regressions to try and work around not
> > having enough stack?
> 
> Dave,
> 
> In this particular instance, we really don't have any bug reports of
> stack overflowing. Just discussing what will happen if we make 
> generic_make_request() recursive again.

I think there was one and that's why we added the bio_list thing.

> > I mean, we can deal with it like the ia32 4k stack issue was dealt
> > with (i.e. ignore those stupid XFS people, that's an XFS bug), or
> > we can face the reality that storage stacks have become so complex
> > that 8k is no longer a big enough stack for a modern system....
> 
> So first question will be, what's the right stack size? If we make
> generic_make_request() recursive, then at some storage stack depth we will
> overflow stack anyway (if we have created too deep a stack). Hence
> keeping current logic kind of makes sense as in theory we can support
> arbitrary depth of storage stack.

But, yeah, this can't be solved by enlarging the stack size.  The
upper limit is unbound.

Thanks.

-- 
tejun
