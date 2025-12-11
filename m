Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEEE1E5B63
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 20:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765484080; cv=none; b=DgzagJgROnzW2GyD3DiIED0vsbAmbtMAvobfGrYZsWTbKFx8gxHD2obff9vz6hKwU0gR/h4Wm2TO4RcBmBbiuz3XTzHPQfHObL6OL4laCIoUi1BRHLyOFUJIqmM599ity1zH6DCbXbSkmtjQdifqM+GAIUcRYCFYBoEgzeJ4iQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765484080; c=relaxed/simple;
	bh=5td7jxg8eFTseX6efY6nfVVNMe6WPHM7yQEkBxSlJH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=l8F7coaX2j2mXvZYJtNw/ROcFSHSDOAMkvCBBnVgqDa9lAe9NPOQVnrmI7Nvs4gz2nXl6ZuKxz94VDQG61o1C+4fRK94R/dR5FJxGVdneqFnV5ns/JutyoEgu9ogBp1oI+s8KxZr+nq79r5qz8sw512LpYvuvpS6TFX48rimBlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YlZLSsDa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YlZLSsDa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765484077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QFXcV/WCFL/5W2Dxu7HabMsvt9Rdqd2Uw1+xcykH1LE=;
	b=YlZLSsDazckqF34eCsFQvc9TmAzZuvLh2rOuZfoc6cxpeVUIure+AwF62pNySZoJ283LBe
	Ckzz+bzBoN3Bi+7EfV4yXW8J//2MyGZZaC7RJud1vKIMksh8z8aoiFJ4qFkjWfibrsLMFc
	ezMWOSDxVKoglyedHr1vAvNK8d0Gq1I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-471-9Yqrwo3eOI-ESb4NFFpq-w-1; Thu,
 11 Dec 2025 15:14:34 -0500
X-MC-Unique: 9Yqrwo3eOI-ESb4NFFpq-w-1
X-Mimecast-MFC-AGG-ID: 9Yqrwo3eOI-ESb4NFFpq-w_1765484073
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 081E4195608A;
	Thu, 11 Dec 2025 20:14:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E5591953984;
	Thu, 11 Dec 2025 20:14:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BBKEVZd1832697
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Dec 2025 15:14:31 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BBKEV6I1832696;
	Thu, 11 Dec 2025 15:14:31 -0500
Date: Thu, 11 Dec 2025 15:14:31 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, mwilck@suse.com,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH v4] mulitpath-tools Add purge capability to
 multipath-tools
Message-ID: <aTsmJ67rhkQ0sXVf@redhat.com>
References: <20251209174342.86044-1-brian@purestorage.com>
 <aToWKsaA0hdePsoJ@redhat.com>
 <88DF0A70-E860-4D42-9CED-2731496C7B90@purestorage.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <88DF0A70-E860-4D42-9CED-2731496C7B90@purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IAUVEGUJwSVzfP3RoxB0yaq3YFGK7OPwTYYoGe_h_Jw_1765484073
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Dec 11, 2025 at 08:49:54AM -0800, Brian Bunker wrote:
>
> >> @@ -2474,6 +2572,20 @@ get_new_state(struct path *pp)
> >> if (newstate == PATH_REMOVED)
> >> newstate = PATH_DOWN;
> >> 
> >> + /*
> >> +  * For PATH_DISOCONNECTED mark the path as OK to purge if that is
> >> +  * enabled. Whether or not purge is enabled mark the path as down.
> >> +  */
> >> + if (newstate == PATH_DISCONNECTED) {
> >> + if (pp->mpp->purge_disconnected == PURGE_DISCONNECTED_ON &&
> >> +     !pp->purge_path) {
> >> + condlog(2, "%s: mark (%s) path for purge",
> >> + pp->dev, checker_state_name(newstate));
> >> + pp->purge_path = true;
> >> + }
> >> + newstate = PATH_DOWN;
> >> + }
> >> +
> > 
> > There are a number of cases where we do not immediately reinstate paths
> > that are usable. But we should cancel any pending purges as soon as we
> > notice that the path is not longer disconnected, instead of in
> > reinstate_path().
> > 
> > Here's another thought. If a path ever goes into PATH_DISCONNECTED, we
> > probably want to force a wwid recheck if it ever comes back, even if we
> > don't purge it.  Possibly we could rename pp->purge_path to
> > pp->disconnected, and make it an enum with values like
> > 
> > NOT_DICONNECTED
> > DISCONNECTED_NO_PURGE
> > DISCONNECTED_NEEDS_PURGE
> 
> I like this idea. I have added the enum. It makes the decisions about
> what to do when things fail easy to distinguish between the original
> state and some step in the purge process.
> > 
> > That way, even if mpp->purge_disconnected is not set, we could still
> > flag the path as disconnected. In the code to check
> > if we should call check_path_wwid_change() in update_path_state(),
> > we could then have the first part of that check be
> > 
> > if ((pp->recheck_wwid == RECHECK_WWID_ON ||
> >     pp->disconnected != NOT_DICONNECTED) && ...
> > 
> > so that we enforce a wwid_recheck of a path that was disconnected.  For
> > this to work, the above code would set paths in PATH_DISCONNECTED
> > to DISCONNECTED_NEEDS_PURGE or DISCONNECTED_NO_PURGE depending on
> > pp->mpp->purge_disconnected. If the path wasn't in PATH_DISCONNECTED,
> > but pp->disconnected was set to DISCONNECTED_NEEDS_PURGE, it would
> > change pp->disconnected to DISCONNECTED_NO_PURGE, so that that path
> > wouldn't get purged.
> > 
> > Paths in DISCONNECTED_NO_PURGE would get changed back to NOT_DICONNECTED
> > once check_path_wwid_change() was called on them (that call would need
> > to be broken out of the large if statement in update_path_state)
> > 
> > Thoughts? That can also go in as a later patch.
> 
> I am not sure that recheck_wwid comes into play with what I am doing.
> Not that it doesn’t still happen. It still does. With the disconnected state
> not affecting the path state, I don’t think any extra logic is required. The
> disconnected state puts the path state to PATH_DOWN. There aren’t
> any extra situations are there where recheck_wwid is needed except
> after coming out of PATH_DOWN right? It happens with or without 
> disconnected in play, doesn’t it? Am I missing something?

recheck_wwid is disabled by default. I'm not sure how many people turn
it on. Likewise, I'm not sure how many people will turn
purge_disconnected on. My idea is to modify the check for calling
check_path_wwid_change() so it will be called when a path is restored if
EITHER recheck_wwid is enabled OR if the path was previously
disconnected (regardless of the purge_disconnected setting). That way,
even if users don't enable recheck_wwid or purge_disconnected (the
common case, I assume) we will enforce wwid_rechecks if a path got
disconnected, since it's WAY more likely to be pointing at something
different now, in that case.

> 
> I will add the recheck_wwid in the reinstate_path case though if that
> is a place PATH_DOWN could return to PATH_UP.

Just to be clear, I'm not asking you to add another place to recheck the
wwid. I'm saying that we should modify the "if" statement that calls
check_path_wwid_change() in update_path_state() so that, instead of
starting with

if (pp->recheck_wwid == RECHECK_WWID_ON &&
...

it starts with

if ((pp->recheck_wwid == RECHECK_WWID_ON ||
     (pp->disconnected != NOT_DICONNECTED && can_recheck_wwid(pp))) &&
...

(I forget the necessity of can_recheck_wwid() in my previous comment)

-Ben

