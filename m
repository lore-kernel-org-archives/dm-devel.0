Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA00F19F103;
	Thu, 20 Mar 2025 05:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742448347; cv=none; b=jTGyNXPvZeA4ibLnOMnXKON356QNN7uCTv1hKGQt+HANYnv8qY0hH5EEPdv1q3jHR9kisn02on9xtB3wynQZKQNVRGqe9bomYqQnQ3ZDyvKsy0q7JhtXZK2456Krg0bJ/Sm5AgyrRoh/qi5AWZcXCs0GEyIx7lbKhcplGyfFH+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742448347; c=relaxed/simple;
	bh=WoejwhvEiMMa2P/805iM2aJULdxpPlMRNB+E5am5kDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfSFSz0wYLYzygNT56vX19tHku9A5GBYRYUvfgPVIVLlDh/amW1o02VBE8xEUfubX3jmM0JykJJHnHKROc4D1HWAtw9S6h1eUvNXVt5yVLhKjmV+KtcKxehOuxNMsSYZVg0kz/683rJDO/G4W/WlmuU1KLFV2yxPGMvL2D7ri2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3D6zcpwA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3D6zcpwA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WoejwhvEiMMa2P/805iM2aJULdxpPlMRNB+E5am5kDo=; b=3D6zcpwADcLVBgV0pusQmPcig4
	7dgP6eHvQOw6LFhGo3cw1OaOBBCtWCEIVNy6tmUSBghr4R7Ci/6turGMbTAgNyCape4uz/LxYfCt8
	KXS5SP/FCEkZv6U2LmkiZ0hPnbxub5NSOx39w+9gO3fwjXZOGc7dyKOJRD3N5FFjQ9Xb3y3i1//+8
	gNsX+P/04qglpx/anXjB2KFwWVzhCCIFxnZiOy/CnQeV+dSAqUA8b9qQm74EhFUfDmO+DUpSkpTz/
	e8xaBkVLaAX9xeFHuF8sVG3Ox7LrdFbjpDjFcjIOVkZH8n/boaCbS5u1x3L87k01D9nyQOLrHJ5ZI
	p/gfS7Mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tv8PP-0000000BDQn-2Slr;
	Thu, 20 Mar 2025 05:25:35 +0000
Date: Wed, 19 Mar 2025 22:25:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATC] block: update queue limits atomically
Message-ID: <Z9umz8lVGwvuc3ZG@infradead.org>
References: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 18, 2025 at 03:26:10PM +0100, Mikulas Patocka wrote:
> The block limits may be read while they are being modified. The statement
> "q->limits = *lim" is not really atomic. The compiler may turn it into
> memcpy (clang does).

And that is intentional.

> This commit changes it to use WRITE_ONCE, so that individual words are
> updated atomically.

You fail to explain why the intentended non-atomic semantics are a
problem.

Note: it usually helps to Cc the other of the commit you suspect is
broken if you want a quick resolution.

