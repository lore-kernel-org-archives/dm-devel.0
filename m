Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10223143747;
	Tue, 30 Apr 2024 15:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491255; cv=none; b=UYOEcRg8oGjFrpRUEbX968jovqTkCBFrAvgZZrDZ8BA4/yqOu0/p7wj0qvNXpWhJPmc6ONCIUko0Ms7Xf+eRoUq/SGjm8mq+iXiiMD9Ad//HVR1h2Kyvq/IeMTZk4Pfa1N1GfGe1ljpOpK0T5nXr+K5jRZPfBtTCxRtRbqgZwqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491255; c=relaxed/simple;
	bh=tspu44Qlw2KpzOIKQKz6RchUuxwgVFCQ49VC/znFRJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ggL0XC0u4zJsasR2Jtpk5vzX/WgSj1RMtFF7yJIJirPK/4RoxCMujOcLu0EhaWowoH3+KisO/nL3m6IwoSiyGOlHC1Z0SJ0qljqGMhGUcnYSaETCbzPEf11wV/CvE1lqJREa96oqKyLvsjjOsYfxyB/QrHhFduqy7ry27LhCu/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lTNr15r5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lTNr15r5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tspu44Qlw2KpzOIKQKz6RchUuxwgVFCQ49VC/znFRJs=; b=lTNr15r5oxjBkzNAu4IU1Yuv3k
	e8f+J17/z6ypAGacwJT+5qEZuRVfp+7rgIkVHfeFmTloV1h6ccGxCnYiU8ZPWnFffYwR5+fJ8baAO
	B60BHPyydsEnzJyqCErnZft8M4dZpE0Jc40fiNJffb0IeWJp6HajBLnvLiOsogoAsbILEug7wNuFo
	Kk+f9317VmJqzud1adjkGfpg7f+rdEokeZ2ONmLhhDwKveSNoQI5p12GT5InelIA0qjxCkhKRAxOE
	zsUa0/BwE7/q8kFr6YqNyXDpnZa+AgDi8d27hrmmw7YOZskGVtYDj3lfwbDfS/a0VvfAX1EJTZnOP
	6XyGfzxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1pUj-0000000743F-1gsU;
	Tue, 30 Apr 2024 15:34:13 +0000
Date: Tue, 30 Apr 2024 08:34:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/13] block: Do not remove zone write plugs still in use
Message-ID: <ZjEPdVYmPYt2ilAu@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-8-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125131.668482-8-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 30, 2024 at 09:51:25PM +0900, Damien Le Moal wrote:
> Large write BIOs that span a zone boundary are split in
> blk_mq_submit_bio() before being passed to blk_zone_plug_bio() for zone
> write plugging. Such split BIO will be chained with one fragment
> targeting one zone and the remainder of the BIO tergetting the next

s/tergetting/targetting/

> Fix this by modifying disk_should_remove_zone_wplug() to check that the
> reference count to a zone write plug is not larger than 2, that is, that
> the only references left on the zone are the caller held reference
> (blk_zone_write_plug_complete_request()) and the initial extra reference
> for the zone write plug taken when it was initialized (and that is
> dropped when the zone write plug is removed from the hash table).

How is this atomic_read() based check not racy?

