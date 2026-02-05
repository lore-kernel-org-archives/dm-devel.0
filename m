Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42439156677;
	Thu,  5 Feb 2026 04:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770264489; cv=none; b=ps8A9cps2YwW9umda85WYJ3uGRBfznK/AsjDigNZgF1BZsitdtHIZ2KApk0Y7xcPjuzpyt5UBtY2TMgqUwaLU+QRzTfOuBLhwtYNVh6zHGKo2LdOl7AVkRQILAsHrjir9Cq9RNcIU3eD3gljOY6CABmLQdXfq6cRL0EkMO+y4k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770264489; c=relaxed/simple;
	bh=wysu9+zrbXMdXgp+6SzTNM5J5EJSlY+kOcwM6krXDVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYy/blJA5ZltmyTKbhRjEs5MAa7QvDHbY+JCYBvnWzrQOIqU4/Gv9JIYDodWmLAt6hxCvw+WeNJeq59rwJ/2kGszQ5vVs6VEHrwax3J8tXX+82qgmRMluHqZIZNFxMnsN1+Q2DDm1exnj4a4vaBcGNOwJ7IW3lGkjEX8oWdepX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+vqYASx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+vqYASx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF76AC4CEF7;
	Thu,  5 Feb 2026 04:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770264488;
	bh=wysu9+zrbXMdXgp+6SzTNM5J5EJSlY+kOcwM6krXDVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+vqYASxyJQq/cuvdPuxtYir/bfzaeXMHG07pEyh5174NosT+jo3ulBNc7kZN2Z0H
	 mx20yC5I4mjYxpK/iSkuSCo8kPC64rPilKEYVQKxv1qeLxvx4rl2dNLzRgrGbVNnN4
	 oYco28olAjnc3TRw15k23MUkxTuxEPWb1C3iTI0sQVCRqso/HbqHjHg4DqpE/lRSBr
	 5sWqfJOt8MDEMClhIX96DamWKwTfahv/rGXtuSlkZuvhXunY/oSLR/m/fHCSdD6Dop
	 OFOyJc6680EQpc4elvKs45vodVqQXrpmlmgx2JEtFNdNOVJy8wTS36AhlZPf3A1EQE
	 XPbc98ZBMNcHQ==
Date: Wed, 4 Feb 2026 20:08:08 -0800
From: Kees Cook <kees@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] dm: dm-zoned: Adjust dmz_load_mapping() allocation type
Message-ID: <202602042007.5C1A9E74@keescook>
References: <20250426061707.work.587-kees@kernel.org>
 <dc1191b4-1010-260b-b7cb-dc748a05e571@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc1191b4-1010-260b-b7cb-dc748a05e571@redhat.com>

On Mon, Apr 28, 2025 at 12:49:53PM +0200, Mikulas Patocka wrote:
> I accepted both patches.
> 
> Just nit-picking - I prefer type name as an argument to the sizeof 
> operator rather than variable name - because when someone needs to find 
> out where variables with a particular type are allocated, it can be easily 
> done with grep if the sizeof operator contains the type name. So I changed 
> your patches so that there are type names.

Thanks for the fix-ups! I wanted to check on these patches, though,
since I still don't see them in -next and the merge window is expected
to open next week.

Thanks!

-Kees

-- 
Kees Cook
