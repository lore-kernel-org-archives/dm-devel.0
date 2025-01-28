Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9910518B476
	for <dm-devel@lists.linux.dev>; Tue, 28 Jan 2025 08:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738053592; cv=none; b=edSp890Ags/NJaifZouKEDIGayifzN1Q653CRXYVRM3wdJ4EElmu1DZLEZ8YJySjW+Ihlc2wSbgWJvkiICXY7ybbwHTVhjBX9T7v1Ol70XDEnZhCx12zS4SFLRfax5ZTaHSeRCkjPrAHPe/i5Bp9lii8ZeZziUNUHSqoSZ1otAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738053592; c=relaxed/simple;
	bh=3mOMUFt1fctyfMdgEXCswlK7yVj+ifmSBTUSTSSwJqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J/Z0RWJ7cUYPrv38xs8WTMNOT4o3llqyboVBlKZyJ4m5osE8xTp2yEKEKKZqikTjoeYc7ajp4uIqxB2fsAPOexnF5iB647kStg6Z5BrqswIfmLQzBq9zv4bqwkQOc3JGp+iNhTZb5xMXDVuLG0WSsLLdgcYF8VSXRPubItU34As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nhIoDgrs; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nhIoDgrs"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-436ce2ab251so34681135e9.1
        for <dm-devel@lists.linux.dev>; Tue, 28 Jan 2025 00:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738053589; x=1738658389; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pAuQlIiR0lJsFia1xtkk31hB3U5kathS6ftHL10BRlM=;
        b=nhIoDgrsWH5LeksTp6EgRjWUt4qcO+xH8IUmDY/XEMZUyuNldYcbu5S4RPO59rjoO9
         9HM2dqUJxoWfySFt0/XibPUndOXgFnYC0k8GgkSlRDGEdZCbaAlhGkb+iWt/8jimM2VJ
         6J9xQ1uBaQCurQUZCHYMNNcN4fyMAp7svbJKQRYyQcwRKTXgAJYncHpUEysq5VmJ721Z
         eYFi0KWs/2MmMnu3P7BKP3w4QVzl4NR37b6XCIvmt/UPHb4M+pZKt+cyW7oc5se9H8BD
         hueafeiCZkEKDO2NixODES+lijNJBbgrYMe+e7Nu4Q9P7byfeGT0owZNnvwoBwUlSDmn
         niVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738053589; x=1738658389;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAuQlIiR0lJsFia1xtkk31hB3U5kathS6ftHL10BRlM=;
        b=JuvJq2BGLWjI1xgd+3NIEGDbKEibw/+jOER/zDWP0Rvnk9uwmGAjBJn4ToupjrCvv2
         as8CLFY7HNEwMHPwlrjatbkRk0swpZdKrBrkWxmiMsZr2rrTnVXL31V3DXBmxo6+f1w9
         A/379nOf95bsir1vqvVluA0yqpw2V42deVbdSPVfzBnbvnP2J9xPhEIscHtBYcVs5kOz
         gOWWJkoDxsp28psVvj8jXjre1L0QXx3DueoczhExB2Im2upMSfHDx1z+cS+a5omloijs
         NShzChuAwGG8qHLBEmE4tgL1923nOrUFjCTvlGKsxkvz1lAOhf+pOcKjSXsKm3xTzvN4
         jeLg==
X-Forwarded-Encrypted: i=1; AJvYcCVihzVhmR2cjgEYjLczZqIauOQjpxGxumtvMb4eDsi4ic6gN06I8dKnpdzR+LBHs/hee0x7UZ59OA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzR8FNOqwydopDkcSI1GFTqCfdaesKRLQamSIqL58eVfFbVgISM
	uo4MIVpudYy7dafjXnWsitPdiIiBjb6m48m2ny6KSHLlxGBtFFEg
X-Gm-Gg: ASbGncswExLjbuDKcD1Hh+9UoPXKlHknYnrD3cjhrdE6iQ0Wff0hzScHOdDxzhbid7a
	8agbhjey0ef8L9iISu72sPHEufP6mHOuQho5bAcVxN12+EVHac72vjh4uXlOlZr9t5RKnsF0EiA
	WFl3OkJ+zDiZgYv8oc4CzmKg27JOqwwRrMcJIt5ZOMy8DNk7X9QjGfyVeEkqsgHiTWErpyIKluz
	QEcLmCKwzSdYcE7eF+MLwmCHS7RVdLDTMA4iXr8TzPb1OcQC6wrin6BJiNG2EU6esPcMxnJz8BS
	3fhVvz38jp8RUnzAkByyzuf68twr7V7c3VStBV4=
