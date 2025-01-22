Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3882F14A619;
	Wed, 22 Jan 2025 06:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737526337; cv=none; b=tanTAvrxUMXb1dzfpNkI+MM/8TvHxzHOaaJXp7VCINv+9V5EsD67Juxo84LB0NxOUKIvin3Em/IKY5iEfM23nSBXvyH+uW7DB0pJ/9v7dU3l96su8R0r4Bgx4V8zDjXPb7AtEL+qy2u6vSCQvL0Uk9hS0Wv+msqQRXcBJib8ec4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737526337; c=relaxed/simple;
	bh=/U6FLkbz0Calnu9BeR1Y4ZcTyemep9tl4oQPvdCbJA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yg4GoFntcGKQA3aOU4foZMZc4JWwS02a7uAR70cT17OzIT7sInsIpQQsGF16xTNMGvz7XuW8PQ7RDKwOdvBE1Zv4lgc1nbQ2QOqOSNe1c5/5axWPJNjf3v1tVi++yG+I7ueyoPpmhL2B9B0YXZXiZS3XK+mGPZYdY1UJqfIyWWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Xer1f8nA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xer1f8nA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6eLVX+j0K2jJ2+buaAaecjCtpkFWJ+tdU79T4an7+bE=; b=Xer1f8nASRAacY74AGLmrWoyR+
	igR7muPLLRCLoF/MiSYRA8Sq6NTrN/5AbOxIYWqsFbQOhz/67GJWQdeZ/ZRc56uCSz+cRkySj4znO
	SWo0l6rAyl4GsmFdGEWiQiHCO1bq3QErrTCVrl4qwoYHmBHoDVOZPolHaH/KPdfAOF6SQYQ6i4xjH
	QQY5YpUvTPX3uC0sUZWegeg02y1DaFq/Aj88ARroE3mBQOUCjRur0yEtECALt54O6OTKGO7N2ia78
	T7YNb1zVaofaJqux+sOaBGLp6PLyVl/LTY/C2g6GtsWquiGK8y5/vDuSCP0qtbkiDs1Fs5/j7VX87
	knMx3DYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1taTyH-00000009So0-3VPs;
	Wed, 22 Jan 2025 06:12:13 +0000
Date: Tue, 21 Jan 2025 22:12:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Zdenek Kabelac <zkabelac@redhat.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
Message-ID: <Z5CMPdUFNj0SvzpE@infradead.org>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 20, 2025 at 04:16:26PM +0100, Mikulas Patocka wrote:
> Some SATA SSDs and most NVMe SSDs report physical block size 512 bytes,
> but they use 4K remapping table internally and they do slow
> read-modify-write cycle for requests that are not aligned on 4K boundary.
> Therefore, io_opt should be aligned on 4K.

Not really.  I mean it's always smart to not do tiny unaligned I/O
unless you have to.  So we're not just going to cap an exported value
to a magic number because of something.


> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: a23634644afc ("block: take io_opt and io_min into account for max_sectors")
> Fixes: 9c0ba14828d6 ("blk-settings: round down io_opt to physical_block_size")

Please explain how this actually is a fix.

