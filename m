Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DC1213E98
	for <dm-devel@lists.linux.dev>; Mon,  9 Dec 2024 07:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733730371; cv=none; b=JJioc243O9xqmQT/6e/F5rxgwqEhYwcL4Mpy4Fs7QBkmvb0F5Frv2ne2lBwCGRtYhP0D5dfJYjaQwq4heRruZ9ts8+wrW2Zy/PTFgXRWCoVEFLngexC7jQ4QYa3EeDD8SGNdCZ3CTjkr/ccGrdeMcEbXqlDU/oLRXd69yWMC5Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733730371; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IhJOX0Duu2Q2v3EOvHt3Oh7NonRvFzWdc13+WIWW5gCGRSg51yB+0yk0wUnmNp1C10kINvxjpL3O2fvCVXLeubn8jwexLvhhDTV7Xj//mjsbSS/lEByPS9IaesCm3TyOtqjjhSTQpj5D++1rs/vDZeB8fzZ+vnccY2wfUZsOllM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 38B7468D0E; Mon,  9 Dec 2024 08:46:07 +0100 (CET)
Date: Mon, 9 Dec 2024 08:46:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 2/4] block: Ignore REQ_NOWAIT for zone reset and
 zone finish operations
Message-ID: <20241209074606.GC24323@lst.de>
References: <20241208225758.219228-1-dlemoal@kernel.org> <20241208225758.219228-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241208225758.219228-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

