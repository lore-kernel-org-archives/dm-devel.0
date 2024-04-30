Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8353CBE49;
	Tue, 30 Apr 2024 15:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491385; cv=none; b=kzH2OXCciRNnHdHb0IdYOscF8QCZq9jdJJRDRqJFmnG4hYV5qjMFn3V+x2n2vNWAQ2ClHvEl0GapwAxe8dto7qoWY8Bj+cOxU2X4+qwmF8W+l9VQ/Xowv02m0CuOb6lg6T64jlzhi8QaAGMNIPtyYOR/Xv2DjfXJrtyfDK4V0ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491385; c=relaxed/simple;
	bh=CcJ59gCPbLullnyFzeppQzSvwOWeES6rk5WPya67s08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNsINOEtCr+NJnXpPIPQMyH0TFMqVytuvRWh8D7mRNLCLCyX7S4CHey9v1X3MdMrlXf8w4T+3HiNTKvkVW3dVz2tIVBx4Nhu9iz82wpNypWsENYtG10bSMXsPmGCmukA3J7IP25b/oVVSYLdpcfXO1XMM+J4f/KFPuyFr9T72es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y3+NpFNI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y3+NpFNI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CcJ59gCPbLullnyFzeppQzSvwOWeES6rk5WPya67s08=; b=y3+NpFNIg9RPkhm1Zc9dTS94G6
	bukNYOXKqwKe0+mBIMTDehFs25vYNJuK8OilHra17V8PxJIXN7gVAp/MOc6uJ1Yfbq+0QLTEpUscP
	eLjR9lPjxkqkfuUwtK+kxZ4rpKAnpV628zUJg8W7kAkP5CytvwjHth8SF8S58kXYg3ZAiAuifEwDA
	K4fkZqDzan60k/OjdwaKIey2n5pmhPQ8ql0OUa8QURi9QYi9qt2K8uD5HhABwpXYJigecWxYVphQt
	YhAGfD6EtDY6zKs9TgODVrviXtReJlZ5ZSQgjpqmv9xBFWoD8rHl+IigoAHhUCqukjmcXZPN/jj9B
	4Vzxyzww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1pWq-000000074XS-0ZWX;
	Tue, 30 Apr 2024 15:36:24 +0000
Date: Tue, 30 Apr 2024 08:36:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 12/13] block: Simplify blk_zone_write_plug_bio_endio()
Message-ID: <ZjEP-LOfbpgONckC@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-13-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125131.668482-13-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 30, 2024 at 09:51:30PM +0900, Damien Le Moal wrote:
> We already have the disk variable obtained from the bio when calling
> disk_get_zone_wplug(). So use that variable instead of dereferencing the
> bio bdev again for the disk argument of disk_get_zone_wplug().

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
