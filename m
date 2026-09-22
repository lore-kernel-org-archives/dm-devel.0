Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702DB54CF55
	for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 13:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084239; cv=none; b=S0G+fhZ6wQMIeBRqlhpNPCg88jnnTcWcb8d9B3T/6eARq7McDpKrBp8DwRHipnCQ+1B5H0gJPBHBTJ4Bqq6dfjyFz78/H5lZ4eKlTEHs8R6u/ztzw1z8YSwh0CEVPm00AH+9W1D0tTX4l5m1eskTg2n+Rew5smo6uf7tYbcN1Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084239; c=relaxed/simple;
	bh=HQWVBZQ3a3dF/DEyKoutDX9guSe4Idp8wVDepJLrORk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jb6ASFiTbAa3WVRx5pCU9L55ggaupsl1nInOq2upA5XZo4N4FQHlmv+kLMmjxd7pcNUcP4L7VwgAm4/Ev+8oSJjH8Qj+r4pI+QBXSpgT38YPj1cJT1lAOL3ZCNhKIzXAlL1/rQKqMDQfpdeq23fnQILamu2Mv4pseX+J3OE5eqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Env/I37P; arc=none smtp.client-ip=74.125.228.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Env/I37P"
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aa22408406so6356833a12.3
        for <dm-devel@lists.linux.dev>; Tue, 22 Sep 2026 06:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790084236; x=1790689036; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3SSB6/4UTXtVP9h0KYT7VpnYQgkILrKgn1VnZQd7YA4=;
        b=Env/I37PJo4EqvJuOYDatu2lwSW+U7olop/wUb0DDZD5b5B4w+ieWkWFf0uvoTyITR
         f8U+SVF1GsWLePliUhimFa2WOTmMFbO2WOFAF0udIzYtZ/42M7s7RLMFhEscLHKvd3ow
         g2KJgEO5tFppPI8dx1geCd6QI4IaaWkqScdDCuilAeU2jXabV4T8jJB1YyEHrDqIwKZW
         Y0AO6LhvROy5LSzFR+UtcwNb6G+Eg65RgkFyPBY50gFEpa4Fb9afxF4VyOV/hFZL5xf8
         rxuop6mmQ9LOlZWWinpYUnwivAZTduyhwWWRwrRTMnmAVlh+PkaPl/C3hFIkVtWzlmCS
         5u3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790084236; x=1790689036;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3SSB6/4UTXtVP9h0KYT7VpnYQgkILrKgn1VnZQd7YA4=;
        b=E9hOL4iwzOlEWFmpMHMnfB+TxLHBgt2+nlAPFT7QiGD3VDAG2evDpyJ3/EpcG/+ABc
         w/Af7jJL1vAAzaPXLgwIugf3WR4gclIKk5h4s8GPlxQqDsya6Kpqbn2Pc5+pPldquZiH
         EL0uMG0jej1DW0L0TExSfKWP968tY9WKhe4/T4qb0KV0cJCzVmqjPnGuEQnD0sUVNLEd
         t40sG28Eos/gMucB43HmvoapQrkASEvQl3rBReF6ZrzG5jOyQcogx/uUUTJw+tNZSVXE
         CrNiIqo6J9r1MEkEBDIeKcGzQtcseNfJzWHZIK04bhQzETNA7GmUBmgCmvVtbOcY+0wY
         7wOg==
X-Forwarded-Encrypted: i=1; AKwUvBzmo2zp6i342Avy/AAYQeWiSGKozNg6C/iFn+pEExdGCT1MW8+Xdjr1spWHWTyFH2vvyc1dxJcJVQ==@lists.linux.dev
X-Gm-Message-State: AFuF++l6UDYMX16tUgxMOuWHxFLA9Y+EZL3Si/muRKhfd33vLGDJM2w3
	mF38MoAGTeU+SRiEAksyyHkfzPe7lKKJQMs1DlrwqSDk4nsTqUeK/2Ra
X-Gm-Gg: AYBFou1o2JmT580UklFeV1EW0NG/WMgXy4wC767+eIc8+f3YiuTCZoJM1PPOfjZWEUq
	78hiB8ssRE8aCdg5pS5oD6/eBTa3BR0tRJzEK0IUVSZAIBqYSmk1HY17aBB9k+mejnKTpQwqfCj
	x+lQGXuvVewWfcsvtvRPEFNQzq8lWp80mahSUpDYYTqwEvgDGxG9dpBioqHyp96re8LbuPeUGkc
	8gxTUfgavVftO3uZ0SKKDykbjZ6gTv+YVx7rCnZW6OKsiZOrW/XhhrUqgFevbb3v36MCa72oQHv
	HRlmTw6cu8JJB8V4VjOigxDr9cokcEYhSuzkgjjYM0NlCcbL59paRR4dft7mwXbE5RazOGdgrEY
	zgTd5ql9HUUkVbvvwrBypS7VCWnLv9DacLevB84T6L8N+SC0CjLBSetS0q+y4tfvB9cH+BumdrR
	syr17u4uizLZAPjK8smWJgd7y/BCWhjr2sDT5OzhimEWwxzA8bmuYuypOCYSm6la10Ow6wgF3hW
	LTRLZ938yfJrOmvoEO/AVYx05siS/qjEOBu4MTTZvO8yovfnJKLa7N7u4HaMLQsloFpAP+Gsr8X
	8THwDO/HgZOGCW5PaJV5WAlOIX9C
X-Received: by 2002:a17:907:6d18:b0:c29:448b:f5d0 with SMTP id a640c23a62f3a-c2a15b86ed4mr1180156066b.33.1790084235477;
        Tue, 22 Sep 2026 06:37:15 -0700 (PDT)
Received: from [10.54.182.141] (82-132-213-196.dab.02.net. [82.132.213.196])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2aa9b14925sm14081966b.19.2026.09.22.06.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 06:37:14 -0700 (PDT)
Message-ID: <d39a6dd7-cb5a-43d6-8dcb-16eb9fc95b4d@gmail.com>
Date: Tue, 22 Sep 2026 14:37:08 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/13] nvme-pci: implement dma-buf backed requests
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
 <e80c3b1e0de004eaca6c51a2a86115ac9ed36381.1789997898.git.asml.silence@gmail.com>
 <20260922132016.GA30684@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260922132016.GA30684@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christoph,

On 9/22/26 14:20, Christoph Hellwig wrote:
> On Mon, Sep 21, 2026 at 02:38:50PM +0100, Pavel Begunkov wrote:
>> Enable BIO_DMABUF_MAP backed requests. On registration we map the
> 
> This is now REQ_DMABUF.

Will change

> Sashiko had a few comments, which I think are correct - if we use
> dma_map_sg to map the data, we need to use the sync_sg APIs to
> transfer ownership.  That only matters on non-coherent architectures
> with MMU, but we need to get it right.

I've seen that and fixed everything locally that should be fixed,
apart from the sync. I wonder what we can do about that? I can
somehow replace it with the sg variant for now, but sync'ing the
entire possibly multi-GB mapping for, let's say, a 512B I/O, sounds
not wise. And I can think of another place that does mix sync_single
with sgs.

> And the reset deadlock also looks plausible.
-- 
Pavel Begunkov

