Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDB3BA34
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 15:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177844; cv=none; b=GC1ky+lUUK+8qzUikSGncxiIjkaeOTTzIs4DG8vMS0+SY1MfaEjT+YApU1oBYeATQDw3urSwW+byrUUyggfW4Ckl9DCj5H2f27MRacWkQhJwxWKvWyQj9YJx6IDe94ajEpCDBuCh7Zy52fNq3NjnCqMwwCYnDESkrmBx1dHr/4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177844; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQfQc1AWbLxRWT+Nrsy6xxMFgZvZFLQmIGtBaQC6NbmlUxLokib/qdtF72R2y/gqkAlSCpbzN4VN1VE0hQWXAhZgkTlukTzu7ccCPITuxvJQAh9Evxhg2HcO/lyyFjByFUF1qt5XylBRJBoz8l/T+RXscN5wDp/oItxVDMMlRB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BEDD568C7B; Mon,  6 Jan 2025 16:37:19 +0100 (CET)
Date: Mon, 6 Jan 2025 16:37:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, hch@lst.de,
	mpatocka@redhat.com, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/5] block: Change blk_stack_atomic_writes_limits()
 unit_min check
Message-ID: <20250106153719.GB27864@lst.de>
References: <20250106124119.1318428-1-john.g.garry@oracle.com> <20250106124119.1318428-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106124119.1318428-3-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

