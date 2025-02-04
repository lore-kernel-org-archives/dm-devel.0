Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F74139579;
	Tue,  4 Feb 2025 05:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738648594; cv=none; b=NVDo1JnTzG0pAR+1HhLPImQ254Y8Aam0mD+avEmk4qKiFdBjVR+66SMnulBVUISrDWNUcvceCn5NcsKvRiuoSnmfJD+E62D1MdoKkpMjwnq7Q5SyVw7LgOen831UgdOMkg3cBw2Y2Ez1FuarwCG0JcsS2MedUPYtCea2qmNftR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738648594; c=relaxed/simple;
	bh=QaAYaxFmwCe24K9uoICiVvDZF0gi3ThVF6HJQf7YOgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9MwOxMB6C8sMOtuekLRLZ4hf25OCiXRkjR1OFX0u9Btn0X8CV4Ppxy4Zl0mdrEMFaMmrjd3TLnQ63DLjRRjgSLLuOw3ROVzOVSpCkCwsteE4rTDxaE+RG4QV/Q8vHIkMAHwhvn8UDliJwId1pkStSrilizlb9nP1a8T6tPuzYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FiXE5rgN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FiXE5rgN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6sX9E/6xPwtqiKVRLOTbPSrwxu6rS2g9tisrhrm+0g0=; b=FiXE5rgNkN0aMTWHnpxYTSNGvd
	Xqgb0419uLzWNHqAfVO/9ijy1XzC3aOPfpyoQDf66Nqf65icjMXf60qYVcIp/NI3wnlgeXvaQSkmI
	wl9agfabQ5Pt06YH9kvlf8woViaPdZvJk6ciK9yb33h1UMjwgWfPSm9PFiwX5GnXEncTxPp8v0N7j
	L4GrszFfHWYN4DuwgPSNZOHy5Xl3BrBTFrZRDigN0FoSwrKrosCboeP6T9kGKskuTwWgMBY/LvYYX
	GsDoLAu+LZKvcmZ/RiNSvPBxkuZobtOqGqT/2vIWN970aZs6HSBCNovml+Ml5z3e/t74JYqxfWg8w
	irvY+Tag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tfBvC-0000000HJNW-3Oxi;
	Tue, 04 Feb 2025 05:56:30 +0000
Date: Mon, 3 Feb 2025 21:56:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
Message-ID: <Z6GsDkcej-Es4-p2@infradead.org>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com>
 <Z5CMPdUFNj0SvzpE@infradead.org>
 <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com>
 <yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
 <28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 03, 2025 at 10:05:27PM +0100, Mikulas Patocka wrote:
> Do you think that SSDs benefit from more alignment than 4K?

SSDs is a very broad category of devices.  But yes, many will.

> Based on my understanding (and some IOPS testing), SSDs have a remapping 
> table that maps every 4K block to the physical location. So, 8K (or 
> larger) I/Os don't have higher IOPS than 4K I/Os.

4K is the traditional value, but it has been increasing at least for
some classes of SSDs for a while.

