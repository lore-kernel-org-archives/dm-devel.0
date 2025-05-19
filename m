Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6DE1E0B86;
	Mon, 19 May 2025 05:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747632740; cv=none; b=f1sHgrybV4Qk+ykF+o4iy9oazHOBnttHsLAENqyyAIwcPNxdJugxRCuTxqVKyRo7OlTsQe4Um3jExul/HfLQMNDq8pBSqxMCV8+kcSsZWjuz1VWcz0nEWuj3HdJ0kL5O7XsimOcHT0SMY0fYFQ6r7KtLhzXuk3cV8tMhqbFhmco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747632740; c=relaxed/simple;
	bh=jWYI5g+vVLiBOzrfAXt/iaQKvkvYcWBSghpAXs28Q3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7KFArxSEsVLrsplWN8In3u+asRkTF6jAMwT5qJEMF3sx4PngNWLhNgNGkEASHogzGxdYtR/8C1bj+A13j0ZZWvpO+IXOecALvDHG8A/e5tboKYx9miPOkuvSf8wQWR2oYf01YY0mGBxRFtTtkr3omUWWdh3fxf4Q76E33siTas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iUouCGxF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iUouCGxF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IEsfDykr8+4fWC+m7DpvjtvuBBE7sgNCtd1n2wYel9k=; b=iUouCGxFog+mPPutazH6N0pUPC
	Qr3eyxBur/7ohGjygeXPb4BBiG5JlNP1Y3KBG25V1lLRrDAOwUzG9deUNGeziJ1sw7YHXwv5dXGI/
	idbgsmxcpnH5izAZUmaMQmG5y+oqFNfdngLCdSX+KU9r9KxE9XYqA1YDOSkJts56NE+liDH6kUHcg
	ImqHueG8Hgeu/TYOggPLmRxlGy4Y2tGescukkaiYbUaC7WYrAtJUT3blUZ81dJtquxjLmTEFDUvVN
	Q1laRD1UgMiz8BVSWKHm7eRKbiyg8xyQAkOblwDLkEMwmZlIYRR35C4iqyv2lr2e7f8TCEAidkosl
	HNuKvKAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uGt6n-000000081xS-19vB;
	Mon, 19 May 2025 05:32:17 +0000
Date: Sun, 18 May 2025 22:32:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Kevin Wolf <kwolf@redhat.com>,
	Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev,
	hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCrCYbvOJs44Kj5a@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
 <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
 <aCW95f8RGpLJZwSA@redhat.com>
 <aCbUcdew393RZIkV@infradead.org>
 <aCdifWdCQCR3Nqb0@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCdifWdCQCR3Nqb0@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 16, 2025 at 12:06:21PM -0400, Benjamin Marzinski wrote:
> I've run into SCSI arrays that always act like they were called with the
> ALL_TG_PT flag set (or perhaps they were just configured that way, I
> never could get a straight answer about that).

Hmm, that's pretty strange.

> libmpathpersist accepts
> this flag, and only sends one registration per initiator & target device
> when it's set, instead of one per initator & target port.

With "this flag" you mean ALL_TG_PT?

> dm-multipath
> currently doesn't have the knowledge necessary to figure out which
> devices it needs to send reservations to, even if the kernel PR API
> supported this.
> 
> But I supposed it could just send the registration normally down one
> path and if that works, it could just ignore the existing key when it
> sends the registration down all the other paths.

We could add support for a similar flag to the kernel PR API.  The
problem is to figure out how to discover support for it.  What does
the library do for that currently?

