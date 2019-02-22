From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm crypt: fix memory leak in dm_crypt_integrity_io_alloc() error
 path
Date: Fri, 22 Feb 2019 17:45:18 -0500
Message-ID: <20190222224518.GA11359@redhat.com>
References: <20190216210022.29483-1-sultan@kerneltoast.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190216210022.29483-1-sultan@kerneltoast.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sultan@kerneltoast.com
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Feb 16 2019 at  4:00pm -0500,
sultan@kerneltoast.com <sultan@kerneltoast.com> wrote:

> From: Sultan Alsawaf <sultan@kerneltoast.com>
> 
> dm_crypt_integrity_io_alloc() allocates space for an integrity payload but
> doesn't free it in the error path, leaking memory. Add a bio_integrity_free()
> invocation upon error to fix the memory leak.
> 
> Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> ---
>  drivers/md/dm-crypt.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index dd538e6b2..f731e1fe0 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -939,8 +939,10 @@ static int dm_crypt_integrity_io_alloc(struct dm_crypt_io *io, struct bio *bio)
>  
>  	ret = bio_integrity_add_page(bio, virt_to_page(io->integrity_metadata),
>  				     tag_len, offset_in_page(io->integrity_metadata));
> -	if (unlikely(ret != tag_len))
> +	if (unlikely(ret != tag_len)) {
> +		bio_integrity_free(bio);
>  		return -ENOMEM;
> +	}
>  
>  	return 0;
>  }

Since commit 7c20f11680a4 bio_integrity_free() is no longer and exported
symbol.

But that aside, this dm-crypt clone bio's endio will clean up the bip
once -ENOMEM return starts to make its way out via
crypt_alloc_buffer()'s bio_put().

Mike
