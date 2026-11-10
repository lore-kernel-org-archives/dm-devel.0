Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794284963;
	b=hKBtKuEmMy80+E8wu70wj5DO5uBQVoteurbmQH2OdxTxqRY8WgEApsb7IrRCBm5lRYqt
	 Di/MaTSiawLnFpdcP9q6ti7o8Bfdc6XOz4Nwl+BiaZ1AF1fXYsa61C/CCDrRVG2OHeCH5
	 Fxjd0pferJ6ROYWWMgJe4hNK8VFjt61wH8IMjZdnlwr3M/oyzjWetopm8FlB3atnM/STs
	 h13SWGc647kmRs0wDHVCylqZPQbzBUO9nETINIh3UrqZ+7Y2O5Fabrb8akYZ82a8wHBk0
	 0r/c/rCpy0BqrLCTysioz8I1c4l/71XTPSlb2EiIUlMFzu3j4vgTRPyflId7/TL6mkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794284963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FxC5kQ/SMr/KLBKiPx0PdPgsfNWcYSP2FuHJsYS9WuY=;
	b=Z5jZz5vMSqK4mRbhNTuxzyJxlw4o65BH1ye3Exwu+iDjfScfvHOj1Kv9VF5Bnidc+qq6
	 nQJymin7Xa5g4zyTjgnVysb8ljJyd9yAlsq1n1erzTqXobtL8+k/AFKKKqyWpJWXDpcgn
	 Dc3UTJMhVuNvyglX0eFmQht2kiJOEQOzfDkMxD9PEW6g8aIgjRGnYSt0Qivt5HTAoZMGl
	 Fn+bIPFIGC+7ceWWHUiDeXEcvE534/oH/jqXsHTPv54GREM898tYNTqbGiF0C8dcNwp7b
	 mwo4QPg6JNBrpMCdG0xzCgiLCVguySr5OPYYFYf7je604lhyp+nfm3zZn2shyN8+2xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s4usk+wW;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8D3606A325
	for <dm-devel@lists.linux.dev>; Tue, 10 Nov 2026 04:29:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB8D3606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s4usk+wW
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so16106105e9.3
        for <dm-devel@lists.linux.dev>; Mon, 09 Nov 2026 20:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794284961; x=1794889761; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FxC5kQ/SMr/KLBKiPx0PdPgsfNWcYSP2FuHJsYS9WuY=;
        b=s4usk+wWaKVshFLpnrRW1lrn6nyQHD89X+1SSwIXycxaGZhFSoSovN6mISIHMZ15SW
         asel53yb5f5L8FMlF/U9NgXcDhesZV0TSsBJQZ4Qiw7NCnUqqPdeIQ/+ohDEIamXY1ot
         A8CR2CIATjo/X+oKvE468dUK3K9xf05vss4mpDb8qe07HrmgAbcMraiet127xtUX+wQL
         f9gJFEW+AR+4XsZeg/7ewJHO9UwoPkN3seVRIcVJtfy7aWtpRRWhFncCxLK8ijG88DHn
         kHJ55ubkuAdZ3phgbww9S8taGg4zsP7YoeO4y6R5MXDWqYr2dA7Z78WdgGByuX6/gOMf
         EDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794284961; x=1794889761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FxC5kQ/SMr/KLBKiPx0PdPgsfNWcYSP2FuHJsYS9WuY=;
        b=h/yZdEM84ePGZlHQYvTBycIm5ZHYqIqJK/PxA80+3K9P/N17fG1dt57WWvXydmIOzc
         fPz0yeqgqOoqE5sWefFhMSsZSGdFwi8JCpybOXaxcnUmEQ10rMglb/SKR+c+bs43NYui
         9pL9SnwrcaivgHrVaVIeJsEXHQWr8BWnzrA8MmRVmcfNLRW4fkbxZ10zW6OxeoSoiEwb
         napFu+NvkhvMF1aZXTKFGQ3Eo90iGl5s2SXtKcwz3ctgdX/IuwjJR4VtcngOq8jrZMwQ
         Kfm1y9FaI+gatpbj2rhKQwj8G2bgPl3g/FAvWPvlviyePtYWJzCMInS65tWGQbngCkU8
         skEg==
X-Forwarded-Encrypted: i=1; AL+hErEt4O5QNIfTKpafp0XncDjtp0pmapy6IBQUIR8rmerWo5YaAzn436sJo6bxs26/Pvvgka2CZ2ExeQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+wK4L3XjSDjBVZpROvQlurfB9XlioxG+D1zVa1C6dnjYOx5mzA
	oYFsikBQ02oHKhmKSGhW3yaf0mSQOjgq1TP8SFQVqcxNqchVG3bDlbLd
