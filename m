Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0613D9E
	for <dm-devel@lists.linux.dev>; Tue,  5 Nov 2024 05:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730783410; cv=none; b=WABA480VgnvHkEf2YSBz/6KzVrkDcN8lO3r/fxHEaVOtxO7DhTZKXWVtNewGIFlScpceR/H0bQYCxjwJX/psd5E3L2wZQovU+MiEV7sMLgd6DCedcJbxSla9bEahh5oNAbmn2YVCbAKGSy1fm/uqu6V4/OSLTJIxM7yvskuD3oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730783410; c=relaxed/simple;
	bh=MvJR1kL11YmOOFh2FswUyDJySHsO1gQRX0ySVdWs9Kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=j/KePDhMy59X5uTKWa9AOBBcjEBG/aTdE/xuegAkHy7EUAI9k8J4uUcxWbMbzdFmuLVjbddjmHyDwRjNvY+iABGRKi6F5ZeQA5i8Y3uckBQggqSvtyQpop9aoqQPjEMJmW5NRTLWqFROM8vYB+59Jzf2/AOlzeHhS3GJtRxBy9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gcLzgv9w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gcLzgv9w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730783407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IQCFBBjDiv84p1/VzA7yRS9eA2Didc0ZWgU5jyZmtBc=;
	b=gcLzgv9wgWc01S8kMDu3vOcwQOhR2bDmWgKkAtUKBRNu8jCudtHcUrYAakYo1AIkooBe+G
	Kr/PQfx+H6iDFGbu/KZ7xqy+RMVR5NAHeJ24gU2WRQL+HsuF/sB8gYEGKHVnMU0ap5W8PD
	wThtcK+GfJglO+0fuPSGjWBEXFHTAJI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-454-Lo3__W0MPmKXZGh-GmHrDw-1; Tue,
 05 Nov 2024 00:10:01 -0500
X-MC-Unique: Lo3__W0MPmKXZGh-GmHrDw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 782F71955D99;
	Tue,  5 Nov 2024 05:10:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA79519560A3;
	Tue,  5 Nov 2024 05:09:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4A559wGw451804
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 5 Nov 2024 00:09:58 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4A559wfi451803;
	Tue, 5 Nov 2024 00:09:58 -0500
Date: Tue, 5 Nov 2024 00:09:58 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 0/5] multipath-tools: udev rule fixes
Message-ID: <Zymopi3HKoXeX8WQ@redhat.com>
References: <20241103224349.42582-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241103224349.42582-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 03, 2024 at 11:43:44PM +0100, Martin Wilck wrote:
> Here are more fixes for the multipath udev rules. 2/5 is an actual fix,
> 1/5, 3/5 and 4/5 are minor cleanups / code clarifications.
> 
> 5/5 implements the fix originally submitted by Ben [1].
> 
> Reviews and comments welcome.
> Martin

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> [1] https://lore.kernel.org/dm-devel/20241022233349.247087-1-bmarzins@redhat.com/
> 
> Martin Wilck (5):
>   11-dm-mpath.rules.in: import DM_COLDPLUG_SUSPENDED only once
>   11-dm-mpath.rules.in: handle inactive suspended devices correctly
>   11-dm-mpath.rules.in: clarify DM_ACTIVATION logic
>   11-dm-mpath-rules.in: skip one .DM_NOSCAN check
>   11-dm-mpath.rules.in: set .DM_NOSCAN if MPATH_UNCHANGED is set
> 
>  multipath/11-dm-mpath.rules.in | 44 ++++++++++++++++++++--------------
>  1 file changed, 26 insertions(+), 18 deletions(-)
> 
> -- 
> 2.47.0

