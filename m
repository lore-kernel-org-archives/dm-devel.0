Return-Path: <SRS0=wQ+j=IQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1000DC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 15:11:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9C6D264D79
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 15:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C6D264D79
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616080277;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g7i/VqFjPRimoURV1rQpbG02woIU+YDG5uIxKUhjrZc=;
	b=ZqGvRu+K5InaNLWD/wDBDVryd7pgBNvQywOFj8kvYR7YQ3eWRq8wAgNlME/dWakpcpKEPE
	Q1Q2/Kb4AqusskgfTt081RcV/lvsLfrHDFr11qGOBYuADcIm7rqe8uiKKrYj/DO+/72UVf
	oOIecKLgupORbpw/H/VyArdK3y9Ipxs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-TkknmtNMMv-pgCZIhhvG9w-1; Thu, 18 Mar 2021 11:11:15 -0400
X-MC-Unique: TkknmtNMMv-pgCZIhhvG9w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA2FE107ACCD;
	Thu, 18 Mar 2021 15:11:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DDD85D9F2;
	Thu, 18 Mar 2021 15:11:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C726B1809C83;
	Thu, 18 Mar 2021 15:11:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12IFB8Ut014299 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Mar 2021 11:11:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4B7AC369A; Thu, 18 Mar 2021 15:11:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 536176F7EB;
	Thu, 18 Mar 2021 15:11:04 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12IFB28I018231; 
	Thu, 18 Mar 2021 10:11:03 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12IFB2Jt018230;
	Thu, 18 Mar 2021 10:11:02 -0500
Date: Thu, 18 Mar 2021 10:11:02 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210318151102.GB15006@octiron.msp.redhat.com>
References: <20210318091413.28027-1-mwilck@suse.com>
	<20210318091413.28027-3-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210318091413.28027-3-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 3/3] multipath-tools tests: check if
 /sys/dev/block is non-empty
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 18, 2021 at 10:14:13AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since f131e31 ("multipath-tools: devt test: avoid failure when run in
> containers"), we check the existence of /sys/dev/block before running
> the devt test. It turns out that on recent releases of podman (3.0.1),
> this check is insufficient, because /sys/dev/block exists now in
> containers, albeit empty. So we need to check for actual entries
> in the directory.
> 
> Fixes: f131e31 ("multipath-tools: devt test: avoid failure when run in containers")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  tests/devt.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/tests/devt.c b/tests/devt.c
> index 02f2e8f..d971302 100644
> --- a/tests/devt.c
> +++ b/tests/devt.c
> @@ -13,7 +13,9 @@
>  #include <sys/sysmacros.h>
>  #include <fcntl.h>
>  #include <sys/stat.h>
> +#include <sys/types.h>
>  #include <unistd.h>
> +#include <dirent.h>
>  #include "util.h"
>  #include "debug.h"
>  
> @@ -21,12 +23,22 @@
>  
>  static bool sys_dev_block_exists(void)
>  {
> -	int fd;
> -	bool rc;
> +	DIR *dir;
> +	bool rc = false;
>  
> -	fd = open("/sys/dev/block", O_RDONLY|O_DIRECTORY);
> -	rc = (fd != -1);
> -	close(fd);
> +	dir = opendir("/sys/dev/block");
> +	if (dir != NULL) {
> +		struct dirent *de;
> +
> +		while((de = readdir(dir)) != NULL) {
> +			if (strcmp(de->d_name, ".") &&
> +			    strcmp(de->d_name, "..")) {
> +				rc = true;
> +				break;
> +			}
> +		}
> +	}
> +	closedir(dir);
>  	return rc;
>  }
>  
> -- 
> 2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

