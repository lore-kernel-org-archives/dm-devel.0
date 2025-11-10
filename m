Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85DE21B9FD
	for <dm-devel@lists.linux.dev>; Mon, 10 Nov 2025 21:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762811682; cv=none; b=bb10mPpBhRCinoiZqrbdpbhoifw/HE0bgng/357rm9+z5+chgL1Y3EAdikRBAemeM7X2xEgFbslpC76v9SyJPRGvtMhw/weOj0Ytxo6R/W8ipUOHaFwbXRilxrC/8sQeImfWqhtwimHkBQ+gcWO7OLsqCvG/p7DUv0kP6WrN1L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762811682; c=relaxed/simple;
	bh=IPnpTvzYO08caLqJi27tlcHTQEs/DmxN0z42vlIdguI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cK0NltXRVYwsiLLG56cNV/r1MrO/67TWnPV2xPHZ57VlSkNYfM0d9WiPdCWMf3hlBLRdm0bdKt1d4wYuZBq+TyhVFC6TYgogEdBK/5h8GTecYIACmHNC3+5MN6Hj0kyOwVj7RAw6e2FSEnyxYL99OdGGCPJfcbxJ/36oEOq0ONc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IwQggl3a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IwQggl3a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762811679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EmT9lB9Tpdaajl8JxL155rfWoOARqjaiZjeyvl/JEvY=;
	b=IwQggl3amrztCq0PT/5h1IgrjAsBcJFChsE1k1MyullTNP9CsLC2icum5orJr1/Nsg3IS2
	VvNFIZ5Q38oe968/3hKhJR0Ic9pBSuRLg56RnV+jExrfiXK4l+ByZJA50x4jteXDoJnvyY
	Wpj1BeITUIyoWil5u4SXJm79rCl/61k=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-306-JE9rq45qM-e69AttsGcEFA-1; Mon,
 10 Nov 2025 16:54:36 -0500
X-MC-Unique: JE9rq45qM-e69AttsGcEFA-1
X-Mimecast-MFC-AGG-ID: JE9rq45qM-e69AttsGcEFA_1762811675
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3721819560B2;
	Mon, 10 Nov 2025 21:54:35 +0000 (UTC)
Received: from [10.44.32.60] (unknown [10.44.32.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39DBF1800361;
	Mon, 10 Nov 2025 21:54:32 +0000 (UTC)
Date: Mon, 10 Nov 2025 22:54:27 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    michael.christie@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH] dm mpath: enable DM_TARGET_ATOMIC_WRITES
In-Reply-To: <cbe9170c-53a3-42be-affc-002f00b384c2@oracle.com>
Message-ID: <7217fc3d-3619-3c49-14a0-9bab8fa4abfd@redhat.com>
References: <20251028150805.1564068-1-john.g.garry@oracle.com> <cbe9170c-53a3-42be-affc-002f00b384c2@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1s_ngllVBFB77MRlcKPIFMBbD3IrQTIjfe46Yzfdd70_1762811675
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 10 Nov 2025, John Garry wrote:

> On 28/10/2025 15:08, John Garry wrote:
> > Both the bio- and rq-based paths have no problem supporting REQ_ATOMIC,
> > so enable DM_TARGET_ATOMIC_WRITES.
> > 
> > Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> This is just a friendly reminder on this change. It has not been picked up
> AFAICS.
> 
> Cheers,
> John

Hi

I've accepted this patch. Sorry for skipping it in my email.

Mikulas

> > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > index aaf4a0a4b0ebb..5dd90b2cdb9bb 100644
> > --- a/drivers/md/dm-mpath.c
> > +++ b/drivers/md/dm-mpath.c
> > @@ -2307,7 +2307,7 @@ static struct target_type multipath_target = {
> >   	.name = "multipath",
> >   	.version = {1, 15, 0},
> >   	.features = DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE |
> > -		    DM_TARGET_PASSES_INTEGRITY,
> > +		    DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ATOMIC_WRITES,
> >   	.module = THIS_MODULE,
> >   	.ctr = multipath_ctr,
> >   	.dtr = multipath_dtr,
> 

