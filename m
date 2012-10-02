From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v3 06/26] block: Add bio_end_sector()
Date: Tue, 2 Oct 2012 14:10:01 -0400
Message-ID: <20121002181001.GB3283@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-7-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1348526106-17074-7-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <chris.mason-5c4llco8/ftWk0Htik3J/w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Sep 24, 2012 at 03:34:46PM -0700, Kent Overstreet wrote:

[..]
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 4e32be1..d985e90 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -67,6 +67,7 @@
>  #define bio_offset(bio)		bio_iovec((bio))->bv_offset
>  #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
>  #define bio_sectors(bio)	((bio)->bi_size >> 9)
> +#define bio_end_sector(bio)	((bio)->bi_sector + bio_sectors(bio))

May be it is just me. But bio_end_sector() kind of sounds that it will
calculate to the last sector of bio. So I thought of it more as
bio_last_sector() and not the sector which is next to the last sector.

Will it make sense to introduce bio_last_sector() and use +1 everywhere.
Or may be we need a better name. Can't think of one though.

Thanks
Vivek
