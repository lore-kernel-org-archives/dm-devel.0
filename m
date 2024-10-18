Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26E1154BE4
	for <dm-devel@lists.linux.dev>; Fri, 18 Oct 2024 02:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729219967; cv=none; b=nQqiHD/9MSvGnXFeaukQCr/K3FPe7QYYjMrTtS/TA28ogDlZgHJll7ZhvHljMEpBZBNKvJoWpyAprS2PSDh/cJdO06dc2qsyy7KqJ1EErmWwwYwrfK8t62uP4mmg7PCl88nW8Pz/GTqEro1b0aV3KjSVxcqZEktsV+dGtkG23nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729219967; c=relaxed/simple;
	bh=pabfNCmlIPwYzm5IgdudAqy7XRVMiMocc5gWvyE8Pxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sj9TuCvv2oRhZ023vTZl4BshSMZiRelB6mnbytdn/T0+yq9NMeS1GU0rpUnRSQX1GdxmNsguFPn/4A/m+nm7Ic7sA3Wln2bkbVyQNv9Qhx2FGEHahdX4afEmZRX7WdeEhfUEhWH0OuIyTIY+EVeAXtCzbqePYzJvH53N6LSLfTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JPYDein5; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPYDein5"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6cc2ea27a50so21459616d6.0
        for <dm-devel@lists.linux.dev>; Thu, 17 Oct 2024 19:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729219964; x=1729824764; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L46f3uUSqgRYVs6jmS0mM8WHRPMBaXlVySl7LjIwhEs=;
        b=JPYDein5ne8J1u7EKYgPvnFks2VKVl+ZgWUdamWiYow1JkqdhnngSjEb8h/Q/VqS3Y
         MqzhFLpMdphNRoMQww609Ak0JzskPjAcSK8SNwgeMqEw/om3BCoJlXXAXj9MFZr/MrnQ
         yFmhU0wijS3V58yNG0XcBRWVF5nn2Hp/BdDZPnAxUpwN91JpoEvxB7UulMOzHJ6OFJUU
         gNYlDRIBFycAGMWaIpztGZKAMod93oOvRMak/Bh++j4FhLgPJXqWhRUFOZX2a5c6FMt1
         zZxklrlE+SH3s9pT/iGbIeKwoKsOUEAB2qnzd8cMaf1M4v0APDAnVFIpqqAoXasbhqQv
         KYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729219964; x=1729824764;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L46f3uUSqgRYVs6jmS0mM8WHRPMBaXlVySl7LjIwhEs=;
        b=afJKzJuV6bpstcXL8Wo/z8E0ufFO8xG9AbO+SGGSAQ7Spfctkz9/3LR7xb4NA0scPE
         t3RgB6SgOF/Imxizrmu3PBAeSiOniadb/ZSOwhmPToFVIiT1HzcoAXX1SIMVWIG24q5S
         YcPuDVA971U5NdJUY2rw0CYbM+1IQeRIOAs274I678Sw3cwGC5HWRg6rBOWJcc+YXdMH
         OyyFlkEo24ifRio+NwXhNv7GeSUp9TIT9mjyT0mGBjiQGMJug68sUIvPA/1a9cl+htWd
         ZQUF1F1MA62MycczLXeYxqMFDDlqYNxQrFc6n5iDLs0PMRCDTHj2LdxzfkLEi995jAKC
         /lRw==
X-Forwarded-Encrypted: i=1; AJvYcCXy39nf/j2sXd1hkjBxBvpMN+tpgFX3lnUrnsvdKubTpjUzyDnrarq6T6brxwxxgtVpiW0zzgaE6g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyMH2iRhBmcTfJNCQ1wY7liLfOK493eDEWSk/oLxoDLedsItqgG
	/T3nUBXhUAV8iThzO4yZ1804mXrR9vl9g9cwVPWj3KE5HAqiidxP
