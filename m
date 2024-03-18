Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27161D522
	for <dm-devel@lists.linux.dev>; Mon, 18 Mar 2024 20:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710795280; cv=none; b=UYYuf9ECUMnXw0JLwNhPTvSqShsD02+4hDO71aZJGpHCVBCvJEFIdFzyy41nM3YELaGXXEiV7CgsfVHaC1SZPs8Tu2Df3q0vI97sCpMCCzXeLZNU/jaqF2TcFG7Jdj6pxfgBU4u9QaASh5M4cdqpLKZmjHloDLls5K626URvVZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710795280; c=relaxed/simple;
	bh=m35jqchrLdw6Hs3oNysKCwiEYmq4l7sAJyJiXo0L3Nw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vi5VWLfuPcFTV8LvoK4TfgDcZriJd4T/9oksaWgy57OzI+N1GCLQQ4FgiDfwU3gK9VZFs/JO2MRdb7qhAqyJ+FL7I119JlU4t2SoRuYlwSNNfvc7MOL/MwiBDbT/QPIJQ95xxKnqrcyAJMydyBazSr4TP/KHK/3SfDO8wzxb+3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c8ON1NTE; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c8ON1NTE"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e6ce174d45so3810796b3a.3
        for <dm-devel@lists.linux.dev>; Mon, 18 Mar 2024 13:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710795278; x=1711400078; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=p2xJJHy5eel7fHJRmeI48tVTIhijif7+3F1WmFkTHbk=;
        b=c8ON1NTE/cMRshiXoN4XNddOd1XdhZOLdlkR4JH0bXgRyhsTS7ngTgI1q2c6q8xPhj
         gzX+nR8kSVjddbwqkhTsCzGMehW+wQdDrGccDjAUUd2C4dysrCilpWnt7mR/nSHMw1DR
         LPpYgAs7A0P0+id8WXwb4SVhA3CMhz/W/7yEUHNLrrEztvdyr9kLZmVUPCJ7aFV9SEan
         kS+uW+7bjMjkQd602CRepKtqdNONhnZWaOBJValRHMzlh7icKK35IRwWE64hyaokNULd
         BOhSAEGpvN7jaV+3O0eysnM32omVmt92P5DdicOM2EMIuKAmhsW8dZhMRqtWAXgRbHD9
         9KMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710795278; x=1711400078;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p2xJJHy5eel7fHJRmeI48tVTIhijif7+3F1WmFkTHbk=;
        b=IBjyZh7e4soQCUZcOVmPor3SgYQr42BsFJSLG1ii1eGrE6LFJIhSOJ74MnFx+O0mbU
         RHE8IanLSIpLgxHsuYE7ZyAzrtsY/kkk8GWv+PB+2zAl6EJK8/dd9hWWgp09nTbq4rmn
         o13tH525ZGwILswRaAXEycbMu3mJzHdqTsQIGXjTDy72aLhe2el4cfVJZR5dWZaliMWa
         k5IzR0UKkLwycl2dDAPDRZriS7ohKdu4hNiP+R+f4768a2UbME7IvlzQ3dQi9FbPIzhs
         oX2+VFC/97v6f23XShl5MNNmYwCLhh1rKGEzBSb572A4bNFlBOnOtvrADC7jjtHj7oBz
         ZB3A==
X-Forwarded-Encrypted: i=1; AJvYcCVaca5Qvj5hRWpa1Tphr4lB+kKw5ZSfiSTZvEMl+RPPEQRiH0cr6t+60xI7R3FevG5Dcc7MUFEwpJTcGTvU2F4yE3kkksH51Kw=
X-Gm-Message-State: AOJu0Ywm3TjgLgpgjGxsSETynZoPjJpRp2QpaikNno/mzXbDpk+wAmu/
	qKzWB1y/CCxKwSxSVAUk4+xqEuagHWxqVAHfgaknlZ6KBkD9niPNLczDbv8h
X-Google-Smtp-Source: AGHT+IHE5IWihrkqsSTiyorYRQDmBWdfOg87wfqmIfMGr5NtMPH/R0gh+o8As3SUnl0FAIzAgfrYxQ==
X-Received: by 2002:a05:6a00:9382:b0:6e6:fcbe:fa70 with SMTP id ka2-20020a056a00938200b006e6fcbefa70mr1002664pfb.0.1710795278288;
        Mon, 18 Mar 2024 13:54:38 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y5-20020a62f245000000b006e5dc1b4861sm8220085pfl.64.2024.03.18.13.54.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 13:54:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <28a88525-6b06-4215-9e78-2b3d8c0d8657@roeck-us.net>
Date: Mon, 18 Mar 2024 13:54:36 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/39] dm vdo: add the MurmurHash3 fast hashing
 algorithm
