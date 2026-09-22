Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECE7549380
	for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085284; cv=none; b=RlsiyfZldaabyF0oYYsUfSG2so8jhXUKcADcXv4BxZ6j7SM8sMjq9aI4VXfSqXZGTKwOXQ0INOo9S99D9c0Etu6TI+YAc3TEAJpeiQ/UY3BqWEhvctSSD/iV7MkNso0VswgTkr6+bKHCR9dPrsSIUO2z6qWuWrxWd0ddkI138vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085284; c=relaxed/simple;
	bh=of1kRO6ILjWAgj4iFFg39n1f9ag2O5+deE7KCawy++g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S9Q8wpo74xL9rbFEsbI7Oa91X1ukaoPMKPwwoIy6a+7CrQU7I6p+ok3qBhssitnDJP7Ew6ByzNes/tvC7/mBmoLLl2snwL8i30AsCeL1uReR7w6a7cwqX+mrRk1YIDubM+9+1vFlbZSE+LbJyxPsmneIvN2Mehn75kc9WTcQvTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QPp3pLaj; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPp3pLaj"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b20so629809566b.3
        for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 06:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790085280; x=1790690080; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ufPZGPSZBLf6/pwvKrChnuajCoyQv+QtMvUQGkdovhk=;
        b=QPp3pLaj09AlkOTAy0Puwu7KYEYWf4YwtlolSilI+dTbZG3pl0R4beNIDY9ycehR2L
         uOmZ9mvSLrGo0pIJR4ZJIbp3Zk9jqCIsTekO0SuZCvOulOIR9uw1XusVH2kzvdMk8570
         0ANT6Uw7jwHaSxbkPn7AJsJBVEdoJUYLm1bhGmfzZhcLbt5SMmuKwbTe1cokbYHfThK4
         LK1sjU4n8MJ8GSBmdBvJaT4uVyvspsfSgSPd4b8g2AEbfQWNykmZ/E4kxgMfOAk9r+wW
         M1kEJr6VOQJVbx7EUfHDu8sBEhfx44IpZiqyscxYvi6FK0gAUgUAiJ4vPr0ggK3PBrpo
         QZ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790085280; x=1790690080;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ufPZGPSZBLf6/pwvKrChnuajCoyQv+QtMvUQGkdovhk=;
        b=qZJ7H6uNW2dbtcNCBX1ZNSgKLRs4PwCn53TPEci5zsfihZcZseYysqCo02GwYgN1b/
         T0q6rB26Ec43gXJ9xeUNznTbAI75lMXOi1clsCg3wDfwf9gLA3pHHkmuBgj+5i4JetXX
         wI5w34JhprQzSAJZeV8UInoJTrXXsPC4xEfj9QDbZoSGPRCdiUxJ2/U6goS97+Cviy66
         VplPSlJYwqjUslnr6wWNM4Qy9FoU+e2W43zF3M9HuQj08Cev7h2l/BnMx0wLRSbwXSOT
         B+qaRfAGM9yadBq7mYTn7ZSSh7T+6VJ5VviihCAPpwOUiBTKEnoNygiY3FK+fANDsxsY
         RrCg==
X-Forwarded-Encrypted: i=1; AKwUvBznKHWmvatnVpDUXJWxQzGKqB/lpFHJmm6zHI7YGGHT9tZft9kk1K82OIPPYgl+gwaEnGwObxdIXQ==@lists.linux.dev
X-Gm-Message-State: AFuF++l/roF/98yG1QqDivqdzC/obZeW1BkJrTAN3LfDLedFGkcu9wQj
	pFTm4X/78dCisFXestHijS1lrHjjTvbRQ89h7dFQGBahOgVfSAYHbakO
X-Gm-Gg: AYBFou0lSYEXbYvQoIFUQmqDCcmQo6H8U2U2GCypWuo6mIb8MS+iytvlD4TzIV7PV3k
	2foGM1bn1qKVI5jcjyCGpCgSAp3GwO3bt8Tq0s/zRj2+U4NbHmoVzsEWMoMVPHihSzuvHjCvDDY
	o+vlAgabWzggJWERZR/lCokYf7qEvhNLzyyhO8TfC5KBDvVI2P5yq4NUful8vZbr6MpZWeqhBdd
	UzLNvKz1fJS+9rjy2E2SHzdNpUEpqktFeBpzv5VmXXNSohP6sYfD/H74TPaQBHeDIXc9Rj6JRvw
	Qi+mmg/iVz0bQkucOUUC2kcLGnktjbUy7iupKTmHJUJX3g1NN63Y3ClC1qVsVUutu8yjbwFfp84
	J6Prn7o9vezWb+jQC/BmJn585PgFNW7KDE0jemPxl/NqKxSJ4Fs1ekTZ5FoVKKV0YYahhOHoseX
	gq4KUI5LK1h9reZU49+19GthT2l/nIc0WRDNe3/HO9oL3AHs/7M7Rl/VD41W1MY3t0rEvXtgb9C
	VbIa4xhvchSZRN3lNwrBEOXeoZca5+GX8W//U2KviL4r9LOTf9S3fqZXxhK+nl8hduFL+xtNRzd
	F0+KTfP0ldNMPJquLd02VRWFKsrT
X-Received: by 2002:a17:906:c111:b0:c29:f5d8:9c6d with SMTP id a640c23a62f3a-c2a15802eb7mr1217098966b.28.1790085280498;
        Tue, 22 Sep 2026 06:54:40 -0700 (PDT)
Received: from [10.54.182.141] (82-132-213-197.dab.02.net. [82.132.213.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2a9c5baa1bsm93202166b.39.2026.09.22.06.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 06:54:39 -0700 (PDT)
Message-ID: <cce62c72-278a-44d1-9cf7-e0beb0b72688@gmail.com>
Date: Tue, 22 Sep 2026 14:54:25 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/13] block: introduce dma map backed bio type
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Matthew Brost <matthew.brost@intel.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1789997898.git.asml.silence@gmail.com>
 <a3ee719abc440ca139f1a945fdaf43a45f0c6b57.1789997898.git.asml.silence@gmail.com>
 <20260922131610.GA30468@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260922131610.GA30468@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/26 14:16, Christoph Hellwig wrote:
> On Mon, Sep 21, 2026 at 02:38:48PM +0100, Pavel Begunkov wrote:
>> Premapped buffers don't require a generic bio_vec since these have
>> already been dma mapped. Repurpose the bi_io_vec space to strore dmabuf
> 
> s/strore/store/
> 
> Can you please expland on the splitting considerations a bit?  Preferably
> both in a comment for the details, and in the commit log for how we
> arrived at them and why they are fine for now?

I'll add something to the commit log, but not sure which specific
details in comments you mean. Do you want me to expand the comment
above limiting the number of segments? Maybe I should add there that
it's stricter than necessary and might cause more splitting than
necessary? This one:

/*
  * Limit by the number of segments. We don't expose the underlying
  * mapping layout, but with a known minimum segment size, any I/O
  * consisting of N full segments should be able to cover at least
  * this much.
  */

-- 
Pavel Begunkov

