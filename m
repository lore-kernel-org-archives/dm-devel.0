Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B941CAA65
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 23:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740008862; cv=none; b=ZghmsLXsGBUNIteoHMDmSOFpirLOJTWmfX63lIGI+EQFnQsG3QRkxiWm5pUGAJzCgPINaxorTzUxsnCC/rd2xDuOcKm35Svym/8PpPa858olaOAwLF48RgMCM6OhZnWd6kR7apyM0+szzhtJTJ7yNzDSEHnSWKLFNsAfRTd1+QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740008862; c=relaxed/simple;
	bh=UwUuwdukqezMT4zNFsZB2G1bJ/KiWJbSnKOhjVLNBmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLKmat4fM1GnRq5tL8tmvtzeM6iFVoCTzIt/Q1gH8xFvX+Zz9jns7kSaVDky41OpXs78BelScu40QnFBmw75VK60+fma92FCOq/Eo7zFfEx2Uj1EHzMi5eU9+x18An+i1wC2FslhavKW2Z5Xh9orTZ9X5awfN/hwJUkDMUltdC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UTta4hKp; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UTta4hKp"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2212222d4cdso59965ad.0
        for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 15:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740008860; x=1740613660; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7EDgb9ixmcxW5HDhsD7poMpSDgYXVSUp8X6oXzf45dg=;
        b=UTta4hKpJtm3H94PTsTUZG3/Oaev7A8ozG0SvyLo0bJkwiTM+douyWu1NBsQx71iWj
         sATSgQ7epT7XszTmfvmYLJvn1qGX/hBrHHzgXlrejbiF3m0Ne4pyloWwBLlI3eKNpSCT
         M7JAM0QM8hncRMkZyAh1frJCTKxwOITHi9s2tDbZJfFFR6a7d2IzfSzFvkYMVJf0QEyc
         wdDQ/WLVfy2Vezn+RCTei3l+khkA6NYbuDhZZRbxapEy7yH/FKF1CWoBgDr9nRwturFK
         79peJT/AwQsKAKcaS3UGvUrfhHyH5ss7xPuMO+iKm8bKvmc4sM14wQ0N6RVjI1eWWm9Q
         U2Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740008860; x=1740613660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EDgb9ixmcxW5HDhsD7poMpSDgYXVSUp8X6oXzf45dg=;
        b=DD+O+0/X6HGAnC/fB1oJ9lKX6Q826AdEvbuPswfBZQJKaEhNh3c28GFx2hgUu99OdY
         EaJhLcLXYAhuV6pqPcqvhgOoeYoo8VjBVMSxBhWtT2qlLGfoWxXLQkFDI/igF20TGB07
         XRE3Dw7tjzKpGYUcouyRmqENPDnjHkzZOuOwnya/zij3b4IcSqDjsoRExrqrneLecarz
         cdlZrEzYNifx1UNc/H5vUbzXzGMMaO/qwkdqOkxc4UqcqfVyuVqRLFLZgj793AfpocJs
         NMWHcpPsX+TTTd78ZPz6Zo5QEHbSc/j2x3+rX1s1zQFPDzg3eroxc5iPkvbJTsGI+yjN
         Qq7w==
X-Forwarded-Encrypted: i=1; AJvYcCUO5qhLxhgov0iUeMeYbhJN7MMO4D8W198y7cXJ12Na9yB1emb15aX6s2VVin/bM5qtSolo5oZJQw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxwZJlGVgqAcGSWdOqiK+SY8X5KIFbXL9pNwNVydMYyxEbs9Khn
	POHLM3X11PsXCaJCKq+1U5J4/fF3zsj+DIuBg6DrXiUOw/7aNKY2D8A6mEmELw==
