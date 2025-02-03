Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAC04414
	for <dm-devel@lists.linux.dev>; Mon,  3 Feb 2025 21:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738616741; cv=none; b=rviZQLol0IjCnn+2MbNkYCqeBMyZOs4yAnsKbvl2Cvo9HJ2u+8n2bgPg86NtY7LgfF/gQdCPOYUKWsrZohoSgeySoOIZyIGmYSLoflYLrrljLfHw0QQJkcy9RmyKL2hHjgP/mNpA64sIfyczsiexzKaWpqddfmYL3ICNMAPeFOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738616741; c=relaxed/simple;
	bh=UcY7afZroDyBcPqp4s3IVPLDE/ljllDxj+TwtrQzwTU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hphgWKqPvkRpQRgrgITe6u5KyBAqzMJDMulEPasCaFIG0oBL3iRGoMzj6nCUlFTvjkGd5PbR30hY/fjTNAxeR8l+WvnjVrikcEw+z2t5zEMgO9Qyk3cRgzytBtUBp0FXiD+VxTVTpTK0UhxokW2VO2zl4sFZaYZGkJoNfOo58tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PZw+J79/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PZw+J79/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738616738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/Qw9837FuP/iC+NOneoge5XH9AGaPIHwQYEDec0CCuo=;
	b=PZw+J79/SYYbKAfWlIEaG9/507JLIS/+Va+M9Ok/tTNe/Zvht3vMbkoYfCMlVcvYWRKgVx
	EAmj1CH1cRqw9pFuO23bJz6rlgg9ZMqwk1OL5U0CPvsGsttrlhNpOLWu+ZwUqcuY1wcxxw
	XsP3qO2SkHnOMLDu/wwe+vKO1LjQC8o=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-180-HB1FBexqNgqQi9mcvDJ2hQ-1; Mon,
 03 Feb 2025 16:05:35 -0500
X-MC-Unique: HB1FBexqNgqQi9mcvDJ2hQ-1
X-Mimecast-MFC-AGG-ID: HB1FBexqNgqQi9mcvDJ2hQ
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60B3A19560A3;
	Mon,  3 Feb 2025 21:05:33 +0000 (UTC)
Received: from [10.45.224.44] (unknown [10.45.224.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 358CD180035E;
	Mon,  3 Feb 2025 21:05:29 +0000 (UTC)
Date: Mon, 3 Feb 2025 22:05:27 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Zdenek Kabelac <zkabelac@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    linux-block@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] blk-settings: round down io_opt to at least 4K
In-Reply-To: <yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
Message-ID: <28dcf41a-db7d-f8e7-d6b7-acef325c758c@redhat.com>
References: <81b399f6-55f5-4aa2-0f31-8b4f8a44e6a4@redhat.com> <Z5CMPdUFNj0SvzpE@infradead.org> <e53588c8-77f0-5751-ad27-d6a3c4f88634@redhat.com> <yq1cyfykgng.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Mon, 3 Feb 2025, Martin K. Petersen wrote:

> 
> Hi Mikulas!
> 
> > The purpose of this patch is to avoid doing I/O not aligned on 4k 
> > boundary.
> >
> > The 512-byte value that some SSDs report is just lie.
> 
> So is 4K, though.

Do you think that SSDs benefit from more alignment than 4K?

Based on my understanding (and some IOPS testing), SSDs have a remapping 
table that maps every 4K block to the physical location. So, 8K (or 
larger) I/Os don't have higher IOPS than 4K I/Os.

2K and smaller I/Os have worse IOPS than 4K I/Os, because they perform 
read-modify-write cycle.

If you have some SSD that has higher IOPS with alignment larger than 4K, 
let me know.

Mikulas

