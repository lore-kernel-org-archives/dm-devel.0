Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5CF1CCB5C
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 18:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725476097; cv=none; b=lnRNVmhoBe1oE/Ym3G3cRVr6Ipi82JXKaXrnZOnlfzAjr2AdUHsUs2kWEwQRLpt+XZqdRBka++PUHEQWwd4HjO4XG8yHWhW05xeWpyhlfVCInIesuxY+xQtwlUTLSzHoz2mpCO5WbzyKx42cAGL5Fu6KAj8pOt5IvyIJJ1A7aFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725476097; c=relaxed/simple;
	bh=wAz7wFmmVUd3AKD1MZQtOyZP41+wTKNvxs81x9UVwyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=f4eA2JdVR8J5If9bTeqW4hUJFpp4dch8Qc7ckdxAHvnQiq9a/5PjbV9OJNyu6XAcOxF+W/2g4MfiW7zw024efZlqevifUny1i+xKb91XfP+M+ssJqcno9Airw7Ewiwgtsa5Sr9Ts8QqUnzPrk9sc1nhDeniQwc4UL6bOZbbPlyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PXtszr4x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PXtszr4x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725476094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jeu5d8v+KU9JS/nzEAwdGJeRSxdvp3eR6n2x4UAw+ok=;
	b=PXtszr4x1Y1xOhbxzgu+AHsKYLag0xuCiIdrdFk4vAjb93gh8eKzVtgsHlsQlBYZRp0E5e
	a58pNg/1ilo4TNiVk/PpGdx09kL+vw1+4AhV850LderrhEw3XBBFJzZohSKNkOy67bPzu2
	VX6xPXtLnXkKmqA8UXULFxD4y2tomTs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-a5_f3Sy_Nz2lPn1CdychWQ-1; Wed,
 04 Sep 2024 14:54:51 -0400
X-MC-Unique: a5_f3Sy_Nz2lPn1CdychWQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E65A19560AD;
	Wed,  4 Sep 2024 18:54:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8207230001AB;
	Wed,  4 Sep 2024 18:54:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 484Ism3u480677
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Sep 2024 14:54:48 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 484Ismgs480676;
	Wed, 4 Sep 2024 14:54:48 -0400
Date: Wed, 4 Sep 2024 14:54:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 13/15] multipathd: update priority once after updating
 all paths
Message-ID: <Ztis-CcoBcK6fExR@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
 <20240828221757.4060548-14-bmarzins@redhat.com>
 <3153bab711698dbe3ca2e1f45d1ad30392d68832.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <3153bab711698dbe3ca2e1f45d1ad30392d68832.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 04, 2024 at 05:06:23PM +0200, Martin Wilck wrote:
> On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > Instead of updating the path priorities and possibly reloading the
> > multipath device when each path is updated, wait till all paths
> > have been updated, and then go through the multipath devices updating
> > the priorities once, reloading if necessary.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/structs.h |   9 +++
> >  multipathd/main.c      | 169 ++++++++++++++++++++++++++-------------
> > --
> >  2 files changed, 118 insertions(+), 60 deletions(-)
> > 
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 2bcc6066..1511f701 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> >  
> > @@ -2859,7 +2898,7 @@ update_paths(struct vectors *vecs, int
> > *num_paths_p, time_t start_secs)
> >  			i--;
> >  		else {
> >  			pp->is_checked = rc;
> > -			if (rc == CHECK_PATH_CHECKED)
> > +			if (rc == CHECK_PATH_CHECKED ||
> > CHECK_PATH_NEW_UP)
> 
> This causes compilation errors. I suppose you meant (rc ==
> CHECK_PATH_CHECKED || rc == CHECK_PATH_NEW_UP)

D'oh! Yep. Thanks.

-Ben

> 
> (fixed this up for now on my "tip" branch).
> 
> Martin

