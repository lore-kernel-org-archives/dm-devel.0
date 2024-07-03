Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BD928379;
	Wed,  3 Jul 2024 19:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720034148; cv=none; b=Fhp+GIdfWK5G9eNydW9JkfuRuKc7TvDKYmMxNk3OrEZQcRqtb0McQD9rLMjeBGYMq1NO+i9VxTzB22acK+yCMzHyAAA4K4RaBljaTU8YP0MEU+lpFQmGiFeCwwuU4NCfcw/80wPrhus4EKmRqG2Ih4U6m5hlaWIN5tviGFQs0Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720034148; c=relaxed/simple;
	bh=yeOTMwCH5NFoVxP4G8Q81APDhzrJDEKKI8r2zzHQFSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R2yelKTY8qm+2HBe5I5pHRJZYHK8pTajMWP5Zav3DdcTKSDCe6M9KWcWFnFQqydgejdDWrFBhhiVg20t1PTWudlEPs5pcyYG4VW6aZ6eTNsRNNIY4bzT+w7R03/aax2L4UG87u8ag/CSGU461By1sB684KyabAJr8IZGdAw6g5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XHXlxkSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XHXlxkSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3ECC2BD10;
	Wed,  3 Jul 2024 19:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720034148;
	bh=yeOTMwCH5NFoVxP4G8Q81APDhzrJDEKKI8r2zzHQFSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XHXlxkSiSrXwgvV7I6KdYaf9eRN+9+tpk2y4nVnK/xTP99bWt9CtFF+JXCtg6VVg4
	 UCZ1sMWnULSmOOxxYILQZecwKatfrg5BZmxoA6aUvAXTQacROZ3THvsZN+N7AziUX0
	 CJl8uaEZx9mUOIs3eEXxJM679VLZB931vzgLtlTEGQZMyO6x1QjEsSYHIoWf671Vv2
	 wjQCrpvxkzvul8fsu1NeqR5L4CTrXUx7Vubho1OANUDOE/CcCZWZLt283CzrbyI6CH
	 dp/+HIc/z7Pu6M/q+bXYQOR4ClpYNR84LdiJrDQcyqor+Cg2PoVHTz9KolidBJDhrZ
	 zS8sSfy7NDNGw==
Date: Wed, 3 Jul 2024 12:15:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>, dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH 0/7] dm-verity cleanups and optimizations
Message-ID: <20240703191546.GA1756@quark.localdomain>
References: <20240702064835.120541-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702064835.120541-1-ebiggers@kernel.org>

On Mon, Jul 01, 2024 at 11:48:28PM -0700, Eric Biggers wrote:
> This series contains some cleanups and optimizations for dm-verity that
> I've split out from my multibuffer hashing series
> https://lore.kernel.org/linux-crypto/20240621165922.77672-1-ebiggers@kernel.org/.
> 
> This series does not depend on any crypto API changes, so it can be
> applied right away.
> 
> Eric Biggers (7):
>   dm-verity: move hash algorithm setup into its own function
>   dm-verity: move data hash mismatch handling into its own function
>   dm-verity: make real_digest and want_digest fixed-length
>   dm-verity: provide dma_alignment limit in io_hints
>   dm-verity: always "map" the data blocks
>   dm-verity: make verity_hash() take dm_verity_io instead of
>     ahash_request
>   dm-verity: hash blocks with shash import+finup when possible
> 
>  drivers/md/dm-verity-fec.c    |  32 +--
>  drivers/md/dm-verity-fec.h    |   6 +-
>  drivers/md/dm-verity-target.c | 461 ++++++++++++++++------------------
>  drivers/md/dm-verity.h        |  39 ++-
>  4 files changed, 242 insertions(+), 296 deletions(-)

Thanks for applying this, Mikulas!

I sent out a new version of "dm-verity: provide dma_alignment limit in io_hints"
to address Christoph's comment.

Also, I noticed that when you applied the patches, patch 2 somehow ended up with
the same commit message as patch 1.  Can you fix that?  Thanks!

- Eric
