Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD58720AF77
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 08:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744273609; cv=none; b=BfkEt8ZmMiONH7vcnh5NMi4dzXVSv/QiFYEKY47DP16KhHipWDont3OzobyPlvMv4OELgIgEAb5NX3UN2xNhwjiai5clcyVS8RLK6rt+edtp9J48mM0ide3KmN3PdaMJ5UB6+lHyHdsALk5EMnv/tP12cmqsQmJ6EPWSo2UwDLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744273609; c=relaxed/simple;
	bh=HEIlhrzYw9mup7fwqaBfCELyF2SxjcyFSDDqXCaouGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gOH5YC34JWN1U/fgqf7xaF+8ow3TkDv3WbKugaZOLtmmmP6eg1TUwQWFrkVItybQ2vX9NOcvPGfODui0rFOVkUhgkjW8wFucGHniN3EEBN5IDlRT18gT8DpLe5ss0f23N9uoLasfH44sFXRrMsF566bJvEi2ka6DWCILjPauE6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m5j3jnTK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m5j3jnTK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HMvFDf6vO43KDcoILOCFZz2j05ez/RdLUgFBi1wcIz8=; b=m5j3jnTKzFL+8npSa41j6g5cNR
	5RUCKT2tOCwFW50Nw7g7WlaokVqt0mkUq0waNIFq+Ulwf+rUosJDb/Nru0yxTkldFdi0PF6s5+loO
	ppbM2+oIIFGs3YtKa0PUn4E77W7HymfhhrPjGWW1S5cWh0E2ScM6COKzLKjphyim5kiQ7EfE6Dd0M
	EadyjENoe58VLx1WEfLwUt36HzoFVq47Adz9Bo2s6+JgaXSmGhMyVGlR0rbnuKFp3Ef8W6EPztWzL
	HmAwuqQNbS0QuVJHCw8nmu36jWPkxwEPYGd5XnhePfeS7qYh0BVmvFJcwFCJsyxoJYFykaLIEod9o
	Jova46mQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2nFH-00000009jwT-1Z5u;
	Thu, 10 Apr 2025 08:26:47 +0000
Date: Thu, 10 Apr 2025 01:26:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	guoweichao@oppo.com, ebiggers@kernel.org, bvanassche@acm.org
Subject: Re: [PATCH 2/2] dm-verity: prefetch all hash blocks in verity_ctr
Message-ID: <Z_eAx9N8IWiz_G9x@infradead.org>
References: <20250402070934.2387587-1-weilongping@oppo.com>
 <20250402070934.2387587-2-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402070934.2387587-2-weilongping@oppo.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 02, 2025 at 03:09:36PM +0800, LongPing Wei wrote:
>  
> +	dm_bufio_prefetch_with_ioprio(v->bufio, v->hash_start,
> +		v->hash_blocks - v->hash_start,
> +		IOPRIO_PRIO_VALUE(IOPRIO_CLASS_RT, 0));

Err, no.  Random code should not prefetch with a RT priority.

