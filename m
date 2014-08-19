From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-crypt: Fix per-bio data alignment
Date: Tue, 19 Aug 2014 14:37:36 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1408191433450.29729@file01.intranet.prod.int.rdu2.redhat.com>
References: <53F238EF.10409@winsoft.pl>
	<1408386997-14690-1-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1408386997-14690-1-git-send-email-gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: kkolasa@winsoft.pl, dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Hi

I would like to see the explanation, why does this patch fix it. i686 
allows unaligned access for most instructions, so I wonder how could 
adding an alignment fix it.

What is the exact cipher mode that crashes it? How can I reproduce it with 
cryptsetup?

Is it possible that something shoots beyond the end of cc->iv_size and the 
alignment just masks this bug?

Mikulas



On Mon, 18 Aug 2014, Milan Broz wrote:

> The commit
>   298a9fa08a1577211d42a75e8fc073baef61e0d9
>   dm crypt: use per-bio data
> causes OOPS on 32bit i686 architecture
> 
>   BUG: unable to handle kernel paging request at 20000000
>   IP: [<e0fe2433>] clone_endio+0x13/0xe0 [dm_mod]
>   ...
> 
>  [<c1257b61>] bio_endio+0x61/0x90
>  [<e142476c>] crypt_dec_pending+0x8c/0xd0 [dm_crypt]
>  [<e142666f>] kcryptd_crypt+0x4bf/0x4f0 [dm_crypt]
> 
> This patch fixes the issue by aligning per-bio alocated structure size.
> 
> Reported-by: Krzysztof Kolasa <kkolasa@winsoft.pl>
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  drivers/md/dm-crypt.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 2785007..33f26a2 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1735,9 +1735,10 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		goto bad;
>  	}
>  
> -	cc->per_bio_data_size = ti->per_bio_data_size =
> -				sizeof(struct dm_crypt_io) + cc->dmreq_start +
> -				sizeof(struct dm_crypt_request) + cc->iv_size;
> +	cc->per_bio_data_size = ALIGN(sizeof(struct dm_crypt_io) + cc->dmreq_start +
> +				      sizeof(struct dm_crypt_request) + cc->iv_size,
> +				      ARCH_KMALLOC_MINALIGN);
> +	ti->per_bio_data_size = cc->per_bio_data_size;
>  
>  	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
>  	if (!cc->page_pool) {
> -- 
> 2.1.0
> 
