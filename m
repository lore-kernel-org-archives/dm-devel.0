Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF4219B3D1
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721139739; cv=none; b=MwTJH4rELdw0ypTb93zik4lMB1LjyCiW3XsvjyRCZCRE9zBjPOBB/06fw1djjyWbrRibVkrkmchq3u8MdXaDBpQ7va+yjkswgHsp1FiQ9xxhVYO1lfC8fiRX1Dj6Hv5KDJ8q+zC2TxRfTrTF8Jze5PQzlQ0/gLaDNShE1SXrhFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721139739; c=relaxed/simple;
	bh=AqHP2nz1H5BciLB2DP8fxv7CWxvwJcg6e2c/cCO+V5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=JqDqw514QUeHwmpph28iDHyqBNOHy7/FENMem2Q2gwq02SlCSYkKFIXgM6+gN7O0kS5YHzzRZ/JTaAaZsb0jgOo1s83U9Bd6lwmOeQnjnhlSYtr8k8/6Sxls3jeQtOYysqsN3GtRCUV8x9C2nVQRn7B7G/ja9WWIzJWrXa42FNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WNqXSZ2I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WNqXSZ2I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721139736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0OtHrY1QPJtmenx4aWDW4tuocx69a058iNzE1Lx8E18=;
	b=WNqXSZ2ITrAV4qa373rF/cZ//t505Ot3EfNOlaFsczhpSPc2DXB4Xlf7p3XEPoAq5AVLLl
	8LKVs594vJ/wEg6NNwUWvPO8lO1XvsyGJc6cxiXSIR56di2XL8I+scU8sECuB+kEvUp6Ao
	jUWVKNRXx73ohZIPDyPQsUc9OZRj0ic=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-Dt_2haeZOnyba2nOgVzy5Q-1; Tue,
 16 Jul 2024 10:22:15 -0400
X-MC-Unique: Dt_2haeZOnyba2nOgVzy5Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CB541955D4C;
	Tue, 16 Jul 2024 14:22:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9607319560B2;
	Tue, 16 Jul 2024 14:22:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46GEMCVo2120310
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jul 2024 10:22:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46GEMBTt2120309;
	Tue, 16 Jul 2024 10:22:11 -0400
Date: Tue, 16 Jul 2024 10:22:11 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 01/22] libmultipath: rename dm_map_present_by_wwid() and
 add outputs
Message-ID: <ZpaCE-Xx9Ea8SM8r@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
 <20240713060506.2015463-2-bmarzins@redhat.com>
 <b4d185692c0f968926e158bbfd547aeeecf56b62.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <b4d185692c0f968926e158bbfd547aeeecf56b62.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jul 15, 2024 at 05:14:36PM +0200, Martin Wilck wrote:
> On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> > add arguments to dm_map_present_by_wwid() to allow optionally
> > fetching
> > the device name and minor number for the devices found by WWID. 
> > These
> > will be used by a later patch. Since it can now also be used to get
> > the
> > name and minor number of a device from its WWID, rename it to
> > dm_find_map_by_wwid()
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/devmapper.c | 16 ++++++++++++----
> >  libmultipath/devmapper.h |  2 +-
> >  libmultipath/valid.c     |  2 +-
> >  tests/valid.c            | 12 ++++++------
> >  4 files changed, 20 insertions(+), 12 deletions(-)
> > 
> > diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> > index c28991fb..1de694c9 100644
> > --- a/libmultipath/devmapper.h
> > +++ b/libmultipath/devmapper.h
> > @@ -132,7 +132,7 @@ int dm_simplecmd_flush (int task, const char
> > *name, uint16_t udev_flags);
> >  int dm_simplecmd_noflush (int task, const char *name, uint16_t
> > udev_flags);
> >  int dm_addmap_create (struct multipath *mpp, char *params);
> >  int dm_addmap_reload (struct multipath *mpp, char *params, int
> > flush);
> > -int dm_map_present_by_wwid(const char *uuid);
> > +int dm_find_map_by_wwid(const char *wwid, char *name, int *minor);
> > 
> 
> Nitpick: According to my personal taste, it would be cleaner to pass in
> the entire dm_info structure rather than just the minor number. One day
> we may need other fields as well.

Sure.

> 
> Martin

