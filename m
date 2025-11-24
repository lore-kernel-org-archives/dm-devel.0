Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA32086334
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 14:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763994650; cv=none; b=QJ4lMFVCLS5ZArMb6U/QMV1/PpPU592Tb/CfAdN3i4lrkDY3JL73NyKe9ZKx2WSOMK6bOjCloV6pQluPb4elpVRsWBLmguHc50WYPeDketNzsVxCrT+ET6MdWLym6NMBMfHr26SdxIwNtxU9H6U9pzW10/Vp1/1e++vbtbPORwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763994650; c=relaxed/simple;
	bh=Q3zQD5pce4sdSqhlZDNMEpNzh1aM4vh/qQ6xCrXTSGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cgRdVc/wIhSRlTEzJkmO4ahcU4s8RQNL3MLIyPi4xb59ZOsL8DNW4Zj1T7t/5nNO1RrwWaZbWUa5P+TRlCJA2k5gljGUIWvqW8Frh3f5ZI7nu5b2EqQQQuXQZsNVLGciEnkERo78JxI9UXBwMG7RRUThBpCSK7m0amwbuTeG2QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1819168CFE; Mon, 24 Nov 2025 15:30:45 +0100 (CET)
Date: Mon, 24 Nov 2025 15:30:44 +0100
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
Message-ID: <20251124143044.GA17164@lst.de>
References: <aRxa1wPMsJwBubjx@pc636> <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com> <aRx_lCimJco5BPKA@redhat.com> <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com> <20251119054635.GB19993@lst.de> <bcd929c2-88b0-36e9-0e22-4bb0293300b5@redhat.com> <20251120062146.GA29990@lst.de> <aR8E2ZZtOi0RZt06@pc636> <20251121072421.GA29754@lst.de> <aSBnXqX9jmoKuv4Y@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSBnXqX9jmoKuv4Y@pc636>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 21, 2025 at 02:21:34PM +0100, Uladzislau Rezki wrote:
> -               offset &= -DM_BUFIO_WRITE_ALIGN;
> -               end += DM_BUFIO_WRITE_ALIGN - 1;
> -               end &= -DM_BUFIO_WRITE_ALIGN;
> +               align = max(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev));
> +               offset &= -align;
> +               end += align - 1;
> +               end &= -align;
>                 if (unlikely(end > b->c->block_size))
>                         end = b->c->block_size;
> <snip>
> 
> and it fixes the setup which i described in the commit message, but i
> have question.

And this patch, using bdev_logical_block_size looks correct.

> 
> Why in dm-ebs we need to offload partial buffer < ubf size?

I don't understand this question.  What is ubf?  What does partial
buffer mean in this context, and what does offload mean?