Content-Language: en-US
To: Kenneth Raeburn <raeburn@redhat.com>
Cc: Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org
References: <20231026214136.1067410-1-msakai@redhat.com>
 <20231026214136.1067410-3-msakai@redhat.com>
 <ea57f231-f78e-4a55-bf85-c5d50e17237e@roeck-us.net>
 <CAK1Ur38jAmWo35HTNrDDAaN5Awiie9wRiPDMVrNUg6+ZM8mJ7A@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAlVcphcFCRmg06EACgkQyx8mb86fmYFg0RAA
 nzXJzuPkLJaOmSIzPAqqnutACchT/meCOgMEpS5oLf6xn5ySZkl23OxuhpMZTVX+49c9pvBx
 hpvl5bCWFu5qC1jC2eWRYU+aZZE4sxMaAGeWenQJsiG9lP8wkfCJP3ockNu0ZXXAXwIbY1O1
 c+l11zQkZw89zNgWgKobKzrDMBFOYtAh0pAInZ9TSn7oA4Ctejouo5wUugmk8MrDtUVXmEA9
 7f9fgKYSwl/H7dfKKsS1bDOpyJlqhEAH94BHJdK/b1tzwJCFAXFhMlmlbYEk8kWjcxQgDWMu
 GAthQzSuAyhqyZwFcOlMCNbAcTSQawSo3B9yM9mHJne5RrAbVz4TWLnEaX8gA5xK3uCNCeyI
 sqYuzA4OzcMwnnTASvzsGZoYHTFP3DQwf2nzxD6yBGCfwNGIYfS0i8YN8XcBgEcDFMWpOQhT
 Pu3HeztMnF3HXrc0t7e5rDW9zCh3k2PA6D2NV4fews9KDFhLlTfCVzf0PS1dRVVWM+4jVl6l
 HRIAgWp+2/f8dx5vPc4Ycp4IsZN0l1h9uT7qm1KTwz+sSl1zOqKD/BpfGNZfLRRxrXthvvY8
 BltcuZ4+PGFTcRkMytUbMDFMF9Cjd2W9dXD35PEtvj8wnEyzIos8bbgtLrGTv/SYhmPpahJA
 l8hPhYvmAvpOmusUUyB30StsHIU2LLccUPPOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAlVcpi8FCRmg08MACgkQyx8mb86fmYHNRQ/+
 J0OZsBYP4leJvQF8lx9zif+v4ZY/6C9tTcUv/KNAE5leyrD4IKbnV4PnbrVhjq861it/zRQW
 cFpWQszZyWRwNPWUUz7ejmm9lAwPbr8xWT4qMSA43VKQ7ZCeTQJ4TC8kjqtcbw41SjkjrcTG
 wF52zFO4bOWyovVAPncvV9eGA/vtnd3xEZXQiSt91kBSqK28yjxAqK/c3G6i7IX2rg6pzgqh
 hiH3/1qM2M/LSuqAv0Rwrt/k+pZXE+B4Ud42hwmMr0TfhNxG+X7YKvjKC+SjPjqp0CaztQ0H
 nsDLSLElVROxCd9m8CAUuHplgmR3seYCOrT4jriMFBtKNPtj2EE4DNV4s7k0Zy+6iRQ8G8ng
 QjsSqYJx8iAR8JRB7Gm2rQOMv8lSRdjva++GT0VLXtHULdlzg8VjDnFZ3lfz5PWEOeIMk7Rj
 trjv82EZtrhLuLjHRCaG50OOm0hwPSk1J64R8O3HjSLdertmw7eyAYOo4RuWJguYMg5DRnBk
 WkRwrSuCn7UG+qVWZeKEsFKFOkynOs3pVbcbq1pxbhk3TRWCGRU5JolI4ohy/7JV1TVbjiDI
 HP/aVnm6NC8of26P40Pg8EdAhajZnHHjA7FrJXsy3cyIGqvg9os4rNkUWmrCfLLsZDHD8FnU
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <CAK1Ur38jAmWo35HTNrDDAaN5Awiie9wRiPDMVrNUg6+ZM8mJ7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/18/24 13:37, Kenneth Raeburn wrote:
> (resend because of accidental HTML lossage)
> 
> On Thu, Mar 14, 2024 at 7:38 PM Guenter Roeck <linux@roeck-us.net> wrote:
>> On sparc64, with gcc 11.4, the above code results in:
>>
>> ERROR: modpost: "__bswapdi2" [drivers/md/dm-vdo/dm-vdo.ko] undefined!
>>
>> Guenter
> 
> Thanks for catching that. I don't think our team has any sparc
> machines readily available for testing.
> This is an artifact of our having imported user-mode code to use in
> the kernel. We should probably be using le64_to_cpup and friends, as
> we do elsewhere, so it doesn't try to pull in libgcc support routines.
> 

I am kind of getting wary about reporting such issues. Should I drop
building dm-vdo images for sparc ? Would it be possible to add
"depends on BROKEN if SPARC" configuration option to indicate that
the code isn't expected to be buildable on sparc, much less work ?

Thanks,
Guenter

