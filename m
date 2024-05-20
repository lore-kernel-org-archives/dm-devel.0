Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F92F53805
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 13:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716211176; cv=none; b=QDjk44/NIjC/tneJM8IARYJ2QfMz207UQDLLJ8ZWYvVw/KZxncto5QaXmK8Od/t9aJGCVuWUjNL/cKQwBE7sJufnN5fWugEKAmiK9S8QLrHWkKAtUrIzcKz4X7kb1tm6ItIyrGLr5y9Ozuyj5ZMEbnHfF3GxCNi9DiaEMt7gnKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716211176; c=relaxed/simple;
	bh=2QMmuMrciHQWJLts1mGh4C5Y+CT2jMCU4k+2l54C12g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lBExxk1bCEokGglhgjq0KWz4a2hoBguqQPko57Bfyca009bUR6xWNITHny7VMqxYiW+Mva/s/SECuleRNySVmEesE54yHYo2nSokXYZtN56Jve5uloZqx8CdBIpnjK4TLjFzTEM5/O4XYhOkxY2v1OoQ1+N9MDQTzKt46DtAzXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q8GD81yH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q8GD81yH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716211173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NJvccikn3cC/SXliMlXLkryPDpnegWTBDtxtNOZEy08=;
	b=Q8GD81yHsH+QXBGT+2dwQEbEKmrw+rjJsztAJUGXCYUxv3WJT+sTomvof+iAAk+qMly2EG
	qecCvEmR+mNQcqWc7nKWoaZFLE85of5v31FkDxve3VsX2yBkhEgpQZV/lf0SbdQaUom6Sm
	SyyQLqG/hCzEtr3K1kqhdWW8JEvxGeU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-UveBbGUyPYmKRU346TlDDA-1; Mon, 20 May 2024 09:19:29 -0400
X-MC-Unique: UveBbGUyPYmKRU346TlDDA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 286A3812296;
	Mon, 20 May 2024 13:19:29 +0000 (UTC)
Received: from fedora (unknown [10.72.116.130])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A5CB01C09480;
	Mon, 20 May 2024 13:19:23 +0000 (UTC)
Date: Mon, 20 May 2024 21:19:19 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org, ming.lei@redhat.com
Subject: Re: [RFC PATCH 1/2] block: change rq_integrity_vec to respect the
 iterator
Message-ID: <ZktN1zQ1dBnjjVQA@fedora>
References: <f85e3824-5545-f541-c96d-4352585288a@redhat.com>
 <c366231-e146-5a2b-1d8a-5936fb2047ca@redhat.com>
 <ZkXAfmbtXzKGaouC@fedora>
 <b9eb6587-3128-df7c-9b71-51e8b7d90fb@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9eb6587-3128-df7c-9b71-51e8b7d90fb@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Mon, May 20, 2024 at 02:42:34PM +0200, Mikulas Patocka wrote:
> 
> 
> On Thu, 16 May 2024, Ming Lei wrote:
> 
> > On Wed, May 15, 2024 at 03:28:11PM +0200, Mikulas Patocka wrote:
> > > If we allocate a bio that is larger than NVMe maximum request size, attach
> > > integrity metadata to it and send it to the NVMe subsystem, the integrity
> > > metadata will be corrupted.
> > > 
> > > Splitting the bio works correctly. The function bio_split will clone the
> > > bio, trim the iterator of the first bio and advance the iterator of the
> > > second bio.
> > > 
> > > However, the function rq_integrity_vec has a bug - it returns the first
> > > vector of the bio's metadata and completely disregards the metadata
> > > iterator that was advanced when the bio was split. Thus, the second bio
> > > uses the same metadata as the first bio and this leads to metadata
> > > corruption.
> > 
> > Wrt. NVMe, inside blk_mq_submit_bio(), bio_integrity_prep() is called after
> > bio is split, ->bi_integrity is actually allocated for every split bio, so I
> > am not sure if the issue is related with bio splitting. Or is it related
> > with DM over NVMe?
> 
> I created a dm-crypt patch that stores autenticated data in the bio 
> integrity field: 
> https://patchwork.kernel.org/project/linux-block/patch/703ffbcf-2fa8-56aa-2219-10254af26ba5@redhat.com/
> 
> And that patch needs this bugfix.

OK, then please update commit log with dm-crypt use case, given there
isn't such issue on plain nvme.

BTW, bio won't be merged in case of plain NVMe since there is gap
between two nvme bio's meta buffer, both are allocated from kmalloc().

However, is it possible for the split bios from dm-crypt to be merged
in blk-mq code because dm-crypt may have its own queue limit? If yes, I
guess this patch may not be enough. Otherwise, I think this path is
good.



Thanks,
Ming