X-Google-Smtp-Source: AGHT+IGyw12kC3EtWeqkNzL6vOrVD7F7x084oiflFQVyi8H67D9oZ0Q04qk8nX/3+/Fvf4vne2xo6g==
X-Received: by 2002:a05:6214:31a1:b0:6cb:e9da:bd4 with SMTP id 6a1803df08f44-6cde1879c6cmr16538756d6.5.1729219964399;
        Thu, 17 Oct 2024 19:52:44 -0700 (PDT)
Received: from [10.56.180.205] (syn-076-188-177-122.res.spectrum.com. [76.188.177.122])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cde117b295sm2750836d6.71.2024.10.17.19.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 19:52:43 -0700 (PDT)
Message-ID: <681a6d2e-a80a-4e81-a049-841d7e8582ba@gmail.com>
Date: Thu, 17 Oct 2024 22:52:42 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/2] dm-inlinecrypt: add target for inline block
 device encryption
To: Eric Biggers <ebiggers@kernel.org>, dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 Md Sadre Alam <quic_mdalam@quicinc.com>, Israel Rukshin
 <israelr@nvidia.com>, Milan Broz <gmazyland@gmail.com>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20241016232748.134211-1-ebiggers@kernel.org>
 <20241016232748.134211-3-ebiggers@kernel.org>
Content-Language: en-US
From: Adrian Vovk <adrianvovk@gmail.com>
In-Reply-To: <20241016232748.134211-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

On 10/16/24 19:27, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Add a new device-mapper target "dm-inlinecrypt" that is similar to
> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
> This allows it to take advantage of inline encryption hardware such as
> that commonly built into UFS host controllers.

Wow! Thank you for this patch! This is something we really want in 
systemd and in GNOME, and I came across this patchset on accident while 
trying to find a way to get someone to work on it for us.

> The table syntax matches dm-crypt's, but for now only a stripped-down
> set of parameters is supported.  For example, for now AES-256-XTS is the
> only supported cipher.
>
> dm-inlinecrypt is based on Android's dm-default-key with the
> controversial passthrough support removed.

That's quite unfortunate. I'd say this passthrough support is probably 
the most powerful thing about dm-default-key.

Could you elaborate on why you removed it? I think it's a necessary 
feature. Enabling multiple layers of encryption stacked on top of each 
other, without paying the cost of double (or more...) encryption, is 
something we really want over in userspace. It'll enable us to stack 
full-disk encryption with encrypted /home directories for each user and 
then stack encrypted per-app data dirs on top of that. I'd say that the 
passthrough support is more important for us than the performance 
benefit of using inline encryption hardware.

Without a solution to layer encryption we can't do a lot of good things 
we want to do in userspace.

As far as I understand, the passthrough support was controversial only 
because previous upstreaming attempts tried to punch holes into dm-crypt 
to make this work. I don't know of an attempt to upstream dm-default-key 
as-is, with passthrough support. As far as I can tell, people even 
seemed open to that idea...

Is there some context I'm missing? Information would be appreciated.

> Note that due to the removal
> of passthrough support, use of dm-inlinecrypt in combination with
> fscrypt causes double encryption of file contents (similar to dm-crypt +
> fscrypt), with the fscrypt layer not being able to use the inline
> encryption hardware.  This makes dm-inlinecrypt unusable on systems such
> as Android that use fscrypt and where a more optimized approach is
> needed.

Yeah, sadly you've removed the use-case we're very interested in. 
Generic PC hardware doesn't have blk-crypto hardware as far as I can 
tell, so we don't get the performance benefit of replacing dm-crypt with 
dm-inlinecrypt. However, we do get the performance benefit of the 
passthrough support (if we run this on top of the blk-crypto software 
emulation mode, for instance)


Best,

Adrian Vovk

