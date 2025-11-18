Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09273A5E77
	for <dm-devel@lists.linux.dev>; Tue, 18 Nov 2025 17:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485784; cv=none; b=fowUmDSK7v8qPNxOyiK/74lamRWZ8mPyKk9xgWhtYwC6sSIwrducKBdck/p4WpZtDynfvTpqI8tlJYwbQjxoIfEsY3yoemJsFj7Kc3efAsUFkWtoe4wS8zQq+oRxU9r/qyIykTU2zDul6vFkQOgnTg6G0LsHnSjYG9NqQ1HQgNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485784; c=relaxed/simple;
	bh=W7SqzbGKVzYvXAnddUTzsnVLmy9+sX4mnax2kGQ1PPQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tHZiowRgs1CCh7m5O3qhwI3pTqUnaJ97bAF0hnykb3QlXt6Z8qkAXulJ4b9M83DO4OK2/aDGhO6z31EE5r8d6R704Ju1ihadcU6JlbNy0y/XHPxj1aGAi9fffg3FwUat3Xyzbi5h71KMF/wAg73Zxz/4E7ypvNiBc+ZDrLgUoN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MA0ekJrm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MA0ekJrm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763485781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JFBxbE/duQJFjei5M01noRGzCfdDivF+IQ/p95hcc2c=;
	b=MA0ekJrmFS4y6UTpiZ0cZ+Om+cMNOO2n3kjGV4k75jEnoXDF1qxvJxuIFz1jdwhWRIE19M
	wysFVYdwGX7wU2bJzWOwQhrIdfvp3csZz+GKZZjAet8uVOU73ilCDFtTUeF9dzmGhFQUVm
	AYxFrBtorzz2dSYHTzdh7d5rwZ+s2KU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-532-d0AYXQXZNpy5FaAiFbMT4A-1; Tue,
 18 Nov 2025 12:09:35 -0500
X-MC-Unique: d0AYXQXZNpy5FaAiFbMT4A-1
X-Mimecast-MFC-AGG-ID: d0AYXQXZNpy5FaAiFbMT4A_1763485774
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A7E019560A2;
	Tue, 18 Nov 2025 17:09:34 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6512718004A3;
	Tue, 18 Nov 2025 17:09:32 +0000 (UTC)
Date: Tue, 18 Nov 2025 18:09:26 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    michael.christie@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
In-Reply-To: <9d2816c3-fc01-44d0-a9ca-4129515bd0ca@oracle.com>
Message-ID: <4ba947ac-969a-49da-193a-ea5cea43c14e@redhat.com>
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com> <6b3582bb-1e50-4e7a-972f-a82f62f46e7c@oracle.com> <9d2816c3-fc01-44d0-a9ca-4129515bd0ca@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FNinHeMKpZahXu0316GH1raUbMyG0gTxnDziAhuVqN4_1763485774
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 18 Nov 2025, John Garry wrote:

> On 10/11/2025 16:02, John Garry wrote:
> 
> Hi Mikulas,
> 
> Just a friendly reminder on this series. Let me know if you require anything
> else.
> 
> Cheers

Hi

In crypt_io_hints - should I set "limits->atomic_write_hw_max", 
"limits->atomic_write_hw_unit_max" or both?

I think that we haven't settled about that when we talked about it.

Mikulas

> > On 05/11/2025 15:02, Mikulas Patocka wrote:
> > > Allow handling of bios with REQ_ATOMIC flag set.
> > > 
> > > Don't split these bios and fail them if they overrun the hard limit
> > > "BIO_MAX_VECS << PAGE_SHIFT".
> > > 
> > > This commit joins the logic that avoids splitting emulated zone append
> > > bios with atomic write bios.
> > > 
> > > Signed-off-by: John Garry <john.g.garry@oracle.com>
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > 
> > 
> > Tested-by: John Garry <john.g.garry@oracle.com>
> > 
> > fwiw, I still don't think that we require the change in crypt_io_hints()
> > [not shown], but it should not make a difference.
> > 
> > Thanks!
> > 
> 

