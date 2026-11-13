Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794588285;
	b=jwFrkDCMOFb3vhgW+H51SJ0S+yVoTfOjQfJjHKVyKV5N2c/IK3Cw/362BBHrynmJWatc
	 z6qA3eaGy+VJ/p5XXjkre57IuZ9KgwK67OM0/rCmn2BAojQpxEtp56UHtogQFcGeNve5L
	 JhT4p9cQ3V0yT11da8vc4B6xJVqA1mhzlmgaedKRIK1QIru5OnqpJ3o1b2IYiFRCul8ON
	 IWrPgadFuqiM5oadiIQytBHvAtYjQyjQbyyoTbQWHj47K30O5J4l2JyGFdqCt+j4vpq/P
	 SbSc938Bs7f8KYKfj9m0XselhORHiVAToElbTMcztCCvU+64DVULAspFotsjj5++x7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794588285;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding;
	bh=uBOM/iKzLTFQ6RoAGp2AYG5OqmMu2aQzWdTXv+yCfks=;
	b=c2ziOAXCYzNakVz8njHPkbwhO0Sw/t7Z7ZyUymJP3HOmbN8dK/5/VSXgHFQMvvgiwW8w
	 Qxep8UP5vPEwl4+/SuCYxAi22M0Kidsy4e0+WGtxaA5AESsI2D6oHOlPPwe6GXhqK40dI
	 9auMTmBP/glgdwiP1wEi6HH46O+ybAo3zxlMqks1XyyoUUj7fE6zCSGmpvux56KTwI6ym
	 f6/TbEvL9QLT3LAxlXk+r/lLGO9mNgLDSTivJ/4jxItNm+fBYV/b81a40wkAavgwz7Zwj
	 1ukgHyLlxskZXG3hKSt4KWKIaTp6Tz1khhhjzvEF9CtGJtW0Rn1fxv5ZNdU/oDbA8xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZgebcBih;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A655606A887
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 16:44:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A655606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZgebcBih
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794588283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uBOM/iKzLTFQ6RoAGp2AYG5OqmMu2aQzWdTXv+yCfks=;
	b=ZgebcBih18qrJAWR7Kt81iz68ZF+gy0LblULadKP7Uw+701HicWVY69yYnhS0XDB8SOctw
	p2+xe1VuQxmJutC9XGxUHGCk8Coqkj35WWHhc6s34uaL4IOWmGCbxEW+4ePefQkx2HaV+y
	t2jJp2CxfI27RVAypuqZeaT1FIbVlns=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-o4Bt6OSkP_-2zwEegNrs8A-1; Fri,
 13 Nov 2026 11:44:38 -0500
X-MC-Unique: o4Bt6OSkP_-2zwEegNrs8A-1
X-Mimecast-MFC-AGG-ID: o4Bt6OSkP_-2zwEegNrs8A_1794588276
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EA1E1955F41;
	Fri, 13 Nov 2026 16:44:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 391B518004FE;
	Fri, 13 Nov 2026 16:44:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6ADGiZdC2030415
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 13 Nov 2026 11:44:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6ADGiYok2030414;
	Fri, 13 Nov 2026 11:44:34 -0500
Date: Fri, 13 Nov 2026 11:44:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, Hannes Reinecke <hare@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: udev / multipath-tools: WWID determination with SG_IO vs. sysfs
Message-ID: <avc-ctvpTR9COos5@redhat.com>
References: <20261109185556.27139-1-brian@purestorage.com>
 <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com>
 <20261111174259.41911-1-brian@purestorage.com>
 <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com>
 <20261111230535.12947-1-brian@purestorage.com>
 <83f73b9cb1506eb80220759e3e0aae18648f80c4.camel@suse.com>
 <avYaaRagjQOdhnyj@redhat.com>
 <b087c205fa86ccda6743ebcdafb7e5340234a4af.camel@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <b087c205fa86ccda6743ebcdafb7e5340234a4af.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MMhMksLmw5Iphb63_ENejntyIFP4U-M0P5zAYdTTbGY_1794588276
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 12, 2026 at 09:47:54PM +0100, Martin Wilck wrote:
> On Thu, 2026-11-12 at 14:58 -0500, Benjamin Marzinski wrote:
> > On Thu, Nov 12, 2026 at 08:00:58PM +0100, Martin Wilck wrote:
> > 
> >  
> > > Brian's patch would add more such ioctls and thus increase the
> > > likelihood of observing a stall. To be observed.
> > > 
> > 
> > This is true, and unlike the existing recheck_wwids use and the
> > prioritizer, it won't be called right after the path checker
> > determined
> > a path to be up. We do also do SG_IO ioctls in pathinfo when DI_IOCTL
> > is
> > set (when we're adding a path, reconfiguring multipath, or
> > initializing
> > a partial path). In that case we do check if the path is up according
> > to
> > sysfs first, but we don't call the checker.
> 
> So, would you prefer making it conditional on something else but
> "recheck_wwid"?

Since recheck_wwid is set, we could just limit this new
check_path_wwid_change() check in ev_add_path() to paths that are up.
uev_add_path() will run the path checker before we get here. If the path
isn't up, recheck_wwid guarantees that we will do the check when the
path is up.

That should make this no more risky than the existing recheck_wwid
calls.

-Ben
 
> Martin
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>
> SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 Nürnberg,
> Germany
> Geschäftsführer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
> 36809,AG Nürnberg)

