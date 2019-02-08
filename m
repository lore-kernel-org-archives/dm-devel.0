From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm: don't overallocate the tags space
Date: Fri, 8 Feb 2019 19:06:45 +0100
Message-ID: <96b4fcfb-f4fd-60fd-70e3-c9d981205ff2@gmail.com>
References: <alpine.LRH.2.02.1902081048510.1182@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1902081048510.1182@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Ming Lei <minlei@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/02/2019 16:52, Mikulas Patocka wrote:
> bio_sectors returns the value in the units of 512-byte sectors (no matter
> what's the real sector size of the device). dm-crypt multiplies
> bio_sectors by on_disk_tag_size to calculate the space allocated for
> integrity tags. If dm-crypt is running with sector size larger than 512,
> it allocates more data than what's needed.
> 
> Device mapper trimmed this extra space when passing the bio to
> dm-integrity, so this bug didn't result in any visible misbehavior. This
> bug showed up when device mapper stopped trimming the bio.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Milan Broz <mbroz@redhat.com>
> 
> ---
>  drivers/md/dm-crypt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/dm-crypt.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-crypt.c	2019-02-08 14:12:19.000000000 +0100
> +++ linux-2.6/drivers/md/dm-crypt.c	2019-02-08 14:12:19.000000000 +0100
> @@ -932,7 +932,7 @@ static int dm_crypt_integrity_io_alloc(s
>  	if (IS_ERR(bip))
>  		return PTR_ERR(bip);
>  
> -	tag_len = io->cc->on_disk_tag_size * bio_sectors(bio);
> +	tag_len = io->cc->on_disk_tag_size * (bio_sectors(bio) >> io->cc->sector_shift);
>  
>  	bip->bip_iter.bi_size = tag_len;
>  	bip->bip_iter.bi_sector = io->cc->start + io->sector;
> 

Yes, this was the problem (perhaps introduced by me since the first commit implementing
authenticated encryption).

With patch above even the bio_trim() works properly.

Tested-and-Reviewed-by: Milan Broz <gmazyland@gmail.com>

Thanks!
Milan
