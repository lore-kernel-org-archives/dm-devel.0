Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D71237B3FE
	for <dm-devel@lists.linux.dev>; Wed, 22 Jul 2026 21:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784757084; cv=none; b=av2H+yIXgpUQAjcTT+FR7FnCSNQN0mePrMfdDFYnb5qDGlAfjGbX1y31RoWdn4KtJEMhiSTV593n8G1wjJqzNzvMt1bUT4cisALwv2GC8uGIj009FYX1s/gRSqFjeyVvAPGt6jvoVKCnAkI76w2Q++IY+k4YHrsaH2NzyKnl8cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784757084; c=relaxed/simple;
	bh=A89aPnJvN7nwUbwnzRq98S7PbQkxYbJeJ24yMHDyCi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=uLQZkXHaNza4jXL3PVs5zVZdfLsWgnsvZahFmwMRmTWddV530T+KN1qFrjaAfHjagmPRtPKh8qWvBLo8g/3QWz1j2ivtkmMFvp7szJGVEq3b0xCgAqZBNaQuCBdEv4aevs+Ha9lm1JNcAy150WCbc5ynYt3igdzWa+kDaBShwFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D3xNC39S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D3xNC39S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784757079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0QwT059jFpVl6VxEpIrQLw1FVwZ3PY+yg3iVpwJjx/s=;
	b=D3xNC39SAVvbEajvwyV08XM0FvghL42tXwShaTT7qkQm7ooc1XkeJEHyAMH4kQsLKtdPPP
	a7hGZ9zdLlVyd/EULuX2t94Mh6cVwfzDBREgDX3ERJBzIZ1T1cF+aZaNvIFxWBlOcvnKll
	3cDhGsepPlllSKjXTXWgq9MNb/60uT8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-n4mkLDGFMYmXHEgrRJLa6Q-1; Wed,
 22 Jul 2026 17:51:18 -0400
X-MC-Unique: n4mkLDGFMYmXHEgrRJLa6Q-1
X-Mimecast-MFC-AGG-ID: n4mkLDGFMYmXHEgrRJLa6Q_1784757077
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D94C1956052;
	Wed, 22 Jul 2026 21:51:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3357177;
	Wed, 22 Jul 2026 21:51:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 66MLpFMY2538089
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 17:51:15 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 66MLpFHG2538088;
	Wed, 22 Jul 2026 17:51:15 -0400
Date: Wed, 22 Jul 2026 17:51:15 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] libmultipath: async_checker: fix sync checker case
Message-ID: <amE7U1VfiIiozLy9@redhat.com>
References: <20260722210926.507674-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260722210926.507674-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YOc9zLuWuaoazOYmDOkJEFVbEmakGuDZ0qER9urRMiA_1784757077
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 22, 2026 at 11:09:26PM +0200, Martin Wilck wrote:
> In the synchronous case (e.g. if called from multipath), the async_checker
> code called the async callback before initializing the rdata struct.
> Fix it.
> 
> Fixes: 474682e ("libmultipath: add generic async path checker code")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

