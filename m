Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC07A2139B6
	for <dm-devel@lists.linux.dev>; Tue,  4 Feb 2025 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738680986; cv=none; b=eUA9OGa1JVOcmvHox3EvhXku8xziwQe6/k491M2G3Fk1mIXmdLqaGVuCZfOzjoATegkqynApf7Lpq48Ezzu2wn1u4pxnq4xm4aS1+z7WcISAcNOmiN85F7Q/lI2rW5kqWq68wfgss/QATL7T5FyHw2THSCLdzlQ9ENL20D0SlKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738680986; c=relaxed/simple;
	bh=O/rfYoTNixn29cCZ9awbxuPaOKKawFsiFKtSr6b8zXY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=N9cf1AVWkYtZv7a/BIKNPmNsJioDoSE58gJQSAIBr4Ri5LS6jCzEOog2CcDV+EF7Lrpdpi6hYiy3dl+ckD8m9n5p/J+0pVfaI9lFQWh3G6HZL0PRcJFFSIHNgnbnc30mux+p00qs8rkJT/l+GrzA8RUM12FEtvPMcDO0PvsIc9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TQo93pFS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TQo93pFS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738680983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2r8CksgnjI1WLDA0JxManiTZylrXoDkYbfPYjwCz02M=;
	b=TQo93pFSgRWfuUxuwzaeYD75pu8GTGGPC0nqMlhmnCCxu0b4asxM2fDQW7NryxoiYrD/CF
	N9fgE/mvlglELaENGnvGpdeUs+i6SbQH7hNBa6NAVFbPA1Q00RQwwKE6Y1Dbq3J7q9d8eR
	4CF2A2CdQ4T/zFpP8vPb1VTa8T9L6Rs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-KsHwvvyzNsGtCIaQQO2_TA-1; Tue,
 04 Feb 2025 09:56:20 -0500
X-MC-Unique: KsHwvvyzNsGtCIaQQO2_TA-1
X-Mimecast-MFC-AGG-ID: KsHwvvyzNsGtCIaQQO2_TA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77B3A1801F17;
	Tue,  4 Feb 2025 14:56:18 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D02F219560BC;
	Tue,  4 Feb 2025 14:56:14 +0000 (UTC)
Date: Tue, 4 Feb 2025 15:56:11 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Zdenek Kabelac <zkabelac@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
In-Reply-To: <yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
Message-ID: <00717ba6-0ce9-5ccd-d93d-ce5db89d85ff@redhat.com>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com> <Z5CMPdUFNj0SvzpE@infradead.org> <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com> <yq1cyfykgng.fsf@ca-mkp.ca.oracle.com> <28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
 <yq1bjviflwb.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40



On Mon, 3 Feb 2025, Martin K. Petersen wrote:

> 
> Mikulas,
> 
> > Do you think that SSDs benefit from more alignment than 4K?
> 
> It really depends on the SSD.
> 
> > If you have some SSD that has higher IOPS with alignment larger than
> > 4K, let me know.
> 
> Absolutely.
> 
> There are devices out there reporting characteristics that are not
> intuitively correct. I.e. not obvious powers of two due to internal
> striping or allocation units. Some devices prefer an alignment of 768KB,
> for instance. Also, wide RAID stripes can end up causing peculiar
> alignment to be reported.

Surely that RAID4/5/6 performs better when you write a full stripe. But 
I'd like to know whether individual SSDs have increased IOPS when the 
request size is increased.

The write tests that I did (some years ago, I don't remember the details) 
showed that SSDs have the best write IOPS for 4k requests. For smaller 
requests they perform worse (because of read-modify-write), for larger 
requests they also have slightly less IOPS (because they write more data 
per request).

If there is some particular SSD that has more write IOPS for 8k requests 
than for 4k requests, I'd like to know about it - out of curiosity.

When I was developing dm-integrity, I just aligned metadata and data on 4k 
boundary, regardless of what the underlying device advertised.

> Instead of assuming that 4KB is the correct value for all devices, I'd
> rather address the cases where one particular device is reporting
> something wrong.

The patch that I made tries to round down optimal IO size to 4k, it 
doesn't force optimal IO size to be 4k.

> I'm willing to entertain having a quirk to ignore reported values of
> 0xffff (have also seen 0xfffe) for USB-ATA bridge devices. But I don't
> think we should blindly distrust what devices using other transport
> classes happen to report, it's usually only USB bridges that are spewing
> nonsense. Which is why we typically avoid trying to make sense of VPD
> pages on USB in the first place.

Mikulas

