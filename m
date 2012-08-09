From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 11/12] block: Add bio_clone_bioset()
Date: Wed, 8 Aug 2012 23:52:51 -0700
Message-ID: <20120809065251.GD2845@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-12-git-send-email-koverstreet@google.com>
 <20120808232120.GK6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809025610.GK7262@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120809025610.GK7262-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Wed, Aug 08, 2012 at 07:56:10PM -0700, Kent Overstreet wrote:
> > So, bio_clone() loses its function comment.  Also, does it even make
> > sense to call bio_clone() from fs_bio_set?
> 
> I'll re add the function comment if you want, just for a single line
> wrapper I don't know if it's worth the cost - comments get out of date,
> and they're more stuff to wade through.

People actually look at docbook generated docs.  I don't know why but
they do.  It's a utility function at block layer.  Please just add the
comment.

> > Let's say it's so, then
> > what's the difference from using _kmalloc variant?
> 
> bio_kmalloc() fails if nr_iovecs > 1024, bio_alloc_bioset() fails if
> nr_iovecs > 256
> 
> and bio_alloc_bioset() is mempool backed, bio_kmalloc() is not.
> 
> AFAICT that's it.

So, the thing is being mempool backed doesn't mean anything if
multiple layers use the pool.  I *suspect* fs_bio_set is supposed to
be used by fs layer - ie. where bios originate.  The reason why I
wondered about bio_clone() is that bio_clone() is almost always used
from stacking drivers and stacking driver tapping into fs reserve is
buggy.  So, I'm wondering whether cloning from fs_bio_set should be
supported at all.

Thanks.

-- 
tejun
