Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA554582CA
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 13:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983225; cv=none; b=BPfwrOrHBPbLm0uXjs9Ombv8xxRkdiWGWHEEqSUiumZMpKh5V4eGa8V1WIV/DfSJrxVw7itCZbmb0cmnVdtRMMTPqyQPgRpjS80bk2Azks5sPgTd1LcXbVus9ktf8mjvjgEay36/5xwvcRnkyr3MFvuO2yo7/tKEtntHGW2PJ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983225; c=relaxed/simple;
	bh=OySODPiskWWvzQQMx1Yq/HwVMV7iyUkBWw0BjUbVY6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PC/1zPuqx39FReeg2iFdrv6otBVGyoFDsEXYtyZzBPjoxx70G2QzL/hCZUqwAfcMrFpGhv8lkS9xWVKDJyjn7KJ/h9Vt68WVtcIpvjTr474HD5FmWpBuBTM9DUavNoJ3l9ZpnpOPHw0FWJJ3/HKPgrS+Dcv7k2NDQZBmLmG0or4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XgkGSiDs; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XgkGSiDs"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a19cba5c14so35042465e9.3
        for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 06:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791983222; x=1792588022; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k5Xx2GBklmLYql9VZXZ+CeE2dU9lwoFm77pkgYHcd38=;
        b=XgkGSiDsrqx9vpOZv5ds6vXVQ0B+rNLz2kqIV6UsZEh+iB2r86CKUQqSL/c313R8nE
         0ne4gOMPBSlqgZeW4UhVoxw8IrQmB+XjB9JY3FUqqalmQWlGqaKwzxn2IRzjxX39wt3I
         SsrQKT2QBdpP2RynKu66KlhSGEEy2UZMlvWG8w7jxcIW3yu3Zer33TWGjOr6XdWCQgKj
         EC4S1lHH4GJaK8aAV6bYdQEpvJ8x9VfOcGP5zuWc5agSvKYHWIamtaTdTTanxbBD/+dc
         i968o1qENFI+Eff0q7pdTMdqROGEDrKvlxstl6i8MxE6mm4XclLBHDvTB9cUNXh4MOjZ
         +ONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791983222; x=1792588022;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k5Xx2GBklmLYql9VZXZ+CeE2dU9lwoFm77pkgYHcd38=;
        b=hHEfCVudTy/397DQzO//cf2eLwMMoCiyYTM8SvhXio4QhdO+BhyJwrgqhfTYt3rjzy
         md9UvZ+xAglxAIn5JVk9rDKtLE7VNRm9DXEu/I/ydMaRSxe7wuve0MxBDLrMUJmt82Sj
         EwJtXHhiMo8ifSpceO1skQkrYzeEc/qNvx8axodySFvbRT437S8DY0kVGx+hm5sAA+tU
         rn7pR66LvBvGXCQPsniXapE03WYzJAZNVHoc7LKzEwOvfrhnN0xc51oE4NVsKQuOjSyx
         lSQ9DKG0XkzoRFb5gI/14L1eoTQUBxvUor5biAJbhuX8swzXz1FZfZgirtXKGTd+tWfj
         eNSg==
X-Forwarded-Encrypted: i=1; AKwUvBxodyNbDxUFg+mUybhL+qvtJcT+TfNhlIPkLF749d5hj956ZMq5lxYvo+aoFVwVdzQmK4QxL9RPRw==@lists.linux.dev
X-Gm-Message-State: AFq9FYIYcwgxUX0Hur8FZmj7Ar5L+HBZxW3hL8/xFkmldxTHlPNQwsax
	1iuh9NbEwHzlGT3DSpE5krNA1sr9VmZE8SnN4rHcRJqykYZJPrwTqlAr
X-Gm-Gg: AYBFou3y0sY9khMaAJFg0d2F18etbTIs0xZoMVyxWjGOXMuBQESEIwrs64lBtFDgjYb
	5JZz3FP+j16ho68wy9D0xECpK95KlWnaSMe1zqXyD5oLSz/4R0lfkW2f9wW+8FXowQ0TLzqJ6UM
	IEdVyztiU54bvKQAQ50RaENWE1SuAkVJ/XS3HV8RVOTl+1RIUMzxV3l/KqxbFhMxvmCI4Pa8hye
	R5LijeI+io2/RjfVq6AcGziftYidlMD3U8ro2+65gdXJwuxMiUkzn7M9BCa/CUH16tCMfzKdCAI
	fr8KPksCXdMNKKzozrkGnbNqpP2K2wORanD2+AkiltArEqXD8ve1kE82tCH9kACXAbOiBWp1SbL
	BzdxgjySZ60sCjO5Sn2tsQou1XziGyynMPPWzhVR/cV+5zbNP7LGGRQLnlPhJhwLWGA+j+uj5Vb
	X4RPqItmy6SNz6IHLtqYivnK4m+q2/l5nY/EsW+m3pS6NOc4CqxLfKO2Uu02YXCBMwJTkQqZg2q
	P6YB0uZ7cYe22pbCG6vcUNdp9JBuIeHCAd9hv6B56cTv09VvjWCxmRGthKj4GGhT5ACLDMPM3z7
	t7RzGGiUvqwQrVN3f0cpahBwu8EERvvgWsvTe3V/O7pJcPjKNw==
X-Received: by 2002:a05:600c:6994:b0:49c:dada:30b7 with SMTP id 5b1f17b1804b1-4a18e446f3bmr313643615e9.2.1791983221508;
        Wed, 14 Oct 2026 06:07:01 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b3602990sm52779585e9.0.2026.10.14.06.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 06:07:00 -0700 (PDT)
Message-ID: <8d0e7d1e-086b-413a-87de-20e21f519daa@gmail.com>
Date: Wed, 14 Oct 2026 14:06:59 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 01/13] dma-buf: introduce initial file I/O
 infrastructure
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, dm-devel@lists.linux.dev
References: <cover.1791975048.git.asml.silence@gmail.com>
 <49e24334953262e85d5616c9afde88c680e4f3a3.1791975048.git.asml.silence@gmail.com>
 <b461d367-8965-4798-b7ac-cffd4301cd1b@amd.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b461d367-8965-4798-b7ac-cffd4301cd1b@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/14/26 13:30, Christian König wrote:
> On 10/14/26 13:01, Pavel Begunkov wrote:
...>> +static void dma_buf_io_kill_map(struct dma_buf_io_ctx *ctx)
>> +{
>> +	struct dma_buf_io_map *map;
>> +
>> +	dma_resv_assert_held(ctx->dmabuf->resv);
>> +
>> +	map = rcu_dereference_protected(ctx->map,
>> +				dma_resv_held(ctx->dmabuf->resv));
>> +	if (!map)
>> +		return;
>> +
>> +	rcu_assign_pointer(ctx->map, NULL);
>> +	percpu_ref_kill(&map->refs);
>> +	/* make sure the map is not visible via ctx->map */
>> +	synchronize_rcu_expedited();
>> +	wait_for_completion(&map->drained);
>> +	dma_buf_io_map_release(map);
>> +}
>> +
>> +int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map,
>> +			struct sg_table *sgt)
> 
> You somehow forgotten the kerneldoc I asked for here.

Ah yes, missed that function. I'll add it but perhaps in a separate
patch, if you don't mind, depending whether we queue it for 7.4.

> Apart from that still looks good, but I had only time to skim over it.
-- 
Pavel Begunkov

