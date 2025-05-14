Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816451EB36;
	Wed, 14 May 2025 04:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747198577; cv=none; b=AT0m3sxd39fACpDjrSixtpLw+4s9/IaN1nM6NTHit8gKvUpp0Lg2cB7SCeTcQ/mvVtp335LdT0GK4lWXEed4VPCelr4nCJgFmDVQWPc8fci0CucceB1+vVpRU39jLTzeto5sNg/KIasGwEmthqtHJpx3XQNjt8SN/N7UhCSDyic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747198577; c=relaxed/simple;
	bh=qpuQoQ3WdonhF4Z9FZyaNqH6Gw0yQC7RkRBThKebTkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPO24sGoSdn6RqXezQHj5/Qe3M4F3Pu6L0qgwZTkGEs93jK1cZ9lm/ZoQAud6gmKbTrEO8e+cseSB3043gYzWU4ZJBLieFPOiaKYNzDdGZy9WrpfCwO3pJ31X3LDZ7GsDs9xpWhIKbu39YqTLylL7vOKSnJVWvlaKmyGm31Z7uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4Xf0FWjk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4Xf0FWjk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o8R6IIGe6dhLB8MYoBo+/X39C91BPWRY/jdRNVLyMW8=; b=4Xf0FWjkitD2mfSuWsFm0YC/DT
	GFovwiUdxEeRSPXZhnw93K5Pwn10BQhULbNLAyXFkDT4wnOFWVY1QTxGWorLl+scFthZoh4WNO4KH
	20SfgUlP5jtW/ZUz99E70D2VIvxjgE7F0zGX0USfvb3Esmu87bp/drlvIaQP89HxrXkYqCn3Cl6TL
	NTie5euKu8NTpG/JA6yKbb/pGPnDSX7YHefoWzkvpfAC5UD6hbN8fcDVhEEBrcmfSPnZDA9o8IpgP
	fM4sOencslpTav/NQIOJRWku1hgiBALqWdJ72p1TuW4ZYsIPf6+AYYEya7pCozxLCm3pmE1brgINA
	A49mM0pA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uF4AA-0000000E25P-0bGB;
	Wed, 14 May 2025 04:56:14 +0000
Date: Tue, 13 May 2025 21:56:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
	Kevin Wolf <kwolf@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
	snitzer@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCQibkfVcvRDCzsG@infradead.org>
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
> Without reading that sense and status information in kernel, the
> multipath target can't know if it needs to fail a path and retry the
> ioctl down a different path. QEMU can read this information, but it
> doesn't know what path the multipath device send the ioctl down. This
> patch just gives users a way to check the paths in the active pathgroup
> (which all should be able to handle IO) and fail those that can't.
> While QEMU is the driver of this, it's completely general functionality.

As just replied to Martin the problem is that this setup fundamentally
can't work.  Either you pass a SCSI devices through, which should
(mostly, there are a few warts) work.  Or you want host side
multipathing, in which case you must pass through the block device
abstraction and not a SCSI one, or at least do a full emulation of
the SCSI interfaces instead of pretending to pass it through.

The root of all evil here is that dm-multipath tries to pass through
SG_IO, which is dangerous for all but the most trivial commands.

