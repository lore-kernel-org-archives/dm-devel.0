Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793753432;
	b=bo4Ke6DSuwDA68//PzYRXQ6hhCxIZoC6Twooqky9V1YfFBjvRfpIPKyw0WanwK0d+uLB
	 qqfD5NsEp6Y8miPbCFBGRVi3bJUGw2+KI65rrlYRsrGe6yDSQDzXGceOuzXOSnZwFOD6M
	 nLA/QvZtnd297jyIZ92yBF5r9h4akZcQAGMhoyQhzby5smXnC0U7R4k6MoUpmSr4/3Dmc
	 BMAvTd/f0tkEAA0xUXxjLx4EJCSz8JKVP0EqWFO9frl+3twqetO1xgu3IJst9UCKKq3sF
	 CCAYNaQWf2VWwjOzh3Lu4Z0JLAednkxnGia6+0HHKy5hffiIbD6ebWq9cgxcs8erz+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793753432;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=umzTAMpmM2XXT0BjWwg/HN9i4Q16VzBGEqlJacN1TW0=;
	b=B2RslpjRDUj9e0CLwtl3TCaaFLB+19RmPFnJuwMzEaN3gRbEfSi4H6x4NiZA+YWsHvkH
	 1fHDcKjwRveORtgBOJ0JM17obj1/k0qaQ9f3DzTnfApWIjWhUSiag5Ay92BJYg4KJtc0h
	 j7O1RNY5P4BBVQjTJH/k5roRGoq2ztDiMNWEGIcU4tKRzHrFK8k8KiIv6C9AGBcod0vk3
	 sOe6tHFbHxWy9Yy+q6+49Gl8PH0zVZiDiOiX1fvGhzFqw5CrkVvq+W8dvNyutzaOdyVi3
	 8U5f6XYRP+86A0MG1gCGMireskFkakxuJRiiitd0qhGiNiBK2dK6G/hRqC0fwPL2zrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aanHxiVw;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363AD606A31B
	for <dm-devel@lists.linux.dev>; Wed,  4 Nov 2026 00:50:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 363AD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aanHxiVw
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2eb0a52d605so30695ad.0
        for <dm-devel@lists.linux.dev>; Tue, 03 Nov 2026 16:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793753431; x=1794358231; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=umzTAMpmM2XXT0BjWwg/HN9i4Q16VzBGEqlJacN1TW0=;
        b=aanHxiVwmUwN/i+rLsVtj3Cl9txdgNZs7XLCC3lOVwDneNdEnpYp9RB9ct3L6IWI/G
         xyVFlf978PLXikz9AQqTkPM/6PQBAAzsMso//heBKzG2yS18FZQLPSBI8sERIOOv1/Ii
         iJVryr/QJcXJwBm3cEGuxytZTV260TtnfUtdf5uF8RB8cL5lK8cvyD2/dbaM3Es+bOGX
         kzUfEAQjYih5SKpHX5gjrgyoNhOYfP7lmXw3weBiPWD0qpSdczjH1rMxGYKTEFag8HHb
         JROKWfQhzyQuoaP6WPT+L1gwIDaX+cdp/4u4ZqkiWS8H12mO9UCK7yhfkUyaAxGIG+Mh
         +Iww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793753431; x=1794358231;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=umzTAMpmM2XXT0BjWwg/HN9i4Q16VzBGEqlJacN1TW0=;
        b=fKLvuegSSKrU7p/Crw7eJPa6JTFiINI+YfCthAff5fDmK8WiPxqnTq71hPdFO7ze/C
         HJTyx9zqY1SljWO0QAXJu+dJERlzxPNGvNcoMzGleiJ/l8jvIN+L1ALaipULN9KQaWte
         I5FKEFsK2wsmbvJ3Txfs1yVpR225RxTAgwl3yMnC8g7+nnQ9SIZ89YiUM4EfbH1B5Cjf
         Of+pyJd5v7nw2FXMhlMERpxlDOb20i06BpTQojF7cVuCHzvU2fTMb7p+js4ruV2iQ9c+
         Z6znsmq4N1l7Kw+mJKvcht6SjKXr7+M7cXffywIlJzI0MhbR+E0+NILaTF1nFTH5Z4MN
         OW5g==
X-Forwarded-Encrypted: i=1; AKwUvBxJig8tOplb5Qku8qKEv8y9eJln0zGRUNxVlyeCLUURaYFJ5JUIRzbLStRPRed1eF5C6iSGekyn+w==@lists.linux.dev
X-Gm-Message-State: APuU4Z/l5xE5eS2K6cADT2Gp9ap+qLecAAUyjaqlgg9qYSIv1NLw1ZuQ
	j9BMklr1VYhhCpFZ0u3FjPokXfnavdoFSt0Ol5Exbiu7zvGC8VhccEdP3LW0BUDo4w==
