From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/13] block: Generalized bio pool freeing
Date: Fri, 18 May 2012 08:55:38 -0700
Message-ID: <20120518155538.GA19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <ea774fea2a27c9f1028a12ce31a7ee5e5517bef4.1337308722.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ea774fea2a27c9f1028a12ce31a7ee5e5517bef4.1337308722.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Thu, May 17, 2012 at 10:59:48PM -0400, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org wrote:
> From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> With the old code, when you allocate a bio from a bio pool you have to
> implement your own destructor that knows how to find the bio pool the
> bio was originally allocated from.
> 
> This adds a new field to struct bio (bi_pool) and changes
> bio_alloc_bioset() to use it. This makes various bio destructors
> unnecessary, so they're then deleted.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Please add Cc: to maintainers of each modified subsystem.  Other than
that, nice cleanup even without the later removal of bi_destructor.

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
