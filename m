Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3391E865;
	Tue, 12 Mar 2024 22:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710282636; cv=none; b=OKVU2GVRI8FfQ64wXalRzXdM2vvLItK/xnTM6eKs3iNwNLxLzPmo/R3aMkgmg6m4fEtVJ92Kc516VYqlaY9f9KFrs0BmM5026dMx9kUgr/RXVNnZfg6rmdcqTB0Kg542OhotuZwTSp7JGIFwSIzU8Ss/fNQYQcWKykiKS/Ijoxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710282636; c=relaxed/simple;
	bh=Q4tyCFUdRMFy/X4/dbjE7LKOIJOM3K5KGJRp8+K4Jks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZoCQnOjzAw6hUu8/E4rs/uL9TzJWSb8eAypjTbEgSpYl72Wfpe93p846AMfDm/nNuw4/DpYzmvvxXuacKPhla3vy/wHqPcT8BM1qZv9EmdXN9F3nZdMoP48j0+M3jRZ+G7BuxHRbK+/03OhI5LTZ52n5KBErPKfsA9T3HE9BU70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VYx9FtyN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VYx9FtyN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=vUPdcFP0avBFD0D2L9KZnUUP8B4bZ3OA1degYExs78g=; b=VYx9FtyNGU0EntIZoMxKthvM/f
	icFD2IBK/Wte2zcPsuHmrMtsgCb59mHSoW7aJPaJl7/hZiXzewCRZXgSkK34obujy0w+Zzmt1v5EO
	CdtWMPLTmkdJl8m5X1qxz/odqUHGakhZMi595VfItyvA1l9RZY9RqjWtAWTf3aJad/t3XL22cRq90
	SOeJ709hIQmRWY1oZbIzSKQ04pNv4SfLdlJ1kxzU57NGw/UWZEiz68I68RpDPPjVBGOLAd94be4No
	6j7p+JBb3jqzQxGLUtC1sHv83+COKOJsqwIWp6hzEudGFSQDkfg1D95bGDIVYJ/JY1erRntte3o/p
	xtkwLFdA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkAdk-00000007qTc-2vub;
	Tue, 12 Mar 2024 22:30:32 +0000
Date: Tue, 12 Mar 2024 15:30:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: [GIT PULL] Block updates for 6.9-rc1
Message-ID: <ZfDXiK2knK7Tx8Iw@infradead.org>
References: <eaeec3b6-75c2-4b65-8c50-2d37450ccdd9@kernel.dk>
 <20240311235023.GA1205@cmpxchg.org>
 <CAHk-=wgOfw8NBQ2Qyh8QUjhp5z4v--PuciLE7drn5LJkTtgPVw@mail.gmail.com>
 <e3fea6c3-7704-46cd-b078-0c6e8d966474@kernel.dk>
 <CAHk-=wgXZ6dE1yHK_jQmnSjbEbndyzZHC5dJNsmQYTD2K-m61w@mail.gmail.com>
 <Ze-hwnd3ocfJc9xU@redhat.com>
 <Ze-rRvKpux44ueao@infradead.org>
 <ZfBzTWM7NBbGymsY@redhat.com>
 <ZfDEtchBNeFLG-GV@infradead.org>
 <ZfDVnVuDYwzDVnDx@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfDVnVuDYwzDVnDx@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 12, 2024 at 06:22:21PM -0400, Mike Snitzer wrote:
> > The real problem is that we combine the limits while we shouldn't.
> > Every since we've supported immutable biovecs and do the splitting
> > down in blk-mq there is no point to even inherit such limits in the
> > upper drivers.
> 
> immutable biovecs, late splitting and blk-mq aren't a factor.
> 
> dm-crypt has to contend with the crypto subsystem and HW crypto
> engines that have their own constraints.

Yes, they are.  The limit for underlying device does not matter for
an upper devіce as it will split later.  And that's not just my
opinion, you also clearly stated that in the commit adding the
limits (586b286b110e94e).  We should have stopped inheriting all
these limits only relevant for splitting when we switched to
immutable bvecs.  I don't know why we didn't, but a big part of
that might be that we never made clear which limits these are.
