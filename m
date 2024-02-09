Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B280139B
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 00:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707438976; cv=none; b=u9nx8nUUjyVP4yZXxYj7bTUGjzxZrA3VKYBq3BE5WECHKnTtJb8CS/M9cSLXXZ0vI9jIUGqCNubTI330NeKUa7i9lvgpxrIGIAGlMirsfcmzve2Z5jc4BDO6dYNzMXxh5jaq9jEHo15/qOZXDMm/mUAc9BhNkJ5mlhqla8mL9sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707438976; c=relaxed/simple;
	bh=go8btp7pp+V50VsvKyDFUUyVuTN32v50qL6r2NDRSFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=TGr5tC10WmL5lGtXnYP9R89uommouRbLnWPf8psTAdDy1ETotpGkG9jANWSyV9cKfblamzFVCYDp62R/faMi/VpgPht8aBsfbxfbd4TmAzbbtQd33UCbs36lEn/4yfGgddxgUqA2PEWculGa9A79PPtOx3pmzMaBuYj21hYV4sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TxVcd0h9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TxVcd0h9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707438974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WIGOseNC8sdLoKSXojduDLmh5MhRqfHrwaFBkQxGTdI=;
	b=TxVcd0h978R6zLxSpVJhQtdEwxsIH/kiMSrhC5nO0OK6eLeU2/fsV7kfC/bHaBKS+J+Mfa
	f7oTrQlEcFj4Fh2Ml5Yfdw/LBMR1lzb0ijMN7O+Vm/5oZefkFELz1m4e5rGqTg4mPweqiE
	pc1pgK+p9dRwTV1ZOGpQEuuOjF+kV0w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-bgCTHxokPeisTdzEtonHUw-1; Thu, 08 Feb 2024 19:36:10 -0500
X-MC-Unique: bgCTHxokPeisTdzEtonHUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81B5F85A58B;
	Fri,  9 Feb 2024 00:36:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 788751C14B04;
	Fri,  9 Feb 2024 00:36:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 4190aAC0338395
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Feb 2024 19:36:10 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 4190aA2I338394;
	Thu, 8 Feb 2024 19:36:10 -0500
Date: Thu, 8 Feb 2024 19:36:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 3/6] 11-dm-mpath.rules: use import logic like
 13-dm-disk.rules
Message-ID: <ZcVzet-hfVMpgDA4@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240205124638.17877-1-mwilck@suse.com>
 <20240205124638.17877-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240205124638.17877-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2024 at 01:46:35PM +0100, Martin Wilck wrote:
> We have to import the properties if either DM_NOSCAN or
> DM_DISABLE_OTHER_RULES_FLAG is set, because blkid will be skipped
> in both cases. Also, if DM_UDEV_PRIMARY_SOURCE_FLAG is not set,
> it makes no sense to try and import the properties.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
> index 43d227c..8fc4a6f 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules
> @@ -89,7 +89,8 @@ ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0", \
>  # not. If symlinks get lost, systemd may auto-unmount file systems.
>  
>  LABEL="scan_import"
> -ENV{DM_NOSCAN}!="1", GOTO="import_end"
> +ENV{DM_NOSCAN}!="1", ENV{DM_DISABLE_OTHER_RULES_FLAG}!="1", \
> +	ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}=="1", GOTO="import_end"
>  IMPORT{db}="ID_FS_TYPE"
>  IMPORT{db}="ID_FS_USAGE"
>  IMPORT{db}="ID_FS_UUID_ENC"
> -- 
> 2.43.0

Doesn't this mean that we will always import the properties if
ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1"

I think you mean

ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
ENV{DM_NOSCAN}!="1", ENV{DM_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"

right?

-Ben

