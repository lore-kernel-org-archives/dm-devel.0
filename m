Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA5F2580D6
	for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 16:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739205577; cv=none; b=mQYWLekQ5XzkOGfG3OyXMX3ZF8NCRlTcabdtcOdJWuPeEv6s8paiaEQSyvZqk5ozgQerZEEjiP/+Kvc5a7ZV6ypT24aT1JD6GAc0qpHw75jsh+KRSrG7IM2HL/aqIs72e0dd4E396Vfi69r59U/ZsbXBp242iSM8gGQFOv9d5BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739205577; c=relaxed/simple;
	bh=6mmyOwdswo/ISw4CqZTla6FnGNtY6+ErV29bEhEV6rQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CuHO0URnuaIY676CcqKbrh+0p//ya8IQqhCg/RTr+XZZKdkqd9/KrggxDKZe6feZBu6MTKn0BAcx9y2mHTLdbIqiH9h/mNBNUDwDoKtt2EVdQdfWmf6+sJwf/OkikY5DrKOZsDWZiarBuNsLQotOqnU18jMQnFvVn/IfuLg+I2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bd8qrtp4; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bd8qrtp4"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4364a37a1d7so45859235e9.3
        for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 08:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739205574; x=1739810374; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dw+Z+c83kKkPHc7xKtHsF+ItrwuAlXjBWz0p0h/l7Hw=;
        b=Bd8qrtp4fV89K1mUyyvJ5jLFxUPAvdw3ZK6rD4GGVUgu+74VaT1CpMVPZbNhFQY6O8
         dCPI+Hw7mstWeYbfNmP1g88ji+eiHHbDM7zN33cHNpxUpcQOae7g5Jy12iDpj/OT93Xd
         Y5wdpvJ3x8UWHpOSR+JJyLxE8SoXAWJlP30rxhwLUp7gqWxAd0pa/BXg2tgFEKKKX1HN
         9xT93aH07ELDhcZPC9dcT56P2Zo2gv8JQZyPqKqT6d4AEPhaggosxYcMPuu/jqsGa3GA
         OLvKy5MFNl/5UF+lFZFm77+JcAZMCp+9h+I6xqf5wmbkBEDJruO/id7JdNPWZ+GEaGY/
         O8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739205574; x=1739810374;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dw+Z+c83kKkPHc7xKtHsF+ItrwuAlXjBWz0p0h/l7Hw=;
        b=k11XWN1Ao3g4poKjmFhtQMXYAD0tzdD5QoUxPfyZjryqeO5utsxzd0tDD+LVrUWtMg
         XWeyAdWGtYesX67NKo+NjXg8OABGFM1GNgIfI2UCqzHkEZLd70AEhFioMWC4TeKGvz3K
         CW3vR7W5wc0DvPneVw9HrifaIL362DipHeWdq80T2z7brFTNV6tKyOlM7y5U8I1T3d5k
         37+F9vo7ziLQiIJHMt43lRJmBIpUyr7NxrslfDG6JzoL3/tifQy3iZXUHy2wIHxRBy2X
         CeUvdFrq0aj7zp6PO39upz5P/idzO3hedhmcaLlXF6nEV6i7fH7G8T/yYR0AojjwRAvq
         x2Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUPd+T+488r66MZkERFExnI5IO/KQo8GGxQFnEiYE0oF0axctVsveyVN8XvsOjkR+qTzIftgRoS+g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxYPN3JLtzQ/X0UFNXHpTqeo3QkbOAd1N2Nx84TfwFcU19WVIqU
	iGgDgVa4EHJlccCNTxvuUItVpRx0+U/sL+i67ICNGZNbq+drTlrm
X-Gm-Gg: ASbGnctaNRA76e5nSOrg2tK/o6usLRb16kYvp/LVPDQymQgErKkuZ69fwmmiEmp28oY
	h5EvjSIyrg2hDI73oFFguANbGcDtFaVnafGKPxMiwe9k5vTpD3APoIN6jM5wEQsErYvPrXlofOT
	ZWoGFPuIb1Hb5ujBguteMPktOh0iEfTVMwo5Kas+Lcty/pTJuSGX6w4W9s7aGdoNvchKaMStvbF
	WyhCxKW0yfKul3u5hMk15FQQVGH78GTAXh6VosQ1XuztrG6Xfl+xVa/SwDLpoON3CPluWVBEtdW
	0x/+AmgBAZdxHt5Ml4n0ml1ZYqgJCaY4nhcfXuad
X-Google-Smtp-Source: AGHT+IGPX7I1a+L7IY6CFs7f9l2JEitN/+IOs23Iy+LwB8c3lFQpLzyrICrojJxpu5sQ6Rq2WmQ+sg==
X-Received: by 2002:a5d:6d87:0:b0:38d:d69e:1326 with SMTP id ffacd0b85a97d-38dd69e1b18mr5605299f8f.9.1739205573726;
        Mon, 10 Feb 2025 08:39:33 -0800 (PST)
Received: from [192.168.2.22] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dd2ef7efesm7762507f8f.52.2025.02.10.08.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 08:39:33 -0800 (PST)
Message-ID: <60c1acde-839d-4d23-8270-2acf032a4ef9@gmail.com>
Date: Mon, 10 Feb 2025 17:39:32 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-verity: do forward error correction on metadata I/O
 errors
To: Mikulas Patocka <mpatocka@redhat.com>,
 Akilesh Kailash <akailash@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, kernel-team@android.com,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <629167c1-9be0-6128-8605-eb02391e821d@redhat.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <629167c1-9be0-6128-8605-eb02391e821d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/10/25 4:04 PM, Mikulas Patocka wrote:
> Do forward error correction if metadata I/O fails.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Not directly related to this patch, but...
please could you also increase the dm-verity version?

I just implemented support for the errors-as-corruption
dm-verity flags in veritysetup.

The version of dm-verity stayed at 1.10 for a very long, and
the IO error processing change was a functional change that we
would like to detect.
We cannot set version retrospectively, but at least now with other
changes.

(Veritysetup tries the requested flags; if activation fails,
it displays a better error message based on the detected
target version. That way it works even with backports.)

Thanks,
Milan


> 
> ---
>   drivers/md/dm-verity-target.c |   19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-verity-target.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-verity-target.c	2025-02-04 13:52:45.000000000 +0100
> +++ linux-2.6/drivers/md/dm-verity-target.c	2025-02-10 15:55:42.000000000 +0100
> @@ -324,8 +324,22 @@ static int verity_verify_level(struct dm
>   						&buf, bio->bi_ioprio);
>   	}
>   
> -	if (IS_ERR(data))
> -		return PTR_ERR(data);
> +	if (IS_ERR(data)) {
> +		r = PTR_ERR(data);
> +		data = dm_bufio_new(v->bufio, hash_block, &buf);
> +		if (IS_ERR(data))
> +			return r;
> +		if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
> +				      hash_block, data) == 0) {
> +			aux = dm_bufio_get_aux_data(buf);
> +			aux->hash_verified = 1;
> +			goto release_ok;
> +		} else {
> +			dm_bufio_release(buf);
> +			dm_bufio_forget(v->bufio, hash_block);
> +			return r;
> +		}
> +	}
>   
>   	aux = dm_bufio_get_aux_data(buf);
>   
> @@ -366,6 +380,7 @@ static int verity_verify_level(struct dm
>   		}
>   	}
>   
> +release_ok:
>   	data += offset;
>   	memcpy(want_digest, data, v->digest_size);
>   	r = 0;
> 

