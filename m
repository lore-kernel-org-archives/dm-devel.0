Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AE87316E
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 07:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716881124; cv=none; b=X2M2kCmuF2PDjBtRAxwIqqhjoNPJ/qfGpKJGPAv5MJw1OeGpUjvyNZU4eNgvQu///LHDDK/Zmvyd8YjZyAAhg514eNIe3pmag135HYfyFyi2oxJGRKlBtKPGj1nPw+MXQx8gPYoBm8xoKKYzC2o8i3+YIppTEmSyQ7kf3hZPPCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716881124; c=relaxed/simple;
	bh=jybnMlOrR6A2UNcmuM2gN1MLS7PwtEQeZE0gBPwZ+bY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q0NLt4U6k4YqpxELDcv00X1YINqAsUGYqUBz+kpwtIL+lsnE1Vv2IN3y6Qb2kIKYGYfXaw0nqVQHRqWC7dVXrCqNBhstf1r+AumcKQMZCMl1BDoOkO6sIZ4PW5lMLFQHv9KXbAiG+1ULsJIXHNLNS+qDKBCmoQCNuxTezvMGCWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dK3Ae+Su; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dK3Ae+Su"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5785f861868so585659a12.2
        for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 00:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716881121; x=1717485921; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=s1Osdo9sjekoZ+6lnBj99/xnbLYIg3ZTc0BDmfVYYlc=;
        b=dK3Ae+SuMrU2OREEb9SCTQT9snmRJhauH/vybJ5QbEH5VlnGsjQR/aSf/Uw+i+3sJC
         txApMQKzv+9USY81WBn4TokrEonkdi+btfYAlKquW5eZ+yysfu+PUqDVvm+PtQLFWLIx
         1z/i9zO44Wj2W8ad/8+lvHqpTSjPn6DlhzPJE2NzfXdOn5GyKYgZyKmByvqGlTttPZfe
         JrSiOb++UWppenaTRY9BXc6q5bRvSF3lCEELKB0A3TWnYWt89stH8W8nLw68X58BZR71
         6AWYKDiCVk9BhIGxRPpCNdYK7eCij6wYOuSc4+zr4Q2yCEBpIqA6BDXt9Z490QskSxxV
         0wqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716881121; x=1717485921;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1Osdo9sjekoZ+6lnBj99/xnbLYIg3ZTc0BDmfVYYlc=;
        b=PslE76z4TJMdH82VSC+Vd3+IOTE4dRdOXlqvzv9RwpQ/nSvFByh8uUZrNeKyV297tJ
         8Mu4f/COuoIIpA/JGy0rILiO8BIjKEHeNXSooeaLVwy77GiwtKEmKAOUkMqAE3Gz27oP
         Ef41Y5qWZ4RmerHosykNqCRgfwDij06dRgx8CVN4JMThFTkDuUrE3Pxu43WYgqrCso5T
         eZsWDJq+J1Vky7WIs3/4qc1Rlb96rLVq47dSa8jSl2M6CuVaVPgiyM2fa9XJx+Y2j717
         bMHd2lMJA9s73vEAfn0B47h7VjMYM3m0z2m0G/jJRCoBgH9aKpdkjj6yd9zQMgYCEURQ
         7B6A==
X-Forwarded-Encrypted: i=1; AJvYcCUiv8prbTvwP4e/G6qht19r5LlyvDnEEIa7BWfgmGGNz6bqXT52ihr9dBheC5SVXPMkYbJ8pESzZgaOiq84w74WINxgJmcOv0w=
X-Gm-Message-State: AOJu0Yzha9ANDc8hUnAu5HSDaiLUerYYeUQeq+pXsgQylkygC3sBZs70
	oMYYq92RnysZH4zR68BGCOgQNfkMb/KcwOY4ldCivyxFqwxH2zL9
