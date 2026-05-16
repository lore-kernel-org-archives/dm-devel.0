Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283A237BE8E
	for <dm-devel@lists.linux.dev>; Sat, 16 May 2026 12:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778933884; cv=none; b=t5MuRpVE79Sb9woRRsEimcAjgVsWqDajhViHQvzi1xt1koZuhDhVOSYt2hCZCQvRYCjf0EwhQG9ekPx3kVms6A7QG1D87AKCLZhrlDmlDdUajBnm9hgHc8JsrdD/q/a0FCO86Ok5FiWc7MCZRJsKBW4KWHRCBRawWoRW/Go+ZrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778933884; c=relaxed/simple;
	bh=Db7mhb9DKOULr0KFD6k/vchV59TltpGYG6dPoC2RznY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TArJnd50yLhiAy1x4Ynqt+u1aBVGm2qGlwHc+Fmex4hHiQx6vv5i7FjIOq0NDzJ3+APOcjAxAPoJN3hD6v0uf/eehPbpEZKWQIIhK1IjOV3DBrs0qad7J9yzvd+CVFb1772Gxk5T5WBZ9VwoSIDs6DJqURzMMNOEp9ws16JCQsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z1Io64v1; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z1Io64v1"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48fde648a71so4077675e9.0
        for <dm-devel@lists.linux.dev>; Sat, 16 May 2026 05:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778933881; x=1779538681; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nKg8jOwjc4StdEv3NDoZR5djOXhb/uASYMLmVlDBpgk=;
        b=Z1Io64v1ZSuZORtiUZQcphVP+Rhq/K6qBqc/ovjOOKoq2HfmSb6iV4BAgxGlT1Qwjm
         zStWF+wBq4TO+odRwZobv9Oi9M8eyI/a+BPFwA6sckWHDlsWWZU4CLOMPDbdSHuiLC/x
         7LbEj48cwNxmI3mEf4bJqDoDWaBEU5+YZB1/WDURSlYs9WNBM2txZZzGMHD8zBwYVrnB
         IYf5UNWopK95gHH+ZCei5DJRMdrvxAYOTkrOL6zQAlneFVG3RyYwh+qtxd4/jylvj7zd
         HZOG88SADRdhwMFxPCpa6oxMZsgcuLb0AjBQ9HsfG07PcBGT2+HJrrsuQLNJCThdLEDB
         I3Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778933881; x=1779538681;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKg8jOwjc4StdEv3NDoZR5djOXhb/uASYMLmVlDBpgk=;
        b=oi/N0vZQUlKvtc5BxUF0I8/cn/vj57EELob9BiQj+pDbzGEw8TYlAOH2wIQMcjoZ+g
         2Xj8KLVs12nrSauVsX87tvVnXyZcKRk7Tk3Uoz39WRsjtI2+3pIvO4ssNPa/49NkX6FI
         JX2jkvGbs4pD3aLsnjyEdQfIJAvn/4K/whUBLiWhgw/j2NVVxY0vFWukfIcPCz9OYCiT
         4jxumUmzoQVlvDjDtyyUHjsX/Yv+JP6fZUGnBPZ3diQz2a/mJfUjAcGy2U62u2kLKw0K
         xECsJJ28HfECYqARGgUkNonfk27UZ1L0Q/jKwjasJGoYU42k+mgUgxR2obGLpa3UWHCv
         wFQw==
X-Forwarded-Encrypted: i=1; AFNElJ+DBdWLZQvexirZ6envzki5c1sV6R0SLlvimiYB71JeoN8r6IeAlznb+pbMdGIgrU4QyURDeqH3nA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxyn+g+lLFo5V0aovPNbSAzal7moPgUdwyVR1zKQk1h+Y2/+HoJ
	VwgjZ9xlTUBGfbwtBvfEi5rF8nXU2LaJHbt4W3zSMkuRSwdYY1fT/fe2
