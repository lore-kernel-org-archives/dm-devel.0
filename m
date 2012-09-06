From: "Jun'ichi Nomura" <j-nomura-JhyGz2TFV9J8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v8 3/8] dm: Use bioset's front_pad for dm_rq_clone_bio_info
Date: Thu, 06 Sep 2012 12:21:15 +0900
Message-ID: <504816AB.8080105@ce.jp.nec.com>
References: <1346876849-15820-1-git-send-email-koverstreet@google.com> <1346876849-15820-4-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346876849-15820-4-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On 09/06/12 05:27, Kent Overstreet wrote:
> @@ -2718,7 +2705,8 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
>  	if (!pools->tio_pool)
>  		goto free_io_pool_and_out;
>  
> -	pools->bs = bioset_create(pool_size, 0);
> +	pools->bs = bioset_create(pool_size,
> +				  offsetof(struct dm_rq_clone_bio_info, clone));
>  	if (!pools->bs)
>  		goto free_tio_pool_and_out;

frontpad is not necessary if type is DM_TYPE_BIO_BASED.

Other pool creation in that function do something like:
	pools->bs = (type == DM_TYPE_BIO_BASED) ?
		    bioset_create(pool_size, 0) :
		    bioset_create(pool_size, offsetof(struct dm_rq_clone_bio_info, clone));

-- 
Jun'ichi Nomura, NEC Corporation
