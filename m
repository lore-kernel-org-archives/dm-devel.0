Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DFE31A89
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 23:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711669835; cv=none; b=K3PITzGP/78kj3INh1QRwjI2dVdu2btBFNt6GLDllT3abSSznIcPwSWAs/nQgnZG6z1urE6nx52dy4lIEfMfE2OFQyvHniemnGdbpB18jycqiAsl7GyNU4A4fxnBzZYQqqsFLJGStMQlIBfLyQKwuaq6LQVnPP1gTzBypwDN0us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711669835; c=relaxed/simple;
	bh=rnAgD8QyYSqlHtwiyhdPnjbT9pkWQMe2yKGBxL3Qi4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4+Q7rY39nV/NIxargth2heFg/ag6UcIm29MiPEKmRok9YgwcFd3nuRzM2473zeAKpryQV7I9cQniI6tEFU/TCVl6s6EbDNyM62f52WA/OrOcRsYL+go7aW/o1LkH4n1dIjczmfH5uq1J4JyqCjGXMhLZce1WdTmm9H0iW/AUwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XkMVC28I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XkMVC28I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711669832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Vn/NzwmdIpWsn5nWXict56VBOKf11qYNjS4a8/2VBk=;
	b=XkMVC28I8hvg5zVt2nU9qe5wzlYlbUxKb9vshDRDc0NuDsFL3VbhSFZxdEouAaHuxQXfCA
	Fo4ptksDE4AXRCCLCJVoEZ6l5fMjt4KHJC38txU6kIF3jRrYmaiiLORBq2onE7wmjwxYMM
	UsrOGQwwpWL09dlQveH/vetFgVuFDmo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-0Y4hxj8HM0-5DFISrRGQsg-1; Thu, 28 Mar 2024 19:50:30 -0400
X-MC-Unique: 0Y4hxj8HM0-5DFISrRGQsg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0FE9101A523;
	Thu, 28 Mar 2024 23:50:29 +0000 (UTC)
Received: from redhat.com (unknown [10.2.16.33])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45A5C200A384;
	Thu, 28 Mar 2024 23:50:27 +0000 (UTC)
Date: Thu, 28 Mar 2024 18:50:21 -0500
From: Eric Blake <eblake@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	David Teigland <teigland@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@lst.de>, Joe Thornber <ejt@redhat.com>
Subject: Re: [RFC 1/9] block: add llseek(SEEK_HOLE/SEEK_DATA) support
Message-ID: <pmwdm323zz7p6adwooc4stxkpimhtte2whtbfyhh6c34brol7z@3jrb42y74y7y>
References: <20240328203910.2370087-1-stefanha@redhat.com>
 <20240328203910.2370087-2-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328203910.2370087-2-stefanha@redhat.com>
User-Agent: NeoMutt/20240201
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Thu, Mar 28, 2024 at 04:39:02PM -0400, Stefan Hajnoczi wrote:
> The SEEK_HOLE/SEEK_DATA interface is used by userspace applications to
> detect sparseness. This makes copying and backup applications faster and
> reduces space consumption because only ranges that do not contain data
> can be skipped.

s/only //

> 
> Handle SEEK_HOLE/SEEK_DATA for block devices. No block drivers implement
> the new callback yet so the entire block device will appear to contain
> data. Later patches will add support to drivers so this actually becomes
> useful.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  include/linux/blkdev.h |  7 +++++++
>  block/fops.c           | 43 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 49 insertions(+), 1 deletion(-)
> 

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.
Virtualization:  qemu.org | libguestfs.org

