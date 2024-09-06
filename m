Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE41282ED
	for <dm-devel@lists.linux.dev>; Fri,  6 Sep 2024 17:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725643619; cv=none; b=YtvP5mzQxpdM1c0RiBSCzMgsQE2VvwWtIIbjQYHBvAfySZS7VMZfOabc4Z6gMWgSG4gciF5USYnChJdNxNjf0gssBPFt6/rUlYXcK+qYoKmsr3KZlDo7s+0vy35kdFEHlTp/Ya+3PRRRzRwJNpRvpS/Tvv9oM9WA+6SWTShx/yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725643619; c=relaxed/simple;
	bh=2ikELtyYNbwr/uDDPbP8nuAMeXNd8K4Pudf6sZHQzCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=MWr7uwyjYQ2DMzc+TYc1pblGzm3Ka2z/wePGZbfy/dDn2BIt+a97VM2MfZCSdJ443ej8u+uH3BtFyL6V09k9NjRe0tkw4WYEeqOeYVP9YUVvBsu3gwLG/RVaDfFIL/0hZoTAjYccpMkzcFAU9uxk7RJ3nOfPH6IMzAghgwq7dTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h9N99Sfi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h9N99Sfi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725643616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9gq4OnRig0w3MI54YxIqVYnrs8PaqzsLDk5yyyk6yzA=;
	b=h9N99Sfi6tax0t26B5B9Irg4/lp20qJsvuvgcKeCTWDmoGSZlMMcWu/catLoIg3ZqC5C8N
	pQOWAJjmpVX13WbdoVFRTVK7/Zco/IR4mbtUTIImz8RyMAivyWYe4gg93EAIrDHDs8WS/r
	cDusu3SzZRg98kgmbK2YmaZXJE47vmU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-FSNEwSlNMSKFpra70CCPKw-1; Fri,
 06 Sep 2024 13:26:51 -0400
X-MC-Unique: FSNEwSlNMSKFpra70CCPKw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A56A31955BC1;
	Fri,  6 Sep 2024 17:26:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0823B1956086;
	Fri,  6 Sep 2024 17:26:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 486HQlp2550937
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 6 Sep 2024 13:26:47 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 486HQlGU550936;
	Fri, 6 Sep 2024 13:26:47 -0400
Date: Fri, 6 Sep 2024 13:26:47 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 04/15] libmultipath: remove pending wait code from
 libcheck_check calls
Message-ID: <Zts7V4t7lMpLo7Ff@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
 <20240828221757.4060548-5-bmarzins@redhat.com>
 <de20ab3264728d3ce0d56b7f6debe79315ae72fd.camel@suse.com>
 <ZtjOWgPfSNcHrOj1@redhat.com>
 <95f3cdf6556991bf981e1d74e4cd6ce6ebb6f9cd.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <95f3cdf6556991bf981e1d74e4cd6ce6ebb6f9cd.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Sep 05, 2024 at 09:53:52AM +0200, Martin Wilck wrote:
> On Wed, 2024-09-04 at 17:17 -0400, Benjamin Marzinski wrote:
> > On Wed, Sep 04, 2024 at 10:05:30PM +0200, Martin Wilck wrote:
> > > On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:

<snip>

> > This way, you just call checker_get_state() on all the paths were you
> > ran the path checker, and if at least one of them needs to wait, then
> > the first one that does will wait, and the rest won't. If none of
> > them
> > need to wait, then none of them will.
> 
> This makes sense. But the "wait" you're talking about is the 1ms delay,
> after which the paths may well still be in PATH_PENDING. It's actually
> not much different from not waiting at all, we've just decreased the
> likelihood of PATH_PENDIN. 1ms is just an estimate, and, in my
> experience, too short in many environments.
> 
> The real benefit of your patch set is that we now start all (async)
> checkers in parallel. Which means that we can wait longer, increasing
> the likelihood that the checkers have actually finished, while spending
> less total time waiting. "Waiting longer" is a bit hand-waving; IMO it
> should be handled further up in the stack rather than down in the
> checker code.
> 
> We could achieve the behavior you describe in checkerloop, like this:
> 
>  - record start_timestamp
>  - fire off all handlers
>  - calculate end_time as start_timestamp + some_delay 
>  - use that end_time for waiting for results of all fired-off checkers
> 
> Like in your example, we'd really wait for no more than 1 path.
> We could do this for the entire set of paths, or for each multipath map
> separately.

Actually, now that I think about it, the biggest benefit of doing the
wait in checkerloop itself is that the code already handles the case
where we drop the vecs lock while there are paths that have started the
checker, but not yet updated the device based on the results. Given
that, we can just do the wait for pending paths without holding the vecs
lock. It's sort of embarassing that I did all this work to cut down on
the time we're waiting but didn't think about the fact that with just a
bit more work, we could avoid sleeping while holding the lock
altogether.
 
I already did some testing before to make sure that things like
reconfigures, adding/removing paths and manually failing/restoring paths
didn't mess things up if they happened in that window where we drop the
lock in the middle of checking the paths, but I'll probably need to do
some more tests and recheck that code if it's going to be non-rare
occurance for other threads to run in the middle of checking paths. But
this seems like too big of a benefit to avoid doing.

-Ben

> Regards
> Martin

