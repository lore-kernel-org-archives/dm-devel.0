Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CF47FA
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 00:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707438772; cv=none; b=CdNdG9qRU4dytVr/ac7KWV5zk07NScCu5gMGSNdoiNQT54XDgXEG+kukn426/tSySbsjZLfQk4GWmZEUBYRsL8UO8ncqYOHJx6TUbFUKHhja8TO40oddGpgN+EBfGB9L0Q74LFA2GkusVo6p4OlpzivFDhM8/ch+vL4irhj/QyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707438772; c=relaxed/simple;
	bh=Hk58IBf7tUw0or6976bRsmRPeK0JWz3X6M8VyTox6Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=IVVqkGR7TBpFOOQSJJncZDtmI/FotkiWeZYI+NwWK9u+MdGczV5zgveprTiCtX8a9HbbysL18z1KPrqmjbWwSnJl1WWPtpDEATgrzZ6wA+3DuSblF9CcrvMWav8XEYokOoKZ3vHLZosDikjtOlRS7twRdmEZXhQcGymYqsYBRHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hDAQN54k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hDAQN54k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707438769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LlPkUFK2YpoyxFA/vm8hM+kc0H8ZFPBzpKX7BhOS6V8=;
	b=hDAQN54kK8cKoHl2sy3HuWvkQGdCHN3dMGIjDN1K2Adwl1s1i9CA05sJF7llcLCHW+C/0v
	mYQqltfn9lrejXlJLVfjEhp/oLbzCSd7QWCHA6/c5qw+dTEzorCz3DGW66WPiR4VfY5d+f
	/nMCktHyMM809RY2QPJIROazmY5VMsc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-uK07ezGxMnSAsX1Hw6VtLQ-1; Thu,
 08 Feb 2024 19:32:46 -0500
X-MC-Unique: uK07ezGxMnSAsX1Hw6VtLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF1A83C02766;
	Fri,  9 Feb 2024 00:32:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3E1DC0FDCB;
	Fri,  9 Feb 2024 00:32:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 4190Wjvm338374
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Feb 2024 19:32:45 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 4190Wjxl338373;
	Thu, 8 Feb 2024 19:32:45 -0500
Date: Thu, 8 Feb 2024 19:32:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 2/6] 11-dm-mpath.rules: fix list of imported properties
Message-ID: <ZcVyrVx4uXcVJKct@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240205124638.17877-1-mwilck@suse.com>
 <20240205124638.17877-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240205124638.17877-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2024 at 01:46:34PM +0100, Martin Wilck wrote:
> Make sure we import all properties that are also imported in
> 13-dm-disk.rules. Keep importing ID_FS_TYPE for now to avoid
> breakage, even if 13-dm-disk.rules does not.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
> index 2c4d006..43d227c 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules
> @@ -92,11 +92,13 @@ LABEL="scan_import"
>  ENV{DM_NOSCAN}!="1", GOTO="import_end"
>  IMPORT{db}="ID_FS_TYPE"
>  IMPORT{db}="ID_FS_USAGE"
> -IMPORT{db}="ID_FS_UUID"
>  IMPORT{db}="ID_FS_UUID_ENC"
> -IMPORT{db}="ID_FS_LABEL"
>  IMPORT{db}="ID_FS_LABEL_ENC"
>  IMPORT{db}="ID_FS_VERSION"
> +IMPORT{db}="ID_PART_ENTRY_NAME"
> +IMPORT{db}="ID_PART_ENTRY_UUID"
> +IMPORT{db}="ID_PART_ENTRY_SCHEME"
> +IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
>  
>  LABEL="import_end"
>  
> -- 
> 2.43.0

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