X-Google-Smtp-Source: AGHT+IG4fm/cbs0IMCKZM/ObnugaXbkeHMF05YPGT1uovmCYu3zUUIxTkGqoH4bfrCVm6hdqgLgh+w==
X-Received: by 2002:a50:ab5a:0:b0:579:f08a:39f4 with SMTP id 4fb4d7f45d1cf-579f08a3a44mr760569a12.37.1716881120565;
        Tue, 28 May 2024 00:25:20 -0700 (PDT)
Received: from [147.251.42.107] (laomedon.fi.muni.cz. [147.251.42.107])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57852496343sm6894520a12.59.2024.05.28.00.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 00:25:20 -0700 (PDT)
Message-ID: <f7c9e39f-b139-429b-a310-15f19dab05ec@gmail.com>
Date: Tue, 28 May 2024 09:25:19 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] dm-crypt support for per-sector NVMe metadata
To: Eric Wheeler <dm-devel@lists.ewheeler.net>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-nvme@lists.infradead.org
References: <f85e3824-5545-f541-c96d-4352585288a@redhat.com>
 <206cd9fc-7dd0-f633-f6a9-9a2bd348a48e@ewheeler.net>
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
In-Reply-To: <206cd9fc-7dd0-f633-f6a9-9a2bd348a48e@ewheeler.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 12:12 AM, Eric Wheeler wrote:
> On Wed, 15 May 2024, Mikulas Patocka wrote:
>> Hi
>>
>> Some NVMe devices may be formatted with extra 64 bytes of metadata per
>> sector.
>>
>> Here I'm submitting for review dm-crypt patches that make it possible to
>> use per-sector metadata for authenticated encryption. With these patches,
>> dm-crypt can run directly on the top of a NVMe device, without using
>> dm-integrity. These patches increase write throughput twice, because there
>> is no write to the dm-integrity journal.
>>
>> An example how to use it (so far, there is no support in the userspace
>> cryptsetup tool):
>>
>> # nvme format /dev/nvme1 -n 1 -lbaf=4
>> # dmsetup create cr --table '0 1048576 crypt
>> capi:authenc(hmac(sha256),cbc(aes))-essiv:sha256
>> 01b11af6b55f76424fd53fb66667c301466b2eeaf0f39fd36d26e7fc4f52ade2de4228e996f5ae2fe817ce178e77079d28e4baaebffbcd3e16ae4f36ef217298
>> 0 /dev/nvme1n1 0 2 integrity:32:aead sector_size:4096'
> 
> Thats really an amazing feature, and I think your implementation is simple
> and elegant.  Somehow reminds me of 520/528-byte sectors that big
> commercial filers use, but in a way the Linux could use.
> 
> Questions:
> 
> - I see you are using 32-bytes of AEAD data (out of 64).  Is AEAD always
>    32-bytes, or can it vary by crypto mechanism?

Hi Eric,

I'll try to answer this question as this is where we headed with dm-integrity+dm-crypt
since the beginning - replace it with HW and atomic sector+metadata handling once
suitable HW becomes available.

Currently, dm-integrity allocates exact space for any AEAD you want to construct
(cipher-xts/hctr2 + hmac) or for native AEAD (my favourite is AEGIS here).

So it depends on configuration, the only difference to dm-integrity is that HW allocates
fixed 64 bytes so that crypto can use up to this space, but it should be completely
configurable in dm-crypt. IOW real used space can vary by crypto mechanism.

Definitely, it is now enough for real AEAD compared to legacy 512+8 DIF :)

Also, it opens a way to store something more (sector context) in metadata,
but that's an idea for the future (usable in fs encryption as well, I guess).


> - What drive are you using? I am curious what your `nvme id-ns` output
>    looks like. Do you have 64 in the `ms` value?
> 
>          # nvme id-ns /dev/nvme0n1 | grep lbaf
>          nlbaf   : 0
>          nulbaf  : 0
>          lbaf  0 : ms:0   lbads:9  rp:0 (in use)
>                       ^         ^512b

This is the major issue still - I think there are only enterprisey NVMe drives that
can do this.

Milan

