Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3598A21106
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 12:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716209617; cv=none; b=JVE7oaCE+Ws0CEgIbOOJnfEC0f76wWMznFFrh2me/5iZYX8nUh0U5uAx7QcaG0t+cyAxD1P8TB1RTS9fPMD/BtCqvoHpM3GgzODtjs+vPkUA05SJc/FT2Wi90lvcLFdr5ly1WOMGnDhDRS11qLyZ0GO6GXxkxjCIZo8FKHsnzcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716209617; c=relaxed/simple;
	bh=CJhRuhs5GtwlV0eA7g1xplKsTD1O11Fi2n1IupK32Cg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WHzfT4yRKhQd4J5ECZNvbAu9Vt4CdgLcCm5ZIPMUZWlKGerWLCDP/jsc2S97n2S3mi7HRSH8ClSJdhnWwwXa+134DTXblO7WC/lnP/xYUQqQf1jcDTjasH9mEiL9vxjcf0cf1UfPQg9cZINzn24PC9A7F0b3C6U4Es3IgMRePYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DJz3XyNw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJz3XyNw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716209615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=guKnOQaYcck3gIy9ZWMzFJIBFpiFj2ii6L3g585Cg7Y=;
	b=DJz3XyNwJmyXdnW376kjZfoQJVCI5T7u33XFXjqkGkV2vhaKC7WgD4AD/EkdfwXSykvRo0
	+q2vcs+RyFHcUUkgbkT+4hLdSHEJZstKOc3a4J5C/03CSj6tTwolXEKul33brWgg2KMUD3
	iBz0c6Ucx2k6BdZfXKXSUuQXr4Z5fiE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-GaszafM6P0WzLQz6Ql74_g-1; Mon, 20 May 2024 08:53:26 -0400
X-MC-Unique: GaszafM6P0WzLQz6Ql74_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A4898008A4;
	Mon, 20 May 2024 12:53:26 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 412C2200A35C;
	Mon, 20 May 2024 12:53:26 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 27DF630C1C33; Mon, 20 May 2024 12:53:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 24F9C3FB52;
	Mon, 20 May 2024 14:53:26 +0200 (CEST)
Date: Mon, 20 May 2024 14:53:26 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
cc: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@kernel.org>, 
    Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org, 
    dm-devel@lists.linux.dev, linux-nvme@lists.infradead.org
Subject: Re: [RFC PATCH 1/2] block: change rq_integrity_vec to respect the
 iterator
In-Reply-To: <8522af2f-fb97-4d0b-9e38-868c572da18a@kernel.dk>
Message-ID: <e9df49b3-f113-342-f1f-96ecce46c357@redhat.com>
References: <f85e3824-5545-f541-c96d-4352585288a@redhat.com> <c366231-e146-5a2b-1d8a-5936fb2047ca@redhat.com> <8522af2f-fb97-4d0b-9e38-868c572da18a@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6



On Wed, 15 May 2024, Jens Axboe wrote:

> On 5/15/24 7:28 AM, Mikulas Patocka wrote:
> > @@ -177,9 +177,9 @@ static inline int blk_integrity_rq(struc
> >  	return 0;
> >  }
> >  
> > -static inline struct bio_vec *rq_integrity_vec(struct request *rq)
> > +static inline struct bio_vec rq_integrity_vec(struct request *rq)
> >  {
> > -	return NULL;
> > +	BUG();
> >  }
> >  #endif /* CONFIG_BLK_DEV_INTEGRITY */
> >  #endif /* _LINUX_BLK_INTEGRITY_H */
> 
> Let's please not do that. If it's not used outside of
> CONFIG_BLK_DEV_INTEGRITY, it should just go away.
> 
> -- 
> Jens Axboe

It can't go away - it is guarded with blk_integrity_rq (which always 
returns 0 if compiled without CONFIG_BLK_DEV_INTEGRITY), so the compiler 
will optimize-out the calls to rq_integrity_vec. But we can't delete 
rq_integrity_vec, because the source code references it.

Should rq_integrity_vec return empty 'struct bio_vec' instead? Or should 
we add more CONFIG_BLK_DEV_INTEGRITY tests to disable the call locations?

Mikulas

