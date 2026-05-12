Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157A244E021
	for <dm-devel@lists.linux.dev>; Tue, 12 May 2026 06:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778566676; cv=none; b=uDteL41YXO91UTaOx6gXuSz+mFxfhFS/4oW56K/hJKMKunwkkenZuHpEzINEnFVxGAIjvH7BHKzc4cn2UmYeQ6QhvIYPxSe6E5ze2MtMpUhLLoss1haADL1YxVnTzsATASrGCg9m33Vw8cf4FxGDaXs+aFTcHnpaz5+jb0TEkDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778566676; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhekfPhRQQycLqEiYUxA7gkh8BBh5f6aWvSpXZbZII+5BGB3dVFliNm7amzAvU2hg4lSH+e7Wk2kdJmz/KMeFsje2tt/i+ehs/SYxe+LKRvukz2BjIp7RFktfOpIyKMUK8Inh+PQujXjFMOSvH8ZYID0OS52vC6364O9oFdj1ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 84B4E6732A; Tue, 12 May 2026 08:17:37 +0200 (CEST)
Date: Tue, 12 May 2026 08:17:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Casey Chen <cachen@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] block: recompute nr_integrity_segments in
 blk_insert_cloned_request
Message-ID: <20260512061737.GB30204@lst.de>
References: <20260511212230.27511-1-cachen@purestorage.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511212230.27511-1-cachen@purestorage.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

