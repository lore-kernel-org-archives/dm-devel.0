Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDD75FDA7
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 13:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772629872; cv=none; b=SnOoMqruMKx93zLqASnkW6AVRQPUC/BW4ShJzmAwx9752naMW271SZ3aLiWFMCBg61iwrh6KxEvSXaUskT49tyT7MQc+c7b4eYAppmXwErMIWR+BzWhsyMnDM8blJwDWkHIeUZgAI/ilWJ2tbqQaWBa8E5f/yv6no1JPnFs98OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772629872; c=relaxed/simple;
	bh=tdr4XFSl2VHNiGrD3QQhBo8zpnljibR0pWucSkqXtDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tq2NkuDzQx1Cr5Q/iHwpX+ydMT6RvFmThSm/SBJ0xw1c618vc/1Pj7aR2LHe2z8gQTcdolfR66qb5blvsT8xO1aTjKeb/EH0Wry9yD+5WUY/x9rHcCBJIypp5YRJ1puML3t2lbFH2AZJvtb7eIR3wdcxowmZZsIia/5nFFXWCTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D+to+U5P; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+to+U5P"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439ac15f35fso3828038f8f.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Mar 2026 05:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772629870; x=1773234670; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JCrSCreRYyCyvdWOvN57PUFUflJeOrYLAAUvncKqv3Q=;
        b=D+to+U5P4mhSPibCEubDYsWx4M98teLrs2AGFanZFDcicgAsFDSOeyQqj0DerLAQHn
         Cbm9mAKU57U/nz7z2jcOBmE0V5DcrK1awJWQ+iBfuQmmQiwf5dmVLisrAmKutH2uqKvT
         fs+gMcKwMGAdsb3baV30ddWDoHJuuFENQrAG2k/C/f+JetTQgDtSSZtlDdRvPhMLj8QY
         vS2tqvSEIsc3c1cSCttj/Ws7aoryUH3qCdK0/rmoGAKLCZdVZkRtyPvOZmk0hiVXGSBo
         8nJo0tMYL4+v/f8no+HYv5fk/S0L0dOtHRoj7AbtLuWHpf4UsAULdBjh+/2h7gdQGf+F
         NmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772629870; x=1773234670;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCrSCreRYyCyvdWOvN57PUFUflJeOrYLAAUvncKqv3Q=;
        b=c3S6LHKI9gMB4l8as5Li5AeBUMvT4lYyvdXVFAGrJMRYY6DyYZKBbxbA5AI2Y8UA7b
         nz8SM4qVXKMLws/YNw9gAcHwUFfeoT9dRMYTDy13MrdPBsoUo2/BIZdsRXQqun4Lzxqr
         CFFKUfo5870IiSqX+auJ3SOt5fkk+kRJHU/nv956RljSzlg25kpARKKEkqhZ+VMGgpWJ
         CqV4AwgGDR2MUy711NRhlNlU/futDhfGnuyz86QpG8l88uNsJYBujG67GE6AwOAJyO1G
         LDWD9HgwMN21Lobd95ghNIJvqHba05iwfmdCpiUlaulNY147yqlOserI8+C2YQCY2NU6
         4riA==
X-Forwarded-Encrypted: i=1; AJvYcCW+SRsnSRWTTXz795bBwNORDuPgSbrWeyRDIW4tNfGFs58R/EkPmJOztSaqGWnWwJgRyH0tG5CW+A==@lists.linux.dev
X-Gm-Message-State: AOJu0YzeU9+Lg8U/+KXYwvmGxrLjKXm6OiI7npDp13kWt3il8uIUV/jQ
	S0aAAEiLmt1YI/gwwdUuNb9wJHTauCQQfcAldyy8YlLc2iQ+rVbxrwQO
