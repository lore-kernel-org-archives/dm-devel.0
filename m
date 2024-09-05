Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7295D17B51A
	for <dm-devel@lists.linux.dev>; Thu,  5 Sep 2024 19:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725562964; cv=none; b=gE4girf87Pi61umwJr4TNpJxLUxQ+f3WFDZYYwCT5LLIxH9L+5WXzK39fLrm0he5BcDWjpSLOMXSIpiUIORDS9rtPccrjx02PkHk4opiQO9ibxFR00u7vUjfv+s/XXoLBwk0u1p49L9MNPYxzflDB0KPGdhZMEQTkWrHvnGaYYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725562964; c=relaxed/simple;
	bh=vSXg/i7+OCLko8NBbpzw6gisOLjdZWiMl9cXcphF3SY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=QWeqHfipKCTsu8rW9yKf73KO8ziYcOfqTruF68Gu0lH5CT+eq7MuK06/xndWsP0ZCyxbllOkEdrqFLpFYkJZFnIemsSKA9STV8wV8wyW+FhrbWj5NsRnw6UdNd/Ra54W34i2VOnMDOtWjNVxepiDdvQ8epBH7hRi0UblvQHx8UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rf3LuQfF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rf3LuQfF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725562960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ccdGeayd25OtGqKVz4duWbBZxe2BShZoYh+GlFNOlqA=;
	b=Rf3LuQfFzgRIj1ORiQvvqxsOObPGraSgfLmmrG8P9ciDPFK5wR5OxWHmTDXjXN1UCxYumh
	pjXhdYzB5IQQVZGlQEWKKoeC4l/jE9h4RQKn8p1hGzT0EHmVWltgQE/ADBPPAj9XRirY5Z
	XxlZ4SMe4TDXfVRlHa/ETVsJUZMZ1V4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-99UjvuUANL2ap1jSKjcfkw-1; Thu,
 05 Sep 2024 15:02:39 -0400
X-MC-Unique: 99UjvuUANL2ap1jSKjcfkw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8AC2196CE02;
	Thu,  5 Sep 2024 19:02:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F07C19560AA;
	Thu,  5 Sep 2024 19:02:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 485J2Z91519053
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 5 Sep 2024 15:02:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 485J2YUZ519052;
	Thu, 5 Sep 2024 15:02:34 -0400
Date: Thu, 5 Sep 2024 15:02:34 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 10/15] multipathd: split check_path into two functions
Message-ID: <ZtoASjJZHbKltAJd@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
 <20240828221757.4060548-11-bmarzins@redhat.com>
 <131273007ab11d8a866e395c1e3aa80598aa1dbe.camel@suse.com>
 <ZtisJ_9A2-z0Gdly@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZtisJ_9A2-z0Gdly@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 04, 2024 at 02:51:19PM -0400, Benjamin Marzinski wrote:
> On Wed, Sep 04, 2024 at 05:38:52PM +0200, Martin Wilck wrote:
> > On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > > Split out the code that updates a path's state and sets up the next
> > > check time into its own function, update_path().
> > > 
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >  multipathd/main.c | 31 ++++++++++++++++++++++---------
> > >  1 file changed, 22 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index 94d4e421..300f8247 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -2390,6 +2390,7 @@ sync_mpp(struct vectors * vecs, struct
> > > multipath *mpp, unsigned int ticks)
> > >  }
> > >  
> > >  enum check_path_return {
> > > +	CHECK_PATH_STARTED,
> > >  	CHECK_PATH_CHECKED,
> > >  	CHECK_PATH_SKIPPED,
> > >  	CHECK_PATH_REMOVED,
> > > @@ -2629,13 +2630,10 @@ update_path_state (struct vectors * vecs,
> > > struct path * pp)
> > >  }
> > >  
> > >  static int
> > > -check_path (struct vectors * vecs, struct path * pp, unsigned int
> > > ticks,
> > > -	    time_t start_secs)
> > > +check_path (struct path * pp, unsigned int ticks)
> > 
> > check_path() used to be one of our core functions, and you now re-
> > introduce it with quite different semantics. 
> > 
> > Perhaps choose a new name?
> 
> Sure. Although the new check_path() is just the beginning part of the
> old check_path(), where we actually run the checker, so it seems
> reasonable to me. But your objection is also reasonable. I was just
> getting sick of coming up with new function names by this point.
> 
> -Ben 

Do you have ideas for the name, because I can't think of anything that
makes more sense then check_path() in the code paths. Here's the code
paths

checkerloop (initialized paths)
-----------------------------------------
check_paths             update_paths
check_path              update_path
start_path_check        update_path_state
start_checker           check_path_state
checker_check           get_state
                        checker_get_state

checkerloop (uninitialized paths)
-----------------------------------------
check_paths                     update_paths
check_uninitialized_path        update_uninitialized_path
start_path_check                check_path_state
start_checker                   get_state
checker_check                   checker_get_state

pathinfo
----------------
start_checker   get_state
checker_check   checker_get_state

The only function that stands out to me as misnamed is
"check_path_state", which I think I'm going to change to
"get_updated_state", since that's a better description of what it's
doing, and it avoids using "check" in the update code path.

Also, like I said before, if you're looking for the function that gets
run to see if a path is due for checking, and runs the path checker if
it is, that's check_path(), just like it used to be. It just no longer
updates the path and mpp state based on the checker result like it used
to. That's now done by update_path() and update_mpp_prio(). 

> 
> > 
> > Martin
> 

