Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AC385278
	for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 15:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711035823; cv=none; b=cWQ2pvG3POt34LscjsJBswSA1PXue3hXyXBcVYO43XO5o0AfZv+87PxQs5deDZ0uzY2KFwCiy1269PgmPCiTSlb7ICpQRoJ1+7DTQyJvXzMsczNtvbaQSr+ImaVm/+SUGZFFeERUgyPHezY5e/BUZQ4SA72dHVkgv/klSGbLWT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711035823; c=relaxed/simple;
	bh=gSp680xC0RNeeCCoc2FA1eULmEXUePFkSX+nZqEsKYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fv+hSYxOtOwPCqiURFfSGWJ8L4LqMQh80z4Ko6V5b9g9orWG0LQidEyvxAk45oMwRiUzTC0SBrWumqantd9hTA/iIcL5nbDMHh2xK3JU1xAz0TvqFA3w0McoS6YNLvPeEjx357R69LBarhChtwqWagFlYhXkBxZVhq6ntlyjfRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-789d0c90cadso74900485a.3
        for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 08:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711035820; x=1711640620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SohwRnzAY7/EKReYuxq0+bkMgOj6Nes6Rrl9hVyegXg=;
        b=nJIMibjgNoAXF/uo5ppFZhh+l9dPS/aAF6iOOLEGSj5GDwjOJp3FnFIyU2T7oDurd7
         3uGyG17rA7Pcj/E9IMVR3iiCGGkiTE+0tZ7/HFtX0lR4XdKiZhlqm7i7IxM5snBAaIx6
         bQwqKuuGtVWnsPSSJIn9Kq0yGBH/IsKyN4akCmkRAbKOCJPNLUZdpHxXbrdj2huIKA0C
         JkLIZb2j8/G/BfYOvbj4s2eNosOu2EGwZFH+JYVfHdetKcB/pQ6qPs+vqTvSZLCSdul2
         xPT8GHFHREdvruqym6sN1YWUmCDjtqOxNblNNhjZRFmmhvCRAyj0ZZBAY/7oFWdzi4ts
         0hoA==
X-Forwarded-Encrypted: i=1; AJvYcCUEPJuQzp28dEGk7mapPAZM714WlC1l0MKYsvsThDri4muEH8In5iMhxEIBs2dv2DjgpQkw6YcdQjnuqk+TT0zuawi28bQ2jF4=
X-Gm-Message-State: AOJu0YxKjMgROMixxWxnUblSAHN3Q5mCy8QpKFLDCbQPF41htJha2o69
	A6N6JV06UagRZMMlIIHGn2+b3P0jIQMbarQQEIQDP98QydkZQJiQcdI0pgyzd/j+J37oYyKRl+s
	=
X-Google-Smtp-Source: AGHT+IFbHWz05LF/nva7rcl0B2EAVlFxIwvlT0fktJgaSa2L139gfknj3NqDLkJFUgJMqZ3TXPPqnQ==
X-Received: by 2002:a05:620a:841:b0:789:e987:61f6 with SMTP id u1-20020a05620a084100b00789e98761f6mr8670140qku.1.1711035819857;
        Thu, 21 Mar 2024 08:43:39 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id sq25-20020a05620a4ad900b0078a0774d1basm3435426qkn.15.2024.03.21.08.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 08:43:39 -0700 (PDT)
Date: Thu, 21 Mar 2024 11:43:38 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: block: fail unaligned bio from submit_bio_noacct()
Message-ID: <ZfxVqkniO-6jFFH5@redhat.com>
References: <20240321131634.1009972-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240321131634.1009972-1-ming.lei@redhat.com>

On Thu, Mar 21 2024 at  9:16P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> For any bio with data, its start sector and size have to be aligned with
> the queue's logical block size.
> 
> This rule is obvious, but there is still user which may send unaligned
> bio to block layer, and it is observed that dm-integrity can do that,
> and cause double free of driver's dma meta buffer.
> 
> So failfast unaligned bio from submit_bio_noacct() for avoiding more
> troubles.
> 
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-core.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a16b5abdbbf5..b1a10187ef74 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -729,6 +729,20 @@ void submit_bio_noacct_nocheck(struct bio *bio)
>  		__submit_bio_noacct(bio);
>  }
>  
> +static bool bio_check_alignment(struct bio *bio, struct request_queue *q)
> +{
> +	unsigned int bs = q->limits.logical_block_size;
> +	unsigned int size = bio->bi_iter.bi_size;
> +
> +	if (size & (bs - 1))
> +		return false;
> +
> +	if (size && ((bio->bi_iter.bi_sector << SECTOR_SHIFT) & (bs - 1)))
> +		return false;
> +
> +	return true;
> +}
> +
>  /**
>   * submit_bio_noacct - re-submit a bio to the block device layer for I/O
>   * @bio:  The bio describing the location in memory and on the device.
> @@ -780,6 +794,9 @@ void submit_bio_noacct(struct bio *bio)
>  		}
>  	}
>  
> +	if (WARN_ON_ONCE(!bio_check_alignment(bio, q)))
> +		goto end_io;
> +
>  	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
>  		bio_clear_polled(bio);
>  
> -- 
> 2.41.0
> 
> 

This check would really help more quickly find buggy code, but it
would be unfortunate for these extra checks to be required in
production.  It feels like this is the type of check that should be
wrapped by a debug CONFIG option (so only debug kernels have it).

Do we already have an appropriate CONFIG option to use?

Mike
