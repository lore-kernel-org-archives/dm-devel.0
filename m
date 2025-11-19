Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FE62248B9
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 08:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763542417; cv=none; b=hwQM0OZ2yBpNY7In9+VezToKH0MeZbtVwtleqAB7+20tr8WDDx9YSAb2vz1hObDPnHFHZ7j0tKsobZXPwSAGgyUVs5npN1BorQukX7Jr8aVOU3wPQg9kwgwgTTdwUWLc4aP6I16pARo0SYYET3Obt7X3cc25rPPK9+JAhjuFklU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763542417; c=relaxed/simple;
	bh=P5vu+PostL+hD3pqBrqUn6uwLw28B6pTxXiucL13EzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SlRpUm7T6c5m+KlOhWDOAmxCMdDR4s17x7NiqnzQWz4h+cbbNnyQOD/QY/Kh1ma1cqdMIjgoWWSZuzl3iTHUE692gimXHgv+pPGMQaVhn2djZK4TDFHqTTRqUsiuFQnOieQ39vGd1y47epiXxVvBjvR+gIBA27RhI6e8ysEn2p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 11782227A88; Wed, 19 Nov 2025 09:53:30 +0100 (CET)
Date: Wed, 19 Nov 2025 09:53:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <20251119085328.GA24461@lst.de>
References: <20251117105945.10179-1-urezki@gmail.com> <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com> <aRxa1wPMsJwBubjx@pc636> <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com> <aRx_lCimJco5BPKA@redhat.com> <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com> <20251119054635.GB19993@lst.de> <aR2DIXsymZWD9EvG@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR2DIXsymZWD9EvG@pc636>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 19, 2025 at 09:43:13AM +0100, Uladzislau Rezki wrote:
> Well. LBA is fixed in my case. Just only one format which is 512B.
> 
> Whereas the I/O can not be performed by using LBAs sizes. It is fixed
> and bigger.

Then it is not an LBA.  The LBA is defined as the minimum block size
you can do I/O on.  Aka your device is really gravely broken.  What
device is this and who is selling it?

