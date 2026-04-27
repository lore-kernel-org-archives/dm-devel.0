Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4A075809
	for <dm-devel@lists.linux.dev>; Mon, 27 Apr 2026 01:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777252814; cv=none; b=l+Gyeq7n9SSoPDe8F0gFqDBbTXof+OAaYPqcbADFG83i4q9IRzQcK7Xu+gHMU+jYFO43FSPxY75fjjeHkMRqJe/VR4mwhSL5PT3B1ysPQhPLuQTymW+7pCSf99Xi1uXVsWMY/8ZoQ83CJBSsgz0AXyk10dxLUEvRi6WZbAFaf2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777252814; c=relaxed/simple;
	bh=LI7uT83oVIjEttnTO5pYJFjfyZW+xnqUdbpC/5yWaAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=oX0v2UUFgOXIe7pKOsVWEnQB4v82mJ6fBSi+M+6EHdBBEzQ6CZT9SKPLZKLNhPKuGhBgvSHnxLCBRz+slqh93NnBpXmZ5lNJk+qW8/8M2VetJ/MJZpnbRG7CuwkJQsHW7ss2p1anRn8+GTIG9t7MhWrsSKLwAV+t+8TMSClCbrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XePkt7EO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XePkt7EO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777252811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c89fDvjWNfw+ww/16N/6uvv8iE3NGx//SCDtEVNSMH4=;
	b=XePkt7EOPQtotPMGy2UCT3/BalMYeLGe2/QI7Wtk123feM2bQecmPj4hbpnENlUb/nfHrW
	cW4/4M5R5RWqICJxUcgXrANyK0L/SfRQR1FB1YVI75dWeqJOl0iC0Egx9ljODh8nHE16Yx
	iQ8l1VYUH8Ql1Chj8AKmF/T6mVchCHw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-333-VLTG3YUeOc-qjrPgTYJ_RA-1; Sun,
 26 Apr 2026 21:20:05 -0400
X-MC-Unique: VLTG3YUeOc-qjrPgTYJ_RA-1
X-Mimecast-MFC-AGG-ID: VLTG3YUeOc-qjrPgTYJ_RA_1777252804
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A20418003FC;
	Mon, 27 Apr 2026 01:20:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8945180045E;
	Mon, 27 Apr 2026 01:20:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63R1K0ZH2704641
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 26 Apr 2026 21:20:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63R1Jwsk2704640;
	Sun, 26 Apr 2026 21:19:58 -0400
Date: Sun, 26 Apr 2026 21:19:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, linux-kernel@vger.kernel.org,
        adrianvovk@gmail.com, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, israelr@nvidia.com, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v2 2/3] dm-inlinecrypt: add target for inline block
 device encryption
