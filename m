Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3628134CFC2
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 01:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778634335; cv=none; b=Xe4snUrg7a8ztfhkh+5m2q00dIrjF2gCZ4j41jNDakeUhZb7vLkl+TsPfKbYc2wUz8kx5zYoYjghEgZ4GHmp2Ww6Q3mvfQxBpxM6+kU3sxmFKBpya+kY0g5l7r9iPmU2aBrvB2U04Ew5iIDrC3Qok50yHb/5e05TnF3JGxLWhHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778634335; c=relaxed/simple;
	bh=ZbaUdg4MF129pXVpIdkmmliQUV0d0Q4BnsXNmt2zJjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=PDNLCEqBJfQf0UdXZUDOOP9fZhMULpLAsmMj1bQXgf9zcJqKdHcp/dKkghkmDy2kfbUYpru/dvWix10ZteOks8O2ZgLjvraUyPIwGnEFv9NsMjCTx/V9/FZ27e9z7biLM/m765G72YR6Ax+6VPrkaD2SQmAx3YjI9wmIwBlzMeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SP/CjTSq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SP/CjTSq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778634327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6IECL/UX4KqRTzzWITX/yZotUOJ1XcUOTid39/PJlek=;
	b=SP/CjTSqtKD7KGrjF5gkji5j2amnAuxS47WgDzApdQGdULWrl1MTnfLRunpokXGAUVJJn2
	2B10BgWfEgDtp3cj0KREeFggeazZw42LtE+jlPUe9FWESKPKMV+FXnbjZg7CmuSsjlLi1n
	ik8epTs6S/JdwQc63Gyr5eZqKpO64mY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-XPsRTRGFMn6_l7-1jtwvSw-1; Tue,
 12 May 2026 21:05:20 -0400
X-MC-Unique: XPsRTRGFMn6_l7-1jtwvSw-1
X-Mimecast-MFC-AGG-ID: XPsRTRGFMn6_l7-1jtwvSw_1778634319
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4CEC1195606D;
	Wed, 13 May 2026 01:05:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16F3919560A7;
	Wed, 13 May 2026 01:05:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D15HHG3332322
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 21:05:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D15H0x3332321;
	Tue, 12 May 2026 21:05:17 -0400
Date: Tue, 12 May 2026 21:05:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 13/18] libmultipath: convert cciss_tur checker to async
 checker
Message-ID: <agPOTSYKf61VNzBu@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-14-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-14-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C9TBz9oUzg6lhgSYkCyLjEUmXkDxEzDtInPmLQ1n8oc_1778634319
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:27PM +0200, Martin Wilck wrote:
> Make the cciss_tur checker use the async checker framework.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

