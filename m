Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86DF314B97
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764003642; cv=none; b=H9TlnYzjAw6Nb7zw9z8cG7HTW9/crtqWLL+B6lVe9G9IoyhFdWjZbHxC9msCXyvvA/IDUjDmCImfSssg4yEir9XAX0EuiFUJkqvOzV+vl82SnKDevX/RmIYnPN3ycvr1Kx9Mp9PKBDg24fsNroYYgMvaw1WngMk3XBlFkcujPcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764003642; c=relaxed/simple;
	bh=hkUCgiWZHV+w23YpLvTI0I2gf8FnOhXEmHSeGiGK7jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7CHpLH54MZzJpdZjV6GfUqxs8Ue6t5y69j4Q3aDdxDy3cK+YFuh/Iu4lxtw+qlL0Ja8yNk6gTuHbYUeAUvcpppmjOlRXIW+5iQtwIjkhr3ezDoAd8Aw1vY4zhH/LlvQjSQbnG3IWQqn4h/5OhwFyxFbGPJyrKr4ZCgfC5tcI6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CB86168B05; Mon, 24 Nov 2025 18:00:37 +0100 (CET)
Date: Mon, 24 Nov 2025 18:00:37 +0100
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
Message-ID: <20251124170037.GA28939@lst.de>
References: <aRx_lCimJco5BPKA@redhat.com> <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com> <20251119054635.GB19993@lst.de> <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com> <20251120062146.GA29990@lst.de> <aR8E2ZZtOi0RZt06@pc636> <20251121072421.GA29754@lst.de> <aSBnXqX9jmoKuv4Y@pc636> <20251124143044.GA17164@lst.de> <aSR6EZrxvlseRhZp@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSR6EZrxvlseRhZp@pc636>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 24, 2025 at 04:30:25PM +0100, Uladzislau Rezki wrote:
> > 
> > > 
> > > Why in dm-ebs we need to offload partial buffer < ubf size?
> > 
> > I don't understand this question.  What is ubf?  What does partial
> > buffer mean in this context, and what does offload mean?
> > 
> That was a typo :) i meant ubs - which is underlying block size or number
> of sectors which define the logical block size of the device. In our case
> it is 8K thus is 16 = 512 * 16 = 8K.
> 
> Partial buffer means, in context of dm-ebs, that within 8K buffer only
> part of it can be modified. For example, since we emulate 512B to 8K
> from upper layer to the device, a file system can write for example
> just first 4K within 8K window buffer and only that part is marked as
> dirty.
> 
> offloading or imposing the data to the lower layer. i.e. writing dirty
> buffers to the device calling submit_io().
> 
> Is it better? It might be that i missed something, feel free to correct.

I'm still lost what the question is, sorry.

