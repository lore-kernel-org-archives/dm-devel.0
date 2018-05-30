From: Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>
Subject: Re: [PATCH] md: dm-crypt: Add Inline Encryption support for dmcrypt
Date: Wed, 30 May 2018 14:52:07 +0000
Message-ID: <BD7FB879CC136E419544C8E2AE7B9C3020BB94@IN01WEMBXA.internal.synopsys.com>
References: <e9120efc-1e25-79c8-6132-9062dd030539@synopsys.com>
 <7a510610-9133-39aa-6841-3925c532f3c0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>, Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Manjunath M Bettegowda <Manjunath.MB@synopsys.com>, Prabu Thangamuthu <Prabu.T@synopsys.com>, Tejas Joglekar <Tejas.Joglekar@synopsys.com>, device-mapper development <dm-devel@redhat.com>, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: dm-devel.ids

On Monday 28 May 2018 05:33 PM, Milan Broz wrote:=0A=
> On 05/28/2018 03:01 PM, Ladvine D Almeida wrote:=0A=
>> This patch adds new option=0A=
>>     -- perform_inline_encrypt=0A=
>> that set the option inside dmcrypt to use inline encryption for=0A=
>> the configured mapping. I want to introduce inline encryption support=0A=
>> in the UFS Host Controller driver. The usage of the same for accomplishi=
ng=0A=
>> the Full Disk Encryption is done by the following changes in the=0A=
>> dmcrypt subsystem:=0A=
>>     - New function crypt_inline_encrypt_submit() is added to the=0A=
>> dmcrypt which associate the crypto context to the bios which=0A=
>> are submitted by the subsystem.=0A=
>>     - Successful configuration for the inline encryption will result in=
=0A=
>> the crypto transformation job being bypassed in the dmcrypt layer and th=
e=0A=
>> actual encryption happens inline to the block device.=0A=
> I am not sure this is a good idea. Dm-crypt should never ever forward=0A=
> plaintext sector to underlying device.=0A=
>=0A=
> And you do not even check that your hw is available in the underlying dev=
ice!=0A=
>=0A=
> If you want to use dm-crypt, write a crypto API driver for your crypto hw=
 that defines=0A=
> specific cipher and let dm-crypt use this cipher (no patches needed in th=
is case!)=0A=
=0A=
Thanks for sharing your review.=0A=
I am sharing the links for the patches which are related to inline encrypti=
on below:=0A=
https://lkml.org/lkml/2018/5/28/1153=0A=
https://lkml.org/lkml/2018/5/28/1196=0A=
https://lkml.org/lkml/2018/5/28/1158=0A=
https://lkml.org/lkml/2018/5/28/1173=0A=
https://lkml.org/lkml/2018/5/28/1178=0A=
=0A=
we have crypto API implementation for the hardware for  XTS algorithm, whic=
h will get registered when=0A=
the XTS algorithm capability of the inline encryption engine inside UFS Hos=
t Controller get detected by the UFS HC=0A=
driver. dm-crypt will be using this registered cipher.=0A=
 dm-crypt patch is unavoidable because the encrypt/decrypt function cannot =
perform the transformation=0A=
when inline encryption engine is involved. Also, it demands forwarding the =
plaintext sectors to the underlying=0A=
block device driver and  the crypto transformation happens internally in co=
ntroller when data transfer happens.=0A=
=0A=
>=0A=
> If I read the patch correctly, you do not check any parameters for=0A=
> compatibility with your hw support (cipher, mode, IV algorithm, key lengt=
h, sector size ...)=0A=
=0A=
I am registering an algorithm with cipher mode, IV size, block size, suppor=
ted key size etc. for use by dm-crypt=0A=
as per the hardware capability of inline encryption engine.=0A=
If any other cipher mode, etc is used during the setup stage, DM-Crypt will=
 work as normal.=0A=
=0A=
>=0A=
> It seems like if the "perform_inline_encrypt" option is present, you just=
 submit=0A=
> the whole bio to your code with new INLINE_ENCRYPTION bit set.=0A=
=0A=
when the optional argument "perform_inline_encrypt" is set, we are not unco=
nditionally sending the bio=0A=
to the block devices. The steps are explained below:=0A=
1. user invokes the dm-setup command with the registered cipher "xts" and w=
ith the optional argument=0A=
"perform_inline_encrypt".=0A=
2. dm-setup invokes the setkey function of the newly introduced algorithm, =
which finds the available key slots=0A=
to be programmed(UFS Host controller Inline Encryption engine has multiple =
keyslots), program the key slot,=0A=
and return the key slot index as return value of the set key function.=0A=
3. When read/write operation happens, crypt_map() function in dm-crypt vali=
dates whether there is associated=0A=
key configuration index for the request. The Bio will be submitted directly=
 in this case only with the associated=0A=
