Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C50F2D73B2
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 06:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965871; cv=none; b=PPSXQM5GZE7ftf04eDgTeNIWi0oNweaNda35fSU+qZ64M4NnaQOEgXor4PIqbXtfmRNE4486e8Hgxilt4aBLnObv7LxAOu2EHi8yQAg5GbCwogadgW5cTES4ejpqQF3a2z88+yZ6gLIfjdh8lnf1eyqKZoNGw5vi3OJTRwftlhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965871; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jvAh5itFUngJdi9x4KW+7HlP/oqHmLLYSQDuMRmaANXDoiJCdSDiBEABSl/wShMG6j3YPuJPEqBjgcCma4fhDNfNnzvJjLOtG0fwsCM22XeULZXENqFj0LD4G65G58Xl0CbIVSxP6mtK6JJqlMdO9Al0fotYJFxtfQwLcko5NFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D26B768BFE; Mon, 24 Nov 2025 07:31:06 +0100 (CET)
Date: Mon, 24 Nov 2025 07:31:06 +0100
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
Subject: Re: [PATCH V2 5/5] xfs: ignore discard return value
Message-ID: <20251124063106.GB16808@lst.de>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com> <20251124025737.203571-6-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124025737.203571-6-ckulkarnilinux@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
