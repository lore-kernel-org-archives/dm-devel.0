Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35685226545
	for <dm-devel@lists.linux.dev>; Mon, 17 Feb 2025 21:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739826244; cv=none; b=GNQGNmCxK4S4eoRFATYjJamJ3oSfCFGOGQRuoIjn6zIUrreDQ6DAQRY2+XxGLnO4v2946VrLV+hD61x4HrgAKwbKMJ504K+Qhycusk6QMQ01J4IN+m8wTETMU7s2C4KZUeO9yI1AnhqdZub2xrpZm98O3fG9UTOSICU+7klC2Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739826244; c=relaxed/simple;
	bh=dGSuUXhSLu9hKXSLe1UgYWjkkwp5PdIxjETsD1GuYgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Qli7Qjt0jfXcLKint+WCmRKJQiePkKfTmAtemj9toOEwK/Wp4kqjzYUxux+fCRme8pSoVf9knNo/i8vBilTXMG3A3K/WUCUbF8+Kastwwr/X+YviJ8AxSghF9+kqetOegWQRuwbVcXCA5zcnyF3iGKnac/XCwjrOzjNNeXGrPQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fQ7zNHnw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQ7zNHnw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739826242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GmhH52TmqXGyxkhb0Z9d5QJXrPPACfE0k2Xkkb9Y0oo=;
	b=fQ7zNHnwp6hv0+88ik/PCJAqnL7LZe7/Rjf83USAJJnIHXQIf0FOUocq7/J2sIxW/fGu4g
	Du6DtyoxfuZ2VUoLS2yFe8ebbcbFAow620+EuzDU93/peCEe5I3zhNLMTyKiSVQBfKdTu8
	R/cfW8OnS42WLsIQUudVPoGRbZzk/s8=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-6oAwxc1fOY-nzwTIY0vgiw-1; Mon,
 17 Feb 2025 16:03:59 -0500
X-MC-Unique: 6oAwxc1fOY-nzwTIY0vgiw-1
X-Mimecast-MFC-AGG-ID: 6oAwxc1fOY-nzwTIY0vgiw_1739826239
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04622196E078;
	Mon, 17 Feb 2025 21:03:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94CEC1800352;
	Mon, 17 Feb 2025 21:03:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 51HL3vgN3047012
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 16:03:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 51HL3vdL3047011;
	Mon, 17 Feb 2025 16:03:57 -0500
Date: Mon, 17 Feb 2025 16:03:57 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Khem Raj <raj.khem@gmail.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] libmpathutils/uxsock.c: Include string.h for memcpy
Message-ID: <Z7OkPcrX9dhWUPSn@redhat.com>
References: <20250217200503.4166910-1-raj.khem@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250217200503.4166910-1-raj.khem@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3OTWzWxEjnV-MFLzIqUnjy3u5tXRsD0VP4lAFBpdLRk_1739826239
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2025 at 12:05:03PM -0800, Khem Raj wrote:
> Fixes
> uxsock.c:72:2: error: call to undeclared library function 'memcpy' with type 'void *(void *, const void *, unsigned long)'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathutil/uxsock.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
> index 2135476d..a474874e 100644
> --- a/libmpathutil/uxsock.c
> +++ b/libmpathutil/uxsock.c
> @@ -8,6 +8,7 @@
>  #include <stdlib.h>
>  #include <unistd.h>
>  #include <stdarg.h>
> +#include <string.h>
>  #include <fcntl.h>
>  #include <sys/ioctl.h>
>  #include <sys/types.h>

