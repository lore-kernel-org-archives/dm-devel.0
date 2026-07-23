Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BCA456E0A
	for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 16:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823538; cv=none; b=jkdN2A+47z6ZpIDCImrmpLu9YPaXkTf2MTYfYvs84Y+ElQjFY789PvnMppMmghzvI3AMNuIDdG3SVH8qrExoxE5AQmsH0NDowvyzN3Q4DCEs41x3P7GNdj9oHKFs/uS3Can6etZ36rinK7OgduQbqcJhsdZE/CEWdzFuVk73mvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823538; c=relaxed/simple;
	bh=YHxsgxtUFx7AHVd6ydmpOlF3rG97YJswPGaOr3zWeJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dD2NQn9/EqXkpaCVpoXiOzG8bKVOjESLqJfZBgR6gBfiQjRnwAc3I+aN9wHRBpOcUP8b7Fmn/w7s4dZyZ/a6CHKOrQx5zDoMgFX67ghJJz38u14mPFsOMe/IHOG2pu6PFdonPabNyDtbHhhK0EfLyU2wcH4+s9qBDZO/nLj8Pfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W13y/vUo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W13y/vUo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784823519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=he4u9oA2Ko3Urlm6k53SW65CO7Ao9bqZFYBQSCkJU10=;
	b=W13y/vUoLth9/l2RL/QAmHpkwLAK0Ix6S7CriiO04pmQjT4sodkqP7sA1PnipYCOzGHdnl
	EbGNWuQJ/Y+m0TJ3ynDwpJIhYtzQlFtK/q4CwHKngCjVNWi1HBiqUKYB64ZbKgbE3fyMw3
	he3SFxoIztdWVN5+TfSDA82x83mX7Ro=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-gY_jmDljOVi8PnvHDhmMRA-1; Thu, 23 Jul 2026 12:18:37 -0400
X-MC-Unique: gY_jmDljOVi8PnvHDhmMRA-1
X-Mimecast-MFC-AGG-ID: gY_jmDljOVi8PnvHDhmMRA_1784823517
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-930b571432fso100743285a.0
        for <dm-devel@lists.linux.dev>; Thu, 23 Jul 2026 09:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784823517; x=1785428317;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=he4u9oA2Ko3Urlm6k53SW65CO7Ao9bqZFYBQSCkJU10=;
        b=qJj4XoluJTzWhGIJ/kgiKDxkz223vnXxWRS+wZwJOxuUGB0J5AZP6obAVpKJK8SXpD
         6uQns/2/OuSTRdk6B7cIwEwNp0Hfyk/9x+itguX36WA3tjVq9EKxLBEaE6MDqOJziuc6
         Gh3jhlYTaJWJIPHougLkKE0A6HxQWj0n9felMYSNdNdjkAWrd3bfVOkNeC1R+bA+hodl
         6kvUYQv7/Ir28jCp1l6wamoyRSqnDfquOq2TphNrhxDiwsb9v132dhJgVCYrJ3C8dsbb
         y0jEulmzT5hSi8pngC1chdbLg1SUEDzA4FtMUzrzgzy/7rRi/y8x9vZ9iskLqdzVhgNQ
         Wa5w==
X-Forwarded-Encrypted: i=1; AHgh+RqEi6oZuZYT6iQjnmxKr8RY7rFGEwh4nuPd2xTdeTY5OMaYDGBWLWmqC62YwOAn40a4yl8phcXd6g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8u4A9cu564EHHC376NR9BhmHb7715lFO0dSnInJwJV+woFh9Y
	vuEmmyPVNv5Unt69xMAr5REWLL6jZoB8akC1Uk6OeLcXSi6KX9wRYHeeuklihxVootyF6QImuIm
	IpqlQwK0fZq4KUKnWBYufzYShGJQUfbAMZfmhQABIMIZQXNpHOhj3BV9VUbwX/U72jO3n
X-Gm-Gg: AR+sD11EkuCNQgZGS58jnHayOWgjGrkUustc8+KmbQdardVO+paxeFWyGVREMkr//vb
	+DxySFX+sozL02wf+UB9cwlP19gFfMKGW0HIoGcY2ZV+BGrQ1KZy43nYRO54EEBTIIV9iJ45wac
	V/Ji0p9rzGa0mSGruXQuyhn3/UMnMfqVqy+SKsyfnH72G70lv4/O/4ss8bfMFsr7w1Z6Wn3Ypys
	eArrj04mxLE1Kr8/45eqO96MgmrnOPjBZ0t9+CclwLm1QykXwaWAm3dzRoSzNyQghmYF16ikHVt
	py/HxW40YobQ15QMTSGZMd77mJxd/DX+Hc51q+8846Rocvy5p7QHrX1ddqVGA49cw9en57TiUwo
	KL87KKowsahROQ/xz6jw4Bt1qjAyaoF+LNLU402pu05xivO8/