X-Gm-Gg: AYBFou18fuc8U8vMcB5yG+wgRLTaQ1VgJGs51K2gEIFmvpGT1Fu1G+M4t+ShNtG7IXf
	kcp3m7JVdWNX1lU7bcm4hznvYX5/xqgtRCyOZA/qwlDgEjyJn/LO8cApSHof2PYheU7vId+UW6g
	d3INVM4KqAFo/Xw7rWPc8ZVXDWtztIEAJj8goTL+qC3jJTtwKWS0QAzHO76K9GOjHV7YGAEn2MK
	mryv2UHphcy3Un7hGug9ofB5VEyXVAtNoy948x3PnvVLXk66OFjWqq0NJMtwgwTgCzdUytGBwEo
	X/kQ/+a5mlxV3KJATxH+9l/MK7UYnK0xY1+IPvjxdCb9rhAR7M2GGlPaaIDJAVuA3YUnNzMQQc0
	mf/OxyHGnmUhdX72ssvhMpuemc2leKVk0dlj4gwymOCW+uaz5GMtegE8Nw6TPzqJr3KTJCYwirU
	RJOpLWAV+xP5ROZM08fanTFARyVmfiPGzrUgmb45D1au6X8g06UHB9q1E3+zBFy04ajCM0PgaRY
	ZD7nDY5CaBktXKfLZLouhGCo4zoKvahEWcKotS+ZzgTKmf8BlAr7OSA0rBzL9N0+UoGp+uBZ1Qa
	CW6z7x3bmAnWjcXoMpUOiKjgBQXEDqJ3Nk/GZKvkYcstFtWVEcIXuiPtXKvk0xUCmeAc64ygOOl
	sdmewMRY0Vfl2fnbBf0bp4a9P2ab0drbXDUJGSRNNzJvi1gJNasRWRCki0ffBGGKSbfZdH495HR
	bIpcDm4EN7wl3p2hy9ASILqqGNpypNk8498sQsC3gnmWuk9TN5jHRVQg==
X-Received: by 2002:a05:600c:6089:b0:4a2:c9b:9b98 with SMTP id 5b1f17b1804b1-4ba02349f95mr17862005e9.17.1794284961165;
        Mon, 09 Nov 2026 20:29:21 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a00-1028-8388-a84e-757f-6ae5-a6fe-9693.ipv6.o2.cz. [2a00:1028:8388:a84e:757f:6ae5:a6fe:9693])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba0204ee67sm36212185e9.13.2026.11.09.20.29.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 20:29:20 -0800 (PST)
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ignat Korchagin <ignat@linux.win>,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-crypt: defer async write submission to write thread
Date: Tue, 10 Nov 2026 05:29:18 +0100
Message-ID: <20261110042809.62987-1-pepe.schlehofer@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <4093292e-1fa1-dc18-b185-18dff61a32bf@redhat.com>
References: <20261105072708.30722-1-pepe.schlehofer@gmail.com> <0197be1d-1257-4597-aea2-1a065fe0a1d5@kernel.org> <4093292e-1fa1-dc18-b185-18dff61a32bf@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 9 Nov 2026, Mikulas Patocka wrote:
> On Mon, 9 Nov 2026, Damien Le Moal wrote:
>> Originally, this was added to avoid write reordering for zoned block devices.
>> So did you test this change with that (scsi_debug or null-blk) ? You can also
>> use an emulated NVMe ZNS device in QEMU.
>
> So, should we disable asynchronous crypto operations for zoned devices?

I tested dm-7.4 with and without the patch in QEMU, using null_blk,
scsi_debug and an emulated ZNS device. I tested both cryptd and a
synchronous cipher.

My write and read-back checks passed on both arm64 and x86_64. I also
ran fio's t/zbd suite and blktests zbd on arm64. All tests passed with
both kernels.

I also used a kprobe to check whether async=1 was ever used in
kcryptd_crypt_write_io_submit() on zoned devices. It wasn't, since
DM_CRYPT_WRITE_INLINE keeps those writes on the async=0 path.

The only exception was blktests zbd/013, which stalled during cleanup on
both kernels under heavy host load. The LUKS volume was still mapped
after luksClose, causing null_blk unloading to wait.

I couldn't find any issues with this change or with async crypto on
zoned devices, so whether to disable it is up to you and Damien.

Thanks,
Josef
