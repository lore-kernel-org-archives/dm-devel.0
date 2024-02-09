Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB27F7BB16
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 17:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707500996; cv=none; b=f79CRadSQ6r/3TEE6CE8igruup/CiWwGTq0IihMewZRBSl4mdHKuDysOkKCZA9+SX+o2q8rekZ1EJKVSImrLKr8pZsS1EFCl8HKcxR1P7wtgrZUGgFR/q3VtJFtc9tzqF0uzhRyCrmE2h/LDU9iWkfgfQ3n1RIZK1X2qLPwmlKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707500996; c=relaxed/simple;
	bh=4D+6L9Ah5IRiA0PsuMm0JqV75YaVKWhmqVf6hCHV7oU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=HqbvXXNyXMNrwibmKNV22Ft2HOLjyBOvdE8UPc1DQ6ZmtpuRwR6McTzV76nH7p51XDuc/gV5znZwu+L8YeZo4A7HEaW4Nh7Dqr18yHqOQBhtAyXRgcT6EWDp+VVW4xxk/YNLVgJLlLNe5r40Grvb14bUJKNGXbjBZv1VQHSBxCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fP7zQ+og; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fP7zQ+og"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707500993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=76embK3DVRbYJoLHAPUJ05TiAma/x/U5O1LzJTtEd+0=;
	b=fP7zQ+ogkf4L6/S0BgUhIVTruHuzKmBWuO2JgSC+/JPjORWzNBxHsIRqQFDhmj1+QSxU/Q
	2S+gCziXbGrNGjGcsi32jYZwqt0EoxKmC+toitReOglxHsEHlEE2YWazYpH+vTi12Y3cFK
	h+nPHE/kd11SoWbMMej8dSusc57BchQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-28-ciIIU18wN92qqZbGgoWRDQ-1; Fri,
 09 Feb 2024 12:49:52 -0500
X-MC-Unique: ciIIU18wN92qqZbGgoWRDQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D4B938212D1;
	Fri,  9 Feb 2024 17:49:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 362DB40C9444;
	Fri,  9 Feb 2024 17:49:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 419Hnp6o347335
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Feb 2024 12:49:52 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 419Hnpoj347334;
	Fri, 9 Feb 2024 12:49:51 -0500
Date: Fri, 9 Feb 2024 12:49:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 1/6] 11-dm-mpath.rules: use import logic like
 13-dm-disk.rules
Message-ID: <ZcZlv21zmafDm55_@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240209165513.7661-1-mwilck@suse.com>
 <20240209165513.7661-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240209165513.7661-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 09, 2024 at 05:55:08PM +0100, Martin Wilck wrote:
> We have to import the properties if either DM_NOSCAN or
> DM_DISABLE_OTHER_RULES_FLAG is set, because blkid will be skipped
> in both cases. Also, if DM_UDEV_PRIMARY_SOURCE_FLAG is not set,
> it makes no sense to try and import the properties.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index b3117f9..e7be12d 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -79,7 +79,14 @@ ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0", \
>  # not. If symlinks get lost, systemd may auto-unmount file systems.
>  
>  LABEL="scan_import"
> -ENV{DM_NOSCAN}!="1", GOTO="import_end"
> +
> +# If DM_UDEV_PRIMARY_SOURCE_FLAG is not set, the properties below
> +# have never been properly set. Don't import them.
> +ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
> +
> +# Don't import the properties from db if we will run blkid later.
> +ENV{DM_NOSCAN}!="1", ENV{DM_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
> +
>  IMPORT{db}="ID_FS_TYPE"
>  IMPORT{db}="ID_FS_USAGE"
>  IMPORT{db}="ID_FS_UUID_ENC"
> -- 
> 2.43.0

