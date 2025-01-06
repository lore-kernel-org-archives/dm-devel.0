Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D0B1A9B43
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 09:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736154578; cv=none; b=bD9o9RK1xdacnlfXB1nAeaFnrNcLzINeHrE5xz3La9IntLC3dO8KzyzgExgNB1yzdUMqbE/2FkXg3M6CsPv4cFFopfBsk+ZDMFTYJd4b5Ic0mnlpxxeT1ecFl+kUjhBadjRd1sonn2I6RUKIPICUfzVHC8QrR4Ao0T8yNc5IQSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736154578; c=relaxed/simple;
	bh=3bw71Wo05qqipV80J4wUO3hsVxarfwEp1FFnPq75ukI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RC+4qCxN2z807HkkP4YkFQbcUSZzEiTDteZkc4u+Ym/qo9TItZCHW24BiOtBzIsAEUQebNwUiYYinwok2M128xcr42EXvqJ/4eazUcO76TWEZGVh5Ln+9ka8kMUpc9+PS85+BsQooSD4vRbU7ZTNTrzn2YwJXCxMCwgLb9embOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RmjiI/MV; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RmjiI/MV"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d3e829ff44so28435454a12.0
        for <dm-devel@lists.linux.dev>; Mon, 06 Jan 2025 01:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736154575; x=1736759375; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zcycuEtvo//nAKIr6UDISN8H6TzY8izd2WkkO6kF8vM=;
        b=RmjiI/MVcJcjDd+sX9nu6oHSCQeIpd6x5nZBDlYpOYCc4VKFnSJjeYvndjR3VorCzk
         DVdNiwsKGc1Td873bLmrWTHe4DFvr5zlZ14aLMqjNa1sjwDFCowp9BXwuYpuELiJDzj9
         Lo5WB5x4NiGa5NFBVu+rq2cGArybMTpnfVhA4Q71qy0rU7Ctox7B1PE63wjG7HtyY5i+
         +lyn8Pu9+B5k+bJjWNa3e+r4kt+ISbEYRdgSBMj+LPAVzLLJJFppCBJ1uVI2AP/4CBvI
         gUoPrgVHxIrXKlT9Drjg8CVbN4rCsFGCzRpPlplViO1U1xAU4b2Hd9/DUH7cEvBBNgsO
         Mb5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736154575; x=1736759375;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zcycuEtvo//nAKIr6UDISN8H6TzY8izd2WkkO6kF8vM=;
        b=RJt2gFBhARmwg7y0eMHcQPKK2F75lBSaYyMwvJh+cL2ilqnRdtnFNMBy/OFiwjKT87
         /tv1BAjcLc3NnhdSsFFB2ee8hGQ/z2lxTUTSIpWz31IvUPf4jGYqCJnoXeYEeIbTSWZ6
         UqDFGPuf3WOK0wWCT0vDQ01OdpYJksEWdaoz47bBkDO7j/n54BvTjyI9Xc2XciW7/vJ9
         MpE68WuCFHGnurMZJFi/mkx8cl7834lJ9qbV45pHFFOJSuKKl4vvRkX9bMuqw4Qe8rES
         DCHbFCtUEBKwzdxdx589369e/KH7a+BE8TYYtlO7djnyv8sWi7vGwic7yC7yds2VL/Zl
         H2yQ==
X-Forwarded-Encrypted: i=1; AJvYcCVq6nljz31FLTjsqLBa+IJb3YMc0ajk4Z3YHjXsdFIjld5EF1V65FWKG47MqvOFcCZ6gyDHgyFllg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxGDMywuWTB1v9PHBi9BfDLydg9p3qKx1nXqkwXL/5CLaou0Q8o
	A7ImXjau8yahJcJC9SPDJcORLOavZRUFU+jMml/LhWC4Cm3Qh9SR
X-Gm-Gg: ASbGncsSVVZ3ePn91x70LPOLGvNmqkS+UsV/eNHHEzwPvyvbWp6VyM5waIJV4lW72k6
	x6NSCCgKn7d5oZ2I2pWRmhwvUQVB9mHotIDYcudap/5/4m4+nQrfOPx0NwCcgpLOr1S44uaC1Dn
	oVnbrVS6z/Vuzu8Y8fmOHHgE5qlbszhp2/Ys76/TBSunPD5RCia8wLZuY1qJQP3y2rpWaIr35ez
	/FgufYSXsk8xnentys6fvTl+ISYH9XK5x8K4EKkUFM7vfBElbyBQMSfQRMmuVQgU96LiEOD20m6
	X1Xf
