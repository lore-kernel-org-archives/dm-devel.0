Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA0C5676F
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 12:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716208961; cv=none; b=euy1LBYqUh6mupMKosoiH1yzRRQ7LzckjnsmpBWh9qcxSss4GxUwoeAEtDIQJ1HMLp3ar+JINjEA5SwV5N1hSPZDenxgxAi0nUOlDe3WRPXVRFTPu2PhYO62PmaLZZE5OACtDW3cwuJRh4Hu7h3fogaok5vUyT4LMDwcT/f7a9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716208961; c=relaxed/simple;
	bh=j7U10x2oeLMecco+ospsBUrm0P44Rah0zMqQbFzvLkc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ientkc7k7WFJIeHd+ruCiz+hKt6ofQ5Kjhg1q2JvDqpEISnsnk4nc0FsLI0uujOqzbazP4iY9KYG5Hie+OAUcQPN5f4Qz7vFw6U/mMKDdVEIPhGk9lA9zHFA/sgNKJqsEDSHjoksOovs5DuV1hF8F66NUvR/0s6qoL6GbGnTKgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S9EGXVEU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S9EGXVEU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716208958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KayalCaS7smIGY4laqLaOBcC9nq15KQ+MkKdhfonP0g=;
	b=S9EGXVEUEXUvfGWXk0Kf3j+E0sgNcuxGonfATxy1rlipyarbjid2gdnHIF7MWFJ8XBOXJC
	nf23/EYsCkMf4+8HZuVXBF5FhJKGv7uJ6K9Ub/3BlARN2JRw13lxvWMk2M8jSWwQ3IQ1+u
	VKmbbU9c+ar23dwdyXhmLRmSUcKFF6U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-f8n_q1rxP1O14wxe5g2e2g-1; Mon, 20 May 2024 08:42:35 -0400
X-MC-Unique: f8n_q1rxP1O14wxe5g2e2g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACC318008A4;
	Mon, 20 May 2024 12:42:34 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29C9040004D;
	Mon, 20 May 2024 12:42:34 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 15A8C30C1C33; Mon, 20 May 2024 12:42:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 14B923FB52;
	Mon, 20 May 2024 14:42:34 +0200 (CEST)
Date: Mon, 20 May 2024 14:42:34 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
    Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
    Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>, 
    linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
    linux-nvme@lists.infradead.org
Subject: Re: [RFC PATCH 1/2] block: change rq_integrity_vec to respect the
 iterator
In-Reply-To: <ZkXAfmbtXzKGaouC@fedora>
Message-ID: <b9eb6587-3128-df7c-9b71-51e8b7d90fb@redhat.com>
References: <f85e3824-5545-f541-c96d-4352585288a@redhat.com> <c366231-e146-5a2b-1d8a-5936fb2047ca@redhat.com> <ZkXAfmbtXzKGaouC@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10



On Thu, 16 May 2024, Ming Lei wrote:

> On Wed, May 15, 2024 at 03:28:11PM +0200, Mikulas Patocka wrote:
> > If we allocate a bio that is larger than NVMe maximum request size, attach
> > integrity metadata to it and send it to the NVMe subsystem, the integrity
> > metadata will be corrupted.
> > 
> > Splitting the bio works correctly. The function bio_split will clone the
> > bio, trim the iterator of the first bio and advance the iterator of the
> > second bio.
> > 
> > However, the function rq_integrity_vec has a bug - it returns the first
> > vector of the bio's metadata and completely disregards the metadata
> > iterator that was advanced when the bio was split. Thus, the second bio
> > uses the same metadata as the first bio and this leads to metadata
> > corruption.
> 
> Wrt. NVMe, inside blk_mq_submit_bio(), bio_integrity_prep() is called after
> bio is split, ->bi_integrity is actually allocated for every split bio, so I
> am not sure if the issue is related with bio splitting. Or is it related
> with DM over NVMe?

I created a dm-crypt patch that stores autenticated data in the bio 
integrity field: 
https://patchwork.kernel.org/project/linux-block/patch/703ffbcf-2fa8-56aa-2219-10254af26ba5@redhat.com/

And that patch needs this bugfix.

Mikulas

> However, rq_integrity_vec() may not work correctly in case of bio merge.
> 
> 
> Thanks, 
> Ming
> 

