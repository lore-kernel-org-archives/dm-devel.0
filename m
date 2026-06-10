Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F053F3876A7
	for <dm-devel@lists.linux.dev>; Wed, 10 Jun 2026 23:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781134901; cv=none; b=GU0tV/eg18TAe7cpH1klWsYdcs7dcfnm7nuyeqsMCZeXzy5z1iK2PkI+kLnm6GbmdUiAjcLNnwtEE1krH5EuPTzYtxZGLBUdTeulqqK1ef3Igvt0AcFpa1CNa6oqJNg9ofKfvAP2kKkHQJIbClS4GMhb2xbHCLGNs/Pu6iYhkAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781134901; c=relaxed/simple;
	bh=k79tXPiU2dnnanGdNw9QbZbL4Ecb1eA8k142ZNpqpu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hUo0ErtxBfpBvgS39DJPT2hONy73nWiotTTvlF6IqrVQEU5L3adPYqyGqOLONPAY5mvGl3N72MeCeQAnSsiiHp+g/Rz0QDyTA5QOD8kNzASoDAy5QD0pdQienF4ZcTTk4WyKUzo+w/mxPCvtwAI8IAGucJBMEj57fG6K6m1xOlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fV1qCR4z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fV1qCR4z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781134897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kDWhKpcYKFSq0KwcztUL47anQniOkl8nLZJMGg7ZXQE=;
	b=fV1qCR4zVZ2+57RgTcydTf06re6LpVUJ6rq74nYLEfWraixlEpV1SOLugbImEmEPR5BDpk
	6DeSt9i2c/pulbVnLVjgTBsBPnvAqTD5VvGYG0Bs0urDObTn65MTjs5Z3fz6qKeOiLcYPZ
	bibctZOkDh/80L7RvhHciOQj2JU4W8Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-c9rAdHwGOjyWXqbDVAV_Xg-1; Wed,
 10 Jun 2026 19:41:34 -0400
X-MC-Unique: c9rAdHwGOjyWXqbDVAV_Xg-1
X-Mimecast-MFC-AGG-ID: c9rAdHwGOjyWXqbDVAV_Xg_1781134893
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A551F1977507;
	Wed, 10 Jun 2026 23:41:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5507A3008B35;
	Wed, 10 Jun 2026 23:41:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65ANfTYL620966
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 19:41:29 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65ANfT2U620965;
	Wed, 10 Jun 2026 19:41:29 -0400
Date: Wed, 10 Jun 2026 19:41:28 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/3] multipath-tools: remove explicit width from .TP
 macros in multipath.conf.5
Message-ID: <ain2KDdFEKuneKP7@redhat.com>
References: <20260607103831.336833-1-xose.vazquez@gmail.com>
 <20260607103831.336833-3-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260607103831.336833-3-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8oogJjd1l01A6LhkKBOIeGO4vmsYqm3HxKOzeRF8mWs_1781134893
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 07, 2026 at 12:38:22PM +0200, Xose Vazquez Perez wrote:
> This allows man/groff to calculate the width automatically, preventing
> excessive whitespace and improving readability on various terminal sizes.
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

