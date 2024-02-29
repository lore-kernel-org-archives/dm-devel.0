Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC6A1E499;
	Thu, 29 Feb 2024 19:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709235560; cv=none; b=expLZCMvWVnchM/g1EMC85OA8fxu9Bb6R4MGFaLj20UQkqFbEqmTR+9rw4Mylepu8RG/eWgsXoCrCchpYdupFY8ixTcXKqEgyAXiVGS2B+QvwrL0jvcFy7Yq6Rz3DFfEdJy5FYore61CNzc8eAbgzMGGK7URQ79Kg0NU6zE0rDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709235560; c=relaxed/simple;
	bh=ONwQZhWdYcui5wN34nN0cw2UqdUK4Eh09LySWF65hWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMjUTNU3jV/2TLgk2eKSW+j8XMBNAF+FH8Tj0F+CF6791eU9+ZRrGN5Y3tJOkq5hBdJrt7EjkbRyxrJ3jdHUtCSfWt187IWaUGF2ipJ/13uxYxEJGfhRCuMwI+WcjUN5Rn8RHSLtUn5+067w4SYWEnlaZSN+hG1LNvn+vvcfBEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pSFBh26/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pSFBh26/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ldDF0uFnhLM0pX4TkhBHDEP6wvmAk+l0peU5Oz8t14Q=; b=pSFBh26/VtE5g3CLLMhC/vpyfT
	ZG/n5u3pHh8YXJdUHOZsp0tvb2Q7R13SZDqDLtyZTZ7xViBqt9wkvhlR2N7eVpmHrE9Oxpzoz/N89
	gHyO6ihI2OVNCewmgkHPEZ9uczYEsxrrRawJVDwO9qHGho+KHnZm3w2uqHAL370mbrcUopHrKuhAh
	s53fpFROmBujJI1I5Z61h4YN03KeKnJyTIA6mIzgoq2Sj3zcLZGe25B2qbFXHB5NbgVqeM8YvVWxM
	rcBodK3VQ2pU58rCQ7oSWqK3IO/o47+XTLZZKQVkjBpq1fxUbxWyHZ/JY6B+cC8f3KaGBxrfgBiK0
	KXrNreIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfmFM-0000000Ev1J-2N5H;
	Thu, 29 Feb 2024 19:39:12 +0000
Date: Thu, 29 Feb 2024 11:39:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Xiao Ni <xni@redhat.com>
Cc: song@kernel.org, yukuai1@huaweicloud.com, bmarzins@redhat.com,
	heinzm@redhat.com, snitzer@kernel.org, ncroxon@redhat.com,
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH 0/6] Fix dmraid regression bugs
Message-ID: <ZeDdYLdWav6yWWwo@infradead.org>
References: <20240229154941.99557-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229154941.99557-1-xni@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

If I rund this on the md/md-6.9-for-hch branch all the hangs I was
previously seeing in the lvm2 test suite are gone.  Still a bunchof
failures, though:

### 427 tests: 284 passed, 127 skipped, 0 timed out, 3 warned, 13 failed 

