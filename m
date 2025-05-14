Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5188F1F30BB;
	Wed, 14 May 2025 04:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747198435; cv=none; b=uuJ6+VqdSJzupAAaZ8kpiY+SJyYriFxR0+E8IEHxmBnY43rcJ0H7Cakc3Ms6fuBMwNyPPG5jLDzdw5wCp5WchYIkO1fyWfHZJU23hztqjDRsqEQCr+pxOcSvUuxIj8LMORE6e564tYr7z2lBJOj2I5PjKYKDN7h2lzde8NrENXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747198435; c=relaxed/simple;
	bh=vfWLaGk5xEa1YsYl+9qGBhHaZsc9On4mHXL81jdegss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcAZaFIfg7ozN9M8RbMR1GtOZ0r3AzBsqwWWFNR+K0o73kEP8oY+99DaM8ffS9hGi1ZGaLWU6QvYJ0iQBU2QtHqIdyWpKZmhaprFfeIzDjJ4CqsBlyjo+lhP4UHDHabaJ69jWiakj6ldsi63nNU56IqQRuyZ9KxZ+kYHM3q8a2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hqKOMHVy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hqKOMHVy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fz+wro42DY1g9FvCJymam7Q6S3cdoxCxDK0w0/0tleM=; b=hqKOMHVyF3gOjKqkU0OH/i7mTx
	UEgOwJxiGobNoF8RUMeN5DSdVP+69bHC/xvasW1CNSxVkgBiYAIUO9/yS0iLCEq+2xv/0xtHeWZvw
	CqRQ4ehs1ha0FtlAtBhUfblMQwa9uhWSucPAo5DN44qcN9pRMLO6Qk+E11IntlDgmoPaOS2lq7T/Y
	z9paOWki56yuh6iyUb9JQwEtih1AiERzmNjJUq692ohOQ8Uj1MepVjCqCLqd/gEU5KnA5oqssUaGA
	T2fE3z8lYRfmMFEq9ROPfBz5C5ukn2jiFSC0H5Rw6e4aPdLRSHZL597yT3z3ubcrTzxJjbvS2dVer
	X7OgADiA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uF47s-0000000E1u5-2QkG;
	Wed, 14 May 2025 04:53:52 +0000
Date: Tue, 13 May 2025 21:53:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Martin Wilck <mwilck@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
	Kevin Wolf <kwolf@redhat.com>, dm-devel@lists.linux.dev,
	hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
	bmarzins@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCQh4NeXtLLCQeVN@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <aCLe5UT2kfzI96TQ@infradead.org>
 <0340c51e-6f89-4799-b2f1-19c785a19ff2@suse.de>
 <aCLjPLCztuXhgpnA@infradead.org>
 <d2a7fa68-1890-4367-a2ac-59ec220779bd@suse.de>
 <aCLrbz3bRLwUbA8p@infradead.org>
 <265961162cf0747a82c66c6cae38aecb85acfec9.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <265961162cf0747a82c66c6cae38aecb85acfec9.camel@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 13, 2025 at 10:17:58AM +0200, Martin Wilck wrote:
> If we emulate a SCSI device to a VM, the device should support commands
> like persistent reservations properly.

Then point it to an actual SCSI device, and not a multipath-device.

Trying to split responsibility for handling the initiator side work is
not in any way support in the SCSI spec, and by trying it anyway you
are just creating tons of of problems.

> And no, passing the SCSI devices to the VM and doing multipath in the
> the guest doesn't work. The transport layer isn't properly emulated
> (bluntly speaking, we have no FC emulation).

Then fix that.  Because without it you will be in never ending pain
due to impedance mismatch.

