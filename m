Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08B6154BF8
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 11:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716894973; cv=none; b=kc9Uoskh50v4/0W9liqvnclQYZWG2OK0yvJcdNq30zIZE07r20gunvQ6/Qe74wPUMGXWZEsHJETxon+nasdtzz7rhgL3QvpXIgZ2pc7sdEXbHWbCDYplEEoFEpL65i/Hyd7rBZRpGWbpnai7OHe+NJDnx08jfHO2uZ0ASMmvavo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716894973; c=relaxed/simple;
	bh=dJzxH+C+YgA2K6Qr0KSXq7M+QtKSoJ8jXdM+a0oASB0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aWW7VGd7v597yTiyga/h9ZiPWtNtQfC5HPqh4LrvSDOJMMbeC3BaMrnhfFu1Tc/+EYajzkBl0OwTLhZXLAVfjl3HeqdmrVxa4EsVUSrlmztD78JmQF5ydPYsUWrOhBXP1YSzysW+gBHrl6UN5PkywQb6mqx3OR6pT6I1MBRKWh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BEuzNZwR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BEuzNZwR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716894970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rYg0TTRzA8O3sBmCaNFcaodzlZZszlkh1V5SLXZSiEs=;
	b=BEuzNZwRj18EBpGIHgBYA6+2HADA9lRZRh9JG+bDRegf8dmFiHAbAY9g7Of57tYclfBXoA
	12ugeBvUwTyH0XjmDdlx1PTJWCciTkqc6bcYSjDcNc1qjOoNw50Wp+6lFpUSuxlArzkPbb
	pC4LcIPXjGXOeybiHTFV/yPgS6HSH+8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-487-iVtCDwhVNzKupBwSEjm7lg-1; Tue,
 28 May 2024 07:16:06 -0400
X-MC-Unique: iVtCDwhVNzKupBwSEjm7lg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 486FC1C05131;
	Tue, 28 May 2024 11:16:06 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8603400059;
	Tue, 28 May 2024 11:16:05 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 9094030C1C33; Tue, 28 May 2024 11:16:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 8C6013C542;
	Tue, 28 May 2024 13:16:05 +0200 (CEST)
Date: Tue, 28 May 2024 13:16:05 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, 
    Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
    Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>, 
    linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
    linux-nvme@lists.infradead.org
Subject: Re: [RFC PATCH 0/2] dm-crypt support for per-sector NVMe metadata
In-Reply-To: <206cd9fc-7dd0-f633-f6a9-9a2bd348a48e@ewheeler.net>
Message-ID: <971e4bbc-62b8-18bb-e847-1d2e58f2a07f@redhat.com>
References: <f85e3824-5545-f541-c96d-4352585288a@redhat.com> <206cd9fc-7dd0-f633-f6a9-9a2bd348a48e@ewheeler.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10



On Mon, 27 May 2024, Eric Wheeler wrote:

> On Wed, 15 May 2024, Mikulas Patocka wrote:
> > Hi
> > 
> > Some NVMe devices may be formatted with extra 64 bytes of metadata per 
> > sector.
> > 
> > Here I'm submitting for review dm-crypt patches that make it possible to 
> > use per-sector metadata for authenticated encryption. With these patches, 
> > dm-crypt can run directly on the top of a NVMe device, without using 
> > dm-integrity. These patches increase write throughput twice, because there 
> > is no write to the dm-integrity journal.
> > 
> > An example how to use it (so far, there is no support in the userspace 
> > cryptsetup tool):
> > 
> > # nvme format /dev/nvme1 -n 1 -lbaf=4
> > # dmsetup create cr --table '0 1048576 crypt 
> > capi:authenc(hmac(sha256),cbc(aes))-essiv:sha256 
> > 01b11af6b55f76424fd53fb66667c301466b2eeaf0f39fd36d26e7fc4f52ade2de4228e996f5ae2fe817ce178e77079d28e4baaebffbcd3e16ae4f36ef217298 
> > 0 /dev/nvme1n1 0 2 integrity:32:aead sector_size:4096'
> 
> Thats really an amazing feature, and I think your implementation is simple 
> and elegant.  Somehow reminds me of 520/528-byte sectors that big 
> commercial filers use, but in a way the Linux could use.
> 
> Questions:
> 
> - I see you are using 32-bytes of AEAD data (out of 64).  Is AEAD always 
>   32-bytes, or can it vary by crypto mechanism?

It varies. I.e. if you use hmac(sha512), full 64 bytes will be used.

> - What drive are you using?

Western Digital SN840

WUS4BA119DSP3X3

> I am curious what your `nvme id-ns` output 
>   looks like. Do you have 64 in the `ms` value?
> 
>         # nvme id-ns /dev/nvme0n1 | grep lbaf
>         nlbaf   : 0
>         nulbaf  : 0
>         lbaf  0 : ms:0   lbads:9  rp:0 (in use)
>                      ^         ^512b

Yes, I have this:
lbaf  0 : ms:0   lbads:9  rp:0
lbaf  1 : ms:8   lbads:9  rp:0
lbaf  2 : ms:0   lbads:12 rp:0
lbaf  3 : ms:8   lbads:12 rp:0
lbaf  4 : ms:64  lbads:12 rp:0 (in use)

Mikulas

> --
> Eric Wheeler

