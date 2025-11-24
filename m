Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA4822127A
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 06:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965679; cv=none; b=rFEfDnHCs6oylATotNGi0IIHsqY+fPqgQ4OEni90LcUYVQPRKg2WASq4n6PVgaBXLTWXBICZ/otezy4duJUPS0HTZLvb5kS1TTbcx8ff052+r3VEKxkZf75Q5/R9/z2Xue2yAi+n+l8qGllo3UC2F2C5+pEwSqWpKCCdhCIYUEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965679; c=relaxed/simple;
	bh=BsuXYppzHhMWNMF03oT3P8lKKTAnmJIXsUzVEvjOdiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNkL4phYL2AWiu6yHKZQmlVjjClYyuDlXaw1IpU5QEANoWyMAIGkuWUZqPnlWd7qFtuoEwEHibbKiHB9IY3ZPnRFOxjew2XWdq8llaXs6axpJ0uVNCiYEsg3BWCEshLxj6iAAqQ8tEG6fiYMyooZjxqIdkmnXdi15/Va1QwifJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7A37968B05; Mon, 24 Nov 2025 07:27:54 +0100 (CET)
Date: Mon, 24 Nov 2025 07:27:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@fnnas.com>
Cc: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
	jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH V2 2/5] dm: ignore discard return value
Message-ID: <20251124062754.GB16702@lst.de>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com> <20251124025737.203571-3-ckulkarnilinux@gmail.com> <d86b820a-46c9-43b6-9fe2-dbd991b76520@fnnas.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d86b820a-46c9-43b6-9fe2-dbd991b76520@fnnas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 24, 2025 at 02:24:05PM +0800, Yu Kuai wrote:
> mdraid and dm are different drivers, please split them.

Yes.  Both parts looks fine to me, though.  So:

Reviewed-by: Christoph Hellwig <hch@lst.de>

for the next round.

