Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B785B13D532
	for <dm-devel@lists.linux.dev>; Tue, 26 Mar 2024 22:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711493086; cv=none; b=qrDz2dzI38TLCixjQ7/XUGCmxaZNy//Hik2ha8m3lWLpUaSyVZ/cF63Dt9jQA41R6Z2zFtOJdMWWXFtrn48nAggtXHVcLl65n8XVO+8hbryCe+D8HCkuARIiQCl+REDwwu565sHzVHYwbD/4lBi3L95bqV/17BnDUiw+0hXCUFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711493086; c=relaxed/simple;
	bh=hHgIKvBihquMNZRlf3nqicsZXoHqgw8dD1Zq5ox75XY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=elOnLR0PROBgio4gSXKAZAJXaNkPAVnUMJe4mQ995DsIR6iH7MvRmRdHRx2+d9UTijjb8xCc/W/3hWasmENfA3suKDf3bKmpFKtYGBrvu3vY/3qD7EgoPTmsFxEbjgAg5sxlaHknACIBfP0FzWvepbwf3DXiyk+dy9GODcOK74g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BX43LkUC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BX43LkUC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711493081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fnIwOBfEMzvYKKHYlzu4vkrNDYDn7jYoqazIucvF6Ng=;
	b=BX43LkUCuq33X4LJcNJBTSwJja05Hr73qkpy1uvCG8+2psijHs5YQ5aDj6Kl+xLtqTkkJx
	+Eh25/F9VYlimZTU0dhxbYetGleBgBXRNU3L9KpwFFKodfPsCKlm/cLsB80s/4vfPIWpp3
	ybIXEe6ojO6l4I/btssNOSGDApPveiU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-vzIWHhdePSaYQgmtCIEMRQ-1; Tue, 26 Mar 2024 18:44:38 -0400
X-MC-Unique: vzIWHhdePSaYQgmtCIEMRQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 954E8811E81;
	Tue, 26 Mar 2024 22:44:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43DC1C017A0;
	Tue, 26 Mar 2024 22:44:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42QMiagV1407476
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 18:44:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42QMiaDj1407475;
	Tue, 26 Mar 2024 18:44:36 -0400
Date: Tue, 26 Mar 2024 18:44:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 05/11] 11-dm-mpath.rules: adapt coldplug event handling
 ro 10-dm.rules update
Message-ID: <ZgNP1MH0qhqy81zW@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-6-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-6-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:12:55PM +0100, Martin Wilck wrote:
> With late late patches for 10-dm.rules, DM_UDEV_DISABLE_OTHER_RULES_FLAG is
> never restored from the udev db. Thus we don't need to clear it here
> any more for coldplug events. Also, we must use .DM_SUSPENDED instead of
> DM_SUSPENDED as input flag with the v3 rule set (other occurences of
> DM_SUSPENDED will be replaced in a follow-up patch).
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules.in | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 997e3e7..cf004fd 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -9,12 +9,17 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
>  	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
>  	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
>  
> -# Coldplug event. DM_UDEV_DISABLE_OTHER_RULES_FLAG has been restored
> +# Coldplug event. Import previously set properties.
> +ACTION!="add", GOTO="mpath_coldplug_end"
> +ENV{DM_ACTIVATION}!="1", GOTO="mpath_coldplug_end"
> +ENV{DM_UDEV_RULES_VSN}=="3", ENV{.DM_SUSPENDED}!="1", GOTO="scan_import"
> +# With DM rules < v3, DM_UDEV_DISABLE_OTHER_RULES_FLAG has been restored
>  # from DB in 10-dm.rules. If the device is not suspended, clear the flag.
>  # This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
>  # equivalent to DM_SUSPENDED==1 || DISK_RO==1
> -ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
> +ENV{DM_UDEV_RULES_VSN}!="3", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \

Again, I'd prefer ENV{DM_UDEV_RULES_VSN}="1|2"

>  	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="", GOTO="scan_import"
> +LABEL="mpath_coldplug_end"
>  
>  # If this uevent didn't come from dm, don't try to update the
>  # device state
> -- 
> 2.43.2

