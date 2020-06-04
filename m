From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm crypt: avoid truncating the logical block size
Date: Thu, 4 Jun 2020 15:14:02 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006041512500.3360@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200604190126.15735-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200604190126.15735-1-ebiggers@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, stable@vger.kernel.org
List-Id: dm-devel.ids



On Thu, 4 Jun 2020, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> queue_limits::logical_block_size got changed from unsigned short to
> unsigned int, but it was forgotten to update crypt_io_hints() to use the
> new type.  Fix it.
> 
> Fixes: ad6bf88a6c19 ("block: fix an integer overflow in logical block size")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-crypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 3df90daba89e..a1dcb8675484 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -3274,7 +3274,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	limits->max_segment_size = PAGE_SIZE;
>  
>  	limits->logical_block_size =
> -		max_t(unsigned short, limits->logical_block_size, cc->sector_size);
> +		max_t(unsigned, limits->logical_block_size, cc->sector_size);
>  	limits->physical_block_size =
>  		max_t(unsigned, limits->physical_block_size, cc->sector_size);
>  	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);
> -- 
> 2.27.0.278.ge193c7cf3a9-goog
> 
