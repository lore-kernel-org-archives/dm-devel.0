Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A39222574
	for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 12:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739192054; cv=none; b=rYCm3rJ0docK3yAFnlny7VrDJNTB8l1YmIcTTtfU4nRt9yZTCBz6cIppe35W+KS/WWEZ0hCFU44KzBVjLvkZZsAMQ8MED8hsfoBBMbrQcJ6eV15OD8dCWYiDKu39jvtEDOb1X3f775cIz8zefPAlHuEOGg44uykxHLx7ZiFh3aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739192054; c=relaxed/simple;
	bh=QGqalAQ1rnunlXro3KoB8sBbpOQlfMZWddKxwHfcwsQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=aBaVOk2g/1dHoMcgG0X+jVVIxE2bV75Sk+zttTTOuITL1UXQilLOpPuYAPluUxZApDIjmI/O9VHrePfnHsBFZAKFpOaCq1H/mH30p3FoAbPw2GDxG7ZnuS9OUYDhJErdcRGVk5z+fhFzOKlC6Yytk6nzs9bjo0petXIeVG3SJRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=haPeQRBy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="haPeQRBy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739192050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YxRVDQx0KBoUs8EflhssFSPDwR4Afm5j1VwyYYrfOfs=;
	b=haPeQRBy7MIDV+AepT0kDryqNR19YuwHrYhnEBP/91mqn5/GyDIQ6PhRWtScX67QH0Ty2P
	5oDI7ckzzCkmeWHKkVoaAu2Kq7/d+gtObWBi2fqwnksCmdUEn/OH7jij/pubGCv3id07XZ
	tD9tTeF3vr3FSPwV9WXDjQEm1cnRgA8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-Zrrmm6oYP1ivFem4Io8wlw-1; Mon,
 10 Feb 2025 07:54:07 -0500
X-MC-Unique: Zrrmm6oYP1ivFem4Io8wlw-1
X-Mimecast-MFC-AGG-ID: Zrrmm6oYP1ivFem4Io8wlw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B5681800876;
	Mon, 10 Feb 2025 12:54:06 +0000 (UTC)
Received: from [10.45.225.131] (unknown [10.45.225.131])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83F46195608D;
	Mon, 10 Feb 2025 12:54:03 +0000 (UTC)
Date: Mon, 10 Feb 2025 13:54:00 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Zdenek Kabelac <zkabelac@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
In-Reply-To: <yq1cyfxdsmz.fsf@ca-mkp.ca.oracle.com>
Message-ID: <52b66f23-d8c8-1344-6fd0-277dfa31ce84@redhat.com>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com> <Z5CMPdUFNj0SvzpE@infradead.org> <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com> <yq1cyfykgng.fsf@ca-mkp.ca.oracle.com> <28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com> <yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
 <00717ba6-0ce9-5ccd-d93d-ce5db89d85ff@redhat.com> <yq1cyfxdsmz.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Tue, 4 Feb 2025, Martin K. Petersen wrote:

> 
> Mikulas,
> 
> > If there is some particular SSD that has more write IOPS for 8k requests 
> > than for 4k requests, I'd like to know about it - out of curiosity.
> 
> SSD blocks are getting bigger and bigger, some drives hide it better
> than others. Also look at all the efforts going on wrt. supporting
> larger block sizes in the kernel.
> 
> Can you send me the output of:
> 
> # sg_vpd -p bl /dev/sdN
> 
> and maybe hdparm -I too? I'd like to see if we can come up with a
> reasonable heuristic.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering

I don't have that USB-SATA bridge that reports optimal I/O size 65535 
sectors. Milan talked about it, but maybe he doesn't have it too. Some 
user reported that cryptsetup behaves badly with this particular bridge, 
so Milan wrote workaround for it in cryptsetup.

You can simulate it with "modprobe scsi_debug dev_size_mb=32 
sector_size=512 num_tgts=1 opt_blks=65535"

Mikulas

