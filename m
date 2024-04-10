Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9B2158D70
	for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759457; cv=none; b=SZ7js+njjcdGT8zSI0e44b1IskulEcLbwwTv68K7sHRX5KiEulN0d0p/rzwGwd4CBMonAfl7/athimDv511BOR3jXZZSkYdH6unBn0BOiOZJ4BfqWoOfUf/ZzxmM3V4eoCd1ycyd/OYM4G4y3KkPs/Cjgyxewqaf+kfZrFE+KEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759457; c=relaxed/simple;
	bh=HoRdY4U8jiSiFT10MVv1jVL2TKyfMXDDxqVTAPQiyKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ibcog1INMIe3t5fTFscMGwXcbpfMZy0wIuoyCnKks9XuVnRPPMWFODJKPpONPi1oxVkrkcjbrHzKOexHHL+cQdbZ3ASQ8Qsj74l2xnvaIIk9sd6Bi7GJt5BfjArYjYoIenO8FVVQ3E43n4xO9EBBPu4fV77SnT29uawaH4pl9Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UUw0XAXh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UUw0XAXh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712759454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=txCV/NBDhufTCOlI9CyswAWIzx3N5wImKYpzFmcHHgo=;
	b=UUw0XAXhV2dd+mSR2srmrNpEj/FdQjELsgTTqSX3E0W257FeqBI+/MbqbL+2NE0+wRIMF7
	SS0e5w0wJTUXMrBbPG4tkgjhpG6XrUa9p4AdKgo83KFHhxnQ30JODWHy9w8IHp8LQIca4L
	k4N24QZ6dPpvaPy2c3eCnMg7CqxLQ8g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-Xl82o29HMaa11X0XIXEhpQ-1; Wed, 10 Apr 2024 10:30:50 -0400
X-MC-Unique: Xl82o29HMaa11X0XIXEhpQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0963830E76;
	Wed, 10 Apr 2024 14:30:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6BCD40C5FD;
	Wed, 10 Apr 2024 14:30:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43AEUn9u1845341
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 10:30:49 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43AEUmle1845340;
	Wed, 10 Apr 2024 10:30:48 -0400
Date: Wed, 10 Apr 2024 10:30:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2] multipathd: make multipathd set priority to
 RLIMIT_RTPRIO
Message-ID: <ZhaimLF4MYCPH7NF@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240409225612.1837905-1-bmarzins@redhat.com>
 <19375aff6ea5ad4dfc4cfc64ec7efbf2f8a4c8d5.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <19375aff6ea5ad4dfc4cfc64ec7efbf2f8a4c8d5.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 10, 2024 at 10:37:38AM +0200, Martin Wilck wrote:
> On Tue, 2024-04-09 at 18:56 -0400, Benjamin Marzinski wrote:
> > With this change, if the SCHED_RT_PRIO compiler flag has been
> > removed.
> > Instead multipathd will call getrlimit(RLIMIT_RTPRIO, ...) and look
> > at
> > the hard limit. It it's 0, multipath will do nothing. Otherwise it
> > will
> > change its scheduling policy to SCHED_RR and its priority to the hard
> > limit.
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
> > To keep the existing behavior, multipathd.service now sets
> > LimitRTPRIO=infinity
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> I will wait a while for feedback on 
> https://github.com/opensvc/multipath-tools/issues/82
> before pushing it to the queue branch.
> 
> When it's pushed, I'll squash it with 1c4301a ("multipathd: make
> multipathd scheduling configurable"), if you don't mind.

That's fine.

> 
> Thanks,
> Martin

