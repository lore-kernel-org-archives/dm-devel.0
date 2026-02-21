Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D53531A7ED
	for <dm-devel@lists.linux.dev>; Sat, 21 Feb 2026 01:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771636799; cv=none; b=Rf3JK4ji/ZGJLqaRtNbTsS+mxmTeKRmVK272wkS6kQXsdCU18M7Kl3r6YEVt1cjUZGyXYuIwB9XlrU37o8KTeQKIFiT8E06LpNNfnX7lrZR5AxxNcPsgelyi6tDJ9f3Cf17iu6REuh1jZhZ9nM8grczs7vowbuYMv/tWpHD8nsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771636799; c=relaxed/simple;
	bh=BjknLUB+QAyCIfp8x2Ftdxi214oGTgbcsdz/cOi9bis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALUJJ5tHvqkBjjb+vEMru3DjUgxr3BIheFaG7IQMj0cn7OZ0i6fezGs+3x6R8BtkP4lASJQrIHUYGNUD0Al6EHDa2DjoZgK3h4G+EMBjhBfqg1fHC462+mzJtKXnltco7LVf+1lQ3d3LrDFlOyqUn395dtAt/SHEn9/TFNjY46A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n047RjaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n047RjaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32298C116C6;
	Sat, 21 Feb 2026 01:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771636799;
	bh=BjknLUB+QAyCIfp8x2Ftdxi214oGTgbcsdz/cOi9bis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n047RjaYztwiUoeGtWaDw9L25OgxKagV0rGn2Qyrj7gpvAV2VOpKGwkBn3z6J9/eR
	 DoyxBGxstjt33DGN/NhfkPdxvQ2P8ICmYYZ0cumqFaTAxZvA1N3E6XLgjL2ywjymcE
	 pCiFV7dxqsviI50rCTOn2lgq3Qdth3U4809Ts7dUjWZ2cMGHCzPPfFpyzpAyIp6j1W
	 6bfXyFrI1sSIFJsHzSdz+KS1e6wMK2l35D2mjz7A3Pb1vWHFP/urUgde7KUR0HipPi
	 bp4L1Sn6+cHiCLqSVodPlSvWGSSwOiH5SITXaN5DrxWFp2KtvV+zJ7mDfQZiyfovFl
	 tzu1Yc9J1G+dQ==
From: SeongJae Park <sj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>,
	linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Date: Fri, 20 Feb 2026 17:19:51 -0800
Message-ID: <20260221011952.59323-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 12 Feb 2026 17:33:30 +0100 (CET) Mikulas Patocka <mpatocka@redhat.com> wrote:

> The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> flags.
> 
> There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> let's add this flag to GFP_VMALLOC_SUPPORTED.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> Cc: stable@vger.kernel.org	# v6.19

Acked-by: SeongJae Park <sj@kernel.org>

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

By the way, I think this list might better to be alphabetically sorted in
future.  Obviously just a trivial and random thought that never required for
this patch.


Thanks,
SJ

[...]
