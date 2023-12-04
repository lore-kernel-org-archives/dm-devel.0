Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8C018E
	for <dm-devel@lists.linux.dev>; Mon,  4 Dec 2023 00:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqfdOmBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E8DC433C8;
	Mon,  4 Dec 2023 00:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701648776;
	bh=dz/Xdg63emmZLkGWSy3nNn+93DZX198gQRe7eKfauiQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YqfdOmBh0ZAZ59/GXjjqmh9PuBWZd2kx338OUvKo6b7ZhfOQqiNuFv3+nY8rXhE7n
	 vcVkjdCsBIRUnQAX4oqjpAnS3zHQ21JWAIWlH8zstDTl3Rut32A4GR851RPz3OOsWC
	 BOwnsgDmjeq3/sdQbDQ34PkQEFargihBiupW0auuZlDWBsFsxrxF3FNeyA8zMYTVUp
	 Fb5FJKHE2m8HD7lJvSDWqY0DZQG1+sc7y3OkbTEqVze1GjDyQacx+WvEbymJ3cl2uR
	 9nrqCDBq2KRmq2i2lFAyqOZrgU96HDBjXFPRHHInWJsHNG9BxtYHbPGl3+V7XB0X5a
	 uBAgdTyWM1S2w==
Message-ID: <0d40686e-786b-42f6-962b-e4806e3b7914@kernel.org>
Date: Mon, 4 Dec 2023 09:12:53 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Validate zoned model of devices built with zoned
 targets
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Naohiro Aota <Naohiro.Aota@wdc.com>
References: <20231201020329.273592-1-dlemoal@kernel.org>
 <53550076-f1ac-4f74-8d8f-6f3f8a05a230@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <53550076-f1ac-4f74-8d8f-6f3f8a05a230@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/1/23 20:09, Johannes Thumshirn wrote:
> On 01.12.23 03:03, Damien Le Moal wrote:
>> +	/* Count conventional and sequential zones */
>> +	noio_flag = memalloc_noio_save();
>> +	ret = dm_blk_do_report_zones(md, t, 0, nr_zones,
>> +				     dm_validate_zoned_model_cb, &zc);
>> +	memalloc_noio_restore(noio_flag);
> 
> Why do we need the memalloc_noio context here? I don't see an allocation 
> in dm_validate_zoned_model_cb.

It is not for the callback but rather for the underlying target type and from
there the underlying device drivers, which may all need to allocate memory for
the report zone (e.g. there is at least a command buffer allocated for SCSI
disks). So I prefer staying on the safe side of things here and use GFP_NOIO.

-- 
Damien Le Moal
Western Digital Research

