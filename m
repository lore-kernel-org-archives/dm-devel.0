Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275D247772
	for <dm-devel@lists.linux.dev>; Tue, 23 Apr 2024 07:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713857545; cv=none; b=AAxcKvqLvvjWkgs3H0aux7VD8noaiIfo71+DZroeiF0DCwclao2sDOxKcQDfwd7dtOyVTgr0pQNrIbQck5EsImZAJLveeOegocYwirGo+jkC52IwbtFfsAQEvJR/COH7lItJDFDvdc0FEafUSAkLcu2HIWtmyHaoNeOyLx/eu7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713857545; c=relaxed/simple;
	bh=fCtgTqqPIGgKR7CtOKrHPlxAEAm3QiX1Kyq3VvKxjHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a0qoWuTIFYfSLtGYie5V4Ff21FiLVwbPuQOl0ZmBkDefWJ8rm0z6HIigErsGn2yjI/RBtiWA9ySuxGx7E5Gf5lmg6Fv3vxAB6OXYPT/uUNt3A+YaJUr1oT8e8hYWXHT/jeiqVBWOJv9+P7God2u0d/ipCC3u1yjn9sFVZDHNE7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gz9zbe0X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gz9zbe0X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713857543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+l4LrlxVKztyl389Cf9Ye2PtVJ+Dx3CAmwyRxf4t95E=;
	b=Gz9zbe0XybnbkAocZOPwvwIIMZZR/7lGfh3Ilpf+TwnK5kYabIS44Kjn53h7xRu1SsdvWL
	+JoXhEG08TGMRxy1QIt/fg4q/BEpsdW4IZVHZ9Iep2xIho/HRtM8rgHgLbyC/IKRnhM65l
	bbwM82oHQEL8UnMMSJ9aw9vLWjCPY/4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-57-XPyiARAZPVCA_2h0Qmy82g-1; Tue,
 23 Apr 2024 03:32:20 -0400
X-MC-Unique: XPyiARAZPVCA_2h0Qmy82g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58B5E1C05122;
	Tue, 23 Apr 2024 07:32:20 +0000 (UTC)
Received: from fedora (unknown [10.72.116.86])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AB0320128F3;
	Tue, 23 Apr 2024 07:32:15 +0000 (UTC)
Date: Tue, 23 Apr 2024 15:32:12 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: hch@lst.de, axboe@kernel.dk, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Brandon Smith <freedom@reardencode.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH for-6.10 1/2] dm-crypt: stop constraining
 max_segment_size to PAGE_SIZE
Message-ID: <Zidj46jf/9USES3L@fedora>
References: <ZfDeMn6V8WzRUws3@infradead.org>
 <20240411201529.44846-2-snitzer@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240411201529.44846-2-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Thu, Apr 11, 2024 at 04:15:28PM -0400, Mike Snitzer wrote:
> This change effectively reverts commit 586b286b110e ("dm crypt:
> constrain crypt device's max_segment_size to PAGE_SIZE") and relies on
> block core's late bio-splitting to ensure that dm-crypt's encryption
> bios are split accordingly if they exceed the underlying device's
> limits (e.g. max_segment_size).
> 
> Commit 586b286b110e was applied as a 4.3 fix for the benefit of
> stable@ kernels 4.0+ just after block core's late bio-splitting was
> introduced in 4.3 with commit 54efd50bfd873 ("block: make
> generic_make_request handle arbitrarily sized bios"). Given block
> core's late bio-splitting it is past time that dm-crypt make use of
> it.
> 
> Also, given the recent need to revert meaningful progress that was
> attempted during the 6.9 merge window (see commit bff4b74625fe Revert
> "dm: use queue_limits_set") this change allows DM core to safely make
> use of queue_limits_set() without risk of breaking dm-crypt on NVMe.
> Though it should be noted this commit isn't a prereq for reinstating
> DM core's use of queue_limits_set() because blk_validate_limits() was
> made less strict with commit b561ea56a264 ("block: allow device to
> have both virt_boundary_mask and max segment size").
> 
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

