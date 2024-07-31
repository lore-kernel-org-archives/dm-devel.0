Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367D91B0137
	for <dm-devel@lists.linux.dev>; Wed, 31 Jul 2024 12:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722429679; cv=none; b=i+ho4bFouIG9BD3TIGBTwYKLEEe1E2qibcg6THW8/J13Skz/GMQVLVqeyrTITgGle/JGsBGve1R5gt6gnlnc7Ul0OCQjyA6Zu8RhuJlb1jhpsnHDtViPnqZj6RQAJg8K2k+chAPqhJrEfgYfJi/a4Hn+oc6hCBDlKR/o8Mw+Rfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722429679; c=relaxed/simple;
	bh=hWzgiXWVrjpTN1nVuyODYR9+OxLdhgMRH76UuMtK06A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=liyZuKhPxQYehGpOHftJq2d5j54jorD0uCjWnWK99gcs2TmROq/T4a/vsc0Bncp/tkuv4KZTsSjqm6MVvdESZKqEHjlg9/2xUSJ7wQK0BYCFMSQ7PJil8JOrtmt+Bqt7WuRWeBRRC5CraCiJ/9BJ/oQ6bu1zJlzVvJIAQjLGMZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vazd31Uh; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vazd31Uh"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7a91cdcc78so343879866b.3
        for <dm-devel@lists.linux.dev>; Wed, 31 Jul 2024 05:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722429676; x=1723034476; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/Q2l7kPRbHfPSAmXr8/i+HQUpkMV0CfBoozBQvEj2VM=;
        b=Vazd31UhWeurZSufpc0eQfeIAj/IOWzM/AOFzTsuqRe6UDZ5wk9siGerpohJLZyd73
         xzhTVtRwa5nnbX57Oz5NJPxc3QQ24Bm5FnyTm9T3/qPPv4dfqFkjbGbWcJfmNnnXfnWp
         /1HWvSc048bpvMUQmugpfgU6A35+7LUM8+AiqjQDdF3xUvWFxBsxDJe8lqxR6nXHmMDX
         k4LaOzNSlCjvBehi0cOO1r4TamoTyAWJbOrRjRRvsz1fn6fs/3ZYYqw12KgK1rLKFqEk
         nJ0XcuxO+pEFuPkHWtpSta6SqH4sYirYZb7pAPtWfl61gmOYypBt15GUydBsf5HbSyfi
         HhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722429676; x=1723034476;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Q2l7kPRbHfPSAmXr8/i+HQUpkMV0CfBoozBQvEj2VM=;
        b=w0zeUvxc1hSwmNxgnEk8H712nb2k7Cb/sgpQI4fD2oB0rth9naNjWJxuq5Pt4l6q/J
         kRe+Rpu97mtCxdViMfwUrSZGUMWXPF5lqylCYztVBQWroPUDbZyklMBBWB9VVuVoo4hR
         p964cyUFrBkfxfDpmSuR0UILPZkms0LKNIakzkiB9iG1GXpfxaWbIhfr8+Or/l+xmbE8
         Off+tuPTsoh6Aj/6BevhbGvB5FLIwtBctyimSth6LUVYb6wf3XCgrg4xFSquBc5VV5k2
         UcF+Sn/omdgRiXPsiQrkeykiqslm2rgIILQ9alKbsSYjym9KxMTveSS81YGFHlffvmf6
         B1Fw==
X-Forwarded-Encrypted: i=1; AJvYcCVZCAxdBUNMvQsfKFdLpDy3SJhiJF1FBg539dMuPFmUuycsSaG2fwpHiL15eo4kaK+nY9lacgsOrBDK3zBF5VcxeTH7HfCsiQE=
X-Gm-Message-State: AOJu0Yz6D76mKTTIY3I2ddNikXjB3ZLVRu3EVYZPz2+bOkOMf8/CimPM
	2fHCkveWFyQiioY0IeK254x8EBqPyJAKNdGJLJmsHXopc4YpLI/u
X-Google-Smtp-Source: AGHT+IH12mfwgxzN+nLyjdSXs3/FhfTaWeWx6KdoyfAElTnn/87OsFBoXHWcj137YDoCOE8gXgpMKg==
X-Received: by 2002:a50:f68d:0:b0:5a2:8f7d:aff4 with SMTP id 4fb4d7f45d1cf-5b021f0dd2amr11840822a12.20.1722429676231;
        Wed, 31 Jul 2024 05:41:16 -0700 (PDT)
Received: from [147.251.42.107] (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5b52ab8f09dsm1604442a12.26.2024.07.31.05.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 05:41:15 -0700 (PDT)
Message-ID: <c897b521-0520-429e-9e94-ba7da74a921f@gmail.com>
Date: Wed, 31 Jul 2024 14:41:13 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] md: dm-crypt: Set cc->iv_size to 4 bytes
To: Md Sadre Alam <quic_mdalam@quicinc.com>, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, adrian.hunter@intel.com,
 quic_asutoshd@quicinc.com, ritesh.list@gmail.com, ulf.hansson@linaro.org,
 andersson@kernel.org, konrad.dybcio@linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 quic_viswanat@quicinc.com, quic_srichara@quicinc.com, quic_varada@quicinc.com
References: <20240730115838.3507302-1-quic_mdalam@quicinc.com>
 <20240730115838.3507302-3-quic_mdalam@quicinc.com>
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
In-Reply-To: <20240730115838.3507302-3-quic_mdalam@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 1:58 PM, Md Sadre Alam wrote:
> Set cc->iv_size to 4 bytes instead of 8 bytes, since
> this cc->iv_size is passing as data unit bytes to
> blk_crypto_init_key(). Since CQHCI driver having
> limitation for data unit bytes to 32-bit only.

In dm-crypt, plain64 IV is defined as "little-endian 64bit IV"
and was introduced to fix security problem when 32bit "plain" IV
overflows and IV is reused.

In that case you can move ciphertext sector between places with
the same IV (but different offsets) and these will be still
correctly decrypted.

If I understand it correctly, this reintroduces the same problem here.
If you have 32bit only, just use "plain" and do not support plain64 here.

(In general, I do not understand why you are sending patches
for dm-crypt code that is clearly not upstream.
I hope this code will never be accepted.)

Milan

> 
> Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
> ---
>   drivers/md/dm-crypt.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 37add222b169..c0257d961968 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -2490,7 +2490,7 @@ static int crypt_select_inline_crypt_mode(struct dm_target *ti, char *cipher,
>   	}
>   
>   	if (ivmode == NULL || (strcmp(ivmode, "plain64") == 0)) {
> -		cc->iv_size = 8;
> +		cc->iv_size = 4;
>   	} else {
>   		ti->error = "Invalid IV mode for inline_crypt";
>   		return -EINVAL;

