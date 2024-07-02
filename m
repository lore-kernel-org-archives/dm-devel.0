Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC1E7E792;
	Tue,  2 Jul 2024 07:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719904618; cv=none; b=VBGR2OG1TAwuqfVhCXxyEdNOck1Imjh6Z5l6Q2iBbVwvSakN/juUxN67XEGfWenY1ZY4D3Ylvm0OxayJ81d+Sy1NIAsfeXdVoHQpZecCzpLjEMsL1rHRavdqrPu4rT2CKzi96RwuapXIE9Ozv2pAedfHu0lV/kAlY6rA0NrvjlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719904618; c=relaxed/simple;
	bh=41coVdQHBZL9oRD0PMx+T+pa0efx8nlTEaII4pDTtIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCiW/5wg8ha5Zcg6xTruyUrbZiXGaBZEqRbCau+1W8EzmC/cx9bedxCy1WtwmiZvQvGWMdymBqU1jujr5HiwsZiaukduhxiQhFgm/oP54cMWnY6XU7yP+yav06soFqABBIds7kk3vS6+EuonTrnto66w0DSrTY57ITPq9KdKbsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tg93HEng; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tg93HEng"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HgY/4AYcbUiS408J/Km+iEzDDWhxg27xYBjk5vDbQus=; b=tg93HEngFe5ib8LxwzB5lMT6YL
	3wwyOqnfDmwf6bddN21Y9LPrCBrK43Q3nYdstRJRBa3ZyeFID2LsJ8ka0/akQFVlnmdsoRMhu3/ti
	kHp6tc20t9Z10GMdapiggqWQ9mzYS7byvmRaJ72A4p72MunvgLxLaMsdzU2Ca9QaetlDV2q/Wx8nI
	hLk7wvLW9e7TztBXdtEDOq7PubWmVBI/GiNliWB5Lu61JFVfA7JSf/81eL1p6LVuCzYi8uCEu1iUb
	wFhhOGWO5bcga0o4XX8SlQzaF4x5JRZdxc8219Fmu0hVuiAMgdekZ9wbDEEDQu4Yve3HY6pL3faH1
	Skt5zFoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sOXkx-00000005psG-3P8j;
	Tue, 02 Jul 2024 07:16:51 +0000
Date: Tue, 2 Jul 2024 00:16:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/7] dm-verity: provide dma_alignment limit in io_hints
Message-ID: <ZoOpYxX-7_HD9zXH@infradead.org>
References: <20240702064835.120541-1-ebiggers@kernel.org>
 <20240702064835.120541-5-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702064835.120541-5-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +
> +	limits->dma_alignment = limits->logical_block_size - 1;

Please add a comment here to explain the limit based on the commit log
text.

