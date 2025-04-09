Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F9317A319
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 10:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744194994; cv=none; b=HibSpyAyB6/7B7X25WCTfr1tOlleynp3bla11mUdiYD5yPi1YOh0GYbgOtVfdLeChP5rnlu+QtLHP58DnvZHEmp/NSi/WbaDQGZST6q8ZSTJj48FFWtaHEEk/pCE4o+o6VT0UjpzaIia9noSMW8k0n3F4E7QIQjhJ4k/H6v4lCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744194994; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5qUJEufJHacItF0RRHzOTnubXtQ9AIqPVPoXzFpIDZrVveRyIaQhXBpoYwT/Ei6lGUg6CCVoY5v1+HkbxhkNAT87LM3S/DiQr0Ct4szHPe6MxVwf2yEcmj4GyRPyXnfPiUt9iEuee+Fbeym8ET7nSDK1MhWaQZjrtE4nEQEIHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6283A68BFE; Wed,  9 Apr 2025 12:36:29 +0200 (CEST)
Date: Wed, 9 Apr 2025 12:36:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de,
	tytso@mit.edu, djwong@kernel.org, john.g.garry@oracle.com,
	bmarzins@redhat.com, chaitanyak@nvidia.com,
	shinichiro.kawasaki@wdc.com, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [RFC PATCH -next v3 09/10] block: factor out common part in
 blkdev_fallocate()
Message-ID: <20250409103629.GD4950@lst.de>
References: <20250318073545.3518707-1-yi.zhang@huaweicloud.com> <20250318073545.3518707-10-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318073545.3518707-10-yi.zhang@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

