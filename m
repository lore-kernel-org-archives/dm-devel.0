Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2B1189F54;
	Wed, 15 Jan 2025 17:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736962658; cv=none; b=IxFXtKPj9wsjRGAAhAQAn6pueeWo63+Af4w0n/493Lmh4Hj7Xx6nZq50Qd/IKboBeYAAMtzxoIKP2+JyoFfk4YC7aHo2jPVK/FJBTfDKIrUxQ3R9qDVfq+TITrVpwdSzHMeCUKClVFjG3l8LCOHRnjVjYuztSSp+xblkktUyMBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736962658; c=relaxed/simple;
	bh=3xWAnLBBl4w+4tJ92QXCBo72mV+FDrquZ1Z2BUPASco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fUYoqE29bnOdMgBP5lPPRhqEN1Gtpat/qF6oLgLTosIq3tckhBuwy7c0bg6eVugCW5g8zs0wDSgCJe+Q3ouFEcdorq7m3eC7kSblA7yoEsFMKKo5d432SC9LjHTRwxrBdgWr5D7mPUVWdCaqQxojdjk7FccEeyUoIAX8Ej/ABJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IyAzogz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IyAzogz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F203EC4CEE0;
	Wed, 15 Jan 2025 17:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736962658;
	bh=3xWAnLBBl4w+4tJ92QXCBo72mV+FDrquZ1Z2BUPASco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IyAzogz9tuvRrqfK+PIY46Dv0v5IBZUhZl1OSl+U3AFLjqXXVs5ewjZmA3OcmsiQd
	 Y3JjDLgujWqclLtGNZlkF05IOWiHJ7J0oS1CjEbOqnIIjt/82DjN3cmOEfbsj4OM2W
	 p/YFkoXwlzrC5ewOBFHXog2WmcjYYHyHIhrDkd6L4KklhYSHpXtY4/x7ib/DQpaO7z
	 LBav9lNelV71LnwHzUxYBBRWRD2f5QKQ5rezf4mcSeJ+iNI9gs/yApbP3h6anW+VhW
	 NkPhwR8ClIhRH8n7Kb8YkccnRE4H094twlkH5nYJJncqzPyIT48jEAZW5r33kj5ciM
	 +3mmrlLKEgwxg==
Date: Wed, 15 Jan 2025 17:37:36 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
	dm-devel@lists.linux.dev, herbert@gondor.apana.org.au,
	dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Message-ID: <20250115173736.GA3712753@google.com>
References: <20250115164657.84650-1-freude@linux.ibm.com>
 <20250115164657.84650-2-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115164657.84650-2-freude@linux.ibm.com>

On Wed, Jan 15, 2025 at 05:46:57PM +0100, Harald Freudenberger wrote:
> Use the async digest in-kernel crypto API instead of the
> synchronous digest API. This has the advantage of being able
> to use synchronous as well as asynchronous digest implementations
> as the in-kernel API has an automatic wrapping mechanism
> to provide all synchronous digests via the asynch API.
> 
> Tested with crc32, sha256, hmac-sha256 and the s390 specific
> implementations for hmac-sha256 and protected key phmac-sha256.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

As Mikulas mentioned, this reduces performance for everyone else, which is not
great.  It also makes the code more complicated.

I also see that you aren't actually using the algorithm in an async manner, but
rather waiting for it synchronously each time.  Thus the ability to operate
asynchronously provides no benefit in this case, and this change is purely about
allowing a particular driver to be used, presumably the s390 phmac one from your
recent patchset.  Since s390 phmac seems to be new code, and furthermore it is
CPU-based and thus uses virtual addresses (which makes the use of scatterlists
entirely pointless), wouldn't it be easier to just make it implement shash
instead of ahash, moving any wait that may be necessary into the driver itself?

- Eric
