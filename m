Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91071D12F4
	for <dm-devel@lists.linux.dev>; Wed, 21 Aug 2024 20:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724270903; cv=none; b=JXChsitELCxYFX+Jjdp6VBC/S57p/nOts98Rtl06sLOP6tuRCmCDgyMK3CCqnvM9J1jThW3d+FAKVM79h1E0BY51t224pSAMwN0ihOXbp44DM0Fd6wvZ9x0RP76EReXq4mhIHBvvD/GMmO1OxjWUFo52XoDDpplByYvuHv0W3Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724270903; c=relaxed/simple;
	bh=2q9LjjlrH3floDa4016Z+7OY5pIw6/bW3s62Fj1qL6o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=J1PdmmotCaczw9wVe4zRNu8FBBjv8ooJDc3ydfV6PZjW1xI6KAgHKuj3Ju8aXdF7UslxIuVZJUewtwfEN7cDfttSd3pPMnJuBrvdo+P3v1oJyTahXE1M8cLK6so/79nHb6NzTQ9cNzjjFJAZ2E96FyXW8KmNj1s3sYeJYFdrlEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T9okU7v3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9okU7v3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724270900;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fBQXoB3FDv+Jsur9P822UcZn4fuAMFTapF27zvyax9g=;
	b=T9okU7v3Pvb0LJDYNUWZADXe7y2VSpPfMiBMY3fti8qpygUuR80GsdGGHyZeW+521lOYj6
	GwNM3tGK8YD70q6AsKd+LgCPrWVj6CbdK4X2NuwV23Rwzc8/EpItmk01UM5TnhjqAOQc6p
	nyrW0qwSBwlPYcJeWk8oqaqmniZz7AI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-361-S_TamtTLPIK-by7EKfcjSg-1; Wed,
 21 Aug 2024 16:08:16 -0400
X-MC-Unique: S_TamtTLPIK-by7EKfcjSg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA1BE19560AD;
	Wed, 21 Aug 2024 20:08:15 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E2EE19560AA;
	Wed, 21 Aug 2024 20:08:14 +0000 (UTC)
Date: Wed, 21 Aug 2024 22:08:10 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Chu <thedavidchu@berkeley.edu>
cc: dm-devel@lists.linux.dev
Subject: Re: dm-integrity and write reordering
In-Reply-To: <CAHge_00RZ7r8Np0F4PdH50hTsX-OrkXznKU2u+R9qD16=vx0_Q@mail.gmail.com>
Message-ID: <219dcade-3d6b-b5ac-c11b-efb8dcd3bc63@redhat.com>
References: <CAHge_00RZ7r8Np0F4PdH50hTsX-OrkXznKU2u+R9qD16=vx0_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 20 Aug 2024, David Chu wrote:

> Hi,
> 
> I was wondering how (excluding possible crashes) dm-integrity
> guarantees that the hashes that it stores for each sector is
> consistent with the data for each sector.
> 
> I've been told that outside of FUAs or flushes, block IOs can be
> arbitrarily reordered (see this article
> https://lwn.net/Articles/400541/). So, let's say there are 2 write
> operations, A and B, writing to the same sector, not separated by any
> FUA or flushes. We know that even if they are concurrent, dm-integrity
> will ensure that they are not submitted concurrently: write A must
> complete first (its end_io is called) before write B is submitted.
> This is the add_new_range() logic, if I am interpreting it correctly.
> In this case, the hash of write B is written to disk.
> 
> Can the disk order write B before write A, thereby making the hash
> check fail? Or is there an ordering guarantee, that if write B is
> submitted after write A's end_io, it must be ordered after? The
> add_new_range() logic seems to suggest that that is the case. Are
> there any special flags that dm-integrity appends in order to get this
> ordering guarantee?
> 
> Thanks,
> David

Hi

There are several modes for that:

'J' - journaling - dm-integrity writes the data and metadata first into a 
journal, then it sends a flush to make the journal persistent and then it 
writes the data and metadata to the places where it belongs.

If the system crashes before the journal is written, the journal is 
discarded and written data is not visible at all. If the system crashes 
after the journal is written, the journal is replayed to make sure that 
the on-disk data and metadata are consistent with the journal.

The downside of journaling is that it degrades write performance twice, 
because it writes the data twice (once in the journal and once to the 
place where it belongs).

'B' - bitmap - dm-integrity maintains a bitmap, each bit represents a 
region on the disk. If it writes to some region, it sets the bit in the 
bitmap, if it finishes writing to some region, it clears the bit. If the 
machine crashes, the checksum is recalculated for all the regions that 
have a bit set.

This doesn't degrade write performance twice, but it is less resilient - 
if the disk corrupts data for some sector and the sector happens to have 
the bit set while a crash happens, the data corruption is not detected and 
the incorrect checksum for the incorrect data is generated.

'D' - do nothing - dm-integrity doesn't do anything to try to maintain 
data/metadata integrity - if the system crashes, the metadata may be 
corrupted. It may be useful for things like operating system installation, 
where you don't recover from a crash at all.

'I' - inline - the integrity metadata is placed into an extra data field 
provided by the NVMe device. You need special (and expensive) NVMe devices 
for that. They provide 8-byte or 64-byte auxiliary metadata per sector. 
The atomicity of data+metadata write is provided by the hardware.

'R' - recovery mode - that is read-only and suitable for data recovery. In 
this mode, dm-integrit doesn't replay the journal and doesn't check 
checksums at all. You can use this mode in situations like I/O errors in 
the journal, where the device couldn't be activated with any of the normal 
modes.

Mikulas

