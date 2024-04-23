Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7F946B9F
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 07:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713857615; cv=none; b=EpMpvUzAUF8jLtGJF3T5x27cafuCSamrUeG8JshEPYNSdadkwou6VnAOEvMDXoKEcC1Us87RrGUx4xMKCeBQl/JYFjB7WLYrp+WzyhwvRvDA0W0gMDgd16uGUvwyEqkCsXzoy3MitZDdHn4WyNtHxPpcyrGeMp78wFBDTG4h/fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713857615; c=relaxed/simple;
	bh=ZHnCPeqdPUQly0lxBYGQEkgOECoxe0TxnkSGQ7PfH1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxaY6kbMW90o13EBOwCnuqnV4b7GmwKfAAED+dz9pzTcIJaKbtaLEwURyfgnBevihPRk87fcHUhCUUTi0yb8v8PzDgm3W6FY/2qMGdekH6QeZ2trcWO/M3tA1G6u0g/tuOZCStI7HAdGmmU6/accdlztOX32AsEgIirUPiBBo2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MS7daSUx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MS7daSUx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713857612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AmeBZHC9gBkDWmo2C+/hRjiKWn2fxewQj8GCeMPq2pk=;
	b=MS7daSUxJoxcPGEoS8mkaqmIJG4/YbcgemwgwsPcVXmTSvYMjAyiwUdxa5Het8K1RXXTr+
	TpMXfvPwtKHEOV8hwArMpFFTlBjDTvsjPatya0TPSmGOV19UfbgeW34rcqbVN+g1R8lQGQ
	JFw+9z0rdnPxsuPqyK0J24m12qG0Mhw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-GhZAK3_6P_uFKk9nXquSmQ-1; Tue, 23 Apr 2024 03:33:30 -0400
X-MC-Unique: GhZAK3_6P_uFKk9nXquSmQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FF6E18065B3;
	Tue, 23 Apr 2024 07:33:29 +0000 (UTC)
Received: from fedora (unknown [10.72.116.86])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 110AEC13FA4;
	Tue, 23 Apr 2024 07:33:24 +0000 (UTC)
Date: Tue, 23 Apr 2024 15:33:21 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: hch@lst.de, axboe@kernel.dk, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Brandon Smith <freedom@reardencode.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH for-6.10 2/2] dm: use queue_limits_set
Message-ID: <ZidkL77UX/cK3ZXE@fedora>
References: <ZfDeMn6V8WzRUws3@infradead.org>
 <20240411201529.44846-3-snitzer@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411201529.44846-3-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Thu, Apr 11, 2024 at 04:15:29PM -0400, Mike Snitzer wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Use queue_limits_set which validates the limits and takes care of
> updating the readahead settings instead of directly assigning them to
> the queue.  For that make sure all limits are actually updated before
> the assignment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

