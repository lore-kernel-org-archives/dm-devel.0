From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-crypt: mark key as invalid until properly
	loaded
Date: Wed, 2 Nov 2016 18:57:03 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1611021856120.18921@file01.intranet.prod.int.rdu2.redhat.com>
References: <1478095328-30806-1-git-send-email-okozina@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478095328-30806-1-git-send-email-okozina@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids



On Wed, 2 Nov 2016, Ondrej Kozina wrote:

> on crypt_message() key set code path while loading new key
> replacing the old one in case tfm->setkey() fails
> we would end having invalid key in crypto layer but
> DM_CRYPT_KEY_VALID flag set.
> 
> Signed-off-by: Ondrej Kozina <okozina@redhat.com>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-crypt.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index a276883..0aedd0e 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1503,12 +1503,15 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
>  	if (!cc->key_size && strcmp(key, "-"))
>  		goto out;
>  
> +	/* clear the flag since following operations may invalidate previously valid key */
> +	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> +
>  	if (cc->key_size && crypt_decode_key(cc->key, key, cc->key_size) < 0)
>  		goto out;
>  
> -	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
> -
>  	r = crypt_setkey_allcpus(cc);
> +	if (!r)
> +		set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
>  
>  out:
>  	/* Hex key string not needed after here, so wipe it. */
> -- 
> 2.7.4
> 
