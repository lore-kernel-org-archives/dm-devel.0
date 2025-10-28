Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0282DF148
	for <dm-devel@lists.linux.dev>; Tue, 28 Oct 2025 08:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761641267; cv=none; b=Cci3uAf/36iMCu+148b+zMHQy+8JFnMdjdy+zvyM8JJ6qmhkMWnUtcqJqVs/vFuieLXk+OeZTHmN5uo//79W71+rGzD8PtzguRqyR6s6N8v6rZ2AF1MnMYghEB4AK7wNj4J+7F+auPaP5YcEwihBYU4K2e5FKTPZyvPrJ6NvnYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761641267; c=relaxed/simple;
	bh=r9yRyupvds6l2O39gsnYYAgVBhowuzrjd1estJhrb0U=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kh4sYS5UkDe9Cupbiwm4gQUyHv6rxa5YRHhoNJzPiXk/nNWqCzNgJYFWwbX65ji/6yUkjHpxLezL04iJwb5xLR5jo2EHYq66MALLr7j284xx+QUBAZLz0chwNwXkZoaGhCgcWLKtoTnOTjtH9x6RYuVtcDNMXDMPLAiRcYId/DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RVRq5dO+; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RVRq5dO+"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-378e603f7e4so48706221fa.0
        for <dm-devel@lists.linux.dev>; Tue, 28 Oct 2025 01:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761641263; x=1762246063; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vRLc0auh5JUbiEVtJ5AkHNMy18AHU8gRSkIPhMjaAHY=;
        b=RVRq5dO+93xKyzYnk0D/iHD8EWRyvYH17XVaykad2tgmAqLlzhxCvr0VKXlFfx8b3d
         ZqTj7tRrp6q9aVVXYjh5gVCYpjWm7HE4GDzLSkvtieUhEGkzyTqjSLv4HLMBvFFCQBSN
         07Pe+vtPI0UCJbXuFCjBMS0dWIvG90KLjDrnrsQXXIPr1FwlLSHPqxciKNVygH83wRna
         76gMU4VA4XqB3LuAjQAQWqFf9TW2IfknsUVeN+22GNZwr9iNJfkpCXHPXjjzfiG69XRt
         xyTbyLrLyai+Dd7IW8QrkCkpyxZSWi5rwWirOwoRwxgT05bojeWXvolrmGoobAlLDXuP
         ilQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761641263; x=1762246063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRLc0auh5JUbiEVtJ5AkHNMy18AHU8gRSkIPhMjaAHY=;
        b=VEJeShzkED96y9CXiE6SbUgK1ShSRjhwPqeidaGKRFJPCXOwz54RLcimbPthlYkyZM
         JiJluxRs4M4DptizovdNfzH5/rnVp/tMdhLKsBNIiFL/tGBRJLZ61wXUBzaxFfSu43R5
         cpaER8enioRFmfPlU2i8zZxf26tKoF/4SWXRqQy9Zs2EpArG6hHChfqk/S3tG5K+9hOZ
         DgB6St8MGw4fm1jlmzdQZgjd5Dt0+nCvw75qV6fru/+jOgshoFCLCwyzKx/HySOq1pLY
         jZqGA8f63PQzp76vzyKQ4okn8Lr4b6Fd1LKUHO9PVHwYBiE1zrMAcYO4B4YJc7X8XDP7
         1FuA==
X-Forwarded-Encrypted: i=1; AJvYcCUNkWHxhuB5lxhF8ZGFC6LwbqKy45jKysPNUna3dLaDdHhTIB5Y4NiZMCtNZep9zqTfimIDPqh+AQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyD0ac/v0tFi/oulwvyWKFWPU5DtYZ+TPNZmYIn5cZRbj9WA5Wn
	e/WxuQ6mxA9m/M/SyLnHFDMPmca7IlAGYkLFOUgGxLrrrHJoS+F6LWNa
