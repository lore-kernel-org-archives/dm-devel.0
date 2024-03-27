Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85287FF
	for <dm-devel@lists.linux.dev>; Wed, 27 Mar 2024 00:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498468; cv=none; b=VSkIRLUibb+/ZN5IE6W8V/RvxgXQ6wHoB/s3QFTuZ8E84ah/9fG69UWMMUEw+62PGkqCQN+fUMtzlhYRQhSUPuWvwDcY1eLN7jNp7f4QqR2uY+hckn2cXjbrNcQPvWgeSw1wNWVTNuiLPZCQRoumRRMkSbOReWYDDom9yw8A8cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498468; c=relaxed/simple;
	bh=m3cuzHLwZ9ZWfbm8aYFgK5KW8FauCfT7HS2qVEJFV/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=NLMzVF1/ZE3Gaq5wmdeY92kmxvkg6Xetj61mM0o7Tlbgj3Kay/jWbLsrlzuklPhNHKAHhb8c8+fcKxfDT8CPA59hH2MiepdhacE18QK8HXPOR4DiQyhEL3irCOKAiCPGXC1zsGUJSGK3KdaXrNQdaTuhuSD7r/uAfDoXfm9kjqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hf5q9fQK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hf5q9fQK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711498465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CBHLAhjTCAtF1kplXYksxp8gGdv7Y8kD+02+IqadHSY=;
	b=hf5q9fQKG2Ldi8GuKPkFtRxUZu0kBQQ/cQ231ic536JZ2CUJU2OnWgZcAw1nzZAp+f2bZr
	Ba4cnyYVHym9cc5oVuxfPfj4qBh+fY+S6g779mtAaJ+f2Sjf4pFwvXY45948HJnpRD1EHx
	ynVK7uRRrXO0IiQESSZhW/BswnrqL24=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-8cE2-wARM9SeabokrrREXg-1; Tue, 26 Mar 2024 20:14:21 -0400
X-MC-Unique: 8cE2-wARM9SeabokrrREXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6542389B847;
	Wed, 27 Mar 2024 00:14:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AE9AC04120;
	Wed, 27 Mar 2024 00:14:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42R0ELci1408259
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 20:14:21 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42R0ELJC1408258;
	Tue, 26 Mar 2024 20:14:21 -0400
Date: Tue, 26 Mar 2024 20:14:21 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 02/11] 11-dm-mpath.rules: don't import DM_NOSCAN from
 udev db
Message-ID: <ZgNk3TymUNP-8ItA@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-3-mwilck@suse.com>
 <ZgNGPsAz_H22VEaj@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZgNGPsAz_H22VEaj@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 26, 2024 at 06:03:42PM -0400, Benjamin Marzinski wrote:
> On Sun, Mar 24, 2024 at 10:12:52PM +0100, Martin Wilck wrote:
> > DM_NOSCAN is our "output" flag for 13-dm-disk.rules, and it should
> > be treated the same way as DM_UDEV_DISABLE_OTHER_RULES_FLAG, which
> > isn't imported from the udev database. The state that we need to
> > remember is MPATH_DEVICE_READY, which we've already imported above,
> > and we will set the "output" flags accordingly in the "force_activation"
> > code path further down.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  multipath/11-dm-mpath.rules.in | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> > index 3f23108..11b5adf 100644
> > --- a/multipath/11-dm-mpath.rules.in
> > +++ b/multipath/11-dm-mpath.rules.in
> > @@ -18,9 +18,11 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1
> >  
> >  # If this uevent didn't come from dm, don't try to update the
> >  # device state
> > +# Note that .MPATH_DEVICE_READY_OLD=="" here. Thus we won't activate the
> > +# device below at mpath_is_ready, which is correct.
> 
> Do you mean "force_activation" instead of "mpath_is_ready"?

I see that this label is added two commits later. I don't have a problem
with a comment being confusing for two commits, so if you don't feel
like changing it,

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> -Ben
> 
> >  ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
> > -	IMPORT{db}="DM_NOSCAN", IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
> > -	GOTO="scan_import"
> > +	IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
> > +	GOTO="force_activation"
> >  
> >  ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
> >  
> > -- 
> > 2.43.2
> 

