Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893E225BF1C
	for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752512400; cv=none; b=FJ0M3B6M1W5RFK4NhPnhAkY6FBHIrr99RJBuWOvy7NS1XHgc8BLf/eqQJe1cmMbK60z0xhXicGJQgScBp+8V7gqBK3BAbORwDLnlxGtPCzG3mcSvZBEq6TXp+eU2c7FU+x3oAAdBfYZ71FXLWjCaNC7VEji2XaCOvxVF+6lgDmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752512400; c=relaxed/simple;
	bh=uTgkgxVohqLKo6KeC2s9TmQi3qtM9CDPc89kOZvnong=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VcVGz4ENoSbyj0QfeBW3RfiMl4m/X9HuHN110FT+k6N0yiY6my3jY/BbBTEFwiK/ZwscIEUlrjiMhwXw3YvBiHH35/NySKbNtZkOZEnSwnRXGyPyba6vbDWCB8msBVSWykrddLmt6MZyEk6WSalIz6IgOpjzftkMvqMWOiuM2As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U984YfWY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U984YfWY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752512397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v7EU173oDugrukEIG650eT0rFs2XFyS7q5qjIytlCEM=;
	b=U984YfWYhHrjT93PNlBd+nxfqDAJDym8E6iRkiAkOrott8GRJpTG/w8U1SLfbDZf7Brro6
	BVyuxMLacEc7R1fKgxgGkNIVz8nPHD92jbFP591ETUmniFJAm+cycUqlvRz8+NOyTng/64
	KKelx7SL0j+8vFzY5w9yPF/1pFJNdW8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-171-guhmjgm-M1OkAK10iwELbA-1; Mon,
 14 Jul 2025 12:59:55 -0400
X-MC-Unique: guhmjgm-M1OkAK10iwELbA-1
X-Mimecast-MFC-AGG-ID: guhmjgm-M1OkAK10iwELbA_1752512394
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70BFF1800366;
	Mon, 14 Jul 2025 16:59:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 282CE1977000;
	Mon, 14 Jul 2025 16:59:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56EGxqYq4143390
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Jul 2025 12:59:52 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56EGxq734143389;
	Mon, 14 Jul 2025 12:59:52 -0400
Date: Mon, 14 Jul 2025 12:59:51 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 11/15] limpathpersist: Handle changing key corner case
Message-ID: <aHU3h8I28IV4V-MY@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
 <20250710181100.3997759-12-bmarzins@redhat.com>
 <cd323846226f9a1dd053d77e9e8bbe35faee8af4.camel@suse.com>
 <09e59080ff857ab63d46355e47528ea32253fdf1.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <09e59080ff857ab63d46355e47528ea32253fdf1.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pC9L0SrccCcRXb9Vj9qCrAJMBo-y2M-bkwfh2qKg_1w_1752512394
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jul 11, 2025 at 04:11:46PM +0200, Martin Wilck wrote:
> On Fri, 2025-07-11 at 14:15 +0200, Martin Wilck wrote:
> > On Thu, 2025-07-10 at 14:10 -0400, Benjamin Marzinski wrote:
> > > When you change the reservation key of a registered multipath
> > > device,
> > > some of paths might be down or even deleted since you originally
> > 
> > [...]
> > > 
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > 
> > This is not a full review, just feedback about a failing CI pipeline.
> > 
> > > ---
> > >  libmpathpersist/mpath_persist_int.c | 124 ++++++++++++++++++++----
> > > --
> > > --
> > >  1 file changed, 90 insertions(+), 34 deletions(-)
> > > 
> > > diff --git a/libmpathpersist/mpath_persist_int.c
> > > b/libmpathpersist/mpath_persist_int.c
> > > index ad5a4ee7..ca972c2b 100644
> > > --- a/libmpathpersist/mpath_persist_int.c
> > > +++ b/libmpathpersist/mpath_persist_int.c
> > > 
> > > +void preempt_missing_path(struct multipath *mpp, uint8_t *key,
> > > uint8_t *sa_key,
> > > +			  int noisy)
> > > +{
> > > +	uint8_t zero[8] = {0};
> > > +	struct prin_resp resp = {0};
> > 
> > gcc 4.8 (Debian Jessie) dislikes this syntax.
> > 
> > > mpath_persist_int.c:272:9: error: missing braces around initializer
> > > [-Werror=missing-braces]
> > 
> > The same issue appears in patch 7/15 and patch 15/15.
> > It seems to be a gcc bug
> > (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=53119).
> > So we could use #pragma to silence the warning, but I'd like to avoid
> > that, especially because it occurs multiple times.
> > 
> > I don't think we should drop Jessie support just yet.
> > 
> > This works:
> > 
> > 	struct prin_resp resp = {{{0}}};
> 
> It does, but it causes an error with Jessie's clang compiler (clang
> 3.5.0).
>                                   ^
> > mpath_persist_int.c:673:30: error: missing field 'additional_length' initializer [-Werror,-Wmissing-field-initializers]
> >         struct prin_resp resp = {{{0}}};
>  
> Both compilers seem to accept this:
> 
> 	struct prin_resp resp = {{{.prgeneration = 0}}};
> 
> It's getting so awkward that we might as well just use memset.

Yeah. picking a member from one of union types to set to 0 is pretty
awkward. I can repost the patches with memsets.

-Ben

> 
> Martin
> 

