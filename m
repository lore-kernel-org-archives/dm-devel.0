Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A98F329395
	for <dm-devel@lists.linux.dev>; Mon,  2 Mar 2026 09:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772445043; cv=none; b=EF4HshquaFkeF/XWBwKv4Mb0Ur5y17M2aL9z3IkBxaP00K+L89IBxZc1IA4Dr9+xEfGIhizHPFFwqIdn0JeEKD2gV6Lt/D2W6eh8r94ttcGw+MRxH4nQ32VxsIqz3n6ZO/YTbcJcmRksKgIKUtryWVm+uLWHoxDGy6jguYyfN6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772445043; c=relaxed/simple;
	bh=/+8kt+qzKcbkGdWx7q+ewGochsmXBzx+ZKPYi3aIKFA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wr7Kit/jzU8ueMjB9sTp/9dQ/P0S1bZINXuhUemfDARnkgBpRfqjNBVq9EKULm1+iGyKuRHBptzhBJGgbXDnHT7o0ZkjQnqYi9hVF/mbDoaqNLepyXAlOi8vK+WKhC1B/XpFBzC3gno03+mmu32QzxvYNZYzuNg0JM1B3vE/LYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WCo4FXzG; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WCo4FXzG"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-439b6d9c981so524947f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 02 Mar 2026 01:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772445041; x=1773049841; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DjYuhTfxuStg4DusSeqMRyij4jtJ3Wp64NCtc74Pn00=;
        b=WCo4FXzGTzUyrCIMPWvq9VuWqgk8axaM5iLQBx4n0C8rzcbmJ5v52N5z2NDHrcm/6A
         4teTvgn3oYRpVqvdKxLzIjXXTsg0m4aSesJTE+zw9p4I5uw7GyX1fUbqnmDaKgicKod7
         41WwGA7Bhym6KU3vUo0AHj3ydZSRuk51S96lHLj5fVehSVe6GVphk8gQF5dadxx4MEfE
         4XDIrfTvkXwaJokU0vdzgDQ7f6tL5axa0Q66tHQFybCByfvyKUS0pkpA66kmkKmo2lcc
         lXhJvYbTinY1RBDL4GWEB8ttoOeKkPz+cqNKxDHIjiAkg0yTHmePITe4F/WlmNOXZyTS
         ngZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772445041; x=1773049841;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DjYuhTfxuStg4DusSeqMRyij4jtJ3Wp64NCtc74Pn00=;
        b=c0FPCFFywMa8JKWlcJui4+PCxTIkAce48zs5ckntzZEdSNBK4ruTCqOCNz7nIm8C9v
         n9t73K98/SWRl59EcE2y8hO3M8x2MFgiqqe+rB+TjMXgUPbC3URtWBksd/x3It4CdDJh
         1d4vAvhxeysotoYcVuiKl9VkjaX72cLdDXKm2pJx7zkr9PV0/0k641jkRVGsGeFknkJf
         hoKki4F0CkXAV+i9jWVLGyl6CHAQeDe0Hl1HO3BS0NUcmb4ViM5yeWut1jiBQjx/fRZf
         wMcQIIYqWqVgHpJTtZ3eqVKyULg4KtgMZ9aJS8ZELsRUVbBcMORqOcWetoSXgtJAweix
         R2HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaBjlXlFJHqGe7fCwFw3hSBu1z0mF8OMAqRaXTS7DTDeWOjOZPJ/Pyc9i2e2F6d2crZ1OOH+cZiw==@lists.linux.dev
X-Gm-Message-State: AOJu0YymOdq4djWBaCqAbVUN+nc5EmhniumDqWjRvoGF3Gcz8bgqh62r
	YcZCLeD/yFytIZarybbW6QcCwDk8nXnEsU8aJwxaZ/1jJqloYz/jauDc
X-Gm-Gg: ATEYQzxAZRtcxX6l8QPfjrWQZdcPbsQdeNmjBQSIn2EwJagqCMgwADvgUB+B1vLyjF0
	b1PF/Jiq1tjyAL1jH5VllFkGnLkJlI6FNXjoCHRBhbbHgKAX7xBryci2wwXAzj+6J0DQZJjoWV3
	WHMOS8VUFb7VvFWezFiwFy2bH7sQrMOzltCdQgRXvCCtKXEVDu5d5TDNu6XlsAzN+USwxUxDowJ
	4VWJmoTl8na/pAc5lZEE3H8Ni6zioI5WcqXTf/ZLrTGWCoAfSYvC9387lAm+YuoLoHYzRa/u0uf
	dNuIatRTy2FFUPERg6E/8Cwj5bQRq9R7GMDm65YRw4G2gDNfEatRUKiB5mKlsrllPvwSeBAPr3s
	+D3c4t/1hKE0wvR/ibhdIKOZUoAGliw5EUFSPrKjhFncbiohm1Mkoc4qpCS/crRR9XeZfPiJElX
	1tr1aC
X-Received: by 2002:a05:6000:2c06:b0:439:8559:98b with SMTP id ffacd0b85a97d-4399d97f826mr18969913f8f.9.1772445040626;
        Mon, 02 Mar 2026 01:50:40 -0800 (PST)
Received: from pc636 ([95.214.255.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439ad3daf89sm27054944f8f.20.2026.03.02.01.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 01:50:40 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 2 Mar 2026 10:50:38 +0100
To: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aaVdbio9nwRW4L6t@pc636>
References: <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
 <aZ3HaVuIA4Ezu1uY@tiehlicka>
 <aZ3JB5Xm3SCmJW95@tiehlicka>
 <aZ3MzxtMp2OykAQq@pc636>
 <aZ6zwMQIj-3JFQZq@pc636>
 <aZ7hJi2-iATBD6GL@tiehlicka>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ7hJi2-iATBD6GL@tiehlicka>

>
> Feel free to use this patch. But please note that I do not have any user
> so I couldn't test it. So make sure this is tested before posted for
> official inclusion.
> 
Thank you. I will properly test it and apply my fixes if needed.

--
Uladzislau Rezki
