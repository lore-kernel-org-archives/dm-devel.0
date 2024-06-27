Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3489119AA7D
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 18:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719513560; cv=none; b=ZZxtC5jlLuFHmH5WfE1X2jbsbG8OYwVoR3jO+GzHsdxtMAKLXx4njmi+Zkcnp8N2fV3dkzW2x2cHdYyaQ8QprP7WrfR55W7ey3OwO+NIghfo0LsDigOJp6lE4uIGNZsT+QTnn/niLNqDUF1cdMU4YBDgkFZRsLslsr3x47DtTxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719513560; c=relaxed/simple;
	bh=UsKTlC1VcZ7GeuWb8BuNHVPyRER8CigfkDdrvaSuDDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=DxO/2oJ2+mziTvHt8LvMksBsVgglRNk1rXyJr0Pj1oJ/1X+4HTpOi9HTOqnKmkZQTQlrtmR1TKFjOk6iSgmlrXeMDJ4Xw81/C0UWGDcKvjx8t+eSZRxDodMzcg0/02ptN8OH7imgk1MwM36Y7tJxu1MgbuxAMZ5XF7zm53g4Mo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g8MOJ6n9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g8MOJ6n9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719513557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YG+BqCmM4NkdeLqtvYma+vcDLhPKAOsaXwanj0bp9kE=;
	b=g8MOJ6n9nwFbM/VMAZ/v52eEkCPeNSWRIp4psj9Sp7jBrt5wb6mHPDcmnCbHNZrLvq89Mv
	4KwAwMVxzaiWktrGb1eGYkhbSR1XT566zUghl1Ccve7nkPMpMXya1YcYPEmrXFe59rI6nr
	vtaiSAsC/ry8ZQS2E6AAiStKiGDtDm0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-45-lO8UeuArMAKYBpvT1Z5BBA-1; Thu,
 27 Jun 2024 14:39:13 -0400
X-MC-Unique: lO8UeuArMAKYBpvT1Z5BBA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C662E195608C;
	Thu, 27 Jun 2024 18:39:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57DFB3000225;
	Thu, 27 Jun 2024 18:39:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45RIdAnH1458355
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 14:39:10 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45RIdA3n1458354;
	Thu, 27 Jun 2024 14:39:10 -0400
Date: Thu, 27 Jun 2024 14:39:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/7] multipathd: refresh multipath before calling
 set_no_path_retry()
Message-ID: <Zn2xzs0uxpWmIMyh@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
 <20240605232254.623290-4-bmarzins@redhat.com>
 <7551690cc28e39dc733c57ae1a9e657c469aafb3.camel@suse.com>
 <Zn2wW55XxNn4ju2e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Zn2wW55XxNn4ju2e@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jun 27, 2024 at 02:33:00PM -0400, Benjamin Marzinski wrote:
> On Thu, Jun 27, 2024 at 09:47:33AM +0200, Martin Wilck wrote:
> > On Wed, 2024-06-05 at 19:22 -0400, Benjamin Marzinski wrote:
> > > Make sure that all callers of set_no_path_retry() update the
> > > multipath->features string from the kernel before calling it, so that
> > > they have the current queueing state to check.
> > > 
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > 
> > I am not sure about this one. 
> > 
> > refresh_multipath() is not a cheap operation, requiring at least 3
> > device-mapper ioctls, and we hold the multipath lock while we call it,
> > meaning that multipathd can't take care of other important things while
> > it's handling this CLI request.
> > 
> > OTOH, the kernel only changes the features string when the map is
> > reloaded. Nobody should be reloading the map under normal conditions
> > anyway, and if they do, we would see an uevent shortly afterwards. IOW,
> > I think it's safe to assume that multipathd has the correct features
> > string cached, except in pathological situations.
> > 
> > Am I overlooking something? Do you have evidence of errors occuring
> > because multipathd has a wrong features string cached?
> 
> Well, I did run into a situation where I couldn't disable queueing
> because of mpp->features being out of date. I fixed that specific issue
> in patch 1/7. But in a broader context, the kernel doesn't send out any
> events when it gets a message to change the queueing mode in the
> features string, so there is always a possibility that something outside
> of multipathd changed it, and multipathd doesn't find out about it.
> Normally, check_path() will find out and resolve the issue within
> seconds. However, if the multipath device lost all its path devices,
> then check_path() won't ever call set_no_path_retry() on it

