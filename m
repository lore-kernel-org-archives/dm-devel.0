Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB34A1EB5D9;
	Tue, 13 May 2025 06:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118962; cv=none; b=Sq0HX1OUS7Nh7d+wrOrNUFjjZOiwBjg2y61t52Q3Tog7AQivTlk3Sd/MjiNjPXFP6kREyncT8fsMtnD8IJdP78yX4cIbdJKpZeYdYf0Cc46QA9Pagc5qioqnvQV+S93JEVnSNJzrkPQ+EZU9iSL68VejUzLit9BrcxkREcq5SS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118962; c=relaxed/simple;
	bh=x0/WdrsnEvGkx9YQtnTq1nO9ZJNK/fgD5O5yDF39WHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYl+cBJXYGtUuVSM2IfSEyVxgc1dNjXoblkgrboS+Gx0oEUtbW/lcem+qpAEBijGMQk6VaYMmYqmsG+XAeT4/zUVfDCPHEeATM9dOiis1sN0mMvLRvUMZXk+4rYOI97kNGIK54FQva9SkD6tIcPjCEW5Ko7flrr4troJJihqZMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X9nbZpjS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X9nbZpjS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x0/WdrsnEvGkx9YQtnTq1nO9ZJNK/fgD5O5yDF39WHY=; b=X9nbZpjSDAUkY3XKfzTetXI3GU
	2w907KpHsHi0U4OjkBd6mGrpxoL0s8m67m7qjgIq6bKkFnr/nUUixBnS+cG2lRpD44iSX4ydZ0NEv
	7s4ObjnIoq93Cqyub51zKdjwBJndVlr1DFkQ1WH/C4foGvBRqC4P8AeKSSDd3YvDosYQx8Gum0O68
	YYDvUZRAN+qjMEnU7NDqUoglt+dVHwEyiCEPA6QXi2NFC6FdhW7ZSOP7U1hAKWvHs5D6i+fPkPYto
	VYVpzf3yaqfvvUj34m9udmKLxDny+sWSVQcCnXqJZxGEhWa9Ei7p0FjPkz730A7RrsOt2uY9L7hvc
	t2TSnn6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEjS3-0000000BXto-0h6U;
	Tue, 13 May 2025 06:49:19 +0000
Date: Mon, 12 May 2025 23:49:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Kevin Wolf <kwolf@redhat.com>,
	Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev,
	hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
	bmarzins@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCLrbz3bRLwUbA8p@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <aCLe5UT2kfzI96TQ@infradead.org>
 <0340c51e-6f89-4799-b2f1-19c785a19ff2@suse.de>
 <aCLjPLCztuXhgpnA@infradead.org>
 <d2a7fa68-1890-4367-a2ac-59ec220779bd@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2a7fa68-1890-4367-a2ac-59ec220779bd@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 13, 2025 at 08:32:12AM +0200, Hannes Reinecke wrote:
> Reservations and stuff.

They should use the kernel persistent reservation API.

> There are customer who use GPFS ...

Supporting illegal binary only modules that is already enough of a
reason to NAK this.

