Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C69249F5
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 20:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721161163; cv=none; b=kpXza9BA+BoFGgxi8zxCPjJrAKStxEpxIaPHnZL9dL/2qkBPCk8S6HQzFJrRMjxNq4VeJOYfsKJpDmvnPUwKXDpTUHSsnhN+jtzq5XCrwF445tNY66hBjF3J+FjMAyzRdNG4UGkg9QtYk9LBga0Fc5cRbD/qyHC+wiMEO7siAxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721161163; c=relaxed/simple;
	bh=OfWVEhtKDG5797qj/dQmzQXWWEbBNvrrS+WlPV2dt+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=A2Tt+Q7awr1QL8V/0zNjtFS5GkxsCq8uztzH05NNSvg3LExLcjY6JlluzILcFNY8Dizbxm/g1mfhszC/ww3HAqjM5ZEJV3MqC9sDlLELj9EEhUnbb+nW70Avqr0aLsMGm+TpqnNJygVMUKpOKsLmlf4Z0ZMHdnAIud1WtJRRDok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ude+SuKg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ude+SuKg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721161160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RBcnHFW7EwbLa9ORm4DIGqBHZDkvJgXxKV2zNSDTQPk=;
	b=Ude+SuKgMFNzVtFdaDqxacfb5Vx09Psw8q5NtsJcUwmyNLA0BBaha0qIacT4cI5GzpqqzV
	AsJwkYJk3yvSdInjpvUxQjsHJZrQXvQCeo5hX042JRc5TAVIexgXYuPkw1zkBFzClds0MO
	ppkCmNYC7pjhrsy7Xtz9fATxjM9/L6Y=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-v3RwHf0sNoyMgQjuG9reHQ-1; Tue,
 16 Jul 2024 16:19:19 -0400
X-MC-Unique: v3RwHf0sNoyMgQjuG9reHQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81DAB19560BF;
	Tue, 16 Jul 2024 20:19:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F1191955F3B;
	Tue, 16 Jul 2024 20:19:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GKJG912129614
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 16:19:16 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GKJGHS2129613;
	Tue, 16 Jul 2024 16:19:16 -0400
Date: Tue, 16 Jul 2024 16:19:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 19/49] libmultipath: add libmp_mapinfo()
Message-ID: <ZpbVxHjz5TIAKwTn@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-20-mwilck@suse.com>
 <ZpWltID7xe-rT5tJ@redhat.com>
 <46b6209d0d86f545fdc5cf3b4b95efaf7ada591f.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <46b6209d0d86f545fdc5cf3b4b95efaf7ada591f.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2024 at 05:51:21PM +0200, Martin Wilck wrote:
> On Mon, 2024-07-15 at 18:41 -0400, Benjamin Marzinski wrote:
> > On Fri, Jul 12, 2024 at 07:14:27PM +0200, Martin Wilck wrote:

> > I wonder if we should wrap ibmp_mapinfo in a macro that grabs the
> > function name of the calling function and passes it down to
> > libmp_mapinfo__() otherwise there will be a lot of messages like this
> > or
> > 
> > condlog(2, "%s: map %s doesn't exist", __func__, map_id);
> > 
> > that use "libmp_mapinfo__" as the function, which isn't super useful.
> 
> Right. I think what I'll do is just hardcode "libmp_mapinfo" in these
> messages instead of using __func__.

Actually, I was thinking more of something like:

int do_libmp_mapinfo(int flags, mapid_t id, mapinfo_t info,
		     const char *func)
{
        char idbuf[BLK_DEV_SIZE];

        return libmp_mapinfo__(flags, id, info,
                               libmp_map_identifier(flags, id, idbuf));
}

#define libmp_mapinfo(flags, id, info) \
do_libmp_mapinfo(flags, id, info, __func__)

So we would retain the caller info, but I don't feel that strongly about
it.

> 
> > 
> > > +			condlog(2, "%s: map %s not found",
> > > __func__, map_id);
> > > +			return DMP_NOT_FOUND;
> > > +		} else
> > > +			return DMP_ERR;
> > > +	}
> > > +


> > 
> > I mentioned tihs before, but the DM_MAP_BY_* identifiers only take up
> > 3
> > bytes so __DM_MAP_BY_MASK can just be 3 or (1 << 2) - 1, unless you
> > are
> > reserving space for more identifiers which is fine but probably
> > unnecessary, since libmultipath isn't a stable API. Or is there some
> > other reason I'm missing.
> 
> Is it important that this bit field is "dense"? Indeed I wanted to 
> leave some space, even though your're right that it most probably won't
> be necessary. I thought it might be helpful during debugging, for
> example.
> 
> Perhaps I should have used the entire low byte for the map_by part.
> That might even provide optimization opportunities for the compiler.
> Unless you object, this is what I'll do.

That's fine. Like I said, it's not a stable API. If it turns out we
don't like it later, we can always change it then.

-Ben

