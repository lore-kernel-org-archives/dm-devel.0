Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105553375A7
	for <dm-devel@lists.linux.dev>; Mon, 26 Jan 2026 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769443147; cv=none; b=n4JGofb6UjSezdX0d4QjufCmThxfSjSR3KqVX+qIZhDTeXAGpwqTBtmSfJPLdx6VpapaJHAyPynuh0BfwI4Ze4OgBtaZwHdi3yX7ufBiceWQD5TfsbWCDytKI9ZHGI6+olH/NQ9bLXEyhoumyjf2ajGST/dVcHqrKKUzMwB5Too=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769443147; c=relaxed/simple;
	bh=oHMRL9gY6UJ0xo4Q0Tzpxe8K1II8+Kk/3Un7cdjGjRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=PNuA4gKJxEFULOPh6mM3wo5nr4OBPOWtEZMOVyNShlfDORiwUEyU8/7m5yc5jPeciR0UGn/l710ISZrItNcch2CbrRgz/yBFc1h9Xc9gQltBOrmQUbPA4fXkXoZU2+9rfFbAizToJJQ3DJZoifunDGpqnx/eTxydmkGYPY/ei+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=faPAe3kN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="faPAe3kN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769443145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m12foImN0pb5eIXmwh8Vja6I3bKr4NWDWEdlXFgDN4I=;
	b=faPAe3kN5e/emuisV8zYzWTITiuUJl0gHvBBJOFFBFYnzg2WZSr+mM+JK4ZBh6pEtwUdDZ
	zaECcZG3NEmc1FmRr+xVNAmxagqU1aVqusV77F5t20DTa8ajkD/q9lJqIQGm/xF4zDxmqp
	R003EplEELtc8eQ2BsLFrBlTbvBVP4o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-42-EmM5tGD8OYe8B0WiCJKRnw-1; Mon,
 26 Jan 2026 10:59:01 -0500
X-MC-Unique: EmM5tGD8OYe8B0WiCJKRnw-1
X-Mimecast-MFC-AGG-ID: EmM5tGD8OYe8B0WiCJKRnw_1769443140
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6966F193E8DC;
	Mon, 26 Jan 2026 15:59:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 220571955F66;
	Mon, 26 Jan 2026 15:59:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60QFwxtP4127384
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 26 Jan 2026 10:58:59 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60QFwxpe4127383;
	Mon, 26 Jan 2026 10:58:59 -0500
Date: Mon, 26 Jan 2026 10:58:59 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: dm-devel@lists.linux.dev,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] kpartx: fix segfault when operating on regular files
Message-ID: <aXePQyzFVnuWfpHt@redhat.com>
References: <20260126121325.208908-1-mwilck@suse.com>
 <aXeHyiI7YtdQKCZx@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aXeHyiI7YtdQKCZx@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GNy5XHWL9Cxtmft7IXBU1NX7QqCcvCeSt-4EMipttvE_1769443140
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 26, 2026 at 10:27:07AM -0500, Benjamin Marzinski wrote:
> On Mon, Jan 26, 2026 at 01:13:25PM +0100, Martin Wilck wrote:
> > The following problem has been introduced in multipath-tools 0.14.0:
> >  
> > [snip] 
> > diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> > index 9bdd204..cfd8212 100644
> > --- a/kpartx/kpartx.c
> > +++ b/kpartx/kpartx.c
> > @@ -334,8 +334,11 @@ main(int argc, char **argv){
> >  	 * This allows deletion of partitions created with older kpartx
> >  	 * versions which didn't use the fake UUID during creation.
> >  	 */
> > -	if (!uuid && !(what == DELETE && force_devmap))
> > +	if (!uuid && !(what == DELETE && force_devmap)) {
> >  		uuid = nondm_create_uuid(buf.st_rdev);
> > +		if (!uuid)
> 
> We should probably print an error message before we exit, but
> otherwise, this looks good.
> 
> -Ben

After being reminded that there's not much point in trying to print
error messages after failing a memory allocation,

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> > +			exit(1);
> > +	}
> >  
> >  	if (delim == NULL) {
> >  		delim = xmalloc(DELIM_SIZE);
> > -- 
> > 2.52.0

