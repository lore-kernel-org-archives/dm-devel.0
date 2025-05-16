Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C63145323;
	Fri, 16 May 2025 06:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747375221; cv=none; b=PbaCnrnC0VNt0zk/JoqUKC3PrPVtzhQoSn5i4N4Ce4/CB3+pf/h3ARC5UFHPWlUPP4TwbLK4jYjDsywQq3VuSQtDKbmSP5rBvhoXqBZ3q8euSXmk6bPiMvNN+Qy1+KeFb/Eg0PDUMISSn9ZY4Amo2EbtUKBzY9hTTBjbgyN4HNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747375221; c=relaxed/simple;
	bh=jRcCQqKoajgCHcqKZL2fKVR9zn8kYTEKLbF6ph3kb9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I6VSauzHnOeKJGTAYIz2vtWIYdqQCljtPEXbTDpPa++EQcCriuyhftuk9P6AeeBH0z0n/aBfqaI3aI3GcbtESVyPzWniEr/KXcGcfm4p4C2888BD5sGMVxP9NfeeKrG9xiEApVBzzLoMGZfawytOwarIHCHz5SuFscDWO9swaLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W6r+kAM3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W6r+kAM3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tMkAG2SFACdyzL8iUB+Wxh6SJJ+34J1Qx1KU18J0p3Y=; b=W6r+kAM3drfZk7z4FiEyTqXGFI
	OxPSN+0oTLerhucmtXvIp5AGqSP8Uvx0I9gq2toJ4ceOjhz7qpFE+MLAs9kDey6PorkOLeNK2yDRr
	tfAGBIBdkiWUF9VAztyncBX/uNpYOgk3gwEsIpOsQo89sQsJiVsVylWGs4IUr/olWnjweBPX8d6JT
	BzjVdH5QbCgiXTQDu/i/c4uu3668SH3OXLKyQGlNQneOIvT7NwMZj8h6kibCK8ZJa2c1TOMk2yMOX
	TAqQGT25siJz2NolUgJ0qJZ5kJnI+kzZGGCjh2e7U33i7m+M4wGHeGEL4O5nn7gaFA52T62/R7PZp
	7uK8hPdw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uFo7F-00000002Xly-0cgy;
	Fri, 16 May 2025 06:00:17 +0000
Date: Thu, 15 May 2025 23:00:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kevin Wolf <kwolf@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@infradead.org>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev,
	hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCbUcdew393RZIkV@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
 <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
 <aCW95f8RGpLJZwSA@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCW95f8RGpLJZwSA@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 15, 2025 at 12:11:49PM +0200, Kevin Wolf wrote:
> If you're talking about SG_IO in dm-mpath, then PRIN/PROUT commands are
> actually the one thing that we don't need. libmpathpersist sends the
> commands to the individual path devices, so dm-mpath will never see
> those. It's mostly about getting the full results on the SCSI level for
> normal I/O commands.
> 
> There has actually been a patch series on qemu-devel last year (that I
> haven't found the time to review properly yet) that would add explicit
> persistent reservation operations to QEMU's block layer that could then
> be used with the emulated scsi-hd device. On the backend, it only
> implemented it for iscsi, but I suppose we could implement it for
> file-posix, too (using the same libmpathpersist code as for
> passthrough). If that works, maybe at least some users can move away
> from SCSI passthrough.

Please call into the kernel PR code instead of hacking up more of
this, which will just run into problems again.

> The thing that we need to make sure, though, is that the emulated status
> we can expose to the guest is actually good enough. That Paolo said that
> the problem with reservation conflicts was mostly because -EBADE wasn't
> a thing yet gives me some hope that at least this wouldn't be a problem
> any more today.

And if you need more information we can add that to the kernel PR API.

