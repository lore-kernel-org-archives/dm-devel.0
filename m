Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0E4182B3
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 11:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716896279; cv=none; b=W9FZYg/IszyjEQM9/YAhvcRvlPyum5CAE/8qeyY64frvM+QTT1lOa0nkMJ8j0ILHr1/+Fzr5q7K+9ylSaIBHYcD7tBuHl3z6Uu26tlwIwTV+OPZNEcAwzG3cOzQsupp/HxYLJL8S1D/SOE0VcEavj2r/MzKQw4kJTbrBWpOXDX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716896279; c=relaxed/simple;
	bh=qsUEMsJeSS+IBw2BPZZTlJN3EV1oMrAZQyqKVRUbvtE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EUEiwWe4RimIlaneAYjeRxrJ4MbSFdtXxINrbcL8Bm3wpsuRsyIEzr354gRSd8pDooM4HpaF+twHyRBZgnxSIJ8sgR+P78UvUNiktJBKRfIUJ2mSjiHCXqB0vbThnHTB2CXQJG1jijzWUzysvSM4IbmCOiDfcdtwRdvgNOwWqHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X3sTGiUF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X3sTGiUF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716896276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cR2bt1k7HyvsTYH0cB1zhL4rvahDLosFkY2Z9XJBKj4=;
	b=X3sTGiUFnPw7+vDdJBC9k+J+0CRzYb23MgZCJrFnbXhDQuul2FiDHkFKAiW25AOMXL+Mbf
	8WSYF1X5vkdmRgoQLv+KMZEUFae3+xyP6SlU32z24WVe8D/1tCWFKATSBQYY2r8vxrZnC5
	b63A3JlazMfzyGAST20er3Gfy+VpZiE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-t2Ce_dVVNM-Zrr8EG9E22Q-1; Tue, 28 May 2024 07:37:54 -0400
X-MC-Unique: t2Ce_dVVNM-Zrr8EG9E22Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B007881227E;
	Tue, 28 May 2024 11:37:53 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E44710004FF;
	Tue, 28 May 2024 11:37:53 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 872D230C1C33; Tue, 28 May 2024 11:37:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 8623A43520;
	Tue, 28 May 2024 13:37:53 +0200 (CEST)
Date: Tue, 28 May 2024 13:37:53 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
cc: Benjamin Marzinski <bmarzins@redhat.com>, Yang Yang <yang.yang@vivo.com>, 
    Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm: optimize flushes
In-Reply-To: <Zk-EtZE4C7bndEYn@kernel.org>
Message-ID: <96148bb3-42e3-a5e2-63fb-ad7f67ba4fea@redhat.com>
References: <20240514090445.2847-1-yang.yang@vivo.com> <20240514090445.2847-4-yang.yang@vivo.com> <ZkTXzG1yrPmW64Z6@redhat.com> <60bd4b9-8edd-7e22-ce8b-e5d0e43da195@redhat.com> <90f4beb-2e15-3f9-4bc2-0d13872e8ea@redhat.com> <Zk4Y6DMgK71UuoKd@kernel.org>
 <44afd6c8-d36a-4b9d-e77f-fca269a9897b@redhat.com> <Zk-EtZE4C7bndEYn@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3



On Thu, 23 May 2024, Mike Snitzer wrote:

> On Thu, May 23, 2024 at 07:46:25PM +0200, Mikulas Patocka wrote:
> > Hi
> > 
> > Here I'm resending the patch, with more comments and explanations added.
> > 
> > Mikulas
> > 
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > Device mapper sends flush bios to all the targets and the targets send it
> > to the underlying device. That may be inefficient, for example if a table
> > contains 10 linear targets pointing to the same physical device, then
> > device mapper would send 10 flush bios to that device - despite the fact
> > that only one bio would be sufficient.
> > 
> > This commit optimizes the flush behavior. It introduces a per-target
> > variable flush_bypasses_map - it is set when the target supports flush
> > optimization - currently, the dm-linear and dm-stripe targets support it.
> > When all the targets in a table have flush_bypasses_map,
> > flush_bypasses_map on the table is set. __send_empty_flush tests if the
> > table has flush_bypasses_map - and if it has, no flush bios are sent to
> > the targets via the "map" method and the list dm_table->devices is
> > iterated and the flush bios are sent to each member of the list.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Suggested-by: Yang Yang <yang.yang@vivo.com>
> 
> Nicely done, please feel free to stage for 6.11 (create a new
> 'dm-6.11' branch starting from 'dm-6.10' -- we'll need to rebase
> dm-6.11 to 6.10-rc2 or so but at least we'll get this commit in the
> pipeline, push to 'for-next').
> 
> Reviewed-by: Mike Snitzer <snitzer@kernel.org>

OK, done.

Mikulas

