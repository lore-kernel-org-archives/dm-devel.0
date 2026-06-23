Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0E73D75C7
	for <dm-devel@lists.linux.dev>; Tue, 23 Jun 2026 15:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782227250; cv=none; b=MoDw4y+vQK+JPyQCCxtM/4Px+DRgMwaNT6GRVrgy2PlpG3kUKq8hHUsqJXSaRl/Jy3ORpjAsCIh5RaWNBvJN5JHyNH44HON+GWdDq4tXP6eSaEFNIlG72yeKY6xvi5Om4DcEEz69cEN0sykMnTv4d42+kHjcdhWEJMEtpyBRFYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782227250; c=relaxed/simple;
	bh=Z8aTFnn5AtXfx7dG9hbyKQG0Zr0pnzNOkM4vZx19l60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LXvNHLFEcYzrrnjlkuEJ7yuP2qqvV1D4DQbaYmmfqyA9ql1R0OMYpqhg/uh8wxN7hUbNAL9olprSOXod6abeJKRHQkGNmp80vHdL9+RU4IFS//3iY6d7K3JSHZEFwQB/ost+P8YPJUG7ywddnPl8EltvqR4sk98Gr5b/KVrbx1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7F43368C4E; Tue, 23 Jun 2026 17:07:26 +0200 (CEST)
Date: Tue, 23 Jun 2026 17:07:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, axboe@kernel.dk, brauner@kernel.org,
	djwong@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCHv2 1/6] block: introduce bio_endio_errno helper
Message-ID: <20260623150726.GA14863@lst.de>
References: <20260622174241.2299563-1-kbusch@meta.com> <20260622174241.2299563-2-kbusch@meta.com> <20260623145431.GA13628@lst.de> <ajqgzcEQm6BthFvx@kbusch-mbp>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajqgzcEQm6BthFvx@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 23, 2026 at 09:05:49AM -0600, Keith Busch wrote:
> On Tue, Jun 23, 2026 at 04:54:31PM +0200, Christoph Hellwig wrote:
> > On Mon, Jun 22, 2026 at 10:42:36AM -0700, Keith Busch wrote:
> > > From: Keith Busch <kbusch@kernel.org>
> > > 
> > > No functional change; purely introducing a convenience function.
> > 
> > I've been deeply into untangling the 1:1 BLK_STS_ mapping to errnos,
> > as propagating them up that way often causes more issues then it
> > solves.  So we can avoid it, I'd rather not add more helpers to
> > facility that (even if the helpers are just the messenger and not
> > the cause of the problem).
> 
> Sure, that's fine. I'm not sure what you have in mind for untangling the
> errno:blk_status_t mappings, but I can certainly have the new users this
> series introduces open code it like the existing users if that's
> alright.

I've tried a few things and banged my ahead against the wall, so I'm
not entirely sure yet either..
