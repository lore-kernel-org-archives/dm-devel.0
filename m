Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717B11FDE31
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 03:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756438611; cv=none; b=WAqk6ADQkPUpUjgL5gUEgMnl242QGhBycLyA/gVJc7ZohsuY9y7lyXncfGVxuOkbDJjN1T4pgnxQZmiMPKWlSCH85wsv+NqA4z3Z1dciVozAW4izDEzTLFBgRA5TiQLiQlnnXIfgCTdJkNICAHECj0avIQx0gmTkQIJNh9zDhKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756438611; c=relaxed/simple;
	bh=ew+rCdI4Rc3oeC/F/zCMwjQUJxZCFmMNopHLdvyBRZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=MmZ7j+CxhgfRijo6oOGGr3IUrMAbaFKoTbtSxrlRWOta89yGI7hlnOUD0QDIx8zdRMEPy32O9D0nf0cIbb9ugbZxmnwuwDO0rrR3Cdv85hJ966OlLnYvYdR5EoLJxCvHbhhSmSISTG1qkHQlCK5pr90Wta5R8JNT8P3dIYORwUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=STeodrku; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="STeodrku"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756438608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HVh/B2lO6oYn7p/JVlE9SGes1jsTc2VEuM8D1hZ6y/k=;
	b=STeodrkuiVbxHbvA0pDot9fShtm1w2kH7vl7OSVYZV1jw6gdQ51m8wplp7ODFj909GuXsi
	ExBR2HF7SLr1a5MggSK/fPyqIHNXWiYzo0qt69etgO2jvIF3gZDSWiCBsNfvhdBb735EzE
	8xsGt1BL9XJWaBTjVvuk8+mFKzPrSgk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-335-c_ASDX6oPNmQ1t-LDOdpPQ-1; Thu,
 28 Aug 2025 23:21:58 -0400
X-MC-Unique: c_ASDX6oPNmQ1t-LDOdpPQ-1
X-Mimecast-MFC-AGG-ID: c_ASDX6oPNmQ1t-LDOdpPQ_1756437716
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE17E1800289;
	Fri, 29 Aug 2025 03:21:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 538703000198;
	Fri, 29 Aug 2025 03:21:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 57T3Lsxq348632
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 28 Aug 2025 23:21:54 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 57T3LsEC348631;
	Thu, 28 Aug 2025 23:21:54 -0400
Date: Thu, 28 Aug 2025 23:21:54 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 10/14] libmpathpersist: only clear the key if we are
 using the prkeys file
Message-ID: <aLEc0gW0zNvIA274@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
 <20250726035855.363290-11-bmarzins@redhat.com>
 <7ceefd5d4a7fb72cb0162e3ef4c23286d128be09.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7ceefd5d4a7fb72cb0162e3ef4c23286d128be09.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zSyUYcxrnddpDzT0LHjmOtjXaREM34ExThHKl9muQDU_1756437716
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Aug 25, 2025 at 06:21:59PM +0200, Martin Wilck wrote:
> On Fri, 2025-07-25 at 23:58 -0400, Benjamin Marzinski wrote:
> > Otherwise this request will create a useless prkeys file.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmpathpersist/mpath_persist_int.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index dfdadab6..f901b955 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> > @@ -831,7 +831,8 @@ int do_mpath_persistent_reserve_out(vector curmp,
> > vector pathvec, int fd,
> >  		break;
> >  	case MPATH_PROUT_CLEAR_SA:
> >  		update_prflag(mpp->alias, 0);
> > -		update_prkey(mpp->alias, 0);
> > +		if (mpp->prkey_source == PRKEY_SOURCE_FILE)
> > +			update_prkey(mpp->alias, 0);
> 
> Should this condition be checked in update_prkey_flags() directly?

We could, but it would just end up being a pointless extra check most of
the time. Aside from the CLEAR command, we only set the prkey when we
are registering a key or reverting the prkey if that registration
failed. When we first set it during register, we need to check
prkey_source early, since there is a bunch of things we can't do if we
aren't using the prkeys file. And we don't want to revert it unless we
updated it and have an old value to revert to.  In both cases we already
had to do the necessary check before calling update_prkey(). The CLEAR
command is the only one where we don't need to check if we are using the
prkeys file earlier. So, I'd prefer to leave the check outside of
update_prkey_flags() here as well, to avoid the unnecessary extra work.

-Ben

> 
> Martin

