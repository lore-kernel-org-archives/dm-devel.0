Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5324027FD54
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 13:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746537585; cv=none; b=rWyE71nydaNZ+CuCUoUdFNKO+7tu3jzKsCZy2apynFsvMaD+w3VXvBvpS2xCGef4dbG/3c+sH9Hcz1c2A9kuA1RFW5fjULYhEW9tmZGAN7LsbpOGVHLYFi7Srge/fhcnA6m3G+RrzKfo1DUrBf+VRrEbZ2898U+q1PwfUcjgCvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746537585; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IuNPya6wmj+EtyOFryeqP/Muq+fnpDhh2ygn/sbCehH4K4rgEKlLGRBoXftpM+9kb1raYkowPFTjxxG2U1kbvCs4Oft0TqTtVTnSJfgv1lOD/7F8oT9+ax8YRPkogucKmmtWSk2ozJ2zNBRCneQwwcEuKJCFSMlH5zHfpjhHCm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A4A0A68B05; Tue,  6 May 2025 15:19:37 +0200 (CEST)
Date: Tue, 6 May 2025 15:19:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, agk@redhat.com, song@kernel.org, hch@lst.de,
	john.g.garry@oracle.com, hare@suse.de, xni@redhat.com,
	pmenzel@molgen.mpg.de, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
	yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 4/9] block: cleanup blk_mq_in_flight_rw()
Message-ID: <20250506131936.GA26876@lst.de>
References: <20250506124658.2537886-1-yukuai1@huaweicloud.com> <20250506124903.2540268-1-yukuai1@huaweicloud.com> <20250506124903.2540268-5-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506124903.2540268-5-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

