Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D54221DBE
	for <dm-devel@lists.linux.dev>; Thu, 12 Dec 2024 17:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023570; cv=none; b=WHGbmv7tNIDWmF8AxmI1y5qZVrZ38g84+P82UDdswoXOkp4vQqlo5A8bt4DAXbCM7wv26rN1dYbumRLEFsyFy0Uyf9YIr0M0o5eLnyUFAb3EkBuc2hRgWt/zqcPzNMRdrr72VMH2UIaAUqPCDB28ThenmTJ9v0xnJByfgVxwGkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023570; c=relaxed/simple;
	bh=QNBJnS6cbMelxwkxX8KvXPkBai+xQ59bjESd0QxAlG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=DLHPMlNReqaiyC0SIU/evI6k1Fk6xo6hjMfiogb8+753gULbP7NHlRl/5v7rNY9LKEyvYIQTBehwI99XnLyN0zRckwzpSuEjzqMrZkXwMcJXnzwrMMTO04RIKOzfmqzmCEo0ooKqX7/d0E8O8dRWXucJxo0dcC5+2Ic01DHjNF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E1YJNSi0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E1YJNSi0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734023567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXNYZMptfRX2uIy+AQKqfiBJ1jW1y548PKEIVna4a6Y=;
	b=E1YJNSi00GefBFjusUYcigUdfqX3Eyh6raNYieKK9B0VX2Bp+TZf0ikj8toYRbgM9XPjS3
	hBvui/+N4rHFpIn96B4vkti3EAwKPQstZ1DB2QqxX89zNr5V2gTXI22fpWo0PozEGFyRh8
	+cRUh2O3ubgqZb2NR8YQeUYAhU5PdEs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-335-ph5J4fCnPJy_CPw__HEsDg-1; Thu,
 12 Dec 2024 12:12:42 -0500
X-MC-Unique: ph5J4fCnPJy_CPw__HEsDg-1
X-Mimecast-MFC-AGG-ID: ph5J4fCnPJy_CPw__HEsDg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE5D019560BD;
	Thu, 12 Dec 2024 17:12:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EBA61956086;
	Thu, 12 Dec 2024 17:12:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BCHCdqJ1488871
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Dec 2024 12:12:39 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BCHCdUa1488870;
	Thu, 12 Dec 2024 12:12:39 -0500
Date: Thu, 12 Dec 2024 12:12:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
Message-ID: <Z1sZh1WLCucwL61e@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
 <20241206233617.382200-4-mwilck@suse.com>
 <Z1jPMVejcI61qP9z@redhat.com>
 <ee6fcbda31fd1f13969653782417fbed748f5bc7.camel@suse.com>
 <Z1nHUk8o3_qqPwED@redhat.com>
 <30fccbf041abd3af27f0228b51df431a2ca8438a.camel@suse.com>
 <422fff82ad35293d9406ec07820ddad5b122d1f6.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <422fff82ad35293d9406ec07820ddad5b122d1f6.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kzQUmpGc2gQbNML-r4J_gFG943mL8e6hJf3im4u_s3Y_1734023561
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Dec 11, 2024 at 09:33:40PM +0100, Martin Wilck wrote:
> On Wed, 2024-12-11 at 21:20 +0100, Martin Wilck wrote:
> > On Wed, 2024-12-11 at 12:09 -0500, Benjamin Marzinski wrote:
> > 
> > 
> > > I'm not actually worried about the kernel so much as libdevmapper.
> > > It
> > > is
> > > not designed for multi-threaded processes, and that has bitten us
> > > in
> > > the
> > > past. For intance, it's why we don't delete devices in
> > > dmevent_loop()
> > > on
> > > libdevmapper errors. dm_get_events() just waits and retries if
> > > getting
> > > the device list fails, and for each device, it calls dm_is_mpath
> > > and
> > > will only delete a device on DM_IS_MPATH_NO, which is what I
> > > suggested
> > > for the cleanup function.
> > > 
> > > I'm pretty sure we've handled all of the known issues here, with
> > > fixes
> > > like:
> > > 02d4bf07 ("libmultipath: protect racy libdevmapper calls with a
> > > mutex")
> > > 34e01d2f ("multipath-tools: don't call dm_lib_release() any more")
> > > 
> > > I'd rather not risk having missed some issue that could cause a
> > > temporary error in a function that we call every couple of seconds
> > > (almost always unnecessarily).
> > 
> > Ok, getting it. I thought that an error in DM_TABLE_STATUS must
> > almost
> > neccessarily mean -ENXIO (from the kernel pov), which would mean that
> > some external entity removed the device, and that we should act as if
> > someone had used the "remove map" CLI command. But I didn't think
> > about
> > libdevmapper.
> 
> But will libdevmapper return ENXIO if it's somehow interally confused?
> I don't think so. I believe that if we see this error code, removing
> the map is the right thing to do.

I don't think that shouldn't ever happen.

https://github.com/lvmteam/lvm2/blob/928b8e9c6eaf871b3405b91c64eac5ea854f2572/device_mapper/ioctl/libdm-iface.c#L2100

If libdevmapper gets an ENXIO from the kernel, it ends up setting
dmi.exists to 0 instead of returning the error.

-Ben
 
> I consider adding a patch on top of the v4 series that does this. 
> If you reject it, fine :-)
> 
> Regards,
> Martin

