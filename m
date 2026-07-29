Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C4A3B47D3
	for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 19:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785352742; cv=none; b=uIIi+AmWBO7quF7igqXSIOzTbT1hkkEAsgLzTrXVCrpahvMJHZbUuOP8jeEU3SEl7SJpN7cqiSF8VjVw1/CN4B5XuNKSs5OPKod8RfwlZDxNcjHu/xlXJu8CjUnAOKr0IFVEn59r0+jpg+CE710BFWG23aiF+B+GGVLNHmcDxaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785352742; c=relaxed/simple;
	bh=nAm+AaubmVJCxA/cyDcHaFkSO0RiDodDXMzyrjHbL/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IYlVWka+e29qna9PTGPpo1kEupNaKKkcbSXyiZeyLT8TM3df5vFwwtCI9bsPTalogFe0c0dLW6TzVqzqHZMQFTkMv1u22ONM6ZazwyBhmIWAjf8M04kViBDpiNQ4MjEUUg8RUNtB6LzRBq7ndR5Arpjn0/C0H8smZqRm2mgFbR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=k/8AjAoK; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="k/8AjAoK"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7ee4f241f42so39598a34.1
        for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 12:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785352737; x=1785957537; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jqt83cqxF1IU8PaFS5z1qjSliqQHp1IdJNxNs+7YlvU=;
        b=k/8AjAoKecHqQGMU+2e4dViI07cKwhC4ixnMBHXM9y2PE0wp5QUK8EoD7FCAl14/xR
         cHbDkDQgCwgA+OdWKbtHteH0PBeZGZv2DTaCI6RHWotU6p5VdRkE8FKRfbZzA2LRDy6v
         8Bfxroa8gOGb/XCIUZ4/lsBZo1cs/105/bcvwE9FdJnJ2O89dnuPqrnVL/GSiJimeiUH
         OOb141aRIqKZuqJ3yLyiytM2a25iJsdPKBWE6RfCYG6jBRx/oc/3bYdFqIY2OjNdSSIK
         khrYBUGin5aEPXURKaT0GWDfcvdVTqTyXWzg50gj0rjbcFTlYtOqKDb8S/RwTQVsy/ap
         1fXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785352737; x=1785957537;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jqt83cqxF1IU8PaFS5z1qjSliqQHp1IdJNxNs+7YlvU=;
        b=EIV7eJU9w5TI0Jydd9WrP26APFhWhCQpPDDnmUvcsrCiZPvjLzzV4ZIW1QwIZMPew6
         QSVZmHqbjyJ9CvJ7rSvdYC4Tw3JZ5bmlDEmG/fvoMsYKll+VGCJQWl4n8ocoN2r9xGjv
         kt7MgX95P7LwQvy6r1ZmX6dDqkz3pc86OCH9zSKjWi28WAWynLfyqXXuAMLSm7UWvSGi
         i5ZnwC8sXuSPNDS0fTlvMsDygfuoS35sb6GJPNyfU0KoQkmmtZ4zT+yzv7woY6rAXiiY
         wHBfBQHW0MJIniWvg/9gZy02NZjyOiIANKQII/PzuTixllO9MWqH8MX/ROitrvqdnLL2
         ZnGg==
X-Forwarded-Encrypted: i=1; AHgh+Rp3j0DCan9sUc8TX3uecXee5VgKE01RAXzVpgjxaLRU6vCuUr6Vi7dpEhFge7VbWlARbJMz7/nSUw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwrGvubdUVOVpnjKa9tkXtZcJGHCf3tN6iNAXpuEYWZRF2vGasF
	ReuLy7YqNE1aC5r7Xtwh1MOzcvU2795BBMRi2taHGM7EFPE10L7lGnjZSom8VfuTJYg=
X-Gm-Gg: AR+sD119hXYdK/+gkDXk/9gJAgY/UzMFOKaPj0om8Gt+aMGOAkno+pkf5CGB7kEkclF
	P7KG1+CcCHGyUl+otX6RANF6UwQ/2g6ZL96jE7hYZugydo9HjUtigsZ/byVlh3YXhkOpWM2SMyO
	yR4fWGIxg3cCUwPzufQcl86H8CXGbT6hGQu7i71p8xy0bnKbpVM+OQcXShXPQO+Mmm220hDAUYx
	dAcZRziqpVPB8dAwT8oryfGSlVX1ZAMOkW7u+5H6K530ER0oHcB50EmDfIBzfrChBU81E3UMxbA
	57X/EUShQXKNEbqQws4Vck3z65y85Mn4t9LOORMEDEZZZ6ckWrLj51Tz7knd+0ktvbDsJB+mg2n
	SOLNNc/AIk74ZJudMRYnV5C1tFBFUCb9Pzr9bqUmEvfF6Y1ByOVOWWLTkRTpdi6kq88dyQnCLcG
	cixgp1e/YQsvnk9hq9NmfPUKe17L1YuRXGEa++26qV05z3e7JnPjuZOBaHgrozJOtD59zc/wP9O
	gZF3QxlX8GrCEY=
X-Received: by 2002:a05:6820:160c:b0:6a3:d8af:6b89 with SMTP id 006d021491bc7-6aca9962397mr1376206eaf.28.1785352736967;
        Wed, 29 Jul 2026 12:18:56 -0700 (PDT)
Received: from [172.19.0.220] ([99.196.129.79])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6aca528b2b7sm2488573eaf.7.2026.07.29.12.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 12:18:56 -0700 (PDT)
Message-ID: <fbe9e74d-c389-46f4-9874-3e9ffd9c91d3@kernel.dk>
Date: Wed, 29 Jul 2026 13:18:40 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
To: Keith Busch <kbusch@kernel.org>, Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@lists.linux.dev, hch@lst.de, brauner@kernel.org, djwong@kernel.org,
 viro@zeniv.linux.org.uk
References: <20260720201057.1862857-1-kbusch@meta.com>
 <ampRQyXDbGgeg49V@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ampRQyXDbGgeg49V@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/29/26 1:15 PM, Keith Busch wrote:
> On Mon, Jul 20, 2026 at 01:10:52PM -0700, Keith Busch wrote:
>> This addresses the misaligned direct-io problem behind various threads:
> 
> Hi Jens, have you had a chance to look at this one yet? This addresses
> previous issues with certain device mappers under direct io.

I they look fine, but at this point we should toss them into 7.3. Yes
I know there are regressions around this, but from 6.1x days. And the
series doesn't apply to the current block-7.2 anyway.

What do you think?

-- 
Jens Axboe

