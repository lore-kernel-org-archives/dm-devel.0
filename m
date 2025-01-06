Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE5A156237
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 15:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177807; cv=none; b=SIqXTF+B/1JDv/trMwR7agN8KL/Jx452aMW4odx5Agp1zgtHrGkKTVZ10glQyp8BHDn2GOt3ghy64YVOUWb5Bb6ZRXIM+8h2/utHn/ZN1nxj1mtKjRQHbp7Lr1m6xag89iIw2qZs+9Uf3BC9K7iOiEPQEBMol3tWMnQTz5/PUI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177807; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKVfEQXRdNwCNbAHmdVuh/hbXQKWcjl6dWYrGbdEG4MlK31gvm/xtERE70tyQnaUYqIExP1ImbFbuEDA8jMqRebaHkcW+PZtT6vvA6ONt44jACJ9J/LCFzAh9QqLMtknPvqnzexl9jFh/tNKTRK+7yWokcZPyWTGUk5geQga+4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3073D68C7B; Mon,  6 Jan 2025 16:36:41 +0100 (CET)
Date: Mon, 6 Jan 2025 16:36:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, hch@lst.de,
	mpatocka@redhat.com, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] block: Ensure start sector is aligned for stacking
 atomic writes
Message-ID: <20250106153640.GA27864@lst.de>
References: <20250106124119.1318428-1-john.g.garry@oracle.com> <20250106124119.1318428-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106124119.1318428-2-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

