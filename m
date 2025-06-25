Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A86202987;
	Wed, 25 Jun 2025 12:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750853642; cv=none; b=Nx3LSMkai+4r6SLpptD6PEoAD7JXO2+O5gtQ0thjAnbmDh3RRI+OTL+zaJVyGuJgTrWLxHu7n8aoAmxPjAf+suBHrhGuGJeFCsNUO60W5v8KH63kuHQb/83EUL6+eWzIcgLcnkra4ZW/dFB4AQW038d19935BL7hHC+myqfkTuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750853642; c=relaxed/simple;
	bh=za6AYq2b4yrReV3qrNlX9mFH22vhIxv2G0LL5RvFIxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMuuGk2Mf+wSnQ8ce2rfSX+1D5M1aXZ0I6Q+NVvDcE5/8G3iRX9Tymh9LXGHUO7mme9aCW8ruVoKDSeOtVlCXuFyDuI1sJuI/hFwA7SYtEBv+ccTjJT3FIJhBnezAI0fEH3iLWrbTr7aq6Op66bVFiZR6vPB2Dp+yYnTrxBhNcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SPdrqZgm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SPdrqZgm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=q2KJiPZKc2p9FKvFob5Y5VCXR4ho8+2HouPQIFIySPI=; b=SPdrqZgmbk6ewsQlWbmoVIEIq7
	qxBd+10gXbMJ77bHdfi3GHrpHqZhmKyzr5HkIhZj5RNk5WT9Ln1eYaIgq73+VntdF4QE+63PnjC3M
	oPyETw/AcyakNdrLS1WrMp2gkaI2ezVzIos+v/eonKORF5F+Sd138C8pycGwBe3RnJrI8bkyKGyVp
	SmUgupfC01KoUw6SSmSIF9/0i7/Da09h3gYXgR6H4nclK1+f+TVqfj5NyVzStG0T15TYXUKbdyAbY
	z9QGffbIoZfExLftNjlEO3PlE4FLLGlqIgrTHf61KjqUWV3VQJVb82/eZbC+3YKagwvVghm1nvvot
	UXNMNb7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uUP0p-00000008agq-1is8;
	Wed, 25 Jun 2025 12:13:59 +0000
Date: Wed, 25 Jun 2025 05:13:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [WARN 6.16-rc3] warning in bdev_count_inflight()
Message-ID: <aFvoB-oP4MXuzO-q@infradead.org>
References: <aFuypjqCXo9-5_En@dread.disaster.area>
 <aFvdRm4Ec8Oi3uBT@infradead.org>
 <aFvnqZEHCkikG6xM@dread.disaster.area>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFvnqZEHCkikG6xM@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jun 25, 2025 at 10:12:25PM +1000, Dave Chinner wrote:
> On Wed, Jun 25, 2025 at 04:28:06AM -0700, Christoph Hellwig wrote:
> > There's a test patch for this on the list:
> > 
> > https://lore.kernel.org/linux-block/aFtUXy-lct0WxY2w@mozart.vkv.me/T/#t
> 
> Ok, so when is this planned to be fixed? I've hit this at least a
> dozen times in the past hour with check-parallel - it's causing
> significant problems because random tests see this trace in dmesg
> output and fail, even though the tests themselves have passed....

From reading the thread I'd expect a patch to be submitted ASAP,
but that's as far as my crystal ball reaches.

