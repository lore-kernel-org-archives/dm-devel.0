Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3739C148FF0
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 19:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732043607; cv=none; b=DOvVkx2lVuGbJK2TEAZ7WHbaURAA0pIOoNmzmMXMpI+N2hvgeGD4uuzMJyeJlKa/epLval+1KP4MQxPIykKzYTtcWz0GxxirGR3dN/szopJ/qCb+i72v8V+wRfOuMayrUQPuz9tWGnfndV86Y/z6K29GZpoPKXNGqUeJeBaYjQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732043607; c=relaxed/simple;
	bh=rID8gJeqYJoWXf5+5A6YiDrLl3MUZDYZs72ilQ8Nxj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ab0gImK3kwivYdOpNB5/qu/dWVj/aM1qbniejzyxoAomMt3MwK+0Erd9lTrOxjsy8kTbcNNAJgx8IywxihzLovWhMCoXFMmw2zvr8ZltM85DhgV7fZwDIAdTwv3m0ZNW0EjzZOD7bYGOWM3Extug8fd9q+wDMMNB7WrTMNB7t6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DdJcysas; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DdJcysas"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732043604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FPdLTLTSf1gdb+MdCPLp5/RZIzCZQQ4ZTCU2v2+XnJk=;
	b=DdJcysasJ5rmB0RaicO7rP9aw974FZoA+nsPX6TisE7ACjDRe4tTx1v1OSK+/oTS8RCt17
	STCbc/RDXGAPWPrgRfiz/MikyENHbQnJLOY54W+1GdKUc+mEqhyPH5blXwW8UKx9XOLNH9
	9sHdnhfW51qNs7G2vVSGKjj6a0IU6fw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-ueHHJ4bbNB-n_JsilST2aw-1; Tue,
 19 Nov 2024 14:13:20 -0500
X-MC-Unique: ueHHJ4bbNB-n_JsilST2aw-1
X-Mimecast-MFC-AGG-ID: ueHHJ4bbNB-n_JsilST2aw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 542C91955DC3;
	Tue, 19 Nov 2024 19:13:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D19631956056;
	Tue, 19 Nov 2024 19:13:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AJJDHdY679430
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 14:13:17 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AJJDHud679429;
	Tue, 19 Nov 2024 14:13:17 -0500
Date: Tue, 19 Nov 2024 14:13:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 0/6] multipath-tools: Handle tableless DM devices
Message-ID: <ZzzjTcBHm2T5AXQu@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
 <fbab2026d6850617f84da01c9c075f468295aa3b.camel@suse.com>
 <ZzuuUTMJgFPWV16s@redhat.com>
 <23860ac02355acab86798e2ce3d582ebed61a0d6.camel@suse.com>
 <1a516ff0aaf34d88da065a1f504606450eb871bc.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <1a516ff0aaf34d88da065a1f504606450eb871bc.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZHISrh6aLxdMOlyApaYMBBksvRTusrE26jQfX7a_juc_1732043599
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Nov 19, 2024 at 05:40:19PM +0100, Martin Wilck wrote:
> On Tue, 2024-11-19 at 13:20 +0100, Martin Wilck wrote:
> > On Mon, 2024-11-18 at 16:14 -0500, Benjamin Marzinski wrote:
> > > On Mon, Nov 18, 2024 at 12:18:20PM +0100, Martin Wilck wrote:
> > > > On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> > > > > 
> > > > > I'm not completely happy with the MAPINFO_ID_IF_FOUND flag. An
> > > > > alternative would be to run a second libmp_mapinfo() call
> > > > > without
> > > > > MAPINFO_MPATH_ONLY to grab the name, if the first failed with
> > > > > DMP_EMPTY.
> > > > > If people think that's a better way to solve this, I can rework
> > > > > those
> > > > > patches.
> > > > 
> > > > We could simply choose to always fill in this information if the
> > > > the caller has requested it, without an additional input flag.
> > > > It's
> > > > not
> > > > an expensive operation. Is there a reason not to do this?
> > > 
> > > Your comments in the code said that libmp_mapinfo() will not touch
> > > any
> > > of the output parameters if it doesn't succeed. I didn't audit the
> > > code,
> > > but I can certainly imagine a situation where you passed in
> > > pointers
> > > to
> > > some varaibles that already had values and you didn't want those
> > > values
> > > overwritten unless libmp_mapinfo() returned DMP_OK.
> > > 
> > > But I can go look and see if any callers would get messed up if
> > > name
> > > or
> > > uuid got set, even when the found device didn't match.
> > 
> > I am pretty sure that that shouldn't happen. The memory must be
> > allocated anyway, and callers can't ignore the return value. But
> > double-checking is a good idea, of course, and we should adapt the
> > documentation.
> 
> I just looked through the code. Except for the unit tests, I only found
> one call where this matters:
> 
> dm_find_map_by_wwid() fills in the name if non-NULL. This is only used
> by cli_add_map(), where it doesn't cause an issue.

Yep. In my patch that adds MAPINFO_ID_IF_FOUND to dm_find_map_by_wwid(),
I even use the returned name to print out a better error message. Which,
BTW I noticed that mpath_get_map() also does, even though we haven't
been setting name on DMP_NO_MATCH returns, so this has been broken. 

I was also wondering if we could do the same thing with info.dmi, since
that will also be set whenever we find a device, even if it doesn't
match the type of device we're looking for. The only problem with that
is that update_multipath_table() would then set mpp->dmi even on
DMP_NO_MATCH or DMP_EMPTY. Now, if update_multipath_table() returns
one of those values, something is already very wrong. But even still,
I think we should not overwrite the existing dmi value. Of course it's
simple to just create a tmp dmi variable, and only overwrite the
mpp->dmi on DMP_OK.

I should note that just removing the MAPINFO_ID_IF_FOUND flag won't
remove most of the complexity of ("libmultipath: Add flag to always
return device ID when found"), since most of the code exists to make
sure that the other output variables aren't updated if allocating space
for the status and target outputs fail. This means that no outputs are
ever touched when we return DMP_ERR. 

If we don't care about that, and just say that the uuid, name, and dmi
output parameters may be overwritten regardless of the return status
of libmp_mapinfo(), then we can set those values as soon as we know
them, and most of that patch becomes very small. I'm not sure if it
really matters one way or the other.

-Ben
 
> Martin
> 
> 
> 
> 
> 
> > 
> > Martin
> > 

