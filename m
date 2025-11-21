Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9837336D4FB
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 01:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763689594; cv=none; b=mulAvbBOwLBA0BaCyI/HsEdc74uc7zpVwwNqjDl22hV+wwevBMzbE8EMMYRKp74p0ZHw13RlTjuTVJA98dUSYCMH+jwAx4h6m/HOwLUueXO82ZHX5QzfVe9HM6T6uz2066KyEK2Rk0ZTZa74Ut7d7ZZaVYBOzCxg8K84miZoS0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763689594; c=relaxed/simple;
	bh=f0+BUEjjXYnzN4KmGMoX+leAN12KDLncW7otub7dG4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KUKv5yiBUx+BesEEKQb4P9NgI7BMCtarjSls7SUuRhhZ4ePobG5LBXulXgG1HJ4CiNkaClyWO67X85odIYWeVan+DNb7kE5SsQkTGXwakd79erqrRHjKngjn//4IMmTUi7VReAD8O1A28oXkBJKBGah9dF2bnafwAa1xXfsBhyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ciLTtJxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ciLTtJxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1880C4CEF1;
	Fri, 21 Nov 2025 01:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763689593;
	bh=f0+BUEjjXYnzN4KmGMoX+leAN12KDLncW7otub7dG4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ciLTtJxrBDnPgpzM34OM5mzLdbEGDBu4L2WWDKeHCSg+/vkMpT79gOODe56axQf42
	 LMWo5UNamfvme3cJdWdEvGsL8W00KsQE4bjU+JnpGy176Uvuce/NrswL0xCSloXiT8
	 XT/8iOqpuIlkLQhNQqSKbvpDCLj/sQdi/cHyiQTwjduZKP484Qz2x/V9NBHmK3MHqs
	 1kEmWHqPfhq+3e8vYmoS3H1N3OFiohDPRg/N09ny3MERkBz2pNygNcPand+oNNSJA3
	 fKjuA//YrsUKLE+k2uEqhIGtIP8lZMCjGgJ/54WRYarF9wKDrmnosKi5ah9UKrjcaY
	 uJ2W2xCGnuNzg==
Date: Fri, 21 Nov 2025 01:46:31 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev, Ondrej Kozina <okozina@redhat.com>,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] dm-verity: fix unreliable memory allocation
Message-ID: <20251121014631.GA3078357@google.com>
References: <0da5850a-05ee-6cff-3c25-e2c9037c52eb@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0da5850a-05ee-6cff-3c25-e2c9037c52eb@redhat.com>

On Mon, Nov 17, 2025 at 09:42:02PM +0100, Mikulas Patocka wrote:
> GFP_NOWAIT allocation may fail anytime. It needs to be changed to 
> GFP_NOIO. There's no need to handle an error because mempool_alloc with 
> GFP_NOIO can't fail.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
