Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB88A182B7
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771949270; cv=none; b=dqXOt4rdFwHoaYQMNubFEOAu6oK6mM7grdpNWUtRgz0qI5+jxCVKwcv9Hc5c3b/vKkUG5ZZhVmukhJCX3ioK28pYt5gW/GKX5sGT7LyFogiFYvx5/vqeAnWfO5SdNEVbDdL0LP8JEDNZdagysW2l1H7TYgLQioDNnOTb+hUrkeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771949270; c=relaxed/simple;
	bh=q12x2puj23C8j4pBz/v/WtdsY/loHRqKMzhXJwhMoKg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZsGRbIeBquIfegNMKa3Wzu5qmFk/UD5JhlAbdRj23C8EnZGGCBVOi3teJfcOsHBjYxfh4f3rAU6ompFN7/IHS1RmlLdDqRUFcHe5Ga46ZZpgL+Ht14o0UIfRfR6zhEAw63p6BzrIMoD1vfOLzFMQ8jLaJKrJVMdpJw/0FjbNFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UEA5YNGh; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UEA5YNGh"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59e6b736b84so5262868e87.1
        for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 08:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771949267; x=1772554067; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6qfUGt/FM7R2rdWgRVoPTD475gsr7cLgK2X8GJMzNug=;
        b=UEA5YNGhzezHeUvWBTa5zjkOm1D5Pg4I+6jb417SL8J9FvPvLXrWMZcWgVklDn6WPc
         Q+2i8lEQ0NZNF7Toc8pVJO/WiJhQ/uhDTpUhOtz6rDEqtRNzRsigkgqSNde5sTyffF/e
         ZV2CpaSG1Uz+x2y1ZWnfo698x/cCV+ioa3ODQR61zxiY8yUGqY3aYwpV3J6NisfN9jUq
         qo9nJTncgI4LuhDPioyv+ytRXkujSyTCbDw62jSlBBllgTsjpmblHOxTapAh1KLTzB2h
         29AQpxwjsQWCb4afVL7hxRfLMQ2utvizfh+4Xv9YtfMz0d/NEe5K+9mHTcm5KG2Aq7dW
         C3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771949267; x=1772554067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6qfUGt/FM7R2rdWgRVoPTD475gsr7cLgK2X8GJMzNug=;
        b=UB1Y9tpR0De1zN1pUvysnuasZIrA55pm09MNGhO74V9J2TCB9WDOCr+LBSGU18mM8v
         ntNPr5kaLe+HwZnNinrrayUjJlCcce+Pk/boBjJSviOOkXA45i/RAxygBMip3y67mcjb
         rUgdG13GNdqLvbxuNn2Br9JDrRjiuoEGOygFDgTz+ujxDIgUciDCEMVPBSegzJeF5pLr
         OHa3mWdH4lXw+Syq4ixXIU59u3x9SlffO5z2V7/15uHYYhrzGu+v9lIR8sR2o32e9uUW
         9MnL1bfp7aQx8LN7vqx8VoiG7rfw6n28BcjwDvMxNdkdQLEhfOkgp7dZhLAlXdmlF5d9
         /ukw==
X-Forwarded-Encrypted: i=1; AJvYcCUBfY57e4ADFiUxU4+BaJKGgr/27obKPLVRUZLMVgExglzkFjtsAsGN/pnPENXB4hLsRwNtuWS2bg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzSLyNSj0twXSXz8CYXJwT5WCJ9C9HhsABsAECEs0wzb6BqdxA3
	lP0BG+JSkJOpg31ohlqJIB3oxZwP7/xxk4GQgxmAiYnuw2Ye/XfcWiyc
