Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769B11EB36;
	Wed, 14 May 2025 04:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747198673; cv=none; b=OOKhqkoOd8/hVsUByPaT+5JmzGjhh13wxAVf8JEGBXq2k5dFGPNkavPvgyA7MB1fJg1uRGB8ZQEn26P4++e60vFE2RC7CK6XsuRq2M3jCgj8fb89rVPPjQz2BNtYi0BPIWMgQOiWSfAPxA5EL4oKrIY0mU82U+w5+ApmbBWrd58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747198673; c=relaxed/simple;
	bh=dwk99c4ze/v5i5wZOUZMiW/juvBRI1Dowh87fegHPPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eyl5QRDdAPe7byoKc3IktzIvd2fMpjhCqJYo/Zt1JaI7jgpCqEo6QL9CWouDJEi/t3R5skBrIsh4vdxTIiw2Sx7HR82g0vbdvz/vy8jqlBae77JrFxSwgSP+Zcj6EfaaI+UOGKeL+XRwcfTYN0G6X+Hx/Ahj2Xmio+KV89VRo0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mlWc47Ks; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mlWc47Ks"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lOR/QFdLKjSv2hRskxp+GEMjKu5nrg0KkEjjkdDExL8=; b=mlWc47KsXRwAHvCgjdqBUmQKvS
	sM5pSRiAmJC3KJxrKUz57vLhhO0efr9bLIay48sdM2W2yPxeUyi/x9rb3RxWm8EQCcpazv+HfIh+h
	idYadG6vDCPr9oUbdjmJSvRw1Xj5pnEtpHc3tWOyTTBIiPR31j16wSe/loBYLYqyCu1HfoDL3V5c/
	PyCNW3S10YotXJziTsp/1PqsbiM/Xsxr4tEOD/9wcfeWdi4apflyJ3RPztCCgiQdLCK3uowEG+kAm
	QHRtJ6QCklSO28jcyN55LDkV85RYsnWTSVVApTthNnx9kXxxBzPZkrMPPBR3QH7rlgO8VKa9F7spp
	gslrNHfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uF4Bj-0000000E2Ar-3yQb;
	Wed, 14 May 2025 04:57:51 +0000
Date: Tue, 13 May 2025 21:57:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kevin Wolf <kwolf@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
	snitzer@kernel.org, bmarzins@redhat.com,
	linux-kernel@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCQiz88HksKg791Z@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <aCLe5UT2kfzI96TQ@infradead.org>
 <aCMQ5S-gI6vZJxmq@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCMQ5S-gI6vZJxmq@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 13, 2025 at 11:29:09AM +0200, Kevin Wolf wrote:
> Am 13.05.2025 um 07:55 hat Christoph Hellwig geschrieben:
> > On Mon, May 12, 2025 at 05:18:43PM +0200, Kevin Wolf wrote:
> > > Yes, it's a bit unfortunate, but we have to work with what we have. QEMU
> > > doesn't even necessarily know that it's dealing with a multipath device,
> > > so it just has to blindly try the ioctl and see if it works.
> > 
> > Why is qemu even using SG_IO to start with?
> 
> How else would you do SCSI passthrough?
> 
> Ok, from your replies to Hannes I understand an implicit message, you
> wouldn't. But I don't think that's really an answer, at least not for
> all users.

SG_IO is fine and the only way for SCSI passthrough.  But doing
SCSI passthrough through md-multipath just doesn't work.  SCSI isn't
built for layering, and ALUA and it's vendor-specific variants and
alternatives certainly isn't.  If you try that you're playing with
fire and is not chance of ever moving properly.

