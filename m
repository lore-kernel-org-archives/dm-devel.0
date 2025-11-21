Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE9322D7B6
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 07:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763709914; cv=none; b=KWvyq/YM5J8SBi7ovskWmCbX2Vubrrwx/45jpcHH+yC5jf85eDDvqEACCUiPLe+vB9EpQxAcV6Wbi3ACmVA9xWgtU0/ki0vYl/9by76jvZ5Esuxy+kT2mp4iYT7LZ+I+2OFZWbfsv5dnGxNL5lBhlp/E+Tb++PRdUAIKMkP70PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763709914; c=relaxed/simple;
	bh=/di9GL8bnJ9YqcyUrQ77QXozvYCZ39EtVtkfp7pLsPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMGewyij0yA5QsFTY8rqm7CmtJpTy2xsPe57A/SJ6J81KBpR5jX4vHInru1Xm5iXoD/MacXhzvm8xvylLE57pWnLSnbqgN1xLkGXlGiR7S0ct1h8xh8GX+Xa6reAIEiocmQ13OrlI7UqOActUV3YFuDIw306Kbu3nAGTMflMnig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E345367373; Fri, 21 Nov 2025 08:25:08 +0100 (CET)
Date: Fri, 21 Nov 2025 08:25:08 +0100
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
Message-ID: <20251121072508.GB29754@lst.de>
References: <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com> <aRxa1wPMsJwBubjx@pc636> <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com> <aRx_lCimJco5BPKA@redhat.com> <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com> <20251119054635.GB19993@lst.de> <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com> <20251120062146.GA29990@lst.de> <aR8E2ZZtOi0RZt06@pc636> <aR8MQOFX0pVldcUT@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR8MQOFX0pVldcUT@pc636>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 20, 2025 at 01:40:32PM +0100, Uladzislau Rezki wrote:
> Christoph, but i assume it is valid case: logical=512B, physical=8192K.
> Could you please confirm?

That is a valid configuration.  One that must accept I/O at 512 byte
granularity.

