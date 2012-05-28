From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 01/16] block: Generalized bio pool freeing
Date: Mon, 28 May 2012 10:15:22 +0900
Message-ID: <20120528011522.GA9891@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-2-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337977539-16977-2-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

Hello, Kent.

On Fri, May 25, 2012 at 01:25:24PM -0700, Kent Overstreet wrote:
> With the old code, when you allocate a bio from a bio pool you have to
> implement your own destructor that knows how to find the bio pool the
> bio was originally allocated from.
> 
> This adds a new field to struct bio (bi_pool) and changes
> bio_alloc_bioset() to use it. This makes various bio destructors
> unnecessary, so they're then deleted.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Change-Id: I5eb66c1d6910757f4af8755b8857dcbe4619cf8d

In the previous review, I made two requests about this patch.

* Please improve description.

* Please lose Change-Id.

None of which seems to have happened and my Acked-by isn't added
either.  Come on.  Give me some reason to keep reviewing this stuff.
A couple more suggestions.

* If this goes in, it will go through Jens' block tree.  Better keep
  him cc'd.

* It's generally a good idea to have Cc: tags in the description
  footer for the maintainers of the affected subsystems.

Thanks.

-- 
tejun
