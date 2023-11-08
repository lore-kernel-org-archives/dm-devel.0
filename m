Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D4632C67
	for <dm-devel@lists.linux.dev>; Wed,  8 Nov 2023 22:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DSGQfjHO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699482287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iOzNr4B7IFW6VjlkUISn7f0hoX6UBNLmw3cubbgtNJ8=;
	b=DSGQfjHOisGgzuDNmd+US5tmjfHwWYSo8SkB2FdUthUIbkua2z5sX6HNUEALl5iG/Owaar
	MC2JPuNc7Cs5v7H+7kqC6k6eVnF/oDB/+6emA0UP517+higcRmNZNftdbG86+ZYiHXTZrr
	muPuYu+q/xK+AFew7ALR+y1Is96Z470=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-1EKNPxwsPAKBwa5EPEWvIQ-1; Wed, 08 Nov 2023 17:24:43 -0500
X-MC-Unique: 1EKNPxwsPAKBwa5EPEWvIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A28CC814042;
	Wed,  8 Nov 2023 22:24:43 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C9C725C4;
	Wed,  8 Nov 2023 22:24:43 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 3A8MOhXj089974
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 8 Nov 2023 17:24:43 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 3A8MOh3p089973;
	Wed, 8 Nov 2023 17:24:43 -0500
Date: Wed, 8 Nov 2023 17:24:43 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>,
        "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 7/7] libmultipath.version: bump ABI version to 22.0.0
Message-ID: <ZUwKq+hyigfxuBMC@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231102221507.105371-1-bmarzins@redhat.com>
 <20231102221507.105371-8-bmarzins@redhat.com>
 <509ad8171e44d691b19c5d1c7866986f67ebf87d.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <509ad8171e44d691b19c5d1c7866986f67ebf87d.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 08, 2023 at 06:10:26PM +0000, Martin Wilck wrote:
> On Thu, 2023-11-02 at 18:15 -0400, Benjamin Marzinski wrote:
> > Commits ("libmultipath: Add max_retries config option") and
> > ("multipathd: Add auto_resize config option") changed the size and
> > member offsets of multiple structs.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> 
> 
> I should have bumped the ABI with my patch "libmultipath: deprecate
> bindings_file, wwids_file, prkeys_file" already. If you don't mind,
> just drop this, and I'll fix the ABI issues when I push to the "queue"
> branch.
> 
> I'd like to create a PR to Christophe soon, basically as soon as this
> series is reviewed.

Sure.

> 
> Thanks,
> Martin
> 
> 
> > ---
> >  libmultipath/libmultipath.version | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index 8368ef7a..8ab7c802 100644
> > --- a/libmultipath/libmultipath.version
> > +++ b/libmultipath/libmultipath.version
> > @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
> >  	put_multipath_config;
> >  };
> >  
> > -LIBMULTIPATH_21.0.0 {
> > +LIBMULTIPATH_22.0.0 {
> >  global:
> >  	/* symbols referenced by multipath and multipathd */
> >  	add_foreign;

