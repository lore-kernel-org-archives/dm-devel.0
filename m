Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E398C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 17 Jan 2022 08:30:12 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-7nypfkWANdewucxyrn2BVA-1; Mon, 17 Jan 2022 03:30:08 -0500
X-MC-Unique: 7nypfkWANdewucxyrn2BVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEDE5102C889;
	Mon, 17 Jan 2022 08:30:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9792255F75;
	Mon, 17 Jan 2022 08:30:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F33654BB7C;
	Mon, 17 Jan 2022 08:30:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20E8Flt9030756 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 14 Jan 2022 03:15:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 86C5040CFD37; Fri, 14 Jan 2022 08:15:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 813ED40CFD05
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 08:15:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63B451044561
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 08:15:47 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-321-Fs07YaA7PVm9Nj1yD8tUag-1; Fri, 14 Jan 2022 03:15:45 -0500
X-MC-Unique: Fs07YaA7PVm9Nj1yD8tUag-1
X-IronPort-AV: E=Sophos;i="5.88,287,1635177600"; d="scan'208";a="294511778"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 14 Jan 2022 16:14:36 +0800
IronPort-SDR: 3jAiZiY0McIfS1Znh7PqYcc6XHlp20l3tcsvEYOeASESQ4YeZ36WljssoubqNRGeV4My6hRgdy
	gbKktv6msBrhpgRoMDWT4x8t8SPeSjrgczWYhtOmA/qhcG0rqEPH+CtNyGs6usGkqlVrhY54vL
	znXlB0cblD80GkvdR3QHPluF6FkMrc+zdEqPTp5qfaUmlKsj7zd43qxviipVmaUPXWqSoztkYh
	xNKiM0lUE6lgMw7B1oT3gj9ip/nRAkla4Mp0mv3PnreeDSESGOrmTe6+MGC36/+uSVSMEESwkZ
	C90H3wg8AOeuNiEKNu4Fanjv
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	13 Jan 2022 23:48:14 -0800
IronPort-SDR: qn/JCr/6kOVJ7hkCNMaOSmv15I1EtdNf5q7yQ8toYdjVxmy7qz7eK+a8raT337VVHvFoAwugW1
	G74UnaOY5pWU5Pb4ENwtW9awZMX7B+cJvrhL+fiT9AKmiaB8UuqVqTLxCETa246zKWiBPZIcK7
	nrUbGI4EJo5TOOMDrKzmHoBy9AjDs5lPUuBWmBjM9aCPG/ge/CijPKAeTrSmUWb/K1sKLVUZM0
	fH30HaiLj5VWSyi9LqW+nfg51rgN9N02CGXiawWw50iRtol0U52uHIvdKi0ux6VzHBuL/OMu+l
	rdo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	14 Jan 2022 00:14:36 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JZvGh093wz1SVp0
	for <dm-devel@redhat.com>; Fri, 14 Jan 2022 00:14:36 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id sMXL0gKcLLhk for <dm-devel@redhat.com>;
	Fri, 14 Jan 2022 00:14:34 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JZvGf08cNz1Rwrw;
	Fri, 14 Jan 2022 00:14:33 -0800 (PST)
Message-ID: <b45d3b40-2587-04dc-9601-a9251dacf806@opensource.wdc.com>
Date: Fri, 14 Jan 2022 17:14:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
	Gecko/20100101 Thunderbird/91.5.0
To: Israel Rukshin <israelr@nvidia.com>, dm-devel <dm-devel@redhat.com>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<1642097341-6521-2-git-send-email-israelr@nvidia.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <1642097341-6521-2-git-send-email-israelr@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 17 Jan 2022 03:30:01 -0500
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, Eric Biggers <ebiggers@kernel.org>,
	Nitzan Carmi <nitzanc@nvidia.com>
