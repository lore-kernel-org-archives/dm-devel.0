From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 09/26] block: Remove bi_idx references
Date: Tue, 2 Oct 2012 15:24:34 -0400
Message-ID: <20121002192434.GE3283@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-10-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1348526106-17074-10-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

On Mon, Sep 24, 2012 at 03:34:49PM -0700, Kent Overstreet wrote:

[..]
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 95e52879..24e5cef 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -3778,7 +3778,6 @@ static int __floppy_read_block_0(struct block_device *bdev)
>  	bio_vec.bv_len = size;
>  	bio_vec.bv_offset = 0;
>  	bio.bi_vcnt = 1;
> -	bio.bi_idx = 0;

So leaving bio.bi_idx uninitialized is safer than setting it to zero? Can
you explain a bit more that why this change is required? 

Thanks
Vivek