X-Google-Smtp-Source: AGHT+IHHWrNyj9UFqzyhQh08Yyfz1M0Oy0bE2eC1J+9v02NawUir3GfjDx5KkEfphtACQ2swdL+3hg==
X-Received: by 2002:a50:c88a:0:b0:5d8:8292:5674 with SMTP id 4fb4d7f45d1cf-5d8829256d9mr30236913a12.7.1736154575118;
        Mon, 06 Jan 2025 01:09:35 -0800 (PST)
Received: from [147.251.42.106] (fosforos.fi.muni.cz. [147.251.42.106])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f303sm23475538a12.24.2025.01.06.01.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 01:09:34 -0800 (PST)
Message-ID: <97f09f1a-7ee0-43da-8569-e0a949df31ad@gmail.com>
Date: Mon, 6 Jan 2025 10:09:34 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [discussion] proposal to bypass zero data for dm-crypt
To: Yu Kuai <yukuai1@huaweicloud.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, lkml <linux-kernel@vger.kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <73152f2b-2a3e-37a7-4578-9a4ae7ec903f@huaweicloud.com>
 <3181bbd4-40df-eecf-c9b2-45b09018b8af@redhat.com>
 <4351b4fa-2558-4b73-8604-81a4b1eef9dc@gmail.com>
 <34ddb616-63c7-5423-b20f-4ccd61bc4a66@huaweicloud.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <34ddb616-63c7-5423-b20f-4ccd61bc4a66@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 2:43 AM, Yu Kuai wrote:
>> On 1/3/25 5:25 PM, Mikulas Patocka wrote:
>>> Milan, what do you think about this from a cryptographic point of view?
>>> Does it make sense to add an option that would detect zero data and skip
>>> decryption in this case?
>>
>> It is a very dangerous thing.
>>
>> Disk encryption is a length-preserving encryption, so it cannot prevent
>> decryption of modified ciphertext. However, such ciphertext modification
>> (without key knowledge) will cause a pseudorandom plaintext output
>> (IOW attacker cannot easily flip bits or whole sectors by ciphertext
>> modification).
>>
>> If you allow the zeroed sector to transform to valid plaintext directly,
>> the attacker can wipe arbitrary plaintext sector. It can lead to fatal
>> issues (for example, wiping filesystem metadata bitmaps on some known
>> location).
> 
> Will there be difference if the attacher wipe the data to zero data or
> random data? And AFAIK, for this case, should user consider dm-integrity
> to prevent such attack?

I think I just explained this - you can directly set specific data with
zeroed plaintext. With pseudorandom decrypted data, you can only destroy
it and hope it will do something useful.

(I did not mention side channels as "decryption" will be much faster.)

With such a feature, it will not be full disk encryption but a weakened variant.
Even if it is ok for your threat model, someone can later use it improperly.

Just use encryption that suits your intended use case (perhaps filesystem
encryption orproperly configure your storage stack, dunno).
>> Stack FDE (dm-crypt) below the filesystem or other storage layer
>> (like thin provision) that supports sparse data, and you will get
>> the expected behavior without such tricks.
> 
> All we want to do is to offer an additional option for user, to enable
> dm-crypt or not. And if we stack dm-crypt below our storage layer, then
> all users will have to use dm-crypt. In order to prevent that, the
> storage layer will have to be much complex, and it will be impossible
> to perform a hot upgrade without affecting existing use cases. :(

This is not a reason for weakening encryption in dm-crypt.
You can always have a virtual volume per user that is optionally encrypted.

Milan

> 
> Thanks,
> Kuai
> 
>>
>> Milan
>>
>>
>>>
>>> Mikulas
>>>
>>> On Sat, 21 Dec 2024, Yu Kuai wrote:
>>>
>>>> Background
>>>>
>>>> We provide virtual machines for customers to use, which include an
>>>> important
>>>> feature: in the initial state, the disks in the virtual machine do
>>>> not occupy
>>>> actual storage space, and the data read by users is all zeros until
>>>> the user
>>>> writes data for the first time. This can save a large amount of storage.
>>>>
>>>> Problem
>>>>
>>>> However, after introducing dm-crypt, this feature has failed. Because we
>>>> expect the data read by users in the initial state to be zero, we
>>>> have to
>>>> write all zeros from dm-crypt.
>>>>
>>>> Hence we'd like to propose to bypass zero data for dm-crypt, for
>>>> example:
>>>>
>>>> before:
>>>> zero data -> encrypted zero data
>>>> decrypted zero data -> zero data
>>>> others
>>>>
>>>> after:
>>>> zero data -> zero data
>>>> decrypted zero data -> encrypted zero data
>>>> others(doesn't change)
>>>>
>>>> We'd like to hear from the community for suggestions first, before we
>>>> start. :)
>>>>
>>>> Thanks,
>>>> Kuai
>>>>
>>>
>>
>> .
>>
> 

