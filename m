Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED25534CFDD
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 01:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778634309; cv=none; b=uGSRGivJx5CZlGmbYg9xQwIs9hy57gDAzPsMb7IrSnZDQo3Kq5FabQ69z6NvpJ5uTU3j7pLwzdkwPYV092O4PRs5ehMRX7jZ9Xr72IOAf7cN+2F3OKu1fdZuObbYOXuOxDKJ/ALVZhfl2QkGboAd0E7oNjEwzBJshlVvojfsJa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778634309; c=relaxed/simple;
	bh=xCMz/e0sh1ZIzKS0hGrbubuv3IvLZGBbmChhDDrac5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=T4RezqnlV+wSBWW96FYV85E2pVLJo02cRJpAaolbqEm6hMcn7hcpsmc7r0TfaZzGfyTHvxmTYVfsmzDR+UKquHy7yOQ6nOvsVIVIDQ9JgFAx4hOr3EQLNCPgPapZ2ffgdgWVrt80Fq5zE+vTUCJzu4XrslhfhQMupwiLwXfBuHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fDSLz05/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fDSLz05/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778634303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3U+Xd8dcYe3v8zuHaIMwYK5LvTtRbvGV0LBDDenPce0=;
	b=fDSLz05/OgC1th2awOuDo2oL5ENsSYDUJtrkcJ542y3XN+6KJC2CmbhYzZ16A30/4XV4U0
	WNAP0K7y4dObJkko+y7BrmWI/XGYyv68dTKVPoN6AgJcGRgynf9vcgo5kzlx1D37sWDzSZ
	vmOJJAKKtKn2753cdLHYftKOY5BJ53c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694--1GXzBy2PqyZYKbk0T6JsQ-1; Tue,
 12 May 2026 21:05:00 -0400
X-MC-Unique: -1GXzBy2PqyZYKbk0T6JsQ-1
X-Mimecast-MFC-AGG-ID: -1GXzBy2PqyZYKbk0T6JsQ_1778634298
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B317C1956089;
	Wed, 13 May 2026 01:04:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 611D81955D84;
	Wed, 13 May 2026 01:04:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D14vdB3332310
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 21:04:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D14veT3332309;
	Tue, 12 May 2026 21:04:57 -0400
Date: Tue, 12 May 2026 21:04:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 12/18] libmultipath: convert RDAC checker to async checker
Message-ID: <agPOOVt52XfQPhDg@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-13-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-13-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9-6tod6OFifyCjIZFLw8vyolbb3Qf9T6kxDzjveXiBU_1778634298
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:26PM +0200, Martin Wilck wrote:
> Make the RDAC checker use the async checker framework.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers/rdac.c | 30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
> index 87b8872..a477fb5 100644
> --- a/libmultipath/checkers/rdac.c
> +++ b/libmultipath/checkers/rdac.c
> @@ -1,8 +1,6 @@
>  /*
>   * Copyright (c) 2005 Christophe Varoqui
>   */
> -#include <stdio.h>
> -#include <stdlib.h>
>  #include <string.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -15,6 +13,7 @@
>  #include "debug.h"
>  
>  #include "sg_include.h"
> +#include "async_checker.h"
>  
>  #define INQUIRY_CMDLEN		6
>  #define INQUIRY_CMD		0x12
> @@ -55,11 +54,7 @@ struct control_mode_page {
>  	unsigned char dontcare1[6];
>  };
>  
> -struct rdac_checker_context {
> -	void * dummy;
> -};
> -
> -int libcheck_init (struct checker * c)
> +int libcheck_init(struct checker *c)

This function doesn't get called anymore. Do we not need to set the
TAS bit for some reason?

-Ben

>  {
>  	unsigned char cmd[MODE_SEN_SEL_CMDLEN];
>  	unsigned char sense_b[SENSE_BUFF_LEN];

