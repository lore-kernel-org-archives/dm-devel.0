Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A7B3DD500
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 17:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775840882; cv=none; b=Q7WANkSnLQjuXflakA5wPhFJN0SnMA4EdwV0yXa9lvelqS6bvcLfUXBiW+ubHmoIwZ9SHYb82q5LO0gUb6TfXTcWdnylgg1mOYncx1Zgvqk28wgBlSSe6ePiBBZprB1BDI/7LRDYaEQbIsHwSMhyjuhr0c4j/dWDoLo4KivLexs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775840882; c=relaxed/simple;
	bh=0Go+kM+HXDp1j+sIMKbSxZkXQlmTfMQ/MD3HwxPkEC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gm8Sbi1xwgIBM6P3+rYrs2PIbkSHlsPqJZT0q6PWcB11ejF/+vtG8j+mlyrbUCyM5VnAIpkVAsa39W/r2+zSdI1SQpUd7JlAlZXgKYjZlQshoWrBuA7mFHbv+UlgxvZJcKxWhYc1iLisQbWGJHRaKyGTfP9HtNMYcYgSEZjZJdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=APxVXIyR; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="APxVXIyR"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso26190355e9.3
        for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 10:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775840879; x=1776445679; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kbZ6cNKTEFnmf1IPUUamxp0kAc/MCTj6oA8/LCn4OBA=;
        b=APxVXIyR+6SD73m78IRO726MIlOrYGvg844lD8RxlxYVWKq7A1eppoV8sQj8D65yiR
         2D5b9MFiu8iYf9JD6WfPE8zfdiUI6i9CB2aR5UBdyIdxFeb8THg10uMJmtT4H1BV2zBj
         hrZmDRtj1GvxjDSd0KbmjZC5FATS++PgZ/pUUX3BQqKptCd8pmGmqzwRtAS7P538+zvW
         ekiSCFxdAMZ6+ANwxo04ww2OS2w5Wf+4jcEg+da5QDYfceADRLTvCpybVKyL2wBRKwiS
         b7QvZZILgR8E6gAz96Gp1mup8CsXYj7x04tT31V+q/53yv6OE4J+9x5omr75MYTCr6Pk
         HghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775840879; x=1776445679;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kbZ6cNKTEFnmf1IPUUamxp0kAc/MCTj6oA8/LCn4OBA=;
        b=aASkLerj+oQluonDYKakvPI8Yclpnj4gLTznsQukNoy9LpVvtDQvjDwlksqTCqHUMW
         GkeCe43S4E562IpXySNQiaWYH+18NFqltdjz/G8/i0IhJHKc8dA5wAAIdHShltGD+U4E
         0Xx1SAh0FpqWKTpzAoZxQU1Dx3XpkozP7qTYMufkB5BKopfGLzSYo44xr0eWoy24qI3q
         ZKjeSe4ewWlHtEGGnTrGmTO4lDF+jrmZrJdctIXNP5Y5kh0pszznIFSlZJLJ67XG3B7a
         xMn/1uD+0XIfSdLtIoAECb43QwHtQxTr9+338rUlySfpBJrgRZoOcHoURhbdU+tw43JR
         8MJg==
X-Forwarded-Encrypted: i=1; AJvYcCXwiht3b7p8Zvr0kmRFC9jb0fViiQK1y/xZTopYS/ucJ7ZuA0X/HrzgDimckTnUeOsbhhy8Csgb1g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzAkTr05SmqeIz0VvRHRV1S6L7gimC8ZZdzH2FC+cYBefzh9S/t
	nGuB8ggjU/hv2bCNWpTeFFWJHqVV6w6cv8Eu5cT2mmQ7aUx0JNG4FVrD
