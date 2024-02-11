Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8461DFC4
	for <dm-devel@lists.linux.dev>; Sun, 11 Feb 2024 19:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707681547; cv=none; b=LmmXpgYbtS6s5JBs5nPh+ucBVOnTFQuv9S6XPu/CIACC0KO/65aTK8P/IvIVFGdVixhfh2mzdDMhAYE2bAO1ZQSInBocFt/xB7iT954LC9Whnd9jjvrxsrdk/Gysiw+h54yIOxz8cLngmeg+YW02iwJakK5Ua6LWbuiAh6PuD+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707681547; c=relaxed/simple;
	bh=T+Y3yC0v173QxskFME6F+TyQjW3CbY53cxL4I1VK5A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfK6ASkPJZPvz09Ivdth0f6W2/PM5VRspx1q/qzr8ARIZ2YCUgKAx4ldTJ5zWNOLptXR8KTuVFmabAxInsMwmLLSU+IitpoUZhgdjmMuxFeRke9PiXxI3mfhfW+mgFBP9+z+gaHYGYD2FWtJlopa3Tytvq8saooupuCEIDHLB0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-783dc658bd9so126285185a.1
        for <dm-devel@lists.linux.dev>; Sun, 11 Feb 2024 11:59:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707681545; x=1708286345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nqNjkt1HFR0hujdDQvGjKA90RZsyD+WBrok5zBF9+dI=;
        b=dH74XOC/0c+mzHiR+mikAbZ/h0lP0XXLdF8+CIqifOVe0uJJXhU6O/Hs7kKPco+upM
         lEaoToB4O1+u1duqJBaAiVz1NYIjBJ+hDnWQM58YBJl2tEHiLi8NZjeLqXMvBx8jmkpA
         KGNhnEuUlP0pn0sOp8u0rJGHZMBUgWwSsuW594G/XOxN/A+RZZ87zV4h1SZk43rnDopZ
         ea/QdESYkJZ2J5zP0abe6o7XOBwJ+rYqVH2UEPia2jZ0ci0yk735eyww+7/D47/F+5OO
         ox5Pienq5fPTTs7N5ctGhGdkrk7BRQKqMIuts6ZR/5Hxdx8KPXD9SJb7YUq7V7xu4Qnd
         F2jQ==
X-Gm-Message-State: AOJu0Yy2k58KOeBC4SiqF9w9NgHO0AqgIr/R+WuPio/ytZpgT5S/+1oY
	Q3ZuZyvrpRZqsTEjzbDE8XVX6jHpEte7SGiojridbI6o6YFuLNzNf1c8CVPDNg==
X-Google-Smtp-Source: AGHT+IFE8/v4vPRnBfQlKGQlP/Acrgy3R3PG2bUWQ6oe13RSP0K1j/aq4e1oTIdwgdtpJmjT5s3f2w==
X-Received: by 2002:a05:620a:a03:b0:785:9236:6947 with SMTP id i3-20020a05620a0a0300b0078592366947mr5898496qka.57.1707681544816;
        Sun, 11 Feb 2024 11:59:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXIOQ0CI9zzM/6AcTVchlhxodzrT40xxJoLktobnRyh8iM3A90QZTaLKI5SMFf5UFVV4HM3p424EjHlqLGaZHewDCjM1POy0k4=
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id v15-20020a05620a122f00b00785d3729eb0sm473484qkj.41.2024.02.11.11.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Feb 2024 11:59:04 -0800 (PST)
Date: Sun, 11 Feb 2024 14:59:03 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: msakai@redhat.com, dm-devel@lists.linux.dev
Subject: Re: [bug report] dm vdo: add flush support
Message-ID: <ZcknB66hlxVFOBi4@redhat.com>
References: <c91e8c15-d418-419c-aebe-078bd8f12687@moroto.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c91e8c15-d418-419c-aebe-078bd8f12687@moroto.mountain>

On Fri, Feb 09 2024 at  3:48P -0500,
Dan Carpenter <dan.carpenter@linaro.org> wrote:

> Hello Matthew Sakai,
> 
> The patch 7d7084389ab3: "dm vdo: add flush support" from Nov 16, 2023
> (linux-next), leads to the following Smatch static checker warning:
> 
> 	drivers/md/dm-vdo/flush.c:114 allocate_flush()
> 	error: uninitialized symbol 'flush'.
> 
> drivers/md/dm-vdo/flush.c
>     101 static void *allocate_flush(gfp_t gfp_mask, void *pool_data)
>     102 {
>     103         struct vdo_flush *flush;
>     104 
>     105         if ((gfp_mask & GFP_NOWAIT) == GFP_NOWAIT) {
>     106                 flush = uds_allocate_memory_nowait(sizeof(struct vdo_flush), __func__);
>     107         } else {
>     108                 int result = uds_allocate(1, struct vdo_flush, __func__, &flush);
>     109 
>     110                 if (result != VDO_SUCCESS)
>     111                         uds_log_error_strerror(result, "failed to allocate spare flush");
> 
> In real life, uds_allocate_memory() isn't going to fail here, but
> if it did then "flush" isn't initialized...
> 
>     112         }
>     113 
> --> 114         if (flush != NULL) {
>     115                 struct flusher *flusher = pool_data;
>     116 
>     117                 vdo_initialize_completion(&flush->completion, flusher->vdo,
>     118                                           VDO_FLUSH_COMPLETION);
>     119         }
>     120 
>     121         return flush;
>     122 }
> 
> regards,
> dan carpenter
> 

I've fixed this and added your Reported-by

Thanks,
Mike
