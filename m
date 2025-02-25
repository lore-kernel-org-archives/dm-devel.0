Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DD126A1BB
	for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 11:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740481387; cv=none; b=nRYaoHNHXjmXlpdFlLVvwSJJbwSvtDFTuSi/kPOh2ozl+1tzxp46kvUSQoy09bWS0Kqz3hq596Q+PfEJubhE5eusNYjLdasvL8eQwyYAbpVtMGBd9qT6EC/txum61XQkUCzId6EHXeiI3x5Td2d754WmVrses7iCAzfC52eCbqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740481387; c=relaxed/simple;
	bh=LHbv0ySp7xfDxrK4xHapFhpfYe+OzWaL/Jp6LJ1qBUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gZFKSauQUPz7zRY40aufsxpdZ9ZlXNzqTpUF3nF8N73F/qczqWZTB2Y1ZfeCx6qTvyctG3nSAnfP2i6bXnuGGc4tABnu6xYAyHUQIPmaR7X92/Sd59XXghjwW4It7XIOPVVIwsUVJJS35AhDIbe3P/iA7HVv6wU53ooboMdBvBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GaOwrVl0; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GaOwrVl0"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5dec817f453so9124364a12.2
        for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 03:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740481384; x=1741086184; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=X9PhBCHuwMSAmBjmzYgRXFDACJ3K4AQ8Leyj9gnJygE=;
        b=GaOwrVl01HV1ZI7vkmZSRkehB1FbhqJ9ZiimTU3ij35t8WHzeIQXReYUO4Dpi1RoCB
         1SXfxwRVYCAkPtDhxoVWzDhliU/TwyOvSe1c7igXhSXublcW7uTGcBG/hF9H70ayUWbP
         pcqkMT6srfkL9Rwf8uLAyBILlrSvA+NgGmT49nk9qPv8Csa/h6gnsJVNsb6kTwmW/FEa
         cf58WeUqaKiRSz0cFcWKVYcZFcdzstjd3h15jYYLGGXMdLZaMsqmFYObtpdoMOA8ZwLf
         8QU2vVFmn/16bJftKyqhFctaGxUrzmPoSiJWIj/JoulewO2OxrnEYO9TXpE+olc6p6Dn
         uROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740481384; x=1741086184;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9PhBCHuwMSAmBjmzYgRXFDACJ3K4AQ8Leyj9gnJygE=;
        b=LKYEbUNRzyihZZRJQ7eA2y8DbaVdOiBxsNMf9hTxq+u5e1x/F1HjVbCyZlODcaQqOO
         xu+4RXyxiv7J1LUTPVOZ6eF4dW3QjRsrQaykJTUxrtKwOaAcrl3AjEnkz9e/KlkpJKu0
         0ReiaNmiSDiscmdfn3pOwswpWjpqAliKTN9KQ2w7jtyyf+MJ5BpW+Q6Cmh4nF4gg/rG+
         o0Q2w5sBVn9t5ImS0zIwp5VkRUt1x4HGcxyNPpBFkJ8hXY5e9Z7qo77ys9NMe7Bv7fJG
         KxnPFXMesgxsyRRtVjbdWHf07nOGKN+AWd0U3hCjXAxhpbA2aD9BTLfutXSG3hFjthZN
         keLw==
X-Forwarded-Encrypted: i=1; AJvYcCWynyBtTgR58TNeUdPaPM8IV5odmYAk7yP8gcyeWQ9AqoKp0hHci1j9WLevNDWtAkHHwXDX7BhPww==@lists.linux.dev
X-Gm-Message-State: AOJu0YzW0R9GW2lQccuu3xBibfiCO9GCmgWiILEnIRue+VqtYPlk+eKi
	yfOVQn2FKdBUset2CuWt5zhC6CAcZ3LJ2t6KGaM831OC0VZeQO8e
