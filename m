Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AEC1E489
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 18:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712599279; cv=none; b=V1+z4vMHPEB5YIhtQX5AHXdi8YPZ45oT+42s7XW+YXMA3/9O1POcJ7gCedbe5ybH/v9TvxqnoHRbygwFuPpgpYEhsVefPidEUJy94FEaiCJ24dhl9YV9FoUlj3YfRljgA4Mhj/kl2Vyh00PFS2vCJyh2j2uER1lkCRwj85OrhQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712599279; c=relaxed/simple;
	bh=BzV738kLB+cNlKCXecxNTHC1stP+IVy5cRJCpiNb2yQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=QNAEQZ3B22PLIcC/gMJsMsr4mNzVJ0ZCz6SwD+B8ZYzVnGRkqrEcPT+JHox6tjZDLVNATMpj8RgjnkJgO5M938SNtJSnroa6S2FP51qCswfEdHpSli2JMgAxO6yuSgK2DM5mMhKMK8b18mhh1hxfnzsH2BC71Nw3o5mN7K1Wg4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KeSKaE+c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KeSKaE+c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712599275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r3XodsA0ubLFvNqrdWblEnJXL1ge9aI686xeaMK7YRo=;
	b=KeSKaE+c7yhkyOIFfQ4Un06Q7enVS/hpqmLDPLXAfU5ASwEKFhY5PcTWrp/cM5V/JJ100g
	LKLtp5/nXiCYkb5R+5MKizvDczjfwsuG6kIL7aAxgdNmcFV7vIeRayQyYala3QH5tM1W0s
	RVuoU6HPhCdMeHJTVNlHwuAzKVvnnvk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-oeJgoqyGMWGIAUvjGACC4Q-1; Mon, 08 Apr 2024 14:01:14 -0400
X-MC-Unique: oeJgoqyGMWGIAUvjGACC4Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3D2D802A6F;
	Mon,  8 Apr 2024 18:01:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 867D8C26A4A;
	Mon,  8 Apr 2024 18:01:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 438I1DPM1818279
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Apr 2024 14:01:13 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 438I1CcJ1818278;
	Mon, 8 Apr 2024 14:01:12 -0400
Date: Mon, 8 Apr 2024 14:01:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 01/11] 11-dm-mpath.rules: explain logic for device
 becoming ready while suspended
Message-ID: <ZhQw6DRsM4rIAkhm@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240404173814.3143-1-mwilck@suse.com>
 <20240404173814.3143-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240404173814.3143-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2024 at 07:38:04PM +0200, Martin Wilck wrote:
> Add a comment to explain why we must set MPATH_DEVICE_READY=0 when
> we see a device becoming ready (number of active paths 0 -> 1) while
> the device is suspended.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index d9585ab..b8d19d0 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -98,6 +98,8 @@ ENV{MPATH_DEVICE_READY}=="0", \
>  # If the device comes back online, set DM_ACTIVATION so that
>  # upper layers do a rescan. If the device is currently suspended,
>  # we have to postpone the activation until the next event.
> +# In this case, we have to set MPATH_DEVICE_READY=0; otherwise, the
> +# MPATH_UNCHANGED logic will cause later rules to skipped in the next event.
>  ENV{MPATH_DEVICE_READY}=="0", GOTO="dont_activate"
>  ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
>  ENV{DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
> -- 
> 2.44.0

