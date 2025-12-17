Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ACB354AE5
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765993568; cv=none; b=oi9RT6RQpz0aPIuGFgfXEHvucrolFh1ykSJz3LMhcUml5TkWlIE3pTmAVadfUSt/ZlabefJpIGDt1MbYVVhlA/3qrwdYLm/LnagS04iqrshAxDZfDmODhNv5PGKnkk8fwiQ1iHeLeIDlgMQr7cZ+txcQX1bLdjk5+TsM9/pikfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765993568; c=relaxed/simple;
	bh=w+7TCzD6jrFmuYykyBWftPJu06x8kYZBA9ocidsd7v4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/Ht/FNKW+EMxep1zQAaNrgLRzWkWZjKLxgePq+8wGzJIlzyKt2Kg+na5TnrMIP4EnStuUCiZx8Kb4G/ypI8fiVcr1/EQjedpDhS8PZNxk9ZLzh0Ie0hsehOw6sv9240un9unIIvIX+LnetBKMoSFnFsI0W7LSx9hY20PUAaKRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EVhqH0O/; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EVhqH0O/"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29f02651fccso3435ad.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 09:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765993565; x=1766598365; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k/0mi21u8KukH3RghJttpiMnNs4vxDW9KG6P0eqeKDA=;
        b=EVhqH0O/E/wC0Fd+CpnrGWLeGjE9lhU0LCxsXp6Dt6rtmBw3wQ+imoMC51CdjflLmS
         /k+GwmqVgYzEuhVzyRQInF6i+y6I4wuLCxoJbl5JYsa5ks5t5CWYLvAPdE461nVdNUt/
         Z+QyE420cOWnWwm1zrzEO7Jxk3jjZGPZWmV7QbbQsvF+Tpd281XBeIt7kCQfFL8TEyrO
         OhFCYDNXgsSX/MTVv0xaz+rBL34OqkRDnYM/dyKY3AoMi573KQoY3vCbV8w9DuNisHHU
         5cH2blYSLn7Nf7PqrO+6iKhfuWUEcglgeYxNtqN22z4iF51jFciqg1UahZLRUbcuSf48
         3UIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765993565; x=1766598365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k/0mi21u8KukH3RghJttpiMnNs4vxDW9KG6P0eqeKDA=;
        b=lsdtCSIlOG3O4kRL37yor4Z7FDLWFBmduXhksIS2m2Sd5ldIkAWu/Jm9VHsT4DQWUj
         uuT3c/aQFIWFTVdM8d72gHWXzzHoN7brJlqSc2Jk/ImZ37aMZqUJMPNhiuKok77+DHsv
         R5O5aIVHVMN7ntkEX1tSiphCHwTiKwMp1XueRNpHqZKjSDSIEL+cdqQJZH0+LUWQHoSp
         ogGDVZlAGG7MFjxG5zN49HFuGc4koHvmJ7ltJZSN4I7ZYXgxDQrPNSBXyr1G3R1AzIHz
         G4xk+o4pVHpmYFXJKHE+idoB5v295Q5IlxNgHakUXda02G8cf2t6pdyaX94l+A9lX/8W
         E1Jw==
X-Gm-Message-State: AOJu0YyFfkZuTh6Drb4UDuZIWkPitV3/1ZhctKo9MjD44FLbRQSnZ3cm
	xjMOmPcHsWk1xyqGc2AWIBEXnEqnWptI0b51A7aQHxFaTrQiBv6RaWOJm5NXFhEVMA==