Err... It won't ever call update_multipath_strings(), which is
what will sync the mpp->features string with the kernel and make
set_no_path_retry() do the right thing.

> and nothing
> will resync it with the kernel state until an event comes in.
> 
> Here's a (admittedly fairly improbable) sequence of events that would
> get you into problems.
> 
> - There is a multipath device with no paths that is currently in
> recovery mode waiting to timeout. It's opened by something with
> outstanding IO.
> 
> - A user runs "multipath -f" to remove the device, and deligation to
> multipathd times out so multipath attempts to locally remove the
> device. It disables queueing and attempts the remove, which fails
> because the device is still in use.
> 
> - multipathd hits the retries timeout and disables queueing.
> 
> - multipath restores queueing because the remove failed.
> 
> - more IO comes into the multipath device.
> 
> In this case, the multipath device will be stuck open due to queued
> IO. The user could reasonably try to disable queueing to resolve this
> issue. This will report success, but not actually do anything.
because multipathd never syncs the features string with the kernel
before calling set_no_path_retry().

> 
> Granted, there is an unavoidable race here. It's always possible that
> after multipathd updates the features string, it gets changed outside of
> its control. But this cuts the window down to something small instead
> of anytime after you lost all your paths. Any if you get unlucky enough
> to hit that window, you can just rerun the command and it will work.
> 
> My main reason for wanting this is that cli_disable_queueing() (and
> friends) is not a command you run all the time. It's a command to run
> when you are cleaning up a mess. It doesn't have to be fast. It has to
> work when things are stuck.
> 
> Thoughts?
> 
> -Ben
> 
> > Regards
> > Martin
> > 
> > 
> > 
> > 
> > 
> > 
> > > ---
> > >  multipathd/cli_handlers.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > > 
> > > diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> > > index 117570e1..3dc5e690 100644
> > > --- a/multipathd/cli_handlers.c
> > > +++ b/multipathd/cli_handlers.c
> > > @@ -934,6 +934,8 @@ cli_restore_queueing(void *v, struct strbuf
> > > *reply, void *data)
> > >  		pthread_cleanup_push(put_multipath_config, conf);
> > >  		select_no_path_retry(conf, mpp);
> > >  		pthread_cleanup_pop(1);
> > > +		if (refresh_multipath(vecs, mpp))
> > > +			return -ENODEV;
> > >  		set_no_path_retry(mpp);
> > >  	} else
> > >  		condlog(2, "%s: queueing not disabled. Nothing to
> > > do", mapname);
> > > @@ -956,6 +958,10 @@ cli_restore_all_queueing(void *v, struct strbuf
> > > *reply, void *data)
> > >  			pthread_cleanup_push(put_multipath_config,
> > > conf);
> > >  			select_no_path_retry(conf, mpp);
> > >  			pthread_cleanup_pop(1);
> > > +			if (refresh_multipath(vecs, mpp)) {
> > > +				i--;
> > > +				continue;
> > > +			}
> > >  			set_no_path_retry(mpp);
> > >  		} else
> > >  			condlog(2, "%s: queueing not disabled.
> > > Nothing to do",
> > > @@ -983,6 +989,8 @@ cli_disable_queueing(void *v, struct strbuf
> > > *reply, void *data)
> > >  	mpp->retry_tick = 0;
> > >  	mpp->no_path_retry = NO_PATH_RETRY_FAIL;
> > >  	mpp->disable_queueing = 1;
> > > +	if (refresh_multipath(vecs, mpp))
> > > +		return -ENODEV;
> > >  	set_no_path_retry(mpp);
> > >  	return 0;
> > >  }
> > > @@ -1001,6 +1009,10 @@ cli_disable_all_queueing(void *v, struct
> > > strbuf *reply, void *data)
> > >  		mpp->retry_tick = 0;
> > >  		mpp->no_path_retry = NO_PATH_RETRY_FAIL;
> > >  		mpp->disable_queueing = 1;
> > > +		if (refresh_multipath(vecs, mpp)) {
> > > +			i--;
> > > +			continue;
> > > +		}
> > >  		set_no_path_retry(mpp);
> > >  	}
> > >  	return 0;

