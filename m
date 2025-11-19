Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1F12FD1B9
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 09:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763543861; cv=none; b=TuQin5S/QUtOo/5GucU3X29rLOyIv8F8gXLu4AXyi4F6Y1mQpJOE3DiDxT9kLansytkGOcFIFV87NB1Uzsokzr3Db7bqAvehRMNVZEQk6Cv7EyN8nJRk+KQBkYGNADnCLPg7kl4JdaWOFiSHG4IDEnNs/fCrwZpxW66HUdSW854=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763543861; c=relaxed/simple;
	bh=PCxsZz67oVtvwKmCB5WysqdpcjmzGwWpc8IOgfPm9Y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJypruuqrf6KfvnFk3CfQGNnaFGSgrMEH1UFPvtX2miTs47NbJaugxCvaGjKgWPw1yJbAlvt8VpUjTQ+Dfh25cHm61Rk/6pYNmLswItO6LSSuVBxwe6vFoeFDjp9Y6goQO1cGm5PFnYvrccgzTzArEDsW7/4vkRu8ox8Vfphgc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 63F446732A; Wed, 19 Nov 2025 10:17:35 +0100 (CET)
Date: Wed, 19 Nov 2025 10:17:35 +0100
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
Message-ID: <20251119091735.GA25022@lst.de>
References: <aRx_lCimJco5BPKA@redhat.com> <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com> <20251119054635.GB19993@lst.de> <aR2DIXsymZWD9EvG@pc636> <20251119085328.GA24461@lst.de> <aR2GjRaNWrfHbDGQ@pc636> <20251119090010.GA24598@lst.de> <aR2HZWE-v-umP7jI@pc636> <20251119090530.GA24770@lst.de> <aR2KTzMkZ5ThtywW@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR2KTzMkZ5ThtywW@pc636>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 19, 2025 at 10:13:51AM +0100, Uladzislau Rezki wrote:
> On Wed, Nov 19, 2025 at 10:05:30AM +0100, Christoph Hellwig wrote:
> > On Wed, Nov 19, 2025 at 10:01:25AM +0100, Uladzislau Rezki wrote:
> > > Again i rely on this.
> > 
> > I'm not sure what your random quoting of low-quality comments in
> > kernel code is trying to prove here.
> > 
> > Any device that does not support the LBA/sector size correctly is
> > not support by Linux.  We could in theory quirk it in the driver,
> > but for that we'd need to known the vendor/model and a good argument
> > why we can't fix the device reporting, as this should just be firmware.
> > 
> > Secrecy is not going to help with that.
> > 
> I will not resist.
> 
> I tried my best to explain the problem including description and steps
> how to reproduce it in the commit message if someone wants to repeat it
> in qemu with virtual nvme device.

Again, the problem is that your device reports an incorrect block size.

And you're being a complete dick ignoring this and not even telling
us anything about the device.
