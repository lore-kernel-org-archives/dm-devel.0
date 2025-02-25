Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3053021ABBB;
	Tue, 25 Feb 2025 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740497936; cv=none; b=qLT6ZEEEcsqIlhtuJKVIcRfUXXlKDHYbo8C7yikA8YarucXIBX5QL6za+TAHzY7ZgmGAmr+1AWMdkXluD868OckuekD8ncDyX96gG+IXJlb+Fv1HsIFujQPisQxNwvRdAguL4Qh0RMk9mVh+9AHpi/yCHdCCob6wuFbZxyT2bI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740497936; c=relaxed/simple;
	bh=wOGorsBJJZl6+/+eDQn3Pcl8r9rTnpJ74+h7RPc2OXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHDY/7KGcXZesX4HdavJTwha45Zqa3PUe/uBtfXWilHYqT2YcHqvgGyJEdHrAAzWRnA9lJEsmWUWFRwnYFycS8yiFAZcnQ7mTABlzm0hBuClCx1WEl+zV59Us8SoHNb9ZikOjKg0Z4AU3GqtG5J4E+VpO9Yum9fexYoXMeuAeBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ckWPmLsp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ckWPmLsp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=k31hCZL2vjeapwXR82N1NDkjPN+BLgfual8VES9awHM=; b=ckWPmLspCq/7CnnacQW7ArwZEA
	7QAjlsC+p7jpnqxKGScfXQDw1yAUho/WBoG4XyF3IpqnvjaweVhcdt9olxBxmcfx08k32O7nbBTuv
	JXa8ezIA2PNSEQFh9e4EA4s0HtxpIfy/vb6zV0AWTMmS6HNCP+7bes9p6POpudc5mRcOC+8xX3Iuv
	VvzRtDue4LAoEdv3i3LpHQX1Vv7EPQrJRO113OMnqs+30Pox0w2deRDUVVNOIiKIfUKek0TaKePpX
	FMTEHXEIbRdXJT/7Ek1bf569A2CmGSotwJjuzwduCALYMMzRh/PoMU4xW0T02r63xuqJPI5ALITeW
	w8lVYEew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tmx1J-000000005ts-2Xvj;
	Tue, 25 Feb 2025 15:38:53 +0000
Date: Tue, 25 Feb 2025 07:38:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Milan Broz <gmazyland@gmail.com>
Cc: linux-block <linux-block@vger.kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: sysfs integrity fields use
Message-ID: <Z73kDfIkgu4v-c9W@infradead.org>
References: <67795955-93a4-405b-b0b7-e6b5d921f35e@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67795955-93a4-405b-b0b7-e6b5d921f35e@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 25, 2025 at 10:23:49AM +0100, Milan Broz wrote:
> Hi,
> 
> I tried to add some support for using devices with PI/DIF metadata
> For an NVMe drive, reformatted to 4096 + 64 profile, I see this:

Based on everything below you have no formatted it with PI and you
also don't plan to use PI, just plain non-integrity metadata.

> 
> - /sys/block/<disk>/integrity/device_is_integrity_capable
>   Contains 0 (?)
>   According to docs, this field
>  "Indicates whether a storage device is capable of storing integrity metadata.
>  Set if the device is T10 PI-capable."

this is only 1 if protection information is enabled, and 0
for non-PI metadata.

> - /sys/block/<disk>/integrity/tag_size
>   Contains 0 (?)
>   According to docs, this is "Number of bytes of integrity tag space
>   available per 512 bytes of data."
>   (I think 512 bytes is incorrect; it should be sector size, or perhaps
>    value in protection_interval_bytes, though.)

Yes, it should be an integrity interval.  Which for all current drivers
is the LBA size.  And the tag_size is the size of the PI metadata, so
0 is expected.

> Then we have new (undocumented) value for NVMe in
> - /sys/block/<nvme>/integrity/metadata_bytes
>   This contains the correct 64.

Yes, this contains the full size of the metadata.  And besides
documenting it we should probably also lift it to the block layer.

> Anyway, when I try to use it (for authentication tags in dm-crypt), it works.
> 
> Should tag_size and device_is_integrity_capable be set even for the "nop" format?
> Is it a bug or a feature? :-)

It is expected.  The only issue is that the block support for metadata
is called integrity all over because it was initially added for PI only
and then extended for non-PI metadata, which makes things a little
confusing.

> If not, what is the correct way to read per-sector metadata size (not only for NVMe
> as metadata_bytes is not available for other block devices)?

Right now the nvme specific attribute is the only way.

