Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF60722092
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709316969; cv=none; b=SUxKMCbjBbVBKO0T7cqZYiXPwZUzD1weINJ8jT38SUa5JmPVnE9GtklXT9NBsY6etG65qBEOL3R1qxYaDjAzAsEIaUHG5W6uPuMjXOHAJ7pih2atVEbBN1zql1zcifeN7rQyLtS5mOvJfeleHcXAVrud+HkrvSYM54f8nQT+7Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709316969; c=relaxed/simple;
	bh=RQJaeeLteVEUuSlUbNrmb8wJ3giZw5CwDHw8fBUDCdk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=qRlwvRBLZWRQgAwODTFKGm8brSz6ktnLgNOulhbw4vXbakZnExfMgXzln5zVbUq+DjhFqOq4E9dDexIGjIdY/8x7ABjeoDijV14RvAHeAoTb9ix4T5R8k0lIGKGTKucpi0WXgjGibuJYZuGPQ28+Nll405G7xHqOwLymbqOcEAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VhbeI7KT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VhbeI7KT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709316964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3gFs7J5CWhe+Ez/eMKYuDcA2y/r3mN/yCJ1aMKLB7LM=;
	b=VhbeI7KTE6d05R/WurYKz/qW1wf5CDv2KDNWat+CtSkN11ozp1OGC9leNhuPur35UMCvBy
	0/hx2cXSGvpneyqwQM3nCYoJv5MoycIE8Rs4GwvmduZvZ0joYDn/YCYleFL+/bVkdbgLMd
	yiyrvIr0s6/GigfWlSBB36wWUddKJvs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-JrevmDS8Nf2GLO9ex9rD7w-1; Fri, 01 Mar 2024 13:16:01 -0500
X-MC-Unique: JrevmDS8Nf2GLO9ex9rD7w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10C2A868901;
	Fri,  1 Mar 2024 18:16:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9008492BE2;
	Fri,  1 Mar 2024 18:16:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 421IG0D6776233
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 1 Mar 2024 13:16:00 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 421IG0fr776232;
	Fri, 1 Mar 2024 13:16:00 -0500
Date: Fri, 1 Mar 2024 13:16:00 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] 11-dm-mpath.rules: fix misspelled
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
Message-ID: <ZeIbYETl5FIvfNxA@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240301172514.7262-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240301172514.7262-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 01, 2024 at 06:25:14PM +0100, Martin Wilck wrote:
> Fixes: b3582da ("11-dm-mpath.rules: use import logic like 13-dm-disk.rules")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index d364f9b..d9585ab 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -116,7 +116,7 @@ LABEL="scan_import"
>  ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
>  
>  # Don't import the properties from db if we will run blkid later.
> -ENV{DM_NOSCAN}!="1", ENV{DM_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
> +ENV{DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
>  
>  IMPORT{db}="ID_FS_TYPE"
>  IMPORT{db}="ID_FS_USAGE"
> -- 
> 2.43.2

