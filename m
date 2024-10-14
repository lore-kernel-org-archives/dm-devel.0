Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682C84683
	for <dm-devel@lists.linux.dev>; Mon, 14 Oct 2024 21:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728940129; cv=none; b=T//p4s0dF35fikiOJg8JL2z2FjikqmWKqnLXEXTJZS4SVUQwvqjyYl5B90Pd2LuJoe3MsK6uRq71Sn3yKUqCdhFh+a3G8yrJ+c9l0gmrdCaT9AmsBvGcmTZIGNLaYIi3oD+05i08VsxgLGbeScG1jhTwqmj02RWvvdGdZB372/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728940129; c=relaxed/simple;
	bh=ZBX0mSrbnrOz2wfHOksZRbB0huYRcqV/ECdJfcLlYxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=WNkiyk3Q2o484y+Tgk+JvzQZ34dChLI16861swb9Ksot6aRJf/pkGeybHtpjZaeLZ1jgIYo+A5DQvSMg22tnaW5HYN2EbfY4gU/XYQsMIO0YKAvVTWHSnTrtr1HcBxgzhathgE99t32aN0rUhRYCCZ2Hd5x6Sz8xkK9zBd3CQ8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGJUFcIn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGJUFcIn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728940126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fJjF/RBs3qJ7Gq60++hWpXxuhq1MQBuAU3uguqlSv3U=;
	b=JGJUFcIng9oFYHnSunMPuw6A2/sssyMJgb82Zm2WhqtqPNPu3nOl1wz4JwwWYh13MuPRRa
	vp8Hg8ybSyJP493yfJaEkQhJGFGWaiW/E+kYIroXCRNT3SwO0PZRSB5tPNvSBYL7shr6+d
	mUv/oyci27r4kr50clWIXvrjfgzcu0I=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-B04sbzo6PraUnZO8yEQ75A-1; Mon,
 14 Oct 2024 17:08:42 -0400
X-MC-Unique: B04sbzo6PraUnZO8yEQ75A-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEEC9195609E;
	Mon, 14 Oct 2024 21:08:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BF9C1956089;
	Mon, 14 Oct 2024 21:08:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49EL8d8A2679025
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 17:08:39 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49EL8dKU2679024;
	Mon, 14 Oct 2024 17:08:39 -0400
Date: Mon, 14 Oct 2024 17:08:39 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 19/22] libmultipath: add libcheck_need_wait checker
 function
Message-ID: <Zw2IV5Iy9eQpf4gL@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
 <20240912214947.783819-20-bmarzins@redhat.com>
 <e46270826de9a255d6e16bcae56e984dfde346ac.camel@suse.com>
 <ZwWJBhwOnrUmtEa_@redhat.com>
 <8d27a1e4823d7382a19d1914c0b28b6feb94353e.camel@suse.com>
 <Zw1ZXkfmU7ggBKol@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Zw1ZXkfmU7ggBKol@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Oct 14, 2024 at 01:48:14PM -0400, Benjamin Marzinski wrote:
> On Wed, Oct 09, 2024 at 05:49:33PM +0200, Martin Wilck wrote:
> > On Tue, 2024-10-08 at 15:33 -0400, Benjamin Marzinski wrote:
> > > On Thu, Oct 03, 2024 at 11:15:21PM +0200, Martin Wilck wrote:
> > > > On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> 
> <snip>
> 
> > > > > diff --git a/libmultipath/checkers/directio.c
> > > > > b/libmultipath/checkers/directio.c
> > > > > index 904e3071..4beed02e 100644
> > > > > --- a/libmultipath/checkers/directio.c
> > > > > +++ b/libmultipath/checkers/directio.c
> > > > > @@ -65,6 +65,7 @@ struct directio_context {
> > > > >  	struct aio_group *aio_grp;
> > > > >  	struct async_req *req;
> > > > >  	struct timespec endtime;
> > > > > +	bool waited_for;
> > > > >  };
> > > > >  
> > > > >  static struct aio_group *
> > > > > @@ -295,6 +296,7 @@ check_pending(struct directio_context *ct,
> > > > > struct
> > > > > timespec endtime)
> > > > >  	int r;
> > > > >  	struct timespec currtime, timeout;
> > > > >  
> > > > > +	ct->waited_for = true;
> > > > 
> > > > Not sure if it's important, but strictly speaking, we have only
> > > > waited
> > > > for the checker if the endtime was in the future, which is often
> > > > not
> > > > the case. Otherwise we'd just have polled.
> > > 
> > > But we always set the endtime in the future when we're starting a new
> > > request, so the first time the we call check_pending() we don't
> > > return
> > > till we either get an answer or endtime has passed, which is what we
> > > want waited_for to check (that we've give the checker till endtime to
> > > respond).
> > 
> > That holds for this patch. But right in the next patch, the code is
> > changed such that libcheck_pending doesn't actually wait at all. So
> > "ct->waited_for" is a really confusing name. It just means that we have
> > polled for the state once. In theory that can happen very quickly after
> > starting the checker.
> 
> Oh. Yeah. I can change the of the variable to something like
> is_unpolled, and the calling function to checker_is_unpolled(), which
> matches what we're actually asking for.

Actually, I'm going to leave the calling functon as checker_need_wait(),
since the question we're asking the checker is whether or not we need to
wait. Even if the checker is unpolled, if it's not pending, there's no
point in waiting.  Inside the checkers, I'll change the variable name to
checked_state, which makes more sense than is_unpolled in the initial
patch, where you're still waiting instead of just polling.

-Ben

> 
> -Ben
> 
> > Regards
> > Martin

