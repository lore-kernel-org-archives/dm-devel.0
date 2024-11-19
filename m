Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405FE1D0E10
	for <dm-devel@lists.linux.dev>; Tue, 19 Nov 2024 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732036107; cv=none; b=Q/QCe2oruzWEGCu4ouM/IwnHm7bvsbhamtINXF9uxWn/k8ulU+du3Q6VHqMpvwiokyQwFFzigK9LWLj81ao78fbHGqN2cbsbjDJiZzlrdg0GpdibOnF/kDbSeM9FLF5Hy+W/u/GqtYmShi3R7hlbNURGzDhBKagFt6ra4UituSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732036107; c=relaxed/simple;
	bh=S6w3OyA+NP2yt0uYRYODmZ3BAMqBfR2nRoWuJCCFL74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hiDcjQGr6XMOGZ1MCFcaids07aOIfd7dq4edRmVQGWYGMgv/OnI89rCmPcEDjscOCMe1On9qmEbwOx6B2LjuBN/N4+B3ObkBsONWSraVUEdnA6osA5F5mUcfUBigvoZRNEKTqFgWC2hVovUMu/b8vWKT0pIGT6bbEfqqON70FKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DDZrhlUj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DDZrhlUj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732036104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=91DEb04hWHXdF9Kf+KOV4Pk4mN3jPMYJU86Mkvm+Q1A=;
	b=DDZrhlUjCsHUVqB5yR/is3eQuhHH19zzRWqe145myn0wLUMpM+s50BUA+fZtE67cxy9hqc
	MWApeGDXQELTEezFuBT73z6iFl2+8jEGJof/vSpgh3jmyFHQuE4wnjbOMMOt6ie7ttJzUA
	8SQOPhO/pOAp7iZx5uxOC9QhY6G+NQQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-bv4pDfqIOyOFn2Ul7f6BOg-1; Tue,
 19 Nov 2024 12:08:22 -0500
X-MC-Unique: bv4pDfqIOyOFn2Ul7f6BOg-1
X-Mimecast-MFC-AGG-ID: bv4pDfqIOyOFn2Ul7f6BOg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E44B195419F;
	Tue, 19 Nov 2024 17:08:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3749F19560A3;
	Tue, 19 Nov 2024 17:08:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AJH8Jsx678371
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 12:08:19 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AJH8J66678370;
	Tue, 19 Nov 2024 12:08:19 -0500
Date: Tue, 19 Nov 2024 12:08:19 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 1/1] multipathd: move systemd watchdog handling into
 daemon
Message-ID: <ZzzGAyrIvujCOMG6@redhat.com>
References: <20241119161218.708117-1-mwilck@suse.com>
 <20241119161218.708117-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241119161218.708117-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G3EqldFWUrosr_knrcSzX7U_LckzSCTKw1hlNhI1uuo_1732036101
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2024 at 05:12:18PM +0100, Martin Wilck wrote:
> Only multipathd needs to take care of notifying systemd. There's
> no need to track this information in struct config, or to limit our
> checker interval to it, as checkerloop() wakes up every second anyway.
> 
> While at it, fix the watchdog enablement logic:
> 
> - the watchdog should only be active if WATCHDOG_PID is either unset,
>   or matches the daemon's PID, and if WATCHDOG_USEC is not 0.
> - the watchdog should trigger twice per systemd-set interval.
> - if WatchdogSec= is set to an unreasonable value, make a smarter
>   choice than just disabling the watchdog, and print a more meaningful
>   error message.
> 
> Use timestamp comparison to make sure the watchdog is triggered even
> if a checkerloop iteration takes more than a second.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

