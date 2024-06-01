Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C791F9D4;
	Sat,  1 Jun 2024 05:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717219755; cv=none; b=QnAjHwX3OhVHD+X00QPeXKmTmUzjaXXDgSm0QbuGdg0OXwJejCdhbA1v40ay7gAgWyEGzmqpWuemd72fbx411ARW2AhFb1tbKGGG14UNJphlwZv9QlysgghCPGkVo7S+KPTmj0i4JVEylhnfTEz0qMMQ3G8r+bN071nTkeRKrR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717219755; c=relaxed/simple;
	bh=9W0JvoGJS+jul1hEaKm6+ECO/tGP4GPMAQeD+kSGxdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TzcOhSggL3sxy8BM8A71q9kwc0UI0rT/pyJm5zhzEMye47Z5VP48AjZvnRn6eCUhPiztpslgoTRc49XZcM/bv58nq3sCb8d9U6J84boDL4/VFMdSY1GainyvzjGQwCwjDXCaCOzR4UCt1yfmcVHUEhylB9Bi+hau4dnZn6Z2H+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QdrIZkX7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QdrIZkX7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9W0JvoGJS+jul1hEaKm6+ECO/tGP4GPMAQeD+kSGxdg=; b=QdrIZkX7nHvjubXa4iotTVjQY9
	6wuLsKvR9NMmzJlf7XJgxgKfb6wzhHdw/6/rZUPWMGKp7qg9XTlebMwNo+A1tOBcfmgDdCazzueMU
	j0xsyWfxJjFIuMHwvkU4gOB674yHFX7LNDLWd2azKk9AVOI4/fJCU1W0V8/hEYudAJgfz1o+duheS
	/FI0SHqL/2BukVsLBO2qtapqJd0e9RDn4K5e1h6eGgYSGKCnhptwqrnNK8LETB2NxkBH7iQIEz/fh
	LpTD6lzBjk4tJGUwzU6BE9MhaRRZmCv0vNuqhE8bd6t1274V7WdBolDGaaelBGkB/6j76cbjFvMRi
	clcw61YQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDHIn-0000000C0aC-2v6r;
	Sat, 01 Jun 2024 05:29:13 +0000
Date: Fri, 31 May 2024 22:29:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/4] dm: Improve zone resource limits handling
Message-ID: <ZlqxqZqixQ_POHvc@infradead.org>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-5-dlemoal@kernel.org>
 <ZlokTjm-l-7NWyhV@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlokTjm-l-7NWyhV@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 31, 2024 at 03:26:06PM -0400, Benjamin Marzinski wrote:
> Does this mean that if a dm device was made up of two linear targets,
> one of which mapped an entire zoned device, and one of which mapped a
> single zone of another zoned device, the max active zone limit of the
> entire dm device would be 1? That seems wrong.

In this particular case it is a bit supoptimal as the limit could be
2, but as soon as you add more than a single zone of the second
device anything more would be wrong.

