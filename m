Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B1C382
	for <dm-devel@lists.linux.dev>; Wed, 13 Nov 2024 00:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731456772; cv=none; b=VtZg3KI6748KwEQ/hdBvIzB3meC+RqMrU2Cf3Lev8l1ybe0bgqg+ib5yDKhMPQgGBo1FDZbmiYrBspvOjN9uEHq1rU3pV5Rjbpx0ntj94299xhsB1GhQhX0AJzehvkJYIxi9X4xrc9+uqkIIQ8z0iq4z2s1q5OSrlr9Z9gpimKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731456772; c=relaxed/simple;
	bh=aCJN+lavo2lTsAvOdQElVTCeGjTAQwkF8H7L2JkUPXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=EhUf6WAgwaIb+XsBvmXBhNT3hSr1xnn5jU5zodz+v9qiaLnRNkIo6oYddeOEpcOgjBDLw4VZiOXtSXi9PrcNlQW1HQvHC+rRTeK1NvcB6xaNwtsLnX+1yCNmZn47l7huDvjWiSgWE+4MvxIrSzqSqn5JJWsKwkJ8M2Go+u3Soco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fjn0iDAL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fjn0iDAL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731456769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q3Cu+BvxiAYfdtOUW3pS2r7cFTAg/bD+JWkAYXKWLbc=;
	b=Fjn0iDALCJygjtB0bcSNv8Tz1R7Iso+UK/nDKEKiRpP1C/p28kXsE1+eXd2OYN4i+dHs5b
	lJGb3OCPYF/U+HW34Lqo2q7K++qqRFrmVnU85ioTUJbK6ItDVJ0Fx1X/rvHUtUBQVyZ5Hl
	jJW/Vf729tL3NFVAkJab5i447Q3L54I=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-btlOB-iCP6WmeatOPMcQOw-1; Tue,
 12 Nov 2024 19:12:45 -0500
X-MC-Unique: btlOB-iCP6WmeatOPMcQOw-1
X-Mimecast-MFC-AGG-ID: btlOB-iCP6WmeatOPMcQOw
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71CB719560B2;
	Wed, 13 Nov 2024 00:12:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F0AD1956086;
	Wed, 13 Nov 2024 00:12:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AD0CgVt580825
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 19:12:42 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AD0CgX1580824;
	Tue, 12 Nov 2024 19:12:42 -0500
Date: Tue, 12 Nov 2024 19:12:42 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 00/12] multipath fixes to tableless device handling
Message-ID: <ZzPu-rJP_10cJgnc@redhat.com>
References: <20241112150215.90182-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241112150215.90182-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P2zvfnebA5Nqhv6MZ4u8MXh_psr0_X6C37TGXDjV2Po_1731456764
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2024 at 04:02:03PM +0100, Martin Wilck wrote:
> This patch set is a re-spin of Ben's previous series by the same name [1].

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
 
> Patch 1 is my take on fixing the regression with map detection
> in multipath-tools 0.10.0. The basic idea is to never fail in dm_get_maps(),
> even if libmp_mapinfo() fails on one or more maps. The behavior wrt "empty"
> maps, or maps without table, is the same as in 0.9.9 and older, these
> maps are simply ignored by multipathd.
> 
> Patch 2 improves the semantics for decting maps with multiple targets.
> 
> Patch 3-6 are from Ben's original series, with unit test fixes added in
> patch 3.
> 
> Patch 7 and 8 improve the semantics of MAPINFO_CHECK_UUID for partitions.
> 
> Patch 9-11 are minor logging improvements.
> 
> Patch 12 is an independent bug fix I discovered recently.
> 
> As usual, comments and reviews welcome.
> 
> Martin
> 
> [1] https://lore.kernel.org/dm-devel/20241031183301.391416-1-bmarzins@redhat.com/
> 
> Benjamin Marzinski (4):
>   libmultipath: check DM UUID earlier in libmp_mapinfo__
>   libmultipath: use MAPINFO_CHECK_UUID in dm_get_multipath
>   multipathd: print an error when failing to connect to multipathd
>   multipathd.service: restart multipathd on failure
> 
> Martin Wilck (8):
>   libmultipath: dm_get_maps(): don't bail out for single-map failures
>   libmultipath: libmp_mapinfo(): return DMP_NO_MATCH for multi-target
>     maps
>   libmultipath: make MAPINFO_CHECK_UUID work with partitions
>   libmultipath: check map UUID in do_foreach_partmaps
>   libmultipath: increase log level for removing partitions
>   libmultipath: reduce log level of libmp_mapinfo() messages
>   libmultipath: don't log boring state messages at level 3
>   libmultipath: don't set dev_loss_tmo to 0 for NO_PATH_RETRY_FAIL
> 
>  libmultipath/devmapper.c         | 70 ++++++++++++++++----------------
>  libmultipath/devmapper.h         |  8 +++-
>  libmultipath/discovery.c         | 13 ++++--
>  libmultipath/structs.h           |  1 +
>  multipathd/multipathd.service.in |  3 ++
>  multipathd/uxclnt.c              |  4 +-
>  tests/mapinfo.c                  | 17 +++++---
>  7 files changed, 71 insertions(+), 45 deletions(-)
> 
> -- 
> 2.47.0

