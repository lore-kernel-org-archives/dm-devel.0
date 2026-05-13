Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C80313E21
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 00:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778633972; cv=none; b=Py9wsQqCKba+MTkGW087DPHlIudbeXqbnatshvYMjD/MPC/e6C+KMb3Rq/RgG1p+aqsA2CpXtL987kDeaF9Wy6swm5lowBBu7XZ8MAmAh34+rKmViY1XVe0u9ojPc1ElGiMSlsZJktugrgYJNzuRdGbFJtuQlN5l4F9RHrMxhvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778633972; c=relaxed/simple;
	bh=VW5X6WEykRevzZQe0iGFWotaZqeP9dKnz4c2pYJf77c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=X6Ytk9M4nvU8E/Vj++BBPij/LJ+mCgXpM24QVVs+nROD6pP3andk3KG696ns2iFHScqmkNOZQyL8nJtreaqVvNhkGLWX7GexsXRellrzuC4P8aJ3+IrCNpSn2QHK8cXYDSku+W3qYJkb8xBCCiS+J2tJpJmqQcay0wjGcuBaHyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FSBB1nsN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FSBB1nsN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778633961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XzZmkQDR//Pk7HTd66A85BvJehvq5NMZ0SiFBDuxzTE=;
	b=FSBB1nsNu/enoJDQqQNpJIisoZiLT0wSyKem3wKHGw9+tq2/dj6hK18JudrFmWow4Sze4S
	QKPjTIstCEG4OQQNYTvUHV3kePc7sZu1+8ZY6WBgua/WPJGyB/ALMJKh7bRQhfPd3/wg01
	VXUNzMNO10NnIq8wP6ztqy4ju8+sdGg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-WKFcBTINMpWA4zU-M2vEPg-1; Tue,
 12 May 2026 20:59:17 -0400
X-MC-Unique: WKFcBTINMpWA4zU-M2vEPg-1
X-Mimecast-MFC-AGG-ID: WKFcBTINMpWA4zU-M2vEPg_1778633956
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 887DA195608F;
	Wed, 13 May 2026 00:59:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54A6518004A3;
	Wed, 13 May 2026 00:59:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D0xE203332073
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 20:59:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D0xEHd3332072;
	Tue, 12 May 2026 20:59:14 -0400
Date: Tue, 12 May 2026 20:59:14 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 10/18] libmultipath: checkers: add support for async
 checker
Message-ID: <agPM4kAJv-QAXG1m@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-11-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-11-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _SVUyQmz39wLWOLKB9n5ccdcJQq8Q5ed2hpKBtOcUrs_1778633956
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:24PM +0200, Martin Wilck wrote:
> If a checker shared library contains a symbol "libcheck_async_func",
> use this as a callback for the async checker functions, and do not
> read any other symbols from the .so file except the message table.
> 
> Checkers can provide a symbol async_context_size that will cause
> the async_checker code to reserve extra space in runner_data for
> the checker to use, and a symbol async_init() for initializing
> this private context.
> 
> Only emc_clariion will use the latter functionality.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
async_context_size and async_init() don't exist yet, but otherwise
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

