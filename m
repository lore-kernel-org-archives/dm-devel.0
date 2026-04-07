Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D693DBA0
	for <dm-devel@lists.linux.dev>; Tue,  7 Apr 2026 15:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775574833; cv=none; b=HKyjTZYQVpiOJKiZi7uTKMLAIBtc+fB3M9jrsRnXihRLacr6wFsnS6qJ/Zw7x5DhNY/OO18uJDMt8umr3oNK6+6EYSlG3p6UeTauxMObEDVy7IqfeQ7wTS0nrnXXL64BCrlZbzPbuMb8zjE3vLDbGrR7sqvWlKpVyjKAEVHOdBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775574833; c=relaxed/simple;
	bh=a7rV+Y3kr12HvpJkEQPCWQ50lNK47XYDqRh2dRSOiWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=M/fLF8pX40xQq5LrCCFR+/I7t86r37+WpXB7s+DYIUWBBjfBqYFzc6saL0SOv1FMtlN9t74cljxbq4FeTU1kKpLDHDL17aMvq0LTyj1S7LJlHYTjVrk7wtibRnhzMNW7vWPzDlJnao1TZhZjATl8ypaWfND2V3CgU7rVZm/xDBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WBS9rB2S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WBS9rB2S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775574831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0WSJXSfZ3mN7CBsHTVsguiR8jH1JqSJHO983MeWzH9g=;
	b=WBS9rB2SWsXBaqdGIZWrHXdufNC6pvOlgaeEGPQSpYFSiMIS9GL1REbysyEEdm9/U2+xvI
	EpRKkETfmvDyC5FS3EUVuaRxUhbcr3CthwND3ac0SnVair7EjsaBewaV/kEorD3g+1+XmZ
	5hJnBEEWuvUaRorgRNsuQPbgS90DYbw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-578-aam-Q3JlOHCu7V1_g1O0Sw-1; Tue,
 07 Apr 2026 11:13:46 -0400
X-MC-Unique: aam-Q3JlOHCu7V1_g1O0Sw-1
X-Mimecast-MFC-AGG-ID: aam-Q3JlOHCu7V1_g1O0Sw_1775574825
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 917FF1956096;
	Tue,  7 Apr 2026 15:13:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2333B1953944;
	Tue,  7 Apr 2026 15:13:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 637FDhJQ1671040
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 7 Apr 2026 11:13:43 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 637FDhtF1671039;
	Tue, 7 Apr 2026 11:13:43 -0400
Date: Tue, 7 Apr 2026 11:13:43 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH] libmultipath: Handle SCSI-2 style vpd page 0x83
 descriptors
Message-ID: <adUfJ-iJVpUZuJrL@redhat.com>
References: <20260327034136.1157685-1-bmarzins@redhat.com>
 <36483a48-bf89-42da-be3d-303f3560d2d7@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <36483a48-bf89-42da-be3d-303f3560d2d7@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9fRBl0YfjDY-GwcVm0Uu2Gz1pMh42d3caHfWy__YErM_1775574825
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 07, 2026 at 11:14:34AM +0200, Xose Vazquez Perez wrote:
> On 3/27/26 4:41 AM, Benjamin Marzinski wrote:
> 
> > Some older SCSI devices return a SCSI-2 style vpd page 0x83, instead of
> > a SPC-2/3 format one. The SCSI-2 page 83 format returns an IEEE WWN in
> > binary encoded hexi-decimal in the 16 bytes following the initial
> > 4-byte page 83 reply header.
> > 
> > Check the 7th byte of the vpd page 83 buffer to determine whether this
> > is a SCSI-2 or SPC-2/3 confomant one. Byte 7 is the 3rd byte of first
> > Identification descriptor in a SPC-2/3 confromant vpd page 83. This is a
> > reserved field, and is guaranteed to be 0. If it is not zero, then it is
> > likely the 3rd byte of a SCSI-2 Identifier (The first 3 bytes of the ID
> > are the Organizationally Unique Identifier). Both the sg_inq and scsi_id
> > commands handle vpd page 83 this way. To make sure that the WWID which
> > multipath reads directly from the device matches, it should handle this
> > format as well.
> Out of curiosity. Did you run into a specific old device that triggered this,
> or was this found by code inspection ?

It was through code inspection.

-Ben