X-Received: by 2002:a05:620a:bd3:b0:92b:9401:7320 with SMTP id af79cd13be357-9310468afc9mr335821985a.2.1784823517104;
        Thu, 23 Jul 2026 09:18:37 -0700 (PDT)
X-Received: by 2002:a05:620a:bd3:b0:92b:9401:7320 with SMTP id af79cd13be357-9310468afc9mr335816285a.2.1784823516488;
        Thu, 23 Jul 2026 09:18:36 -0700 (PDT)
Received: from ?IPV6:2600:4040:530f:b400:d348:ae32:97a6:8a0d? ([2600:4040:530f:b400:d348:ae32:97a6:8a0d])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f687acdasm448316785a.1.2026.07.23.09.18.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 09:18:35 -0700 (PDT)
Message-ID: <9c6bd25c-80c1-426a-b22c-5b3f3a8ae372@redhat.com>
Date: Thu, 23 Jul 2026 12:18:35 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Documentation: device-mapper: document VDO zstd
To: Rhajune Park <june@pythonplayer123.dev>, dm-devel@lists.linux.dev
References: <20260723161350.1080473-1-june@pythonplayer123.dev>
 <20260723161350.1080473-2-june@pythonplayer123.dev>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20260723161350.1080473-2-june@pythonplayer123.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j8eZmjA6MBXs_JfNA61ahFjoYdQdueBhx60q0ZJsijk_1784823517
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This is attempting to document a feature that does not exist in dm-vdo.
We cannot accept this.

Matt

On 7/23/26 12:13 PM, Rhajune Park wrote:
> document zstd compression with dm-vdo
> 
> Assisted-by: opencode:gpt-5.6-sol
> Signed-off-by: Rhajune Park <june@pythonplayer123.dev>
> ---
>   .../admin-guide/device-mapper/vdo.rst         | 21 ++++++++++++++++++-
>   1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/Documentation/admin-guide/device-mapper/vdo.rst
> index 8a67b320a97b..24a6b26bb990 100644
> --- a/Documentation/admin-guide/device-mapper/vdo.rst
> +++ b/Documentation/admin-guide/device-mapper/vdo.rst
> @@ -171,6 +171,20 @@ Miscellaneous parameters:
>   		Whether compression is enabled. The default is 'off'; the
>   		acceptable values are 'on' and 'off'.
>   
> +	compressionAlgorithm:
> +		The algorithm used to compress data. The acceptable values are
> +		'lz4' and 'zstd'; the default for a new volume is 'lz4'. The
> +		algorithm is recorded when the volume is formatted and cannot be
> +		changed afterward. If specified when loading an existing volume,
> +		it must match the recorded algorithm.
> +
> +	compressionLevel:
> +		The Zstd compression level. The default is 1; negative levels are
> +		accepted when supported by the kernel Zstd implementation. This
> +		option is invalid with LZ4. The level may be changed after fully
> +		deactivating the volume, but not by reloading an active VDO table.
> +		It does not affect the readability of data written at another level.
> +
>   Device modification
>   -------------------
>   
> @@ -178,6 +192,8 @@ A modified table may be loaded into a running, non-suspended vdo volume.
>   The modifications will take effect when the device is next resumed. The
>   modifiable parameters are <logical device size>, <physical device size>,
>   <maxDiscard>, <compression>, and <deduplication>.
> +The <compressionAlgorithm> parameter is a format-time property and is not
> +modifiable.
>   
>   If the logical device size or physical device size are changed, upon
>   successful resume vdo will store the new values and require them on future
> @@ -255,7 +271,10 @@ The messages are:
>   	config:
>   		Outputs useful vdo configuration information. Mostly used
>   		by users who want to recreate a similar VDO volume and
> -		want to know the creation configuration used.
> +		want to know the creation configuration used. Output version
> +		3 contains physicalSize, logicalSize, slabSize,
> +		compressionAlgorithm, the Zstd compressionLevel when applicable,
> +		and index configuration fields.
>   
>   	dump:
>   		Dumps many internal structures to the system log. This is

