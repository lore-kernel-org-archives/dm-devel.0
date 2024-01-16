Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286611BF29
	for <dm-devel@lists.linux.dev>; Tue, 16 Jan 2024 19:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705432073; cv=none; b=pZ/JMrkBDtMYAcMM2tRTgQk6mL3lH0xP0fqTlOGfBcOWbrjx+X+Rdeo0RsruaT1buxi/xZkQ1sqA7fY8yhfAXCvX+huUHEMnNa/1nDdWJezUSY8c4WaQqjCU4qPUmFUHuz3uoBZ2TBRjQsXRrgxPfpJVlJzvMlfdGoQu0cy+Apg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705432073; c=relaxed/simple;
	bh=49azcfmTqQuHM+il6qoxnucIh4ku4CMglRnv7CMpY2Q=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:In-Reply-To:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-Originator:Content-Type:Content-Disposition; b=YO7T0CrkhBOhiX3DuSiuxuWRMy1j3fiMJgv24BlUhvajnHAuoFXqOwn+vK1Q4tLxsZ0GV+5U7gL6ViSM7h+mxcu49E45yt19YXWn4PErT3m7IRXD9HCst/C4wgEsN4rxXMqDC8jniTgGN+atd70yidXV8vdINWHm283/VU91kGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UmUVoJ/k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UmUVoJ/k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705432070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZkAUeEu05FStQ5vfmWbW9I+lHgn2jiFb6cnOe/dZY1s=;
	b=UmUVoJ/kRqdhCEzwE9uk5B0pJfEdjwRFhZxkJbQvT58WcfZQEgm9ieR8dkyoP4bh87x1HC
	JepcVXj4Lx4i76C2u1DJ6HZmTzsOD9JwLUVx+smygLgVhxgyqeZtlLecVrO98oHP+DmeVE
	0RfBZEz9lhhQMgUxibBo1IS1JTyfTVk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-Tuce5MkoOQqf01CngRFn7g-1; Tue, 16 Jan 2024 14:04:49 -0500
X-MC-Unique: Tuce5MkoOQqf01CngRFn7g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC31F185A783;
	Tue, 16 Jan 2024 19:03:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C39FA2166B32;
	Tue, 16 Jan 2024 19:03:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40GJ3tDT014963
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 14:03:55 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40GJ3tIS014962;
	Tue, 16 Jan 2024 14:03:55 -0500
Date: Tue, 16 Jan 2024 14:03:55 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/2] multipathd: fix auto-resize configuration
Message-ID: <ZabTG0dltPIh6lU7@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240116070507.10563-1-bmarzins@redhat.com>
 <20240116070507.10563-3-bmarzins@redhat.com>
 <623ac42b1e305d7ed685694694bb69fb69ec3203.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <623ac42b1e305d7ed685694694bb69fb69ec3203.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 16, 2024 at 12:23:33PM +0100, Martin Wilck wrote:
> On Tue, 2024-01-16 at 02:05 -0500, Benjamin Marzinski wrote:
> > The code acted like AUTO_RESIZE_UNDEFINED didn't exist, but since
> > conf->auto_resize was never set to AUTO_RESIZE_NEVER, the default was
> > in
> > fact AUTO_RESIZE_UNDEFINED, which ended up getting treated like
> > AUTO_RESIZE_GROW_SHRINK. Remove AUTO_RESIZE_UNDEFINED, so
> > AUTO_RESIZE_NEVER really is the default.
> > 
> > Fixes: 981b83ad1 ("multipathd: Add auto_resize config option")
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> The analysis is correct, but the fix differs from what we did for other
> options. We won't be able to cleanly change the default later on with
> this patch applied.
> 
> I would prefer to keep AUTO_RESIZE_UNDEF and DEFAULT_AUTO_RESIZE and
> just change the condition in uev_update_path() from "auto_resize !=
> AUTO_RESIZE_NEVER" to "(auto_resize == AUTO_RESIZE_GROW_ONLY ||
> auto_resize == AUTO_RESIZE_GROW_SHRINK)", unless you have strong
> reasons not to do so.

I would argue that by removing AUTO_RESIZE_UNDEF, I am making this
option more like our existing ones. Are there any options that we have
an UNDEF value for, where we don't need it to mean that we should use a
default which is defined someplace else? We either need UNDEF to show
that an option was not included in a devices or multipaths section, or
to mean that we should use a default system value defined outside of
multipath, like for dev_loss_tmo or max_fds. I don't see what it gets us
for an option like this where mulitpath must always have some defined
default behavior. There are many options that don't have and UNDEF
value. All the yes/no values that only exist in the defaults section, as
well as defaults section only options with multiple values like
force_reload and queue_without_daemon.

I'm fine with explicitly defining a DEFAULT value and setting it in
__init_config(). There are options where 0 is not UNDEF where don't do
this, like force_reload and queue_without_daemon (as well as most of the
ones where we only have yes/no values), and there are options where we
do explicitly set the option to 0, like reassign_maps and force_sync.
Manually setting the value to 0 is unnecessary, but I agree that it's
clearer to define it explicitly.

How does that sound (removing AUTO_RESIZE_UNDEF, but keeping and
actually setting the default)?

-Ben

> 
> Regards,
> Martin

