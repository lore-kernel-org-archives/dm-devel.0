Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5A720CCEF
	for <dm-devel@lists.linux.dev>; Tue,  8 Oct 2024 18:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728411548; cv=none; b=O6w7p/Bf5DqRpAaPd+o34hcDNVC6XoqzwfAEGjtAKkLmzyLgtrrafz81GrKjv5pyfT8mhKEuXBX+qfLirfEysh8TXRE9LLYzCb33Vubr0nuTu3tW9DeJed5ACzEWnoEZniZqBCdGZLPbiUeC+V6lL1AtbpV9mHy5qAdMpkcblWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728411548; c=relaxed/simple;
	bh=6smm2XKDWq+zoPLaRlwJZQkvY/LrijlC/sEoc1E/0z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fTTLxQMeghL9rmuJgvh3C01rbBkZBQulzUT5BcXL+1pVk8p/Ks1eDmzeplRYU9r1YgltojMBXES3+2eJCNXWUpPR+S9vaJNHVNjko0CyYu4GZ/QylnepMO1cz3gHp2lxHQ4NPcRppHSAO3gI0+vr0QqoQUTGNzSuxZi3am65tHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kh45aEkl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kh45aEkl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728411546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mIos7ksmgzqAmWwCVCbxyC3ULff2IKZKO2BX84WF0wA=;
	b=Kh45aEkl38OphkaRB742wPyz736ld0KxknEG9dPB9rLHIUmx/I2HjLUYM5pyelG+ePtusZ
	5ISsKjgikGNH2SU83C0x3C2pXGcYiIfL9ZC912zmypSxxhQJNvghWlH56gJQrWeHSDqklo
	LL1aR6UcAOObopxn9gz2FX3dccA4zig=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-uFZFFoScMo6IXU-ZvWXNNA-1; Tue,
 08 Oct 2024 14:19:03 -0400
X-MC-Unique: uFZFFoScMo6IXU-ZvWXNNA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1FBF19560A5;
	Tue,  8 Oct 2024 18:19:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D9FB19560A2;
	Tue,  8 Oct 2024 18:19:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 498IJ0nI2368050
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 14:19:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 498IIxcp2368049;
	Tue, 8 Oct 2024 14:18:59 -0400
Date: Tue, 8 Oct 2024 14:18:59 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 09/22] multipathd: split do_checker_path
Message-ID: <ZwV3k3NVmfrRFqyW@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
 <20240912214947.783819-10-bmarzins@redhat.com>
 <d9deb2b87f50016daef904a5c639ee90f2809b1c.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d9deb2b87f50016daef904a5c639ee90f2809b1c.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Oct 03, 2024 at 10:23:51PM +0200, Martin Wilck wrote:
> Nit: the subject should refer to "do_check_path".
> Also, the word "split" is somewhat confusing as you've been using it 
> for actually splitting one function into two elsewhere in this set.
> 
> Perhaps just call the patch "rename do_check_path to
> update_path_state".

Sure.

> 
> On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> > Move the code that starts the path checker from do_check_path() into
> > check_path(), rename the remainder of do_check_path() to
> > update_path_state() and call that from check_path().
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/main.c | 21 +++++++++++----------
> >  1 file changed, 11 insertions(+), 10 deletions(-)
> > 
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 16c0531e..9319751e 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2396,7 +2396,7 @@ enum check_path_return {
> >  };
> >  
> >  static int
> > -do_check_path (struct vectors * vecs, struct path * pp)
> > +update_path_state (struct vectors * vecs, struct path * pp)
> >  {
> >  	int newstate;
> >  	int new_path_up = 0;
> > @@ -2414,12 +2414,6 @@ do_check_path (struct vectors * vecs, struct
> > path * pp)
> >  	marginal_pathgroups = conf->marginal_pathgroups;
> >  	put_multipath_config(conf);
> >  
> > -	if (pp->checkint == CHECKINT_UNDEF) {
> > -		condlog(0, "%s: BUG: checkint is not set", pp->dev);
> > -		pp->checkint = checkint;
> > -	};
> > -
> > -	start_path_check(pp);
> >  	newstate = get_new_state(pp);
> >  	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED)
> >  		return CHECK_PATH_SKIPPED;
> > @@ -2639,7 +2633,7 @@ check_path (struct vectors * vecs, struct path
> > * pp, unsigned int ticks,
> >  	    time_t start_secs)
> >  {
> >  	int r;
> > -	unsigned int adjust_int, max_checkint;
> > +	unsigned int adjust_int, checkint, max_checkint;
> >  	struct config *conf;
> >  	time_t next_idx, goal_idx;
> >  
> > @@ -2652,14 +2646,21 @@ check_path (struct vectors * vecs, struct
> > path * pp, unsigned int ticks,
> >  		return CHECK_PATH_SKIPPED;
> >  
> >  	conf = get_multipath_config();
> > +	checkint = conf->checkint;
> >  	max_checkint = conf->max_checkint;
> >  	adjust_int = conf->adjust_int;
> >  	put_multipath_config(conf);
> >  
> > -	r = do_check_path(vecs, pp);
> > +	if (pp->checkint == CHECKINT_UNDEF) {
> > +		condlog(0, "%s: BUG: checkint is not set", pp->dev);
> > +		pp->checkint = checkint;
> > +	}
> > +
> > +	start_path_check(pp);
> > +	r = update_path_state(vecs, pp);
> >  
> >  	/*
> > -	 * do_check_path() removed or orphaned the path.
> > +	 * update_path() removed or orphaned the path.
> 
> Nit: update_path() is introduced in the follow-up patch.
> Should this be update_path_state()?

Oops. Yep.

-Ben

> 
> Martin
> 
> 
> >  	 */
> >  	if (r == CHECK_PATH_REMOVED || !pp->mpp)
> >  		return r;

