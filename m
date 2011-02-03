From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] dm crypt: wipe keys string immediately
 after key is set
Date: Thu, 3 Feb 2011 10:52:45 -0500
Message-ID: <20110203155244.GC24255@redhat.com>
References: <1296691696-23722-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1296691696-23722-1-git-send-email-mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 02 2011 at  7:08pm -0500,
Milan Broz <mbroz@redhat.com> wrote:

> If the tfm key was set up correctly, do not keep another
> copy of key and immediately replace it with zero string.
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> ---
>  drivers/md/dm-crypt.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 4e054bd..d748433 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1331,20 +1331,26 @@ static int crypt_setkey_allcpus(struct crypt_config *cc)
>  
>  static int crypt_set_key(struct crypt_config *cc, char *key)
>  {
> +	int r = -EINVAL, key_string_len = strlen(key);
> +
>  	/* The key size may not be changed. */
> -	if (cc->key_size != (strlen(key) >> 1))
> -		return -EINVAL;
> +	if (cc->key_size != (key_string_len >> 1))
> +		goto out;
>  
>  	/* Hyphen (which gives a key_size of zero) means there is no key. */
>  	if (!cc->key_size && strcmp(key, "-"))
> -		return -EINVAL;
> +		goto out;
>  
>  	if (cc->key_size && crypt_decode_key(cc->key, key, cc->key_size) < 0)
> -		return -EINVAL;
> +		goto out;
>  
>  	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
>  
> -	return crypt_setkey_allcpus(cc);
> +	r = crypt_setkey_allcpus(cc);
> +out:
> +	/* Wipe hexa key string as soon as possible */

s/hexa/hex/ ?

> +	memset(key, '0', key_string_len);
> +	return r;
>  }
>  
>  static int crypt_wipe_key(struct crypt_config *cc)

Acked-by: Mike Snitzer <snitzer@redhat.com>
