Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678A71D8A0D;
	Thu, 16 Jan 2025 09:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737018789; cv=none; b=hpyAtEAOzFgZQM2z5z6fN1CWu91i56y8DU61bEKZPEiVG58mAa+ADiylVs4V7Nnxuc85111cJcFqJbs5XrxZxWiXHLBSn3QiAMHxhMXQj03+K2zU0MIkcDUHq32/Z3XkZkVxAUQW0jgfMxtGz5umec6LUHEsHewcMEfftH5nAuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737018789; c=relaxed/simple;
	bh=t5Fl+gns+MN7ehWwDDXaQRsSZGhSXe1kAdF4VCXP+PM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5KiN5CcfCrNPydSLJEJgJ9IvpK0jR1GVhV/xc6ysgDC8YVYXy9bJeVrfPryKKL0GTuoyPX+Bu71I6wk7JRmFyRLqbUK2s1JqnIUKmHgG30Z84d00F9yN+pc6hc8eXyMPj7sGpGDqVp1peVl9OBncIOVv8eLzntdj97aWGGzPL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OZE7F4If; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OZE7F4If"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YPDUhnJT2q+ZG68dtaioZVuYydEN2X34VOu6ixhZU7c=; b=OZE7F4IfstpbFYzAp1DMEnOG0X
	SKDr8iNFikRPx33UAgFJDdVxjUgGPP40TSpfjF6dIMhLzPs/R5/Pp4FlwVpFH/KOYvv3z3iPxzbmy
	D8TrK/Gnqp6/1wo8Cbltv8XjRofj+kvdsNreefsf/8v4Y9wyCjmxrXfws5D/oM9bJ2dGdOgujpTKg
	2MzVHIH1SJAZRIgyNDMxcuHPnohzRfEZYSKenY+DX4L8dpIXeGGsbVsfrlv/tKeHnrnLr6CDyKhEo
	JaBWoJaGRG+XA5LCQZj3tO9LpYVFtRrZm1HfyrDoqn1oUJglLRBMxEJwNixIqi1sn1wlUD+c78w2B
	MMbmzp6A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tYLiy-009hG2-2w;
	Thu, 16 Jan 2025 17:12:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Jan 2025 17:12:57 +0800
Date: Thu, 16 Jan 2025 17:12:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>, mpatocka@redhat.com, agk@redhat.com,
	snitzer@kernel.org, ifranzki@linux.ibm.com,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Message-ID: <Z4jNmdb4Bacom3-j@gondor.apana.org.au>
References: <20250115164657.84650-1-freude@linux.ibm.com>
 <20250115164657.84650-2-freude@linux.ibm.com>
 <20250115173736.GA3712753@google.com>
 <85ea487d37ec320ec5707bd249352b02@linux.ibm.com>
 <20250116080324.GA3910@sol.localdomain>
 <94e11912f1e1413ac2d13c7e5dc0ed35@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94e11912f1e1413ac2d13c7e5dc0ed35@linux.ibm.com>

On Thu, Jan 16, 2025 at 10:00:36AM +0100, Harald Freudenberger wrote:
>
> Eric your idea was whirling around in my head for at least 3 month now.
> It would be great to have a way to offer an shash() implementation which
> clearly states that it is not for use in atomic context. E.g. like as you
> wrote with a new flag. I'll work out something in this direction and push
> it onto the crypto mailing list :-)

I don't like this flag because we'd have to modify every other
hash user.  For example, this would result in your algorithm
being unavailable to IPsec despite it being an ahash user (because
it can't sleep).

I think the dm-crypt patch should wait until after I have added
virtual address support to ahash.  Then we could compare it properly
with shash.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
