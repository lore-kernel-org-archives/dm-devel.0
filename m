Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B671773D
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 06:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712556148; cv=none; b=FSGLN36OlgrKawNh+7j0G95PtIljINJqtL+7djW0vFNPz6f6So4yRMCHlOb9P1nrxbfARC4Ngbza+u2JLfb7CHSZZhLr+zZyu1NiinDkNAORUwWzpa+W3rkf67qqZ66wTQ1HUa1Dzs/MbHYQV/Pee+juwdyinlSCMou4waUdx/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712556148; c=relaxed/simple;
	bh=3CaYQkJIzeUNrGgpSaGOyOZnWNfJoGMDwjXQF8sOFwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iaA6AgAVKgXgbGqVscwYawIMLuYsGtpl3Ajjgfo3w6rVSROOnJTdxPtSXVzCg7XsH8WmXrbuXy6WRvC0qGJUWB1ovP7ulrxUnJLxvz+kaJZJnQHtfO+V9E7odATPmPLlHP1ZmcHQZdRsZShJPXP7gADhpZbKTbx/u41AVijr59g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A424168D09; Mon,  8 Apr 2024 08:02:19 +0200 (CEST)
Date: Mon, 8 Apr 2024 08:02:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 00/28] Zone write plugging
Message-ID: <20240408060217.GA15846@lst.de>
References: <20240408014128.205141-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408014128.205141-1-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

FYI, this still looks good to me with the minor changes from the
last two iterations.
