Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE15817730
	for <dm-devel@lists.linux.dev>; Mon,  6 Nov 2023 10:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1qzwZY-00EXk2-2P; Mon, 06 Nov 2023 18:11:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Nov 2023 18:11:15 +0800
Date: Mon, 6 Nov 2023 18:11:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, gilad@benyossef.com,
	samitolvanen@google.com
Subject: Re: [PATCH] dm-verity: hash blocks with shash import+finup when
 possible
Message-ID: <ZUi7ww5BMr7V+axG@gondor.apana.org.au>
References: <20231030023351.6041-1-ebiggers@kernel.org>
 <ZUHZQ3tJH0WSV9dX@gondor.apana.org.au>
 <20231101054856.GA140941@sol.localdomain>
 <ZUMo87EMeYxiCZLX@gondor.apana.org.au>
 <20231102054008.GG1498@sol.localdomain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102054008.GG1498@sol.localdomain>

On Wed, Nov 01, 2023 at 10:40:08PM -0700, Eric Biggers wrote:
>
> Do you have in mind making struct ahash_request specify the data by either
> scatterlist or by virtual address?  It might be possible.  It would be necessary
> to wire up all possible combinations of (SG, virt) x (ahash_alg, shash_alg),
> with the vmalloc_to_page() hack for the virt + ahash_alg case.

Yes that's what I had in mind.  We need to do something similar
for akcipher now that the top-level interface is linear only but
the drivers are still SG-based.

> Well, struct shash_desc used to have that flag, but it never did anything.  The
> few use cases like this might be more simply served by just having a helper
> function crypto_shash_update_large() that passes the data in chunks to
> crypto_shash_update().

Are you volunteering to add this interface? :)

The module signature path is really broken right now, at least on
non-preemptible kernels.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
