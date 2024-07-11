Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEBC16D33D
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 16:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720715924; cv=none; b=gPipndXOwonK/BQBLZ61wSzO6VqeQZOFSCwtg9Arcs2fvMFdwGW+DY00dZK3eWRFEDG8T8d+smxPdVN8peOiCKMAWwcf9ATtI0bOOloFahmU5WigXumzWDk1i3iZ1xiQq3b/dR6U4taNoNabHB2E0s/q6wHReJrt7WGmI6frkYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720715924; c=relaxed/simple;
	bh=km+3dgW6m+P80ppVcSNo/pvtT8XUqsjr8qbdPY3/ZRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=oe8d5WTBTbnzeVLplOy6jLnqeoAtRrKy0oFVAVMUQIXf7ElGU3e3WtUcsyZ9Gz2S2rJdL3PFlIEMYUksMb9jtnDsXI/9xpMF35/R6SQWqrDY+xD+0sPQ5KO+iVZ6n/u54Sxdvm4DM/CQGVRa2hMZGcWa7kcWu42pim1iMYuamPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e3weRAvK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e3weRAvK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720715921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dy+Ii/Rawi/hrZHvYelrP5kUo6ASodS7G/fxsEHttso=;
	b=e3weRAvKOcbC0jCa5XWyM8+QSJs2q1RncN1zkHJmOJjrxDmAwImj7pT6c7IK4TFU56Zll5
	eZeplndBlprjRjh7XHhUJen/SvH9MJHlC+1p86gZn0b7TDKq9pzmLa5DBpAM9QAgvW5Ixr
	HjCom4rFt+dqXAhPGydoBsgNt5lvp58=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-vfvnNoQkOHGJ_QGaZ64s0Q-1; Thu,
 11 Jul 2024 12:38:38 -0400
X-MC-Unique: vfvnNoQkOHGJ_QGaZ64s0Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E0781955BCD;
	Thu, 11 Jul 2024 16:38:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3B4D19560AA;
	Thu, 11 Jul 2024 16:38:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46BGcZAd1947531
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 12:38:35 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46BGcYfb1947530;
	Thu, 11 Jul 2024 12:38:34 -0400
Date: Thu, 11 Jul 2024 12:38:34 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 23/44] libmultipath: improve dm_get_wwid() return value
 logic
Message-ID: <ZpAKio0isVeugRZ5@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-24-mwilck@suse.com>
 <Zo8aoNebaxrgKlzo@redhat.com>
 <c97168ac1c8d92b5403453f1be1190cda8a9d1e4.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <c97168ac1c8d92b5403453f1be1190cda8a9d1e4.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jul 11, 2024 at 02:25:54PM +0200, Martin Wilck wrote:
> On Wed, 2024-07-10 at 19:34 -0400, Benjamin Marzinski wrote:
> > On Tue, Jul 09, 2024 at 11:39:14PM +0200, Martin Wilck wrote:
> > > Make dm_get_wwid() return different status codes for non-existing
> > > maps,
> > > maps that exists but are not multipath maps, and generic error
> > > case,
> > > and handle these return codes appropriately in callers.
> > > 
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/alias.c     |  5 +++--
> > >  libmultipath/configure.c | 23 +++++++++++------------
> > >  libmultipath/devmapper.c | 21 ++++++++++++++++-----
> > >  libmultipath/wwids.c     |  2 +-
> > >  tests/alias.c            | 10 +++++-----
> > >  5 files changed, 36 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> > > index 10e58a7..2ab9499 100644
> > > --- a/libmultipath/alias.c
> > > +++ b/libmultipath/alias.c
> > > @@ -408,13 +408,14 @@ static bool alias_already_taken(const char
> > > *alias, const char *map_wwid)
> > >  {
> > >  
> > >  	char wwid[WWID_SIZE];
> > > +	int rc = dm_get_wwid(alias, wwid, sizeof(wwid));
> > >  
> > >  	/* If the map doesn't exist, it's fine */
> > > -	if (dm_get_wwid(alias, wwid, sizeof(wwid)) != 0)
> > 
> > We used to assume the alias was not taken if dm_get_wwid() failed
> > with
> > an error. Now we assume that the alias is taken. I think we should
> > continue to assume we can use the alias if we get DM_ERR.
> 
> I am not sure about this. but I can change it. I guess it's a corner
> case anyway, where there's no obvious right or wrong behavior. 
> 
> A DM_DEVICE_INFO call with this map name failed with an error other
> than ENXIO. By going on with this map name, we clearly risk that future
> failures will happen when we try to create or reload the map in
> question.

Fair enough. The worst that could happen if we keep your method is that
we skip a usable name, which would get used by a future device anyway.
I'm dropping my objection.

-Ben

