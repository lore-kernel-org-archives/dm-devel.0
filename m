Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF3E30FC11
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 12:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763469745; cv=none; b=kG3VccEsXQGwgJZ17jaTmIHtZOGHvMQZZq4o/6gI0fZQuH83Xp/Ch2ZwPdMGEbwkuzaDcfMtrzK6R/Z/rYGje6KZ4uXLPPawErNXFrF2IA7dkIJVai0fcOfrXQOjA1I0e4M56PU4s5//NyUfCkgA86mlbKNZCoqg3uciP+PXvJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763469745; c=relaxed/simple;
	bh=A3eWYGUg+9NlLdRkr4jNbQw1dciXDZqc9zalybbz0iY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0Sr8tu1KbespoqNHP35fMTRkiUEQOU3M4qNuhhWm5Jd8qslygAhVzWQ1u1oNLJPD9wzwTyYTx5WVVrlMnYb3SxS4ujehb1/uogtxgcGKVeyMETv+0f1bQ4nkiSiHVCkat2uE9yw5zlKvEC/UPLn1+I3xIpTgNdKn59+roL/DzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XNUy9LLx; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XNUy9LLx"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59447ca49afso6852158e87.1
        for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 04:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763469742; x=1764074542; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QtA2omCvhhC8MI482XxJZXb5SFEBTy+qnOK3gJGQ5Ak=;
        b=XNUy9LLxZndQP0gXOU3jTVjKJVHiSqDgXzJ2q8KQ9di62oNDUTB/jQ055nCh3y6qp6
         r1+/T0Ehxh6njwn7Tv2mck/BCIMNc7jpv2rGLbOBOUUERd5G58pkmQS8J/Bvm5UqApHf
         4K+nl85mitf1AiaXmyT5qC+Z/5vj3ljpQNYMrHzk+PZeckmN3Q4Vu6fIWh0+jew7wROk
         /zggHyZcKWBBAIIvoZ0cp3AuYlqRQtWv0ThgMFMbvVVV+r4e+7rAeZoeaMUgziKLoVg2
         mI/Yg2GDDHZUTNx011ethdWqA+E8aAS7crR0WY5bll7OWjYckud1A8broEiFbvX89yyv
         Y6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763469742; x=1764074542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QtA2omCvhhC8MI482XxJZXb5SFEBTy+qnOK3gJGQ5Ak=;
        b=Vm4OTgmtw86xf7IrOicmV0RaXKU6bvas7KtbSXw6Nt7G40mrUzPBTS9jr3+Q4hcxwq
         HwqLVEDqC0BcHgSYt0zf0f/TieGIgcT0sa3JaVCAFUlrE5oSdeKUXLAHVY/PWIpEh5cQ
         qv04s+I2NRJHODebwdDRb92/5LsN1/tj1IJWqfiqzUBmmntdSKI4cJpZQHUJl64nF/bk
         1mWZBUWysWhxRuQxE6EmEF+nticK1mwNE8k2hH4SjrcCWQza65dtKMGRB6o9Oc6iT+vS
         jaRXFNhpJ0izZ+y3LEYZiQh/wrtlRlWOIazIolZqFpcwpCak6bFo+B0i3n+G+4eOAcoI
         3I3A==
X-Forwarded-Encrypted: i=1; AJvYcCU1x/TkQVTcoragcb1Mt5u/djOeOvz67+qyvPasahZL+iQNL8D3CAW/35gwu86p+pd6OpORohaecw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0/S5okwd3AE4VYeE24XLFbKUTdg4Gggxs2NasCCU545o3d3JQ
	SljIYRzC3sHSsIf0vSg3azV68lpPR5TdeRmRjiexNIJXkVSQ6/EkVL8L
X-Gm-Gg: ASbGncvi08WrUpymiAcOyH7QEj3GlV7RQ+Vj5o5Qi+kTHQjL5GQvk+D2ZXfcaVadabl
	SxIgtKZ/b2VS5PKddrTK6y2WyUWxFl7ZLYPehybnPo651gPo+3aZmYdEvzow61ozxrUyaUO2Gsx
	07Q/QGF6TTpz7aAIAR7/w1t6Yncs+88Q+RqNaonF6AEqYjklJcLGvuqWbKelIjjz0J3gGezTR+a
	H28B3tA3XMT/VuNQMwfmtwhfdYgK3TF+OvdF/qc3KxtqmC6YVyWp1JfDv78v5bW2Froj+dmF5Ql
	6mNo5GKcwap1Lb9B4gfN/0PTSwaFI96oWZlcL2RX0QmoQJkkoVBp5FwHpIOPLSeNkAb17mh8UzM
	Dx9iOA/K0a1HHJQHdAIVEqEVZ++asRS7oowOtW9XQrnXV8xj2qSAEfg==
X-Google-Smtp-Source: AGHT+IGadafoNdv8/E0ZXL0/MLxqF9Z9U2WdLWVoJ2s3g+20bFpVmRKZQjaatRukyCnlMqHf54sjLQ==
X-Received: by 2002:a05:6512:228b:b0:595:90ee:f480 with SMTP id 2adb3069b0e04-59590eef813mr2968394e87.16.1763469741951;
        Tue, 18 Nov 2025 04:42:21 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595803b2e26sm3960903e87.24.2025.11.18.04.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 04:42:21 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 18 Nov 2025 13:42:19 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm-bufio: align write boundary on bdev_logical_block_size
Message-ID: <aRxpq2RH3v4Dz33q@milan>
References: <20251020123350.2671495-1-urezki@gmail.com>
 <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com>
 <aRvvSvyG8AK9hiCX@redhat.com>
 <3c6ecb98-d574-9d75-a23c-fbdfa09428bf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c6ecb98-d574-9d75-a23c-fbdfa09428bf@redhat.com>

On Tue, Nov 18, 2025 at 12:15:43PM +0100, Mikulas Patocka wrote:
> 
> 
> On Mon, 17 Nov 2025, Benjamin Marzinski wrote:
> 
> > On Mon, Oct 20, 2025 at 02:48:13PM +0200, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Mon, 20 Oct 2025, Uladzislau Rezki (Sony) wrote:
> > > 
> > > > When performing a read-modify-write(RMW) operation, any modification
> > > > to a buffered block must cause the entire buffer to be marked dirty.
> > > > 
> > > > Marking only a subrange as dirty is incorrect because the underlying
> > > > device block size(ubs) defines the minimum read/write granularity. A
> > > > lower device can perform I/O only on regions which are fully aligned
> > > > and sized to ubs.
> > > 
> > > Hi
> > > 
> > > I think it would be better to fix this in dm-bufio, so that other dm-bufio 
> > > users would also benefit from the fix.
> > 
> > This looks to me like it should accomplish the same thing as
> > Uladzislau's patch. But I think there could still be problems with other
> > dm-bufio users, for devices where the blocksize is larger than 4k.
> 
> Yes, but Uladzislau said that this patch doesn't work for him. So, I 
> suspect that he has "logical_block_size" set incorrectly.
> 
Indeed. Because logical is < physical in my case. Your change does not fix
it because of I/O size is equal to physical.

--
Uladzislau Rezki
