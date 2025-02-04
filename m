Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AFD25A626
	for <dm-devel@lists.linux.dev>; Tue,  4 Feb 2025 05:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738647929; cv=none; b=fVuEeKLK9OsR2fNGGKLhMhv90+7ZUAH2RNE3Mu7/Uwlv1ewSQH/GSYp3OOhU6TaT8Wn6Vhj1Rg502q2zmwOrByHjpInov+Vwt+Vkd3CGDju6OhtoFHYDUG7ggEHRDsikDSsgoQrk4f2pS2uffljBFJ/iWb9FIlYjjbnUKkfWrOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738647929; c=relaxed/simple;
	bh=aIsXSz3h+h6XF2CZYPxHMXyo2Vy1uQYDeOZtSFW9IAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ExgnAnfVBCF90uEBr3YadRWeeNKXcyCyDA4fQ125qvhoxCMI9UIx+IiiUly8ctAtYGbXCxN1LiLPLEis+T0XWZJ+qRjtnNxM+JQA9hzmfwOQguz9ZPvofIqgA4ZP2mYAc7G8RfsVvhsQdJ9nTBnZrHZYWlQTGLJc0xF2y5Uj69M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1344868AFE; Tue,  4 Feb 2025 06:45:22 +0100 (CET)
Date: Tue, 4 Feb 2025 06:45:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] block: move the block layer auto-integrity code
 into a new file
Message-ID: <20250204054521.GA28971@lst.de>
References: <20250131122436.1317268-1-hch@lst.de> <20250131122436.1317268-3-hch@lst.de> <yq1v7tqj00w.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1v7tqj00w.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 03, 2025 at 02:41:25PM -0500, Martin K. Petersen wrote:
> I'm not sure I'm so keen on integrity-default.c, though. But naming is
> hard. bio-integrity-auto.c, maybe?

Fine with me.

