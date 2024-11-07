Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D863215F72
	for <dm-devel@lists.linux.dev>; Thu,  7 Nov 2024 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731001334; cv=none; b=OoSm6eDhnahO6yvslB+y1IW0uhEMFd+4lgNHNYp1CoH2fgd0aowXdb0/2y6Y7HMtnNqO2HhZT7FcsMKXKY0W3Zk29NefZA3UtAj3zn5spDipxeVWcUmZ0KXSX07gSUaYe0yDZEjud4iTI0yLuqn2nbLE1avLy0nI3QooWsIT8z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731001334; c=relaxed/simple;
	bh=mQ31S+RqOD4y1nFBTfYGgsMiT0pwl2At33QvxhYatOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fPCVWr2kI+ELe6ZBg683Edp/nFMLRjrGCfC3HXIKajoJDxU8/DrogbcgelhxtpAIICvOPIuHg3MDTDySs1mtzsZJq764WJB9PXkv9A2vcWcSj2OPA0eoGCsH+SXycA6s6I0/jfb1zukH9COwXohILZa6+nQPktM341Ghwtn79Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WqbEdpU+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WqbEdpU+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731001331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVbwNB4n9Ec3RdL0GJdwf6DR8Dyiuq3r24tId95Rp+o=;
	b=WqbEdpU+4psrzwAN6smNoDIU+9FkSvczyTK7IPAUU90H2ycSBIVQk++hKZ31+8Vv+M2SUa
	8cihlbpsOX7hFebzIzDw5rswRNtpAWUPElJi3P2A+fKRa3UXXYZ3uqZiBYYXdtOol1Q1x5
	YpC0MJPgKzSLN/IYqZ+/eGQMGHrjhEc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-LqAt8d9zPXKAGtH1bg5y2w-1; Thu,
 07 Nov 2024 12:42:09 -0500
X-MC-Unique: LqAt8d9zPXKAGtH1bg5y2w-1
X-Mimecast-MFC-AGG-ID: LqAt8d9zPXKAGtH1bg5y2w
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7695719560AF;
	Thu,  7 Nov 2024 17:42:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4C0B195E481;
	Thu,  7 Nov 2024 17:42:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4A7Hg6N1496774
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 7 Nov 2024 12:42:06 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4A7Hg61p496773;
	Thu, 7 Nov 2024 12:42:06 -0500
Date: Thu, 7 Nov 2024 12:42:06 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 6/8] libmultipath: signal multipath UUID device with no
 table
Message-ID: <Zyz77iYLXPAfTJSl@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
 <20241031183301.391416-7-bmarzins@redhat.com>
 <08ddd03d48938378f6281f14f52dfd8b942f9476.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <08ddd03d48938378f6281f14f52dfd8b942f9476.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hu64gCswfZudTviF3OwOO5VrLYjwSHHhx9tvNhZpOQk_1731001328
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Nov 06, 2024 at 05:17:30PM +0100, Martin Wilck wrote:
> On Thu, 2024-10-31 at 14:32 -0400, Benjamin Marzinski wrote:
> > if libmp_mapinfo() is run on a device that has a multipath prefixed
> > DM
> > UUID but no table (either active or inactive), it will now return
> > with a
> > new exit code, DMP_BAD_DEV, to signal that this is an invalid
> > multipath
> > device. Currently all code paths treat this identically to
> > DMP_NOT_FOUND.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/devmapper.c | 18 ++++++++++++++++++
> >  libmultipath/devmapper.h |  5 ++++-
> >  2 files changed, 22 insertions(+), 1 deletion(-)
> > 
> > diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> > index 13d8c1e5..6e11d5b5 100644
> > --- a/libmultipath/devmapper.c
> > +++ b/libmultipath/devmapper.c
> > @@ -726,6 +726,22 @@ static int libmp_mapinfo__(int flags, mapid_t
> > id, mapinfo_t info, const char *ma
> >  	}
> >  
> >  	if (info.target || info.status || info.size || flags &
> > MAPINFO_TGT_TYPE__) {
> > +		if (!dmi.live_table) {
> > +			/*
> > +			 * If this is device has a multipath uuid
> > but no
> > +			 * table, flag it, so multipath can clean it
> > up
> > +			 */
> > +			if (flags & MAPINFO_CHECK_UUID &&
> > +			    !dmi.inactive_table) {
> > +				condlog(2, "%s: multipath map %s has
> > no table",
> > +					fname__, map_id);
> > +				return DMP_BAD_DEV;
> 
> 
> What about the case when there's an inactive_table? AFAIU that means
> that a resume operation after a table (re)load failed or was
> interrupted, or that the program that (re)loaded the table (multipathd,
> probably) died before it could resume the table.
> 
> In this case we'd fall through the the "map has no targets" case, but
> shouldn't we also treat it as DMP_BAD_DEV?

This is because I was deleting these devices in patch 8, and I didn't
want to delete devices that where in the process of getting modified by
multipath. The code could still delete devices that were getting created
if it ran during the window between when the dm device gets created, and
a table gets loaded. In that case there would be no table. But there
is another window that happens after this during creation and during
a reload failure, where the device doesn't have an active table but
still has an inactive one. I didn't want to delete devices like this,
since it could effect existing devices. We could, for instance, end up
deleting a device that multipath was currently working on and was about
to clean up itself.

But if we aren't deleting these devices, then yes, it would make more
sense to characterize these as DMP_BAD_DEV.

-Ben

> 
> Martin

