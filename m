Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80477F
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 04:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1qy3C9-00D9Tv-4j; Wed, 01 Nov 2023 12:51:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 Nov 2023 12:51:15 +0800
Date: Wed, 1 Nov 2023 12:51:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, gilad@benyossef.com,
	samitolvanen@google.com
Subject: Re: [PATCH] dm-verity: hash blocks with shash import+finup when
 possible
Message-ID: <ZUHZQ3tJH0WSV9dX@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231030023351.6041-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
>
> +       driver_name = crypto_ahash_driver_name(ahash);
> +       if (v->version >= 1 /* salt prepended, not appended? */ &&
> +           1 << v->data_dev_block_bits <= PAGE_SIZE) {
> +               shash = crypto_alloc_shash(alg_name, 0, 0);

I'm sorry but this is disgusting.

Can't we do the same optimisation for the ahash import+finup path?

On a side note, if we're going to use shash for bulk data then we
should reintroduce the can/cannot sleep flag.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
