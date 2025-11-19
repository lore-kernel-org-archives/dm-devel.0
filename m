Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2412E0901
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 17:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763572457; cv=none; b=N8D6l4BptBHY/AxHaDFUqpZC2s3M0ujvq0xej8FPZCW7mdYidHIC0vEdhrYP1xguhJmErn8fU4uwsvlMXX5j+V9FzgGGo4W3ge4vChaeKO+ctHqYv2dEGqBspvjX4NJhvngDaAymB00qmVWVdfymIcZhoCbdybGqYqrbNaKvShA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763572457; c=relaxed/simple;
	bh=Fo5HvjUQhUkh6IZ71afeExcK/YeZ6Ox9kIytVIdPCaM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fm9mjVEUhy45mtV7DkSFVDNJXsn7ETrksQnXmfK5xHfjcFAcX4SVYIlVUG/GvaY3FW1m+KAqcZDZoz4E39SKtG3XNxbqS/yduNkkENmu4SqtcVOp2FfXRIeU+QjEttPyVuSQACJQAynD2/incuaDg0pfKZvkFnSuCRGS7Dg0LPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A/CPMQDC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A/CPMQDC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763572454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pr6IQs5FpCTaJW+P4yZyIURBTeOI7apzV+Rg15XBRt8=;
	b=A/CPMQDCV5ugNbFQ8G/Di9avMcHo6uc2eKGUBe/1N+JW2YGV7oKN6P3tQP7xk79CFb/KOC
	xAXtDR2BgPMWAoqq5v1DxIWdp9dKxc6GN6x6RL7VyUWs9Gw3RYiNEZt3AKpJyiCtXmryZL
	pg0lZoQm3eIkpZdRhPYWTNU+FwqakI8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-ymqT71PbOuSTQ_4liC8Kzw-1; Wed,
 19 Nov 2025 12:14:09 -0500
X-MC-Unique: ymqT71PbOuSTQ_4liC8Kzw-1
X-Mimecast-MFC-AGG-ID: ymqT71PbOuSTQ_4liC8Kzw_1763572448
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6C38195609E;
	Wed, 19 Nov 2025 17:14:04 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0ECF18004A3;
	Wed, 19 Nov 2025 17:14:01 +0000 (UTC)
Date: Wed, 19 Nov 2025 18:13:56 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christoph Hellwig <hch@lst.de>
cc: Benjamin Marzinski <bmarzins@redhat.com>, 
    "Uladzislau Rezki (Sony)" <urezki@gmail.com>, 
    Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm-bufio: align write boundary on
 bdev_logical_block_size
In-Reply-To: <20251119054524.GA19993@lst.de>
Message-ID: <f8394fce-dc49-661a-6960-a816094d6da4@redhat.com>
References: <20251020123350.2671495-1-urezki@gmail.com> <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com> <aRvvSvyG8AK9hiCX@redhat.com> <faafd90d-e41c-dcfc-cc25-7f29ff4f958c@redhat.com> <20251119054524.GA19993@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Wed, 19 Nov 2025, Christoph Hellwig wrote:

> On Tue, Nov 18, 2025 at 06:45:55PM +0100, Mikulas Patocka wrote:
> > I changed the patch below, so that it aligns write bios on 
> > max3(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev), 
> > bdev_physical_block_size(b->c->bdev)); - so that if physical block size is 
> > greater than logical block size, the writes are aligned so that the device 
> > doesn't do read-modify-write.
> 
> That doesn't make any sense whatsoever.  The physical block size must
> be >= logical block size, and the block enforces that.

OK, so I changed it to max(DM_BUFIO_WRITE_ALIGN, 
bdev_physical_block_size(b->c->bdev))

Mikulas

