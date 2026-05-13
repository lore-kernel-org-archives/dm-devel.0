Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87DD3168E1
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 01:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778634379; cv=none; b=MD22rfZEv6xv6QrEdWEufG8QGiLKHA7lE4UBWt9o3fbsTd9XFAKm3utlJAtpd2dnSFPPHU8C4YJyIR729TUBHopQWZUhGHkClDbnQe0IiCZzqw0ptw8IrIBxcZPfFxCJVFSRMQWH6nyZ1H8EWzzGeHKvkqhd89CK4KgKTLWg5sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778634379; c=relaxed/simple;
	bh=wGhgxyfFFDHbgaLLK91eRQpeQ/kRES4pvzonbmK5pzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=JxTEtsO8FwxzNIZduOy38dSbXdqyumVsLDEMwIBRJ4pn04S+CQ2ZQvv0I9hFRaHNf7fipjlRtyiBF2UIHVLD83hKfv6Fw0pq9DxgEOYXVSdtjtvT1/mtVis18VWWS0FdAadK+8KaI8pI0SDjE0YLPJRCm6h2T/WTS2qFvNCdLJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ChswqBAl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ChswqBAl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778634375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DNGVwlHwwLzI2s5lnXblTUOAZMk6PW3qqRljjRN+j6I=;
	b=ChswqBAldYhIC98jkpXq06Z/3gbPC9/Jgyy+aieQLE+RveVxMsdL5KyNv12iJ3Wv2M15v8
	qFBiTse0HgMJTVg4fu1rBiIJzRhdTbbhoXoD9sA8ZPn9UbBubRph7PpHdYYn11mylJJUic
	7JC5Eq9uGLzh8mqFk2hgH4Y8NYJdw4A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-655-TxZ40B4IN5-NcalnT4XoWA-1; Tue,
 12 May 2026 21:06:10 -0400
X-MC-Unique: TxZ40B4IN5-NcalnT4XoWA-1
X-Mimecast-MFC-AGG-ID: TxZ40B4IN5-NcalnT4XoWA_1778634368
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9C4D195608F;
	Wed, 13 May 2026 01:06:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 85D78180058F;
	Wed, 13 May 2026 01:06:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D167tq3332356
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 21:06:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D167JO3332355;
	Tue, 12 May 2026 21:06:07 -0400
Date: Tue, 12 May 2026 21:06:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 15/18] libmultipath: convert hp_sw checker to async
 checker
Message-ID: <agPOf27fnyJdqRHe@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-16-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-16-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FENYbv1sfSH3t3fnVTgxSNIpdtsRSGWPNx8Eg83MTvc_1778634368
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:29PM +0200, Martin Wilck wrote:
> Make the hp_sw checker use the async checker framework.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

