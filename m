From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 10/12] block: Add bio_clone_kmalloc()
Date: Wed, 8 Aug 2012 23:55:04 -0700
Message-ID: <20120809065504.GE2845@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-11-git-send-email-koverstreet@google.com>
 <20120808231552.GJ6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809015704.GI7262@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120809015704.GI7262-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Wed, Aug 08, 2012 at 06:57:04PM -0700, Kent Overstreet wrote:
> That means bio_clone_kmalloc will just become:
> 
> static inline struct bio *bio_clone_kmalloc(struct bio *bio,
> 					    gfp_t gfp_mask)
> {
> 	return bio_clone_bioset(bio, gfp_mask, BIO_KMALLOC_POOL)
> }
> 
> (or maybe NULL there, I think using NULL for the interface makes sense,
> I just don't want to use it for bi_pool).
> 
> Do you still want the /** for a one line wrapper like that?

I don't know.  But do you think you can do similar thing to alloc
interface too?

Thanks.

-- 
tejun
