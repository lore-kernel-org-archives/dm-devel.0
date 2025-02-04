Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE69139579;
	Tue,  4 Feb 2025 05:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738648668; cv=none; b=Kuj7VmGZCNzsdws41m34P6vWtrWVcbjOGJXJ5el2rhxKp4uDWJYKL+g53+RZK8tY0n2Y0ZbZ5jzPPvT6dEapu4dGLLrdAIDKdeTnyajaLBPaxCG1WxpgEB+EYrHrhBYGMmhTX1qeH38Uz4gVd/xt5i66wGDDgva6Waa4WlHwNL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738648668; c=relaxed/simple;
	bh=mNZkayeWsP1H55nQJQORCfUaDELBL2iJMSIlfaZ9+kI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7ZC3tn58zPRMFgKgBRTyJ2+Fwe70UUDY7G+KHBTD+cTKVMiBI0F2iBiPVic3xiq3Z5hyEi1iiJBeWs9obTMi0OG9u8E77yzerJz0dIOL2Za0i1lkZ2YEYJ07D/hUmz/vDOFk8CKeFFZRFLiYJ1L7aQ0Y9uzmk9k2BKO2GShrVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RoiqVP4t; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RoiqVP4t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Sn61CPCkLvOkWeJUEivSGz9P/YnVf3mNFzsAOFhGZDo=; b=RoiqVP4t8Mq4aDtmmouDgoDyZZ
	ODTjSb1eZoQnYZETiPnzhwJusPMreVTpCDVL6cOTPPRUYxfjT7McLG5Svx8hQl5/1Vj9qGxncQ1ec
	X9ekw8GwHS0hogT8rAScEX7j2J1DTrzsWrsThB05wA0hLwIXsaUZGF4zioww6d2Q2INjcH9p/6ynE
	iMxnGabT4F1reLPRWdVnL9iWU0LWoYED4NnjAfKmbyZ+rTiS8skMJmhWqAPgm5zmiciOp90m8ykj0
	vxEbJPzkZMd3WHOc79/H3IXwk3qaYdvc4qtOZ7HHuQPoLpCkVwqHC8SdBosG75hrMyJrNoTb6Pa9l
	Uhonbhvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tfBwP-0000000HJRq-2O6i;
	Tue, 04 Feb 2025 05:57:45 +0000
Date: Mon, 3 Feb 2025 21:57:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
Message-ID: <Z6GsWU9tt6dYfqBL@infradead.org>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
 <Z5CMPdUFNj0SvzpE@infradead.org>
 <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
 <yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
 <28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
 <yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 03, 2025 at 10:30:42PM -0500, Martin K. Petersen wrote:
> I'm willing to entertain having a quirk to ignore reported values of
> 0xffff (have also seen 0xfffe) for USB-ATA bridge devices.

0xffff as the max and a weirdly uneven number even for partity RAID
seems like a good value to ignore by default.  But then again just
dealing with USB will probably catch the majority of cases.

