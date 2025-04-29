Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF55920C488
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 20:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958444; cv=none; b=HbwVKTzBFXkjo732efdumzIAdzv3SE0V9szGC/opttgkBczzybQ1LP9Hgivn4p6e4YrZFaJWyxXGFIbPSRFNwOfd8YZoVShqUbL9mlB9fIKdX+kWJ1nsfUFWQ4YDstc7bFFqvLbQr8ZOYXw3RZ+7GnADVpO1ISLEixbKl/vy6vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958444; c=relaxed/simple;
	bh=dvSV5NwKtrxfQyvGMcszmiJLFDRiOFvmN/Xp3Ta8ctA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=LZQjJzzS+s8+8R2roLbmpQgVwhrk8dzMpdfCIEBtfu3W9lcCvAPaFCwlA08OWJBP7LkYfC9wK9QwGLjKKaOcARiEX44b0I4v/4mx4sxcWepCwHAj93E7xeXAb2LGkgbLvmtvDG3X42GGxJ78pcxFzCkntV4gGBo48RNX0hok8Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J8U/gQxj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J8U/gQxj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745958441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+8yxGxTKw5tFVlPt8Gj3q7ILg2VXwXDxgU6BK6rVWGA=;
	b=J8U/gQxjrkicG+lN7/MwmafI0Mey3+WQA99GuwTwnoXk2wJBKWxr4/exNehDXlMLHBDTjG
	QF8e3Tt6eukyUX7zvtQV7E8seouRrX+W3F98Bd8oaCuDx7TGeOUZP2GOtDaXhSbHecgmeA
	eopDnJ66O0ubAQBpO7i9vxmozU9G+zo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-446-T2QFI1jeND2Qmi94EJJDIQ-1; Tue,
 29 Apr 2025 16:27:17 -0400
X-MC-Unique: T2QFI1jeND2Qmi94EJJDIQ-1
X-Mimecast-MFC-AGG-ID: T2QFI1jeND2Qmi94EJJDIQ_1745958436
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66AD61800876;
	Tue, 29 Apr 2025 20:27:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2317218001D7;
	Tue, 29 Apr 2025 20:27:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53TKRE9P1951204
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Apr 2025 16:27:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53TKRDFY1951203;
	Tue, 29 Apr 2025 16:27:13 -0400
Date: Tue, 29 Apr 2025 16:27:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/2] libmutipath: handle blacklisted paths on
 map_discovery
Message-ID: <aBE2IX4re8qXv-GG@redhat.com>
References: <20250428214514.1905327-1-bmarzins@redhat.com>
 <20250428214514.1905327-2-bmarzins@redhat.com>
 <d277b26e716775ef3778aa47c8a96ea24a551de7.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d277b26e716775ef3778aa47c8a96ea24a551de7.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Bv3BZB28OU6XbhhLvzjkyJPyatJziJm9aanBa-V3e-s_1745958436
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 29, 2025 at 09:59:40PM +0200, Martin Wilck wrote:
> On Mon, 2025-04-28 at 17:45 -0400, Benjamin Marzinski wrote:
> > If the multipath configuration is changed to blacklist existing
> > devices,
> > and multipathd is reloaded but the blacklisted multipaths device
> > can't
> > be removed, multipathd was marking the paths as INIT_PARTIAL, causing
> > them to stay in the multipath device, at least until the
> > partial_retrigger_delay timeout elapsed. Instead, mark them as
> > INIT_REMOVED and set mpp->need_reload, so the device is reloaded and
> > the
> > paths are removed. To make sure the blacklisted paths are deleted
> > when
> > the multipath device is removed in coalesce_maps(), set their pp->mpp
> > to point to map before removing it.
> > 
> > Fixes d9c61332 ("multipathd: trigger uevents for blacklisted paths in
> > reconfigure")
> 
> The patch looks good to me, but I only vaguely understand why the bug
> is introduced in d9c61332. Are you positive that before d9c61332, the
> hang didn't occur?

Well, I'm pretty sure these blacklisted paths stopped getting deleted
during reconfigure by d9c61332. Before d9c61332, blacklisted paths were
immediately deleted in update_pathvec_from_dm(). After this change

@@ -193,7 +196,8 @@ static void update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 		rc = pathinfo(pp, conf,
 		              DI_SYSFS|DI_WWID|DI_BLACKLIST|DI_NOFALLBACK|pathinfo_flags);
 		pthread_cleanup_pop(1);
-		if (rc != PATHINFO_OK) {
+		if (rc == PATHINFO_FAILED ||
+		    (rc == PATHINFO_SKIPPED && !map_discovery)) {
 		        condlog(1, "%s: error %d in pathinfo, discarding path",
 		                pp->dev, rc);
 		        vector_del_slot(pgp->paths, j--);

they started hanging around, so that uevents could be generated for them
by trigger_paths_udev_change(). However, since coalesce_paths() will
usually clear pp->mpp, they won't get removed when orphan_paths() is
later called by remove_maps() to remove the old maps. I admit I didn't
test if the paths got removed before that commit, but the commit message
says that they did.

-Ben

> 
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>

