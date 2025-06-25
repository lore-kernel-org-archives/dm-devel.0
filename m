Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A0E2D9EC7;
	Wed, 25 Jun 2025 11:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750850888; cv=none; b=jT8VttQa0d2UgVUQKac9U/lgdoW4E29L0YbJUTa/7JWiB3sb00pJpqqen0kQTiYW9mlmOWwezniNkWwDd3aMny5DilTjKqOV589KXQoLl3sFMxmQn+Dxt2xSNCGZnDFIq/clGlGkfFFDl4YazROa06ZjHFf+LT02JQQ4ojKroP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750850888; c=relaxed/simple;
	bh=PZohJwpBIiCNc2Tr1Bh0rGo7QQJ9my1Yi3uRkhj6vXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVExuHCj5GW+6x7YjR5iH7aFYPjI/8QBR5xvJRy1Drkzq64Iz/tPSy3bOgcHXOmmTP9hu4efyrOWX862u3kik83SYxcPvMguGevkEBFisCyxtkANOGx5z8BL08YzJaWPxJHOobgH9BQ/d9WU7l15docGx1CcBk8FKsYBYP5eP6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jJhUI/lU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jJhUI/lU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PZohJwpBIiCNc2Tr1Bh0rGo7QQJ9my1Yi3uRkhj6vXU=; b=jJhUI/lUdi8vlHY9+a9f8Umza7
	4yf7SWwv4BcRiglUZVHnUTAJTXaya2Ohx/Z5Pp2fBI5hG694fvaamCkVokA0DnOFqD6b/l1ogODaG
	Y0crl+bWutOOMbSeRrXIc+N6Bwp1muGZspp4GkaMtWIj5SV5mt0yxyYpSWd19+6XyMvd09ikZEEaM
	F+AzrXNNE8AOuAn0oVMJmbCCE1VHrl8Jt+NgCVt5rmMkHNFqt6AzDcTZpRnXi4HVqZSYA/iLrFeuc
	rPEH4+FWNAvT6blr7mAN0MzYs42umqjBAtzWB2VXuJRtfzZ75XRQLhvAqbx1tzPOhKK8tGKxiMW5p
	2yWuC7oQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uUOIQ-00000008TIe-1Y8n;
	Wed, 25 Jun 2025 11:28:06 +0000
Date: Wed, 25 Jun 2025 04:28:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [WARN 6.16-rc3] warning in bdev_count_inflight()
Message-ID: <aFvdRm4Ec8Oi3uBT@infradead.org>
References: <aFuypjqCXo9-5_En@dread.disaster.area>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFuypjqCXo9-5_En@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There's a test patch for this on the list:

https://lore.kernel.org/linux-block/aFtUXy-lct0WxY2w@mozart.vkv.me/T/#t

