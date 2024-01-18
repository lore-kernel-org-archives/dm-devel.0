Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233671E494
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705595685; cv=none; b=Nw00lCLU9hu2uwX4dMb7Cvv8aFBazT1rSN9EiHaBF9Frvi2t8LQMTYmCW+E+tFjADafSpd/YYf+WRl8ITj6Fzl7+8s1b9l8n+zdJej1Pp11fRvYz4Z6KGi2CiNwQzNbX/5glrV/zS4U7mRYgopAyRO25F4MJZhmlNo/ZyIyxAKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705595685; c=relaxed/simple;
	bh=TitDxBbrQ7IZjHRIIX/GimHn/DW/8ltdLrn/lp7SpLg=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:In-Reply-To:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-Originator:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding; b=og1L75NGYoT46481oC+DCLE6ElsaqjQzcOV9PTyl3yFkgb2a86nwHLoFh/iGOg2kQrl9E8mA0YuLEhglgnmGnO2xnPFLSIcL8PONJhQOCEodg69p/i6cwvZGpLdggdWSnQstWhBemzX+6IE5Z6vSO0gsEIBifcLem4qpTHd7Xnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c+R0btFR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c+R0btFR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705595682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VaeSnVG8geu7rHimkrrxeXJ7ifnm3EmvyBNxsh7c4s8=;
	b=c+R0btFRMy2zcnY+0K6kpwVRFixbnKTv8Q9A0TUcxAPfIBTNrBs1Pzt/vJLMqH8nTZip1z
	XZN6fLMm0sjPhNhTWgbrVrtSbYHzJwy3F++npbcZ2DnbwrtD1d06jpfJsHU7dfxjXWfB8Y
	AklXRVD/Wec8WzPvHOYSZ0YVgmdg+Dc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-_ExqOjZUNEaYOzuBzmUQKw-1; Thu, 18 Jan 2024 11:34:39 -0500
X-MC-Unique: _ExqOjZUNEaYOzuBzmUQKw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5C14837227;
	Thu, 18 Jan 2024 16:34:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD4562166B33;
	Thu, 18 Jan 2024 16:34:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40IGYcUQ108772
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Jan 2024 11:34:38 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40IGYcBi108771;
	Thu, 18 Jan 2024 11:34:38 -0500
Date: Thu, 18 Jan 2024 11:34:38 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Seamus Connor <sconnor@purestorage.com>,
        Krisha Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH] multipathd: the local path change is not considered
Message-ID: <ZalTHihKuWlaUpAJ@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240117225110.50072-1-brian@purestorage.com>
 <8af5a4e5aff3edf9511ebdd5244f65a8e1ecf875.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8af5a4e5aff3edf9511ebdd5244f65a8e1ecf875.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Jan 18, 2024 at 09:16:35AM +0100, Martin Wilck wrote:
> On Wed, 2024-01-17 at 14:51 -0800, Brian Bunker wrote:
> > When update_prio is called, there is a check to see if the local path
> > has a priority change. Then all the remaining paths are simliarly
> > checked.
> > 
> > Only the result of paths not matching the local path's priority are
> > considered in the calculation of 'changed'. In the case of failed
> > paths
> > becoming again available this can lead to multipath not reloading.
> > 
> > The result will look like this:
> > 3624a93703c9f34490f6140a100011010 dm-2 PURE,FlashArray
> > size=3.0T features='1 retain_attached_hw_handler' hwhandler='1 alua'
> > wp=rw
> > > -+- policy='service-time 0' prio=50 status=active
> > > > - 1:0:0:1  sdb 8:16  active ready running
> > > > - 9:0:0:1  sdc 8:32  active ready running
> > > > - 11:0:0:1 sdd 8:48  active ready running
> > > `- 13:0:0:1 sdh 8:112 active ready running
> > `-+- policy='service-time 0' prio=50 status=enabled
> >   |- 8:0:0:1  sde 8:64  active ready running
> >   |- 10:0:0:1 sdf 8:80  active ready running
> >   |- 12:0:0:1 sdg 8:96  active ready running
> >   `- 14:0:0:1 sdi 8:128 active ready running
> > 
> > Where the path's priorities are updated, but the path group is not
> > activated.
> > 
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
> > Signed-off-by: Seamus Connor <sconnor@purestorage.com>
> > Signed-off-by: Krisha Kant <krishna.kant@purestorage.com>
> > ---
> >  multipathd/main.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> 
> Thanks for the report and fix!
> 
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 230c9d10..62b87bf8 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -2127,7 +2127,7 @@ int update_prio(struct path *pp, int
> > refresh_all)
> >  	int oldpriority;
> >  	struct path *pp1;
> >  	struct pathgroup * pgp;
> > -	int i, j, changed = 0;
> > +	int i, j, local_changed = 0, other_changed = 0;
> 
> Why use two variables here? AFAICS, you can implement the same logic
> with just the "changed" variable.
> 
> Other than that, this looks good.
> 
> When you submit a v2, please add bmarzins@redhat.com and myself to cc,
> and add 
> 
> Fixes: 6ccd7b8 ("multipathd: only refresh priorities in update_prio()")
> 
> Regards,
> Martin

ACK for the code with using "changed" for both the local and other changes. 

Thanks for catching this.

-Ben

> >  	struct config *conf;
> >  
> >  	oldpriority = pp->priority;
> > @@ -2138,8 +2138,11 @@ int update_prio(struct path *pp, int
> > refresh_all)
> >  		pthread_cleanup_pop(1);
> >  	}
> >  
> > -	if (pp->priority == oldpriority && !refresh_all)
> > -		return 0;
> > +	if (pp->priority != oldpriority)
> > +		local_changed = 1;
> > +	else
> > +		if (!refresh_all)
> > +			return 0;
> >  
> >  	vector_foreach_slot (pp->mpp->pg, pgp, i) {
> >  		vector_foreach_slot (pgp->paths, pp1, j) {
> > @@ -2151,10 +2154,10 @@ int update_prio(struct path *pp, int
> > refresh_all)
> >  			pathinfo(pp1, conf, DI_PRIO);
> >  			pthread_cleanup_pop(1);
> >  			if (pp1->priority != oldpriority)
> > -				changed = 1;
> > +				other_changed = 1;
> >  		}
> >  	}
> > -	return changed;
> > +	return (local_changed || other_changed);
> >  }
> >  
> >  static int reload_map(struct vectors *vecs, struct multipath *mpp,
> 

