Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6874617557C
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 21:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732568823; cv=none; b=eZTHja11O4r0NHcIwedfz/qWZ05TGNJVjhcCG74qIvv9CmmjGc/KZIphCM4VzcgO6rHd3iqXRWiKLFQ2GTQKaTwYS5DCAI/uhTWNDzjkB5Al93th0bGfVxSEwX07IeBrSPJqV/rX3kjWdI0nuB9NnNvlnMF3Oob0ICx0aM5VyAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732568823; c=relaxed/simple;
	bh=EMik22dm8ZmEMNEDaMJ3alzfxUH3En1NgPF+/czGswI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=UDSBoKsg9TDTHb4FZq2zoFVYLF3Fu+4WdLa2Cz1CHD/ofUhBFrk++ItXN56ciRyTvqhIz+XLVbk0b20h1SnbozPahSavCG5EPrcmd/YtJuFCm5X6/tVjzoNnOz6u5ilcUm+KUUTTvHVuDtWgbhSaQwO2udjVGj7elzH332glRXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gUDnm0fy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gUDnm0fy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732568819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2mUWgC6vW85LjVtvTSgD5i923QtjrDsSkNr2HwWqXak=;
	b=gUDnm0fyavu9HTuou95FiQW5R25V4+3R5CcExXAdVLDaJY19sB3cFsd65t96kIM8gcPSq6
	dWM+wrz3g+BCmo4k2T7NXmhohdU2i4XO/JjdsWEPjtlC4wXljFcnI24XIMzqIfAKnfz0V5
	cETbtTW3RdIQuX/hi2SMTHebAxW4Yso=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-195-_501lF6gMGignDSsVydCZQ-1; Mon,
 25 Nov 2024 16:06:55 -0500
X-MC-Unique: _501lF6gMGignDSsVydCZQ-1
X-Mimecast-MFC-AGG-ID: _501lF6gMGignDSsVydCZQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A6951955F09;
	Mon, 25 Nov 2024 21:06:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08B011956086;
	Mon, 25 Nov 2024 21:06:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4APL6qkh762137
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 16:06:52 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4APL6q1U762136;
	Mon, 25 Nov 2024 16:06:52 -0500
Date: Mon, 25 Nov 2024 16:06:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/3] libmultipath: pgcmp(): compare number of paths
Message-ID: <Z0Tm7AJeGdZs5WIS@redhat.com>
References: <20241125143224.51934-1-mwilck@suse.com>
 <20241125143224.51934-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241125143224.51934-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dYAq62aaz4dVdrsFG7-r9goZGDo5XziWhPb4lAhJgIw_1732568814
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 25, 2024 at 03:32:23PM +0100, Martin Wilck wrote:
> pathcmp() makes sure that all paths in pgp have a match in cpgp, but not
> vice-versa. Check the number of paths, too.

This looks fine. But looking at it made we a nervous about cpgp->id.  We
only calculate that in pgcmp() (and just for mpp, not cmpp) and in
disassemble_map(). But we clearly can have pathgroup changes after that,
as the last patch has shown. To be safe, we should either skip the whole
pgp->id thing (it's not a huge time savings) or recalculate it for all
of cmpp's path groups before we start the loops in pgcmp().

-Ben

> 
> Fixes: 90773ba ("libmultipath: resolve hash collisions in pgcmp()")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index d0e9c95..55140d0 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -442,6 +442,7 @@ pgcmp (struct multipath * mpp, struct multipath * cmpp)
>  
>  		vector_foreach_slot (cmpp->pg, cpgp, j) {
>  			if (pgp->id == cpgp->id &&
> +			    VECTOR_SIZE(pgp->paths) == VECTOR_SIZE(cpgp->paths) &&
>  			    !pathcmp(pgp, cpgp)) {
>  				r = 0;
>  				break;
> -- 
> 2.47.0

