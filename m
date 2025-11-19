Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBAE205E25
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 05:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763531200; cv=none; b=AgN5CVzg17SK2T720cFw8ADCXxanbDLCEiA+6rfrZk59knKNoRsOOPDClrmkf1R+pANQt5SIEtdQi5v9Ta+U3W0V8HvyFZ7D1Vf1jHiTDyt2wHqJ3wA4h5neV+bHZTiuJ8b5TdUuqLyxWWjanozUECB6CpdUL4VFiPE+EdcxfGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763531200; c=relaxed/simple;
	bh=2BbrBH2UsfnUOIYvnbzk85XOI91QlhledzBuFk8Gl7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liNbLRxGUMt2xal+XcTbaspFr8seFWpZLqhKglvB74M5Pn6L/1AjjfcLqRO9cxGy/KkHUOMDVrAjy5AGP6Xt2RP4CtSpD6WQVY3XcQQQnN/NVZGnS4eMndJVJma3bY3AAlo54NV0lQzNcgCQfKR/aCJ/xAaLQEbJ366a/ja5XSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B126068AFE; Wed, 19 Nov 2025 06:46:35 +0100 (CET)
Date: Wed, 19 Nov 2025 06:46:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial
 write
Message-ID: <20251119054635.GB19993@lst.de>
References: <20251117105945.10179-1-urezki@gmail.com> <fff990bc-6ff9-7b34-8e80-57078de40928@redhat.com> <aRxa1wPMsJwBubjx@pc636> <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com> <aRx_lCimJco5BPKA@redhat.com> <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 18, 2025 at 06:21:56PM +0100, Mikulas Patocka wrote:
> OK - I accepted Uladzislau's patch. As logical block size and physical 
> block size seem to be unreliable, it's better to set the size in dm-ebs.

logical and physical block size are reliable.  Uladzislau just seems
to have a completely broken device that needs fixing, because it will
run into all kinds of other problems otherwise.