X-Gm-Gg: ATEYQzyHgfvmcQ2DXPUhPbVhquOMpyHyhStOreLIxFugP+zT18YpOHm5HiRH6epdTSo
	ouSw6oKkKJ0o1fC0E5/1QHP4dnICe2bcD8I6GTt6o/pH1ZqWfJ/IbDdISNN58g39YskApgDBDcr
	+pnoue93wrL8Bym5iXIoQbjZrf/6RooWzGI4Mze0zwm8pUrWDlGpDvuZ7J1d1LsotnE3zFq2/ut
	+IWtONahiY8Ge4zTUOjw+NEn/kwgSeA/8m0/xrwgGrgRsCm+RwsoN2PsbpFL5r4SE945WudY1tK
	OQ7rduH+JkxbUeebBIgsz6c5GRcn/6tqLGGY64t0fJwVJQ3KuEigpmI+eW5pjPa5A96YNGWQGi5
	nwBPubrhtOVrgRyiQeExWUH0kZGqx0GqQvnnD8mWT2hsE8kQ8MLGEwrmpRynocgQejlzXlz6yDz
	ZeFxzEa+yc3a1oR5HDtxuV0Yki1jDm
X-Received: by 2002:a05:6000:40e0:b0:439:aef4:9451 with SMTP id ffacd0b85a97d-439c7f79e83mr3862806f8f.18.1772629869650;
        Wed, 04 Mar 2026 05:11:09 -0800 (PST)
Received: from [192.168.1.116] ([176.74.141.242])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439bb686a32sm17572791f8f.13.2026.03.04.05.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2026 05:11:09 -0800 (PST)
Message-ID: <682506ea-c9c2-458b-8123-8d78fc53cc7f@gmail.com>
Date: Wed, 4 Mar 2026 14:11:06 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] dm-inlinecrypt: add target for inline block device
 encryption
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
 linux-block@vger.kernel.org, ebiggers@kernel.org
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
 dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
 mpatocka@redhat.com
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

just few comments below, but I am not DM maintainer so feel free to ignore it :)

On 3/4/26 1:17 PM, Linlin Zhang wrote:
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
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> ---
>   drivers/md/Kconfig          |  10 +
>   drivers/md/Makefile         |   1 +
>   drivers/md/dm-inlinecrypt.c | 416 ++++++++++++++++++++++++++++++++++++

I think it should also add doc in
Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
...

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

Hm. I can understand some translation table for this stupid
dm-crypt notation to inline enum, but why you need key size here?

Shouldn't there be some helper for inline crypt returning
keysize based on BLK_ENCRYPTION_MODE_AES_256_XTS?

I guess you have fixed cipher list already, but what about IV?
Is it always little-endian, or someone already reinvented plain64be (big-endian)?

...> +	while (opt_params--) {

...> +/*
> + * Construct an inlinecrypt mapping:
> + * <cipher> <key> <iv_offset> <dev_path> <start>

As above, it supports opt params, it should mention it here (or in doc).


...
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


Any reason it does not support keyring keys from the beginning?

...
> +static int inlinecrypt_map(struct dm_target *ti, struct bio *bio)

> +	/* Map the bio's sector to the underlying device. (512-byte sectors) */
> +	sector_in_target = dm_target_offset(ti, bio->bi_iter.bi_sector);
> +	bio->bi_iter.bi_sector = ctx->start + sector_in_target;
> +	/*
> +	 * If the bio doesn't have any data (e.g. if it's a DISCARD request),
> +	 * there's nothing more to do.
> +	 */

dmcrypt uses bio_set_dev() for REQ_PREFLUSH or REQ_OP_DISCARD, why this differs?

> +
> +	switch (type) {
> +	case STATUSTYPE_INFO:
> +	case STATUSTYPE_IMA:
> +		result[0] = '\0';

This should really emit audit information similar to dm-crypt.

> +		break;
> +
> +	case STATUSTYPE_TABLE:
> +		/*
> +		 * Warning: like dm-crypt, dm-inlinecrypt includes the key in
> +		 * the returned table.  Userspace is responsible for redacting
> +		 * the key when needed.

Again, why not support keyring format? LUKS2 uses it by default for dm-crypt table.

Milan