X-Gm-Gg: ASbGncvnXvqeDSSTpzrGBPo1ecPF9ofeE/ULPq0oBmpefljActTGXrHzDouxkNODU6Z
	+y6WckgwDHIlPsNve83HnKAYG0rGM9GsrxlUhwgWvZpudwyKRMuAy9gwnS7vJJeKDI+9V5/qrml
	2tp78gCD2YhSBPM7xWTDAEHSMnlYbnXIgdHxrDR6OB+rAzgxmQkw8oT89gndS/4qBVyDc0HKALQ
	lvsApWbqshuYbIQlp3sHxoZSYIKl/KWVDsIT9QTiVc5y/sv7Mn04vffQe1E203Tdw0h+VthNsy+
	D67fspfa7lL0h4aqWIu8q8o/1Obh100YGA7a5olNN1Oy8c9Ah4cHKuteFUoKre2UIGEZZEKfiMg
	TEJF32sM9BidQ+XQmaKonly7eUtwIR/62Kuvx+F4WeKM=
X-Google-Smtp-Source: AGHT+IEdfnNRUozr4xhoAo4HjYXDAefDjAlsaDl5RblosO0jl3zzldZ8dEMI2G4Tp89Dq4IeKHLxhw==
X-Received: by 2002:a05:651c:551:b0:378:cff9:93f with SMTP id 38308e7fff4ca-379076d81f5mr8932271fa.12.1761641262989;
        Tue, 28 Oct 2025 01:47:42 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-378ee0da49fsm24829691fa.44.2025.10.28.01.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 01:47:42 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 28 Oct 2025 09:47:40 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm-bufio: align write boundary on bdev_logical_block_size
Message-ID: <aQCDLBie3fGwMDW2@milan>
References: <20251020123350.2671495-1-urezki@gmail.com>
 <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com>

Hello!

Sorry i have missed you email for unknown reason to me. It is
probably because you answered to email with different subject
i sent initially.

> 
> On Mon, 20 Oct 2025, Uladzislau Rezki (Sony) wrote:
> 
> > When performing a read-modify-write(RMW) operation, any modification
> > to a buffered block must cause the entire buffer to be marked dirty.
> > 
> > Marking only a subrange as dirty is incorrect because the underlying
> > device block size(ubs) defines the minimum read/write granularity. A
> > lower device can perform I/O only on regions which are fully aligned
> > and sized to ubs.
> 
> Hi
> 
> I think it would be better to fix this in dm-bufio, so that other dm-bufio 
> users would also benefit from the fix. Please try this patch - does it fix 
> it?
> 
If it solves what i describe i do not mind :)

> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> There may be devices with logical block size larger than 4k. Fix
> dm-bufio, so that it will align I/O on logical block size. This commit
> fixes I/O errors on the dm-ebs target on the top of emulated nvme device
> with 8k logical block size created with qemu parameters:
> 
> -device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  drivers/md/dm-bufio.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-bufio.c	2025-10-13 21:42:47.000000000 +0200
> +++ linux-2.6/drivers/md/dm-bufio.c	2025-10-20 14:40:32.000000000 +0200
> @@ -1374,7 +1374,7 @@ static void submit_io(struct dm_buffer *
>  {
>  	unsigned int n_sectors;
>  	sector_t sector;
> -	unsigned int offset, end;
> +	unsigned int offset, end, align;
>  
>  	b->end_io = end_io;
>  
> @@ -1388,9 +1388,10 @@ static void submit_io(struct dm_buffer *
>  			b->c->write_callback(b);
>  		offset = b->write_start;
>  		end = b->write_end;
> -		offset &= -DM_BUFIO_WRITE_ALIGN;
> -		end += DM_BUFIO_WRITE_ALIGN - 1;
> -		end &= -DM_BUFIO_WRITE_ALIGN;
> +		align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
> +		offset &= -align;
> +		end += align - 1;
> +		end &= -align;
>  		if (unlikely(end > b->c->block_size))
>  			end = b->c->block_size;
>  
> 
I will check it and get back soon.

Thank you.

--
Uladzislau Rezki
