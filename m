From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] md: dm-crypt: Add Inline Encryption support for dmcrypt
Date: Fri, 1 Jun 2018 09:52:34 +0200
Message-ID: <c94d425a-bca4-8a8b-47bf-451239d29ebd@gmail.com>
References: <e9120efc-1e25-79c8-6132-9062dd030539@synopsys.com>
 <7a510610-9133-39aa-6841-3925c532f3c0@gmail.com>
 <BD7FB879CC136E419544C8E2AE7B9C3020BB94@IN01WEMBXA.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BD7FB879CC136E419544C8E2AE7B9C3020BB94@IN01WEMBXA.internal.synopsys.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Manjunath M Bettegowda <Manjunath.MB@synopsys.com>, Prabu Thangamuthu <Prabu.T@synopsys.com>, Tejas Joglekar <Tejas.Joglekar@synopsys.com>, device-mapper development <dm-devel@redhat.com>, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: dm-devel.ids

On 05/30/2018 04:52 PM, Ladvine D Almeida wrote:
 
> we have crypto API implementation for the hardware for  XTS algorithm, which will get registered when
> the XTS algorithm capability of the inline encryption engine inside UFS Host Controller get detected by the UFS HC
> driver. dm-crypt will be using this registered cipher.
>  dm-crypt patch is unavoidable because the encrypt/decrypt function cannot perform the transformation
> when inline encryption engine is involved. Also, it demands forwarding the plaintext sectors to the underlying
> block device driver and  the crypto transformation happens internally in controller when data transfer happens.

I understand you want to utilize hardware this way, but this is very dangerous abusing of dm-crypt,
that is designed to be software-based FDE (hw acceleration should be on crypto API layer that decides where to encrypt data).

Either you should implement crypto accelerator driver, that will work with dm-crypt through crypto API,
or you can implement own crypto block layer driver or a new device-mapper target (very similar to linear one)
that will just add key reference to bio for inline encryption.

>> If I read the patch correctly, you do not check any parameters for
>> compatibility with your hw support (cipher, mode, IV algorithm, key length, sector size ...)
> 
> I am registering an algorithm with cipher mode, IV size, block size, supported key size etc. for use by dm-crypt
> as per the hardware capability of inline encryption engine.
> If any other cipher mode, etc is used during the setup stage, DM-Crypt will work as normal.
> 
>>
>> It seems like if the "perform_inline_encrypt" option is present, you just submit
>> the whole bio to your code with new INLINE_ENCRYPTION bit set.
> 
> when the optional argument "perform_inline_encrypt" is set, we are not unconditionally sending the bio
> to the block devices. The steps are explained below:
> 1. user invokes the dm-setup command with the registered cipher "xts" and with the optional argument
> "perform_inline_encrypt".
> 2. dm-setup invokes the setkey function of the newly introduced algorithm, which finds the available key slots
> to be programmed(UFS Host controller Inline Encryption engine has multiple keyslots), program the key slot,
> and return the key slot index as return value of the set key function.
> 3. When read/write operation happens, crypt_map() function in dm-crypt validates whether there is associated
> key configuration index for the request. The Bio will be submitted directly in this case only with the associated
> crypto context.
> 4. Block device driver, eg. UFS host controller driver will create the Transfer requests as per this crypto context and
> encryption happens inside the controller.
>>
>> What happens, if the cipher in table is different from what your hw is doing?
> 
> In this case, the dm-crypt will work as previous. This is because the setkey returns 0.
> whenever there is key configuration index associated, setkey returns index value(greater than 0). The bios are submitted
> with that information to underlying block device drivers.
> Also, care is taken to ensure that fallback will happen incase hardware lacks the support of any key lengths.

What I see in the patch is:

You set key through crypto_skcipher_setkey() for crypto API tpm (whatever driver it uses)
seems that you expect that this function returns your key offset in hw and this is the only
check I see there.

