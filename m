Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0351F4615
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 18:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762366998; cv=none; b=Kl9t4bqfBCT4IstDZ3PY0yfWCQma6muymR4TKmxEn3M1fFYTRrSGOnom4KQ6s5j4ToyCxRgOHFvJT3M/bOwDE/ot6LAvwLGdVEtCkaH0uUu6cKTcDNWif0nNb243v+X9FTzoMzdD7fwcRbesrOabp87JlM4GVmiulrkMS8i2fEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762366998; c=relaxed/simple;
	bh=ve8a+J7dggO4lFmHLfM/as0yJ0Lu44MMo0/bb4HFNjw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nzrbW4U7Si4iJXB/Ta+Jjvb29Z3+5gYHRE4bUd/56sdR+4+6sLYaOsFBeCeCaxByFciVL1i4VvJjbHKnjQwrwoMgOkA5Rr2Tax1SaaoQsfCZ9Gqy+a9F2lyoGcYr42jLEk4d5Kcu+4sj7Ig2rFqQxLEYBVFhHZa/ozmUIzlLS4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U5ZgvV+S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U5ZgvV+S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762366995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jQR4gK66SC2D0shFE0youicfqOceijcYRBsGM5U6FKY=;
	b=U5ZgvV+Sg0XLmYukutQ+FQRrIY8Z0NTKYJuNgOSPEJB3T/3mlnPEBmnYUhCbd2q5SbiKb7
	k5llc093fs+0EdQ+ehqUMcCmWsO3+9j3yfz9XrkiUoPlnyX/UQYWNKimdM9iHdcSYwMIy2
	s2qlyBtfLnMqJ+I/Y0KMekrcFXXh87c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-4IaDBSlQOhCwQ2J9hY-OTw-1; Wed,
 05 Nov 2025 13:23:12 -0500
X-MC-Unique: 4IaDBSlQOhCwQ2J9hY-OTw-1
X-Mimecast-MFC-AGG-ID: 4IaDBSlQOhCwQ2J9hY-OTw_1762366991
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFB2F1956080;
	Wed,  5 Nov 2025 18:23:10 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0025919560B2;
	Wed,  5 Nov 2025 18:23:08 +0000 (UTC)
Date: Wed, 5 Nov 2025 19:22:59 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    michael.christie@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH 0/2] dm-crypt atomic writes support
In-Reply-To: <8c9b0336-4a3e-49c4-9324-50d1c1b0305b@oracle.com>
Message-ID: <bc439c9c-6002-494d-7dcd-250b3169d92c@redhat.com>
References: <20251105120244.99752-1-john.g.garry@oracle.com> <7942b0d8-9f5f-d8b5-194a-3dd5b604898a@redhat.com> <90b9aaa5-0572-4a3c-afd3-33864daeb814@oracle.com> <a78c06d6-27ea-55c1-fcba-98ebc0bb7a43@redhat.com>
 <8c9b0336-4a3e-49c4-9324-50d1c1b0305b@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 27crC2TE551bzqnCvVnguwBMh-k3GwPQQy2SmtycwZU_1762366991
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 5 Nov 2025, John Garry wrote:

> > Similarly, if you stack dm-crypt on the top of a logical volume and change
> > the limits of the logical volume, dm-crypt has no way to find you that the
> > underlying logical volume was reconfigured.
> 
> Sure, and I don't know what really can be done about that.
> 
> But I am interested in if extent a vg by adding another device - would the
> limits of a lv be updated? I think that it would.

Yes, they would.

> > There is also time-to-check - vs - time-to-use race condition. Someone may
> > see that a device has non-zero atomic_write_hw_max, construct an atomic
> > write bio, the device could be reconfigured after the bio was contructed
> > and before the bio was dispatched - and the atomic bio would be sent to a
> > dm target that is not expecting it.
> 
> Sure, but the good news is that we have checks in the block stack for this,
> i.e. if dm submits a bio with REQ_ATOMIC to a device which doesn't support
> atomic writes, then the block stack will reject it. The physical device will
> also reject it.

Yes - but the block layer checks the bio without preventing device mapper 
table swap.

So, the block layer may find out that a device supports atomic writes, 
pass the bio through to dm, dm table may be reloaded and the bio would be 
sent to a target that doesn't expect it.

You must do the check inside the RCU read region to make sure that the 
dm table can't be swapped underneath.

Mikulas

> Thanks,
> John
> 

