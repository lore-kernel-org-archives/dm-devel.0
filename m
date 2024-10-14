Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57ED231C8A
	for <dm-devel@lists.linux.dev>; Mon, 14 Oct 2024 17:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728928103; cv=none; b=kprkBtqsYBOFqvvjg4ZoJlFmRrE92xClSNUkNoZJn1r0a5hpAm2pxN8nOC26AGjQ47IO4ejd4sHobNAl4kbEDkQ0zHeRTO99TR0lp0fU2FhlaWENK03Oi9KNBdZUxyGsChSwdPihDHh0EQv7Zvqd59KISSKovBaZ+z34W7Kz5Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728928103; c=relaxed/simple;
	bh=a0jchVJqC5UqCwrPWAdAczTKFyE1VZylnMaUCx0zmyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=L/G+OqvhUXjF4WR4mDFQhrF3SuRj48MN9Snx+3uNbvbL+587p7zptfEzPh7zS56uaRWZ3qcahKZCFNaolsudnrGpp9sAnAyNWySN0og85ZCh5XDpcUn1UMKFBDc2VO7SM/XKJGIWKYX2zrvyNMty/xd9nxOW2HtNdkXK3PhDLqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YnZwTZn3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YnZwTZn3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728928100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IqMiolMxJNXrAerKTzkqoEj2C627I5VM7GmJZn0u5vo=;
	b=YnZwTZn3mlb7b14ussG0zmIJf+2ShXze7x8LRdAuffRtleY/v6SEvRo9BogmGvs7OGXMw2
	2Tv9xXZIPX2K62m3iG4+1TxLB0hh4OxodfDnwhjJ390/ahUL/BnjjCnMIbW7UNelTKmNIw
	jc3Te8e7h98vRiPh7SL1CA5piRgfhp8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-325-KDpiN-hdOCqvl-ugoyYQmg-1; Mon,
 14 Oct 2024 13:48:17 -0400
X-MC-Unique: KDpiN-hdOCqvl-ugoyYQmg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8812019560A2;
	Mon, 14 Oct 2024 17:48:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0990A1956089;
	Mon, 14 Oct 2024 17:48:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49EHmEIj2673884
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 13:48:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49EHmEiU2673883;
	Mon, 14 Oct 2024 13:48:14 -0400
Date: Mon, 14 Oct 2024 13:48:14 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 19/22] libmultipath: add libcheck_need_wait checker
 function
Message-ID: <Zw1ZXkfmU7ggBKol@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
 <20240912214947.783819-20-bmarzins@redhat.com>
 <e46270826de9a255d6e16bcae56e984dfde346ac.camel@suse.com>
 <ZwWJBhwOnrUmtEa_@redhat.com>
 <8d27a1e4823d7382a19d1914c0b28b6feb94353e.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8d27a1e4823d7382a19d1914c0b28b6feb94353e.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Oct 09, 2024 at 05:49:33PM +0200, Martin Wilck wrote:
> On Tue, 2024-10-08 at 15:33 -0400, Benjamin Marzinski wrote:
> > On Thu, Oct 03, 2024 at 11:15:21PM +0200, Martin Wilck wrote:
> > > On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:

<snip>

> > > > diff --git a/libmultipath/checkers/directio.c
> > > > b/libmultipath/checkers/directio.c
> > > > index 904e3071..4beed02e 100644
> > > > --- a/libmultipath/checkers/directio.c
> > > > +++ b/libmultipath/checkers/directio.c
> > > > @@ -65,6 +65,7 @@ struct directio_context {
> > > >  	struct aio_group *aio_grp;
> > > >  	struct async_req *req;
> > > >  	struct timespec endtime;
> > > > +	bool waited_for;
> > > >  };
> > > >  
> > > >  static struct aio_group *
> > > > @@ -295,6 +296,7 @@ check_pending(struct directio_context *ct,
> > > > struct
> > > > timespec endtime)
> > > >  	int r;
> > > >  	struct timespec currtime, timeout;
> > > >  
> > > > +	ct->waited_for = true;
> > > 
> > > Not sure if it's important, but strictly speaking, we have only
> > > waited
> > > for the checker if the endtime was in the future, which is often
> > > not
> > > the case. Otherwise we'd just have polled.
> > 
> > But we always set the endtime in the future when we're starting a new
> > request, so the first time the we call check_pending() we don't
> > return
> > till we either get an answer or endtime has passed, which is what we
> > want waited_for to check (that we've give the checker till endtime to
> > respond).
> 
> That holds for this patch. But right in the next patch, the code is
> changed such that libcheck_pending doesn't actually wait at all. So
> "ct->waited_for" is a really confusing name. It just means that we have
> polled for the state once. In theory that can happen very quickly after
> starting the checker.

Oh. Yeah. I can change the of the variable to something like
is_unpolled, and the calling function to checker_is_unpolled(), which
matches what we're actually asking for.

-Ben

> Regards
> Martin

