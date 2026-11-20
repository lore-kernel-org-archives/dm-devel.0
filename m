Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188142;
	b=Lu/3iMhQE8gvzwEgzQACDk3/yKvkvQKOdV4hIFZDz1u8wEIzH9mPkfvzkmaT83zxtIss
	 R3BJFREp4+OuW6JMWhAHz8KhN9c/yZNWiYoKx9CzVCkWWK4oX+cy2VKuU6rU4Tq+CABB0
	 9weqOaqN0AWU093O0S0euDLsfFHVD7Mm9y6CG3rQ9zShSDTa01vD7sSq1YcpPMdhPU9ye
	 m0H41bOPz5iUE03aKjUsBq6Ub9OLP9b6Ajvle/B2c473DLlrVuQfVI3iOOz4Gh9Q/8WYS
	 Xilaf45oOGFVfBXtBSOCcnQEvPo3nAiS+abYlDy2aRdp4OTRLIYX0wBlCvrpgQuoK/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188142;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=rsy4DwQA+i0NEZBScsPjOPX4JjtcB79SgylulL4Lhzk=;
	b=w1ScgXg3n5xbPWncK38s5H5z1suIG5DDQTfwzWvP17afjJ6nnUgmR3cF/WrmXstmlyJz
	 hBWpD/2mAY8nJBwoyqwTeYzpZdoxGvXdxGVVy86s7obF0srTkbPETa0S1nbZRwCq6pbbz
	 SAyQ95wX5wbLlm31hzegu1aKwO2X0dIGmSWIL7+utkrRSrP0vSSZKiMXQVHaDTBpTMx3x
	 /TMUYrbOHa208M90mn/x82FKG8lLJZ3UpIWdUjc/PHSc3grnhL6nwQSEg6xD5piYp8YDv
	 mWnZXuC6eSGn+6CQN1q5AArZfy/JWpb/9uzuP1bsH9BZV2FlCEk80lzDL5pjCafClig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=G8PIDRBn;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D55606A320;
	Fri, 20 Nov 2026 15:22:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2D55606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=G8PIDRBn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rsy4DwQA+i0NEZBScsPjOPX4JjtcB79SgylulL4Lhzk=; b=G8PIDRBnx71sTaraFoEjvuYds0
	CpdlXs8HW69pllSZORFRu3MEkkWlpTH7nONYfWuTJ7oyqBbPd/6Vc1xTO9NyLiN9LyccG15gCPEaa
	OErzGfB4btucPPrzYjf0z2zGpejwUwCZvHE1d0arOJ60NeOS4dp8kzBMRKQAG46z6q5VImGtKn36+
	wHJQa7qXA1b9OpOQxBGQeDHBunMBR3xElw4YLiSi0MbalCUsQiqeg2ZjFh7ViNIUPTZ81gAI2P+tw
	+Rk9zQY9bIgaxZpdD6vuOyLnTVP4L5qkmoANORb2f7aaxF3hT1JVvwHvAKtuPKc5uZTrwm7A650iv
	DxyQg0Uw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUQRL-0000000FOdL-0Qa0;
	Fri, 20 Nov 2026 15:22:15 +0000
Date: Fri, 20 Nov 2026 07:22:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: axboe@kernel.dk, hch@infradead.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	mtsai@redhat.com, stable@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v4] block: fix discard alignment for non-power-of-two
 granularities
Message-ID: <awBlp41S0RxBowC3@infradead.org>
References: <20261120101758.45513-1-dennylin0707@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120101758.45513-1-dennylin0707@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

FYI, this still looks good, and it would be great to get this into
7.4-rc ASAP.

