Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3026D29A
	for <dm-devel@lists.linux.dev>; Sat, 16 Dec 2023 03:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ckh+hz/H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702697058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uZv2qdZTXxyD6Z8HsiHTr8WhTA8iqcE7gr49Jfrpkfc=;
	b=ckh+hz/HuMVDMXU6+J5Ja72v6+Ae6hPdDWCxxuSPXjoZ0NjCYu8I6mGZnspjbLTh5CfeBM
	nVBEUoP0lN4FCY0/ukryIhRPrar+JdnQCGJkvSSiNRjihfSkAdg+d0X4+6jK/5Nb3NI64l
	z+yl2ejtiVvr+zs4HSeebW59irw+CYc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-BpsyDyv1O12abkriDZOtvg-1; Fri, 15 Dec 2023 22:24:16 -0500
X-MC-Unique: BpsyDyv1O12abkriDZOtvg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10628832D1D;
	Sat, 16 Dec 2023 03:24:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09F132026D66;
	Sat, 16 Dec 2023 03:24:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BG3OFsi677897
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Dec 2023 22:24:15 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BG3OFpN677896;
	Fri, 15 Dec 2023 22:24:15 -0500
Date: Fri, 15 Dec 2023 22:24:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 12/16] multipathd: make cli_handlers check for paths by
 dev and devt
Message-ID: <ZX0YXyw919T1UAmY@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231212235320.440336-1-bmarzins@redhat.com>
 <20231212235320.440336-13-bmarzins@redhat.com>
 <9777471825fdc0c864a758694925be284a735190.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <9777471825fdc0c864a758694925be284a735190.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Dec 14, 2023 at 06:17:18PM +0100, Martin Wilck wrote:
> On Tue, 2023-12-12 at 18:53 -0500, Benjamin Marzinski wrote:
> > Some of the client handlers checked for paths by both dev and devt,
> > but
> > not all. Also, many of the client handlers don't print anything if
> > they
> > failed to find a path. Make all the client handlers which work on
> > path
> > devices use a new function, find_path_by_str(), which will try both
> > methods to find a path, and can print out an error message if none is
> > found.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/cli_handlers.c | 40 ++++++++++++++++++++-----------------
> > --
> >  1 file changed, 21 insertions(+), 19 deletions(-)
> > 
> > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > index 063a771f..7f550030 100644
> > --- a/multipathd/cli_handlers.c
> > +++ b/multipathd/cli_handlers.c
> > @@ -33,6 +33,20 @@
> >  #include "cli_handlers.h"
> >  #include "devmapper.h"
> >  
> > +static struct path *
> > +find_path_by_str(const struct _vector *pathvec, const char *str,
> > +		  const char *action_str)
> > +{
> > +	struct path *pp;
> > +
> > +	if (!(pp = find_path_by_dev(pathvec, str)))
> > +		pp = find_path_by_devt(pathvec, str);
> 
> I wonder if devt should be tried first. It doesn't make a real
> difference because no real-world devices will have major:minor names,
> and the callers in the old code did it the other way around, too; but
> it would feel more correct to me.

I'm fine with switching the order. Also, I assume you'd like the log
level to be set to 2, right?

-Ben
 
> Other than that, LGTM.
> 
> Regards
> Martin

