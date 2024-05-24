Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE1B12CDA8
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716563283; cv=none; b=Ebgh4jXGYRX+gnA6o88ltKE1VGdtbylyAb1rUhM8cUL4d8ZeK+9W5HOr+ViL2XkxLMPUc1ZGqh9NQ7VmiaSTlDPxvj3rhsAleKl1r14C4dp0TuNMHXpntuqbi+BEcUh3s7vCZusas4ygMmUeOPS7QYdXJolcWUYB3c+5VwqnBpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716563283; c=relaxed/simple;
	bh=awM9KS9Hf/cTVeJFtrPxpz6mdNN+XbqzYtxxMBFvNdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txpm7MRTljgkMvSDoAEmXvTJT85R3hBU+kcYihMOKMAFlpPwchNmK27e1RDF0VERes4AxS6sY2AGK41jQkKdPyPkHU3vpCA8GUNDbJ8xsilsOnHLFJ47HtscE38pmndx+1xZjEoccFx8IgtH2QZQPbYkzR5I/J+LYXjCBGuytfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-43fb02d7eb5so4531691cf.0
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716563281; x=1717168081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woYS6Es2+y4+PibBTK1NwSLpjN0wVXLdgLw932m/a6g=;
        b=AqYisGwZaZnvfjhNm5ibTcKQdmQZ1knKqHQE2BPXJvrdqy6byp5ki95FFTlruEN44s
         d+YKU65RHoGfSnzJDnK3gPdrgI9NkhyAx/8Ok6IGdj/vId165J5aq1DV3oaDp5tZEqGj
         O20mlma8HKqw+d2/mOdzCnMdXBLEmPuIpJ1kjUx7lLETS4Lnral5r8Ts5Ayh9WLz924R
         gvX+I0qpxuLvzC5NIfN64qVWxGyvttISKvCXKT5W/B38jfqED3nLcTiDi+VcO42tD7iv
         UJo3u3dobGLc9iZ7TtPSanZqK74egUAjoFIKP0cVKW4d1+OjaYkf/vJS9o4ee/izALdV
         p34A==
X-Forwarded-Encrypted: i=1; AJvYcCUiZGtQ47Spv57BVpnCjK/2QyhnWkQJFqkO3S+VOJbykVmJkoqFigjfOHe+PeqHQ4wq0e3XFI90xtfZo+Uzc3ISntQ84PwFMVc=
X-Gm-Message-State: AOJu0YzE5ABf/FeS9mYd/HnFhRGZ5E9w+DN7lZVE2dPOMiV7gPOPPUF2
	7wrz9iGavEsp36F9XdGtXBj2XosHT+POj2RcKPDEFbKyb7OL2QIk0GTj5ruKGZI=
X-Google-Smtp-Source: AGHT+IG1Iuvd4NC6UPMP7fN3razy69NpRrviBHID81LtFhzjsTGrwfa4UB1jK8cf0LUgilv/0FkOQw==
X-Received: by 2002:a05:622a:450:b0:43b:a44:f83c with SMTP id d75a77b69052e-43fb0f0d702mr27402931cf.56.1716563280838;
        Fri, 24 May 2024 08:08:00 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43fb17f40f2sm8534081cf.44.2024.05.24.08.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:08:00 -0700 (PDT)
Date: Fri, 24 May 2024 11:07:59 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/3] dm: move setting zoned_enabled to
 dm_table_set_restrictions
Message-ID: <ZlCtT0FadH4I8dFb@kernel.org>
References: <20240524142929.817565-1-hch@lst.de>
 <20240524142929.817565-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524142929.817565-2-hch@lst.de>

On Fri, May 24, 2024 at 04:29:09PM +0200, Christoph Hellwig wrote:
> Keep it together with the rest of the zoned code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-table.c | 3 ---
>  drivers/md/dm-zone.c  | 8 +++++++-
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index cc66a27c363a65..e291b78b307b13 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -2040,9 +2040,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  		r = dm_set_zones_restrictions(t, q);
>  		if (r)
>  			return r;
> -		if (blk_queue_is_zoned(q) &&
> -		    !static_key_enabled(&zoned_enabled.key))
> -			static_branch_enable(&zoned_enabled);
>  	}
>  
>  	dm_update_crypto_profile(q, t);
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 8e6bcb0d786a1a..eb1165324ab047 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -287,7 +287,13 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>  		       queue_emulates_zone_append(q) ? "emulated" : "native");
>  	}
>  
> -	return dm_revalidate_zones(md, t);
> +	ret = dm_revalidate_zones(md, t);
> +	if (ret < 0)
> +		return 0;

Not following why you're return 0 if r < 0.

blk_revalidate_disk_zones() has quite a few negative checks that
return regular error codes, so why drop those validation errors?

> +
> +	if (!static_key_enabled(&zoned_enabled.key))
> +		static_branch_enable(&zoned_enabled);
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.43.0
> 
