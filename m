Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AE81CEE9B
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732643046; cv=none; b=J5O2EfE+gXF78s/wkQ0arYPtvuoDgs2+iN1P7qJbm4P3zD7lzm1GoxAiW9amcjc9Nw/h7fK+eLnoI+IZICk3j8BZTL0Rl5ZZk5qdI+6R0SzjSZz4TAV6sn3Gxy1MczVGEwDXAF4otOrcMETVkYnLcboyr6ylY0oRRgvZqcrMLgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732643046; c=relaxed/simple;
	bh=SXdXfNLB1o1nisjqWNeIdChJ6knDn3OyBCL1PXYxEbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=QHntGCRXxWlgEa+jro912eZByY/oq4GJqDoSm6daC2TLkm9w8ZeJnrgsh/iPq7Pzox3NdhcbSIWNd6OW/ZC2pOLmwdw/N+gW6puQXj6ERbbvWH2hM0ide5lCs3ALMyKOgZKD63p5HT3zbBJ+yvAcqPkiPyZGNOBNOqTMQ6KBbeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hjIzE6Gg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hjIzE6Gg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732643042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W3c0nWNUszRSISDTjUiBPYAqg2quZUzsp+cZndVawMQ=;
	b=hjIzE6GgTaXFdjPK22AlrFNY8GMZlN3EsiSxe+HGc9SCxArIvW0ibi+avpXnUuG4LpQmhN
	RLKNpQMWbT8T8AefJknzvtRIR3OcEfj9asg7a4VR5F+YiPFCaft0e2J3qnM5EGhoikl95X
	UB1sa87bo6icBQ3Q78sh4RNKVD39R78=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-325-UZbctoVXN-iF5wXT3iX7kA-1; Tue,
 26 Nov 2024 12:43:59 -0500
X-MC-Unique: UZbctoVXN-iF5wXT3iX7kA-1
X-Mimecast-MFC-AGG-ID: UZbctoVXN-iF5wXT3iX7kA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD0AA1955F42;
	Tue, 26 Nov 2024 17:43:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 944E21955F43;
	Tue, 26 Nov 2024 17:43:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQHhu2R854996
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 12:43:56 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQHhuhj854995;
	Tue, 26 Nov 2024 12:43:56 -0500
Date: Tue, 26 Nov 2024 12:43:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/3] libmultipath: pgcmp(): compare number of paths
Message-ID: <Z0YI3Dbv7ImsfCtG@redhat.com>
References: <20241125143224.51934-1-mwilck@suse.com>
 <20241125143224.51934-3-mwilck@suse.com>
 <Z0Tm7AJeGdZs5WIS@redhat.com>
 <6cd4e709400b0169d745a4f9a25159bd47c44904.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <6cd4e709400b0169d745a4f9a25159bd47c44904.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wb_mrkpYo8glM5ZqV690JhljniOvE4n5idPacouxk10_1732643038
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Nov 26, 2024 at 12:15:06PM +0100, Martin Wilck wrote:
> On Mon, 2024-11-25 at 16:06 -0500, Benjamin Marzinski wrote:
> > On Mon, Nov 25, 2024 at 03:32:23PM +0100, Martin Wilck wrote:
> > > pathcmp() makes sure that all paths in pgp have a match in cpgp,
> > > but not
> > > vice-versa. Check the number of paths, too.
> > 
> > This looks fine. But looking at it made we a nervous about cpgp->id. 
> > We
> > only calculate that in pgcmp() (and just for mpp, not cmpp) and in
> > disassemble_map(). But we clearly can have pathgroup changes after
> > that,
> > as the last patch has shown. To be safe, we should either skip the
> > whole
> > pgp->id thing (it's not a huge time savings) or recalculate it for
> > all
> > of cmpp's path groups before we start the loops in pgcmp().
> 
> Agreed. Like before, I am wondering if we should drop pgp->id in 0.11.0
> already or postpone.
> 
> IMO my patch is a valid fix for a minor issue which needs redesign in a
> future release.

Yep. Like I said, your patch looks fine. I just noticed the gpg->id
issue while looking at it.

-Ben

> 
> Martin

