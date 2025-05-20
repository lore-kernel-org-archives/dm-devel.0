Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A4B2441B4;
	Tue, 20 May 2025 13:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747748817; cv=none; b=Nu55AerDcEN8yoqfro27Ob/3aP4T0qvZ2A+d9TuPWaLKOwwcYEVi0jkYKP1SJ+lejrSMut5gxbB4HDC/JQGvKmIu+abT7sYDZ1rBD24mPIYtLGjoiFhBvnSb0Js0s52uEahwDnRM/D4wudS3sXuyX70Vegm9x2yXSJ9vGvB3vGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747748817; c=relaxed/simple;
	bh=gT0qsOxXBK/hI+CUQi4J6/Jupa+PoB/pzblsZBJac08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DL95EdTyq9dM8QHY8rognDp5sESW4wJcwb1zyeoad+cXLWb6ydN1A11GBUOv0SEHqhKidBajFMFlvm9ZTY+Ntzk0VsNsvKFJdLvrc1Jm8LoU5ANNFAmrY+dRE2gNeswEKoH3dZob/PbXPQ5AaQt1hGWuR782GY3k+1lh5O6MT5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0mWEg9bq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0mWEg9bq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=042DvXqa0a9B9ggp4H5ETGqUUlZKP5UrH69lkxaNfCM=; b=0mWEg9bqPw8ZR9QDSBnQ55JuoV
	QOu6tZiYPLjBamefsfJEjWOQ1kjGecUvp3K1MLPqG1qIH/loFq1uLS32wr9Cq7vVLmZ5KMKeBIWUA
	HQZodUM1r4toW3pw+KI4komYwwahG2GR4ntl4dBS8ORTCNHlry5nKOa0Y1HlJVg19WHzMjf4hOYqm
	ZpKanebfZcHQ0JXXkGqoJZSw2uUCzRmB99w2i/Y+99egzwnjSDJ8gMB7rxgdOBw3oMSEhTyUkYYzj
	JTWd2zIP5cwyJba/j7uJLSHLxRasMiT+JqxGyh8tNsSX5ZQr4yxSgv0VQhm8mtT9ITaUuVpuTuHdH
	tA4kiKIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uHNJ2-0000000D3tD-0JWC;
	Tue, 20 May 2025 13:46:56 +0000
Date: Tue, 20 May 2025 06:46:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Martin Wilck <mwilck@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Kevin Wolf <kwolf@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
	hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCyH0KdvxLWEKdA1@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
 <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
 <aCW95f8RGpLJZwSA@redhat.com>
 <aCbUcdew393RZIkV@infradead.org>
 <f114a8d8497da0c452af33cbf02a55e91c47d94e.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f114a8d8497da0c452af33cbf02a55e91c47d94e.camel@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 19, 2025 at 07:33:50PM +0200, Martin Wilck wrote:
> I still don't get what this buys us.

You get one layer to deal with instead of polking into a leak
abstraction.  Qemu sees a block devices, checks if it supports
persistent reservations and everything is taken care underneath
instead of having to try to understand what is below and working around
it.

