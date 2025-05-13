Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E59A11712
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 09:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747128560; cv=none; b=da5jmTyDnKdNS76Tz0KE4KGhvE3aG8MtjkvWR7U6pWIyZSzPGp2LhUZ+jlhtTETXLkXtBNKCWuc0pePspTk2IWVnnUx7p4P5jJfKGZqW2VK9ztv4MFUnvs/wBlphxr4aI4FDq/r0fprWFyWBPtYzC2BG0q9Eb/wz4DZJz5GOsnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747128560; c=relaxed/simple;
	bh=8O7CUj/TgXcdonn9vBDT5qTqdIn+fJHSMgChw4LhMjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbwEV/7sHA0oGobKqFpwQtCVkqp/AWK2S/hkRok0FjAXtsjKQZG24clQQNEhsAFqTS4ZuXGr3VN+A0sZH6/mbnzj7wQ5hq0oXBiLVlrcDnUc49X3QMtncYICxSjuwR+EknQhsU1OG8qq/lfKOtig8IwPC2ZaDmNHL6097MvYLiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GrJRbHKU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GrJRbHKU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747128558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=93t4tFkIyPCogX7UwUqjdNFHzcw9/x4QgZzmXcOPlSo=;
	b=GrJRbHKU1oO/aD8byXRE0G+QePoOuJvNAy41Tq92ZRUVEYgBMtn65aHZ52aaihvZRrHXjd
	qm75rIZcHfJO2VdGpiHvR+xBcU68Ul2zQvuYZrSAQMmiLSFKUlAGPdI3o4SQg0eb6dNdbh
	tvJJ/AB2SouUhTEHriebwA1QGuaIuIE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-280-D5izl036PjW_6LLqymc3TA-1; Tue,
 13 May 2025 05:29:17 -0400
X-MC-Unique: D5izl036PjW_6LLqymc3TA-1
X-Mimecast-MFC-AGG-ID: D5izl036PjW_6LLqymc3TA_1747128555
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F5F51955DB2;
	Tue, 13 May 2025 09:29:15 +0000 (UTC)
Received: from redhat.com (unknown [10.45.224.238])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E8BD1953B82;
	Tue, 13 May 2025 09:29:12 +0000 (UTC)
Date: Tue, 13 May 2025 11:29:09 +0200
From: Kevin Wolf <kwolf@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev,
	hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
	bmarzins@redhat.com, linux-kernel@vger.kernel.org,
	pbonzini@redhat.com
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCMQ5S-gI6vZJxmq@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <aCLe5UT2kfzI96TQ@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCLe5UT2kfzI96TQ@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Am 13.05.2025 um 07:55 hat Christoph Hellwig geschrieben:
> On Mon, May 12, 2025 at 05:18:43PM +0200, Kevin Wolf wrote:
> > Yes, it's a bit unfortunate, but we have to work with what we have. QEMU
> > doesn't even necessarily know that it's dealing with a multipath device,
> > so it just has to blindly try the ioctl and see if it works.
> 
> Why is qemu even using SG_IO to start with?

How else would you do SCSI passthrough?

Ok, from your replies to Hannes I understand an implicit message, you
wouldn't. But I don't think that's really an answer, at least not for
all users.

Yes, I'll give you that in the long term, we might be able to move some
passthrough users away from it by using more specific interfaces like
for persistent reservations (though see below). But for example, it's
also used for vendor-specific commands and I don't see how Linux could
ever provide more specific interfaces than SG_IO for those.

But it's even about more than just accessing commands that aren't
otherwise accessible. Mapping a SCSI response from the device to a
single errno and back into SCSI status for the guest isn't lossless.
QEMU's scsi-block device actually started off using normal I/O for reads
and writes and using SG_IO only for things that aren't covered by normal
I/O. But then those had to be changed to SG_IO, too, so that the guest
would actually see the full SCSI status. Things the commit message
mentions are unit attention codes and handling RESERVATION CONFLICT
correctly (which made me unsure above if the more specific interface for
reservations could actually be used to fully get rid of SG_IO). For more
context, I'm adding Paolo who actually made that change back then. He
may remember the concrete bug(s) this fixed.

So if you want the guest device to behave mostly the same as your host
device, I don't really see any way around SCSI passthrough and therefore
SG_IO.

Kevin

