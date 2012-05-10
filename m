From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [Bcache v13 01/16] Only clone bio vecs that are in use
Date: Thu, 10 May 2012 17:35:56 -0400
Message-ID: <20120510213556.GO23768@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 09, 2012 at 11:08:13PM -0400, Kent Overstreet wrote:

[..]
> -
> -	if (bio_integrity(bio)) {
> -		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
> -
> +#if 0
> +	if (bio_integrity(bio))
>  		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
>  			bio_integrity_trim(clone,
>  					   bio_sector_offset(bio, idx, 0), len);
> -	}
> -
> +#endif

Dead/debug code under "#if 0" ?

Thanks
Vivek
