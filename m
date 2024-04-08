Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C56E1E489
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712599294; cv=none; b=KWy0FUosHR71+T51fch2hE8vlEfi4bC5jxK0Gym3WuuZNS+Ivb3OMVRBSUq0o4cMS2FM9kh7+qFX+eTyZ7ucsqxc1fpkUZJ/AXi6VjNm4ptSdCU9FP8X6ktjoNHQHlGthbmA73c9v8HMQ3JiWjtkqIBwFH62VuXXlzZGrx1zj7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712599294; c=relaxed/simple;
	bh=+wyT+foUhNWDlt4BLK0sWlfSqj+g0OmEOO0TYYllZ3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=pcG+iN8Tj6l0b+Io0mKh6n+Y5axX91jgpk3NfNng2esZGbTydNKR6TWv4pNn52MGffotPzbKUyztpA1T6vTl8IAN5ON0Jdx9hSJoawxZh5A16avOu1/haCy93OtOUUPnI1WBiTVEc7FbByqfZsT36H6f5Qnp05VSkMeYuj+YT/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TMhzzVqA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TMhzzVqA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712599292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jCq7voa+Zuf/zXXNEPKv9hy+kYSU0ESGllO9YwtZtiI=;
	b=TMhzzVqAXo6RC1UWDH7B9UHv9tj8g6DCZGyFyfywlgZo00kX5MH2m/7UHT9oCZYHOVVvyU
	nFAsDRtTcCriBh6QE9Nziv7U+Up2Epc2EAeKE26I72h6uTlL7D5KajZMMwUWJBBFT7cZJl
	Dtnxa3vkORsWa10fD/cQYEXdh2F+vUw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-Dp0xgz_lPRqYdcaUfGuo3w-1; Mon, 08 Apr 2024 14:01:29 -0400
X-MC-Unique: Dp0xgz_lPRqYdcaUfGuo3w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E5088032FA;
	Mon,  8 Apr 2024 18:01:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56FA5200B22C;
	Mon,  8 Apr 2024 18:01:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 438I1TbS1818287
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Apr 2024 14:01:29 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 438I1TVN1818286;
	Mon, 8 Apr 2024 14:01:29 -0400
Date: Mon, 8 Apr 2024 14:01:29 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 02/11] 11-dm-mpath.rules: don't import DM_NOSCAN from
 udev db
Message-ID: <ZhQw-UqLm9hNaBi8@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240404173814.3143-1-mwilck@suse.com>
 <20240404173814.3143-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240404173814.3143-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2024 at 07:38:05PM +0200, Martin Wilck wrote:
> DM_NOSCAN is our "output" flag for 13-dm-disk.rules, and it should
> be treated the same way as DM_UDEV_DISABLE_OTHER_RULES_FLAG, which
> isn't imported from the udev database. The state that we need to
> remember is MPATH_DEVICE_READY, which we've already imported above,
> and we will set the "output" flags accordingly in the "force_activation"
> code path further down.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index b8d19d0..eb12b0c 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -18,9 +18,11 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1
>  
>  # If this uevent didn't come from dm, don't try to update the
>  # device state
> +# Note that .MPATH_DEVICE_READY_OLD=="" here. Thus we won't activate the
> +# device below at force_activation, which is correct.
>  ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
> -	IMPORT{db}="DM_NOSCAN", IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
> -	GOTO="scan_import"
> +	IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
> +	GOTO="force_activation"
>  
>  ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
>  
> -- 
> 2.44.0

