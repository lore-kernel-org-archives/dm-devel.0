Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD3320CCE1;
	Tue,  4 Feb 2025 13:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738677019; cv=none; b=J1Jcp0pe4PvNMEJg/t9x1LUW9B7aDkQ88L7lM25NQjFeuv05QM4RuUJebnBZUflG3aYCifijysrilhrCV5MWZ0PIHX1w/Yt5uq701v5lkPclwEd8S7Rvam3gd62kCHfFw2iIoB8iaxZFR493yIqpUIgYFo/YQtotO3WKsvbLWpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738677019; c=relaxed/simple;
	bh=TcGm65x2pnbcsnDgPJw0YoxTUVTJc2sTDwdaQOVoQk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bh9vVHGYsT+iw1nCp4boHbPkdyEIIqUrMSjx84OuxDubnNzwnhnHjWpKKlMJWD0UYQLuh/8z63+M5T2wrXZbV4IAyO1UdZo8j+2EYji+VwKSRqso7p1aTI500Gr7gihjMZqtuvpPA5BWJ6HobiOXQyITaajRi3WBBr5ulRGDeCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4IDKkgCA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4IDKkgCA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+KZXpS0lPgrKjUFBY0uZhNSyVQQKGba4rc5yeIgtUYc=; b=4IDKkgCAhWWwNyQCZ/CdxFtBwc
	y03PrnVgz9z+nuWGkpBWBhsSbQwzbrQJgE1BuZ8F+OcSlf3Phpi04C5MqIrwxmNOL7FbEc1ORRh9k
	3kyovLbYFA36qPYeDw3SmGbm1LXPCjsta1TwO8arOOI1prJ/rj4Z47j+xIaJQns0Z/Qoc4Wg6RIKT
	1UdMwX2YG4gHMDZmm6Z8oqfQn3Ht8s4p/D8cbbooMxgDl51+bebZGgqmBf9xbAb3n7lElJ2oOO46S
	79sOHZ2+afg6pMBnQcOdgneeBJ9elumpZZni8Wmg+hfT2jOGFBOCPHpeNEBaAOz3imuaBwne/FnAN
	c+dY+8mg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tfJJg-00000000aAy-0m9t;
	Tue, 04 Feb 2025 13:50:16 +0000
Date: Tue, 4 Feb 2025 05:50:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
Message-ID: <Z6IbGNYoY6DjjYpG@infradead.org>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
 <Z5CMPdUFNj0SvzpE@infradead.org>
 <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
 <yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
 <28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
 <yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
 <Z6GsWU9tt6dYfqBL@infradead.org>
 <yq1zfj1eusl.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1zfj1eusl.fsf@ca-mkp.ca.oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 04, 2025 at 08:02:17AM -0500, Martin K. Petersen wrote:
> 
> Christoph,
> 
> > 0xffff as the max and a weirdly uneven number even for partity RAID
> > seems like a good value to ignore by default.
> 
> Quite a few SCSI devices report 0xffff to indicate that the optimal
> transfer length is the same as the maximum transfer length which for
> low-byte commands is capped at 0xffff. That's where the odd value comes
> from in some cases.

Hmm, optimal == max is odd, and I'm pretty sure it's going to confuse
the hell out of whatever non-sophisticated users of the optimal I/O
size that Mikulas is dealing with.

