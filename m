Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50498224CC
	for <dm-devel@lists.linux.dev>; Tue, 18 Mar 2025 23:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742340770; cv=none; b=HGbM6f4HlrtoilIKOPoekbitshSw48Lnu6q+TGCcooraBw8cCuleHbFkiONSwiIK5fcE4N83VGPgO8+9YRtDSVbOQC3+0jKPo5tVPMH7PAznUaY7prmMTYscx0udzFbA6f8rozhaATmKdFp+oAt0jnb53YTBWNDBi9ZdjDfb4Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742340770; c=relaxed/simple;
	bh=uJuYx28s1al6UqMpdyHXVvcxDDONyT87ph5DTCPY5Nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hqg6h5vHLB539tsWYXyKCqUMpA64zITG5KnTiFF7pvATlPIeWtX7bHwgvcsy3/8nqTKHKd2DgedHZvymbzlmhcgKe8QtnU3ycCB03GBiOes/WWWgVFAZduNjneOuklRBPOsJveycjqNGuybBp+IQOcwUs0MtlQxtC5N6Hd9IwEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MgFAOINm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MgFAOINm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742340767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vaGgus9GoniP60NJloGBqYZlnBqO/XdQ7ttj2qU8mbA=;
	b=MgFAOINmtLzyyp9zMtUmwefrcGCoovEQbTNgpfQZnACfD2nVbu7FsjR6spTrh6vse0GHU/
	0R6avgWnLLzGgjXZFm+l49kl5PWAuHwuScmaXg7TXgQLgPXBKoH4EJ7W2zTy/R4W5zYsPZ
	4TThlh51lO6hG/DCYM5H+T6zb6UoCLY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-pdItevhkOheiJ-9bfhWpQw-1; Tue,
 18 Mar 2025 19:32:45 -0400
X-MC-Unique: pdItevhkOheiJ-9bfhWpQw-1
X-Mimecast-MFC-AGG-ID: pdItevhkOheiJ-9bfhWpQw_1742340764
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 589C5180035C;
	Tue, 18 Mar 2025 23:32:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0420F1828A83;
	Tue, 18 Mar 2025 23:32:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52INWg122275393
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 19:32:42 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52INWfZd2275392;
	Tue, 18 Mar 2025 19:32:41 -0400
Date: Tue, 18 Mar 2025 19:32:41 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH RFC] multipath-tools: add Generic SCSI in hwtable
Message-ID: <Z9oCmSP3Zm11T7zr@redhat.com>
References: <20250317173352.14387-1-xose.vazquez@gmail.com>
 <Z9h_dgeRCakpLak9@redhat.com>
 <3d9867d00eeb9d9ec65a2f93ea09cd71a960c4bc.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <3d9867d00eeb9d9ec65a2f93ea09cd71a960c4bc.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qocEGziA2L0FQzqXIsnk-TkN4X8jQ496bIlLLJNuKUg_1742340764
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Mar 18, 2025 at 12:08:32PM +0100, Martin Wilck wrote:
> On Mon, 2025-03-17 at 16:00 -0400, Benjamin Marzinski wrote:
> > On Mon, Mar 17, 2025 at 06:33:51PM +0100, Xose Vazquez Perez wrote:
> > > Cc: Martin Wilck <mwilck@suse.com>
> > > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > > Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> > > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > > ---
> > >  libmultipath/hwtable.c | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > > 
> > > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > > index f8cf3fa9..34b1fd2f 100644
> > > --- a/libmultipath/hwtable.c
> > > +++ b/libmultipath/hwtable.c
> > > @@ -79,6 +79,17 @@
> > >  #endif
> > >  
> > 
> > If we wanted to make these changes, we could just change
> > DEFAULT_PGPOLICY, DEFAULT_FAILBACK, and DEFAULT_NO_PATH_RETRY. But I
> > still think that for completely unknown devices, we should stick with
> > our current defaults. They're safe and I haven't heard any complaints
> > about them.
> 
> I agree. The point of the hwtable is to change the defaults for
> specific devices. Using "vendor = .*" and "product = ".*" is against
> the spirit of the hwtable. 
> 
> Unless I am mistaken, this  change would override user settings in the
> "defaults" section of multipath.conf. This happens a lot already for
> those systems that do have a specific hwtable entry, and I am sure that
> that comes as a surprise for users (it has confused myself a
> significant couple of times). By adding these catch-all entries, we'd
> make the "defaults" section ineffective for any setting that's
> available in the "devices" section, too.
> 
> Thinking about it, that might actually be a good thing, as it would
> eliminate the uncertainty whether or not a given "defaults" setting
> would take effect for a given storage device. Maybe we should
> officially stop supporting settings in "defaults" that can be
> overridden by device-spefic settings, just to reduce confusion in this
> area, and recommend using a catch-all device setting (in
> multipath.conf, not in the built-in hwtable) instead.

The device configs from /etc/multipath.conf will override values in the
built-in hwtable. So a catch-all device config in /etc/multipath.conf is
the same as putting options in the overrides section, not the defaults
section.

Now that we changed how hwentry configs work, we could probably
deprecate the overrides section, but I don't think we can replace the
defaults section.

right?

-Ben
 
> Anyway, that would be a possible cause for major breakage, as user
> settings in the field would suddenly stop being effective. We can't
> possibly just let it slip in with a minor hwtable patch like this.
> 
> Regards
> Martin
> 
> > -Ben
> > 
> > >  static struct hwentry default_hw[] = {
> > > +	/*
> > > +	 * Generic SCSI devices
> > > +	 */
> > > +	{
> > > +		/* Generic SCSI */
> > > +		.vendor        = ".*",
> > > +		.product       = ".*",
> > > +		.pgpolicy      = GROUP_BY_PRIO,
> > > +		.pgfailback    = -FAILBACK_IMMEDIATE,
> > > +		.no_path_retry = 30,
> > > +	},
> > >  	/*
> > >  	 * Generic NVMe devices
> > >  	 *
> > > -- 
> > > 2.48.1
> > 

