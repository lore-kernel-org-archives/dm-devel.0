From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/2] block: Convert integrity to bvec_alloc_bs()
Date: Fri, 19 Oct 2012 14:11:03 -0400
Message-ID: <20121019181103.GH27052@redhat.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
 <1350331769-14856-29-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350331769-14856-29-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Mon, Oct 15, 2012 at 01:09:02PM -0700, Kent Overstreet wrote:
> This adds a pointer to the bvec array to struct bio_integrity_payload,
> instead of the bvecs always being inline; then the bvecs are allocated
> with bvec_alloc_bs().
> 
> Changed bvec_alloc_bs() and bvec_free_bs() to take a pointer to a
> mempool instead of the bioset, so that bio integrity can use a different
> mempool for its bvecs, and thus avoid a potential deadlock.
> 
> This is eventually for immutable bio vecs - immutable bvecs aren't
> useful if we still have to copy them, hence the need for the pointer.
> Less code is always nice too, though.

I think this patch should be part of your immutable prep work series or
later series. First patch is the stand alone fix for bio integrity for
bio_split() case. I would say post that separately and hopefully martin
likes it and acks it. It is simple enough and looks right to me though.

Thanks
Vivek
