From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/26] block: Convert integrity to bvec_alloc_bs(),
 and a bugfix
Date: Fri, 19 Oct 2012 13:34:21 -0700
Message-ID: <20121019203421.GT13370@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
 <1350331769-14856-31-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350331769-14856-31-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Oct 15, 2012 at 01:09:04PM -0700, Kent Overstreet wrote:
> This adds a pointer to the bvec array to struct bio_integrity_payload,
> instead of the bvecs always being inline; then the bvecs are allocated
> with bvec_alloc_bs().
> 
> This is needed eventually for immutable bio vecs - immutable bvecs
> aren't useful if we still have to copy them, hence the need for the
> pointer. Less code is always nice too, though.
> 
> Also fix an amusing bug in bio_integrity_split() - struct bio_pair
> doesn't have the integrity bvecs after the bio_integrity_payloads, so
> there was a buffer overrun. The code was confusing pointers with arrays.

Ummm... patch description doesn't agree with the patch content?

-- 
tejun
