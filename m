Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A6F7484
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719514128; cv=none; b=EZmU/AH55jz8g+bgqG170QEeKi2WbX1EQQoD/EhDOpt+nJZxhQ7CT2l63auCPLAr8OuL+jvYWAz0aPOhs/wwPEeOjW937ikz6AiJD8Z03TubqzZSEE/jPApwEa0LMVKtOqJET8zYIQUJq22HbopThcy1H4/7+gvivZRakoUApuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719514128; c=relaxed/simple;
	bh=EKKz2KaqZ7hpQ9C+kTy1jGW6Jh180nTfRx2URmc8fG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=PWGtFSuwzkJgJWmHR/0u9X4Y/RMhcC/T6hOcnjAbUyepiHDOjJKnTRSbGpNxnEHPMvcxBmG399Nj4OqQnmp2/KJ2rS/bb8oicVLRSfc+ZLTMxts2px4CG55i0hfsETd5MeoIxR4ClOnMbkX98mbEd2Rx4QH5CqS4CABaMz2vE98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RzyR/+94; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RzyR/+94"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719514124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G6365meiu22WfRVVwZgX8KiZH8Y8wJRCkwuV45VtnB0=;
	b=RzyR/+94bBuTmltxsRVfYJgAjV7ITRQC/NVypk0MX/F1NPGrmiB6wwl7CWtJMXjhhLeJ1T
	wsYTJIZLJ17JnSdEEZNXyY+BES8C31yepFl/5bPrubEAWc8bU/TqAXbZ+LoxRq9J5xA7m5
	6J2FoVPmj3Ps63tsfq73Du8fXKZ5tBk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-XuZxdP9KOWCYGNDMoORUng-1; Thu,
 27 Jun 2024 14:48:41 -0400
X-MC-Unique: XuZxdP9KOWCYGNDMoORUng-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 258591944D23;
	Thu, 27 Jun 2024 18:48:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7729419773E6;
	Thu, 27 Jun 2024 18:48:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45RImcJ61458561
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 14:48:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45RImblY1458560;
	Thu, 27 Jun 2024 14:48:37 -0400
Date: Thu, 27 Jun 2024 14:48:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 4/7] libmultipath: add name and minor outputs for
 dm_map_present_by_uuid()
Message-ID: <Zn20BcBvXJLClyyI@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
 <20240605232254.623290-5-bmarzins@redhat.com>
 <6204dbb3f98a53b472e52c0356a16260f95ba2af.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <6204dbb3f98a53b472e52c0356a16260f95ba2af.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jun 27, 2024 at 11:27:41AM +0200, Martin Wilck wrote:
> On Wed, 2024-06-05 at 19:22 -0400, Benjamin Marzinski wrote:
> > add arguments to dm_map_present_by_uuid() to allow optionally
> > fetching
> > the device name and minor number for the devices found by WWID. These
> > will be used by a later patch.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> I have to say I don't like this much. At least the function name should
> be changed. But actually, our handling of DM_DEVICE_INFO and
> DM_DEVICE_STATUS dm tasks needs refactoring. As far as the kernel is
> concerned, all dm ioctls that refer to an existing map will find the
> map either by uuid, by name, or by major/minor, and the map uuid and
> name will always be filled in.
> 
> I'll see if I can come up with something to clean this up.

Do you want be to resend this patch with a name change, or will that
just happen as part of your cleanup?

-Ben

> 
> Regards
> Martin 
> 
> 
> > ---
> >  libmultipath/devmapper.c          | 11 ++++++++++-
> >  libmultipath/devmapper.h          |  2 +-
> >  libmultipath/libmultipath.version |  2 +-
> >  libmultipath/valid.c              |  2 +-
> >  4 files changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 08bb3c51..7fe68841 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -936,7 +936,7 @@ out:
> >   *  -1 : error
> >   */
> >  int
> > -dm_map_present_by_uuid(const char *uuid)
> > +dm_map_present_by_uuid(const char *uuid, char **name_p, int *minor)
> >  {
> >  	struct dm_task *dmt;
> >  	struct dm_info info;
> > @@ -966,6 +966,15 @@ dm_map_present_by_uuid(const char *uuid)
> >  		goto out_task;
> >  
> >  	r = !!info.exists;
> > +	if (!r)
> > +		goto out_task;
> > +
> > +	if (name_p) {
> > +		const char *name = dm_task_get_name(dmt);
> > +		*name_p = (name && strlen(name)) ? strdup(name) :
> > NULL;
> > +	}
> > +	if (minor)
> > +		*minor = info.minor;
> >  
> >  out_task:
> >  	dm_task_destroy(dmt);
> > diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> > index 19b79c5b..d9c71e92 100644
> > --- a/libmultipath/devmapper.h
> > +++ b/libmultipath/devmapper.h
> > @@ -43,7 +43,7 @@ int dm_simplecmd_noflush (int task, const char
> > *name, uint16_t udev_flags);
> >  int dm_addmap_create (struct multipath *mpp, char *params);
> >  int dm_addmap_reload (struct multipath *mpp, char *params, int
> > flush);
> >  int dm_map_present (const char *name);
> > -int dm_map_present_by_uuid(const char *uuid);
> > +int dm_map_present_by_uuid(const char *uuid, char **name_p, int
> > *minor);
> >  int dm_get_map(const char *name, unsigned long long *size, char
> > **outparams);
> >  int dm_get_status(const char *name, char **outstatus);
> >  int dm_type(const char *name, char *type);
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index eb511749..600de394 100644
> > --- a/libmultipath/libmultipath.version
> > +++ b/libmultipath/libmultipath.version
> > @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
> >  	put_multipath_config;
> >  };
> >  
> > -LIBMULTIPATH_24.0.0 {
> > +LIBMULTIPATH_25.0.0 {
> >  global:
> >  	/* symbols referenced by multipath and multipathd */
> >  	add_foreign;
> > diff --git a/libmultipath/valid.c b/libmultipath/valid.c
> > index f2237787..3b060192 100644
> > --- a/libmultipath/valid.c
> > +++ b/libmultipath/valid.c
> > @@ -360,7 +360,7 @@ is_path_valid(const char *name, struct config
> > *conf, struct path *pp,
> >  	if (check_wwids_file(pp->wwid, 0) == 0)
> >  		return PATH_IS_VALID_NO_CHECK;
> >  
> > -	if (dm_map_present_by_uuid(pp->wwid) == 1)
> > +	if (dm_map_present_by_uuid(pp->wwid, NULL, NULL) == 1)
> >  		return PATH_IS_VALID;
> >  
> >  	/* all these act like FIND_MULTIPATHS_STRICT for finding if
> > a

