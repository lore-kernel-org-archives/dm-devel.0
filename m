Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5626B13DB8C
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712679166; cv=none; b=hgHr3P86CjXSiFCIN4RmwujUVkqlo9kRhVc3mnPPYACTHR2qbd8ghe6fNwT0QAIWn83gLhiU/Ufqa815sGHIYiRGgpaHSPsQKBUh3x+0vnqSWXdj+kglsJqxpxFOd7skbvwc5z19wd5Akf9apdj/A3ppl63+W2MvrfIOMeX+kbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712679166; c=relaxed/simple;
	bh=AzOJGFQbXrti8Gb7iqTbfesPxxWDKrVBWc6tEpPYjIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ZVOH+CNtO8GiV2gvTxiAIH9KP+Ty2jJR1uMsqpaOmJ/Lg5/F0frqdZ9VcrTQlj7m2feycdL8PDOvHtUWH7yGe0xygii5sE7A9Ywjanr+M9TyPpmYNTbTMk1+SOr3TjwODFelpPVM/DSXf7WRUJNPpX9M5Y4dB0Srfu+bFlemHFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Imr4gVzl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Imr4gVzl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712679163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TW1jfD1wd4MJs6TRBYRGHtgo2y9z8utDrhHt68W9pEw=;
	b=Imr4gVzloc3CqtD3vN53DlFwze47IJlhssFbOwBFOiJokflU6h+nF94J2pFFUnjskck1mQ
	8TDLK9Gm6kwiUI2oFULhukO62DOj+HkieymhPi2L5aICe4FZ8qtl806uXkWlyrHrohVXGA
	+Rz6JgjuyVKxCM8zo/G60xtSIvdrrJE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-68-2ONdsUQ9PZeUokg_pknAEg-1; Tue,
 09 Apr 2024 12:12:39 -0400
X-MC-Unique: 2ONdsUQ9PZeUokg_pknAEg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 645BE380673D;
	Tue,  9 Apr 2024 16:12:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49E12444303;
	Tue,  9 Apr 2024 16:12:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 439GCckK1829523
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 9 Apr 2024 12:12:39 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 439GCcrh1829522;
	Tue, 9 Apr 2024 12:12:38 -0400
Date: Tue, 9 Apr 2024 12:12:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] multipathd: make multipathd set priority to RLIMIT_RTPRIO
Message-ID: <ZhVo9uHMm3-F1MIe@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240329182813.1455019-1-bmarzins@redhat.com>
 <f6654d3ac12ff4621942e409340b29bb23d959b3.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f6654d3ac12ff4621942e409340b29bb23d959b3.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 09, 2024 at 04:38:57PM +0200, Martin Wilck wrote:
> On Fri, 2024-03-29 at 14:28 -0400, Benjamin Marzinski wrote:
> > With this change, if the SCHED_RT_PRIO compiler flag is not set,
> > multipathd will call getrlimit(RLIMIT_RTPRIO, ...) and look at the
> > hard
> > limit. It it's 0, multipath will do nothing. Otherwise it will change
> > its scheduling policy to SCHED_RR and its priority to the hard limit.
> > 
> > This allows users to change the priority of that multipathd runs with
> > by
> > adding
> > 
> > LimitRTPRIO=<prio>
> > 
> > to the [Service] section of the multipathd.service unit file. Setting
> > LimitRTPRIO=0 will make multipathd run as a normal process, while
> > setting LimitRTPRIO=infinity will make it use the maximum SCHED_RR
> > prio,
> > which is 99.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> This looks good to me, but do we really need both the RLIMIT_RTPRIO and
> the SCHED_RT_PRIO mechanism?

Not if https://github.com/dracutdevs/dracut/pull/2563 ever gets merged,
we don't. Until then it seemed easier to keep a knob to let us control
this ourselves, rather than try to sync with a change in dracut.

Obviously, I'm still not convinced that it really matters whether or not
multipathd is running with SCHED_RR, so we probably could just say that
until dracut gets updated, we just don't run in SCHED_RR in the
initramfs. I'm fine with pulling the compiler flag if you want.

-Ben

> 
> Thanks,
> Martin