X-Gm-Gg: ATEYQzwYEISkMjAZVGFvmroCqr5gOQbmWK7BYRxIImpsp5BTWIGC0elN+NehGr6KLyz
	f7PRwdIg06gi9zrZgZEu5RCi4fFTyikhUljyaxhlU9h69EqaP4dgBA0pQXV6DeA+clXzUULgyQs
	NpSV9Pcjlv5e/WtJvUxB9pLHKJrFwuKW9C46GHTEEwUvX9H61XY/ViMjieAEe0J6wOHFhGkBi/n
	m5lgUBqyCCKaTkxeSEwYe/DPtVyjB6tTO9jvUTjDeYcszJBOqxT6q8j8PQfeGxCmPr/Zn7JffIW
	MG3pMLhYtjFn2V5T5QbTJ+ItQHtwbwyOIfVC9nkdQqC/qgqKp9pd/uKHdGdrfoPbpHtA/RNhLlm
	4lbP546VocTkqPMPOqzErPqfvBi84ivmgwojSaKgZvi6cn0/zLgrk6TF8q+0fEeVyc2luXs1dWi
	+Fz44HeCMNSaQY7BqN9tn3Ufgmrx7fY61kML50/p2owNp/Q4Fwr2mR7ZUZ5ZgZIAs=
X-Received: by 2002:a05:6512:3d1f:b0:5a0:f3f2:7ca6 with SMTP id 2adb3069b0e04-5a0f3f280b2mr2300626e87.38.1771949266678;
        Tue, 24 Feb 2026 08:07:46 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a0eeb45a64sm2282697e87.67.2026.02.24.08.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 08:07:46 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 24 Feb 2026 17:07:43 +0100
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
Message-ID: <aZ3MzxtMp2OykAQq@pc636>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
 <aZ3HaVuIA4Ezu1uY@tiehlicka>
 <aZ3JB5Xm3SCmJW95@tiehlicka>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3JB5Xm3SCmJW95@tiehlicka>

On Tue, Feb 24, 2026 at 04:51:35PM +0100, Michal Hocko wrote:
> On Tue 24-02-26 16:44:43, Michal Hocko wrote:
> > On Tue 24-02-26 16:38:01, Uladzislau Rezki wrote:
> [...]
> > > I do not have a strong opinion about workaround you noted. Maybe Mikulas
> > > can switch to NOWAIT flag instead.
> > 
> > using NOWAIT for the full vmalloc allocation would be just too easy to
> > fail under moderate memory pressure.
> > 
> > The real question is whether we want to provide some sort of backoff
> > early but not way too easily allocation semantic for vmalloc. If yes we
> > need to get creative in the vmalloc internals rather than expect callers
> > to be working around that on their side. History has proven that this
> > just leads to tech. dept and more work later on.
> 
> Just to make sure we are on the same page I mean something like this 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..791366fe44e2 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3798,6 +3798,8 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
>   * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
>   * GFP_NOFS - memalloc_nofs_save()
>   * GFP_NOIO - memalloc_noio_save()
> + * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save() to prevent
> + * OOMs
>   *
>   * Returns a flag cookie to pair with restore.
>   */
> @@ -3806,7 +3808,7 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
>  {
>  	unsigned int flags = 0;
>  
> -	if (!gfpflags_allow_blocking(gfp_mask))
> +	if (!gfpflags_allow_blocking(gfp_mask) || (gfp_mask & (__GFP_RETRY_MAYFAIL|__GFP_NORETRY)))
>  		flags = memalloc_noreclaim_save();
>  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
>  		flags = memalloc_nofs_save();
> @@ -3940,7 +3942,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>   * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
>   */
>  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> -				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> +				__GFP_NOFAIL |  __GFP_ZERO | |\
> +				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>  				GFP_USER | __GFP_NOLOCKDEP)
>  
> @@ -3971,12 +3974,15 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>   * virtual range with protection @prot.
>   *
>   * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> - * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> + * %__GFP_RETRY_MAYFAIL, %__GFP_NORETRY, %GFP_NOFS and %GFP_NOIO.
> + * Zone modifiers are not supported.
>   * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
>   * by __vmalloc().
>   *
> - * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> - * and %__GFP_RETRY_MAYFAIL are not supported.
> + * Retry modifiers: only %__GFP_NOFAIL is fully supported; 
> + * %__GFP_NORETRY and %__GFP_RETRY_MAYFAIL are supported with limitation,
> + * i.e. page tables are allocated with NOWAIT semantic so they might fail
> + * under moderate memory pressure. 
>   *
>   * %__GFP_NOWARN can be used to suppress failure messages.
>   *
> 
Yep, i got your intention correctly. It would eliminate the problem
with page tables allocations :)

--
Uladzislau Rezki
