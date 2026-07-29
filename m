Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2B3425CF0
	for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 10:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321454; cv=none; b=Q339GXB9oXGg9/Af6dMXjuhMNx1DocYO3n4TKlTiLaVhHqVXx9e7SGm1YWgCKn+LMQdB4Tn6HeioWSXL0Ray9UoUWfNjZC0fZiX6SsMEX7MBpJc5r//ku1u5OD2/UB3G9Z5A7RV90VY5Sl2ZG9hLQJCQKh1KiWQONVzSP9ax2dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321454; c=relaxed/simple;
	bh=KMDBHWwtyZpTu40an4MnGq08B+PKsj/C5jew5swtPtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BrKfziP35DOQYRNghWlg93qE1zfJymUmZkpW094AtghdF5fPQQKQNjhvLgCMBlhoHNnIP523hK1UX5IHFZhxQOgEOaJBHyLZWZQSg+lgCI6M5h7mLOWWjDCvzNqOJ1UrA62tXs31Kz2vipQaJAecAK2Ld7s66wEc0p5KIFfln4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lZQ+kMJe; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZQ+kMJe"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c12614b81c9so141396566b.3
        for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 03:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785321450; x=1785926250; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p8KbmJYcU1SAlCdU+OP1hBT5okmuW3fRl/0GYAxB+Rg=;
        b=lZQ+kMJeAg6CY46h4VnSr+KJe26e5ll+Y1i9V8CrkY/iq+/LgogBT8JEK0kMQyRqln
         P+i3jxFYmxQ8mlT+gUOkuAYoHltIZg/Ri/AFS8nTAGN84HbQZcfpsYQ8hZWuNKWmj4iZ
         +aUtG+1FYlMKkEPTT5vIuDs3TDkIqOSg8bRDQA5fCgps++VzgZOL7tqial3hYwgQMzQ+
         Q+Fr89hPCPs7Uwv6KMXNIfdK8merzMM70JSCEahtUy85O8NAO4Jdi9BPn5zS5ttrnbUJ
         6zPzaWxtPVb/ERuBlDPiQmO5f9VMQ4GmqIDJm6fEFs2IhgyC7CFRlwkYziIzfJQCa+sQ
         /gsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785321450; x=1785926250;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p8KbmJYcU1SAlCdU+OP1hBT5okmuW3fRl/0GYAxB+Rg=;
        b=OpgD45X1tdsX34IxQxZr6vtpwh2nWtVcmJUqulqNi524xGUNdpRwlkYBpjCz9CFn1s
         58cfB1XRrC2/esxQsX8r2vYsh5NdB+9Z+hcOruGD71fo/El9iWLDfH7rzLnvr5za9eqy
         uvJs9q1Z0ni9W3Mn4NXke1RrbY1CAaMqDYjjsjdk13WNgy19G3I2F5CHvXH8tG1UMTce
         wDA4M2OXzCH9wimhGrcxWKpGrqFyehkOO9KuCY4XxoWQtDj6bimG5X93lp5fTpsL/x4O
         F3hYrPfwlZn2DkVZWPk4pGWXNP2KihqVM0FUJSO5pAtnl9N62ynQkm8dLD0//4rQCN2v
         iGhg==
X-Forwarded-Encrypted: i=1; AHgh+RpCYqJhCxwuYme2msTdi31xgTGOhfvn2dH18sZkNmxaKY/kEpIOtbLxMLVFJlDyzjrhUattoQ5DNg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyk95xwXPGmY2gCKrXNmjTh0jJfATMtVwzhlbl97Wh3YypGfHob
	Emscau4qKKlsjQRFAVxyWKKq0lHsxXwjxFLNUgypRxYVihftN6OWIPFj
X-Gm-Gg: AR+sD10I1/q8glGmewiGRxryYrI3uc3ptDOhF9hEDtJCOjP4wreuZzen8zOeUazc4dH
	UA04eR+h6yYw7mcM2THu2bvGBlp0jZCln3jUitFzZ/aP/IOvfQSx0DUJ3S2XRYnMrIXPlojjkJJ
	VExYfS6HE65jnZdUoe+l2DUNLjtPmED589tlQWPUCn+zsfj871aQdr+fPb+iEbTBIVh+Ft5yRXV
	SY+i6rg8rZ2ggLPwIOIQn0tXuDts1AMpCnI/n93zGbOLRQzctQ68JrJ2zafxsvlzDIid1oLh7qu
	08LaPCp18JuCJ0jCzTi7M2uudLa4QzzhYo+iD4xSWoVlclml931zalDzROUXIUD9C1euCLO/9FO
	k/P0fUpwHCtVd7rIaQTqipLenNgNen6RydS1Q5s17mNdzOU7IbBMTO3T4XLAsXzFlzMYaPo66pY
	Fgb3mQZK2ez+DzfGKGz1nsHE61U3MAckIOBUaZnm6GY2wSXDt/zxkWEaPO0XcAgImzc1uOmAibf
	FmhmaL6gGQInQdzlEU3K59hwPHcrPS4VQ0e2pCpJQuHfjcyHavI+dSSl0vFwahfm1gCmTLI2qEJ
	7Z7Vp45DGloUM+DAgds=
X-Received: by 2002:a17:907:9617:b0:c1c:62b4:1ebf with SMTP id a640c23a62f3a-c1f721913ddmr365145166b.60.1785321449861;
        Wed, 29 Jul 2026 03:37:29 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f84026c47sm93918766b.63.2026.07.29.03.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 03:37:28 -0700 (PDT)
Message-ID: <340dd033-2a45-49e7-afd6-95dbbbf624da@gmail.com>
Date: Wed, 29 Jul 2026 11:37:19 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/14] dma-buf: introduce initial file I/O
 infrastructure
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785274111.git.asml.silence@gmail.com>
 <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com>
 <20260729065927.GA9534@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729065927.GA9534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 07:59, Christoph Hellwig wrote:
> The method name feels a bit convoluted, but given all the
> previous discussions I don't care too strongly.  I'll leave
> the dma-buf side review to those who understand it.

I assume you mean this:

+	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);

I agree, and all dma_buf_io_[ctx,map] look clunky, but I don't
see what I can drop out of the name. Suggestions? Maybe I at least
should make the fs op sth like "register_dma_buf".

-- 
Pavel Begunkov

