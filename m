Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C9222EF5
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 10:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711102593; cv=none; b=kmPnIyiEjrGi4ZuxYaquk8cBALD+8bDtRpxnS9nf+xvYzMpJAR4I60Km701RTFjNgfcW9dMyAUyfu0OTjitM3et1G3Y8G16N0ILInZeiKwrJiInsZv3lO20D3kg3PlKf06Q9kL4SWhfIJ+/c4bfMYMufnlDMDim7Iek+tuIYGZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711102593; c=relaxed/simple;
	bh=rmZLHL12c58LxK8RmzCpoTEEZ6vgU2KklkmgV3DS7Q0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CNMf4OCFkwvfQRaPQdPQlUC9HE90BsOPHkMUqMzheKJztEigxAIV5gtpP3ZkuLQYuPI1norZbscsoi7+TefF4NNxMQl/Gt0XWoRV52JNxKFl594Nd9LD4RtuOdSp+gygQ96AI7c5dvkZI/hGSsuQgKFjFq9OLHW1dek18zX5cgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZgALwcym; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZgALwcym"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711102590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O0JUJuOfMh8CnijpLAcgbKqt0zNMKFJUJdCktWh8VBk=;
	b=ZgALwcymQINtx43Td3fYuMuQBhRMA7VfL+11b1AZBKWez/nYgiCTbcPvFMxm6YVqKzO7Tc
	JIRbYG4nnQUFCiW3N/SrcoAdlK8oA5U2rBkvphK1EwMMVwXixSSX5YbGkJJyjS7ZMCjUz0
	kgfACAzTKcV6AaYBzq/xl4c2wmdfDX4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-398-al3aDdPLMcujfZvRRN5lMA-1; Fri,
 22 Mar 2024 06:16:28 -0400
X-MC-Unique: al3aDdPLMcujfZvRRN5lMA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33E241C02CA0;
	Fri, 22 Mar 2024 10:16:28 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5963C492BC6;
	Fri, 22 Mar 2024 10:16:27 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 3065730BFECA; Fri, 22 Mar 2024 10:16:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 2EB313FB4B;
	Fri, 22 Mar 2024 11:16:27 +0100 (CET)
Date: Fri, 22 Mar 2024 11:16:27 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
cc: Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
    linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: block: fail unaligned bio from submit_bio_noacct()
In-Reply-To: <ZfzoC/V07nExJ+0x@fedora>
Message-ID: <dd4e8b49-aa76-4b1b-3827-6650cb525226@redhat.com>
References: <20240321131634.1009972-1-ming.lei@redhat.com> <ZfxVqkniO-6jFFH5@redhat.com> <ea8a13c-ee40-47f9-a7be-17b84bd1f686@redhat.com> <ZfzoC/V07nExJ+0x@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9



On Fri, 22 Mar 2024, Ming Lei wrote:

> On Thu, Mar 21, 2024 at 06:01:41PM +0100, Mikulas Patocka wrote:
> > 
> > 
> > > > +static bool bio_check_alignment(struct bio *bio, struct request_queue *q)
> > > > +{
> > > > +	unsigned int bs = q->limits.logical_block_size;
> > > > +	unsigned int size = bio->bi_iter.bi_size;
> > > > +
> > > > +	if (size & (bs - 1))
> > > > +		return false;
> > > > +
> > > > +	if (size && ((bio->bi_iter.bi_sector << SECTOR_SHIFT) & (bs - 1)))
> > > > +		return false;
> > > > +
> > > > +	return true;
> > > > +}
> > 
> > I would change it to
> > 
> > if (unlikely(((bi_iter.bi_sector | bio_sectors(bio)) & ((queue_logical_block_size(q) >> 9) - 1)) != 0))
> > 	return false;
> 
> What if bio->bi_iter.bi_size isn't aligned with 512? The above check
> can't find that at all.

Could it happen that bi_size is not aligned to 512? I haven't seen such a 
bio yet. If you have seen it, say where was it created.

Mikulas

