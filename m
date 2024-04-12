Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AE6E542
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 06:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712902290; cv=none; b=jNibWDNiVUPgI7fHB3aogR4853dtTo0MvOa6fw+CxhEqsP90+bstL1KiXARelLIt3qjqXmrXtGYvy02/jHHbo52m5TjZc37haf/ngw7ALmPPre8peIGfyupoWRGcKigqTJCDYE0kc9brnpTvLWT0M35ZQoZnofgtVv/zcLtPCr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712902290; c=relaxed/simple;
	bh=rKvSEZQJnJxHV1+OoyvpAmGFl6o1Vusg95ULpcTMwh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSIYRbDIbi8evqD64mCxYzL0cTYPm2NfPMtPIlSQmapqtbah4rmAtrQVNI582P9YLtkg1kj6u/f+BnPnFVdHyOeORvC3CWxzMoJNYOwr2NCYBWROx9K7jF9YUHfAddyZrZZrULCny8Db869KAi7P2e7jspi5LhUE9PWPuitRuaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6BF4768CFE; Fri, 12 Apr 2024 08:11:25 +0200 (CEST)
Date: Fri, 12 Apr 2024 08:11:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: hch@lst.de, axboe@kernel.dk, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Abelardo Ricart III <aricart@memnix.com>,
	Brandon Smith <freedom@reardencode.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH for-6.10 1/2] dm-crypt: stop constraining
 max_segment_size to PAGE_SIZE
Message-ID: <20240412061125.GB32319@lst.de>
References: <ZfDeMn6V8WzRUws3@infradead.org> <20240411201529.44846-2-snitzer@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411201529.44846-2-snitzer@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Yes, this is the right thing to to:

Reviewed-by: Christoph Hellwig <hch@lst.de>

