Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB4C36A002
	for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 19:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771873377; cv=none; b=s6H3blEE/XoYiEktpvtFeb8hhb4BZj+Qwa8pmjug4nMGAZIM8WNctjglIbK+CaSHAZm6gQ5fd1FF+hDJjeFsHU8OFzSJTiBquL616ji9yPvKsii22ZiPFwK2WHOSO5qdFxQOmcvoaDu4SIqiPOcaZ/M9ij65YccFKwZrT1Tekf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771873377; c=relaxed/simple;
	bh=uTfMCcqUUjrvTGiFfz//4bRSnO1pbZFHIyy1EJvAuwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDvlB7XWFVooDvH7h21gF5FnBlja55ikC0KCHh5R2tAkYXgP2oC8/6Eef9D1kYXLlOV0YUmO4JJLkfPFalZsyKdysAoL4GkKJWtDK7GgVMpryERRpaLjrhZ0Vw7fSWCqEg859K7eF7MnhD7RXRz7mivgVmOWuVIFdwgwPErJG1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aabzV5wr; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aabzV5wr"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d4c307db9aso2406242a34.3
        for <dm-devel@lists.linux.dev>; Mon, 23 Feb 2026 11:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771873375; x=1772478175; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1q9OIY/ja79xQZyMwDY8+lmaLB15J8cqbigUd8WTY1g=;
        b=aabzV5wrNqYFmt+0SAzOqSbAKt191Z9+TpdgF0kNPtsnfdfOu1jQ2URsrI4dU80WzB
         6k8dYYEozVmWa4BGEYLN/Q7gmlAg4VWd/vOh6BQIU1vuYQ58bSOa7F1hdm/+NhCasyPq
         VmyTngNy0xY5DqJT1wiaZCiLH7Ry67moYgbdU5B6EZEsU18ngJu0C7L96xjkgPk8Uc5v
         RdLQQFFQKdkQHydK44PkIv7BmBWKj2iFAqTQg565QUr3vE9kdCGmuzIy0InUIhUrvmK2
         g9mi5hvMlPmvy1IDo8RAnBo/vOCfG/vBS4EwNPP2TDGjdjNITQmaf6PlLWUZ9sIgtkg0
         dYxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771873375; x=1772478175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1q9OIY/ja79xQZyMwDY8+lmaLB15J8cqbigUd8WTY1g=;
        b=b+M1PFWuvMt3+3FNs7jO74+MjlauQ/6dl53lgTRIo5jOQsFEm1hYEnP/ArDfSx5ai+
         wjY2HGzaTxIrbJN/P43oeYjSSJcNnmUW+Ig8qefxhpGnI41UioAYjzh6NUZcp53vg6oO
         u6E+lBRZLtQicf9Yb/cfUjx82t4Ngsv1GhTOF+5wygYKfaJn9gS1tsyYvSQqxYZ7jlc8
         S4sz05sx2WTnUWTl82Y8RWN7Lo3i6gbtmF9+3C9dA9sMYSNPXPN3J8R+CjkOCLUGjyAo
         /AuKukjrzY+j6e7DHaEJVbdxgxK04QdSGX9EDae1QL+bEq4X9OjM/fll+9tTbx4Drcw+
         QSBA==
X-Forwarded-Encrypted: i=1; AJvYcCWyHD/KMsZlpuEQ9CRe4e9LS6bwIb5LJkX3T3ESortIS7yvmeGhldz8WgOBVr9MnDV+39TuRr85wg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxow0Hjxa3+yyPQ1WDfYQp9mgg+VSyHDnJ9v853I823lKIv9Dj8
	frulfKBd2JoBc1M6n+ItLG0+2tvZsZ2lx0czMts1fluQrvevK6IE/Z3K
X-Gm-Gg: AZuq6aK1bWdFc0vSvZ0HT+LdftbTIFzITzLsTVH63YEFkYnmVvkWmgS0mkdHKcTuVUJ
	Ps0KQpSX4S3dAwza/BPaqrFCNBsAk8O4yBfxRvDkrBSCG6MuN0l1wzb2BoY9wNw01J3Swbypge3
	qWbSuETMVUY7t8u6uxG+LcvrF3bOjzHgGKqVZphf0PESQeHg9EKZnSAm2hgSGkNz9lZRAVX99CQ
	auZpS7G8dI52cB4A7i4K/2PX8BkSYL799gskMo5Gqv9PIKNH65CDfnRtGItKE+cGQerf6+HGBbg
	zyZR0W4tupYMXH1iqMSqtkPEmCIF0VvYcipq0mYcMWNccKekD7m1/IV+0pCsDhQ5zu7JzMOtWip
	zHRj6yI32t5y0u3m48PrZkmCRiggKRfqE7Nxh/EuqFZD+Um46DrFsjNMuVrcSEvQAl1JJCTFHWl
	ZIGhJYZ84CZ10V4hx7rNimJFM8fQ6kqTA7vxQvuQ==
X-Received: by 2002:a05:6820:450c:b0:663:56f:1ac with SMTP id 006d021491bc7-679c424dd9emr4009371eaf.6.1771873374840;
        Mon, 23 Feb 2026 11:02:54 -0800 (PST)
Received: from fedora ([2603:8080:10f0:ab80::1382])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679c5630a56sm7024190eaf.1.2026.02.23.11.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 11:02:53 -0800 (PST)
Date: Mon, 23 Feb 2026 11:02:51 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZykWyxLy34o7PKr@fedora>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>

On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> flags.
> 
> There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> let's add this flag to GFP_VMALLOC_SUPPORTED.

My only skepticism about this comes from the line in the
vmalloc_node_range() doc: 
"and %__GFP_RETRY_MAYFAIL are not supported."

I myself don't know why that may be. Could you elaborate on if/why the
doc is wrong please?

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> Cc: stable@vger.kernel.org	# v6.19
> 
> ---
>  mm/vmalloc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/mm/vmalloc.c
> ===================================================================
> --- linux-2.6.orig/mm/vmalloc.c
> +++ linux-2.6/mm/vmalloc.c
> @@ -3928,6 +3928,7 @@ fail:
>   */
>  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
>  				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> +				__GFP_RETRY_MAYFAIL |\
>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>  				GFP_USER | __GFP_NOLOCKDEP)
>  
> 
