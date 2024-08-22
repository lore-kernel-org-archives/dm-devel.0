Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0BB1CCB36
	for <dm-devel@lists.linux.dev>; Thu, 22 Aug 2024 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724348022; cv=none; b=hM6k0i84Q61oTQFBq7NR0PANzpabXkqdZUBr8MFG3LI1+9+71s/T0LJFwIJm4sY0OyKRekupwqJ1pVGt39V4DiIxpoEmfJc2u0W0EDY49ZWJGkwRpuHl+kQKIGiv1cob4yeiJ9oZIYyZREqGZzXNi+TDddpZyx2RRQF0ksQGIas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724348022; c=relaxed/simple;
	bh=XETr+agcXDIon2OY3zNFyGPPRvu3vWCu/6JGLGoBEwU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XCulLToPsJbDunHXK1zPqhdHS9GNulfusRDF6m59t5ZhgWQW1mTMhuxcjecYrnM4eildVYR9Pq7ch63JdcGRuCfyVjAvn5P+s5UaLd/wtrrZNiqtUE2jgXKrAiUEsqJZVEOuKTupEFERBOQTNY9GpJrk2CV3eNet5IFU9G0nuPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YK4hKuaL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YK4hKuaL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724348019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0JPqXb/EIbOnsSSAl80TyHGlvDSY+gSQmvY882Oe35c=;
	b=YK4hKuaLOIkF9ZzJteXHmkXw/qlu3hWeCSlQ8ftw2mRiShmjOyme36J/nrD7VX5MEsKsX7
	6skLcrBzPad2LCRiAc4J3xHo3T7oZVOcKgVbl+0axHeJwkkvBSPWNept7yJx9nvHTyF2St
	FQzX3tC48K0Ho0yeZX9tlk28Wg1ixw8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-394-vaTJdv9oOgqVFDZL1TMbbQ-1; Thu,
 22 Aug 2024 13:33:34 -0400
X-MC-Unique: vaTJdv9oOgqVFDZL1TMbbQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B56CF19560B0;
	Thu, 22 Aug 2024 17:33:33 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B59593001FE8;
	Thu, 22 Aug 2024 17:33:32 +0000 (UTC)
Date: Thu, 22 Aug 2024 19:33:29 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: David Chu <thedavidchu@berkeley.edu>
cc: dm-devel@lists.linux.dev
Subject: Re: dm-integrity and write reordering
In-Reply-To: <219dcade-3d6b-b5ac-c11b-efb8dcd3bc63@redhat.com>
Message-ID: <66c00dfe-ac48-db3e-713e-9541468b9879@redhat.com>
References: <CAHge_00RZ7r8Np0F4PdH50hTsX-OrkXznKU2u+R9qD16=vx0_Q@mail.gmail.com> <219dcade-3d6b-b5ac-c11b-efb8dcd3bc63@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 21 Aug 2024, David Chu wrote:

> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> 
> 
> 
> 
> Hi Mikulas,
> 
> On Wed, 21 Aug 2024, Mikulas Patocka wrote:
> > 'D' - do nothing - dm-integrity doesn't do anything to try to maintain 
> > data/metadata integrity - if the system crashes, the metadata may be 
> > corrupted. It may be useful for things like operating system installation, 
> > where you don't recover from a crash at all.
> 
> Thanks for the quick and detailed response! I am actually *not interested
> in crashes*, but in what happens during a normal run, when there are two data
> writes to the same sector on disk. Let's say these writes are write A and
> write B, and we are running dm-integrity in 'D' mode (so there is no journal).
> 
> dm-integrity makes sure that if the writes' sector ranges intersect, then one
> write will not be sent to disk until the other returns, like so:
> 
>   Write A and B
>     | 
>     v
>   -----------------------------------------
>   | dm-integrity                          |
>   -----------------------------------------
>     |             ^                    |
>     v Write A     | Write A end_io     v Write B
>   -----------------------------------------
>   | disk                                  |
>   -----------------------------------------
> 
> dm-integrity then stores the hash of write B.
> 
> This behavior suggests to me that dm-integrity assumes that if write A returns
> before write B is sent to disk, then write A must be written to disk *before*
> write B (or maybe write A is never written, but in any case, write B is the
> final write). Otherwise, if the disk reorders write A and write B, then there
> would be a mismatch between the hash that dm-integrity stores and the actual
> write on disk.
> 
> Is this the assumption dm-integrity is making?
> And if so, how does it square with the hardware reordering I/O requests?
> 
> Thanks,
> David

Hi

There is a red-black-tree of all in-progress I/O (see ic->in_progress) and 
when we start an I/O, we add it to the tree with "add_new_range" and when 
we end an I/O, we delete it from the tree with "remove_range_unlocked".

The tree makes sure that there are no overlapping I/Os in progress.

Regarding disk-reordering - the disk may reorder I/Os, but if there is no 
crash, the disk must appear to be coherent. Therefore, if we write A, get 
A's endio and then write B, the disk must read B from this location, it 
can't read A.

The reordering only becomes a problem, if the system crashes (in that 
case, it is unknown if the disk will read A or B after a crash). I think 
that the SCSI standard even allows reading garbage after a crash.

Mikulas

