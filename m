Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B3A1C8605
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 03:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756438674; cv=none; b=QTcJrrEDqFs5dhncACdDFwhTfxkRNCOGg5mxO1kiERDLm6L7fmcTLebaEtcX0Hhmq+lRQBm+26JOgQg/Vi0Wf/5Rm8CRs212N8ApLMRhuD7jgzuvHkE/DBTAxy5SNbm6nzj0R08spYhGFOlgPbCX6uA7ZNuhRb4zmqKJolo/mFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756438674; c=relaxed/simple;
	bh=EPPkV/4YIuGgce1I01wPYK/cmW5fYoE1MUv19xs37qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Zd1plbvLTORhBeY0Qbb55hIhb2xNFQMz8EFCWSDsrDWQapNlp3isye2t8cDXYLAPe+MnVeXXFUbi3cjV5Ani4haUJZ0g0su1aRPyNgM2stXfQfE8dG42fcBeiSBLRQXSw4CrxD5Pr5NRMD9i932DPnw+Tx4igTyHhDyGgRr4SE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wgn3MYFA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wgn3MYFA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756438671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o8gnABXZ/M6Re5FG0MJV/8uy3MqshNA1CzB0A1B8hdU=;
	b=Wgn3MYFA6qRHSECeC0eg6gRPw5bAz5iQotfIkuBZPZyjPjM0uQI7CPpKlVj9UoMJfm8FBF
	mkKzKgIX1dGdJuegKGTFBTEdgdRmb2aAeINATFJsdy2ygYamiSxOlJJz8xc2kfClnHWkUk
	8t98bGX92wK4bF81LXIxYFzkLHdjQvk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-XnAv79XhNbaxfu_vqNE_7Q-1; Thu,
 28 Aug 2025 23:37:47 -0400
X-MC-Unique: XnAv79XhNbaxfu_vqNE_7Q-1
X-Mimecast-MFC-AGG-ID: XnAv79XhNbaxfu_vqNE_7Q_1756438666
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A18F6195608F;
	Fri, 29 Aug 2025 03:37:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4FD1D1956095;
	Fri, 29 Aug 2025 03:37:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 57T3bitX349004
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 28 Aug 2025 23:37:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 57T3biV9349003;
	Thu, 28 Aug 2025 23:37:44 -0400
Date: Thu, 28 Aug 2025 23:37:44 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 12/14] libmpatpersist: update reservation key before
 checking paths
Message-ID: <aLEgiGGxvEySW397@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
 <20250726035855.363290-13-bmarzins@redhat.com>
 <aad385f3a960df921765001f35f1a6f3cf39edb7.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aad385f3a960df921765001f35f1a6f3cf39edb7.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bm2sfhxkevElDHphBIrOr-0u2tcgQ4Mr6pYI1x5IWPs_1756438666
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 25, 2025 at 06:36:18PM +0200, Martin Wilck wrote:
> On Fri, 2025-07-25 at 23:58 -0400, Benjamin Marzinski wrote:
> > There is a race condition when changing reservation keys where a
> > failed
> > path could come back online after libmpathpersist checks the paths,
> > but
> > before it updates the reservation key. In this case, the path would
> > come
> > up and get reregistered with the old key by multipathd, and
> > libmpathpersist would not update its key, because the path was down
> > when it checked.
> > 
> > To fix this, check the paths after updating the key, so any path that
> > comes up after getting checked will use the updated key.
> 
> In do_mpath_persistent_reserve_out(), you call update_prkey_flags()
> before checking for MPATH_PR_SYNTAX_ERROR. Perhaps you should check the
> key parameters first?

We could, but the way the code currently is, if you called
update_prkey_flags() earlier, you can't fail those MPATH_PR_SYNTAX_ERROR
checks.

You can only call update_prkey_flags() if rq_servact is
MPATH_PROUT_REG_IGN_SA or MPATH_PROUT_REG_SA, so we only need to look at
the True branch of the outermost if statement in those
MPATH_PR_SYNTAX_ERROR checks. We also cannot fail those checks if
unregistering is true, so we only care about the case were
paramp->sa_key is non-zero. And when we call update_prkey_flags(), we
also copy the value of paramp->sa_key to mpp->reservation_key, so it too
must be non-zero. This means that can't fail the checks since they
check if mpp->reservation_key is zero or not equal to paramp->sa_key.

But it doesn't hury anything to move the update_prkey_flags() call to
after those checks either. So I'm fine with either solving this by
adding an explanation of why we don't need to worry about failing these
checks if we updated the key to the comments above the checks, or by
just moving the update_prkey_flags() call to after them. Do you have a
preference?

-Ben

 
> Martin

