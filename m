Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2FB31AABC
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 01:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778634223; cv=none; b=W603N/HySnDPrGzskogFW9ptCYi+IkhbnBtC3vAa4lzwqKjWD0kLH55XDaR48gO2M/Oz5dfRRGUal+AFLeWNFEtYwPRTRs8JO/HgTUO46L1vszMyAE7lmzO4xgTtpVKgeePkGVK4/eZ9u12yx6KwB4j8EF4zIhVSAfeBzCVXPw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778634223; c=relaxed/simple;
	bh=DbVK70PruYLurvxzYxRUIC5JXDHtMWdGNo9q1XuudX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VWDw+mDLoEFva/dYLhz89P8OcpOS51vFnwPd4UmxLpwx71exGg9/FIX5bcmKqsSFK6ys7ikbti+W6MWigQH9d6OJuGTx115zJJT1YfrRpHnlIV98HA7sWFLjRCwhPsq5pelciSZ20Ek77Iebx3uB/FM5fARG5Bn4P9F89NCP1GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SmC4umx5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SmC4umx5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778634216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iv825l5zjEgeyaV5UzMLeAdsRxpc3HUVIp7FYeN89jA=;
	b=SmC4umx5uLoCZNfthz7UvgQMRh9eAfzPTAH7l2ZW9pSCIk75+0BZcc3FJp11/6RhWKLMaX
	eHCJ3jSJxHz+LN9xf0fiN1knGQR4eEe9JOSmljUe1Drz8Ey1Vj1MqAEHoaUnvk6nP+6LM8
	sqbu6Xom3tWni04niTUPdjPB9BnjaUA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-RPvpUx4qMXq1RjCWCEskrQ-1; Tue,
 12 May 2026 21:03:31 -0400
X-MC-Unique: RPvpUx4qMXq1RjCWCEskrQ-1
X-Mimecast-MFC-AGG-ID: RPvpUx4qMXq1RjCWCEskrQ_1778634210
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22D271800283;
	Wed, 13 May 2026 01:03:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4239180058F;
	Wed, 13 May 2026 01:03:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 64D13SvP3332254
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 12 May 2026 21:03:28 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 64D13SUC3332253;
	Tue, 12 May 2026 21:03:28 -0400
Date: Tue, 12 May 2026 21:03:28 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 11/18] libmultipath: convert TUR checker to an async
 checker instance
Message-ID: <agPN4AagZhT6mEjl@redhat.com>
References: <20260505154332.448054-1-mwilck@suse.com>
 <20260505154332.448054-12-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260505154332.448054-12-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XVMrtM5co-3PNe7WmkHeXck2cLZio7pG5iQLwdACH_o_1778634210
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 05, 2026 at 05:43:25PM +0200, Martin Wilck wrote:
> The TUR checker now just exports the message table and the
> "libcheck_async_func" symbol. This converts it into an instance of
> the generic async checker model.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers/tur.c | 251 +++---------------------------------
>  1 file changed, 15 insertions(+), 236 deletions(-)
> 
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index 6791172..757767a 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -3,87 +3,31 @@
>   *
>   * Copyright (c) 2004 Christophe Varoqui
>   */
> -#include <stdlib.h>
> -#include <string.h>
> -#include <sys/types.h>
> -#include <sys/stat.h>
> -#include <unistd.h>
> -#include <fcntl.h>
>  #include <sys/ioctl.h>
> -#include <sys/sysmacros.h>
> +#include <sys/types.h>
> +
>  #include <errno.h>
> -#include <sys/time.h>
>  
>  #include "checkers.h"
> -#include "debug.h"
> +#include "async_checker.h"
>  #include "sg_include.h"
> -#include "runner.h"
>  
>  #define TUR_CMD_LEN 6
>  #define HEAVY_CHECK_COUNT       10
> -#define MAX_NR_TIMEOUTS 1
>  
>  enum {
> -	MSG_TUR_RUNNING = CHECKER_FIRST_MSGID,
> -	MSG_TUR_TIMEOUT,
> -	MSG_TUR_FAILED,

MSG_TUR_FAILED isn't actually used anymore, and can get removed.
Otherwise this looks good.

-Ben

