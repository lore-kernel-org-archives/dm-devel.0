Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A853BBE3;
	Tue, 30 Apr 2024 08:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714464983; cv=none; b=WYHjdL+HbUBTxBSxESizqZEXPolFwBBGtllZeQOxATokoU1nfM52ZYMpb+2N467GggHuuAbRObxleVXYIblSZhjMJ235MSkULh13izTDOLRTP/H4J3ZfjuPtnK/Uk1sO9ILpWgkhl6N1Uxb/Kek6asP0CRUwFZvdBvPJYy+eYec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714464983; c=relaxed/simple;
	bh=N3+9SsDfJ97HXEmOTnUUvanWDw1MLedwYXFVC/l0vrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UMzMapPoeMI2RygIlQ1bfcdMvDIG/mK6l4xLjw/OlV5Zcl8eNKLR96/PEK/Zhq1mV68GsgNQpjkNCs9m2Mhxi/652graVcSWS++4lmhB1UyuK50oJiK+lA2t8ubCTFXPHwQS2wE/Y9reZkm469/f7k3sP4SzG3ymJXI+vna69Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Afji1/Qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Afji1/Qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EF0C2BBFC;
	Tue, 30 Apr 2024 08:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714464982;
	bh=N3+9SsDfJ97HXEmOTnUUvanWDw1MLedwYXFVC/l0vrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Afji1/QeWkzhkveOO4iXvrJU9JzTQlRm2/eD2IqaYYky7r+BJsD2drIfzIVAQbfm9
	 7gFZw2TyJiKJ+mQhb4/hHkwSahsM9ZR6EGa53WxeGnvJxG6za5X9Nog6KUKuqB6NMs
	 eZskyodeKsyw+nRQEtqEzJ9ps5qw3VrcTnlPMp0pVaHc8laEXrWJkdDBh4F+E+QbDn
	 99srpg1SPq0BYE9eZo2hn1+IVAHNqBtMXs8egAZgLePsJwt3nU7fxzxjNpg5IMSXMF
	 X2X5zvr4iNWb6KBwfTcHjb7COEHf5qazKG8buB8BR7ppBuvVNva3VdoxiLPZOKY5tx
	 vt6TL+z/3Yfaw==
Date: Tue, 30 Apr 2024 09:16:18 +0100
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH] block: change rq_integrity_vec to respect the iterator
Message-ID: <ZjCo0rRZOlM_Ielu@kbusch-mbp.dhcp.thefacebook.com>
References: <19d1b52a-f43e-5b41-ff1d-5257c7b3492@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19d1b52a-f43e-5b41-ff1d-5257c7b3492@redhat.com>

On Mon, Apr 29, 2024 at 08:37:26PM +0200, Mikulas Patocka wrote:
> I am changing dm-crypt, so that it can store the autenticated encryption 
> tag directly into the NVMe metadata (without using dm-integrity). This 
> will improve performance significantly, because we can avoid journaling 
> done by dm-integrity. I've got it working, but I've found this bug, so I'm 
> sending a patch for it.

Patch looks fine, but Kanchan sent nearly the same one last week:

  https://lore.kernel.org/linux-block/20240425183943.6319-6-joshi.k@samsung.com/
