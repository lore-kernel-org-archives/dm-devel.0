Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE81355021
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 15:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769010624; cv=none; b=Yz5jCm/ZVDIx3kR73lneT2I2fAxTQEEb4XD3hhot1ZKv9n50yu5C5SmLpcNuo6Z6cFb9o8Qwm8fGOecinWPsq8JMFG8255RvDtR2LfYE1IxWdv/qJmTzEsPSp0nRdskwZmzVc1W4AHBTfcQ2Ml8DpPwPUeBrfBJc9Mt25o9azvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769010624; c=relaxed/simple;
	bh=scVHSAd3RYEtELBcceeznqJX6b99/wYF4gXQlZ/mCA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=DQKb/5VXIyRkbHYt/skn67e9JfbMw6yvs6h2b5SqzHIRisFe6ngugNB/XOqUa33vgKmoJXoI2/MeI2waQQ9RDOG68fxjTxq5ckAdc+X3sV/nTMCKS9nsX+wbS1L+nD/XgV5luclCYJqE6jVQYjb89Ij30pO51OpJvvGh+l7VE+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3od7Atr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3od7Atr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769010620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gXsAeVm1zH8uXdf5W12thRyzrRe7PRzMyZ5q/jBL9X8=;
	b=e3od7Atr/FTytHsQGMaN6M2vsQOuZ3vEyLtq1sqr8TRwL86KCnqcsdYKb57tDCqCDhWXWy
	d5HDCxKVloXSYdG5cYOghBqjAV1DGfNOVCn/JMmh2m6WcmAyPM7lms3iTuWx6QBzgYc9fe
	anrCISDrxJefyDoVCPA3EIm2CZLMEmA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-549-94PgPUkjNpep9S5Xp8BRfg-1; Wed,
 21 Jan 2026 10:50:17 -0500
X-MC-Unique: 94PgPUkjNpep9S5Xp8BRfg-1
X-Mimecast-MFC-AGG-ID: 94PgPUkjNpep9S5Xp8BRfg_1769010616
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA13118003FC;
	Wed, 21 Jan 2026 15:50:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1BFA19560A2;
	Wed, 21 Jan 2026 15:50:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60LFoEth3932327
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 10:50:14 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60LFoEqL3932326;
	Wed, 21 Jan 2026 10:50:14 -0500
Date: Wed, 21 Jan 2026 10:50:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/4] multipathd: make "multipathd show status" busy
 checker better
Message-ID: <aXD1tsRC9PeR5aEX@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
 <20260121042315.3914707-4-bmarzins@redhat.com>
 <a6931ca87fcb21eb20490be1f3a6b7b21d80985b.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a6931ca87fcb21eb20490be1f3a6b7b21d80985b.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1N65-TL6SeBOmLBQFFIV2npyYgpGlZAU8jUG2QksIHY_1769010616
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jan 21, 2026 at 10:27:51AM +0100, Martin Wilck wrote:
> On Tue, 2026-01-20 at 23:23 -0500, Benjamin Marzinski wrote:
> > while uevent_listen() was grabbing new uevents, "multipathd show
> > status"
> > would still show show busy as "False". Add a check there, to make
> > catch
> > multipathd's uevent processing earlier. Also, access servicing_uev
> > (as
> > well as the new variable, adding_uev) atomically, just to make sure
> > that
> > the compiler doesn't do stupid things trying to optimize them.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> access to servicing_uev is protected by uevq_lockp. The
> atomic annotation isn't necessary for it, AFAICT.

True. I can remove that.
 
> I have to admit that I wasn't fully aware of the semantics of "busy".
> Naïvely, one would assume that it means "some thread of multipathd is
> doing something". But your intention in 69cb2d8 ("multipath: add "count
> paths" multipathd command") was that it means "states of paths and/or
> maps are imminent because of current uevent processing". With that in
> mind, taking "adding_uev" into account makes sense. I'm not so sure
> about the practical relevance, though. How likely is it to hit a
> situation where the uevent listener is working but the uevent
> dispatcher hasn't been woken up yet?

I saw it happen at the start of a uevent surge. To be honest, I don't
know why uevent_receive_events() took so long to return, but it seemed
like extending the check is a pretty painless way to catch that.

-Ben

> Martin