X-Google-Smtp-Source: AGHT+IHrEjtGxlI5f5yabAvAQ+78/+AfKvRi9fM5tFgRx4evScKHouP9StrtnD5V+p1QLGLR09x8AQ==
X-Received: by 2002:a05:600c:524f:b0:436:1b7a:c0b4 with SMTP id 5b1f17b1804b1-438913bed33mr336997065e9.1.1738053588601;
        Tue, 28 Jan 2025 00:39:48 -0800 (PST)
Received: from [147.251.42.106] (fosforos.fi.muni.cz. [147.251.42.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438d75de282sm6821035e9.2.2025.01.28.00.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 00:39:48 -0800 (PST)
Message-ID: <bd38b6c0-9334-4a6b-ab42-db4b7da76333@gmail.com>
Date: Tue, 28 Jan 2025 09:39:47 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-crypt: switch to using the crc32 library
To: Eric Biggers <ebiggers@kernel.org>, dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
References: <20250127221533.58298-1-ebiggers@kernel.org>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 xsFNBE94p38BEADZRET8y1gVxlfDk44/XwBbFjC7eM6EanyCuivUPMmPwYDo9qRey0JdOGhW
 hAZeutGGxsKliozmeTL25Z6wWICu2oeY+ZfbgJQYHFeQ01NVwoYy57hhytZw/6IMLFRcIaWS
 Hd7oNdneQg6mVJcGdA/BOX68uo3RKSHj6Q8GoQ54F/NpCotzVcP1ORpVJ5ptyG0x6OZm5Esn
 61pKE979wcHsz7EzcDYl+3MS63gZm+O3D1u80bUMmBUlxyEiC5jo5ksTFheA8m/5CAPQtxzY
 vgezYlLLS3nkxaq2ERK5DhvMv0NktXSutfWQsOI5WLjG7UWStwAnO2W+CVZLcnZV0K6OKDaF
 bCj4ovg5HV0FyQZknN2O5QbxesNlNWkMOJAnnX6c/zowO7jq8GCpa3oJl3xxmwFbCZtH4z3f
 EVw0wAFc2JlnufR4dhaax9fhNoUJ4OSVTi9zqstxhEyywkazakEvAYwOlC5+1FKoc9UIvApA
 GvgcTJGTOp7MuHptHGwWvGZEaJqcsqoy7rsYPxtDQ7bJuJJblzGIUxWAl8qsUsF8M4ISxBkf
 fcUYiR0wh1luUhXFo2rRTKT+Ic/nJDE66Ee4Ecn9+BPlNODhlEG1vk62rhiYSnyzy5MAUhUl
 stDxuEjYK+NGd2aYH0VANZalqlUZFTEdOdA6NYROxkYZVsVtXQARAQABzSBNaWxhbiBCcm96
 IDxnbWF6eWxhbmRAZ21haWwuY29tPsLBlQQTAQgAPwIbAwYLCQgHAwIGFQgCCQoLBBYCAwEC
 HgECF4AWIQQqKRgkP95GZI0GhvnZsFd72T6Y/AUCYaUUZgUJJPhv5wAKCRDZsFd72T6Y/D5N
 D/438pkYd5NyycQ2Gu8YAjF57Od2GfeiftCDBOMXzh1XxIx7gLosLHvzCZ0SaRYPVF/Nr/X9
 sreJVrMkwd1ILNdCQB1rLBhhKzwYFztmOYvdCG9LRrBVJPgtaYqO/0493CzXwQ7FfkEc4OVB
 uhBs4YwFu+kmhh0NngcP4jaaaIziHw/rQ9vLiAi28p1WeVTzOjtBt8QisTidS2VkZ+/iAgqB
 9zz2UPkE1UXBAPU4iEsGCVXGWRz99IULsTNjP4K3p8ZpdZ6ovy7X6EN3lYhbpmXYLzZ3RXst
 PEojSvqpkSQsjUksR5VBE0GnaY4B8ZlM3Ng2o7vcxbToQOsOkbVGn+59rpBKgiRadRFuT+2D
 x80VrwWBccaph+VOfll9/4FVv+SBQ1wSPOUHl11TWVpdMFKtQgA5/HHldVqrcEssWJb9/tew
 9pqxTDn6RHV/pfzKCspiiLVkI66BF802cpyboLBBSvcDuLHbOBHrpC+IXCZ7mgkCrgMlZMql
 wFWBjAu8Zlc5tQJPgE9eeQAQrfZRcLgux88PtxhVihA1OsMNoqYapgMzMTubLUMYCCsjrHZe
 nzw5uTcjig0RHz9ilMJlvVbhwVVLmmmf4p/R37QYaqm1RycLpvkUZUzSz2NCyTcZp9nM6ooR
 GhpDQWmUdH1Jz9T6E9//KIhI6xt4//P15ZfiIs7BTQRPeKd/ARAA3oR1fJ/D3GvnoInVqydD
 U9LGnMQaVSwQe+fjBy5/ILwo3pUZSVHdaKeVoa84gLO9g6JLToTo+ooMSBtsCkGHb//oiGTU
 7KdLTLiFh6kmL6my11eiK53o1BI1CVwWMJ8jxbMBPet6exUubBzceBFbmqq3lVz4RZ2D1zKV
 njxB0/KjdbI53anIv7Ko1k+MwaKMTzO/O6vBmI71oGQkKO6WpcyzVjLIip9PEpDUYJRCrhKg
 hBeMPwe+AntP9Om4N/3AWF6icarGImnFvTYswR2Q+C6AoiAbqI4WmXOuzJLKiImwZrSYnSfQ
 7qtdDGXWYr/N1+C+bgI8O6NuAg2cjFHE96xwJVhyaMzyROUZgm4qngaBvBvCQIhKzit61oBe
 I/drZ/d5JolzlKdZZrcmofmiCQRa+57OM3Fbl8ykFazN1ASyCex2UrftX5oHmhaeeRlGVaTV
 iEbAvU4PP4RnNKwaWQivsFhqQrfFFhvFV9CRSvsR6qu5eiFI6c8CjB49gBcKKAJ9a8gkyWs8
 sg4PYY7L15XdRn8kOf/tg98UCM1vSBV2moEJA0f98/Z48LQXNb7dgvVRtH6owARspsV6nJyD
 vktsLTyMW5BW9q4NC1rgQC8GQXjrQ+iyQLNwy5ESe2MzGKkHogxKg4Pvi1wZh9Snr+RyB0Rq
 rIrzbXhyi47+7wcAEQEAAcLBfAQYAQgAJgIbDBYhBCopGCQ/3kZkjQaG+dmwV3vZPpj8BQJh
 pRSXBQkk+HAYAAoJENmwV3vZPpj8BPMP/iZV+XROOhs/MsKd7ngQeFgETkmt8YVhb2Rg3Vgp
 AQe9cn6aw9jk3CnB0ecNBdoyyt33t3vGNau6iCwlRfaTdXg9qtIyctuCQSewY2YMk5AS8Mmb
 XoGvjH1Z/irrVsoSz+N7HFPKIlAy8D/aRwS1CHm9saPQiGoeR/zThciVYncRG/U9J6sV8XH9
 OEPnQQR4w/V1bYI9Sk+suGcSFN7pMRMsSslOma429A3bEbZ7Ikt9WTJnUY9XfL5ZqQnjLeRl
 8243OTfuHSth26upjZIQ2esccZMYpQg0/MOlHvuFuFu6MFL/gZDNzH8jAcBrNd/6ABKsecYT
 nBInKH2TONc0kC65oAhrSSBNLudTuPHce/YBCsUCAEMwgJTybdpMQh9NkS68WxQtXxU6neoQ
 U7kEJGGFsc7/yXiQXuVvJUkK/Xs04X6j0l1f/6KLoNQ9ep/2In596B0BcvvaKv7gdDt1Trgg
 vlB+GpT+iFRLvhCBe5kAERREfRfmWJq1bHod/ulrp/VLGAaZlOBTgsCzufWF5SOLbZkmV2b5
 xy2F/AU3oQUZncCvFMTWpBC+gO/o3kZCyyGCaQdQe4jS/FUJqR1suVwNMzcOJOP/LMQwujE/
 Ch7XLM35VICo9qqhih4OvLHUAWzC5dNSipL+rSGHvWBdfXDhbezJIl6sp7/1rJfS8qPs
In-Reply-To: <20250127221533.58298-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/27/25 11:15 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Now that the crc32() library function takes advantage of
> architecture-specific optimizations, it is unnecessary to go through the
> crypto API.  Just use crc32().  This is much simpler, and it improves
> performance due to eliminating the crypto API overhead.  (However, this
> only affects the TCW IV mode of dm-crypt, which is a compatibility mode
> that is rarely used compared to other dm-crypt modes.)

Yes, these are only used to be compatible with old TrueCrypt CBC images
(except chained ciphers requiring modified CBC mode).
I would like to keep this for the ability to access legacy images,
but it should not be used by anything else.

I tested the patch below with the images we have in the cryptsetup
testsuite, and it works ok.

So if you want, add

Tested-and-reviewed-by: Milan Broz <gmazyland@gmail.com>

Milan


> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   drivers/md/Kconfig    |  1 +
>   drivers/md/dm-crypt.c | 41 ++++++++++-------------------------------
>   2 files changed, 11 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 0b1870a09e1fd..06f809e70f153 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -265,10 +265,11 @@ config DM_UNSTRIPED
>   config DM_CRYPT
>   	tristate "Crypt target support"
>   	depends on BLK_DEV_DM
>   	depends on (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
>   	depends on (TRUSTED_KEYS || TRUSTED_KEYS=n)
> +	select CRC32
>   	select CRYPTO
>   	select CRYPTO_CBC
>   	select CRYPTO_ESSIV
>   	help
>   	  This device-mapper target allows you to create a device that
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 1ae2c71bb383b..c726cddd310c8 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -15,10 +15,11 @@
>   #include <linux/kernel.h>
>   #include <linux/key.h>
>   #include <linux/bio.h>
>   #include <linux/blkdev.h>
>   #include <linux/blk-integrity.h>
> +#include <linux/crc32.h>
>   #include <linux/mempool.h>
>   #include <linux/slab.h>
>   #include <linux/crypto.h>
>   #include <linux/workqueue.h>
>   #include <linux/kthread.h>
> @@ -122,11 +123,10 @@ struct iv_lmk_private {
>   	u8 *seed;
>   };
>   
>   #define TCW_WHITENING_SIZE 16
>   struct iv_tcw_private {
> -	struct crypto_shash *crc32_tfm;
>   	u8 *iv_seed;
>   	u8 *whitening;
>   };
>   
>   #define ELEPHANT_MAX_KEY_SIZE 32
> @@ -604,14 +604,10 @@ static void crypt_iv_tcw_dtr(struct crypt_config *cc)
>   
>   	kfree_sensitive(tcw->iv_seed);
>   	tcw->iv_seed = NULL;
>   	kfree_sensitive(tcw->whitening);
>   	tcw->whitening = NULL;
> -
> -	if (tcw->crc32_tfm && !IS_ERR(tcw->crc32_tfm))
> -		crypto_free_shash(tcw->crc32_tfm);
> -	tcw->crc32_tfm = NULL;
>   }
>   
>   static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
>   			    const char *opts)
>   {
> @@ -625,17 +621,10 @@ static int crypt_iv_tcw_ctr(struct crypt_config *cc, struct dm_target *ti,
>   	if (cc->key_size <= (cc->iv_size + TCW_WHITENING_SIZE)) {
>   		ti->error = "Wrong key size for TCW";
>   		return -EINVAL;
>   	}
>   
> -	tcw->crc32_tfm = crypto_alloc_shash("crc32", 0,
> -					    CRYPTO_ALG_ALLOCATES_MEMORY);
> -	if (IS_ERR(tcw->crc32_tfm)) {
> -		ti->error = "Error initializing CRC32 in TCW";
> -		return PTR_ERR(tcw->crc32_tfm);
> -	}
> -
>   	tcw->iv_seed = kzalloc(cc->iv_size, GFP_KERNEL);
>   	tcw->whitening = kzalloc(TCW_WHITENING_SIZE, GFP_KERNEL);
>   	if (!tcw->iv_seed || !tcw->whitening) {
>   		crypt_iv_tcw_dtr(cc);
>   		ti->error = "Error allocating seed storage in TCW";
> @@ -665,85 +654,75 @@ static int crypt_iv_tcw_wipe(struct crypt_config *cc)
>   	memset(tcw->whitening, 0, TCW_WHITENING_SIZE);
>   
>   	return 0;
>   }
>   
> -static int crypt_iv_tcw_whitening(struct crypt_config *cc,
> -				  struct dm_crypt_request *dmreq,
> -				  u8 *data)
> +static void crypt_iv_tcw_whitening(struct crypt_config *cc,
> +				   struct dm_crypt_request *dmreq, u8 *data)
>   {
>   	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
>   	__le64 sector = cpu_to_le64(dmreq->iv_sector);
>   	u8 buf[TCW_WHITENING_SIZE];
> -	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
> -	int i, r;
> +	int i;
>   
>   	/* xor whitening with sector number */
>   	crypto_xor_cpy(buf, tcw->whitening, (u8 *)&sector, 8);
>   	crypto_xor_cpy(&buf[8], tcw->whitening + 8, (u8 *)&sector, 8);
>   
>   	/* calculate crc32 for every 32bit part and xor it */
> -	desc->tfm = tcw->crc32_tfm;
> -	for (i = 0; i < 4; i++) {
> -		r = crypto_shash_digest(desc, &buf[i * 4], 4, &buf[i * 4]);
> -		if (r)
> -			goto out;
> -	}
> +	for (i = 0; i < 4; i++)
> +		put_unaligned_le32(crc32(0, &buf[i * 4], 4), &buf[i * 4]);
>   	crypto_xor(&buf[0], &buf[12], 4);
>   	crypto_xor(&buf[4], &buf[8], 4);
>   
>   	/* apply whitening (8 bytes) to whole sector */
>   	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
>   		crypto_xor(data + i * 8, buf, 8);
> -out:
>   	memzero_explicit(buf, sizeof(buf));
> -	return r;
>   }
>   
>   static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
>   			    struct dm_crypt_request *dmreq)
>   {
>   	struct scatterlist *sg;
>   	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
>   	__le64 sector = cpu_to_le64(dmreq->iv_sector);
>   	u8 *src;
> -	int r = 0;
>   
>   	/* Remove whitening from ciphertext */
>   	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE) {
>   		sg = crypt_get_sg_data(cc, dmreq->sg_in);
>   		src = kmap_local_page(sg_page(sg));
> -		r = crypt_iv_tcw_whitening(cc, dmreq, src + sg->offset);
> +		crypt_iv_tcw_whitening(cc, dmreq, src + sg->offset);
>   		kunmap_local(src);
>   	}
>   
>   	/* Calculate IV */
>   	crypto_xor_cpy(iv, tcw->iv_seed, (u8 *)&sector, 8);
>   	if (cc->iv_size > 8)
>   		crypto_xor_cpy(&iv[8], tcw->iv_seed + 8, (u8 *)&sector,
>   			       cc->iv_size - 8);
>   
> -	return r;
> +	return 0;
>   }
>   
>   static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
>   			     struct dm_crypt_request *dmreq)
>   {
>   	struct scatterlist *sg;
>   	u8 *dst;
> -	int r;
>   
>   	if (bio_data_dir(dmreq->ctx->bio_in) != WRITE)
>   		return 0;
>   
>   	/* Apply whitening on ciphertext */
>   	sg = crypt_get_sg_data(cc, dmreq->sg_out);
>   	dst = kmap_local_page(sg_page(sg));
> -	r = crypt_iv_tcw_whitening(cc, dmreq, dst + sg->offset);
> +	crypt_iv_tcw_whitening(cc, dmreq, dst + sg->offset);
>   	kunmap_local(dst);
>   
> -	return r;
> +	return 0;
>   }
>   
>   static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
>   				struct dm_crypt_request *dmreq)
>   {
> 
> base-commit: 805ba04cb7ccfc7d72e834ebd796e043142156ba