Subject: Re: [dm-devel] [PATCH 1/1] dm crypt: Add inline encryption support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/01/14 4:11, Israel Rukshin wrote:
> Using inline encryption means that the block layer handles the
> decryption/encryption as part of the bio, instead of dm-crypt
> doing the crypto by itself via Linux's crypto API. This model
> is needed to take advantage of the inline encryption hardware
> on the market.
> 
> To use inline encryption, the new dm-crypt optional parameter
> "inline_crypt" should be set for the configured mapping. Afterwards,
> dm-crypt will provide the crypto parameters to the block layer by
> creating a cypto profile and by filling the bios with crypto context.
> In case the block device or the fallback algorithm doesn't support
> this feature, the mapping will fail.
> 
> Signed-off-by: Israel Rukshin <israelr@nvidia.com>
> ---
>  block/blk-crypto.c    |   3 +
>  drivers/md/dm-crypt.c | 202 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 180 insertions(+), 25 deletions(-)
> 
> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> index 1c08d3b6e24a..65f13549eb5f 100644
> --- a/block/blk-crypto.c
> +++ b/block/blk-crypto.c
> @@ -102,6 +102,7 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
>  
>  	bio->bi_crypt_context = bc;
>  }
> +EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);
>  
>  void __bio_crypt_free_ctx(struct bio *bio)
>  {
> @@ -370,6 +371,7 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(blk_crypto_init_key);
>  
>  /*
>   * Check if bios with @cfg can be en/decrypted by blk-crypto (i.e. either the
> @@ -411,6 +413,7 @@ int blk_crypto_start_using_key(const struct blk_crypto_key *key,
>  	}
>  	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
>  }
> +EXPORT_SYMBOL_GPL(blk_crypto_start_using_key);
>  
>  /**
>   * blk_crypto_evict_key() - Evict a key from any inline encryption hardware

These changes could probably go into a separate prep patch.

> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index d4ae31558826..4c0e1904942b 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -39,6 +39,7 @@
>  #include <keys/user-type.h>
>  #include <keys/encrypted-type.h>
>  #include <keys/trusted-type.h>
> +#include <linux/blk-crypto.h>
>  
>  #include <linux/device-mapper.h>
>  
> @@ -134,7 +135,7 @@ struct iv_elephant_private {
>  enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
>  	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
>  	     DM_CRYPT_NO_READ_WORKQUEUE, DM_CRYPT_NO_WRITE_WORKQUEUE,
> -	     DM_CRYPT_WRITE_INLINE };
> +	     DM_CRYPT_WRITE_INLINE, DM_CRYPT_INLINE_ENCRYPTION };
>  
>  enum cipher_flags {
>  	CRYPT_MODE_INTEGRITY_AEAD,	/* Use authenticated mode for cipher */
> @@ -220,6 +221,11 @@ struct crypt_config {
>  	struct bio_set bs;
>  	struct mutex bio_alloc_lock;
>  
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +	enum blk_crypto_mode_num crypto_mode;
> +	enum blk_crypto_key_type key_type;
> +	struct blk_crypto_key *blk_key;
> +#endif
>  	u8 *authenc_key; /* space for keys in authenc() format (if used) */
>  	u8 key[];
>  };
> @@ -2383,11 +2389,103 @@ static void crypt_copy_authenckey(char *p, const void *key,
>  	memcpy(p, key, enckeylen);
>  }
>  
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +static int crypt_select_inline_crypt_mode(struct dm_target *ti, char *cipher,
> +					  char *ivmode)
> +{
> +	struct crypt_config *cc = ti->private;
> +
> +	if (strcmp(cipher, "xts(aes)") == 0) {
> +		cc->crypto_mode = BLK_ENCRYPTION_MODE_AES_256_XTS;
> +		cc->key_type = BLK_CRYPTO_KEY_TYPE_STANDARD;
> +	} else if (strcmp(cipher, "xts(paes)") == 0) {
> +		cc->crypto_mode = BLK_ENCRYPTION_MODE_AES_256_XTS;
> +		cc->key_type = BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
> +	} else {
> +		ti->error = "Invalid cipher for inline_crypt";
> +		return -EINVAL;
> +	}
> +
> +	if (ivmode == NULL || (strcmp(ivmode, "plain64") == 0)) {
> +		cc->iv_size = 8;
> +	} else {
> +		ti->error = "Invalid IV mode for inline_crypt";
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int crypt_prepare_inline_crypt_key(struct crypt_config *cc)
> +{
> +	int ret;
> +
> +	cc->blk_key = kzalloc(sizeof(*cc->blk_key), GFP_KERNEL);
> +	if (!cc->blk_key)
> +		return -ENOMEM;
> +
> +	ret = blk_crypto_init_key(cc->blk_key, cc->key, cc->key_size,
> +				  cc->key_type, cc->crypto_mode, cc->iv_size,
> +				  cc->sector_size);
> +	if (ret) {
> +		DMERR("Failed to init inline encryption key");
> +		goto bad_key;
> +	}
> +
> +	ret = blk_crypto_start_using_key(cc->blk_key,
> +					 bdev_get_queue(cc->dev->bdev));
> +	if (ret) {
> +		DMERR("Failed to use inline encryption key");
> +		goto bad_key;
> +	}
> +
> +	return 0;
> +bad_key:
> +	kfree_sensitive(cc->blk_key);
> +	cc->blk_key = NULL;
> +	return ret;
> +}
> +
> +static void crypt_destroy_inline_crypt_key(struct crypt_config *cc)
> +{
> +	if (cc->blk_key) {
> +		blk_crypto_evict_key(bdev_get_queue(cc->dev->bdev),
> +				     cc->blk_key);
> +		kfree_sensitive(cc->blk_key);
> +		cc->blk_key = NULL;
> +	}
> +}
> +
> +static void crypt_inline_encrypt_submit(struct dm_target *ti, struct bio *bio)
> +{
> +	struct crypt_config *cc = ti->private;
> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
> +
> +	bio_set_dev(bio, cc->dev->bdev);
> +	if (bio_sectors(bio)) {
> +		memset(dun, 0, BLK_CRYPTO_MAX_IV_SIZE);
> +		bio->bi_iter.bi_sector = cc->start +
> +			dm_target_offset(ti, bio->bi_iter.bi_sector);
> +		dun[0] = le64_to_cpu(bio->bi_iter.bi_sector + cc->iv_offset);
> +		bio_crypt_set_ctx(bio, cc->blk_key, dun, GFP_KERNEL);
> +	}
> +
> +	submit_bio_noacct(bio);
> +}

#else

define the above functions as empty (see below).

> +#endif
> +
>  static int crypt_setkey(struct crypt_config *cc)
>  {
>  	unsigned subkey_size;
>  	int err = 0, i, r;
>  
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
> +		crypt_destroy_inline_crypt_key(cc);
> +		return crypt_prepare_inline_crypt_key(cc);
> +	}
> +#endif

You could avoid the ifdef here using IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION)
directly in the if condition. That will make the code cleaner. That said, since
DM_CRYPT_INLINE_ENCRYPTION can only be set if CONFIG_BLK_INLINE_ENCRYPTION is
enabled, I am not sure if the ifdef buys you much in the
!CONFIG_BLK_INLINE_ENCRYPTION case.

> +
>  	/* Ignore extra keys (which are used for IV etc) */
>  	subkey_size = crypt_subkey_size(cc);
>  
> @@ -2648,6 +2746,15 @@ static int crypt_wipe_key(struct crypt_config *cc)
>  
>  	kfree_sensitive(cc->key_string);
>  	cc->key_string = NULL;
> +
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
> +		crypt_destroy_inline_crypt_key(cc);
> +		memset(&cc->key, 0, cc->key_size * sizeof(u8));
> +		return 0;
> +	}
> +#endif

same comment as above and for most of the following ifdef additions.

> +
>  	r = crypt_setkey(cc);
>  	memset(&cc->key, 0, cc->key_size * sizeof(u8));
>  
> @@ -2713,6 +2820,10 @@ static void crypt_dtr(struct dm_target *ti)
>  	if (cc->crypt_queue)
>  		destroy_workqueue(cc->crypt_queue);
>  
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +	crypt_destroy_inline_crypt_key(cc);
> +#endif

You can avoid the ifdef here if this function is defined as empty in the
!CONFIG_BLK_INLINE_ENCRYPTION case (see above the comment about #else).

> +
>  	crypt_free_tfms(cc);
>  
>  	bioset_exit(&cc->bs);
> @@ -2888,6 +2999,11 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
>  	/* The rest is crypto API spec */
>  	cipher_api = tmp;
>  
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
> +		return crypt_select_inline_crypt_mode(ti, cipher_api, *ivmode);
> +#endif
> +
>  	/* Alloc AEAD, can be used only in new format. */
>  	if (crypt_integrity_aead(cc)) {
>  		ret = crypt_ctr_auth_cipher(cc, cipher_api);
> @@ -3001,6 +3117,11 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
>  		goto bad_mem;
>  	}
>  
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
> +		return crypt_select_inline_crypt_mode(ti, cipher_api, *ivmode);
> +#endif
> +
>  	/* Allocate cipher */
>  	ret = crypt_alloc_tfms(cc, cipher_api);
>  	if (ret < 0) {
> @@ -3036,9 +3157,11 @@ static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
>  		return ret;
>  
>  	/* Initialize IV */
> -	ret = crypt_ctr_ivmode(ti, ivmode);
> -	if (ret < 0)
> -		return ret;
> +	if (!test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
> +		ret = crypt_ctr_ivmode(ti, ivmode);
> +		if (ret < 0)
> +			return ret;
> +	}
>  
>  	/* Initialize and set key */
>  	ret = crypt_set_key(cc, key);
> @@ -3111,6 +3234,10 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
>  			set_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);
>  		else if (!strcasecmp(opt_string, "no_write_workqueue"))
>  			set_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +		else if (!strcasecmp(opt_string, "inline_crypt"))
> +			set_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags);
> +#endif

May be add a warning here for the !CONFIG_BLK_INLINE_ENCRYPTION case ?

>  		else if (sscanf(opt_string, "integrity:%u:", &val) == 1) {
>  			if (val == 0 || val > MAX_TAG_SIZE) {
>  				ti->error = "Invalid integrity arguments";
> @@ -3218,10 +3345,36 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  			goto bad;
>  	}
>  
> +	ret = -EINVAL;
> +	if ((sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) ||
> +	    (tmpll & ((cc->sector_size >> SECTOR_SHIFT) - 1))) {
> +		ti->error = "Invalid iv_offset sector";
> +		goto bad;
> +	}
> +	cc->iv_offset = tmpll;
> +
> +	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
> +			    &cc->dev);
> +	if (ret) {
> +		ti->error = "Device lookup failed";
> +		goto bad;
> +	}
> +
> +	ret = -EINVAL;
> +	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 ||
> +	    tmpll != (sector_t)tmpll) {
> +		ti->error = "Invalid device sector";
> +		goto bad;
> +	}
> +	cc->start = tmpll;
> +
>  	ret = crypt_ctr_cipher(ti, argv[0], argv[1]);
>  	if (ret < 0)
>  		goto bad;
>  
> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
> +		return 0;
> +
>  	if (crypt_integrity_aead(cc)) {
>  		cc->dmreq_start = sizeof(struct aead_request);
>  		cc->dmreq_start += crypto_aead_reqsize(any_tfm_aead(cc));
> @@ -3277,27 +3430,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  
>  	mutex_init(&cc->bio_alloc_lock);
>  
> -	ret = -EINVAL;
> -	if ((sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) ||
> -	    (tmpll & ((cc->sector_size >> SECTOR_SHIFT) - 1))) {
> -		ti->error = "Invalid iv_offset sector";
> -		goto bad;
> -	}
> -	cc->iv_offset = tmpll;
> -
> -	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &cc->dev);
> -	if (ret) {
> -		ti->error = "Device lookup failed";
> -		goto bad;
> -	}
> -
> -	ret = -EINVAL;
> -	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 || tmpll != (sector_t)tmpll) {
> -		ti->error = "Invalid device sector";
> -		goto bad;
> -	}
> -	cc->start = tmpll;
> -
>  	if (bdev_is_zoned(cc->dev->bdev)) {
>  		/*
>  		 * For zoned block devices, we need to preserve the issuer write
> @@ -3419,6 +3551,13 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  	if (unlikely(bio->bi_iter.bi_size & (cc->sector_size - 1)))
>  		return DM_MAPIO_KILL;
>  
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +	if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags)) {
> +		crypt_inline_encrypt_submit(ti, bio);
> +		return DM_MAPIO_SUBMITTED;
> +	}
> +#endif
> +
>  	io = dm_per_bio_data(bio, cc->per_bio_data_size);
>  	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
>  
> @@ -3481,6 +3620,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>  		num_feature_args += test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
>  		num_feature_args += test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags);
>  		num_feature_args += test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags);
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +		num_feature_args +=
> +			test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags);
> +#endif

You do not think that you need the ifdef here. If CONFIG_BLK_INLINE_ENCRYPTION
is not enabled, then DM_CRYPT_INLINE_ENCRYPTION is never set.

>  		num_feature_args += cc->sector_size != (1 << SECTOR_SHIFT);
>  		num_feature_args += test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags);
>  		if (cc->on_disk_tag_size)
> @@ -3497,6 +3640,10 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>  				DMEMIT(" no_read_workqueue");
>  			if (test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))
>  				DMEMIT(" no_write_workqueue");
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +			if (test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags))
> +				DMEMIT(" inline_crypt");
> +#endif

ditto.

>  			if (cc->on_disk_tag_size)
>  				DMEMIT(" integrity:%u:%s", cc->on_disk_tag_size, cc->cipher_auth);
>  			if (cc->sector_size != (1 << SECTOR_SHIFT))
> @@ -3516,6 +3663,11 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
>  		       'y' : 'n');
>  		DMEMIT(",no_write_workqueue=%c", test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags) ?
>  		       'y' : 'n');
> +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> +		DMEMIT(",inline_crypt=%c",
> +		       test_bit(DM_CRYPT_INLINE_ENCRYPTION, &cc->flags) ?
> +		       'y' : 'n');
> +#endif

You do not think that you need the ifdef here. If CONFIG_BLK_INLINE_ENCRYPTION
is not enabled, then inline_crypt=n will always be reported, which is fine I think.

>  		DMEMIT(",iv_large_sectors=%c", test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags) ?
>  		       'y' : 'n');
>  


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

