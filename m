Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA71259CB9
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 04:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783743263; cv=none; b=Ss8Xk2UjMLQ5sfvnUOGNy1WMNx4qEqB/YsmYU0i7RYgkCD6Sgf/ph8W7807sBuEUsLJrewIRkKIdSuhbfeQhrX+V1KZSxvxoEmWQza/Y6A3pMlFBFqkoGtoEbn4La9T4j4MqTn4rV0FWr6EG6s1SD5TfHR06WfLWIbIprdt1/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783743263; c=relaxed/simple;
	bh=1porn2byjIryEdatlCtbjcq5TzsYtWD0PQBQReDPOC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xumb1yiHKwCB/lHYydd0YMr7ilHK1oKDUv64spgYGCYoGb9a6FdIbsYXA/yjgKK3cPOznNCD46JEBI29+KppybqeKWKqoW2xVAI3320jE1vSrxwHhFKeWTnaeZZuuybNKnxTQu8blQTLxTksGC875i3kSp3wta4HmVFrzHLnddE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lizCq5G8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lizCq5G8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7061F000E9;
	Sat, 11 Jul 2026 04:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783743260;
	bh=blsu9LVUXMBb+XhgAF+IYkczJ+5wLvW5EmhUyaunfow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lizCq5G8Ihd5zGWln9CqzpC4MMmH+YK+kXZWrNMHCffXhhoeX9jzZ06SGTb/Jg1nV
	 /YSL8NikmMYpstNoUj5q2dHtuUBo7nRAKCVhilZO6MzzzJfHETEG7Qt2hm/toHSEcy
	 StT6MQQKe2fpdpO6NMa1twRW7nTDs6MZVB8WLh5DWx9JS6eNpQ79+3aitM5ncqp0g9
	 ke9VIPACqNVaIgnNH1y88e1xcT7Qez7RbkCZPJrU0+Z6yi+0I8iYRQ6kvcT/9ANDp/
	 /+giPKWVV1Xyr8nKnh3OFnxxILSV4ghQUEpdhQngohupsYbjxHoSr04Ql5qvTY2UT5
	 IuQeu45I4XZKw==
Date: Fri, 10 Jul 2026 22:14:19 -0600
From: Keith Busch <kbusch@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	mpatocka@redhat.com, snitzer@kernel.org, bmarzins@redhat.com
Subject: Re: [PATCHv5 3/3] dm-crypt: allow unaligned bio_vecs for direct io
Message-ID: <alHDG19tfq8lMSQz@kbusch-mbp>
References: <20260709161519.1559723-1-kbusch@meta.com>
 <20260709161519.1559723-4-kbusch@meta.com>
 <20260711005440.GA7610@quark>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711005440.GA7610@quark>

On Fri, Jul 10, 2026 at 08:54:40PM -0400, Eric Biggers wrote:
> 
> So what is the minimum SG entry length alignment this can result in?
> Once that get misaligned enough, crypto_skcipher_encrypt() and
> crypto_skcipher_decrypt() start allocating bounce buffers internally.
> That code has no mempool fallback and can fail with ENOMEM.

I'm not the one introducing ENOMEM consideration here. Indeed, patch 2
in this series addresses this very thing ahead of what I'm asking for.

> I think you'll need to take the limitations of crypto_skcipher into
> account.  See the comment above CRYPTO_ALG_ALLOCATES_MEMORY.

The block layer's queue limits is the single source of truth for what
the backing device at any layer can accept. If you've some constraints
that are not appropriately described there, then let's fix that.
