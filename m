From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Sun, 2 Sep 2012 18:17:52 -0700
Message-ID: <20120903011752.GC20060@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120903004927.GM15292@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120903004927.GM15292@dastard>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Sep 03, 2012 at 10:49:27AM +1000, Dave Chinner wrote:
> Given that we are working around stack depth issues in the
> filesystems already in several places, and now it seems like there's
> a reason to work around it in the block layers as well, shouldn't we
> simply increase the default stack size rather than introduce
> complexity and performance regressions to try and work around not
> having enough stack?
> 
> I mean, we can deal with it like the ia32 4k stack issue was dealt
> with (i.e. ignore those stupid XFS people, that's an XFS bug), or
> we can face the reality that storage stacks have become so complex
> that 8k is no longer a big enough stack for a modern system....

I'm not arguing against increasing the default stack size (I really
don't have an opinion there) - but it's not a solution for the block
layer, as stacking block devices can require an unbounded amount of
stack without the generic_make_request() convert recursion-to-iteration
thing.
