Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AD121345
	for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 09:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740475435; cv=none; b=rv0Y3RIdVF4y8QDuYdGl/ognkkgfxwOL9GPGNqjE7aHFK9bvSHcCe8YiDqCBqx20pyT1J3AjPLzqy+M+0vbOHgKyuAfqldQQdrd6d32XpCFmTuvNnaGnoA6VCCdWlj3Fq7j+9GOQ5yMoHYpA4P8KzeHOZxys652QZhkCkSw0mRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740475435; c=relaxed/simple;
	bh=Py3+brg9yvijJ/WWLLWJ/wpfr27D7KoaSA9EbZbNv5Y=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=D1OSb8ZrdM6gAQEsvR83u1aY6DalWOiQy/8NGifG/xSYMvDFNIKPP3pBeuvvXvB0oVRU1MGbLBHQXsLPiZKmYwlReZ99cMbbxk3sStHjX4XBSqPBS71F/HI/s8kgmNmVDniijJF/jG1690qE2AjVu/mG7XUuFUQ/5MTEDksoY0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aAbrXW35; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAbrXW35"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abb86beea8cso958365866b.1
        for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 01:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740475431; x=1741080231; darn=lists.linux.dev;
        h=content-transfer-encoding:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t9rVD0HbpiKXQSOBLeLUA5bb7NNk0p1uaWDafORJ4B0=;
        b=aAbrXW35hBijFSxCMvYbP4JvHaW/s9nqgvopzlT+YorgrbYxUThmYD6zOipPP+Gmax
         pcKE2fff8pd7M9TZNHCKrg+aHFH72v6Nw1Idki+e2Lg8d0OtXrkaIuhkxujzXRN5DLCF
         EAgdKPjO+AL+z6qFaB4Jvb1uIIIcNgHjE3AvkFrVWgBjysm6Ds3e/Taiyd8qZHbbQHfS
         ARd9inrx8uckeSAGG3TsS+ZswYwTB4ZDBYaXLY4q6PrQv4KweTEgLQEhD1u64BZ6Wn9k
         R1gw+RTSX6M1dAFo/1ZdK6bIFxKtsV5a5ymBOvwbPB6XzR7irM7qf7QeQmZNSHHRtLyH
         fZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740475431; x=1741080231;
        h=content-transfer-encoding:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t9rVD0HbpiKXQSOBLeLUA5bb7NNk0p1uaWDafORJ4B0=;
        b=jlqKj7fLICrzbClhuY+04AJbqqmPoYJXyOKryo0U7v1C5uXA1UgIcQL4mACDFMgfe7
         FR2EHjXvz0uvXcod2f6pune/l2JsvjdTbcHVKfArqesCTcu6CvFQpGfHh80bqoJLRcK2
         oz36kJ7OVMUS+2UgLWt1ttOznPlfNhqrLrjrJ31V8Bglu5LHYEso9Y+8TXOsxN/2Fx7F
         WrsWpUwGGSR6QtjCT15ISZeb5ZNYt4Yu65TSHytBtkdIf+Iz8p3i9lwYRwBTc6nYGRbd
         ciStTAatDPM1yUdxacOaeEmXNnuflJWqvfxE+4sVbii7X7PsNvYwZkzXiteZ4dyiqnSw
         o3kA==
X-Forwarded-Encrypted: i=1; AJvYcCVINWQVEwIt7x3PrA1WGSf5UQ11DtnaHV1zkI6PDafPXDhYAgFegV8+lLnF7bTLNPlBR8uwAfpUQg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyAnEITVwGPDNk4H0H264A2jlIbBaQ+D1vEEs+nKv340HmAxFaw
	/dmp30BF2zare1K4HStS6sNyCenCe7uoNCVc17R+jnkbglbTZocFNDSCcvzMbAU=
X-Gm-Gg: ASbGncvEg55OkZx9rlVFY2wr+aZ94XZLqXQWx11D/NpXHnFedN5ou63cqgob4EoPf6R
	w+Fx7JXSx2ImdrJ4l2ga42eafjg8DD97B9u4qwWR+WA+fAYGnWRfQM4uwmbhI1DlsR6YzA4iHZS
	8O2EwzvkI80WZycj2++FjPgvxW4R2jEHxAhF3Gvv7nIsj/sCh7+/IxGYRQLcn+dntljb0GxhGSg
	IHXdQHABUROiAQk6HeACNb66yEG7wJtfKml8Y6YuP/jFRgHC60SarN0HtBi7wq0qeJTguxRu8QB
	yn+X9P/qFnr673N+cdRnYXBF2wiFPTcOaaB0b2ZQgqmS3FyIkw==
X-Google-Smtp-Source: AGHT+IG693op7F52mSdsKyXQAQMfwBdwER0E0yQbf1y+OR04IQ8qfJqmlwoJ2oecTszlvQNXKLgLLQ==
X-Received: by 2002:a17:907:6ea1:b0:abe:c11e:29d8 with SMTP id a640c23a62f3a-abec11e2a27mr538447166b.33.1740475430700;
        Tue, 25 Feb 2025 01:23:50 -0800 (PST)
Received: from [147.251.42.106] (fosforos.fi.muni.cz. [147.251.42.106])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1d537c3sm108970866b.38.2025.02.25.01.23.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 01:23:50 -0800 (PST)
Message-ID: <67795955-93a4-405b-b0b7-e6b5d921f35e@gmail.com>
Date: Tue, 25 Feb 2025 10:23:49 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-block <linux-block@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@infradead.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
From: Milan Broz <gmazyland@gmail.com>
Subject: sysfs integrity fields use
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I tried to add some support for using devices with PI/DIF metadata
and checked (through sysfs) how large metadata space per sector
is available.

The problem is that some values behave differently than I expected.

For an NVMe drive, reformatted to 4096 + 64 profile, I see this:

- /sys/block/<disk>/integrity/device_is_integrity_capable
   Contains 0 (?)
   According to docs, this field
  "Indicates whether a storage device is capable of storing integrity metadata.
  Set if the device is T10 PI-capable."

- /sys/block/<disk>/integrity/format
  Contains expected "nop" (not "none")

- /sys/block/<disk>/integrity/tag_size
   Contains 0 (?)
   According to docs, this is "Number of bytes of integrity tag space
   available per 512 bytes of data."
   (I think 512 bytes is incorrect; it should be sector size, or perhaps
    value in protection_interval_bytes, though.)

Then we have new (undocumented) value for NVMe in
- /sys/block/<nvme>/integrity/metadata_bytes
   This contains the correct 64.

Anyway, when I try to use it (for authentication tags in dm-crypt), it works.

Should tag_size and device_is_integrity_capable be set even for the "nop" format?
Is it a bug or a feature? :-)

If not, what is the correct way to read per-sector metadata size (not only for NVMe
as metadata_bytes is not available for other block devices)?

(This is on recent Linus' master - 6.14.0-rc4)

Thanks,
Milan
