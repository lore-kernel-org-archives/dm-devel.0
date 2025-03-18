Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE11521128F
	for <dm-devel@lists.linux.dev>; Tue, 18 Mar 2025 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742311910; cv=none; b=i3bBpZ1NTW7R6YmVyHOl3pQiuCJYddtkdBDFfR+y7IiGWYkSORhnAVcidRY6CjQ/d/LK/h6IE2UxWTdHoZpaR/p9o1qJhgjy3U3t2w7ANUKejdGlCuDo3iJZP9Z3tYbI+MOIkKhPAEKdm66oRwE4VUeeiRXJeOmoWOlliM/LhJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742311910; c=relaxed/simple;
	bh=bdStWsgebDCDpXIsIcLRLtVwYMaHWOn2ybqeS5iTUm8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NPUNPjn7MAKTqfmf3lzNZq7agMBN7iv5GpcknUUrjAOK2jyduYConBTMubr0IRKJwal79hANmM2uolHcVWykYLifX3TRqwmGdP6z/qwYdaRhMaSm12RYtBwDMVs2pLwGrCxl9HG7bGYhVeXcqVD8TI4r5sOAus5zPHd6Y2IYWQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IgenXaFk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IgenXaFk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742311906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XYQ7FfKQroCOodU41rHpA8TgO41jqwfOEBAbfRTkj38=;
	b=IgenXaFkdttwUzlUMnnwI/SfdV9q6p5bQi2SkC1jvnQ9TMr+kE2dhEIKt9rbdvUXoHhD+r
	v5tvtypJ8UHn46HiP3n5y2yegl+ITUyxZ63PX/DeymH0OW5XS5IN3Bgvit1ol7Tviv5AWE
	ciOH03AUhAoAGaEe9C8iEiDJYijcQ2s=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-zItq7CKtOn66wc18qvLzHg-1; Tue,
 18 Mar 2025 11:31:43 -0400
X-MC-Unique: zItq7CKtOn66wc18qvLzHg-1
X-Mimecast-MFC-AGG-ID: zItq7CKtOn66wc18qvLzHg_1742311902
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38632180025E;
	Tue, 18 Mar 2025 15:31:42 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F2AD1956094;
	Tue, 18 Mar 2025 15:31:39 +0000 (UTC)
Date: Tue, 18 Mar 2025 16:31:35 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org, 
    dm-devel@lists.linux.dev
Subject: Re: [PATC] block: update queue limits atomically
In-Reply-To: <Z9mJmlhmZwnOlnqT@fedora>
Message-ID: <d5193df0-5944-8cf6-7eb6-26adf191269e@redhat.com>
References: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com> <Z9mJmlhmZwnOlnqT@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15



On Tue, 18 Mar 2025, Ming Lei wrote:

> On Tue, Mar 18, 2025 at 03:26:10PM +0100, Mikulas Patocka wrote:
> > The block limits may be read while they are being modified. The statement
> 
> It is supposed to not be so for IO path, that is why queue is usually down
> or frozen when updating limit.

The limits are read at some points when constructing a bio - for example 
bio_integrity_add_page, bvec_try_merge_hw_page, bio_integrity_map_user.

> For other cases, limit lock can be held for sync the read/write.
> 
> Or you have cases not covered by both queue freeze and limit lock?

For example, device mapper reads the limits of the underlying devices 
without holding any lock (dm_set_device_limits, __process_abnormal_io, 
__max_io_len). It also writes the limits in the I/O path - 
disable_discard, disable_write_zeroes - you couldn't easily lock it here 
because it happens in the interrupt contex.

I'm not sure how many other kernel subsystems do it and whether they could 
all be converted to locking.

> > "q->limits = *lim" is not really atomic. The compiler may turn it into
> > memcpy (clang does).
> > 
> > On x86-64, the kernel uses the "rep movsb" instruction for memcpy - it is
> > optimized on modern CPUs, but it is not atomic, it may be interrupted at
> > any byte boundary - and if it is interrupted, the readers may read
> > garbage.
> > 
> > On sparc64, there's an instruction that zeroes a cache line without
> > reading it from memory. The kernel memcpy implementation uses it (see
> > b3a04ed507bf) to avoid loading the destination buffer from memory. The
> > problem is that if we copy a block of data to q->limits and someone reads
> > it at the same time, the reader may read zeros.
> > 
> > This commit changes it to use WRITE_ONCE, so that individual words are
> > updated atomically.
> 
> It isn't necessary, for this particular problem, it is also fragile to
> provide atomic word update in this low level way, such as, what if
> sizeof(struct queue_limits) isn't 8byte aligned?

struct queue_limits contains two "unsigned long" fields, so it must be 
aligned on "unsigned long" boundary.

In order to make it future-proof, we could use __alignof__(struct 
queue_limits) to determine the size of the update step.

> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> 
> stable often requires bug description.

The bug is that you may read mangled numbers when reading the 
queue_limits.

Mikulas

