From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Tue, 28 Aug 2012 18:06:10 -0400
Message-ID: <20120828220610.GH31674@redhat.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1346175456-1572-10-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Aug 28, 2012 at 10:37:36AM -0700, Kent Overstreet wrote:
> Previously, if we ever try to allocate more than once from the same bio
> set while running under generic_make_request() (i.e. a stacking block
> driver), we risk deadlock.
> 
> This is because of the code in generic_make_request() that converts
> recursion to iteration; any bios we submit won't actually be submitted
> (so they can complete and eventually be freed) until after we return -
> this means if we allocate a second bio, we're blocking the first one
> from ever being freed.
> 
> Thus if enough threads call into a stacking block driver at the same
> time with bios that need multiple splits, and the bio_set's reserve gets
> used up, we deadlock.

Hi Kent,

So above deadlock possibility arises only if multiple threads are doing
multiple splits from same pool and all the threads get blocked on mempool
and don't return from ->make_request function.

Is there any existing driver in the tree which can cause this deadlock or
it becomes a possibility only when splitting and bcache code shows up?

Thanks
Vivek
