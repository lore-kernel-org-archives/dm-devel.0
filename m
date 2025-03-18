Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECF6209F27
	for <dm-devel@lists.linux.dev>; Tue, 18 Mar 2025 14:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742309805; cv=none; b=utnsqqweZQpcqKfG47YjKroyKhz2FvnnIFicfAyZ8RNt2wGYl94goOFHdi5dQoNA/gXTyT2SOiVhRJC/X7EokCh6DXKTD66/baRsgu0GvbMqwjvEskzZnuAk3e2CnQYkewgDxUoqQif7jD9OeQ9sDn9Pz/pRIK95rl+IP0ux+I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742309805; c=relaxed/simple;
	bh=sOWU4p5DHg6Fbzp83qLQPUObyHXWU9PThVQOyUyc3dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLv/4qVLqgZa1ma2oxrUHb5sB7aax5tb5OlEwRx3wY7O4AlvcV+fjmKBKP7vZjmwq9tnpwWGbytniYr/A9zYGWBb4JwXfk9nrSNKiLqJpQ6h3VkCbf0vCPMZxoi/I5AXsxRhKI+YSgYz80onEQ+I73/z2nyIMlTsGusGqcTYw1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jOjhbYYK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jOjhbYYK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742309802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MWVVX2LSuZdqO8+74bvGsn6twEgJqbAt+G3ZbT6EyXs=;
	b=jOjhbYYK83cQDKHI/OJ9kx54l6DlgMDFl86EQg6dJ0y3EFEscGsB4JiXXrKdRkGbtQvcVw
	k2nDkcildTPlpQVJBrutHJLRnKU4PNPKdm5PFO2ToOFKEYl/EIerGvAmphjmQ58nJ+7SP3
	+NPaqgC6K2miXtmUAFvhv1ZMMUKFhcg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-421-kOwqq8oROkafdOWZKCNzyg-1; Tue,
 18 Mar 2025 10:56:38 -0400
X-MC-Unique: kOwqq8oROkafdOWZKCNzyg-1
X-Mimecast-MFC-AGG-ID: kOwqq8oROkafdOWZKCNzyg_1742309797
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3889D1955DCF;
	Tue, 18 Mar 2025 14:56:37 +0000 (UTC)
Received: from fedora (unknown [10.72.120.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2BA4D1800268;
	Tue, 18 Mar 2025 14:56:31 +0000 (UTC)
Date: Tue, 18 Mar 2025 22:56:26 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATC] block: update queue limits atomically
Message-ID: <Z9mJmlhmZwnOlnqT@fedora>
References: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Tue, Mar 18, 2025 at 03:26:10PM +0100, Mikulas Patocka wrote:
> The block limits may be read while they are being modified. The statement

It is supposed to not be so for IO path, that is why queue is usually down
or frozen when updating limit.

For other cases, limit lock can be held for sync the read/write.

Or you have cases not covered by both queue freeze and limit lock?

> "q->limits = *lim" is not really atomic. The compiler may turn it into
> memcpy (clang does).
> 
> On x86-64, the kernel uses the "rep movsb" instruction for memcpy - it is
> optimized on modern CPUs, but it is not atomic, it may be interrupted at
> any byte boundary - and if it is interrupted, the readers may read
> garbage.
> 
> On sparc64, there's an instruction that zeroes a cache line without
> reading it from memory. The kernel memcpy implementation uses it (see
> b3a04ed507bf) to avoid loading the destination buffer from memory. The
> problem is that if we copy a block of data to q->limits and someone reads
> it at the same time, the reader may read zeros.
> 
> This commit changes it to use WRITE_ONCE, so that individual words are
> updated atomically.

It isn't necessary, for this particular problem, it is also fragile to
provide atomic word update in this low level way, such as, what if
sizeof(struct queue_limits) isn't 8byte aligned?

> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org

stable often requires bug description.



Thanks,
Ming

