Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7944C298CAB
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 00:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633129; cv=none; b=CKDPzEu6Wt2VezaykATMuD1tU1glLo6vLY469g1BHmqhLW3AVfk9nyq/yPXCH4N/m6eGz/ea5cxrM/2KfEC7352gQ7NKvvnGh9Zu+FMd16eTvPL2+nvKg3NIm+iPgxtBaagzrTSgz3VNb47rV5/8+KBJ7gAz+V/tXXNZw0oBHeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633129; c=relaxed/simple;
	bh=m4MLX+RRcXS7jjyRgiucMwQJO9q+sV7OwQtqOUqe3mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=peUB6x8VgLAQ9+yqoXRero7UJr6pjA7mHn0jVQ1skwHj9Guml9a19r1++XzOjx1hTJI9heCr96plpchb5bS9K1eEFBJEpyB2z1/iCdUCLS/Fyh+/f/zE94T8OZd2osi/538ElVZ+sA89DStzqV+JXGkDqSoA5uBXwm7HXnT8JCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FPmP4/Rn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPmP4/Rn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778633126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gflYnwmC+qtjX3XiZBEDIpBN/1dCxWoQ+TxM1vHtrOE=;
	b=FPmP4/RnYlfJjp8BUTbZ41TU2L2k82IDkyxA3UeY4U+1zxXCw8YHi1OrfGFmQ4Bi8A1/aV
	uYVzfcw5z/CS9TniN8JIDG+Gh99j6CqqfDFxjnqCeYzsb1Hpwuo32T/Cvn1TR5iNuKL7KS
	nBRejNywl+EuWppKZPfK5IJHblidElc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-342-DSDbN8mUPkuAf2CzlxAAfA-1; Tue,
 12 May 2026 20:45:21 -0400
X-MC-Unique: DSDbN8mUPkuAf2CzlxAAfA-1
X-Mimecast-MFC-AGG-ID: DSDbN8mUPkuAf2CzlxAAfA_1778633120
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 088851800343;
	Wed, 13 May 2026 00:45:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B51CA19560A2;
	Wed, 13 May 2026 00:45:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D0jIx53331713
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 20:45:18 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D0jIn43331712;
	Tue, 12 May 2026 20:45:18 -0400
Date: Tue, 12 May 2026 20:45:18 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 04/18] libmpathutil: add implementation of generic shared
 pointer
Message-ID: <agPJnkBDaaQgii_b@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VOYGh28e6JwxKH_jOsKjhnBH4SNj76_y4-ydaNxVTes_1778633120
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:18PM +0200, Martin Wilck wrote:
> Add a set of simple functions to handle refcounted pointers.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
> diff --git a/libmpathutil/util.c b/libmpathutil/util.c
> index 23a9797..3c623ec 100644
> --- a/libmpathutil/util.c
> +++ b/libmpathutil/util.c
[...]
> +void get_shared_ptr(void *ptr)
> +{
> +	struct shared_ptr *sp = container_of(ptr, struct shared_ptr, ptr);
> +
> +	if (uatomic_add_return(&sp->refcnt, 1) < 0)

This is fine, but what about using an unsigned refcnt, and checking if
this returns 1? It would catch the cases where wrap-around happened,
but it would also catch if something incremented a freed pointer. Just
a thought. But like I said, this is fine as is, so

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> +		condlog(0, "%s: refcount overflow", __func__);
> +}

