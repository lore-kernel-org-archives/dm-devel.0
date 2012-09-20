From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/26] block: Remove bi_idx references
Date: Thu, 20 Sep 2012 16:49:53 -0700
Message-ID: <20120920234953.GO7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-9-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1347322957-25260-9-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 05:22:19PM -0700, Kent Overstreet wrote:
> These were harmless but uneccessary,andt getting rid of them makes the
> code easier to audit since most of them need to be removed.

I find the descriptions a bit too terse.  Why do they need to be
removed?  So, I suppose you wanted to say explicit initializations to
0 are unnecessary, but there are bio_segments() conversions too.

The patch is simple and this isn't a big deal but I really hope for
better (correct) descriptions.

Thanks.

-- 
tejun
