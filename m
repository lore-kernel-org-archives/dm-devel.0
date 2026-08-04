Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A643E51F7
	for <dm-devel@lists.linux.dev>; Tue,  4 Aug 2026 08:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832928; cv=none; b=YW5WWeCFewdWQ85MH9yM8ZD+dSK1GUCx6R4lXeWIXjRf9jMNb5i3xIG3y17UyldNHHckzG/SZnvZSwIxHcPT4BFOGiUXBmX4ssWoZX2fXHuI7nDib/AOAi+ZwHQy1UoSr7WXBDFuOlxvPfxaoWnzOxE7X8+jMRMwCEkPC7xqsF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832928; c=relaxed/simple;
	bh=SD2jpuPrRshOPjZPDhOULtKF/IyS30DOHYKRJQ1eYRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dByDcOCCtsKdQiy4BGPsEQaflsMRCJ0Fzje4oK3bQz6OJ4tK3WlSDalDlQ3+vg3cSsSCz2ta2TemZvqIJrEuU71h7qo9Z8Y8XNefxI/jelgod0LkPCaarDhNhQdiK/e7vQik4KicWIMBD28oKPL2pUIT1YdvCeil0VAjQ6N72uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a0kzZUnV; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0kzZUnV"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8486ac3f347so753601b3a.1
        for <dm-devel@lists.linux.dev>; Tue, 04 Aug 2026 01:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785832926; x=1786437726; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U2I8sdYMfYJjOc8dSgSE9HfEVezQOKs2ggEWu0ibP00=;
        b=a0kzZUnVT1PfVHZqXXovMfZQa6ehVBNdgai+Us4KzLbh24hugR6VGvTBj9y1IHsdJv
         l3weKSYESxYQwfrZU6HS2BG8yv98dEc3Jw0ZkPM7wYocJwkcNw2JdejbqRHOjyWgVeZq
         fWJnOFeSO6DuDjGp5jR3v6neFx4gtc61Xu4e3bKRTwAP+VGPOq6X0ZQQa9GKatoszHr0
         SbzxUPsmCZ2qlOAMeEFd/lI/jb2cU1X4nWUUYLbgQ5THq5tPrHCWAL4h6KcsGeCP9jdX
         cgz658G0abpTvdomRUkWF5PivtsCDhVePafnF4Ws/uwGZyiielndby9dzyFjPOpv0TN5
         28ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785832926; x=1786437726;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U2I8sdYMfYJjOc8dSgSE9HfEVezQOKs2ggEWu0ibP00=;
        b=I1rd+VIo8CKSU4FJbV9VnkLhJgZz1bJdxX90HfW0ADOlFf0+bDd3CJeAf3EnZbVZcm
         NBv4RzVZHoqww4BXXuNCUS3HMS2HYpJGvPgSIROOI+ni5/hQ8BveqD4lhzd7YHaBUTTP
         OeOuyXevWzc0SZx3YYgucHHDRGs5fU0VfLS5idfnmF4beQASz1CAPuCnDoCc2nRthNa1
         2XckP+tTwOqDvRukjHS0z1zOzpguk6hBSA0qXZ5icU+DBu/hPqO4fmTX3Fxo9bzX6F34
         KYadENCVl91TlX2y2o4pY5+cue55TpbWX3DhfFjZVL9Aj5A8lNhAgDgP4xp+DTNPXPfp
         cvxQ==
X-Forwarded-Encrypted: i=1; AHgh+RrmKKt8ubs5ywi0b3PE7fahDbfASH140xerKVHLbrE9ND9zBls0Xhb+rZ39xQHMFJNOYAiEv5OYvw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxsKziTOKAzw6QvJQym5hWWiEyxgMn1HjLIAs7gIx7CRREk1odF
	NL4bF/cwDSOWhZCtAUlssMFeT+VU/7MKsUYVLXHOo5X7WHvXCnmeNS9E
X-Gm-Gg: AR+sD11lBCJA4ElsPta79ydi1Mj+WPxqTqvHqOVXMzJ5Y7MRh9Roh75fyoI9NCvKeD5
	yWsLHfGTWlOEgvlV1/IcO7xsl50y45/9SqQaCoXCsZyEGpkMgFFJ9xurTCkUIhPqtmedaMt9p1Y
	suUNN3JiF3nQArXHZ8UeU+3eIr9YkI2EiJSN/bj8krhhmuyIt5j0nzU5Pbi+3kZOjiWNwZmogAT
	mMHaKi6NLBBEi8EwILtXPKWzCg6ubUSCsfrxCaDSLeurH1PteNQc/b3aLtryithmOhDGBx4klVg
	Bkqifr9Vy6f+QSAVjtjb6xiLy8VdqdKi8jU8Qblo/LjU5DlIXJF2kBRM4aCBrf9ttCXXe+aWdbY
	QtOl+lExdXsqrteyCDlP1xzYHAD9xGhhY9FfhmyS5Ru+QOUsY33nYyfgep866cCovG+gwi1UYDQ
	lAYnARNwIFWek+rhrEU574HwU7jRMXJkqTCLuQDPrqbMW+bTmKI/8EqYAK5lnp9jPAOI3s2zXr7
	7kL0tPR7TZOuzTQF8SkFOSSNBDTZT3PKBla0QET8ukLmXHzPr75jQNRXbdvMPtq0cCTnj8AotBk
	1r15ke6GxojW4Pxvoh93
X-Received: by 2002:a05:6a20:9188:b0:3bf:6c27:38b with SMTP id adf61e73a8af0-3cb6c937c3amr2601207637.29.1785832926102;
        Tue, 04 Aug 2026 01:42:06 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:541b])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe39ea0a73sm4753273a12.23.2026.08.04.01.41.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 01:42:05 -0700 (PDT)
Message-ID: <53c9cf90-4284-4b6a-ab2f-1686c7461bf8@gmail.com>
Date: Tue, 4 Aug 2026 09:41:47 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/16] nvme-pci: implement dma-buf backed requests
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
References: <cover.1785596451.git.asml.silence@gmail.com>
 <CGME20260801155005epcas5p4ecdcdf532aa2c2ff4e94638eedaa435b@epcas5p4.samsung.com>
 <9e3dd1b2d71dc0f9bd556b6a6d6e48fb6a8d727b.1785596451.git.asml.silence@gmail.com>
 <c4cec417-24b8-428a-853f-4e1ff1e29a6a@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c4cec417-24b8-428a-853f-4e1ff1e29a6a@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/26 08:29, Anuj Gupta/Anuj Gupta wrote:
> On 8/1/2026 9:16 PM, Pavel Begunkov wrote:
...>> +	if (WARN_ON_ONCE(seg_shift < NVME_CTRL_PAGE_SHIFT))
>> +		return ERR_PTR(-EFAULT);
> 
> This should be 'goto err;' instead of a direct return. If this ever
> triggers, it leaks the map and already established sgt mapping.

I can change it as I'm going to respin the series anyway,
but it doesn't really matter here as it's a warning and
shouldn't happen.

-- 
Pavel Begunkov