X-Gm-Gg: ASbGnctHhbnNL37YIczOXoOg6DItwv5pk1IK6itHiQr/uhz1JOnaUUDOwWXX97A6hXN
	EV5mMUMviVCKjbvEJPHzdT+5ujEq+HKmRkj9kDeeu3I4QSoFALSUyDiaymv6G0XnPOekX0cSIws
	n5GGa6BdqF7xRXbRJ3yH4+P20K0JhpwYTs0/yCo+yLzlkeVioObTht8/RZC12Sy3aKmAxGGV5CD
	UY7AaqINQJ/DfOMaHDqBd0eIJ9KE9ZZBpusRmoNcgZfKY4fV0Vw0Mhan4yYEGbMlLHbmfJNSkzd
	adqGlLaolf2C8dUylPpGHcWzwoIxBarWk5yZnTU3BDgDFphFMyGgubW3DNA=
X-Google-Smtp-Source: AGHT+IG0hr/jG6j1sf+wqHDPRpxr2FFnc0Et7UEElKQxjMSSSyeVPZKlgXTKJB1uWFrEjnPtBHR0Yg==
X-Received: by 2002:a17:902:d48e:b0:215:79b5:aa7e with SMTP id d9443c01a7336-2218ff9e8a0mr489615ad.13.1740008859704;
        Wed, 19 Feb 2025 15:47:39 -0800 (PST)
Received: from google.com (190.40.105.34.bc.googleusercontent.com. [34.105.40.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2217eb0e503sm12269545ad.62.2025.02.19.15.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 15:47:38 -0800 (PST)
Date: Wed, 19 Feb 2025 23:47:34 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Akilesh Kailash <akailash@google.com>, kernel-team@android.com,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm-verity: do forward error correction on metadata
 I/O errors
Message-ID: <20250219234734.GA758416@google.com>
References: <920de20f-1d11-e6f6-e7ae-a774f5c210f0@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <920de20f-1d11-e6f6-e7ae-a774f5c210f0@redhat.com>

On Mon, Feb 17, 2025 at 10:36:02PM +0100, Mikulas Patocka wrote:
> dm-verity: do forward error correction on metadata I/O errors
> 
> Do forward error correction if metadata I/O fails.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-verity-target.c |   25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-verity-target.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-verity-target.c	2025-02-10 16:24:56.000000000 +0100
> +++ linux-2.6/drivers/md/dm-verity-target.c	2025-02-17 16:47:37.000000000 +0100
> @@ -311,7 +311,7 @@ static int verity_verify_level(struct dm
>  
>  	if (static_branch_unlikely(&use_bh_wq_enabled) && io->in_bh) {
>  		data = dm_bufio_get(v->bufio, hash_block, &buf);
> -		if (data == NULL) {
> +		if (IS_ERR_OR_NULL(data)) {

Thanks for adding the check, makes this easier to follow.

>  			/*
>  			 * In tasklet and the hash was not in the bufio cache.
>  			 * Return early and resume execution from a work-queue
> @@ -324,8 +324,24 @@ static int verity_verify_level(struct dm
>  						&buf, bio->bi_ioprio);
>  	}
>  
> -	if (IS_ERR(data))
> -		return PTR_ERR(data);
> +	if (IS_ERR(data)) {
> +		if (skip_unverified)
> +			return 1;
> +		r = PTR_ERR(data);
> +		data = dm_bufio_new(v->bufio, hash_block, &buf);
> +		if (IS_ERR(data))
> +			return r;
> +		if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
> +				      hash_block, data) == 0) {
> +			aux = dm_bufio_get_aux_data(buf);
> +			aux->hash_verified = 1;
> +			goto release_ok;
> +		} else {
> +			dm_bufio_release(buf);
> +			dm_bufio_forget(v->bufio, hash_block);
> +			return r;
> +		}
> +	}
>  
>  	aux = dm_bufio_get_aux_data(buf);
>  
> @@ -366,6 +382,7 @@ static int verity_verify_level(struct dm
>  		}
>  	}
>  
> +release_ok:
>  	data += offset;
>  	memcpy(want_digest, data, v->digest_size);
>  	r = 0;
> @@ -1761,7 +1778,7 @@ static struct target_type verity_target
>  	.name		= "verity",
>  /* Note: the LSMs depend on the singleton and immutable features */
>  	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
> -	.version	= {1, 10, 0},
> +	.version	= {1, 11, 0},
>  	.module		= THIS_MODULE,
>  	.ctr		= verity_ctr,
>  	.dtr		= verity_dtr,

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
