Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15591D54F
	for <dm-devel@lists.linux.dev>; Tue, 26 Mar 2024 22:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711490688; cv=none; b=U6+NM/e5/WaTXBrXcJ+K8ijIiIN2IuAiRs0kgFkUS60CYnXH9HFdpiNi7GMhW3Borf9lrPwtwWT2GYcVJxcT33Wy0VoWg5LB4+MqWFc7ordIvszT/44jTRtRQPteXg4qMRVnBKyVBEHOOgr6yK4QkCvAnGd6AiYN7ZNH/O3OVhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711490688; c=relaxed/simple;
	bh=QY8h4ncNqsvhv0M/BYJDjC9oT/zI2W+pUYlzh+BLzyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hIyAJe7Z94mq9lCWUIYUrCamwpMfvm8Y6VkRHQzRL7xzyZGq6Yi6xqJm0+wx1pIIfZ/Zh70T9ca7fWFWqbEMyb0aZWZ4IuA9Z1Pyfc/Jafp9ADhtQlICk/Ci17t2kBf+vCQ9/rghHo1P3uZ1d8Pi0xl7WPidU/rhiktZRvwXdkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O+DFhPzQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O+DFhPzQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711490685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/h4L6Zt8O5M0o22T73OPRgrpHi5wKTlaeufqAHZFOEQ=;
	b=O+DFhPzQ1gfLgNgCeCs/T4pm0EgWyixv1e3CmV9Tki41RKi3JrxypYBdJxroxvUKzfc322
	pK3WigNJuRQM21y5uk6SPvIWCZXFIiKLFEQZRaITjEa1rEK8yx+Sgk/Wlpnglp82ABfgpK
	s32OemWzobhehspxB0dSIVKxXp0JkKw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-450-yAey1-wPNoCrmjRb5Vww9g-1; Tue,
 26 Mar 2024 18:04:42 -0400
X-MC-Unique: yAey1-wPNoCrmjRb5Vww9g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED97C3800BA1;
	Tue, 26 Mar 2024 22:04:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFF0FC54F80;
	Tue, 26 Mar 2024 22:04:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42QM4fZH1407187
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 18:04:41 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42QM4fdp1407186;
	Tue, 26 Mar 2024 18:04:41 -0400
Date: Tue, 26 Mar 2024 18:04:41 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 03/11] 11-dm-mpath.rules: don't import ID_FS_VERSION from
 udev db
Message-ID: <ZgNGeUA2aWpuRqx_@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:12:53PM +0100, Martin Wilck wrote:
> Use the same set of properties to import as 13-dm-disk.rules.
> ID_FS_VERSION isn't used in any udev rule I am aware of.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 11b5adf..5259b86 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -124,7 +124,6 @@ IMPORT{db}="ID_FS_TYPE"
>  IMPORT{db}="ID_FS_USAGE"
>  IMPORT{db}="ID_FS_UUID_ENC"
>  IMPORT{db}="ID_FS_LABEL_ENC"
> -IMPORT{db}="ID_FS_VERSION"
>  IMPORT{db}="ID_PART_ENTRY_NAME"
>  IMPORT{db}="ID_PART_ENTRY_UUID"
>  IMPORT{db}="ID_PART_ENTRY_SCHEME"
> -- 
> 2.43.2