Message-ID: <ae65vfakVKg2aGcp@redhat.com>
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
 <20260410134031.2880675-3-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260410134031.2880675-3-linlin.zhang@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 67_jHAuL_uRkcbyWN-nDsocmwNgttCLoXxUvYCwgnnQ_1777252804
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 10, 2026 at 06:40:30AM -0700, Linlin Zhang wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a new device-mapper target "dm-inlinecrypt" that is similar to
> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
> This allows it to take advantage of inline encryption hardware such as
> that commonly built into UFS host controllers.
> 
> The table syntax matches dm-crypt's, but for now only a stripped-down
> set of parameters is supported.  For example, for now AES-256-XTS is the
> only supported cipher.
> 
> dm-inlinecrypt is based on Android's dm-default-key with the
> controversial passthrough support removed.  Note that due to the removal
> of passthrough support, use of dm-inlinecrypt in combination with
> fscrypt causes double encryption of file contents (similar to dm-crypt +
> fscrypt), with the fscrypt layer not being able to use the inline
> encryption hardware.  This makes dm-inlinecrypt unusable on systems such
> as Android that use fscrypt and where a more optimized approach is
> needed.  It is however suitable as a replacement for dm-crypt.
> 
> dm-inlinecrypt supports both keyring key and hex key, the former avoids
> the key to be exposed in dm-table message. Similar to dm-default-key in
> Android, it will fallabck to the software block crypto once the inline
> crypto hardware cannot support the expected cipher.
> 
> Test:
> dmsetup create inlinecrypt_logon --table "0 `blockdev --getsz $1` \
> inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 $1 0"
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> ---
>  drivers/md/Kconfig          |  10 +
>  drivers/md/Makefile         |   1 +
>  drivers/md/dm-inlinecrypt.c | 559 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 570 insertions(+)
>  create mode 100644 drivers/md/dm-inlinecrypt.c
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index c58a9a8ea54e..aa541cc22ecc 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -313,6 +313,16 @@ config DM_CRYPT
>  
>  	  If unsure, say N.
>  
> +config DM_INLINECRYPT
> +	tristate "Inline encryption target support"
> +	depends on BLK_DEV_DM
> +	depends on BLK_INLINE_ENCRYPTION
> +	help
> +	  This device-mapper target is similar to dm-crypt, but it uses the
> +	  blk-crypto API instead of the regular crypto API. This allows it to
> +	  take advantage of inline encryption hardware such as that commonly
> +	  built into UFS host controllers.
> +
>  config DM_SNAPSHOT
>         tristate "Snapshot target"
>         depends on BLK_DEV_DM
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index c338cc6fbe2e..517d1f7d8288 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -55,6 +55,7 @@ obj-$(CONFIG_DM_UNSTRIPED)	+= dm-unstripe.o
>  obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
>  obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
>  obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
> +obj-$(CONFIG_DM_INLINECRYPT)	+= dm-inlinecrypt.o
>  obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
>  obj-$(CONFIG_DM_DUST)		+= dm-dust.o
>  obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
> diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
> new file mode 100644
> index 000000000000..b6e98fdf8af1
> --- /dev/null
> +++ b/drivers/md/dm-inlinecrypt.c
> @@ -0,0 +1,559 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2024 Google LLC
> + */
> +
> +#include <linux/blk-crypto.h>
> +#include <linux/ctype.h>
> +#include <linux/device-mapper.h>
> +#include <linux/hex.h>
> +#include <linux/module.h>
> +#include <keys/user-type.h>
> +
> +#define DM_MSG_PREFIX	"inlinecrypt"
> +
> +static const struct dm_inlinecrypt_cipher {
> +	const char *name;
> +	enum blk_crypto_mode_num mode_num;
> +} dm_inlinecrypt_ciphers[] = {
> +	{
> +		.name = "aes-xts-plain64",
> +		.mode_num = BLK_ENCRYPTION_MODE_AES_256_XTS,
> +	},
> +};
> +
> +/**
> + * struct inlinecrypt_ctx - private data of an inlinecrypt target
> + * @dev: the underlying device
> + * @start: starting sector of the range of @dev which this target actually maps.
> + *	   For this purpose a "sector" is 512 bytes.
> + * @cipher_string: the name of the encryption algorithm being used
> + * @iv_offset: starting offset for IVs.  IVs are generated as if the target were
> + *	       preceded by @iv_offset 512-byte sectors.
> + * @sector_size: crypto sector size in bytes (usually 4096)
> + * @sector_bits: log2(sector_size)
> + * @key: the encryption key to use
> + * @max_dun: the maximum DUN that may be used (computed from other params)
> + */
> +struct inlinecrypt_ctx {
> +	struct dm_dev *dev;
> +	sector_t start;
> +	const char *cipher_string;
> +	unsigned int key_size;
> +	u64 iv_offset;
> +	unsigned int sector_size;
> +	unsigned int sector_bits;
> +	struct blk_crypto_key key;
> +	u64 max_dun;
> +};
> +
> +static const struct dm_inlinecrypt_cipher *
> +lookup_cipher(const char *cipher_string)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dm_inlinecrypt_ciphers); i++) {
> +		if (strcmp(cipher_string, dm_inlinecrypt_ciphers[i].name) == 0)
> +			return &dm_inlinecrypt_ciphers[i];
> +	}
> +	return NULL;
> +}
> +
> +static void inlinecrypt_dtr(struct dm_target *ti)
> +{
> +	struct inlinecrypt_ctx *ctx = ti->private;
> +
> +	if (ctx->dev) {
> +		if (ctx->key.size)
> +			blk_crypto_evict_key(ctx->dev->bdev, &ctx->key);
> +		dm_put_device(ti, ctx->dev);
> +	}
> +	kfree_sensitive(ctx->cipher_string);
> +	kfree_sensitive(ctx);
> +}
> +
> +static bool contains_whitespace(const char *str)
> +{
> +	while (*str)
> +		if (isspace(*str++))
> +			return true;
> +	return false;
> +}
> +
> +static int set_key_user(struct key *key, char *bin_key,
> +			const unsigned int bin_key_size)
> +{
> +	const struct user_key_payload *ukp;
> +
> +	ukp = user_key_payload_locked(key);
> +	if (!ukp)
> +		return -EKEYREVOKED;
> +
> +	if (bin_key_size != ukp->datalen)
> +		return -EINVAL;
> +
> +	memcpy(bin_key, ukp->data, bin_key_size);
> +
> +	return 0;
> +}
> +
> +static int inlinecrypt_get_keyring_key(const char *key_string, u8 *bin_key,
> +					const unsigned int bin_key_size)
> +{
> +	char *key_desc;
> +	int ret;
> +	struct key_type *type;
> +	struct key *key;

There's nothing forcing CONFIG_KEYS to be set when CONFIG_DM_INLINECRYPT
is, and without it, struct key won't be defined and this won't compile.

> +	int (*set_key)(struct key *key, char *bin_key,
> +				   const unsigned int bin_key_size);
> +
> +	/*
> +	 * Reject key_string with whitespace. dm core currently lacks code for
> +	 * proper whitespace escaping in arguments on DM_TABLE_STATUS path.
> +	 */
> +	if (contains_whitespace(key_string)) {
> +		DMERR("whitespace chars not allowed in key string");
> +		return -EINVAL;
> +	}
> +
> +	/* look for next ':' separating key_type from key_description */
> +	key_desc = strchr(key_string, ':');
> +	if (!key_desc || key_desc == key_string || !strlen(key_desc + 1))
> +		return -EINVAL;
> +
> +	if (!strncmp(key_string, "logon:", key_desc - key_string + 1)) {
> +		type = &key_type_logon;
> +		set_key = set_key_user;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	key = request_key(type, key_desc + 1, NULL);
> +	if (IS_ERR(key))
> +		return PTR_ERR(key);
> +
> +	down_read(&key->sem);
> +
> +	ret = set_key(key, (char *)bin_key, bin_key_size);
> +	if (ret < 0) {

This does the same commands regardless of whether it takes this branch.

> +		up_read(&key->sem);
> +		key_put(key);
> +		return ret;
> +	}
> +
> +	up_read(&key->sem);
> +	key_put(key);
> +
> +	return ret;
> +}
> +
> +static int inlinecrypt_get_key(const char *key_string,
> +				u8 key[BLK_CRYPTO_MAX_ANY_KEY_SIZE],
> +				const unsigned int key_size)
> +{
> +	int ret = 0;
> +
> +	/* ':' means the key is in kernel keyring, short-circuit normal key processing */
> +	if (key_string[0] == ':') {
> +		if (key_size > BLK_CRYPTO_MAX_ANY_KEY_SIZE) {
> +			DMERR("Invalid keysize");
> +			return -EINVAL;
> +		}
> +		/* key string should be :<logon|user>:<key_desc> */
> +		ret = inlinecrypt_get_keyring_key(key_string + 1, key, key_size);
> +		goto out;
> +	}
> +
> +	if (key_size > 2 * BLK_CRYPTO_MAX_ANY_KEY_SIZE

get_key_size() returns the size of the binary key in this case, so
shouldn't this check for "key_size > BLK_CRYPTO_MAX_ANY_KEY_SIZE", and
it seems like the check if the key_size is odd would make more sense in
get_key_size().

> +		|| key_size  % 2
> +		|| !key_size) {
> +		DMERR("Invalid keysize");
> +		return -EINVAL;
> +	}
> +	if (hex2bin(key, key_string, key_size) != 0)
> +		ret = -EINVAL;
> +
> +out:
> +	return ret;
> +}
> +
> +static int get_key_size(char **key_string)
> +{
> +	char *colon, dummy;
> +	int ret;
> +
> +	if (*key_string[0] != ':')
> +		return strlen(*key_string) >> 1;
> +
> +	/* look for next ':' in key string */
> +	colon = strpbrk(*key_string + 1, ":");
> +	if (!colon)
> +		return -EINVAL;
> +
> +	if (sscanf(*key_string + 1, "%u%c", &ret, &dummy) != 2 || dummy != ':')
> +		return -EINVAL;
> +
> +	/* remaining key string should be :<logon|user>:<key_desc> */
> +	*key_string = colon;
> +
> +	return ret;
> +}
> +
> +static int inlinecrypt_ctr_optional(struct dm_target *ti,
> +				    unsigned int argc, char **argv)
> +{
> +	struct inlinecrypt_ctx *ctx = ti->private;
> +	struct dm_arg_set as;
> +	static const struct dm_arg _args[] = {
> +		{0, 3, "Invalid number of feature args"},
> +	};
> +	unsigned int opt_params;
> +	const char *opt_string;
> +	bool iv_large_sectors = false;
> +	char dummy;
> +	int err;
> +
> +	as.argc = argc;
> +	as.argv = argv;
> +
> +	err = dm_read_arg_group(_args, &as, &opt_params, &ti->error);
> +	if (err)
> +		return err;
> +
> +	while (opt_params--) {
> +		opt_string = dm_shift_arg(&as);
> +		if (!opt_string) {
> +			ti->error = "Not enough feature arguments";
> +			return -EINVAL;
> +		}
> +		if (!strcmp(opt_string, "allow_discards")) {
> +			ti->num_discard_bios = 1;
> +		} else if (sscanf(opt_string, "sector_size:%u%c",
> +				  &ctx->sector_size, &dummy) == 1) {
> +			if (ctx->sector_size < SECTOR_SIZE ||
> +			    ctx->sector_size > 4096 ||
> +			    !is_power_of_2(ctx->sector_size)) {
> +				ti->error = "Invalid sector_size";
> +				return -EINVAL;
> +			}
> +		} else if (!strcmp(opt_string, "iv_large_sectors")) {
> +			iv_large_sectors = true;
> +		} else {
> +			ti->error = "Invalid feature arguments";
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* dm-inlinecrypt doesn't implement iv_large_sectors=false. */
> +	if (ctx->sector_size != SECTOR_SIZE && !iv_large_sectors) {
> +		ti->error = "iv_large_sectors must be specified";

Since setting sector_size forces setting iv_large_sectors, does it
really need to be a separate parameter? Can't it just be implied by
setting a non-512 sector_size. Is this here to futureproof the table
line?

> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Construct an inlinecrypt mapping:
> + * <cipher> [<key>|:<key_size>:<logon>:<key_description>] <iv_offset> <dev_path> <start>
> + *
> + * This syntax matches dm-crypt's, but the set of supported functionality has
> + * been stripped down.
> + */
> +static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> +{
> +	struct inlinecrypt_ctx *ctx;
> +	const struct dm_inlinecrypt_cipher *cipher;
> +	u8 raw_key[BLK_CRYPTO_MAX_ANY_KEY_SIZE];
> +	unsigned int dun_bytes;
> +	unsigned long long tmpll;
> +	char dummy;
> +	int err;
> +
> +	if (argc < 5) {
> +		ti->error = "Not enough arguments";
> +		return -EINVAL;
> +	}
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		ti->error = "Out of memory";
> +		return -ENOMEM;
> +	}
> +	ti->private = ctx;
> +
> +	/* <cipher> */
> +	ctx->cipher_string = kstrdup(argv[0], GFP_KERNEL);
> +	if (!ctx->cipher_string) {
> +		ti->error = "Out of memory";
> +		err = -ENOMEM;
> +		goto bad;
> +	}
> +	cipher = lookup_cipher(ctx->cipher_string);
> +	if (!cipher) {
> +		ti->error = "Unsupported cipher";
> +		err = -EINVAL;
> +		goto bad;
> +	}
> +
> +	/* <key> */
> +	ctx->key_size = get_key_size(&argv[1]);
> +	if (ctx->key_size < 0) {
> +		ti->error = "Cannot parse key size";
> +		return -EINVAL;
> +	}
> +	err = inlinecrypt_get_key(argv[1], raw_key, ctx->key_size);
> +	if (err) {
> +		ti->error = "Malformed key string";
> +		goto bad;
> +	}
> +
> +	/* <iv_offset> */
> +	if (sscanf(argv[2], "%llu%c", &ctx->iv_offset, &dummy) != 1) {
> +		ti->error = "Invalid iv_offset sector";
> +		err = -EINVAL;
> +		goto bad;
> +	}
> +
> +	/* <dev_path> */
> +	err = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
> +			    &ctx->dev);
> +	if (err) {
> +		ti->error = "Device lookup failed";
> +		goto bad;
> +	}
> +
> +	/* <start> */
> +	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 ||
> +	    tmpll != (sector_t)tmpll) {
> +		ti->error = "Invalid start sector";
> +		err = -EINVAL;
> +		goto bad;
> +	}
> +	ctx->start = tmpll;
> +
> +	/* optional arguments */
> +	ctx->sector_size = SECTOR_SIZE;
> +	if (argc > 5) {
> +		err = inlinecrypt_ctr_optional(ti, argc - 5, &argv[5]);
> +		if (err)
> +			goto bad;
> +	}
> +	ctx->sector_bits = ilog2(ctx->sector_size);
> +	if (ti->len & ((ctx->sector_size >> SECTOR_SHIFT) - 1)) {
> +		ti->error = "Device size is not a multiple of sector_size";
> +		err = -EINVAL;
> +		goto bad;
> +	}
> +
> +	ctx->max_dun = (ctx->iv_offset + ti->len - 1) >>
> +		       (ctx->sector_bits - SECTOR_SHIFT);
> +	dun_bytes = DIV_ROUND_UP(fls64(ctx->max_dun), 8);
> +
> +	err = blk_crypto_init_key(&ctx->key, raw_key, ctx->key_size,
> +				  BLK_CRYPTO_KEY_TYPE_RAW,
> +				  cipher->mode_num, dun_bytes,
> +				  ctx->sector_size);
> +	if (err) {
> +		ti->error = "Error initializing blk-crypto key";
> +		goto bad;
> +	}
> +
> +	err = blk_crypto_start_using_key(ctx->dev->bdev, &ctx->key);
> +	if (err) {
> +		ti->error = "Error starting to use blk-crypto";
> +		goto bad;
> +	}
> +
> +	ti->num_flush_bios = 1;
> +
> +	err = 0;
> +	goto out;
> +
> +bad:
> +	inlinecrypt_dtr(ti);
> +out:
> +	memzero_explicit(raw_key, sizeof(raw_key));
> +	return err;
> +}
> +
> +static int inlinecrypt_map(struct dm_target *ti, struct bio *bio)
> +{
> +	const struct inlinecrypt_ctx *ctx = ti->private;
> +	sector_t sector_in_target;
> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = {};
> +
> +	bio_set_dev(bio, ctx->dev->bdev);
> +
> +	/*
> +	 * If the bio is a device-level request which doesn't target a specific
> +	 * sector, there's nothing more to do.
> +	 */
> +	if (bio_sectors(bio) == 0)
> +		return DM_MAPIO_REMAPPED;
> +
> +	/*
> +	 * The bio should never have an encryption context already, since
> +	 * dm-inlinecrypt doesn't pass through any inline encryption
> +	 * capabilities to the layer above it.
> +	 */
> +	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
> +		return DM_MAPIO_KILL;
> +
> +	/* Map the bio's sector to the underlying device. (512-byte sectors) */
> +	sector_in_target = dm_target_offset(ti, bio->bi_iter.bi_sector);
> +	bio->bi_iter.bi_sector = ctx->start + sector_in_target;
> +	/*
> +	 * If the bio doesn't have any data (e.g. if it's a DISCARD request),
> +	 * there's nothing more to do.
> +	 */
> +	if (!bio_has_data(bio))
> +		return DM_MAPIO_REMAPPED;
> +
> +	/* Calculate the DUN and enforce data-unit (crypto sector) alignment. */
> +	dun[0] = ctx->iv_offset + sector_in_target; /* 512-byte sectors */
> +	if (dun[0] & ((ctx->sector_size >> SECTOR_SHIFT) - 1))
> +		return DM_MAPIO_KILL;

If ctx->iv_offset is not a multiple of ctx->sector_size, this will
always fail. ctx->iv_offset should probably get validated in
inlinecrypt_ctr()

-Ben

> +	dun[0] >>= ctx->sector_bits - SECTOR_SHIFT; /* crypto sectors */
> +
> +	/*
> +	 * This check isn't necessary as we should have calculated max_dun
> +	 * correctly, but be safe.
> +	 */
> +	if (WARN_ON_ONCE(dun[0] > ctx->max_dun))
> +		return DM_MAPIO_KILL;
> +
> +	bio_crypt_set_ctx(bio, &ctx->key, dun, GFP_NOIO);
> +
> +	/*
> +	 * Since we've added an encryption context to the bio and
> +	 * blk-crypto-fallback may be needed to process it, it's necessary to
> +	 * use the fallback-aware bio submission code rather than
> +	 * unconditionally returning DM_MAPIO_REMAPPED.
> +	 *
> +	 * To get the correct accounting for a dm target in the case where
> +	 * __blk_crypto_submit_bio() doesn't take ownership of the bio (returns
> +	 * true), call __blk_crypto_submit_bio() directly and return
> +	 * DM_MAPIO_REMAPPED in that case, rather than relying on
> +	 * blk_crypto_submit_bio() which calls submit_bio() in that case.
> +	 */
> +	if (__blk_crypto_submit_bio(bio))
> +		return DM_MAPIO_REMAPPED;
> +	return DM_MAPIO_SUBMITTED;
> +}
> +
> +static void inlinecrypt_status(struct dm_target *ti, status_type_t type,
> +			       unsigned int status_flags, char *result,
> +			       unsigned int maxlen)
> +{
> +	const struct inlinecrypt_ctx *ctx = ti->private;
> +	unsigned int sz = 0;
> +	int num_feature_args = 0;
> +
> +	switch (type) {
> +	case STATUSTYPE_INFO:
> +	case STATUSTYPE_IMA:
> +		result[0] = '\0';
> +		break;
> +
> +	case STATUSTYPE_TABLE:
> +		/*
> +		 * Warning: like dm-crypt, dm-inlinecrypt includes the key in
> +		 * the returned table.  Userspace is responsible for redacting
> +		 * the key when needed.
> +		 */
> +		DMEMIT("%s %*phN %llu %s %llu", ctx->cipher_string,
> +		       ctx->key.size, ctx->key.bytes, ctx->iv_offset,
> +		       ctx->dev->name, ctx->start);
> +		num_feature_args += !!ti->num_discard_bios;
> +		if (ctx->sector_size != SECTOR_SIZE)
> +			num_feature_args += 2;
> +		if (num_feature_args != 0) {
> +			DMEMIT(" %d", num_feature_args);
> +			if (ti->num_discard_bios)
> +				DMEMIT(" allow_discards");
> +			if (ctx->sector_size != SECTOR_SIZE) {
> +				DMEMIT(" sector_size:%u", ctx->sector_size);
> +				DMEMIT(" iv_large_sectors");
> +			}
> +		}
> +		break;
> +	}
> +}
> +
> +static int inlinecrypt_prepare_ioctl(struct dm_target *ti,
> +				     struct block_device **bdev, unsigned int cmd,
> +				     unsigned long arg, bool *forward)
> +{
> +	const struct inlinecrypt_ctx *ctx = ti->private;
> +	const struct dm_dev *dev = ctx->dev;
> +
> +	*bdev = dev->bdev;
> +
> +	/* Only pass ioctls through if the device sizes match exactly. */
> +	return ctx->start != 0 || ti->len != bdev_nr_sectors(dev->bdev);
> +}
> +
> +static int inlinecrypt_iterate_devices(struct dm_target *ti,
> +				       iterate_devices_callout_fn fn,
> +				       void *data)
> +{
> +	const struct inlinecrypt_ctx *ctx = ti->private;
> +
> +	return fn(ti, ctx->dev, ctx->start, ti->len, data);
> +}
> +
> +#ifdef CONFIG_BLK_DEV_ZONED
> +static int inlinecrypt_report_zones(struct dm_target *ti,
> +				    struct dm_report_zones_args *args,
> +				    unsigned int nr_zones)
> +{
> +	const struct inlinecrypt_ctx *ctx = ti->private;
> +
> +	return dm_report_zones(ctx->dev->bdev, ctx->start,
> +			ctx->start + dm_target_offset(ti, args->next_sector),
> +			args, nr_zones);
> +}
> +#else
> +#define inlinecrypt_report_zones NULL
> +#endif
> +
> +static void inlinecrypt_io_hints(struct dm_target *ti,
> +				 struct queue_limits *limits)
> +{
> +	const struct inlinecrypt_ctx *ctx = ti->private;
> +	const unsigned int sector_size = ctx->sector_size;
> +
> +	limits->logical_block_size =
> +		max_t(unsigned int, limits->logical_block_size, sector_size);
> +	limits->physical_block_size =
> +		max_t(unsigned int, limits->physical_block_size, sector_size);
> +	limits->io_min = max_t(unsigned int, limits->io_min, sector_size);
> +	limits->dma_alignment = limits->logical_block_size - 1;
> +}
> +
> +static struct target_type inlinecrypt_target = {
> +	.name			= "inlinecrypt",
> +	.version		= {1, 0, 0},
> +	/*
> +	 * Do not set DM_TARGET_PASSES_CRYPTO, since dm-inlinecrypt consumes the
> +	 * crypto capability itself.
> +	 */
> +	.features		= DM_TARGET_ZONED_HM,
> +	.module			= THIS_MODULE,
> +	.ctr			= inlinecrypt_ctr,
> +	.dtr			= inlinecrypt_dtr,
> +	.map			= inlinecrypt_map,
> +	.status			= inlinecrypt_status,
> +	.prepare_ioctl		= inlinecrypt_prepare_ioctl,
> +	.iterate_devices	= inlinecrypt_iterate_devices,
> +	.report_zones		= inlinecrypt_report_zones,
> +	.io_hints		= inlinecrypt_io_hints,
> +};
> +
> +module_dm(inlinecrypt);
> +
> +MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
> +MODULE_AUTHOR("Linlin Zhang <linlin.zhang@oss.qualcomm.com>");
> +MODULE_DESCRIPTION(DM_NAME " target for inline encryption");
> +MODULE_LICENSE("GPL");
> -- 
> 2.34.1
> 

