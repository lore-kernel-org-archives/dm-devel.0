Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795109464;
	b=RWu2rnKmi1+uEuGNgP8b5DkhKu3Pjmh8Y/ovx6dY8Cx/U4MHaJ+AkXyJ77py6rsvwVyU
	 h0gCJjAOsYhtEF/7c943KLYXADg/YPx3Z7svtGriNAZne+ydw2y3z8vTpShsdsEX6YSYc
	 ZNl3dggXFGWax8NFh7dS13djLO8DHBT11ZonyvaVkAlfZQXoNyWq3dtG3N1l8ZTpSGB+j
	 J787Zd33pwVZJj+7ZSw3gFg7WQkZ/RTRpCoNwYRlXhimdV8lHxBHUhKmNjakqrivSa63/
	 TjU5hhcFgT9bUcs7lsm/wZ7vx1jrinyr/SW6y0RcgzBxgeE4Si6IqKw3r/KZ9yBUSAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795109464;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=vqkNCMLPuvcORP1G2PW/tqDu2/0ish4Yr/K13Q1ZRzo=;
	b=xSgjR3i1dh3qkp8At0WB1KfSCTajrFAhSFqGmbrJ+WRNqBkEJ9r09j1q/dOFvFawGO3a
	 4+K1IGD5pM9wti7PuB+0DgBk3pffqA1Foqxuw1VyAaseRKvT4uIO9DXNdYiLzc1RvaTBX
	 DColgt+PjltGWJ4bFAeykqqFDsAj9Mnddsy8IYhlYyEvNYlBE1IBAS/vd79anIdixf4Sn
	 5xOp4WpdOFvyNA/IT1TWanaYWUp0QMtjPc7WT+xW1NUgkvAcZURNq5Kqb/u2SKJ36ys1m
	 xem/smzN4Z6wsR0ePWL/lRRX64i24TpUftRme1RNEDfkHqtg2wHofZYdNdA3kNwNnRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="TX0d/k+e";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5190606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 17:31:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5190606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TX0d/k+e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795109462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vqkNCMLPuvcORP1G2PW/tqDu2/0ish4Yr/K13Q1ZRzo=;
	b=TX0d/k+etTIRsTy/tFB1HJk0+N+/pFEPxtZJGv0ooCNZG+EuwTG2oHTXL6VtBqwGe/LEn6
	pNq5LgELgOOn08IBp6JEqQlasuxuaLB2x5KvTSqTPgm7LI7TV//9b+ZcMH0xPLxtghe2yF
	KxxQ0NtJ//KW53ZYYnQF3e2lpQxRIbE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-G60G2Hq4OSKvu0fZhXWK-Q-1; Thu,
 19 Nov 2026 17:31:00 +0000
X-MC-Unique: G60G2Hq4OSKvu0fZhXWK-Q-1
X-Mimecast-MFC-AGG-ID: G60G2Hq4OSKvu0fZhXWK-Q_1795109458
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB8F91956095;
	Thu, 19 Nov 2026 17:30:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 418AC1801974;
	Thu, 19 Nov 2026 17:30:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AJHUuTQ832378
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 12:30:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AJHUu8O832377;
	Thu, 19 Nov 2026 12:30:56 -0500
Date: Thu, 19 Nov 2026 12:30:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v4 1/1] multipathd: recheck WWIDs of re-added paths with
 the device
Message-ID: <av8yUJLcMz9_4ljM@redhat.com>
References: <20261111181642.51912-1-brian@purestorage.com>
 <20261111181642.51912-2-brian@purestorage.com>
 <179452227264.147392.9708937185980533136.b4-review@b4>
 <avdQNjzddtu7o18n@redhat.com>
 <9259d20188a042cb280bad95f8be9783d1b9c1fd.camel@suse.com>
 <avtdexYN1B3pJLmL@redhat.com>
 <1a6a0493ef4f510a047647db2385cf89f7424b68.camel@suse.com>
 <20261118223449.85519-1-brian@purestorage.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261118223449.85519-1-brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Srr2I-LTMi2FJixcwRXjx9spxbd7mam2I3CvT0VKpWc_1795109458
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 18, 2026 at 02:34:49PM -0800, Brian Bunker wrote:
> Martin, Ben,
> 
> Thanks, both. Two points before I do a v5.
> 
> On Mon, 2026-11-16, Benjamin Marzinski wrote:
> > If this code was only run when we got a wwid before and then it
> > changed, then requiring a matching WWID from the device seems much
> > more reasonable.
> 
> Agreed, and that changes my earlier position. With PATH_ADD_REINIT
> passed only from the changed-WWID branch, the check only runs when the
> path already had a WWID and udev now reports a different one. In that
> case, if the device doesn't confirm the new WWID, including when SG_IO
> fails, I'd keep the path out and let the checker retrigger, as for a
> mismatch.
> 
> check_path_wwid_change() returns false both for a match and for an SG_IO
> failure, so v5 would need to tell those apart.
> 
> > we never reset pp->retriggers once we have a reasonable WWID
> 
> On Mon, 2026-11-16, Martin Wilck wrote:
> > I don't see an issue with resetting retrigger_tries once the issues
> > with path's WWID are sorted out, in both cases.
> 
> I'm fine with resetting pp->retriggers once a path has a confirmed WWID,
> so that "no WWID from udev" and "WWID didn't match" don't share one
> budget for the life of the path. Would you rather have that in this
> patch or as a separate one? I lean towards a separate patch, since it
> also changes the existing missing-udev handling.

Yes to a separate patch.
 
> If you're both fine with this, I'll send v5.

I'm fine with this.

-Ben

> Brian

