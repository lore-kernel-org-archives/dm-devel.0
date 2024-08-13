Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCAD19E831
	for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 15:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723562644; cv=none; b=CghItR7sDV7oWm3k2xzs/LWzCPxgCBIwgSZSL7hgcmcvrVzGJXlXFhpIuX1RXfXOQHZjXUBBIzvI/3eRaXJsskeUYX5lbOkwhDUldAMbYQXUpmJqQRCMkQCYLE2ezZvvwi9phylpli4MhYbYE3NUNh0nsyJVKYS77+CadCgeHPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723562644; c=relaxed/simple;
	bh=iI4gyFjBNzWveejorfI8EJiiHtOQ8l+sn8jokkrJZLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qlix3Fyg2i/39w3YTi8KKHwz2crmiggN20D/sikWG14q/2BfQwaOT1NpqL68fZ85qQG+hLab2LW85uHee94cUZqVUZEx6UC8kIKudZWOd7UwaWsnQ8Um4PBTWZWb7GUw78Xclgum45TilTWF1lwcrkeF7FA5SQcR8jCrTSbnh04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DfhtvKQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DfhtvKQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBCDC4AF09;
	Tue, 13 Aug 2024 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723562643;
	bh=iI4gyFjBNzWveejorfI8EJiiHtOQ8l+sn8jokkrJZLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DfhtvKQgeuZXq+/8n1XOm3fScZqTk2DRGdvdcn/LzASe56QPR4J9TfTtmmWY9rA3d
	 AerJ+GmG+R79OzWCPBdv1B8HwmlQ4o4RE98fMAYZvl3osisBNZu3tJctEzXe7j6wqG
	 Q3NncMjzluJCz8HC6G7XUPTC5fPWjPReCVfiXh5claSrBYsvVoUtNaxU48CkkTv++l
	 TW489NtR10BhMx3NK9iLRnhDy/EcZkuW21qUYPKWKZ2qWzQdOuaog8knP4eufFs8F7
	 4VPT9fi2uRka3ylUra+abOr3BWvCS6AX6vbRGdBwMzEB4OG7JdVtNP4rnXXPxlR582
	 LwM9OjVbNMtUQ==
Date: Tue, 13 Aug 2024 11:24:02 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: dm persistent data: fix memory allocation failure
Message-ID: <Zrt6kskSNfQQecHH@kernel.org>
References: <12f6fc8a-a0cb-48c-e792-57f09b62cd@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12f6fc8a-a0cb-48c-e792-57f09b62cd@redhat.com>

On Tue, Aug 13, 2024 at 04:35:14PM +0200, Mikulas Patocka wrote:
> kmalloc is unreliable when allocating more than 8 pages of memory. It may
> fail when there is plenty of free memory but the memory is fragmented.
> Zdenek Kabelac observed such failure in his tests.
> 
> This commit changes kmalloc to kvmalloc - kvmalloc will fall back to
> vmalloc if the large allocation fails.

Should add this tag here:
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
