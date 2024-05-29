Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B903C17BB15
	for <dm-devel@lists.linux.dev>; Wed, 29 May 2024 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994994; cv=none; b=PAhXXXPCMazOkHhcntREp0FxwDfIXpZhF8XUbwye7RnwB5gM75uobD4w72HpMLARiuySOmC//68U7fE9EpIFO1kPB5bL1zKbN+vA59sc6HMnVIzJuwNOwylm/u2RNxi+Db5mwKxCV9Us7Xpv22CaRKpqGQLjTHhg2XpVUccMKQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994994; c=relaxed/simple;
	bh=X6fZJ6pnk/p7KtSm6anIvMpsZaKFVB68x2Cmz+VXHA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=jB41TfghCjBzRhwXuYwj8kSNYQ1M/2EiwhUUuQ9lp+dZ6HWImKmsaTedXs0WPFkwOb2DFbadd7jQe9s/R112VxnPuFXc6IpoP9JZqmeSoUxMHjYYKgIBq5jNI48UgiyS8v7CLmjvk4wQ6Df75yXQ0ts3vWh6LVPaKFQYkt6TpDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h2rprz2q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h2rprz2q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716994991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DQfclFt4WlAa6q8XqrBw32cqACvBpvh7DmsSER7urF8=;
	b=h2rprz2q+gLirHs6/Ialg7Wv/wRfeisEiHYEJI0iN5hKBBc+nNhOBxSuDADbwL/AwLU4Eo
	8WkdWg5R3DF7hipkXKiNm2Hh9Lvfu9cOqQDWJHrOBSNoD2MGW7QQ2MIYPjdGPWdD5P60+9
	NkPtpPHmV4U56kLnFDFl5DK+yEmjtvQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-H7bTiLh3P66VqfMDVSilqg-1; Wed,
 29 May 2024 11:03:10 -0400
X-MC-Unique: H7bTiLh3P66VqfMDVSilqg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE41529AA390;
	Wed, 29 May 2024 15:03:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4453200A6E7;
	Wed, 29 May 2024 15:03:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44TF39jq359231
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 11:03:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44TF39FL359230;
	Wed, 29 May 2024 11:03:09 -0400
Date: Wed, 29 May 2024 11:03:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>,
        Nitin Yewale <nyewale@redhat.com>
Subject: Re: [PATCH 3/7] libmultipath: print all values in snprint_failback
Message-ID: <ZldDrafYc1riyz76@redhat.com>
References: <20240513173646.94424-1-bmarzins@redhat.com>
 <20240513173646.94424-4-bmarzins@redhat.com>
 <5e534cd7c8034436819ef451e451fe00549d8a72.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <5e534cd7c8034436819ef451e451fe00549d8a72.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, May 24, 2024 at 03:43:44PM +0200, Martin Wilck wrote:
> On Mon, 2024-05-13 at 13:36 -0400, Benjamin Marzinski wrote:
> > Add the missing output for manual failback and print the defferral
> > time
> > for deferred failbacks, if one isn't currently in progress.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/print.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/libmultipath/print.c b/libmultipath/print.c
> > index 89813517..14e7e325 100644
> > --- a/libmultipath/print.c
> > +++ b/libmultipath/print.c
> > @@ -218,9 +218,13 @@ snprint_failback (struct strbuf *buff, const
> > struct multipath * mpp)
> >  		return append_strbuf_str(buff, "immediate");
> >  	if (mpp->pgfailback == -FAILBACK_FOLLOWOVER)
> >  		return append_strbuf_str(buff, "followover");
> > +	if (mpp->pgfailback == -FAILBACK_MANUAL)
> > +		return append_strbuf_str(buff, "manual");
> > +	if (mpp->pgfailback == FAILBACK_UNDEF)
> > +		return append_strbuf_str(buff, "undef");
> >  
> >  	if (!mpp->failback_tick)
> > -		return append_strbuf_str(buff, "-");
> > +		return print_strbuf(buff, "%i", mpp->pgfailback);
> 
> Perhaps we should print something like "delayed:%i" here?

Sure.

> 
> Martin
> 
> 
> 
> >  	else
> >  		return snprint_progress(buff, mpp->failback_tick,
> >  					mpp->pgfailback);

