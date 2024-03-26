Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A965954BFF
	for <dm-devel@lists.linux.dev>; Tue, 26 Mar 2024 06:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711435529; cv=none; b=B9uhFaUypcx9kG2cxh9wYMtW8tsfTXg6y/uis3CRgRhZhpivTYHpEq87kyNFbnT+nbrNcAUST1D8bZG18yfyXD5jdvpzoDgIbGzRlabNjpoxDBzFQYEhDsvTzvXKh4DcSBuN9Xcd9/pGLBi4a89t5OK1tnmDJ4n8b3buKTlViTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711435529; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WiObybxtdGRXpoc0UPv+dHahKz4uo4Kvv7jobaZ+EOTd6wnJ1CcAtXi5c2FP5e/vJkybq0Rm++dTEnNmRHN34d/OQcEuaDt+N9aLtUpONhsb6ANUk3Ov8/FnzoFKPhiK/II5eiJj7BmxlKNlbfRYpDRq5ALnEJpy8945OPOfgiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CB54E68D37; Tue, 26 Mar 2024 07:45:24 +0100 (CET)
Date: Tue, 26 Mar 2024 07:45:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 20/28] block: Remove BLK_STS_ZONE_RESOURCE
Message-ID: <20240326064524.GB7986@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org> <20240325044452.3125418-21-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325044452.3125418-21-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
