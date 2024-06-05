Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1329218F2CD
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 07:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717574081; cv=none; b=iNeB6glmA6ST1yd6TRd7KGYmuPBtivdaIQnD/AzTes7XuMJUUvPRlyqno+ZbDB6UFM6kvpjioQLfU0HC7ODjJxyfQWp2ng4rtnlMkP3ufi3xkKEDqEI0XF7Fq1gKKBgyqbezb41BEZ3vgR1aRaTDbwiKBgySAs6lcusPSQj0R+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717574081; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=az8Gzqv5nzOzd34j6XtU4t6o/klIthbcI18LkHqUajyKO/xFSab9mB1gvMrZ5qY5DJKMEaJM9Knd77o+mGrzT9vI9m1xFIr/igkVoyH4lVv/KbnQF4fCYk7ZxxJB4CNTaAUSWA7yMeAwOhKpTWjfxPcJ5tt7KCZZaVlACSgg42k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B7F868D0D; Wed,  5 Jun 2024 09:54:36 +0200 (CEST)
Date: Wed, 5 Jun 2024 09:54:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v4 1/3] block: Improve checks on zone resource limits
Message-ID: <20240605075435.GA18465@lst.de>
References: <20240605075144.153141-1-dlemoal@kernel.org> <20240605075144.153141-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605075144.153141-2-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

