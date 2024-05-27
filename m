Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8F815DBCB;
	Mon, 27 May 2024 11:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716810878; cv=none; b=p3EHjZMQ9vmea45JsNa80eshkALD4nwTz03cRyc+0AsrH8hmwzjyapJzd8ymGqX+tdLiVqOyEABmbJNGUGcwOvCug6tzJn1H+d3rz7BimX8bcr9sa1bg2kBoa9fAJXHaROYEN7/Jpd9HxhdypdUHl5WhBbpihvdOh+ejRUfkrGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716810878; c=relaxed/simple;
	bh=9hh0e8YI/CNqmrgTZOqYOdjqcrsxuitBXNBT7RvMvZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgllaNWW/ZuIwp+vI50OD7Kp3HmhjSm8tHc4TaFAh5/u6kO72ZsWjnsPIMk2xuFjdYQjo11PspmSqfhYHB34OG6FOLLTYU0p/nokajhbT80CdNHqNuNKZH5/LQwMhZTrUGtMW9a+FkrmyTs4FP1GvTyMEHsoUO0L8jz/3As6N8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e2DPtqIY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e2DPtqIY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9hh0e8YI/CNqmrgTZOqYOdjqcrsxuitBXNBT7RvMvZw=; b=e2DPtqIY+5sp7iagVMz5LRdHIZ
	yGQNfeChOVOKNXloSW2oYaAydJ5tws5lRdwOVtqYeeqpH3xvV5XMlGiaMVK15ZewH+goVCBTABsNb
	xgN+Dncvedx5uFrUerX0ouGJuzzWweTlLulg0S+azxSEad/HMXfBl5+xa0GiiQQLclPvn4UjlCzey
	Q0kGmn2sNireKoBNViNox/8Gc4Kz7MVzoSKQ02gSLxyV1/iKeFc+VlcD+zteTRC/vmQ2gDle2GXq0
	EjKGClR+1QpMK09C18oVJ6ST9yp8vq3SoE0S8EWcATTo1vN9GjJMSeiR//ESHSjo4XTuLF1M7DDJd
	XPNuYMaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sBYvz-0000000El8d-3JSB;
	Mon, 27 May 2024 11:54:35 +0000
Date: Mon, 27 May 2024 04:54:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: convert newly added dm-zone code to the atomic queue commit API
 v2
Message-ID: <ZlR0ewboGeRJQY-3@infradead.org>
References: <20240527080435.1029612-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240527080435.1029612-1-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The buildbot noticed a link failure due to a missing IS_ENALBED about
a day after claiming succss, so I'll resend another version of this,
sorry.

