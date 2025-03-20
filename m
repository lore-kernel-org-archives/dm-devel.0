Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E0C1E2613
	for <dm-devel@lists.linux.dev>; Thu, 20 Mar 2025 07:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742454681; cv=none; b=h+8+3o1+ZJgcONJPY6gjct2k9SzrqFi6XE4Z4WdLsbM777ICOu7xfurbj5Jj9C+6gQV0IEW0EBBtcBZQYdUvmA8z7e+Sv1PFtnb4WkS2gda0RUP2sifGRUNBpSSCMEdFzzEJXvDJjODQMsxtupcxpcFHkD9kOaVDRxkfOkGNgH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742454681; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h4OqVkvB/xpjQZjg6kDOXrnb9hWRR2eyggEoGf0NC67Pxp9xd99m2RhYMpRsFLvGn7XcAWsFCoVq0etyJVnNhwzdTuRrHeeJ+CEf+p6reZWDUDdHy/hjhpebbnPWl0dUDMhsgNXNL2x1lMpyndOMJI7bl7V4y0eBRbXXplllJjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 45DBD68B05; Thu, 20 Mar 2025 08:11:16 +0100 (CET)
Date: Thu, 20 Mar 2025 08:11:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Jooyung Han <jooyung@google.com>,
	Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH V2 2/5] loop: cleanup lo_rw_aio()
Message-ID: <20250320071115.GB14337@lst.de>
References: <20250314021148.3081954-1-ming.lei@redhat.com> <20250314021148.3081954-3-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314021148.3081954-3-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
