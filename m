Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390D12D5C61
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 06:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965816; cv=none; b=GdhoG+wKqLub4WpybQ0CYkY19P8NQSHAYgFSKmeUxy0UfPLyTo7CZ1Dwma7CsAi3AusXc4deKb//6gQCPHjNnFd+XTySnAB3xbZaljNDRMvBI95GdcPLw6MUR0Jwu0A3a7EKb/rS/u3KssNijeGoaeqp6ROrHgW1iPigmqPGVtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965816; c=relaxed/simple;
	bh=WIVG4JvopaUAhb6ikTuILxILFdoaTMcY/q5G1Hl4Ync=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n+5yPrSefbo8z5z8rakZ+xTLn3L7NupvjqeMrTuJYWFwyeJA4rRYYgW2OFB4MeamOk8LxRT7gO6CTaCh9mFnF+Dpbsql6kq73v4R9I+fFJR+E6pgeJ8Qfg8IoAKAA59tbxxRx3Yjc/KSQD64U9q3xDWPJ38487eUMyGzY7iHff8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B44AD68B05; Mon, 24 Nov 2025 07:30:11 +0100 (CET)
Date: Mon, 24 Nov 2025 07:30:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
	mpatocka@redhat.com, song@kernel.org, yukuai@fnnas.com, hch@lst.de,
	sagi@grimberg.me, kch@nvidia.com, jaegeuk@kernel.org,
	chao@kernel.org, cem@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH V2 4/5] f2fs: ignore discard return value
Message-ID: <20251124063011.GA16808@lst.de>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com> <20251124025737.203571-5-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124025737.203571-5-ckulkarnilinux@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Nov 23, 2025 at 06:57:36PM -0800, Chaitanya Kulkarni wrote:
> +		__blkdev_issue_discard(bdev,
> +				SECTOR_FROM_BLOCK(start),
> +				SECTOR_FROM_BLOCK(len),
> +				GFP_NOFS, &bio);

This can be shortened a bit as well:

		__blkdev_issue_discard(bdev, SECTOR_FROM_BLOCK(start),
				SECTOR_FROM_BLOCK(len), GFP_NOFS, &bio);

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
