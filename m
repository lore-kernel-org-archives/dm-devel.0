Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFC01F0E2E
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 12:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763469991; cv=none; b=QIGMCOIWU70RXtiQmJRg2D4fXLAAbyh0x+qDzU2cAln0Rj80t/U0ia2uqWvUZNtKunYHQuFeLcXaQynEClmGwZo7LuApgAQNbLKQ1BLVXxanZzCOAUtqO/LqTkLCs/Hr2zzcZdHc2MtxrZAsiRBWb9JUN7AWLUVsO0tDDCKYRt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763469991; c=relaxed/simple;
	bh=6u9DrSE4YAdfmX/7rVtXhqUtqge8E2c7J0xrUUgyg2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=snzKm+I6L7oID3rfP8ee2IMajdF8bI9CF2TFvPCpsrAb2AJkp1pbQFdAlfOVNcMo3Ihtn3sD6b+DlUIy085in5jc9P3BrpSg6/ps65ZrZ/4XGjtUFlR1/PbojPtClizW200XfEB+6RwRLrt8ZhJ0iFbiXo3Db3Gr/0dDHQI21KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 278FC68AFE; Tue, 18 Nov 2025 13:46:24 +0100 (CET)
Date: Tue, 18 Nov 2025 13:46:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <20251118124623.GA32286@lst.de>
References: <20251117105945.10179-1-urezki@gmail.com> <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com> <aRxa1wPMsJwBubjx@pc636> <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com> <aRxpPFQmbB0wnmM7@milan>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRxpPFQmbB0wnmM7@milan>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 18, 2025 at 01:40:28PM +0100, Uladzislau Rezki wrote:
> > If logical < physical, then the device performs read-modify-write cycle 
> > when writing blocks that are not aligned at physical block size.
> > 
> This is not true. It depends on your device and specification. If it
> can't there is the dm-ebs that does the job.

Logical blocks size is the access unit.  Physical block size is a hint
that the device might be doing RWF and thus be slow.  What driver/device
are using?  Whatever it is doing is completely broken.

(that being said aligning things to the physical block size as much
as possible is usually still a good optimization, that's why the
value exists).

