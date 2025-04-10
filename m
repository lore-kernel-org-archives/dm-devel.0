Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C271DF987
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 08:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744273687; cv=none; b=fY4uy+wsHiR5jLLDn1gccZ6EwxI3eqIzdgBj+9DjLe4BY2c/DGC/W4HpRnXq4ODElTtwmKKnHvP5ws6cIof8GLdGuhAIdk2ZLTit7lFi3ekQJ0Og5nzj1vWmI6OlBkQPbM8k5SVVFu1q9buIhBXZ+BT+y3DjNigjwoTuJGiN3ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744273687; c=relaxed/simple;
	bh=CdbYp+JcqBPLqTYVoZV/XTh82AuAxxmYGrIIryGz5KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BPHoe/1pvZaxqknX2NupP5VQSc72TYq3y1dTJ917Kf7rCcD9QLKKmU6w4W8806azxDux9IkP5pLeyZAADa07Y5FUVx0vDpeaQZrla4MhmL0yDaQpIIXzyo4y7yxVWUWu8jyHRBAry0MDWYfajDqA213P7mgLvgLcz5Q48VoXfzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hc0IIrX+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hc0IIrX+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cZqqXOIcnkYtfOz7YW8MYmZ0Iy5Ni8YhfvzmpenpEdQ=; b=hc0IIrX+RdpYIig02csbxqgTfL
	CIvcCvjwcTOWafQF5JyrvMq0F1X8Dp7uPyVJDsUdr0UgoiKHggfEwQqYTxgUHy7xQ0r/8RdA/YGY/
	sqi6M/2hC5Suapv5EZYNtWBCOSjnPgLMSONhGNwAxNmPHLRDUT1Sf2ktIRWGQZ3qucP/MGuXOMgh2
	FWPbyNNsuk7UGLjd1P5JoqwgQ8ZZz1kAzw8RtnajykU62sOFjwMr7EPqvx8BZL43cN1387xcKigyq
	PTKUB6P9kUuLKYB5ghXxFsZ/t04COAR7h4i0ygBSINNybCoDrBqiuWdyttuupPshU3f+HvMRZ8XSZ
	R4QlDP1A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2nGX-00000009kEG-1Rlw;
	Thu, 10 Apr 2025 08:28:05 +0000
Date: Thu, 10 Apr 2025 01:28:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: LongPing Wei <weilongping@oppo.com>, snitzer@kernel.org,
	dm-devel@lists.linux.dev, guoweichao@oppo.com, ebiggers@kernel.org,
	bvanassche@acm.org
Subject: Re: [PATCH 2/2] dm-verity: prefetch all hash blocks in verity_ctr
Message-ID: <Z_eBFarZfoFfcJp-@infradead.org>
References: <20250402070934.2387587-1-weilongping@oppo.com>
 <20250402070934.2387587-2-weilongping@oppo.com>
 <8ec81db3-fff0-71be-e643-b74cb5bb88de@redhat.com>
 <d25b56ad-fa6f-49db-9a78-d4849742b22e@oppo.com>
 <7228249e-db9d-be26-8459-9141ec3b3ceb@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7228249e-db9d-be26-8459-9141ec3b3ceb@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 02, 2025 at 08:44:39PM +0200, Mikulas Patocka wrote:
> Submitting large I/O with IOPRIO_CLASS_RT will block every other task that 
> does some I/O, so I can't do that. It needs to be changed to 
> IOPRIO_CLASS_NONE or IOPRIO_CLASS_IDLE.

Also random kernel code should not simply upgrade the I/O priority.
Your magic snowflake is not going to be as magic for everyone else.

