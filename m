Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6498EEBB
	for <dm-devel@lists.linux.dev>; Fri, 27 Mar 2026 04:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774586415; cv=none; b=S6sG5V/wzFOpZG4fX4Z9h6itoEAbMJEu7svKxyraGVWssnZl5qdPvmcgD7gh0nY9QmQWqa2v1o/hnBM3VQNRsagJKQjMg5QxVEv4DAccQm08k/ksvpWvkYJ5fefQKDRK6xSOguBkHCqBxU/dYmK5RUC/nJ2OclmMVpETytJ0p1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774586415; c=relaxed/simple;
	bh=MyZVx4UKuZ65TuQc1udP9tQsFC7hWuXtHZK0hGE5BPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mqjj73UzPCDW2N9RyOqyVCy0mFV1KspuhKj3Y70RI33MfxpCwyGvTBw1R9v7v4tfDcBaaQins/cXEEQ9M0EXap1fHskkA8iWUq1jkQIR8MfElZEg/NdlRFQFWxh3zPVLKnC7PXr0RIOLyojDcflITmHo2RDzwK/UmcpJqchxEkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgemrelse7q.lge.com) (156.147.1.151)
	by 156.147.23.53 with ESMTP; 27 Mar 2026 13:33:57 +0900
X-Original-SENDERIP: 156.147.1.151
X-Original-MAILFROM: chanho.min@lge.com
Received: from unknown (HELO BRUNHILD) (10.178.31.97)
	by 156.147.1.151 with ESMTP; 27 Mar 2026 13:33:57 +0900
X-Original-SENDERIP: 10.178.31.97
X-Original-MAILFROM: chanho.min@lge.com
Date: Fri, 27 Mar 2026 13:33:57 +0900
From: Chanho Min <chanho.min@lge.com>
To: Guillaume Gonnet <ggonnet.linux@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@schwermer.no,
	chanho.min@lge.com, jaeyuel.im@lge.com, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm init: ensure device probing has finished in
 dm-mod.waitfor=
Message-ID: <acYItW3pCI99s2ab@BRUNHILD>
References: <20260317213229.18371-1-ggonnet.linux@gmail.com>
 <abtakh4sU3HldDBB@BRUNHILD>
 <DH6N0QM6764O.2CZNT5C8VH6Y1@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DH6N0QM6764O.2CZNT5C8VH6Y1@gmail.com>

On Thu, Mar 19, 2026 at 10:05:46AM +0100, Guillaume Gonnet wrote:
> Hello Chanho,
> 
> > This patch seems overly optimistic.
> > wait_for_device_probe() only waits for driver probe() callbacks to finish.
> > However, partition devices (e.g. /dev/mmcblk0p3) are often created
> > asynchronously after the parent disk probe has completed.
> 
> This patch does work and fix the issue. I let you read my detailed
> explanation on how it does in my latest message on the mailing list:
> https://lore.kernel.org/dm-devel/DH6MMYX3TX5Y.R3N3IX6370ED@gmail.com/
> 
> Basically, it replicates what was made for rootwait= argument, which has
> the same objectives but doesn't suffer from this issue.
Hi, Guillaume

I have verified that your patch does fix the issue I was seeing.
Given that blkdev_get_no_open() is no longer a public interface,
your approach seems to be the most suitable solution currently available.
Calling wait_for_device_probe() twice doesn't look particularly elegant,
but I can understand the reasoning behind it.

Reviewed-by: Chanho Min <chanho.min@lge.com>

Thanks
Chanho
> 
> > The previous per-device polling loop was much more robust for dm-verity rootfs
> > use cases without an initramfs. Replacing it with a single call to
> > wait_for_device_probe() is likely a regression.
> > Instead, we should restore (and possibly improve) proper per-device waiting
> > using blkdev_get_no_open() in a loop until the actual partition appears.
> >
> > That said, Christoph also pointed out in the thread that dm-init is inherently
> > fragile, and the proper long-term solution is to use initramfs + udev.
> 
> The blkdev_get_no_open() is an internal function of the block system.
> Christoph moved it out of public headers last year (see commit c632021).
> As you said, he is not a great fan of this dm-init wait mechanism so I'm
> pretty sure he won't let you make these functions public again. My patch
> does not depend of the block system at all, while still fixing the issue.
> 
> Guillaume
