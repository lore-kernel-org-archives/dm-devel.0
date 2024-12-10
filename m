Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68AA18A94C
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 16:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733847603; cv=none; b=HXrLg20IyOLe+h02HLAaQXywfV9Js7m/d+DziqyKl+fSyjWt03VSwJDVGQkj0mvh6bxFAliVkOyrPiAGt0diR5Dc58ve6HYXsRMAE1EkTHx164gKxtwxf6Lovb/Q5V22Vp7niRZabb6jgjUDCjStGbnveDJNESFSPGAftO7rzZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733847603; c=relaxed/simple;
	bh=WvufVm2JTUQopNYwcjumL2S8v4R9r6o9UwatVDefcOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/AzPLGkEvdwi0JPrUfiOUgQehmKfuOwwPJR/GLDhEteqG31jatEaABgyCNsqy9FIJB8vl7vTfNh0Zkep6VD6881gujuZWSBkdVY2kFMsCPABYy3/3oFcsjAsu0oiBqA0n1b7oatbaic+PUAcPotvFjPtqqAQxKfsZx9Cdk4OnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VnbXI/Ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VnbXI/Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFECC4CEE6;
	Tue, 10 Dec 2024 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733847603;
	bh=WvufVm2JTUQopNYwcjumL2S8v4R9r6o9UwatVDefcOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VnbXI/RyKLchkzLz/Nk/zI1YIwtiG1ZwYwR+GvlC/ZVDAtWdZKGXuLyRFfOwCcaN2
	 GlCMXbp4tnqLHl/WLAIMIBclYvQ+qrG/6rtvaA6Bk612/uLLILtAdosy4h6IPQU4I1
	 rlyeaUIfuzh6lVuUXBzpJkjW6QLd+pRje1Cd0o0RdLJf8AqiqjuJ36cHBkvbeL43fl
	 NLI7Up38zr82f60JWk/oSlENoZZtpUx4rXWyFoYv5hDNkzERTeeCoEXqsITFRSVaxP
	 EwUMOV9Uns0F1KRNCigZg4Lxq9UE3WgtMr063W5pywtwhFqkQa4mcjj6gbz8s71esY
	 y0rsr+O0v/yog==
Date: Tue, 10 Dec 2024 11:20:01 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"ebiggers@google.com" <ebiggers@google.com>
Subject: Re: dm-crypt: set max_io_len as chunk_sectors of zoned device
Message-ID: <Z1hqMSI-got7s_Od@kernel.org>
References: <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
 <Z0QSqndKs1fyiOmJ@infradead.org>
 <b01f1929-f1bc-4ed6-ae57-dded68f23e26@kernel.org>
 <Z0QVCemvU5_5REWB@infradead.org>
 <ec6f2bb7-95d8-4c1b-9654-4c597e1f0da4@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec6f2bb7-95d8-4c1b-9654-4c597e1f0da4@oppo.com>

On Mon, Nov 25, 2024 at 03:49:01PM +0800, LongPing Wei wrote:
> On 2024/11/25 14:11, Christoph Hellwig wrote:
> > On Mon, Nov 25, 2024 at 03:07:24PM +0900, Damien Le Moal wrote:
> > > 100% agree. But in this case, dm-crypt sees a single BIO which gets split when
> > > submitted to the underlying device. But the split issues the requests in
> > > reverse order, which breaks write ordering.
> > 
> > I'd like to see verification of this.  People who send these kinds of
> > odd old kernel reports tend to have weird patches applied to their tree
> > as well.
> > 
> > Without an upstream reproducer that actually shows issues I think
> > this can be safely ignored.
> > 
> Thanks for your suggestions.
> I will try to make another patch of fault injection to reproduce it on qemu.
> 

If/when you do find it is relevant for latest upstream and/or
6.6-only: please add a "Fixes:" tag and also be explicit about which
kernel(s) your fix is applicable to.

Mike
