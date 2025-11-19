Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B3833436D
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 09:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763543135; cv=none; b=ixcCDgGndEN8Fncwz2Ct3nt8Uo9uVWJ0OewtJesFc8ibZbnVGq9UnPt+PQ2x3BoDGAQY79UKuSUlsDTUtBeBwlIcNKH7QX2OAZh7djTMVMc59uQaQF6sPYjZg87B7xlFcCgbCr1TfNUOZjtkX+0eF6/EZ0B1n5SKYZo/YycQIP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763543135; c=relaxed/simple;
	bh=TKNIgNsb934eG0+WlsyswXd1CQHqr9/HEIUUVCIaMr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+HHxmPT5EyzwWCLEYEkn9ygJE+ZxOGxrjT49Pw/ISAsSnu8GnBd/TRJtGWMT92rJnVwdoB79PhaSEvb2Cs9HYN8rGtYto/HH6vxKKjrtguGds2HaQ63c5vpaqIM8Z1XH2uS3yesuNmcIBd1kCUIJ+CXHigiVZrEvpaJZ583Fv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8CBD56732A; Wed, 19 Nov 2025 10:05:30 +0100 (CET)
Date: Wed, 19 Nov 2025 10:05:30 +0100
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
Message-ID: <20251119090530.GA24770@lst.de>
References: <aRxa1wPMsJwBubjx@pc636> <73556fc8-5fbf-37cb-26b9-7cdb88f69720@redhat.com> <aRx_lCimJco5BPKA@redhat.com> <230baa83-cd79-f232-5fb8-1476115e1ae7@redhat.com> <20251119054635.GB19993@lst.de> <aR2DIXsymZWD9EvG@pc636> <20251119085328.GA24461@lst.de> <aR2GjRaNWrfHbDGQ@pc636> <20251119090010.GA24598@lst.de> <aR2HZWE-v-umP7jI@pc636>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR2HZWE-v-umP7jI@pc636>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 19, 2025 at 10:01:25AM +0100, Uladzislau Rezki wrote:
> Again i rely on this.

I'm not sure what your random quoting of low-quality comments in
kernel code is trying to prove here.

Any device that does not support the LBA/sector size correctly is
not support by Linux.  We could in theory quirk it in the driver,
but for that we'd need to known the vendor/model and a good argument
why we can't fix the device reporting, as this should just be firmware.

Secrecy is not going to help with that.

