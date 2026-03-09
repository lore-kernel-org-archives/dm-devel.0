Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B98A258EFF
	for <dm-devel@lists.linux.dev>; Mon,  9 Mar 2026 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773068777; cv=none; b=qhgXPf4KSlZmYsxKjTqnkBE3F0igOSkiYYDISnZQ49JvnD79FxjDi5dpEAAEEoatVyK0/geYO0b6dDktfsb2gmQUtSAj4M4wMUFWyORgUHfmUOywJGgCpeFTccfCrYob2eFu6D+K9BrbTiRUyfcP5sNMxMVkiZuiJVsSpeLWOg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773068777; c=relaxed/simple;
	bh=wRzvLbBGaAh9TMd/K6fo819fSxGJuZ6OqTWdUwzMPLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RdAVrmcenFS6YQqKeeByYiOe9C5HgKuHnNCto/EU6WaASAxAJuCFVH+R/mWvyo+dDVxgjKHtZmkdAnPIARcI7do6sqsAFhFaUkQayjcWGqSEauDWvhTf0s/xBPTw0Zkb88fo2wNQOqyt+RRMsifRms998l26uD3GbglKAwvJB2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K+jLq9dm; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K+jLq9dm"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50905b779dfso24592141cf.3
        for <dm-devel@lists.linux.dev>; Mon, 09 Mar 2026 08:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773068774; x=1773673574; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X/pSwYu0Cu6TqiNKu2kObY4zE6l9DNx84f7s+dA/j44=;
        b=K+jLq9dmo+84UE/WSJJUKPM/4IrFYhfKioSNBcZqmRrJCpLDwdDzCI5wGV1TPdWpUK
         9aR4CsvfEtLGxojWPhbaFnVHb1gqX969VHAYgmrn+YMbIvrRk9ZyCGQ1ocqxmwm8N6Q9
         xYMjoLBZp44AbN0cnOmKXb+6+pJz2GWx+/iL0ITRS5uIl9okx7T/Mtt+vjktqKNl6Ed8
         AiRC96RJBCgtJ2wcuW+T39bQRFTDKOUWBy+MYkSxUipb/o+kXGhgV8UwPlBo9cIu4+3L
         Erm6+2Ram9Z1OZqAf8s54Gg1i3B81eO5Hwdjf13dPe82Ii36pPR4n3/WmoroYeX9eWqK
         nreg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773068774; x=1773673574;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X/pSwYu0Cu6TqiNKu2kObY4zE6l9DNx84f7s+dA/j44=;
        b=MsNNcilph59IGQ/slg0+3wmtXknu3b98zYEW4X7w343ZCEScrK9mk9Q3ypW6ad162T
         E4ftXY4qKhZ6WPYJnEOaiokCFx9RlMqfUgmIsJvTqC3bvlQgTz0przmmBFv13ePC5zm8
         o0ifpHSDW/lyFvO56J1qDWjJr36L4CqSRtYZ+SY1JgEnBEQcyHWD0rVGd9RWtn+YwCbe
         DiwEzAmihWj5gkNhaJA/4kgpY25GsYKhtxGbz1kx1pp7f2U+PgqFbFvK7Q6A2fzoKnhA
         ehej7iL8BxcXMr8dARlGm3VrSmPSlyvPy+GIHFscBsFwzKuQCLekiGwHPUYlweV0BRrD
         jgyA==
X-Forwarded-Encrypted: i=1; AJvYcCW9Fc60RMue9zYCoOADCmkgrFmelydgOLl1DKyCPhTsYWKaCvYkPGrRyiUMzjLpyE2LRIWxDkCyjA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwOAYWD5nv5ORgLgfSn7KwaZSF0Fa/kTOcCGNDZOozqOF6TUKP7
	KOdJntQ2oAgkYiuwSaMpSobmZruzrjS2K9sHTnHncsu3mBc0w/wE8Xe+GwTtomIxQaE=
X-Gm-Gg: ATEYQzz3BcU8744BhoAS5VwcxRhtsGR9ZF20o3HUpqGwQQg2mjH37zd1QG1dAL/m8vz
	jah1JEP6MSnunlSlQPOJjtW2ueNp9PIJ1pvroS8H2UK+k/bAL0Gf6++8mMTZlCX3WaW49j1pv6B
	HUWFbBLJ5cTO02kncZFnB+29+e83Nh2KpONQPo+ksJ+hvCfeWl1bRyCjeHtruRHvoKhv+U6M+Eh
	Mmdo04oT7l0KVQg8yMai7M39dTD7vk9VxwdtXC+koO8bInCeDHbHKJi1BRlA7OI/sy7j+nA3XJ+
	Bv69+WDsEf2nQoGA8Vlf8Ifsr0EHHtls6AB14tHh5g48OqEIHjtURQIGITGvlcPLmAviYKC7bIR
	9ApsrAZzif4SfpCKhwP8uuFTe1dDpQAECQV3R4dvdwAj+Uwxmz/g3cQe5daIrU4yCEFivnGuHPm
	CnDJspPmW7g1ly9SMFzPBh02Bbh18DUz90zUPmOlPqpXpDXbeF3Q==
X-Received: by 2002:ac8:7f86:0:b0:509:17b5:654c with SMTP id d75a77b69052e-50917b56abdmr50427091cf.37.1773068774226;
        Mon, 09 Mar 2026 08:06:14 -0700 (PDT)
Received: from [172.19.0.48] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50923ed69bbsm5209671cf.28.2026.03.09.08.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 08:06:13 -0700 (PDT)
Message-ID: <4d46676d-e738-497c-b848-4278ec15d868@kernel.dk>
Date: Mon, 9 Mar 2026 09:05:56 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] block: export blk-crypto symbols required by
 dm-inlinecrypt
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
 linux-block@vger.kernel.org, ebiggers@kernel.org
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
 dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, gmazyland@gmail.com,
 israelr@nvidia.com, mpatocka@redhat.com
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <20260304121729.1532469-2-linlin.zhang@oss.qualcomm.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260304121729.1532469-2-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/4/26 5:17 AM, Linlin Zhang wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> bio_crypt_set_ctx(), blk_crypto_init_key(), and
> blk_crypto_start_using_key() are needed to use inline encryption; see
> Documentation/block/inline-encryption.rst.  Export them so that
> dm-inlinecrypt can use them.  The only reason these weren't exported
> before was that inline encryption was previously used only by fs/crypto/
> which is built-in code.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

