Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942B81E413A
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 18:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725474604; cv=none; b=mx/S1CSD73bdWHl0dsTMNy9GnYqvvLEiIWtOULYFlwwPmB0gGw6RM5dSfoXDNhYiD3zj3R3XwjhjzNntgFF8dQJSsRFFLBcf8jf2muxVj9fFNLQQVPCrcuqDdbXH4Xe6qH78T8Byj9fDg1nIxicJC/PJYBV634Qi35ZiDnCXpoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725474604; c=relaxed/simple;
	bh=OC3jCg6VleVy8/UJAmH/B2v9Bl6HijYh2f8HkpNsLQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=K07p6hgrYcb6mhsziiusFA+/49Q+OGxsz8r+dWudBMMCcM1MSFCgNvb4N9zV0aRoGue5tNKmIsES0YFiZHOCUVfqzID5Xz0SI9q2tm7z5hOoFYAu7FZJa/EbpVqBATlGagaUNYoeJ3Q2F7G/MuNkhtgZsrOH1l/K3He3gkneILU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fpnDFHrN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fpnDFHrN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725474599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CDzpUCmqc6Wt3Reb6Se62hiQRYVvKUPY+9EfZZRaPII=;
	b=fpnDFHrN3SZqP5aluxnt6Em8aqxRR1jpUWXntRvEY3oR2fUmIXFz3AHjBZtT8waT+6gSFn
	+0AesMsaVpTfRMXiVIVx5eBEx4sdYaqA79e6tmLx9R5/l1iSsBNeQ5iUbqDOp3kgyY1WrE
	1sfWSTmxETXZyMtrjqP/6NaXwXnA+2s=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-KrFbNtW1N-ytNvoJaPtH2g-1; Wed,
 04 Sep 2024 14:29:56 -0400
X-MC-Unique: KrFbNtW1N-ytNvoJaPtH2g-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D558F1955F29;
	Wed,  4 Sep 2024 18:29:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9706D19560AA;
	Wed,  4 Sep 2024 18:29:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 484ITrXn480030
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Sep 2024 14:29:53 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 484ITrtZ480029;
	Wed, 4 Sep 2024 14:29:53 -0400
Date: Wed, 4 Sep 2024 14:29:53 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 05/15] multipath-tools tests: fix up directio tests
Message-ID: <ZtinIZY2jMe0ZDNX@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
 <20240828221757.4060548-6-bmarzins@redhat.com>
 <534d539850c59ac55911bdd584737934cb24d060.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <534d539850c59ac55911bdd584737934cb24d060.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2024 at 06:12:37PM +0200, Martin Wilck wrote:
> On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > Make the directio tests work with libcheck_pending() being separate
> > from
> > libcheck_check
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> There's still something wrong with this test. I'm seeing lots of CI
> errors with your complete series applied.
> 
> https://github.com/openSUSE/multipath-tools/actions?query=branch%3Atip
> https://github.com/openSUSE/multipath-tools/actions/runs/10704501258/job/29677643779

It looks like your "tip" brach is missing:
[PATCH 04/15] libmultipath: remove pending wait code from libcheck_check calls

-Ben

> 
> Martin

