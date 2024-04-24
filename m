Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A421772F
	for <dm-devel@lists.linux.dev>; Wed, 24 Apr 2024 20:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713991390; cv=none; b=sPXEPe4STGFVwJNVy4NQok6Eb0FeH3CKENCnuq/wLsFASIav5NItP8KC6zlVe75u+eWpU1qbNyq/yIgP0z2i21Dj+wVzPZcD3ScTl01qomMiDZP0VEu9tkel/lLCq//+au9K8A/uDdDgx5Yp0SCkoMFSXqCPchj2MBfd/iZevhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713991390; c=relaxed/simple;
	bh=qYF5n5N7gsIjOsOVNRorBG0vxTZKw6XVrIpaJEJ6Alk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=XlaUygEKKlgUWqFa8p+MIOp7Y6VaeMRkYrc2JSGYSZCfBm0xQTR/KfxfwDiXeuKYuU2Xk2FOQIpexNIB4As75W1a9mYFIEIxpOyLbBBDSVNRGcLJXUZFQP6GD1rohnPvKhC3J6leS888jkj3PnNDt6PgCKYP/CykVxXpRNSlbFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Iucb805b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Iucb805b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713991388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4qoHWmD2MEBgUlNkPbNxn9aoCQZ1G2zQtP9nVRptrSk=;
	b=Iucb805bfhfTsYwMSWhO88UL5dZX35ASsyKuNKMtzg6xQ6QeWSVH4TsZdPNcUUv+zaS/pG
	jZuhr7QfdMq90UgcjrHzmoEUkPN2UWlIr41mXZQdM3co8XK65zaptsj3fb0Oz5yVn4g/dq
	oOl8ZEAXRTRaxyrKpdQwaNwCB0b61Tk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-QfjuGySkOrWU0yo6CM15Bg-1; Wed, 24 Apr 2024 16:43:06 -0400
X-MC-Unique: QfjuGySkOrWU0yo6CM15Bg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DAA118065BB;
	Wed, 24 Apr 2024 20:43:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F709EC680;
	Wed, 24 Apr 2024 20:43:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43OKh5XE2108840
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 16:43:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43OKh51B2108839;
	Wed, 24 Apr 2024 16:43:05 -0400
Date: Wed, 24 Apr 2024 16:43:05 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/3] libmultipath: simplify dm_flush_map_nopaths
Message-ID: <Zilu2YaY48HRa6iK@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240423222536.2096486-1-bmarzins@redhat.com>
 <20240423222536.2096486-4-bmarzins@redhat.com>
 <00855491fbf55a026919fad059218bcab7ffd14d.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <00855491fbf55a026919fad059218bcab7ffd14d.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Apr 24, 2024 at 06:40:36PM +0200, Martin Wilck wrote:
> On Tue, 2024-04-23 at 18:25 -0400, Benjamin Marzinski wrote:
> > Now that flush_map_nopaths(), its only caller, needs to deal with
> > whether or not a remove is deferred, dm_flush_map_nopaths()
> > doesn't need to worry if LIBDM_API_DEFERRED is defined. It can just
> > trust that the caller took care of making sure deferred_remove is
> > correct.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/devmapper.c          | 19 -------------------
> >  libmultipath/devmapper.h          |  3 ++-
> >  libmultipath/libmultipath.version |  3 +--
> >  3 files changed, 3 insertions(+), 22 deletions(-)
> > 
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 24d03e83..dc8c4d17 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -1140,25 +1140,6 @@ int _dm_flush_map (const char * mapname, int
> > need_sync, int deferred_remove,
> >  	return DM_FLUSH_FAIL;
> >  }
> >  
> > -#ifdef LIBDM_API_DEFERRED
> > -
> > -int
> > -dm_flush_map_nopaths(const char * mapname, int deferred_remove)
> > -{
> > -	return _dm_flush_map(mapname, 1, deferred_remove, 0, 0);
> > -}
> > -
> > -#else
> > -
> > -int
> > -dm_flush_map_nopaths(const char * mapname,
> > -		     int deferred_remove __attribute__((unused)))
> > -{
> > -	return _dm_flush_map(mapname, 1, 0, 0, 0);
> > -}
> > -
> > -#endif
> > -
> >  int dm_flush_maps (int retries)
> >  {
> >  	int r = DM_FLUSH_FAIL;
> > diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> > index 2987a1b5..8599ee98 100644
> > --- a/libmultipath/devmapper.h
> > +++ b/libmultipath/devmapper.h
> > @@ -61,7 +61,8 @@ enum {
> >  
> >  int partmap_in_use(const char *name, void *data);
> >  int _dm_flush_map (const char *, int, int, int, int);
> > -int dm_flush_map_nopaths(const char * mapname, int deferred_remove);
> > +#define dm_flush_map_nopaths(mapname, deferred) \
> > +	_dm_flush_map(mapname, 1, deferred, 0, 0)
> 
> Perhaps we can do away with dm_flush_map_nopaths entirely.

You mean by directly calling _dm_flush_map instead, since there's only
one caller of dm_flush_map_nopaths()? Sure.

-Ben
 
> 
> >  #define dm_flush_map(mapname) _dm_flush_map(mapname, 1, 0, 0, 0)
> >  #define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0, 0, 0,
> > 0)
> >  #define dm_suspend_and_flush_map(mapname, retries) \
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index e070f296..806676bf 100644
> > --- a/libmultipath/libmultipath.version
> > +++ b/libmultipath/libmultipath.version
> > @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
> >  	put_multipath_config;
> >  };
> >  
> > -LIBMULTIPATH_23.0.0 {
> > +LIBMULTIPATH_24.0.0 {
> >  global:
> >  	/* symbols referenced by multipath and multipathd */
> >  	add_foreign;
> > @@ -74,7 +74,6 @@ global:
> >  	dm_enablegroup;
> >  	dm_fail_path;
> >  	_dm_flush_map;
> > -	dm_flush_map_nopaths;
> >  	dm_flush_maps;
> >  	dm_geteventnr;
> >  	dm_get_info;