X-Gm-Gg: Acq92OFGsTbTyjstemqHGVULu9AckEgAFDpNdmDbTSN7LTi9UOSZgg3NYHPa8p557h3
	+MjNW2idNi/P5ZZLRvBUMKn2PihlAxVzh9aMwvN/yLq+Y7HdOIgskQ+faBCu8Hhlac6Du0ZWDZ5
	oRF+aXVzha5V+Lcc3aQ9IPu39JCT1/oywQiMK2mE6qXcd6mFJxPHchem84tIs7B3UiX9+AfZMDe
	2NVB152RnOrqp5k2w3uLqbsin4/gJeAPuXHmVHltyf1xY2f6v1rWDUVdZIVwWnKwxCCx5ccIB2Z
	aGbvc+uctYaG7hWLY5PlYd/mzVenxvKsDNYQoWJidJYraor+6U+aqeOlqwkBUmmsrpQLqpuN+Ah
	3ujOXcg+uHjNQ8nAos8A79HvQhYIrZ4RWLKwmWJrwgjeptT9uE1BwxJUWZ3OZMgwB75rfap/e4X
	0jqZGogEeda2PypvF7AqFTNq2v6FdRGJuKa7G0qa2UugSwfd0Vj+CMC7mpLRC9amv8iA==
X-Received: by 2002:a05:600c:c0d0:b0:48a:761:5816 with SMTP id 5b1f17b1804b1-48fe53774b4mr86301855e9.8.1778933881207;
        Sat, 16 May 2026 05:18:01 -0700 (PDT)
Received: from [192.168.8.101] (37-48-49-167.nat.epc.tmcz.cz. [37.48.49.167])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5cab818sm128228785e9.14.2026.05.16.05.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 05:18:00 -0700 (PDT)
Message-ID: <3b57685a-09b4-473a-8810-bbb46769ab42@gmail.com>
Date: Sat, 16 May 2026 14:17:59 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] dm-inlinecrypt: add support for hardware-wrapped
 keys
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers <ebiggers@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260516115045.3958326-1-linlin.zhang@oss.qualcomm.com>
 <20260516115045.3958326-2-linlin.zhang@oss.qualcomm.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260516115045.3958326-2-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/26 1:50 PM, Linlin Zhang wrote:
> Add support for hardware-wrapped encryption keys to the
> dm-inlinecrypt target.
> 
> Introduce a new parameter <is_wrappedkey> to indicate whether
> the provided key is a raw key or a hardware-wrapped key. Based
> on this flag, the appropriate blk-crypto key type is selected
> when initializing the key.
> 
> This allows dm-inlinecrypt to work with hardware that requires
> keys to be wrapped and managed by the underlying inline
> encryption engine.
> 
> Update the target argument parsing accordingly and pass the
> key type to blk_crypto_init_key(). Documentation is also
> updated to reflect the new parameter and usage.
> 
> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> ---
>   .../device-mapper/dm-inlinecrypt.rst          | 10 ++-
>   drivers/md/dm-inlinecrypt.c                   | 71 +++++++++++--------
>   2 files changed, 50 insertions(+), 31 deletions(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
> index c71e600efb76..3a4ce2c5f228 100644
> --- a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
> @@ -10,7 +10,7 @@ https://docs.kernel.org/block/inline-encryption.html
>   
>   Parameters::
>   
> -	      <cipher> <key> <iv_offset> <device path> \
> +	      <cipher> <key> <is_wrappedkey> <iv_offset> <device path> \
>   	      <offset> [<#opt_params> <opt_params>]

Please use optional parameter.
Adding mandatory field will introduce unnecessary incompatibility with dm-crypt mappings.
(The idea was that you can simply switch "crypt" to "inlinecrypt" for raw keys.)

I would probably just add "hw-wrapped" or "keytype=raw|hw-wrapped" optional argument
(with raw as default, so no need so specify it).

IOW the mapping will look like this (1 is number of optional parameters):

    <cipher> <key> <iv_offset> <device path> <offset> 1 hw-wrapped
or
    <cipher> <key> <iv_offset> <device path> <offset> 1 keytype=hw-wrapped

The second option will allow to add new key type much easier.

Please check how other targets implement it, some dm-crypt examples
https://gitlab.com/cryptsetup/cryptsetup/-/wikis/DMCrypt

Thanks,
Milan