According to crypto/skcipher.h, the positive return value is not defined for crypto_skcipher_setkey()
"* Return: 0 if the setting of the key was successful; < 0 if an error occurred"

If it is undocumented extension of crypto API, then ANY driver, that returns positive integer
here causes that dmcrypt will bypass encryption in map function later.


Another question - how do you handle different IV generators (that are currently implemented in dmcrypt inline)?
What if I want to use (for some reason) other IV generator that plain sector number with XTS (aes-xts-essiv:sha256 for example)?

Where do you check that inline encryption will use properly generated IV for sector?
Ditto for dm-crypt sector_size and some other parameters (we can use 4k encryption sector over device
that announces 512 hw sectors).

> Appreciate your suggestions/feedback. We are trying to bring modifications into the subsystem to support controllers with
> inline encryption capabilities and tried our best to take care of any vulnerabilities or risks associated to same.
> Inline encryption engines got huge advantage over the accelerators/software algorithms that it removes overhead associated
> to current implementation like performing transformation on 512 byte chunks, allocation of scatterlists etc.

Well, it is up to Mike if he accepts such extensions, but for me this is not the correct way.

I would suggest you to implement a new device-mapper target for inline encryption (it should be quite straightforward,
basically just key setting extension to linear target?).
All this logic seems to be just a wrapper for some preconfigured hw block device with encryption.

All dm-crypt mappings should be configurable using cryptsetup tool (not only dmsetup),
you solution is hw dependent and is then unsupportable in cryptsetup.

We can support in future some key wrapping schemes fore HSM (like paes in S390) but the interface to dm-crypt must
be hw independent.

Also the extension of bio struct is perhaps not acceptable, this is why there is bio cloning interface and bi_private
(I think Jens already mentioned it in reply for another patch from series).

Milan