X-Gm-Gg: AY/fxX5eruEdRx9DrPQZRcEgtdKnoDfOe72ewR3aFPbEQNrx92BLfSq37midSy0E8x7
	rhsjeKNnCcIYAG/PWOykxXaDbBZuY6+kTmSnJkdiEFlOg0vsq8aYDMxV+eH2TjspJU9M8UKf1EY
	wcScp05kT9KYtKdtnKUo5I6uCJkqByfZnUfE+mb89kSG2ZZMg9C2tVCVXC7hDmN9sRN9M/OOWOL
	qZ/mXEhFbc9oM66rcBcxTQvgOFCQj3KRX2Oyb/yU4kyvVuwxy4nhswNDODq50ejvf07MRsO1lKH
	pwBcw9r4CW+tYa3+5gm7iTKMgEvLcuSzuTePItfEWNyXDnof+Yss7VVytBCjg7QNUsgYQnY3exa
	70J+YmtkizJ4puVgASdUvi7N3boawLK16OioHlTJuF5nua5FOzoFLXGEwas3EBVh0AZddyi9qRi
	VeFGCrmG0mktfaOdaS675DdhyXrltz3FMvg1SbBAdQryphADmRtZPSgUo=
X-Google-Smtp-Source: AGHT+IG3OYKh9CRi8LqFdH304dtk5qxdcCH2kwSFCEJJEMqeMcUssWHrkH4WGAt2skKXNggFtsmuBA==
X-Received: by 2002:a17:902:d583:b0:297:fe6f:a26e with SMTP id d9443c01a7336-2a15f2bb3ddmr3357575ad.14.1765993565039;
        Wed, 17 Dec 2025 09:46:05 -0800 (PST)
Received: from google.com (99.181.125.34.bc.googleusercontent.com. [34.125.181.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2ccdc6293sm948085ad.34.2025.12.17.09.46.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 09:46:04 -0800 (PST)
Date: Wed, 17 Dec 2025 17:45:59 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Eran Messeri <eranm@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] dm-verity: make dm_verity_fec_io::bufs
 variable-length
Message-ID: <20251217174559.GB2944334@google.com>
References: <20251216230614.51779-1-ebiggers@kernel.org>
 <20251216230614.51779-3-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216230614.51779-3-ebiggers@kernel.org>

On Tue, Dec 16, 2025 at 03:06:09PM -0800, Eric Biggers wrote:
> When correcting a data block, the FEC code performs optimally when it
> has enough buffers to hold all the needed RS blocks.  That number of
> buffers is '1 << (v->data_dev_block_bits - DM_VERITY_FEC_BUF_RS_BITS)'.
> 
> However, since v->data_dev_block_bits isn't a compile-time constant, the
> code actually used PAGE_SHIFT instead.
> 
> With the traditional PAGE_SIZE == data_block_size == 4096, this was
> fine.  However, when PAGE_SIZE > data_block_size, this wastes space.
> E.g., with data_block_size == 4096 && PAGE_SIZE == 16384, struct
> dm_verity_fec_io is 9240 bytes, when in fact only 3096 bytes are needed.
> 
> Fix this by making dm_verity_fec_io::bufs a variable-length array.
> 
> This makes the macros DM_VERITY_FEC_BUF_MAX and
> fec_for_each_extra_buffer() no longer apply, so remove them.  Also
> remove the related macro fec_for_each_prealloc_buffer(), since
> DM_VERITY_FEC_BUF_PREALLOC is fixed at 1 and was already assumed to be 1
> (considering that mempool_alloc() shouldn't be called in a loop).

> [..]

>  static struct dm_verity_fec_io *fec_alloc_and_init_io(struct dm_verity *v)
>  {
> +	const unsigned int max_nbufs = fec_max_nbufs(v);
>  	struct dm_verity_fec *f = v->fec;
>  	struct dm_verity_fec_io *fio;
>  	unsigned int n;
>  
>  	fio = mempool_alloc(&f->fio_pool, GFP_NOIO);
>  	fio->rs = mempool_alloc(&f->rs_pool, GFP_NOIO);
>  
> -	memset(fio->bufs, 0, sizeof(fio->bufs));
> -
> -	fec_for_each_prealloc_buffer(n)
> -		fio->bufs[n] = mempool_alloc(&f->prealloc_pool, GFP_NOIO);
> +	static_assert(DM_VERITY_FEC_BUF_PREALLOC == 1);
> +	fio->bufs[0] = mempool_alloc(&f->prealloc_pool, GFP_NOIO);

Can we just remove DM_VERITY_FEC_BUF_PREALLOC completely instead?

Sami
