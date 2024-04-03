Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87128133981
	for <dm-devel@lists.linux.dev>; Wed,  3 Apr 2024 09:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712137398; cv=none; b=phIS5KrLWwu+mMTYFMv7B8GKKIAhTkKUpuZ3SIa1/9fdoJs+dJm4SUzlCw6pygnz2RM+xEb+xXJC5Moq+9oVFwgzShPOL3ilhFvfsvry8MH0ENh1OBP2h/Bxiz2fgFcq0NiqQIDep7RBHp1pqpHPbbG3zN2jJKEU3idnAn7Vq0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712137398; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nqb+01FzlIqMGUVGG3VlSvnTx89mOukjazlH5bCbl/AWe+c1gIlzviwqOlllanZejCSwfmJWKbZTzqZtflISY6KsaBo6aaNhsBOWHD/GWpq1wmOelCndT5e4M332+GUjNTXtqmxKo9N90rQVG9pPrURBGI5tA0S4I85a1NWpyIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA82568BFE; Wed,  3 Apr 2024 11:43:13 +0200 (CEST)
Date: Wed, 3 Apr 2024 11:43:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 08/28] block: Fake max open zones limit when there
 is no limit
Message-ID: <20240403094313.GB4828@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org> <20240403084247.856481-9-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403084247.856481-9-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