>>> Another patch set is sent to the block layer community for
>>> CONFIG_BLK_DEV_INLINE_ENCRYPTION config, which enables changes in the
>>> block layer for adding the bi_ie_private variable to the bio structure.
>>>
>>> Signed-off-by: Ladvine D Almeida <ladvine@synopsys.com>
>>> ---
>>>  drivers/md/dm-crypt.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++--
>>>  1 file changed, 53 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>>> index 44ff473..a9ed567 100644
>>> --- a/drivers/md/dm-crypt.c
>>> +++ b/drivers/md/dm-crypt.c
>>> @@ -39,6 +39,7 @@
>>>  #include <linux/device-mapper.h>
>>>  
>>>  #define DM_MSG_PREFIX "crypt"
>>> +#define REQ_INLINE_ENCRYPTION REQ_DRV
>>>  
>>>  /*
>>>   * context holding the current state of a multi-part conversion
>>> @@ -125,7 +126,8 @@ struct iv_tcw_private {
>>>   * and encrypts / decrypts at the same time.
>>>   */
>>>  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
>>> -	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
>>> +	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
>>> +		 DM_CRYPT_INLINE_ENCRYPT };
>>>  
>>>  enum cipher_flags {
>>>  	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */
>>> @@ -215,6 +217,10 @@ struct crypt_config {
>>>  
>>>  	u8 *authenc_key; /* space for keys in authenc() format (if used) */
>>>  	u8 key[0];
>>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
>>> +	void *ie_private; /* crypto context for inline enc drivers */
>>> +	int key_cfg_idx;  /* key configuration index for inline enc */
>>> +#endif
>>>  };
>>>  
>>>  #define MIN_IOS		64
>>> @@ -1470,6 +1476,20 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
>>>  	atomic_set(&io->io_pending, 0);
>>>  }
>>>  
>>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
>>> +static void crypt_inline_encrypt_submit(struct crypt_config *cc,
>>> +	struct dm_target *ti, struct bio *bio)
>>> +{
>>> +	bio_set_dev(bio, cc->dev->bdev);
>>> +	if (bio_sectors(bio))
>>> +		bio->bi_iter.bi_sector = cc->start +
>>> +			dm_target_offset(ti, bio->bi_iter.bi_sector);
>>> +	bio->bi_opf |= REQ_INLINE_ENCRYPTION;
>>> +	bio->bi_ie_private = cc->ie_private;
>>> +	generic_make_request(bio);
>>> +}
>>> +#endif
>>> +
>>>  static void crypt_inc_pending(struct dm_crypt_io *io)
>>>  {
>>>  	atomic_inc(&io->io_pending);
>>> @@ -1960,6 +1980,9 @@ static int crypt_setkey(struct crypt_config *cc)
>>>  
>>>  	/* Ignore extra keys (which are used for IV etc) */
>>>  	subkey_size = crypt_subkey_size(cc);
>>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
>>> +	cc->key_cfg_idx = -1;
>>> +#endif
>>>  
>>>  	if (crypt_integrity_hmac(cc)) {
>>>  		if (subkey_size < cc->key_mac_size)
>>> @@ -1978,10 +2001,19 @@ static int crypt_setkey(struct crypt_config *cc)
>>>  			r = crypto_aead_setkey(cc->cipher_tfm.tfms_aead[i],
>>>  					       cc->key + (i * subkey_size),
>>>  					       subkey_size);
>>> -		else
>>> +		else {
>>>  			r = crypto_skcipher_setkey(cc->cipher_tfm.tfms[i],
>>>  						   cc->key + (i * subkey_size),
>>>  						   subkey_size);
>>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
>>> +			if (r > 0) {
>>> +				cc->key_cfg_idx = r;
>>> +				cc->ie_private = cc->cipher_tfm.tfms[i];
>>> +				r = 0;
>>> +			}
>>> +#endif
>>> +		}
>>> +
>>>  		if (r)
>>>  			err = r;
>>>  	}
>>> @@ -2654,6 +2686,10 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
>>>  			cc->sector_shift = __ffs(cc->sector_size) - SECTOR_SHIFT;
>>>  		} else if (!strcasecmp(opt_string, "iv_large_sectors"))
>>>  			set_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
>>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
>>> +		else if (!strcasecmp(opt_string, "perform_inline_encrypt"))
>>> +			set_bit(DM_CRYPT_INLINE_ENCRYPT, &cc->flags);
>>> +#endif
>>>  		else {
>>>  			ti->error = "Invalid feature arguments";
>>>  			return -EINVAL;
>>> @@ -2892,6 +2928,13 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>>>  	if (unlikely(bio->bi_iter.bi_size & (cc->sector_size - 1)))
>>>  		return DM_MAPIO_KILL;
>>>  
>>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
>>> +	if (cc->key_cfg_idx > 0) {
>>> +		crypt_inline_encrypt_submit(cc, ti, bio);
>>> +		return DM_MAPIO_SUBMITTED;
>>> +	}
>>> +#endif
>>> +
>>>  	io = dm_per_bio_data(bio, cc->per_bio_data_size);
>>>  	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
>>>  
>>> @@ -2954,6 +2997,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>>>  		num_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
>>>  		num_feature_args += cc->sector_size != (1 << SECTOR_SHIFT);
>>>  		num_feature_args += test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
>>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
>>> +		num_feature_args +=
>>> +			test_bit(DM_CRYPT_INLINE_ENCRYPT, &cc->flags);
>>> +#endif
>>>  		if (cc->on_disk_tag_size)
>>>  			num_feature_args++;
>>>  		if (num_feature_args) {
>>> @@ -2970,6 +3017,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>>>  				DMEMIT(" sector_size:%d", cc->sector_size);
>>>  			if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
>>>  				DMEMIT(" iv_large_sectors");
>>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION
>>> +			if (test_bit(DM_CRYPT_INLINE_ENCRYPT, &cc->flags))
>>> +				DMEMIT(" perform_inline_encrypt");
>>> +#endif
>>>  		}
>>>  
>>>  		break;
>>>
>>
> 
> Best Regards,
> 
> Ladvine
> 