X-Gm-Gg: AeBDietRwgJpFrlxF+VR1nkuE7Yt+cRCdH2cmE0I2q6QLplQcoSEqcl1xe6u43EJEFH
	yuuTvl30j6mEGzBsbBdQ6UdwYQvwuEZtBD9G5pJLbNqVncKJbnBSrmvwpgEpPM8exz1NhI0BWoT
	1P97P49mMQ4BnKGHhzt8TPagIJLW0xYZl1SKypkpFGTXNSuCTY2s/2uhKaPiVpsXD4VEOpE2dFC
	1HLM9+TE/DKjie4WpZpzuFpKzd9z2gFYq43VE9H0gHwJcsycr1G4GWhIQF5P6vvk7mpS9Qi9Na+
	UuWsA5KvKQFEmprbhxrglTCF/P87W2qEtQ19KQOKSWcNlrQEsepk+P8HIXdiwYhjp05VZN/whys
	9NL0hmg5wWUREyfWH2kvOhg1G9NJgbOtbDB7hgsto8hdMCy80LR3/Kz4SuT0UTytNS71rHUVMOz
	V5eX4fiVsojJBAqtQ6MNr31Uzs2VIP6liLByvqH2R+/TG1NF7jFkzmeQOK1sqmjJRUdQ63
X-Received: by 2002:a05:600c:a415:b0:487:1108:48af with SMTP id 5b1f17b1804b1-488d67bf7c7mr38838535e9.4.1775840879280;
        Fri, 10 Apr 2026 10:07:59 -0700 (PDT)
Received: from [192.168.8.101] (78-80-20-202.customers.tmcz.cz. [78.80.20.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d58a8438sm89155735e9.5.2026.04.10.10.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2026 10:07:58 -0700 (PDT)
Message-ID: <1a36c5e7-5fd6-4923-926e-65bb04c33b04@gmail.com>
Date: Fri, 10 Apr 2026 19:07:56 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] dm: add documentation for dm-inlinecrypt target
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
 linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
 dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
 hch@infradead.org, axboe@kernel.dk
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
 <20260410134031.2880675-4-linlin.zhang@oss.qualcomm.com>
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
In-Reply-To: <20260410134031.2880675-4-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/10/26 3:40 PM, Linlin Zhang wrote:
> This adds the admin-guide documentation for dm-inlinecrypt.
> 
> dm-inlinecrypt.rst is the guide to using dm-inlinecrypt.
> 
> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> ---

...

> +
> +<cipher>
> +    Encryption cipher type.
> +
> +    The cipher specifications format is::
> +
> +       cipher
> +
> +    Examples::
> +
> +       aes-xts-plain64
> +
> +    The cipher type is correspond one-to-one with encryption modes. For

... with encryption modes supported for inline crypto in block layer?

In your patch only BLK_ENCRYPTION_MODE_AES_256_XTS.

> +    instance, the corresponding crypto mode of aes-xts-plain64 is
> +    BLK_ENCRYPTION_MODE_AES_256_XTS.

...

> +iv_large_sectors
> +   IV generators will use sector number counted in <sector_size> units
> +   instead of default 512 bytes sectors.
> +
> +   For example, if <sector_size> is 4096 bytes, plain64 IV for the second
> +   sector will be 8 (without flag) and 1 if iv_large_sectors is present.
> +   The <iv_offset> must be multiple of <sector_size> (in 512 bytes units)
> +   if this flag is specified.

Is it true? I see this comment in the code:

/* dm-inlinecrypt doesn't implement iv_large_sectors=false. */

...

> +Example scripts
> +===============
> +LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
> +encryption with dm-inlinecrypt using the 'cryptsetup' utility, see
> +https://gitlab.com/cryptsetup/cryptsetup

Cryptsetup has no support for inlinecrypt and it is question if it should have.
It would require additional options and maybe LUKS2 metadata flag to make it persistent.

How did you test it? Please remove this cryptsetup example.
It can be added later when userspace get this functionality.

...> +
> +	#!/bin/sh
> +	# Create a inlinecrypt device using cryptsetup and LUKS header with default cipher
> +	cryptsetup luksFormat $1
> +	cryptsetup luksOpen $1 inlinecrypt1

ditto. This example will use dm-crypt, not dm-inlinecrypt.

Milan

