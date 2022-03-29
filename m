Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA42C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 29 Mar 2022 20:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648586068;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tR9KQGWHWKlzPH7CmRh5EZARbT3uw0/BXKAWbbJ+4tw=;
	b=NryltmiPyuaRHqb1FxGwE4sY75ph5g5V7Rp6cMtvE0G7zv+gCioq4GwXiV8pT/p4XNkHB0
	X7iSU1+s0TgZ5b/vKAps8QoM4T/1Chh/d3fdtFBmShSzLfC+YSxGCi5zL4OjjJtWNFomph
	5QcOis8QWbhMyAgw52EmkmCvNe8Ve7U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-goZR0zNePFG-lcQTIavYiQ-1; Tue, 29 Mar 2022 16:34:24 -0400
X-MC-Unique: goZR0zNePFG-lcQTIavYiQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4ED9428EC10B;
	Tue, 29 Mar 2022 20:34:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4CE2B400E554;
	Tue, 29 Mar 2022 20:34:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DE0DC1940345;
	Tue, 29 Mar 2022 20:34:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5328E1940342
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Mar 2022 20:34:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D70B400E11D; Tue, 29 Mar 2022 20:34:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B2514010A3D;
 Tue, 29 Mar 2022 20:34:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22TKYFQ5026948;
 Tue, 29 Mar 2022 15:34:15 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22TKYECT026947;
 Tue, 29 Mar 2022 15:34:14 -0500
Date: Tue, 29 Mar 2022 15:34:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220329203414.GO24684@octiron.msp.redhat.com>
References: <20220324211927.7152-1-mwilck@suse.com>
 <20220324211927.7152-2-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220324211927.7152-2-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v3 11/12] multipathd: make startup / shutdown
 messages less noisy
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Guozhonghua <guozh88@chinatelecom.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Mar 24, 2022 at 10:19:26PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> These messages are noisy in the system log without being actually helpful.
> Print the version number on startup.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipathd/main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9ef3197..aee0953 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -37,6 +37,7 @@
>  /*
>   * libmultipath
>   */
> +#include "version.h"
>  #include "parser.h"
>  #include "vector.h"
>  #include "config.h"
> @@ -2566,7 +2567,6 @@ checkerloop (void *ap)
>  	rcu_register_thread();
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
>  	vecs = (struct vectors *)ap;
> -	condlog(2, "path checkers start up");
>  
>  	/* Tweak start time for initial path check */
>  	get_monotonic_time(&last_time);
> @@ -3247,8 +3247,8 @@ child (__attribute__((unused)) void *param)
>  
>  	post_config_state(DAEMON_START);
>  
> -	condlog(2, "--------start up--------");
> -	condlog(2, "read " DEFAULT_CONFIGFILE);
> +	condlog(2, "multipathd v%d.%d.%d: start up", MULTIPATH_VERSION(VERSION_CODE));
> +	condlog(3, "read " DEFAULT_CONFIGFILE);
>  
>  	if (verbosity)
>  		libmp_verbosity = verbosity;
> @@ -3441,7 +3441,7 @@ child (__attribute__((unused)) void *param)
>  
>  	exit_code = 0;
>  failed:
> -	condlog(2, "--------shut down-------");
> +	condlog(2, "multipathd: shut down");
>  	/* All cleanup is done in the cleanup_child() exit handler */
>  	return sd_notify_exit(exit_code);
>  }
> -- 
> 2.35.1
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

