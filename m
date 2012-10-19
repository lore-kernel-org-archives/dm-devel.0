From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 1/2] block: Fix a buffer overrun in
 bio_integrity_split()
Date: Fri, 19 Oct 2012 13:30:15 -0700
Message-ID: <20121019203015.GS13370@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
 <1350331769-14856-28-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1350331769-14856-28-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Mon, Oct 15, 2012 at 01:09:01PM -0700, Kent Overstreet wrote:
> bio_integrity_split() seemed to be confusing pointers and arrays -
> bip_vec in bio_integrity_payload was an array appended to the end of the
> payload, so the bio_vecs in struct bio_pair should have come after the
> bio_integrity_payload they're for.
> 
> Fix it by making bip_vec a pointer to the inline vecs - a later patch is
> going to make more use of this pointer.
> 
> Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> CC: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

This being an apparent bug, I think it would be better to create a
patch to simply reorder bio_pair fields to fix it and mark it w/ Cc:
stable and introduce bip_vec pointer separately.

Other than that, looks good.

Thanks.

-- 
tejun