> It is however suitable as a replacement for dm-crypt.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   drivers/md/Kconfig          |  10 +
>   drivers/md/Makefile         |   1 +
>   drivers/md/dm-inlinecrypt.c | 417 ++++++++++++++++++++++++++++++++++++
>   3 files changed, 428 insertions(+)
>   create mode 100644 drivers/md/dm-inlinecrypt.c
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 1e9db8e4acdf6..caed60097a216 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -268,10 +268,20 @@ config DM_CRYPT
>   	  To compile this code as a module, choose M here: the module will
>   	  be called dm-crypt.
>   
>   	  If unsure, say N.
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
>   config DM_SNAPSHOT
>          tristate "Snapshot target"
>          depends on BLK_DEV_DM
>          select DM_BUFIO
>   	help
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 476a214e4bdc2..6e44ff32b8af8 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -49,10 +49,11 @@ obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
>   obj-$(CONFIG_BLK_DEV_DM_BUILTIN) += dm-builtin.o
>   obj-$(CONFIG_DM_UNSTRIPED)	+= dm-unstripe.o
>   obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
>   obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
>   obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
> +obj-$(CONFIG_DM_INLINECRYPT)	+= dm-inlinecrypt.o
>   obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
>   obj-$(CONFIG_DM_DUST)		+= dm-dust.o
>   obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
>   obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
>   obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
> diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
> new file mode 100644
> index 0000000000000..d6c2e6e1fdbbb
> --- /dev/null
> +++ b/drivers/md/dm-inlinecrypt.c
> @@ -0,0 +1,417 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2024 Google LLC
> + */
> +
> +#include <linux/blk-crypto.h>
> +#include <linux/device-mapper.h>
> +#include <linux/module.h>
> +
> +#define DM_MSG_PREFIX	"inlinecrypt"
> +
> +static const struct dm_inlinecrypt_cipher {
> +	const char *name;
> +	enum blk_crypto_mode_num mode_num;
> +	int key_size;
> +} dm_inlinecrypt_ciphers[] = {
> +	{
> +		.name = "aes-xts-plain64",
> +		.mode_num = BLK_ENCRYPTION_MODE_AES_256_XTS,
> +		.key_size = 64,
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
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Construct an inlinecrypt mapping:
> + * <cipher> <key> <iv_offset> <dev_path> <start>
> + *
> + * This syntax matches dm-crypt's, but the set of supported functionality has
> + * been stripped down.
> + */
> +static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> +{
> +	struct inlinecrypt_ctx *ctx;
> +	const struct dm_inlinecrypt_cipher *cipher;
> +	u8 raw_key[BLK_CRYPTO_MAX_KEY_SIZE];
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
> +	if (strlen(argv[1]) != 2 * cipher->key_size) {
> +		ti->error = "Incorrect key size for cipher";
> +		err = -EINVAL;
> +		goto bad;
> +	}
> +	if (hex2bin(raw_key, argv[1], cipher->key_size) != 0) {
> +		ti->error = "Malformed key string";
> +		err = -EINVAL;
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
> +	err = blk_crypto_init_key(&ctx->key, raw_key, cipher->mode_num,
> +				  dun_bytes, ctx->sector_size);
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
> +
> +	/* Calculate the DUN and enforce data-unit (crypto sector) alignment. */
> +	dun[0] = ctx->iv_offset + sector_in_target; /* 512-byte sectors */
> +	if (dun[0] & ((ctx->sector_size >> SECTOR_SHIFT) - 1))
> +		return DM_MAPIO_KILL;
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
> +	return DM_MAPIO_REMAPPED;
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
> +		       ctx->key.size, ctx->key.raw, ctx->iv_offset,
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
> +				     struct block_device **bdev)
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
> +static int __init dm_inlinecrypt_init(void)
> +{
> +	return dm_register_target(&inlinecrypt_target);
> +}
> +
> +static void __exit dm_inlinecrypt_exit(void)
> +{
> +	dm_unregister_target(&inlinecrypt_target);
> +}
> +
> +module_init(dm_inlinecrypt_init);
> +module_exit(dm_inlinecrypt_exit);
> +
> +MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
> +MODULE_DESCRIPTION(DM_NAME " target for inline encryption");
> +MODULE_LICENSE("GPL");