X-Gm-Gg: ASbGncvqEiHLGFMSH+WK1Pm5aOOghtWXOrDUkR5MOEbnhv2ImZ8wtgfBoSBjwFDbKrB
	fK90hOZ1bECTOv7AoEQAwY/LOAIKYgklSKbIPZxLm2QdwPcEsPHsTuPITGkgkN5yv0ycSCADSyB
	9dBr2afhRrvnv0Ps4M+ZD6KzFSXoyLyh1CmIv44YQKi/fi6vKnS6umlx82hEQj+j5ip2DSYZYXB
	EAYkUILBUojPznULwqIhKZFUZ01AszVvIwhjhOmG+iRXCEjwNJIkUCRny3s6MZ3P7dOJhpkdZyh
	RzZv1fiQCAFB9u3fRmitlKBqDROOqJI5S0IslFHfRZ9+hn5XOg==
X-Google-Smtp-Source: AGHT+IEfWZbLPMPl4xzpoUMh28dOs0f97cyZOw21N18EzeoLdRVruBnMgEdxH2T6RxcFsIF+5yrnJA==
X-Received: by 2002:a05:6402:2b88:b0:5de:d6c3:111a with SMTP id 4fb4d7f45d1cf-5e0b70d034bmr14495875a12.3.1740481383698;
        Tue, 25 Feb 2025 03:03:03 -0800 (PST)
Received: from [147.251.42.106] (fosforos.fi.muni.cz. [147.251.42.106])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e460d1bcb6sm1042969a12.55.2025.02.25.03.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 03:03:03 -0800 (PST)
Message-ID: <ba3840dd-e3a7-4896-89c9-0f131bb46fa5@gmail.com>
Date: Tue, 25 Feb 2025 12:03:02 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: sysfs integrity fields use
To: Kanchan Joshi <joshi.k@samsung.com>,
 linux-block <linux-block@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@infradead.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
References: <CGME20250225092525epcas5p31dd0a19ffdfb39f3f2ce4acd1c6da7ee@epcas5p3.samsung.com>
 <67795955-93a4-405b-b0b7-e6b5d921f35e@gmail.com>
 <823d3261-671d-41cb-ab15-10a361c48bca@samsung.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <823d3261-671d-41cb-ab15-10a361c48bca@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/25 11:10 AM, Kanchan Joshi wrote:
> On 2/25/2025 2:53 PM, Milan Broz wrote:
>> Hi,
>>
>> I tried to add some support for using devices with PI/DIF metadata
>> and checked (through sysfs) how large metadata space per sector
>> is available.
>>
>> The problem is that some values behave differently than I expected.
>>
>> For an NVMe drive, reformatted to 4096 + 64 profile, I see this:
>>
>> - /sys/block/<disk>/integrity/device_is_integrity_capable
>>     Contains 0 (?)
>>     According to docs, this field
>>    "Indicates whether a storage device is capable of storing integrity
>> metadata.
>>    Set if the device is T10 PI-capable."
>>
>> - /sys/block/<disk>/integrity/format
>>    Contains expected "nop" (not "none")
>>
>> - /sys/block/<disk>/integrity/tag_size
>>     Contains 0 (?)
> 
> This and "nop" indicates that pi-type was configured to be 0?
> Maybe you can share the nvme format command as well.

Sure, it is formatted to 4k data + 64 bytes metadata profile:

# nvme id-ns -H /dev/nvme0n1
...

LBA Format  0 : Metadata Size: 0   bytes - Data Size: 512 bytes - Relative Performance: 0 Best
LBA Format  1 : Metadata Size: 8   bytes - Data Size: 512 bytes - Relative Performance: 0 Best
LBA Format  2 : Metadata Size: 0   bytes - Data Size: 4096 bytes - Relative Performance: 0 Best
LBA Format  3 : Metadata Size: 64  bytes - Data Size: 4096 bytes - Relative Performance: 0 Best (in use)

formatted with
# nvme format --lbaf=3 --force /dev/nvme0n1

>>     According to docs, this is "Number of bytes of integrity tag space
>>     available per 512 bytes of data."
>>     (I think 512 bytes is incorrect; it should be sector size, or perhaps
>>      value in protection_interval_bytes, though.)
>>
>> Then we have new (undocumented) value for NVMe in
>> - /sys/block/<nvme>/integrity/metadata_bytes
>>     This contains the correct 64.
> 
> Maybe you mean "/sys/block/>/metadata_bytes"?

Yes, it is not under integrity subdir, just copy& paste error, sorry.

Just to add - I would like to add these integrity fields also to lsblk, but there we need exact
specification where to get integrity info.

Milan

