Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DAE29408
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 00:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778632768; cv=none; b=jMUmkaR9y3ba/G0fBbeg+K515XfQ/2IEiItwiYW2YYwlyXQJ4HAHyrce7UZs0iwf+p40diIclrrZFPmIbwaqV64kYJOT8TNNsTDPcUtqB70isDa+Up9qLn88nm4WHG2eq52luqYzU/NnWOMdwPWqhQB8fmq93g8h6a8etGggahM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778632768; c=relaxed/simple;
	bh=C9vgYyBrZ8XEVdhEE9DGi0B8elj4LIvwiCFn4urMd9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=BfYOkGKBaDatgyaf/yr/Tjc9jnDLUcollYesOIvR1BEJWw3APgReMuQvPhlpEe4SZ92BOkdauFYlKU9r10sG2de+4hSRRggTNfm7pi3+Tqf/04T5OUPQI+2yKguw4O2X91n5ZfG/yyQulGY4NpX4vjrkRvGj7F2n/0GNQRJgFEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eR6oLiQ2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eR6oLiQ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778632766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4+aJP0YqpfWsTc16rLkX8a/OjyUov/nh/ZF/bsi+eAc=;
	b=eR6oLiQ2otu1uJPD3YQwEuq4iI5xyFoMBJYl7TEqEOc9oADqcRbm9i8SHzt2LgjNlLmjvd
	Cu0EuYUQtoTap6VFdmXn6dz14ipoNG9H3GZ6NKfSxLDB5mJ1vrBJzFWjnzbvKTJW4/nXQp
	RtdU4tF2J/6wQPp/v/ZDatX4tdThRfA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-152-AqhvqQ04NLChrhsZsdDOTQ-1; Tue,
 12 May 2026 20:39:22 -0400
X-MC-Unique: AqhvqQ04NLChrhsZsdDOTQ-1
X-Mimecast-MFC-AGG-ID: AqhvqQ04NLChrhsZsdDOTQ_1778632761
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5379919560AA;
	Wed, 13 May 2026 00:39:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05B601955D84;
	Wed, 13 May 2026 00:39:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D0dJt83331533
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 20:39:19 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D0dJXt3331532;
	Tue, 12 May 2026 20:39:19 -0400
Date: Tue, 12 May 2026 20:39:19 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 01/18] libmpathutil: runner: reduce a message loglevel
Message-ID: <agPIN092zWxEuIVt@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ofEVj_yLZq88VMlehI2RPCDV3TNlyEUFrKy0fuie53U_1778632761
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:15PM +0200, Martin Wilck wrote:
> Don't "log runner 0x7b724a07a480 cancelled in state 'done'" at
> level 3. It's a fairly normal thing to happen.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

