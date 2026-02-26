Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE8745C0B;
	Thu, 26 Feb 2026 05:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772082331; cv=none; b=bvi4BnVup6wre/hU4GmafTxyjXGa2l2afOUEH6iY7CMeabhLNDa66jlEAMUxIz/cQ6TbIRcrCXYwsLNDsGrmGWAF1tShZWvAynOxVVtYYdk3xzKsIIuwW4c0yy+rShfcmb2LYYUmEzpOzh4PTPpvJNqZRMm2YsE07h6qWqYYhbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772082331; c=relaxed/simple;
	bh=lRWzvObeAaVyyqRA63sIgkc5s83+SORp3L0cua+A9HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bE/kkv/iU69YOMxuLZOY5I9ZZ7mYMYK7uinzg6KWRMKvLdGoFICqZwxEI4Vv9lUUv3vHyB5SIhbLoknY9BoCQYqCrqVQDLpHqElrOW0iCIsUTZ+bveHS4vmKCpThh0mWvIS0nn6RZrG4dqfXGuFhNiHJkad5rQpaeU1zgAw+y1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uAjy4z7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uAjy4z7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69E3C19422;
	Thu, 26 Feb 2026 05:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772082331;
	bh=lRWzvObeAaVyyqRA63sIgkc5s83+SORp3L0cua+A9HQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uAjy4z7Zg08j2qAeTEwrMTsNFRRnpvAK7IZ9CL7t/qEHG/IioK7ualItv8aP65SqW
	 JXf2jnT/ph2Pl8i5NTQyekFV3ATr3wDDqRCGPKTZ3mtF47rIhkCTqmh65ujkfqL+ES
	 ayuQd9QA5/WHv+658hP78GSQLIooNFg3KL++eU5sZCXxwj2dDkU2LEw/MnkUujiuEg
	 oBqvBE6WAsHhyW/kyrr4OSNj1S4zFwdmvbr/hFb8Bwqr4qkczPAiFDhMVxoAORLSoa
	 OU600NqVdiHj0H0N+WidV+OCWthkQg6Ixemqc6JBJVqcl3xzNIQn35iYcvsk/3cD2Q
	 mlXp5o7o1XTnQ==
Date: Wed, 25 Feb 2026 21:04:40 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Rahul Sharma <black.hawk@163.com>
Cc: gregkh@linuxfoundation.org, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev, Guangwu Zhang <guazhang@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH 6.12.y] dm-verity: disable recursive forward error
 correction
Message-ID: <20260226050440.GA2302@sol>
References: <20260226043500.3945988-1-black.hawk@163.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226043500.3945988-1-black.hawk@163.com>

[+Cc dm-devel@lists.linux.dev]

On Thu, Feb 26, 2026 at 12:35:00PM +0800, Rahul Sharma wrote:
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> [ Upstream commit d9f3e47d3fae0c101d9094bc956ed24e7a0ee801 ]
> 
> There are two problems with the recursive correction:
> 
> 1. It may cause denial-of-service. In fec_read_bufs, there is a loop that
> has 253 iterations. For each iteration, we may call verity_hash_for_block
> recursively. There is a limit of 4 nested recursions - that means that
> there may be at most 253^4 (4 billion) iterations. Red Hat QE team
> actually created an image that pushes dm-verity to this limit - and this
> image just makes the udev-worker process get stuck in the 'D' state.
> 
> 2. It doesn't work. In fec_read_bufs we store data into the variable
> "fio->bufs", but fio bufs is shared between recursive invocations, if
> "verity_hash_for_block" invoked correction recursively, it would
> overwrite partially filled fio->bufs.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Guangwu Zhang <guazhang@redhat.com>
> Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> [ The context change is due to the commit bdf253d580d7
> ("dm-verity: remove support for asynchronous hashes")
> in v6.18 which is irrelevant to the logic of this patch. ]
> Signed-off-by: Rahul Sharma <black.hawk@163.com>

Looks good.  The upstream patch incremented the dm target version number
too, but skipping that part looks good.  This further shows that the dm
subsystem's version numbers don't really work.

- Eric
