Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F6E1632F2;
	Fri,  2 May 2025 08:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746173485; cv=none; b=NJYoXVXiKyaBL3Ztx+tfwmCHxhLwebMfeDpIfepzhL6iRlwUkaD/gfQRNsz7r8XlFrilXtsSMMTzW/HxiVZhttgbbKlFk99R0xOH0wnF5uiWayXuWEG248cIAprf5oyoQ4lyRX7N6iVePtuTTzRGf6jeA+oLg/CsGwqu9IgACow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746173485; c=relaxed/simple;
	bh=/l9WRHoddJfJFKPKt/vNBHpMtm1OJBFgkOV9dcTiSDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiniIj/znMtAD+X+o0SKwP8ic7RXJaS1uq7kWEaTEvqL+WNz4oYs8PsGJ+g5wQ2l8IJiujjRRGyNzyJTaf8FLmjPxt1n6mOI+wNBJkgxltX8NNBHQH/2Fd8tLSg285z4DTHu8s66UvZW+a1EbGC0H6HnhSBfQX70MdLjv1CK4BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so12190235e9.1;
        Fri, 02 May 2025 01:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746173482; x=1746778282;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/l9WRHoddJfJFKPKt/vNBHpMtm1OJBFgkOV9dcTiSDo=;
        b=XEaKDs0c04JyaEWlX0UF4DTQQ/A9scrZyVTWsbzNoSOiIsNZ94iIuKhyy8vRg4i1cF
         ny+IDufSnw9vXMnQpVsHLpCcGm8KX8732uJdgrmtZx/siTrCJCE4JcyFG1oUyYZA3q8t
         jHYFPjoGUjUt7D7DAhLmYNPoUj/BJcUbVbq2uIy0sOQ8rehuOWgaG/3vX7rKuyFtFy0H
         DmxqX5qn8Dr0ZiUdE3VUMZNXWWImoZpGi0E+aJoMMQwBgF6MoMjOGT7331iXIoNllL3V
         KtiKsA0t32i077zRHnVamixSb0uw5u4CwxiH8HEZDUbUR16IFQVgYXnmRazIbjc1KGJc
         37Pg==
X-Forwarded-Encrypted: i=1; AJvYcCUDkdEAVXyx7bI9Wr+G5unGFwQ2BesXJZ2yOyHGKBFi1jHAahmJC9ntpL26iK9JUFCgKvVx3TcZpw==@lists.linux.dev, AJvYcCW+3iJlWHYWFVC5WMwXtq/bHu0t1BU7qaVo14YhJ6ycOUHaG8bCy2rDTr+zZK7Q/bR30Ku33g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxfqrsbYMjUwWKo9hCJAdlTy4l9TTRAh8zXMlrWdwRvLBZxui1q
	iC7MkHIxvyX+pDwpDEQdYCvZgZSm8UCKhopiO7JBU1dXu2kK3G3m
X-Gm-Gg: ASbGncsNCMRZx8BCBZC2g0iffth3ALAOSz8/Gew9+KYJP6zkR2EQ8hRi7esIgOvFTpw
	DnKNUQEYBwQNdPQ0pFDB4KuWaXzxPRbZXa0h4P1EyROdjYe3yBgZgQuuMpr2xrfBJvlrGhuqBmG
	ndKc/T++5bMpJg61Li3qU8rzNRn+IYgAoIRzk0qYucaAUhIlC+NA+DJqEjBo/UI1tyEoPCLlclg
	oojAOWNdYUfg9tNn8zMEw6OWq05VlEZsQq5E8hrY6Nj5g57Tm6VKfFu9IuAvu+CHGc515/888mT
	kavgEYeCn7jDMN8+lPt2yZQbNXBjMx+rcfWqAzP80cbVQjZodPIjeq+n8g==
X-Google-Smtp-Source: AGHT+IF5PXSof6LicA+MgHiU22N+nB2PIEsPoZ92lRPcS/dOgUxz6GrNK7mU/Mus+h0qVk26GnapfQ==
X-Received: by 2002:a05:600c:1d99:b0:441:b19c:96fc with SMTP id 5b1f17b1804b1-441bbeb0e07mr13471465e9.11.1746173481946;
        Fri, 02 May 2025 01:11:21 -0700 (PDT)
Received: from fedora (p54ad9a78.dip0.t-ipconnect.de. [84.173.154.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b89cc441sm36983865e9.3.2025.05.02.01.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 01:11:21 -0700 (PDT)
Date: Fri, 2 May 2025 10:11:18 +0200
From: Johannes Thumshirn <jth@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, slava@dubeyko.com,
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 03/19] block: add a bio_add_max_vecs helper
Message-ID: <aBR-JiTsQj3Hv4DA@fedora>
References: <20250430212159.2865803-1-hch@lst.de>
 <20250430212159.2865803-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430212159.2865803-4-hch@lst.de>

Looks good to me,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