X-Gm-Gg: AYBFou0QeSdvhOC2nDK4K575vTn04NEWWlUDMmJeBaSP1k2d21sLVnEcJrn6zVpQcHL
	1CUUsFzecKUJ00H24lrhhrws4hgTpBAc2F+XKsiElnfsdxBHHyWPbMHI4B1TISHUZUwaqYfyqNN
	DYB2H63n0EGqCoisZpbHan/n4Opsy9vwR+/V0L3K/UX5y0HMo16zwBg8e8dWFSwkNWHc4dlwM5s
	HRFYoxPPXbf0Ikk6UbZdzx6mtDitTFGl50sOKr2t2L8uXFvsi3xfUlzuHlU9VBjde7OxCzaM+Tz
	uLgOMKK7BOsiTUpgjqGQkllQBINVWteeE1/Y/TdfQoxx/ZT0FKYoW6IztznnjAYUgNX3Pwub0cw
	kPK0OTckfEHDKTSiINHqd9Kwkd2G5orw7yyG4Dkolpg92tfYcaPuMxpkMqO2QMD6xKIwxrBQYpn
	/VphZ+X0tPPfok8QdFtyywxrSarcY+hpB7ityuOp6LAMu42Du181sT5FFBg4gv6rqdq/fcx3hNC
	T0LTNsZPU5ytqC89lnNfeQ1obAi2y/lZvEZg8uCx6a8x6ANrp0HQC/cFwWYrOfiWt5Ste1+3dTW
	9m9GxilWCP2MMd3dPJ7pbyxGMhM0ATCOtEkwiD1SxC3IHCm36KFrOUnxt7RqBS+jVJocgiLMEJB
	F
X-Received: by 2002:a17:903:4b0e:b0:2df:42af:2f9f with SMTP id d9443c01a7336-2ed08e69329mr1597975ad.1.1793753430917;
        Tue, 03 Nov 2026 16:50:30 -0800 (PST)
Received: from google.com (210.109.125.34.bc.googleusercontent.com. [34.125.109.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b07c9b0ec5sm6480537a91.16.2026.11.03.16.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 16:50:29 -0800 (PST)
Date: Wed, 4 Nov 2026 00:50:24 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Chris Wiseman <chriswiseman@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>, Christoph Hellwig <hch@lst.de>,
	LongPing Wei <weilongping@oppo.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-verity: use bdev_rw_virt() in verity_recheck()
Message-ID: <20261104005024.GA1247794@google.com>
References: <18e49db5e159b72d.3137322e32332e3235332e313736.1d9cee.0000sendgmr@google.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18e49db5e159b72d.3137322e32332e3235332e313736.1d9cee.0000sendgmr@google.com>

Hi Chris,

On Tue, Nov 03, 2026 at 06:50:28PM +0000, Chris Wiseman wrote:
> verity_ctr() creates a dedicated dm_io_client (v->io) for every
> dm-verity target, but its only caller is verity_recheck(), which reads
> a single data block into a page from v->recheck_pool after a hash
> mismatch.  Because dm_io_client_create() preallocates a mempool of 16
> bios and 16 biovec-max (4 KiB) vectors per target, each dm-verity
> target permanently pins ~70 KiB of unreclaimable slab that a single-page
> read never uses (~2.4 MiB across 35 targets on Android, or ~4.1 MiB
> across 59 targets).
> 
> Replace dm_io() in verity_recheck() with bdev_rw_virt() and remove
> v->io.  bdev_rw_virt() puts the bio and single bio_vec on the stack and
> waits for completion, while keeping v->recheck_pool per-target.
> 
> Fixes: 9177f3c0dea6 ("dm-verity: recheck the hash after a failure")
> Link: https://lore.kernel.org/dm-devel/20250423115013.4004577-1-weilongping@oppo.com/
> Signed-off-by: Chris Wiseman <chriswiseman@google.com>
> ---
> TEST (ARM64 QEMU, 59 dm-verity targets, sha256, 4K blocks, mem_profiling=1):
> 
> /proc/allocinfo growth from 0 to 35 targets (bytes):
>                                      BASE     PATCHED       DELTA
>   bio.c:biovec_init_pool        4,587,520   2,293,760  -2,293,760
>   bio.c:bioset_init             1,196,160   1,052,800    -143,360
>   dm-io.c:dm_io_client_create     107,520      53,760     -53,760
>   mempool.c:mempool_init_node      36,680      23,240     -13,440
>   Total (35 targets)            5,927,880   3,423,560  -2,504,320 (-71,552 B/target)
> 
> Unreclaimable slab saved by target count:
>    8 targets:   572,416 B (  559 KiB)
>   15 targets: 1,073,280 B (1,048 KiB)
>   35 targets: 2,504,320 B (2,446 KiB)  [SUnreclaim: BASE +8,436 kB vs PATCHED +5,960 kB]
>   59 targets: 4,221,568 B (4,123 KiB)
> 
>  drivers/md/dm-verity-target.c | 24 +++---------------------
>  drivers/md/dm-verity.h        |  2 --
>  2 files changed, 3 insertions(+), 23 deletions(-)

Looks like a nice improvement!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
