Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0583B19A4
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 15:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773415672; cv=none; b=XSFY9VKpzIDn1JU2JK0WIXGroYOaH1r0/CEk5n+haitcjectjcHzuexXNaFKGKPMYEoi9qEO7IijBrPDarxMSB03OhaiP0wJNNbHH9bIOZtVeIONLRny92hqwtRUCch4H1J712BI2sZr8/CKEXFtOfGX3FNt0TQkY6lCjeruBIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773415672; c=relaxed/simple;
	bh=r732MH4eUyZFj0cG1H0vXTxFnuY4XK0oCax8NJCzLZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=brosjIrSvA+6edb9ApeUML/OJEyqsAFNrq8ChVWVBhg29sCA+QQflZuzgnj6f/iWaZQUP8NUVxrD8Yx3VCcyB80z+yGAkUEsIhX2iidSm64Wud+8lrUJqJKHelVN2hbbWeXxZlBRgGDbnP6+04ZtslXsU9hDG22F8TB/xiAG+W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c0hYZL3d; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0hYZL3d"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48534237460so25119585e9.3
        for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 08:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773415669; x=1774020469; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MMNm0gL3Me4TtMRtXwPRJioaCzWcm1bgO59kj5/wfh4=;
        b=c0hYZL3d1hWSeF5Mi0Vt7Cm5HY5Xe3E6tnENksvjYCCvU1Iw5YuOBUlRiskBw2QmGk
         Zm5GeL1+vFMjy7TLS+pfjHxyvZ4f5gEe8xzPCvg6yiTWgfHZUbgGLLlh1w4v0JOXyN0q
         Fb2JzILAmr46Q61dlurjk47Ys+ciycj7OMstgTs9looDQGnJvcwKGEhrJ5hgPux/i4/J
         0+G6vznQyxouP8bGhLtjREhnw1UObJwC4KLX5dKCCf3LJjjAOTxR1bCrlTrSZP8rXpZR
         c57vPWfjXrJnZpEEaxRAaUm5vmq3D5FaoitX/YoNpnAuginRc9pHIPe86R3zQVEz6xHm
         2y1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773415669; x=1774020469;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MMNm0gL3Me4TtMRtXwPRJioaCzWcm1bgO59kj5/wfh4=;
        b=lDgWpdFcPBs5BnuNTpliuqVBosIhd9nKhWHWeoocEjeXjSFJ+bQdYedqUud3a3oFX2
         5tUfDy3PfdjY6uCFu2qwDiPNb+ziq1eAU0GqfNQnygF0BL/R02ZZmn0wrwyc5eI3+BwB
         ZUTlVPTwPxzUaZlFXGhqUxdUmVkvK6VgC6/r3bQdB9GZKwyRZqjWU/Qss/QFOXrp43x2
         1OETZ+DJ0yvxkboRTNvmBnV3+wsqVc4jRGa0eh3BzjYfb2HsQm4pVwOEe/hrHVWAaCnL
         H2ODEDtHQ1ZgjKYwixKOJrh3bwQvOtdeFHbo7k5eBB6t1I7yyKcemBpY+Ts4LZme78SM
         RIZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy1YEw80dNk4oc+558MOlRBbqrEZwsrETCCswIvK2W84TzZaR/we/3BIVCy/ZBjvYiQ8fdrS9ySw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywc1oJuXmt/oeKiBPlxzZiC4LOXKBfR9KqrUVB4PvxqdB7bOZsw
	SNRdqjAm2HD+ecrXwGTPrBhYpb5prU6182Ite6OAzjZ+LhubjiMVvIBE
X-Gm-Gg: ATEYQzySNXChiB4pQQGsq8Rh5JtrqoBR6eHBIJDkEBl731AsGteNa25tcrsg2df2e+8
	xG1nnJifPJEQoiBnsE3Uda41fuhBF0cv1ekjBhzyCdws5Q6coQt6ldX7a1pCIwMt1MBn/yRP/1G
	YM2GKfTOrQWjGavRc13MQ5F8FArIMGjQWS8+fw9Y5HAkjCx9i9H9jxW1acipqd4lYeT8VwZUvs3
	bLA4vGx7yMEKqu8iTLa3I7Ezi2Oxb4HRHmqZDXDeleb9yvtKvdFnUW0pHI4WHLdt17LYHvVNUYp
	swYaMpU2yd0FEyP26CPsJdlrSJSjXxlYk2j8cCPXxEbZ650NcN178zDYHWCMCy2HuxJACAQ0dLT
	ubfgOAdZZG+lsBldGv0RHGsga30LkgwNuHl4hXOhzqo0HnWi7AaqHRERjrDO88s5kG+cbyWhFIJ
	Q7mPFkly4wvww9gplZ+Bx9Xo0sodCpQaAogWp6L1qVoR8kzSJ0N/Pg8qFYyvy2dWE=
X-Received: by 2002:a05:600c:c049:b0:483:7903:c3b1 with SMTP id 5b1f17b1804b1-485566f7a35mr46270265e9.20.1773415669234;
        Fri, 13 Mar 2026 08:27:49 -0700 (PDT)
Received: from [192.168.8.102] (89-24-59-99.nat.epc.tmcz.cz. [89.24.59.99])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fdf09abesm18409700f8f.0.2026.03.13.08.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 08:27:48 -0700 (PDT)
Message-ID: <7f613001-fc2b-44e3-ac14-7e661cf52fdd@gmail.com>
Date: Fri, 13 Mar 2026 16:27:46 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] dm-inlinecrypt: add target for inline block device
 encryption
To: Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers <ebiggers@kernel.org>
Cc: Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 adrianvovk@gmail.com, dm-devel@lists.linux.dev, quic_mdalam@quicinc.com,
 israelr@nvidia.com
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com>
 <20260312070110.GD2359@sol> <5a310122-bd7e-d10e-653e-bc7e09681478@redhat.com>
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
In-Reply-To: <5a310122-bd7e-d10e-653e-bc7e09681478@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/26 2:25 PM, Mikulas Patocka wrote:
> On Thu, 12 Mar 2026, Eric Biggers wrote:
> 
>> On Wed, Mar 04, 2026 at 04:17:27AM -0800, Linlin Zhang wrote:
>>> From: Eric Biggers <ebiggers@google.com>
>>>
>>> Add a new device-mapper target "dm-inlinecrypt" that is similar to
>>> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
>>> This allows it to take advantage of inline encryption hardware such as
>>> that commonly built into UFS host controllers.

...

>> I don't think it's plausible that this new patch was actually tested.
>> The version I sent in 2024 was tested at the time
>> (https://lore.kernel.org/r/20241016232748.134211-3-ebiggers@kernel.org/),
>> but I see at least two things that would make this new patch not work.

What a waste of time... thanks.
> OK. I dropped it.

Well, the inline crypt has some advantages to proprietary internal
hw implementations (like self-encrypting drives)  - it can be actually validated
comparing to sw version.

Anyway, Mikulas, if this dm-inlinecrypt returns one day, please be
sure that we do not have security-related "regressions" like not supporting
keyring. There is no need for dm-inlinecrypt to keep key inside the mapping table.
The keyring code is in dm-crypt, it should be easy to adapt it here.

Thanks,
Milan

