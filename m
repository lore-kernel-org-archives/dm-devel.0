Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C126346420;
	Tue, 12 Mar 2024 22:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710284341; cv=none; b=ZbRJDrxtbg8YbpR56GFw2FOq+yAvk2jC/ALuTYUvU5yZjptdSubG4C4ahWtab3LAdwSeb/r0KABf+HIXldi3yAgJ/EjrTE/c5kmbN1/gy2yVOVNevWMeIB8pHj5iNQfkuTmpXRu4+tkQTj1dJZu/M/RRjVRxb7/emiZGfPumloY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710284341; c=relaxed/simple;
	bh=AHsTrgOnfb/OJD5az4jJnRgeFnrppGoJ2+s0WQ1qFQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m39iDQFpsOnXEzbNqj3idIc9X+10q5dgvZNtcZLxIyes+Lu65JLIYGP3EhZxw14dBaguTB22R5Ex2c1WBiYVCGOlnaXXAFx+ji2Kpw00o1ehVyl/vTQ2QrzcX6KlQufasGIMEpcqvy7BEgs1s7DkWPjGUCmOwyGLWHqyu5fLG20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mwHCKxzB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mwHCKxzB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DUsqmA5ZCKRVPJsJrjXCTNjQzlb/ejNZz8cnXjD3iDM=; b=mwHCKxzBGf1eb9OSqfnqe8Qi1l
	K66SHCwQexFkUEsrLT21PoeFVSErKvEkI0faU9GBjOb6+57IaZPyoLgoZkD7TC3wHtuLvvkd76rhh
	1358Ml+ZjH5IH4I5w4+5P6r8w8MFxDDM1E/m+Gi0Rtvutppiqu8mJFjrO38kOT/8hRhZzyl9Hyt21
	sNxpz/8WOcJzciElLYoBLnMz3sQg1Q/TCQFtgVHxfdzNi/OREDSa2uPTGVRREiywx3Y49W/97ZTmb
	CNZ7Uf399g9ybZgO2majtqARspcCVmmwkFjUIBsNRkFr6PWIXf0hyWNusmqsTHBnvEBS7uWY9Xb2k
	pxpPpNjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkB5G-00000007ug2-1P1S;
	Tue, 12 Mar 2024 22:58:58 +0000
Date: Tue, 12 Mar 2024 15:58:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: [GIT PULL] Block updates for 6.9-rc1
Message-ID: <ZfDeMn6V8WzRUws3@infradead.org>
References: <CAHk-=wgOfw8NBQ2Qyh8QUjhp5z4v--PuciLE7drn5LJkTtgPVw@mail.gmail.com>
 <e3fea6c3-7704-46cd-b078-0c6e8d966474@kernel.dk>
 <CAHk-=wgXZ6dE1yHK_jQmnSjbEbndyzZHC5dJNsmQYTD2K-m61w@mail.gmail.com>
 <Ze-hwnd3ocfJc9xU@redhat.com>
 <Ze-rRvKpux44ueao@infradead.org>
 <ZfBzTWM7NBbGymsY@redhat.com>
 <ZfDEtchBNeFLG-GV@infradead.org>
 <ZfDVnVuDYwzDVnDx@redhat.com>
 <ZfDXiK2knK7Tx8Iw@infradead.org>
 <ZfDcS4q5l2sn2h5Q@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfDcS4q5l2sn2h5Q@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 12, 2024 at 06:50:51PM -0400, Mike Snitzer wrote:
> Wow, using my 8+ year old commit message against me ;)

Or for you :)

> I've honestly paged most of this out but I'll revisit, likely with
> Mikulas, to pin this down better and then see what possible.

FYI, I don't think this is really a dm issue, but one of block
infrastructure.  But looping in the dm and md maintainers as well
as Martin who wrote the stacking code originally is definitively
a good idea.
