Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9492EB5CD
	for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 13:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332367; cv=none; b=XZt4Af4dtj01yB8psJv3VIRcGN8e16DShiHy6FhN6pWpORxtxVlJDuldIkWxu5rosQ3hWYe08gjgefiPkTRruqGECVHJVt63YG+Irq+7xftK4JVPo3fKT6bQ1Q00BvoOL7kygKwj/qw9qZCUvxl6puq6Yi8pNEMT9KK7LEgDFpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332367; c=relaxed/simple;
	bh=uY3sUepmqssMOr1jNQvyXWE6qqQrkaRqI5lsNd3E8OM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nm5kzmbZEfvmHUsSvrUNG/FCpLOZy9xvBQiZ4ywy+8lBzul/As+gOXlsS3enfzU1JDphvWL/woLC8IAG1g43gt0S0qwzS1/9uSzU+8f5bUhfP7VCcLACsaui9W9QzzbhKzikJwzmrNIntJ7m+4Pha8EyKlqJSB+/siekZZy1s/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F33epD4L; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F33epD4L"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso116088666b.1
        for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 06:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785332352; x=1785937152; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3aN3udKBcENjBD5UHxw3XhgPgHCGso1JhkYTFHwhTGI=;
        b=F33epD4LNjiDIwVPeq09mkFTLFZr7jTseFK+/hIVUR7hEdhXylwIIaAXO03Hse5uu5
         yYg809eoSjZR+x1jBNqtnU4Gs2In3YUCmwOx7IW7wdxYrSadf4h6/F5F40VLMwz17VkI
         +qhmtNSLODQpc451OeG0GDEQjfZTxT+RSjuNYhxz32/uIPTfu6RB30mIqldEw9XJcl4Y
         YGGG9EeLVnMC8CfTqUccVpiGRIBr7dJ4bZ4AOgQoIx3NqvyL/D+OGfDZ4GzpYwqJULRV
         vuZOWaOQZZf8nwXq2RpFOV2mPCNWHwiqp08hOebzwupF3hbZ1rbroISxTUiTdy/DpQPe
         PgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785332352; x=1785937152;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3aN3udKBcENjBD5UHxw3XhgPgHCGso1JhkYTFHwhTGI=;
        b=Zi/SZCPxEBvCWYXfU2rTQLJu6juNEkd76RywVyBwo8y+mW0U/LGlHEkKdO7gD1Ka1F
         6OwWd6LqZJhsnaFGKwMT1ju9FRFrwDNAaPJxAW7tIGZxwJcydcYHXTtblbdDIuqJ2GNh
         UJYQyjawCJEFtaPwmGKMewIJvwsMZBfbC1mg0R0rgK5AtjDaxMZJ2b+xkpQeJoMMPUn7
         DZD9grIkLVuQOZDYYC4Jdv2MUWuOpUTRIEHqs8D7Gy3DwPypM13/5YTW6zNwSsIE3sYh
         1FCHUeCTfTkENWErkrT+Dl8VHVmsYASzrksMkXBgw+pWaoH1cc14k/5MPDYn5U6F+rNh
         a+wg==
X-Forwarded-Encrypted: i=1; AHgh+RpmKVg9lsg8U245AsmoforytvGhFYwzzonytHDZbc9pHRjHjnlEMb/kZVi8FANZ3SuQuFE0qMSKpA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzqHFbK/xtIvYisLxigfMxEKUxGnKL4smCz2agYVonYrfbcl8Cl
	yNyBWNYLl/i4Y4BNT/AlB+/RgApx1AprqjdRGzVVSBkd9QwGHQLWNlkE
X-Gm-Gg: AR+sD12Q/lLxO8Oh7qtLVTDn/QKffNUCvuTFMzftEYLjFp3LTl3eQMk8jCH/k+Ixpq8
	w8m6BdoakSXL4DlfOduRwqEgcS8qfctdoGkwJNilZ4PyEkqaB7XkT0PmcL3R/ZuKffgG9pG00PP
	lWA86fbaLC0p+IgU9BSQPkOzgRVoH7eNkzUFRhcha9xwZ4SyFr8DW1J4HeWp1BJcj/jCI7LgDly
	16/Zgds97p2Cfh3cQ+3yaR0SnAgWclRADtbDkhFY19gHnbybh2vqRo9tG790qAoYjBhycRYKfwS
	nQPWnsxPiwtI49+QoSVzwpYdFZzuH0Iv77/8fTS3SRt7dgUEiTabt2ypaWnwLLAZM9Fm4EysvjW
	n5C+f6O9FeBV0LG72yQXmMpRWwdKSZQbcI6hPcdK1cC5jzcx8nZwCCOSHUYdED61bJ2kyh2EFE3
	+nP/2gQQO5BlvymE0ft/X62uKxfrPKLCD3JOVfqFGSSGEPWJ0+yknV/Xxm9DCkFQ7udMVkbj2Yw
	uXM8XY0/iUCI4hbDFFFl4aCmu4qLDdqAGop72yx/KYd0B7DTkiQJwL6QFgQsGt+2+ZncrobXD/Q
	x8Qk1e8RdtOZxKf6akU=
X-Received: by 2002:a17:906:f598:b0:c16:7b66:4932 with SMTP id a640c23a62f3a-c1f721bf58emr374209166b.64.1785332351629;
        Wed, 29 Jul 2026 06:39:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83f4de5bsm118685466b.29.2026.07.29.06.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 06:39:10 -0700 (PDT)
Message-ID: <dc72d46b-7b45-4beb-8e36-d810d2a94c28@gmail.com>
Date: Wed, 29 Jul 2026 14:39:01 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/14] io_uring/rsrc: extend buffer update
To: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe
 <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785274111.git.asml.silence@gmail.com>
 <CGME20260728213008epcas5p418dfc10b7ef786e162ade86d14430475@epcas5p4.samsung.com>
 <633d33d8e278999f55126794fce948343403494a.1785274111.git.asml.silence@gmail.com>
 <73317bf9-f7df-43f9-abc2-daa25a675485@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <73317bf9-f7df-43f9-abc2-daa25a675485@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 14:31, Anuj Gupta/Anuj Gupta wrote:
> On 7/29/2026 2:59 AM, Pavel Begunkov wrote:
>> @@ -882,8 +894,13 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>>    	struct io_imu_folio_data data;
>>    	bool coalesced = false;
>>    
>> -	if (!uaddr) {
>> -		if (size)
>> +	if (desc->type >= __IO_REGBUF_TYPE_MAX)
>> +		return ERR_PTR(-EINVAL);
>> +	if (!mem_is_zero(&desc->__resv, sizeof(desc->__resv)))
>> +		return ERR_PTR(-EINVAL);
> 
> desc->flags  isn't validated here, unlike __resv. nonzero flags should
> be rejected too?

good catch

-- 
Pavel Begunkov

