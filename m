Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D294204F98
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 20:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733256725; cv=none; b=Qak68fjoz9r214xpnFN0e3GKxgz8HLt3hrEKRwhVwYGY0rTTapEW0mKpLACWj+22Yek324XILuXVZBfPQXP3VlGvEgLm7BYf4yUaJ77wMCRxx5jYU6sh8e/P7XzRCk6GOvt+kY5mz36tiWpVwIRodpH1+ZIfRtSp4vTZ50x50ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733256725; c=relaxed/simple;
	bh=lRZCiP+YiHVcAhIUt3w+a5voT9VYiUbtiUs/KjhbXw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hAgfHejV5ULWIGOwGt0+6X0m29Ba5S+LlUFH2+dUiRVALmKUjtmMbn558DtyoetkB+k2P55VgHPMNKWHhZwzkyK3eAhn7VA+0aCM3RZ+HT3oydYd+yPJuYIxpC/vL522PPdGoqgGtndFOkNWCrqzcd/yOEftdBrMBu8DC5ml5hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=atr5OXOu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="atr5OXOu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733256722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RC8KAzMSYFgtjKHZRfCoTXOiOyvmECD7qEXYEHaTKEg=;
	b=atr5OXOuIkf5DEsO+5Y3Nru9mpVrsq3cUykChIxrtInkV3qpVvfU2qkqdCpIHlinTIhC7M
	MevwkzX+0VWiT98SMc3qpsOttfVxIoVFLuErHFNAuSRS/zIUc2WBHO09EbhIr/oFKspljP
	NGr9+0xHBv3Q76Nz7UcXenyad4Gg2rs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-136-xjFpRXp6PUiImQiPqKTScA-1; Tue,
 03 Dec 2024 15:12:00 -0500
X-MC-Unique: xjFpRXp6PUiImQiPqKTScA-1
X-Mimecast-MFC-AGG-ID: xjFpRXp6PUiImQiPqKTScA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B5B919560A3;
	Tue,  3 Dec 2024 20:11:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4F9F1955F2D;
	Tue,  3 Dec 2024 20:11:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4B3KBvNY1170563
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 3 Dec 2024 15:11:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4B3KBv4Y1170562;
	Tue, 3 Dec 2024 15:11:57 -0500
Date: Tue, 3 Dec 2024 15:11:57 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 0/8] multipath-tools fixes
Message-ID: <Z09mDdvigD5QqIDj@redhat.com>
References: <20241127230430.139639-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241127230430.139639-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X9cqPpA2THnTEGJuyYCbE8SkmGiH_ExG8eeciPe_Sig_1733256719
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 28, 2024 at 12:04:22AM +0100, Martin Wilck wrote:

For all but patch 5/8:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> The first patch is an attempt to fix
> https://github.com/opensvc/multipath-tools/issues/105.
> 
> Patch 2-5 provide a re-implementation of pgcmp() without relying on
> pgp->id, as discussed during the review of v1 of this series.
> 
> Patch 6 and 7 change the way multipathd triggers uevents when
> it detects configuration changes, motivated by
> https://github.com/opensvc/multipath-tools/issues/105.
> 
> Up to now, multipathd had done this basically only if the "failed" state of a
> map had changed. This would miss cases where e.g. with find_multipaths strict,
> a path had been added to the WWIDs file and "multipathd reconfigure" had been
> run. In such cases, the paths would be added to the map, but udev would still
> not see them.  The same holds for changes of the blacklist.
> 
> With this set, when a map is created, or when map creation fails, multipathd
> checks whether udev already sees the correct properties for the device, and
> triggers an uevent otherwise.
> 
> When maps are to be removed because of configuration changes in
> coalesce_maps() (for example if a WWID has been removed from the WWIDs file),
> multipathd now also triggers uevents for the respective path devices. This
> is only done in coalesce_maps(), where current configuration changes are
> reflected. We can't do it after a "remove map" CLI command, for example,
> because that is by definition a temporary change. If we triggered an uevent
> for that, multipathd would recreate the map it just removed as soone as it
> receives the uevents.
> 
> Patch 8 is a minor log message change.
> 
> Martin Wilck (8):
>   libmultipath: fix handling of pp->pgindex
>   libmpathutil: change STATIC_BITFIELD to BITFIELD
>   libmpathutil: add cleanup_bitfield()
>   libmultipath: move pathcmp() to configure.c
>   libmultipath: re-implement pgcmp without the pathgroup id
>   libmultipath: trigger uevents upon map creation in domap()
>   multipathd: trigger uevents upon map removal in coalesce_maps()
>   multipathd: improve a log message in coalesce_maps()
> 
>  libmpathutil/libmpathutil.version |   1 +
>  libmpathutil/util.c               |   5 ++
>  libmpathutil/util.h               |  10 +--
>  libmultipath/configure.c          | 124 ++++++++++++++++++++----------
>  libmultipath/devmapper.c          |   9 +--
>  libmultipath/discovery.c          |   2 +-
>  libmultipath/dmparser.c           |   1 -
>  libmultipath/pgpolicies.c         |   6 ++
>  libmultipath/structs.c            |  31 +++-----
>  libmultipath/structs.h            |   3 -
>  libmultipath/structs_vec.c        |  15 ++++
>  multipathd/main.c                 |   6 +-
>  12 files changed, 135 insertions(+), 78 deletions(-)
> 
> -- 
> 2.47.0

