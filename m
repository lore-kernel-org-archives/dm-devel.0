Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18FB285CBA
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 16:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769011343; cv=none; b=gc4Fmu3vigZAEAR4VVwLV/5J3xwFmpsQQXFehGnu4S+4tDciYJqXkz+LG0O5+Ck6DSQttK+gQoVAqxfi8mxuOlAB9NwDobZZKLZq9NZRE+H9LDgkKhBr2PHXPbYumx2fmYfeMShVdpSt1J16tmM9ZX7eTGz9jaxn8jOysXa5Alk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769011343; c=relaxed/simple;
	bh=ATnObeCoEHqFUM1RYN+3i7gk73GG6OeXohdFOZ7QZcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=RoCU5QIw6KA0gu+RdMmGVfx+2ShIZj7StT4xTItctUeBEmyenfcZdDmWlRiJPo9dkljzh4Ctx7HzIh5lmRLJmXLsonM3In5R8ggQY1SuUfbRNZTuvPfO++5hP1SboKcQmY9bIu4nhfNefPcj7Oifb/cwGlEqZKUe3gmt1BmJs84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XZ5DwtRJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XZ5DwtRJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769011340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wcgOUrvoIOa6w5i9GYOINP/p4KOt9xKidwHRe7iB2w8=;
	b=XZ5DwtRJ2pmDEFVuxW/M/PFlZkQizZjnAyLbq/sV1ePNFbIWGkbWdWNsC9kqg1u4cMqevm
	GsJud0n+4SW+MmYJZJnbFTVyAOKKDkaE6cj7I8jt/xJ84yN6HMP/IpzcW4g1IXGCj4+asp
	YVv0mRsBnivCXZpJGWa/HYlGAxRPKIc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-320-m8-DV9C8N8SpqvnNiO993g-1; Wed,
 21 Jan 2026 11:02:13 -0500
X-MC-Unique: m8-DV9C8N8SpqvnNiO993g-1
X-Mimecast-MFC-AGG-ID: m8-DV9C8N8SpqvnNiO993g_1769011332
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E372D19560AF;
	Wed, 21 Jan 2026 16:02:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABB5A19560AB;
	Wed, 21 Jan 2026 16:02:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60LG2A0C3932687
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 11:02:10 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60LG2A3F3932686;
	Wed, 21 Jan 2026 11:02:10 -0500
Date: Wed, 21 Jan 2026 11:02:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 4/4] multipathd: print path offline message even without
 a checker
Message-ID: <aXD4gokRK8GZYSFY@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
 <20260121042315.3914707-5-bmarzins@redhat.com>
 <cb0311f9641a398981a543a3698a5395edb27165.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cb0311f9641a398981a543a3698a5395edb27165.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s2fV80IV8_jX3bL8-cWisqebhUNZ0BsKYo_KZpPiKK4_1769011332
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jan 21, 2026 at 10:00:21AM +0100, Martin Wilck wrote:
> On Tue, 2026-01-20 at 23:23 -0500, Benjamin Marzinski wrote:
> > If a path has a checker selected and is offline, multipathd will
> > print a
> > "path offline" message. However if the checker isn't selected, for
> > instance because multipathd was started or reconfigured while the
> > path
> > was offline, multipathd was not printing the "path offline" message.
> > Fix that.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/main.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 2140e432..69e4808f 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -96,12 +96,11 @@ mpath_pr_event_handle(struct path *pp, unsigned
> > int nr_keys_needed,
> >  
> >  #define LOG_MSG(lvl, pp)					\
> >  do {								\
> > -	if (pp->mpp && checker_selected(&pp->checker) &&	\
> > -	    lvl <= libmp_verbosity)
> > {					\
> > +	if (pp->mpp && lvl <= libmp_verbosity) {		\
> >  		if (pp->sysfs_state == PATH_DOWN)		\
> 
> While at it, we should probably change this to "p->sysfs_state !=
> PATH_UP", because start_path_check will only call the checker for the
> PATH_UP case, and in other cases, the checker state will be stale.

Sure, although I'm pretty sure that will just mean that removed paths
might see a final log message, since PATH_PENDING paths won't see any,
and the only other sysfs_state options are PATH_UP and PATH_DOWN.
Actually, if we print an explicit "path removed" message, it could be
useful on the off chance that a removed path didn't transistion to
INIT_REMOVED like it should.

-Ben
 
> Regards,
> Martin

