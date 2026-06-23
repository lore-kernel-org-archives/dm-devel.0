Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B203D5227
	for <dm-devel@lists.linux.dev>; Tue, 23 Jun 2026 14:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782226476; cv=none; b=lSFBFBxSOf3uOutaTC2zpkkLYIGCMAlGRZh587ohsgyQo0ziuiaFc6BmFfYaEBDXiWi2e5+36R+q/apPA5wgaZ5HpdRKsY2CdSMp/FWQknYjORj15Oe+55bnVC0nYIm2WkmzacCCzLaxyVhiWKjdr390BCaTgh7dp1AvWZBuAYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782226476; c=relaxed/simple;
	bh=PORveSu5f93Vap/x9nXVeBrgwFv8rT2Y3qsG/t0pe5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=enhbaAPEZGCKF41ctNsjXAsITkEL1+1z8fR4av3raj+MVXmxlrJdKIMVKpSR5deZsncg6lXXzfcq1EEpaXB6HjQF+P+7O0MFJKNjfdUTIWw3l8maBScI0btwEO1JE9pqKCRjevexMXeC2nCIiT7aYJP5+rG5n4ZFPxvdMkxBYZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7501A68C4E; Tue, 23 Jun 2026 16:54:31 +0200 (CEST)
Date: Tue, 23 Jun 2026 16:54:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
	brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 1/6] block: introduce bio_endio_errno helper
Message-ID: <20260623145431.GA13628@lst.de>
References: <20260622174241.2299563-1-kbusch@meta.com> <20260622174241.2299563-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622174241.2299563-2-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 10:42:36AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> No functional change; purely introducing a convenience function.

I've been deeply into untangling the 1:1 BLK_STS_ mapping to errnos,
as propagating them up that way often causes more issues then it
solves.  So we can avoid it, I'd rather not add more helpers to
facility that (even if the helpers are just the messenger and not
the cause of the problem).

