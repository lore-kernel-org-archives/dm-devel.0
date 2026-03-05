Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBECB3803F6;
	Thu,  5 Mar 2026 14:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772720092; cv=none; b=O3fPphShzrRCZbT9y/pa9eH+/MbqTLTKTMIzhKnWQvP+UcBif7q6v/Xx/K2foaZ/siM4FszbaRwiUZo5v5SyYzC/JAb/YXZz851309Hn5upNMTsdvjMl8t/aPDFLW6Y1jj3Mh5VArrdQutLA18dE457Yg8Dt3dFDNzP54GJQP3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772720092; c=relaxed/simple;
	bh=VyACtQ8FtLAF8W79RsrWoCkj/Khk2u/PvVKY+BBKGME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HbEpYfSU7P96Ich8mmzHO9+V/Z6KBZKmT8UB6OZVgaMi6ihsayafZn0Qkm/oMqul6VQxTJwRrfkiDJIb/bg80BBXkuxlEIFiOi6ls4+ZXIuJKL7aMWGrO5qgGAVzY82c5uy7my1lXHxzvnqkHyDaRWkb/UO/KM4IlRErMBQAJ7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U2aAmqo6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U2aAmqo6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VyACtQ8FtLAF8W79RsrWoCkj/Khk2u/PvVKY+BBKGME=; b=U2aAmqo60Ca2/4JMxoWYSz2OVF
	8QLmkiTeD4u5i+7Gd0GWJoGUQndeSnQacyao3D9qsQBZeRoOOVpM8JMUAmJxvyQwmheNYR+hSMJ7Z
	cWMb0FsOXd7+ooYDZmyz+u5PanFqzy3OnVz8D7RdoaUDxNCbse76mdMg76J9SDdj0yXMX8JQfDSd4
	iS2zckLHXZTKDFIJOSjCMzNUge0cry9LRaDjszhjh9063HVjUBzB7amJykGVzfJ6Gt1xNMRdUClrm
	hdzknJxq7H1R1g5INpLcftONLawlD22PRX+CoSl4YLlm8k40BUuFebC2Ys96u4Z/NZ7VaelX9mQ9L
	9qZn6wwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vy9TW-00000001van-3rd0;
	Thu, 05 Mar 2026 14:14:50 +0000
Date: Thu, 5 Mar 2026 06:14:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] bio: use bio_io_error more often
Message-ID: <aamP2qNKEmiyXQQH@infradead.org>
References: <20260304190424.291743-1-agruenba@redhat.com>
 <20260304190424.291743-5-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304190424.291743-5-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 04, 2026 at 08:04:09PM +0100, Andreas Gruenbacher wrote:
> Instead of setting bio->bi_status to BLK_STS_IOERR and calling
> bio_endio(bio), use the shorthand bio_io_error(bio).

I'm a little torn how good these helpers actually are, as
hard coding one specific type of error seems to create weird
code and lead to bugs like the xfs one you fixed yesterday.

Maybe we just need a bio_endio_status() that allows passing the
satatus?

Also you really need to send one patch per subsystem.

