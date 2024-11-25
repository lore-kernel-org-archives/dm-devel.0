Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C242500C1
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 06:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732514476; cv=none; b=CAK1EFoKLpeb/AgnIJQ0U3b/1mfuLzth1q4ErLP+ca5tr6IQtzBtudnU/i9RN+OlCR0BkNp1PadfXJNUxIvuOzos5MYdHmic1yM+ePAdlGaHRTLKsl87knvJK3Li1bPkn8zf6/K92pwBZDXq73Z0mZuibQYr1wIC6XsyuLdj9t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732514476; c=relaxed/simple;
	bh=Gdvmdcc1i/yG/AQtUB+0F8RW0Kpdh4lxq2T+qbY0J+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIOq2RxY8yN1QcQcY+yoWZ3Ty4t/krGVEqQsLU5G29lHAh8XTt+hBTZQeiFtSRd/fjE4iahKe+5REyjS1OR4lPsAcq6JJubLsrLGv4f/RwEyoK2n06farZpbAZOHQfEWZY2JFDiVGok+CYKaKD6iQcHQFscvAVwUWJUAos1pMxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vwTh/e70; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vwTh/e70"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Fk2j1Q6hNXp7T9MHz0I5E62MJ8MEwyzB//01/sNoK1o=; b=vwTh/e70Y9eSiK6/POMN8L5DNY
	/e3lLRI1pJP8GxOkcicO+0ePH0Hl2Eo+dh3o4mGSMuYHycbAR0TBHkFS7c1t1VEyjcvae7ousGJBd
	Tn/QyPid0ZUaAIuJ9aJR2DLQHdYZPyE0tNOWvuAm/9JUOBtbXqNv4VFnC8XpokBizMe1UMU5OQavE
	87ivoKCO5t5fBPWqYsj1YQW2THS2I1WtWsjs7q30T2DfEe7xViR7sDTfiEazJGIMgZmqu3DU17LSf
	vr4/C0T6rbAtQcqsVe54nEAySgGC8ynds52ADm5m1ocAfVoVEnE4v0iCjj1SwhdcivhtWazwv5fGo
	nu9VWaaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFS9q-000000078Yn-1P9n;
	Mon, 25 Nov 2024 06:01:14 +0000
Date: Sun, 24 Nov 2024 22:01:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: =?utf-8?B?6Z+m6b6Z5bmzKEdyb290KQ==?= <weilongping@oppo.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dlemoal@kernel.org" <dlemoal@kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"ebiggers@google.com" <ebiggers@google.com>
Subject: Re: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned device
Message-ID: <Z0QSqndKs1fyiOmJ@infradead.org>
References: <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 05:58:22AM +0000, 韦龙平(Groot) wrote:
> > What is ZWL?  And why mention 6.6?  And why do you care about ordering?
> ZWL is Zone-Write-Locking and it was replaced by Zone-Write-Plugging on 6.12.

That's not a generally accepted acronym.  But more importantly it's all
gone now, so completely irrelevant.

> 
> > There is no real ordering requirement in the block layer.
> According to the design constraints of zoned device, write requests in the same
> zone must be dispatched in order of address and there can be no holes in the middle

Yes.  But none of that matters at the device mapper layer.  Either the
submitter needs to ensure ordering, or you must use zone append.