crypto context.=0A=
4. Block device driver, eg. UFS host controller driver will create the Tran=
sfer requests as per this crypto context and=0A=
encryption happens inside the controller.=0A=
=0A=
>=0A=
> What happens, if the cipher in table is different from what your hw is do=
ing?=0A=
=0A=
In this case, the dm-crypt will work as previous. This is because the setke=
y returns 0.=0A=
whenever there is key configuration index associated, setkey returns index =
value(greater than 0). The bios are submitted=0A=
with that information to underlying block device drivers.=0A=
Also, care is taken to ensure that fallback will happen incase hardware lac=
ks the support of any key lengths.=0A=
=0A=
Appreciate your suggestions/feedback. We are trying to bring modifications =
into the subsystem to support controllers with=0A=
inline encryption capabilities and tried our best to take care of any vulne=
rabilities or risks associated to same.=0A=
Inline encryption engines got huge advantage over the accelerators/software=
 algorithms that it removes overhead associated=0A=
to current implementation like performing transformation on 512 byte chunks=
, allocation of scatterlists etc.=0A=
=0A=
>=0A=
> Milan=0A=
>=0A=
>> Another patch set is sent to the block layer community for=0A=
>> CONFIG_BLK_DEV_INLINE_ENCRYPTION config, which enables changes in the=0A=
>> block layer for adding the bi_ie_private variable to the bio structure.=
=0A=
>>=0A=
>> Signed-off-by: Ladvine D Almeida <ladvine@synopsys.com>=0A=
>> ---=0A=
>>  drivers/md/dm-crypt.c | 55 ++++++++++++++++++++++++++++++++++++++++++++=
+++++--=0A=
>>  1 file changed, 53 insertions(+), 2 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c=0A=
>> index 44ff473..a9ed567 100644=0A=
>> --- a/drivers/md/dm-crypt.c=0A=
>> +++ b/drivers/md/dm-crypt.c=0A=
>> @@ -39,6 +39,7 @@=0A=
>>  #include <linux/device-mapper.h>=0A=
>>  =0A=
>>  #define DM_MSG_PREFIX "crypt"=0A=
>> +#define REQ_INLINE_ENCRYPTION REQ_DRV=0A=
>>  =0A=
>>  /*=0A=
>>   * context holding the current state of a multi-part conversion=0A=
>> @@ -125,7 +126,8 @@ struct iv_tcw_private {=0A=
>>   * and encrypts / decrypts at the same time.=0A=
>>   */=0A=
>>  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,=0A=
>> -	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };=0A=
>> +	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,=0A=
>> +		 DM_CRYPT_INLINE_ENCRYPT };=0A=
>>  =0A=
>>  enum cipher_flags {=0A=
>>  	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cihper */=0A=
>> @@ -215,6 +217,10 @@ struct crypt_config {=0A=
>>  =0A=
>>  	u8 *authenc_key; /* space for keys in authenc() format (if used) */=0A=
>>  	u8 key[0];=0A=
>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION=0A=
>> +	void *ie_private; /* crypto context for inline enc drivers */=0A=
>> +	int key_cfg_idx;  /* key configuration index for inline enc */=0A=
>> +#endif=0A=
>>  };=0A=
>>  =0A=
>>  #define MIN_IOS		64=0A=
>> @@ -1470,6 +1476,20 @@ static void crypt_io_init(struct dm_crypt_io *io,=
 struct crypt_config *cc,=0A=
>>  	atomic_set(&io->io_pending, 0);=0A=
>>  }=0A=
>>  =0A=
>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION=0A=
>> +static void crypt_inline_encrypt_submit(struct crypt_config *cc,=0A=
>> +	struct dm_target *ti, struct bio *bio)=0A=
>> +{=0A=
>> +	bio_set_dev(bio, cc->dev->bdev);=0A=
>> +	if (bio_sectors(bio))=0A=
>> +		bio->bi_iter.bi_sector =3D cc->start +=0A=
>> +			dm_target_offset(ti, bio->bi_iter.bi_sector);=0A=
>> +	bio->bi_opf |=3D REQ_INLINE_ENCRYPTION;=0A=
>> +	bio->bi_ie_private =3D cc->ie_private;=0A=
>> +	generic_make_request(bio);=0A=
>> +}=0A=
>> +#endif=0A=
>> +=0A=
>>  static void crypt_inc_pending(struct dm_crypt_io *io)=0A=
>>  {=0A=
>>  	atomic_inc(&io->io_pending);=0A=
>> @@ -1960,6 +1980,9 @@ static int crypt_setkey(struct crypt_config *cc)=
=0A=
>>  =0A=
>>  	/* Ignore extra keys (which are used for IV etc) */=0A=
>>  	subkey_size =3D crypt_subkey_size(cc);=0A=
>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION=0A=
>> +	cc->key_cfg_idx =3D -1;=0A=
>> +#endif=0A=
>>  =0A=
>>  	if (crypt_integrity_hmac(cc)) {=0A=
>>  		if (subkey_size < cc->key_mac_size)=0A=
>> @@ -1978,10 +2001,19 @@ static int crypt_setkey(struct crypt_config *cc)=
=0A=
>>  			r =3D crypto_aead_setkey(cc->cipher_tfm.tfms_aead[i],=0A=
>>  					       cc->key + (i * subkey_size),=0A=
>>  					       subkey_size);=0A=
>> -		else=0A=
>> +		else {=0A=
>>  			r =3D crypto_skcipher_setkey(cc->cipher_tfm.tfms[i],=0A=
>>  						   cc->key + (i * subkey_size),=0A=
>>  						   subkey_size);=0A=
>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION=0A=
>> +			if (r > 0) {=0A=
>> +				cc->key_cfg_idx =3D r;=0A=
>> +				cc->ie_private =3D cc->cipher_tfm.tfms[i];=0A=
>> +				r =3D 0;=0A=
>> +			}=0A=
>> +#endif=0A=
>> +		}=0A=
>> +=0A=
>>  		if (r)=0A=
>>  			err =3D r;=0A=
>>  	}=0A=
>> @@ -2654,6 +2686,10 @@ static int crypt_ctr_optional(struct dm_target *t=
i, unsigned int argc, char **ar=0A=
>>  			cc->sector_shift =3D __ffs(cc->sector_size) - SECTOR_SHIFT;=0A=
>>  		} else if (!strcasecmp(opt_string, "iv_large_sectors"))=0A=
>>  			set_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);=0A=
>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION=0A=
>> +		else if (!strcasecmp(opt_string, "perform_inline_encrypt"))=0A=
>> +			set_bit(DM_CRYPT_INLINE_ENCRYPT, &cc->flags);=0A=
>> +#endif=0A=
>>  		else {=0A=
>>  			ti->error =3D "Invalid feature arguments";=0A=
>>  			return -EINVAL;=0A=
>> @@ -2892,6 +2928,13 @@ static int crypt_map(struct dm_target *ti, struct=
 bio *bio)=0A=
>>  	if (unlikely(bio->bi_iter.bi_size & (cc->sector_size - 1)))=0A=
>>  		return DM_MAPIO_KILL;=0A=
>>  =0A=
>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION=0A=
>> +	if (cc->key_cfg_idx > 0) {=0A=
>> +		crypt_inline_encrypt_submit(cc, ti, bio);=0A=
>> +		return DM_MAPIO_SUBMITTED;=0A=
>> +	}=0A=
>> +#endif=0A=
>> +=0A=
>>  	io =3D dm_per_bio_data(bio, cc->per_bio_data_size);=0A=
>>  	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector=
));=0A=
>>  =0A=
>> @@ -2954,6 +2997,10 @@ static void crypt_status(struct dm_target *ti, st=
atus_type_t type,=0A=
>>  		num_feature_args +=3D test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);=0A=
>>  		num_feature_args +=3D cc->sector_size !=3D (1 << SECTOR_SHIFT);=0A=
>>  		num_feature_args +=3D test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_fl=
ags);=0A=
>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION=0A=
>> +		num_feature_args +=3D=0A=
>> +			test_bit(DM_CRYPT_INLINE_ENCRYPT, &cc->flags);=0A=
>> +#endif=0A=
>>  		if (cc->on_disk_tag_size)=0A=
>>  			num_feature_args++;=0A=
>>  		if (num_feature_args) {=0A=
>> @@ -2970,6 +3017,10 @@ static void crypt_status(struct dm_target *ti, st=
atus_type_t type,=0A=
>>  				DMEMIT(" sector_size:%d", cc->sector_size);=0A=
>>  			if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))=0A=
>>  				DMEMIT(" iv_large_sectors");=0A=
>> +#ifdef CONFIG_BLK_DEV_INLINE_ENCRYPTION=0A=
>> +			if (test_bit(DM_CRYPT_INLINE_ENCRYPT, &cc->flags))=0A=
>> +				DMEMIT(" perform_inline_encrypt");=0A=
>> +#endif=0A=
>>  		}=0A=
>>  =0A=
>>  		break;=0A=
>>=0A=
>=0A=
=0A=
Best Regards,=0A=
=0A=
Ladvine=0A=
=0A=
