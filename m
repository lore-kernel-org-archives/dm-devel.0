Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA6D351C3B
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 01:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778634599; cv=none; b=fqLfSuLJny1WNgmIi5uxD3CbRb0mIAoIEPOkNIilduY27PeNzC5d6pq/4OaSKj9uOCsRekwecCw/GTXwycKdjKz1/X2mlwYSFVvSG7Yn0gRUEm+UZz8rCqeket3SBmiEyhAmCmOt9jM2lKztWZhqSXSBpHtXK+SVsmcDUew4Q/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778634599; c=relaxed/simple;
	bh=avCfCja/66iE0o6vUrg1+AYvJA23QjMi2nE1GbSvWWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=GNP8lJJ/O4xQ8W+A3GCz6yMaCb9dXfDynOrgM3d/nCskDhGUuXjZUHQo2YK+QSwjSTIFaJTDrMZGA8ul+52EYVJTdhcbnJ6Dfk+Iy74d4WP3zAdYMXGSSdFy3Q/fo7Zei0OOUP4mFcLMW7EfmwfSWBPF0axgNnU244YV16Yw0JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dA6D/s0U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dA6D/s0U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778634595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43oVG6//4APSmUiNGCGzC3gfCe5uPeT3s7GmASEG5D4=;
	b=dA6D/s0UzHmPcg/tnApKQNEggu2Ix8m6TdkbHnFUuP470GxYmx6htFFjWDMkJT3wq+XPG7
	hjUZjYe+Rb7KTSRwHoSR4q1u2AGbDpgaRAZplblkbub+wTAcYhPSJQrz904zBf/IMKmhTf
	87u8C+W4MvaPEgiIEvyTjUyxPcJD6z4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-208-l_1-ZGTDODWYK2jBGuMzmQ-1; Tue,
 12 May 2026 21:09:52 -0400
X-MC-Unique: l_1-ZGTDODWYK2jBGuMzmQ-1
X-Mimecast-MFC-AGG-ID: l_1-ZGTDODWYK2jBGuMzmQ_1778634591
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 16204195608A;
	Wed, 13 May 2026 01:09:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC3171800465;
	Wed, 13 May 2026 01:09:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D19nXK3332461
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 21:09:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D19njI3332460;
	Tue, 12 May 2026 21:09:49 -0400
Date: Tue, 12 May 2026 21:09:49 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 17/18] libmultipath: checkers: rework mpcontext passing
Message-ID: <agPPXU9cckw-iaL3@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-18-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-18-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q8b6YtnkT2AvxrGkRAkm8E4q-DJ1fCA5t2HFC7hGUjc_1778634591
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:31PM +0200, Martin Wilck wrote:
> The emc_clariion path checker requires an "mpcontext" that is shared
> between the checkers for all paths of a given multipath map. This context
> is currently represented in struct multipath as a void *, the pointer to
> which is passed to the checker. The checker allocates the actual memory in
> the libcheck_mp_init() function, and changes the pointer in struct
> multipath. This is a dangerous layering violation as the checker operates
> on memory it doesn't own, and not type-safe at all.
> 
> This patch changes the mpcontext handling as follows: The void * pointer
> is replaced by a dedicated union checker_mpcontext. It only contains
> a long integer element, which is sufficient to store the information
> needed by emc_clariion.
> 
> Instead of initializing this value in mp_init, the address of the union is
> passed to libcheck_check() and libcheck_pending() if the path that is being
> checked has an associated struct multipath. Passing a union pointer
> improves compile-time type safety. In order to check whether the value is
> initialized, instead of testing for a NULL pointer like before, the code
> defines an INVALID_MPCONTEXT value. This value must obviously be chosen
> such that it doesn't represent a valid context value, which is the case for
> emc_clariion.
> 
> For a synchronous checker (like emc_clariion), libcheck_check() is allowed
> to write to this memory, because at the time of the call we know that
> pp->mpp is valid. The same holds for libcheck_pending().
> 
> This change requires checker_check() and checker_get_state() to be passed
> a "struct path *" rather than a "struct checker *". The layer separation
> happens in these functions now.
> 
> The async_checker code also gets an implementation of mpcontext handling,
> in preparation of converting emc_clariion to an async checker.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

