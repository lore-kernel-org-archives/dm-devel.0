Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551E22063EF
	for <dm-devel@lists.linux.dev>; Wed,  5 Mar 2025 13:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741181565; cv=none; b=Wumm4X9ejyEcxdil4EdbIVn4sL24i1m/KjyLE4+bGw16iVgEhFRdG8sRB2XFAgVV2goQUK3SyXVeykzQAyCCwNrZSnXFPkf4XdNYHCDVYkXgoahH31xOE/TiwZ+F7SR4LWLVVNkCU/1ngP6Gfj0caoS8XP2xOI+P4agLM86BHSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741181565; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IxENhG5V7+YrMw/B5UgooxiPykT9lQC1g858pvBR5E8Z80vrNR+mqGtA7bpPSywQgny+hbMj/nVzBAnPcmhu1E2jWOnzvf2A9oj+f3TaYoqzZekll2cBuS81g1hfSibiFQ7zZ3KYjQQmPbY5bbtwa+IW2JQtMol+3CdZE6tCQOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E7D2868C7B; Wed,  5 Mar 2025 14:32:36 +0100 (CET)
Date: Wed, 5 Mar 2025 14:32:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 2/2] block: Correctly initialize
 BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY
Message-ID: <20250305133236.GB16755@lst.de>
References: <20250305063033.1813-1-anuj20.g@samsung.com> <CGME20250305063903epcas5p46a5f908f6500fc34795b8330534d0c15@epcas5p4.samsung.com> <20250305063033.1813-3-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250305063033.1813-3-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

