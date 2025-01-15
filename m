Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EBD1D6DA9
	for <dm-devel@lists.linux.dev>; Wed, 15 Jan 2025 18:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736967553; cv=none; b=AoRGDajTbqmw9UIjgTE6SnzqV+Za8mXWj0vSjR8uTUoS+/WECK9hecwMb0i7IV3eDLArkz/erCBacdKP9OI80JhmJSC+1AnMcqidDI5MGD3sKYpF+hglVg0zwTnU+ekhS2ftvw6FC49pY5l2Pmy9qUujTkuWf8aZsb5Vs5CabAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736967553; c=relaxed/simple;
	bh=h7vDzbwNyEfIvQcoyjcubw9tLWPKKrbvNTDt49482+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=G41m+SmPeiZCdiX1HvziVc8uyKw/BwEgREM8wOclyPURpdFCjBbs8r1YHRnS/o5C7XyI6ce+KK5PrTCMmGwZ37wavNjFT5oodPps2mtxuS+AsLoLuWeP6bQqVCES3u7sKwQ3bErYecDtMTGaSKVrOytYg2tZnA/rjn6TE/YJvjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jh5+aIz3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jh5+aIz3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736967550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y1Go2H0uihJPuqGsBXKEINmApO6c9AaGPufVTBD77MA=;
	b=Jh5+aIz3iTwGQkAuhJ2cRtvb0oWSUg/UhMIgPGtcL2BuZNRWzKNAtJLrDLyGs+aTYuwWfp
	ch6+4sfdW0p9Dcpe4ci4jfdZ/z3pY7P1Y+j/kzWVRSxOQiS+LFD89THDIHGzw5vBdaW8eb
	7nbpyBe54Fqyb86zb6XIBPc569cOlhc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-XTWIa5FuPw2ffzNQbri9dw-1; Wed,
 15 Jan 2025 13:59:05 -0500
X-MC-Unique: XTWIa5FuPw2ffzNQbri9dw-1
X-Mimecast-MFC-AGG-ID: XTWIa5FuPw2ffzNQbri9dw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D2F9F19560B0;
	Wed, 15 Jan 2025 18:59:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7ACF019560AA;
	Wed, 15 Jan 2025 18:59:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50FIx1tt2716058
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 13:59:01 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50FIx1Qu2716057;
	Wed, 15 Jan 2025 13:59:01 -0500
Date: Wed, 15 Jan 2025 13:59:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/2] multipathd: set rport port_state to marginal for
 NVMe devices
Message-ID: <Z4gFdSUb0JGFSAJ0@redhat.com>
References: <20241220020235.1759375-1-bmarzins@redhat.com>
 <20241220020235.1759375-3-bmarzins@redhat.com>
 <c7641dfc68b568dc78297c60c56a9ee8@mail.gmail.com>
 <Z3wVVg0AgLLq4EUN@redhat.com>
 <7fd13eec94452ac1128158aa7fb79ea08367641f.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7fd13eec94452ac1128158aa7fb79ea08367641f.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kKUlcPczsAuPepmBN4rxpNVmsLWek2GFiNm6LJL7Uhg_1736967544
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jan 14, 2025 at 11:31:00PM +0100, Martin Wilck wrote:
> On Mon, 2025-01-06 at 12:39 -0500, Benjamin Marzinski wrote:
> > On Fri, Dec 20, 2024 at 04:25:22PM +0530, Muneendra Kumar M wrote:
> > > Hi Benjamin,
> > > Thanks for the changes.
> > > But below is the reason why we didn't add support to set the rport
> > > port_state to marginal for NVMe devices
> > > 
> > > In the case of SCSI  once rport-state is set to Marginal ,
> > > If any pending I/O's on the marginal path hit's the scsi-timeout
> > > (after
> > > abort success) the scsi-layer checks the rport-state  and If the
> > > rport-state is set to Marginal it will not do any retries on the
> > > Marginal
> > > path instead the I/O
> > > Will be retried on the other Active paths.
> > > 
> > > 
> > > This particular functionality(checking the rport-state and acting
> > > accordingly) we didn't add( as far I know) in the case of NVME and
> > > we need
> > > to check how we can handle this in the case of NVME .
> > > That's the reason we didn't set the port state to Marginal in the
> > > case of
> > > NVMe.
> > > 
> > > 
> > > In a brief SCSI layer handles the case when the rport-state is set
> > > to
> > > Marginal whereas in NVMe it doesn't(AFIK).
> > > 
> > > Atleast with the below changes we make sure that once we get the
> > > FPIN-LI
> > > notification we will set the affected path , as well as the rport-
> > > state to
> > > Marginal irrespective of SCSI and NVMe.
> > > 
> > > I am just thinking that until we have some changes in the NVME
> > > driver to
> > > handle (the rport-state to marginal) this changes doesn't show any
> > > impact
> > > in the case of NVMe
> > >  other then keeping it  on par with SCSI implementation.
> > > 
> > > Please let me know your opinion on the same.
> > 
> > The request to do this came because the user wanted to see which
> > target
> > ports were effected, but when they looked, none of them we in the
> > Marginal state. So there is some value in this for users, even if the
> > systems behavior doesn't change because of it.
> 
> Please add a note to the commit message explaining this.
> 
> I'm actually a bit concerned about it ... won't other users be even
> more confused when they see the path devices as marginal but don't
> observe any change in the system's usage of these paths?

Sure, I can add a commit message. But while this isn't implemented in
the NVMe layer, multipath will still route future IO differently. So,
any IO that multipath has already dispatched to the now marginal path
won't get treated differently, users will notice a change in IO patterns
going forward. Right?

-Ben

> 
> Regards,
> Martin

