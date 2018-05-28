From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] md: dm-crypt: Add Inline Encryption support for dmcrypt
Date: Mon, 28 May 2018 18:32:46 +0200
Message-ID: <7a510610-9133-39aa-6841-3925c532f3c0@gmail.com>
References: <e9120efc-1e25-79c8-6132-9062dd030539@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e9120efc-1e25-79c8-6132-9062dd030539@synopsys.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Manjunath M Bettegowda <manjumb@synopsys.com>, Prabu Thangamuthu <prabut@synopsys.com>, Tejas Joglekar <Tejas.Joglekar@synopsys.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/28/2018 03:01 PM, Ladvine D Almeida wrote:
> 
> This patch adds new option
>     -- perform_inline_encrypt
> that set the option inside dmcrypt to use inline encryption for
> the configured mapping. I want to introduce inline encryption support
> in the UFS Host Controller driver. The usage of the same for accomplishing
> the Full Disk Encryption is done by the following changes in the
> dmcrypt subsystem:
>     - New function crypt_inline_encrypt_submit() is added to the
> dmcrypt which associate the crypto context to the bios which
> are submitted by the subsystem.
>     - Successful configuration for the inline encryption will result in
> the crypto transformation job being bypassed in the dmcrypt layer and the
> actual encryption happens inline to the block device.

I am not sure this is a good idea. Dm-crypt should never ever forward
plaintext sector to underlying device.

And you do not even check that your hw is available in the underlying device!

If you want to use dm-crypt, write a crypto API driver for your crypto hw that defines
specific cipher and let dm-crypt use this cipher (no patches needed in this case!)

If I read the patch correctly, you do not check any parameters for
compatibility with your hw support (cipher, mode, IV algorithm, key length, sector size ...)

It seems like if the "perform_inline_encrypt" option is present, you just submit
the whole bio to your code with new INLINE_ENCRYPTION bit set.

What happens, if the cipher in table is different from what your hw is doing?

Milan

> Another patch set is sent to the block layer community for
> CONFIG_BLK_DEV_INLINE_ENCRYPTION config, which enables changes in the
> block layer for adding the bi_ie_private variable to the bio structure.
> 
> Signed-off-by: Ladvine D Almeida <ladvine@synopsys.com>
> ---
>  drivers/md/dm-crypt.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 44ff473..a9ed567 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -39,6 +39,7 @@
>  #include <linux/device-mapper.h>
>  
>  #define DM_MSG_PREFIX "crypt"
> +#define REQ_INLINE_ENCRYPTION REQ_DRV
>  
>  /*
>   * context holding the current state of a multi-part conversion
> @@ -125,7 +126,8 @@ struct iv_tcw_private {
>   * and encrypts / decrypts at the same time.
>   */
>  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
> -	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
> +	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
> +		 DM_CRYPT_INLINE_ENCRYPT };
>  
>  enum cipher_flags {
>  	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */
> @@ -215,6 +217,10 @@ struct crypt_config {
>  
>  	u8 *authenc_key; /* space for keys in authenc() format (if used) */
>  	u8 key[0];
> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
> +	void *ie_private; /* crypto context for inline enc drivers */
> +	int key_cfg_idx;  /* key configuration index for inline enc */
> +#endif
>  };
>  
>  #define MIN_IOS		64
> @@ -1470,6 +1476,20 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
>  	atomic_set(&io->io_pending, 0);
>  }
>  
> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
> +static void crypt_inline_encrypt_submit(struct crypt_config *cc,
> +	struct dm_target *ti, struct bio *bio)
> +{
> +	bio_set_dev(bio, cc->dev->bdev);
> +	if (bio_sectors(bio))
> +		bio->bi_iter.bi_sector = cc->start +
> +			dm_target_offset(ti, bio->bi_iter.bi_sector);
> +	bio->bi_opf |= REQ_INLINE_ENCRYPTION;
> +	bio->bi_ie_private = cc->ie_private;
> +	generic_make_request(bio);
> +}
> +#endif
> +
>  static void crypt_inc_pending(struct dm_crypt_io *io)
>  {
>  	atomic_inc(&io->io_pending);
> @@ -1960,6 +1980,9 @@ static int crypt_setkey(struct crypt_config *cc)
>  
>  	/* Ignore extra keys (which are used for IV etc) */
>  	subkey_size = crypt_subkey_size(cc);
> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
> +	cc->key_cfg_idx = -1;
> +#endif
>  
>  	if (crypt_integrity_hmac(cc)) {
>  		if (subkey_size < cc->key_mac_size)
> @@ -1978,10 +2001,19 @@ static int crypt_setkey(struct crypt_config *cc)
>  			r = crypto_aead_setkey(cc->cipher_tfm.tfms_aead[i],
>  					       cc->key + (i * subkey_size),
>  					       subkey_size);
> -		else
> +		else {
>  			r = crypto_skcipher_setkey(cc->cipher_tfm.tfms[i],
>  						   cc->key + (i * subkey_size),
>  						   subkey_size);
> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
> +			if (r > 0) {
> +				cc->key_cfg_idx = r;
> +				cc->ie_private = cc->cipher_tfm.tfms[i];
> +				r = 0;
> +			}
> +#endif
> +		}
> +
>  		if (r)
>  			err = r;
>  	}
> @@ -2654,6 +2686,10 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
>  			cc->sector_shift = __ffs(cc->sector_size) - SECTOR_SHIFT;
>  		} else if (!strcasecmp(opt_string, "iv_large_sectors"))
>  			set_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
> +		else if (!strcasecmp(opt_string, "perform_inline_encrypt"))
> +			set_bit(DM_CRYPT_INLINE_ENCRYPT, &cc->flags);
> +#endif
>  		else {
>  			ti->error = "Invalid feature arguments";
>  			return -EINVAL;
> @@ -2892,6 +2928,13 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  	if (unlikely(bio->bi_iter.bi_size & (cc->sector_size - 1)))
>  		return DM_MAPIO_KILL;
>  
> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
> +	if (cc->key_cfg_idx > 0) {
> +		crypt_inline_encrypt_submit(cc, ti, bio);
> +		return DM_MAPIO_SUBMITTED;
> +	}
> +#endif
> +
>  	io = dm_per_bio_data(bio, cc->per_bio_data_size);
>  	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
>  
> @@ -2954,6 +2997,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>  		num_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
>  		num_feature_args += cc->sector_size != (1 << SECTOR_SHIFT);
>  		num_feature_args += test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
> +		num_feature_args +=
> +			test_bit(DM_CRYPT_INLINE_ENCRYPT, &cc->flags);
> +#endif
>  		if (cc->on_disk_tag_size)
>  			num_feature_args++;
>  		if (num_feature_args) {
> @@ -2970,6 +3017,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>  				DMEMIT(" sector_size:%d", cc->sector_size);
>  			if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
>  				DMEMIT(" iv_large_sectors");
> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
> +			if (test_bit(DM_CRYPT_INLINE_ENCRYPT, &cc->flags))
> +				DMEMIT(" perform_inline_encrypt");
> +#endif
>  		}
>  
>  		break;
> 
