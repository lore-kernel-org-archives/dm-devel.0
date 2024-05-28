Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574CE43AA0
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 06:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716878078; cv=none; b=LPdZ8Dp8G60IadueManoqkhq4Idv4H8daKj38RHq5zF5OmuU+l6LGuhGXtWZk8bAZirZ1OtH/XS3uAlWQriAjK56WAwWYRKyn091Tn7X6hGKYIJfN22UwSPUAqk7B4QI9Nv98fTsIpbyZRIg+9Y7MbgxADkaTkmoa8TCJrlWnEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716878078; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxpaJsWokxS60YsInPVmnnZos5BG7Fgs43W9kX7IBJRmf+xVXBtIVwxy9T6SPiFiZbYfD+K1fkWf/XFUZPvVrvABbaXFGimPdaTSsBcAe1vDBH7cSIf2Jeex/WFP+LDXU0bTVBPGJ9juMS0G/MSKmTUX/YbnSfefXRBMD2ueVTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 47A0068BFE; Tue, 28 May 2024 08:34:34 +0200 (CEST)
Date: Tue, 28 May 2024 08:34:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>,
	Anuj gupta <anuj1072538@gmail.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/2 v4] block: change rq_integrity_vec to respect the
 iterator
Message-ID: <20240528063433.GA30133@lst.de>
References: <719d2e-b0e6-663c-ec38-acf939e4a04b@redhat.com> <49d1afaa-f934-6ed2-a678-e0d428c63a65@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49d1afaa-f934-6ed2-a678-e0d428c63a65@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
