Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E22C1FECAC;
	Wed,  5 Feb 2025 21:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738790647; cv=none; b=aRcSe2xYNIzULjKZKNQ/IZfmFKY9HGCNzNNulCFVxJ9rn8jdhmcU5TXhewjqb5Jr6RJH26cHFVPbAIXjH+yCHXol+wA/sMXo+tF2kDxwpOM/lpdqulmiq33toXzQ15HlztfKIKalVTysxXAUc7LGKFDro7yuWXNSkx5V6OQEi+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738790647; c=relaxed/simple;
	bh=+UmAYllNZYZlQY4/25xkX92Mq1romBT3nJ/RvEWGDkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FjOM4w+1EzPw0wiNp8kjtQW8FyZuHruBzJscvZKIXc2ygAqQihGTX1REpwxFdX4VHy1ogGlZxs/5QECe9OH2VutB8O440/pnG87hh2YYN8xVOmwbx4EyOvlEGJPErAejsFpyDfje1waf2ITm6fB70iRArB7QTGZXCWZww7MESjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJpW+qIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJpW+qIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6315EC4CED1;
	Wed,  5 Feb 2025 21:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738790646;
	bh=+UmAYllNZYZlQY4/25xkX92Mq1romBT3nJ/RvEWGDkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gJpW+qIOr2q0UZYqhVZSsO8CsQ3aiFgMy5fQw22kPckB8CjH2qxf+BmrtslGiFxfY
	 GA7DwNBUie1jFQT38/PoUMvlawHmMBQHf04y0aqw14bp6YJ49vgxjssBVsjY7eRkUe
	 FC+u165X5HzDjmdX8XtDd4bQqgS0OaPo9JnGoRLZs6DxYG/50gB7ERdZGOXIjeww8n
	 ZT/lCqkr2e+YU5U2i0339FJ8vIRjlFuX2IvVi9O/oHkGJCsjskewJna5Vqplcb+EE+
	 cDgKnA7pAcmjQux69en8xVKSxoTmXVJ+idNyQQfJrn02SJbbnRo/5Xm0gi6Pv3RoCM
	 tOHb8MEa7x0+w==
Date: Wed, 5 Feb 2025 21:24:04 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>, dengler@linux.ibm.com,
	ifranzki@linux.ibm.com, agk@redhat.com, snitzer@kernel.org,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	herbert@gondor.apana.org.au, Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v4 2/2] dm-integrity: introduce ahash support for the
 internal hash
Message-ID: <20250205212404.GA2175877@google.com>
References: <50a28342-9d3c-b4e4-de13-40304eabb8b1@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50a28342-9d3c-b4e4-de13-40304eabb8b1@redhat.com>

On Wed, Feb 05, 2025 at 09:23:18PM +0100, Mikulas Patocka wrote:
> Introduce ahash support for the "internal hash" algorithm.
> 
> Rework the dm-integrity code to be able to run the "internal hash"
> either with a synchronous ("shash") or asynchronous ("ahash") hash
> algorithm implementation.
> 
> The get_mac() function now tries to decide which of the digest
> implemenations to use if there is a choice:
> - If an ahash and shash tfm is available and both are backed by the
>   same driver name it is assumed that the shash is the faster
>   implementation and thus the shash tfm is delivered to the caller.
> - If an ahash and shash tfm is available but the backing device driver
>   divers (different driver names) it is assumed that the ahash
>   implementation is a "better" hardware based implementation and thus
>   the ahash tfm is delivered to the caller.
> - If there is no choice, for example only an ahash or an shash
>   implementation is available then this tfm is delivered to the
>   caller. Especially in cases where only an ahash implementation is
>   available this is now used instead of failing.
> - The caller can steer this choice by passing a NULL to the ahash or
>   shash parameter, thus enforcing to only allocate an algorithm of the
>   remaining possibility.
> 
> The function integrity_sector_checksum() is now only a dispatcher
> function calling one of the two new functions
> integrity_ahash_sector_checksum() or integrity_shash_sector_checksum()
> based on which tfm is allocated based on the two new fields
> internal_shash and internal_ahash in struct dm_integrity_c.
> 
> Together with this comes some slight rework around availability and
> digest size of the internal hash in use.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> ---
>  drivers/md/dm-integrity.c |  350 +++++++++++++++++++++++++++++++++-------------
>  1 file changed, 252 insertions(+), 98 deletions(-)

Thanks.  This keeps the questionable ahash stuff from affecting the common case.

I do still want to emphasize that the use of ahash here is artificial, given
that the proposed code waits synchronously for each request to complete, and the
underlying "phmac" algorithm that Harald is trying to add
(https://lore.kernel.org/r/20250115162231.83516-1-freude@linux.ibm.com) uses CPU
instructions (s390 CPACF) and therefore wants virtual addresses.  IMO, the way
that things should be is that subsystems like dm-integrity, dm-verity,
fs-verity, etc. should implement ahash support *only* if they are trying to
support old-school, fully off-CPU hardware hash accelerators *and* it is used
properly with an async callback other than crypto_req_done in order to actually
utilize the hardware properly.  That does not apply here, where the underlying
algorithm that Harald is adding could just be made an shash instead, provided
that shash was improved to support sleepable algorithms.

So, that is my opinion.  But in practice it may be necessary to use ahash for
other use cases too if that is what Herbert insists on.

- Eric
