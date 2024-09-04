Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A57823AC
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 05:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725427166; cv=none; b=G4QgbBf6X09FqZGhhufQD29sNMr/mOvFn3HkF+PBF4EjYq1xOLbzd69beT3t7xqmpeuj8Vr5i3JlkatWhe1RqTlwDZROmILfeBHjaNz5N5OBajaEcx3k7RdbOJyrjZXrOnKfkNeFezxTc/9zKUI8nh10zI24AjoDzsAMfypS3kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725427166; c=relaxed/simple;
	bh=k0w+8MjX9gmCSRlueN4R9IhVAtdMye+chfLj3TRmxVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jrRuE9h9GZCzTeNNC9N5diIFaL1A/esmH7zqkNVOeDZ/u0j5CeCzGm3gAk3nUN9ntqd2bJUlenAFrUf6vM7+tTw9qjc9hg4KoQjdPc5Wu3O3PJq1V2Z56+dzAXVOY/mh6+HMK8u4rg3R8R4993R4f0l4fgcGEEDBnUfe+COn9OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CDF1668AA6; Wed,  4 Sep 2024 07:19:14 +0200 (CEST)
Date: Wed, 4 Sep 2024 07:19:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jinyoung Choi <j-young.choi@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] bio-integrity: don't restrict the size of integrity
 metadata
Message-ID: <20240904051914.GA13967@lst.de>
References: <e41b3b8e-16c2-70cb-97cb-881234bb200d@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e41b3b8e-16c2-70cb-97cb-881234bb200d@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 03, 2024 at 09:47:59PM +0200, Mikulas Patocka wrote:
> Hi Jens
> 
> I added dm-integrity inline mode in the 6.11 merge window. I've found out
> that it doesn't work with large bios - the reason is that the function
> bio_integrity_add_page refuses to add more metadata than
> queue_max_hw_sectors(q). This restriction is no longer needed, because
> big bios are split automatically. I'd like to ask you if you could send
> this commit to Linus before 6.11 comes out, so that the bug is fixed
> before the final release.

This looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although between the patches from Keith and the prep patch for the
io_uring metadata series I'm not sure that splitting of bios with
integrity actually fully works.  Although until we get the io_uring
passthrough code in we also won't have an easy way to exercise it either.

