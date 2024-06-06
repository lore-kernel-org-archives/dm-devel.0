Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D45C19D8BD;
	Thu,  6 Jun 2024 01:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717636892; cv=none; b=F2m6U6mOO1bKk6osAifcgvpnGlNlAPZKFQqO8aPRHYoRQ3svyqPtvbtGssIhFGk3aLdj2GPszVSaB48HcgYW9ehW9qhSKrBvmdLSBjK2GMD3IUXsrnC3USt4IwqnrZlZeXb7QMWtXTxmZtfCMqpXt0rTS0E/Z4R9AHvadz0J13o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717636892; c=relaxed/simple;
	bh=4spr3/x8vYejoGMRrUhZYEXe6VbQQ6Q6W+ZE3T89Jcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hG7NQc5Ryp2FvduUZGbV7tozYQWjdCKa9FnFBeqKpIiOBDK3plFBUxuNgRAGuz6jgngTAEnjSDDFKCMlwaUUswRiaIv/DdEIk728fVxZCW22mgFWhINgsDC2CKjlrpYuZMtDi96r3FipZAc2xJ7Xj1QttVIVFvuCqk2hblgIask=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g68AN7VU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g68AN7VU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8363C2BD11;
	Thu,  6 Jun 2024 01:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717636891;
	bh=4spr3/x8vYejoGMRrUhZYEXe6VbQQ6Q6W+ZE3T89Jcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g68AN7VUgxpBT4m+jaHAqO7kCBOXYE/Ciitz+DxX4jVKgFZALp+H+sOz9CuigJtQW
	 YPjCN6hbK4BbFkGoOb0ZzHaTYEzliCxEkDULkMiQzsAgV1VIUe84r2VGW/iOFr6hrJ
	 FOZ4xeSkzNHSdUx0QFFZJ11XTPGwMcEm/qoQAQRfcpn9ma1Ss+lnWQnMan404yhlXd
	 FLxUcc8mE/c8BsnN1iS4nDEllFAKqI2OHibhNJQ9ocPQ+/BqoB5P1LeVN7LbczcKyn
	 kwXy6ba2NaHXctglB3V+uWjzM74KzEo8Q72L/zaKvqJPXGT3TRvYMFEqsSgR4QHOHJ
	 XUD2s2gvjr+Jw==
Date: Thu, 6 Jun 2024 03:21:26 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v4 1/3] block: Improve checks on zone resource limits
Message-ID: <ZmEPFn9tvZb95fgz@ryzen.lan>
References: <20240605075144.153141-1-dlemoal@kernel.org>
 <20240605075144.153141-2-dlemoal@kernel.org>
 <ZmCfmlnoo7wjQLTg@ryzen.lan>
 <2e8b1334-61a1-4c1c-a4f7-9550e32e7be6@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e8b1334-61a1-4c1c-a4f7-9550e32e7be6@kernel.org>

On Thu, Jun 06, 2024 at 09:06:58AM +0900, Damien Le Moal wrote:
> On 6/6/24 2:25 AM, Niklas Cassel wrote:
> > On Wed, Jun 05, 2024 at 04:51:42PM +0900, Damien Le Moal wrote:
> 
> The problem you are raising is the reliability of the limits themselves, and
> for NVMe ZNS, given that MOR/MAR are not defined per namespace, we are in the
> same situation as with DM devices sharing the same zoned block dev through
> different targets: even if the user respects the limits, write errors may
> happen due to the backing dev limits (or controller limits for ZNS) being
> exceeded. Nothing much we can do to easily deal with this right now. We would
> need to constantly track zone states and implement a software driven zone state
> machine checking the limits all the time to actually provide guarantees.
> 
> > Since AFAICT, this also means that we will expose 0 to sysfs
> > instead of the value that the device reported.
> 
> Yes. But the value reported by the device is for the whole controller. The
> sysfs attributes are for the block device == namespace.

The limits are defined in the I/O Command Set Specific Identify Namespace
Data Structure for the Zoned Namespace Command Set, so they are per NS,
otherwise they would have been defined in the I/O Command Set Specific
Identify Controller Data Structure for the Zoned Namespace Command Set.


> 
> > Perhaps we should only do this optimization if:
> > - the device is not ZNS, or
> > - the device is ZNS and does not support NS management, or
> > - the device is ZNS and supports NS management and implements TP4115
> >   (Zoned Namespace Resource Management supported bit is set, even if
> >    that TP does not seem to be part of a Ratified ZNS version yet...)
> 
> Right now, this all works the same way for DM and nvme zns, so I think this is
> all good. If anything, we should probably add a warning in the nvme driver
> about the potentially unreliable moz/moz limits if we see a ZNS device with
> multiple zoned namespaces.

Well, it is only a problem for ZNS devices with NS management.

If there are two ZNS namespaces on the device, and the device does not
support NS management, the device vendor would have been seriously silly
to not allocate and set the limits in the I/O Command Set Specific Identify
Namespace Data Structure for the Zoned Namespace Command Set correctly.

But yes, this concern cannot be solved in disk_update_zone_resources(),
which operates on per gendisk (and there is one gendisk per namespace),
so not much this function can do. If we were to do something, it would
have to be done in the nvme driver.


Perhaps if the device is ZNS, and does support NS management, but does
not have the Zoned Namespace Resource Management supported bit is set,
divide the MAR/MOR values reported by each namespace by the number of
ZNS namespaces?


Kind regards,
Niklas
