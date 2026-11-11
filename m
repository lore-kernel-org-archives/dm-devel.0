Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794387381;
	b=tckWkU7ZCr2Gh707ldw6mLlmgOrT64ADGI/o8Y4bDNioIVdBMli1SUyYxgEGCVwLfkZM
	 4JLQlk5CYMgKsyskIZyDUHqmQuZtt95MXDdhY3llfCcYnujGjX8O6cS7UE3JXmt39qffp
	 oipvfuKMMGPCQsUT7QDYGQJZo0yTWjnZOsze+UIMvDpl7tEIJNuiNmU4xk1+U48WHE280
	 i0K4E2maY+oLyYcS49HTzBx6z4e1tyu/WHLQ/6xTlIwGyWuTwQRslVx2lbHbPZX3Bs2IE
	 EpJ7B7e9O/pZ5PUZAtWSah2V8WBMDimF0/9Wot+WLkfbw7T8t7wlvJjGnFmZXhscD5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794387381;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=aVLNpf8cQ9pzUOUmcgcEa1Vt4E6j8oqaJeSp//hmIMs=;
	b=xKjXpnrpYNVWl01mwGeeVXZSb/N6HIIF9ZQFRwBUfsr8yy9I4Cg6TTxNvwCpYHfWhOOy
	 S1Z/3o2Sfz6KzscH8ovrHQ/W1jtrJjaQdRr3EaEFeDMbYw1in1LZQbVyC7rGputIEaJAq
	 HPcaWpmtBl+ujp7UwR2qHREldmM7YViT54dHHAKgUaAXhdfCBFY29SYYEgGVdv4R8Wt/I
	 71QOGV79oib525C8FbIOLDIvEiB+jWtdWnTMz0GO4tlDiKVejK+2mfz3qEpuS5hKP2iDo
	 YSX2wTR9unkpd77RSwkFv7eYD9zEYN4I5ScByclpdGGKwIGrfkxh9CvzZQ78fPdhfBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwGWvJFA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC252606A327;
	Wed, 11 Nov 2026 08:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bwGWvJFA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B7C1F00A05;
	Wed, 11 Nov 2026 08:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794387381;
	bh=aVLNpf8cQ9pzUOUmcgcEa1Vt4E6j8oqaJeSp//hmIMs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bwGWvJFARtML5copA5bu5AKZGa+aVnmbjMuIMU0o48JwCg6Za7kxQC67CBEqnLjg9
	 GRcs+xXNvAVGnIAXIBwS6JQgR2p5nGTn9tvuYUVZVT4XKBMx77eYIuHUQrD0CcNYyD
	 //dl9p30Hd+6wLJ9dYDYLAhNUzPyKwWF9ryppkbFoXbRDAUa77YhnJt8p9Bdb/WZQA
	 EqIRUsKiqgtkB5SPK+UMOK9PMvfrJfpY9Ef2oRdCBhaYB4dJV+SW6IuWqbsYUJXbPv
	 vEpF3RqA0s8a3VM0CoxEm5kEtB8RXdahBSOUns/Lk3oW9FDwzOcQFttu4gvp1wafBd
	 rGIfMfG7ywlIQ==
Message-ID: <b0108ede-001a-4747-b8a4-f39094083122@kernel.org>
Date: Wed, 11 Nov 2026 17:56:18 +0900
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-crypt: defer async write submission to write thread
To: Josef Schlehofer <pepe.schlehofer@gmail.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Ignat Korchagin <ignat@linux.win>, Milan Broz <gmazyland@gmail.com>
References: <20261105072708.30722-1-pepe.schlehofer@gmail.com>
 <0197be1d-1257-4597-aea2-1a065fe0a1d5@kernel.org>
 <4093292e-1fa1-dc18-b185-18dff61a32bf@redhat.com>
 <20261110042809.62987-1-pepe.schlehofer@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261110042809.62987-1-pepe.schlehofer@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/11/10 13:29, Josef Schlehofer wrote:
> On Mon, 9 Nov 2026, Mikulas Patocka wrote:
>> On Mon, 9 Nov 2026, Damien Le Moal wrote:
>>> Originally, this was added to avoid write reordering for zoned block devices.
>>> So did you test this change with that (scsi_debug or null-blk) ? You can also
>>> use an emulated NVMe ZNS device in QEMU.
>>
>> So, should we disable asynchronous crypto operations for zoned devices?
> 
> I tested dm-7.4 with and without the patch in QEMU, using null_blk,
> scsi_debug and an emulated ZNS device. I tested both cryptd and a
> synchronous cipher.
> 
> My write and read-back checks passed on both arm64 and x86_64. I also
> ran fio's t/zbd suite and blktests zbd on arm64. All tests passed with
> both kernels.

My bad. Since we switched the block layer to zone write plugging, a DM device
only ever sees a single write command per zone. So regardless of what the target
driver does with that command, things are fine for writes to zoned block
devices. The only gotcha here is that if the target driver splits the write,
then the fragments must be ordered correctly to be sequential. If I remember
correctly, I patched dm-crypt to avoid such splitting for exactly that reason.

> 
> I also used a kprobe to check whether async=1 was ever used in
> kcryptd_crypt_write_io_submit() on zoned devices. It wasn't, since
> DM_CRYPT_WRITE_INLINE keeps those writes on the async=0 path.
> 
> The only exception was blktests zbd/013, which stalled during cleanup on
> both kernels under heavy host load. The LUKS volume was still mapped
> after luksClose, causing null_blk unloading to wait.
> 
> I couldn't find any issues with this change or with async crypto on
> zoned devices, so whether to disable it is up to you and Damien.

Thanks for checking. async is fine for zoned devices. Feel free to focus on
other comments that mention that this may enable async even if the user does not
want that.

-- 
Damien Le Moal
Western Digital Research
