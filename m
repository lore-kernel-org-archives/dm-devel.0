Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2B7288DA;
	Fri, 16 May 2025 05:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747374739; cv=none; b=XqNpncfoeoIX2d3dIKLPCwoUE+23vUIlNcTrAM7PDQv1rOqA0dsEj2Y8Mc5dly6TDO4myOxU2gq+8x0+j3hqFkGPIU9ZYhMXpL6OZC9AEymdYxER6V0vrqBWmIOEvL+T18YYVgp2BpDCV2RY84KNr+M9vRnOipdGvNb5ihYJywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747374739; c=relaxed/simple;
	bh=aw08LBXzt6obXPy/8Vm80GRmMC7w0UnW/0OPYmGgpZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XB3d8h6mbDOqjzgelvLn5iN8jxjElSkbYAClfd5k20i+ZBIq2eLQ1vv45O5ht7EEuTEEb/PcAn3cyFSw4QZI3Kdpna65CVgOI7XDo62yXk9v5vcXF2USg6zoDrIRqR64qyTjVKgAnYttZfKW0THwOkifU0B99EgXelv+zbTPR/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IlF8fXdI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IlF8fXdI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=K8UXY7rT/l3eeHRyLbzo//dG7vL4enowgat/pk9HleM=; b=IlF8fXdI+7gIwHPmL36dnwQJYA
	znkqyKppR4lYlt38el9ZKosOASWE4iHCifZDLGO4IKaOSkyU1ITC+e26DPAeKhH1RMgkMZw3ARfCH
	DrmNFEE7qFu9Q0tkHCgoo736lnxo/sCz8uBEfBZN11TIGyZ8vmobr+0E3yknxwrs+V8gNwiTyPRSW
	tdciEteZ7NYUsGCD0oZV7Jlj1L3x9FmxkhtF7f1UkbuPzJSlb3XJaAs4cQJtVmHbrJnVr8+IH4YvS
	jA0a5kfs1Gb8TfuZgadMUSw4541KHSd85QJQehpyvP6fDV8c9lKLF8QjJGvhQCk9hDGANPx5dEu7W
	p0nW4LuA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uFnzT-00000002XCz-1Gf0;
	Fri, 16 May 2025 05:52:15 +0000
Date: Thu, 15 May 2025 22:52:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
	Kevin Wolf <kwolf@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
	snitzer@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCbSj9HLGJD1dK3u@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <aCLe5UT2kfzI96TQ@infradead.org>
 <0340c51e-6f89-4799-b2f1-19c785a19ff2@suse.de>
 <aCLjPLCztuXhgpnA@infradead.org>
 <d2a7fa68-1890-4367-a2ac-59ec220779bd@suse.de>
 <aCLrbz3bRLwUbA8p@infradead.org>
 <aCNzf7MJa-hLQpmv@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCNzf7MJa-hLQpmv@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 13, 2025 at 12:29:51PM -0400, Benjamin Marzinski wrote:
> On Mon, May 12, 2025 at 11:49:19PM -0700, Christoph Hellwig wrote:
> > On Tue, May 13, 2025 at 08:32:12AM +0200, Hannes Reinecke wrote:
> > > Reservations and stuff.
> > 
> > They should use the kernel persistent reservation API.
> 
> Currently QEMU isn't sending Persistent Reservation requests to
> multipath devices at all. It's sending those directly to the underlying
> scsi devices. The issue here is with all the other SCSI commands that
> users want to send to their SCSI passthrough device that is actually a
> multipath device on top of a number of SCSI paths. They expect to
> get back the actual sense and status information, so QEMU needs to
> send them via SG_IOs.

And that's the problem.  There is plenty of path (I_T_L) nexus
specific information in SCSI, and just trying to glob it back
together above means you'll get path specific information in something
that doesn't claim to be multi-pathing and will get random and
changing results depending on the underlying path selection.

> Without reading that sense and status information in kernel, the
> multipath target can't know if it needs to fail a path and retry the
> ioctl down a different path.

The blk_status_t has the information to fail over.  But the whole
idea of implementing SG_IO in dm-mpath or any other stacking layer
is just really, really dangerous.

