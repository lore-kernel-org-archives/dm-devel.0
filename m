Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FB9182BD;
	Tue, 13 May 2025 05:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747115751; cv=none; b=d9qfxZMj9NUSSEdJu0b0oyG9HhNbUUEk3iYhm2k63dNfehG86yvaw6n1VXCAyPrhE5NBin9OT9V1I4G0v9Kw+NRL2bT9f2jaXpbwI1otK7rt3wPJwYRVozX2qM+KLsl3TWsFCJUpvADMO+3D3pUHPfpTwIfIZ8c0S5UpSatc1pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747115751; c=relaxed/simple;
	bh=RP49QrYotC4wtmWmzueEFIgQ7wUF7SzcF1AY4iJX48U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cBeopGT6bMj2ZXDQgcJpPmoi+qX5IH9MhGPCguH8whrDS/UU6Eg2CbcQbjNmGDoulrjtql9MYH+7Mj6AFRJJBDrcwrIBkZ+qGJ5oTQoKs1RgzngxRITAC0nN5kuQHXgIFiwBm5kh25kWnj5XHcEcGTPuRCBFUx8ZTiJLZ44u0BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dwsDLsD1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dwsDLsD1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RP49QrYotC4wtmWmzueEFIgQ7wUF7SzcF1AY4iJX48U=; b=dwsDLsD18ZbLnYnRawGnxEDOop
	yV3OyEngKbIJX9nuFRf8EJsTwRNMFhDlR77nzjuKHLDW3rA3BFHPpsrZpCh6LB8MtIIf47PVpNHJy
	1RpYEfmu/Rfg6sXPYgo8sFwiGbZMuipR8JigjNG9UD8l2x+WvB0/m1es7gL7q2RyKFdUw97cVALII
	//xn3RdI+TUIpRC1JLogKwS13XeJ22QHzmJ0HuSDkBnQrmMxHntxqcSIr2XoZ6aQCJIHUnmQUeaQ8
	DnoTANN6y9uJmHROXNXF0mBubY9PJnyxkjtLQiLWeLxEkswc01Yp34WOS2ePRH6D7AUp83+92cO9q
	0aWriOcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEicH-0000000BRo0-14pW;
	Tue, 13 May 2025 05:55:49 +0000
Date: Mon, 12 May 2025 22:55:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kevin Wolf <kwolf@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev,
	hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
	bmarzins@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCLe5UT2kfzI96TQ@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCIRUwt5BueQmlMZ@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 12, 2025 at 05:18:43PM +0200, Kevin Wolf wrote:
> Yes, it's a bit unfortunate, but we have to work with what we have. QEMU
> doesn't even necessarily know that it's dealing with a multipath device,
> so it just has to blindly try the ioctl and see if it works.

Why is qemu even using SG_IO to start with?

