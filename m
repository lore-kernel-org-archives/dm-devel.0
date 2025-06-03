Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5649823BCFA
	for <dm-devel@lists.linux.dev>; Tue,  3 Jun 2025 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748966709; cv=none; b=bQnf5yFm2NDVzOPGd5oacjLtYPTgJgPu29aWIMd2zrMfLrtMVksvvbUKGPEFeJP+pMW6Q+QwejzV1/50NpfzqD5hjZ1SWrYOWcsc8NwNPu9z7gdEmZBW953XYYTZeKQJ0R3wElnF1J+eOJfgBFkNC2e4/Nt1X85OYYlZoqAYVzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748966709; c=relaxed/simple;
	bh=6SLg1LoecvyaYu9Rd5wHx1iN2y7a9ABtUIdQFNmof6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fLasbTUHyf/Tyr3ruqpIdRMBjs/NcumOd4BY+KLT5XtHkg6bEtsjh54zWOPrgTWJRqBfI1BWbzLozRnHkPt2oQdLdjdCZImpE0Uiw3Dw2dkrc2MgbrKUlMQ3CxPdkw4lrrwCxirSqAKWequYuhJh+O4aKX5fHdfJFkozVN2KV+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cf4sN4h1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cf4sN4h1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748966706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dv4uiohT3zsDhl5+kF9GraoHQsrkUtnLiCJh35rXhqs=;
	b=cf4sN4h14mNqhS+rk1TsCvA4uM56iQ7lLYxRw+wyuSSaAV4gWKVGjjN9RhQHIVFQDoeVaf
	bMGapllMQvMEH7F7lIb6DIzCxsEeu6m538NXgCnASVP27fdz4RaE/CtsSnVrkqUoTe0dmu
	SriV72yUYSjMR2L+U3ykvbfQGTBOQnE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-MmjOQFv5PuWQ-9nkr--T6w-1; Tue,
 03 Jun 2025 12:05:05 -0400
X-MC-Unique: MmjOQFv5PuWQ-9nkr--T6w-1
X-Mimecast-MFC-AGG-ID: MmjOQFv5PuWQ-9nkr--T6w_1748966704
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E725419560AD;
	Tue,  3 Jun 2025 16:05:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61D541800242;
	Tue,  3 Jun 2025 16:05:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 553G50qD2101530
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 3 Jun 2025 12:05:01 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 553G50k22101529;
	Tue, 3 Jun 2025 12:05:00 -0400
Date: Tue, 3 Jun 2025 12:05:00 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        dm-devel@lists.linux.dev, hch@lst.de
Subject: Re: [PATCH] dm-table: check BLK_FEAT_ATOMIC_WRITES inside limits_lock
Message-ID: <aD8dLP5d-fvI-D-B@redhat.com>
References: <20250530145032.1491277-1-bmarzins@redhat.com>
 <d9d13fea-e75f-4fa4-86c8-dc7053a553b9@oracle.com>
 <aD3QccNaBXLQ2xPP@redhat.com>
 <9f8cb209-00c4-4596-b6df-3bf5ed2f1505@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <9f8cb209-00c4-4596-b6df-3bf5ed2f1505@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JtydDcLmOMfTuJJAuOmupvm5hTf0z_lZYneaLUsEYSo_1748966704
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2025 at 08:57:32AM +0100, John Garry wrote:
> On 02/06/2025 17:25, Benjamin Marzinski wrote:
> > On Mon, Jun 02, 2025 at 11:08:46AM +0100, John Garry wrote:
> > > On 30/05/2025 15:50, Benjamin Marzinski wrote:
> > > 
> > > +
> > > 
> > > > dm_set_device_limits() should check q->limits.features for
> > > > BLK_FEAT_ATOMIC_WRITES while holding q->limits_lock, like it does for
> > > > the rest of the queue limits.
> > > > 
> > > > Fixes: b7c18b17a173 ("dm-table: Set BLK_FEAT_ATOMIC_WRITES for target queue limits")
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > 
> > > In itself, the change seems fine, but I have doubts whether it's preferred
> > > to even grab the q->limits_lock outside block layer / its helpers.
> > 
> > I'm pretty sure Mikulas added the q->limits_lock around DM's queue
> > limits accesses as the result of a discussion with some block layer
> > developers.
> 
> Do you have a pointer for that?

https://lore.kernel.org/dm-devel/ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com/

Specifically, in that thread Ming Lei suggests it here:
https://lore.kernel.org/dm-devel/Z9t709DZs-Flq1qS@fedora/
and Jens agrees.

-Ben

> 
> > 
> > > 
> > > And, apart from this, if the bottom device limits change later, do we
> > > actually trigger a top device limits evaluation update?
> > 
> > DM will obviously re-evaluate the limits if you reload the table. In
> > some cases, DM will also disable features if turns out that they aren't
> > supported when it actually tries to use them. Dumb question: Is there
> > much chance of a SCSI device's atomic write support changing while it's
> > in-use?
> 
> No, I would not think so.
> 
> thanks,
> John

