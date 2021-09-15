Return-Path: <SRS0=IV6L=OF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3633AC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 23:03:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B6BCC60EE3
	for <dm-devel@archiver.kernel.org>; Wed, 15 Sep 2021 23:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B6BCC60EE3
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631746988;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5xVmUFMZE1CCgTVEondsdOMq27WIzMdzwgoKpLoY0T4=;
	b=J94XvETBRRxKqYbT4IeynC3o2EYw9Ll3o6rgpRXAXz3iX+1700zJIwIT2xt0JhPmRD8efo
	4DXy+mPpuE1ia6b4JVkskBf+zQie+TiGlYZ7xOXOBq+mseZVi6qRae4vBbFXkDt+H8wtcw
	XnDuA5WQWxTTEg68jU51P/yTzufBDqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-7blNkMk7O4CIOGVOEQaR1w-1; Wed, 15 Sep 2021 19:03:07 -0400
X-MC-Unique: 7blNkMk7O4CIOGVOEQaR1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1A071800D41;
	Wed, 15 Sep 2021 23:03:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 710C119C79;
	Wed, 15 Sep 2021 23:03:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 47151180142F;
	Wed, 15 Sep 2021 23:03:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18FN1Wn5011276 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 19:01:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 745431972E; Wed, 15 Sep 2021 23:01:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B562519C79;
	Wed, 15 Sep 2021 23:01:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18FN1QeE006613; 
	Wed, 15 Sep 2021 18:01:27 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18FN1Q15006612;
	Wed, 15 Sep 2021 18:01:26 -0500
Date: Wed, 15 Sep 2021 18:01:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210915230126.GT3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-9-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-9-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 08/35] multipathd: cli.h: formatting
	improvements
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Sep 10, 2021 at 01:40:53PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> No functional changes. Just make the code a little easier to read.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/cli.h | 82 ++++++++++++++++++++++++------------------------
>  1 file changed, 41 insertions(+), 41 deletions(-)
> 
> diff --git a/multipathd/cli.h b/multipathd/cli.h
> index fdfb9ae..1e8948a 100644
> --- a/multipathd/cli.h
> +++ b/multipathd/cli.h
> @@ -4,83 +4,83 @@
>  #include <stdint.h>
>  
>  enum {
> -	__LIST,
> +	__LIST,			/*  0 */
>  	__ADD,
>  	__DEL,
>  	__SWITCH,
>  	__SUSPEND,
> -	__RESUME,
> +	__RESUME,			/*  5 */
>  	__REINSTATE,
>  	__FAIL,
>  	__RESIZE,
>  	__RESET,
> -	__RELOAD,
> +	__RELOAD,			/* 10 */
>  	__FORCEQ,
>  	__DISABLEQ,
>  	__RESTOREQ,
>  	__PATHS,
> -	__MAPS,
> +	__MAPS,			/* 15 */
>  	__PATH,
>  	__MAP,
>  	__GROUP,
>  	__RECONFIGURE,
> -	__DAEMON,
> +	__DAEMON,			/* 20 */
>  	__STATUS,
>  	__STATS,
>  	__TOPOLOGY,
>  	__CONFIG,
> -	__BLACKLIST,
> +	__BLACKLIST,			/* 25 */
>  	__DEVICES,
>  	__RAW,
>  	__WILDCARDS,
>  	__QUIT,
> -	__SHUTDOWN,
> +	__SHUTDOWN,			/* 30 */
>  	__GETPRSTATUS,
>  	__SETPRSTATUS,
>  	__UNSETPRSTATUS,
>  	__FMT,
> -	__JSON,
> +	__JSON,			/* 35 */
>  	__GETPRKEY,
>  	__SETPRKEY,
>  	__UNSETPRKEY,
>  	__KEY,
> -	__LOCAL,
> +	__LOCAL,			/* 40 */
>  	__SETMARGINAL,
>  	__UNSETMARGINAL,
>  };
>  
> -#define LIST		(1 << __LIST)
> -#define ADD		(1 << __ADD)
> -#define DEL		(1 << __DEL)
> -#define SWITCH		(1 << __SWITCH)
> -#define SUSPEND		(1 << __SUSPEND)
> -#define RESUME		(1 << __RESUME)
> -#define REINSTATE	(1 << __REINSTATE)
> -#define FAIL		(1 << __FAIL)
> -#define RESIZE		(1 << __RESIZE)
> -#define RESET		(1 << __RESET)
> -#define RELOAD		(1 << __RELOAD)
> -#define FORCEQ		(1 << __FORCEQ)
> -#define DISABLEQ	(1 << __DISABLEQ)
> -#define RESTOREQ	(1 << __RESTOREQ)
> -#define PATHS		(1 << __PATHS)
> -#define MAPS		(1 << __MAPS)
> -#define PATH		(1 << __PATH)
> -#define MAP		(1 << __MAP)
> -#define GROUP		(1 << __GROUP)
> -#define RECONFIGURE	(1 << __RECONFIGURE)
> -#define DAEMON		(1 << __DAEMON)
> -#define STATUS		(1 << __STATUS)
> -#define STATS		(1 << __STATS)
> -#define TOPOLOGY	(1 << __TOPOLOGY)
> -#define CONFIG		(1 << __CONFIG)
> -#define BLACKLIST	(1 << __BLACKLIST)
> -#define DEVICES		(1 << __DEVICES)
> -#define RAW		(1 << __RAW)
> -#define COUNT		(1 << __COUNT)
> -#define WILDCARDS	(1 << __WILDCARDS)
> -#define QUIT		(1 << __QUIT)
> -#define SHUTDOWN	(1 << __SHUTDOWN)
> +#define LIST		(1ULL << __LIST)
> +#define ADD		(1ULL << __ADD)
> +#define DEL		(1ULL << __DEL)
> +#define SWITCH		(1ULL << __SWITCH)
> +#define SUSPEND	(1ULL << __SUSPEND)
> +#define RESUME		(1ULL << __RESUME)
> +#define REINSTATE	(1ULL << __REINSTATE)
> +#define FAIL		(1ULL << __FAIL)
> +#define RESIZE		(1ULL << __RESIZE)
> +#define RESET		(1ULL << __RESET)
> +#define RELOAD		(1ULL << __RELOAD)
> +#define FORCEQ		(1ULL << __FORCEQ)
> +#define DISABLEQ	(1ULL << __DISABLEQ)
> +#define RESTOREQ	(1ULL << __RESTOREQ)
> +#define PATHS		(1ULL << __PATHS)
> +#define MAPS		(1ULL << __MAPS)
> +#define PATH		(1ULL << __PATH)
> +#define MAP		(1ULL << __MAP)
> +#define GROUP		(1ULL << __GROUP)
> +#define RECONFIGURE	(1ULL << __RECONFIGURE)
> +#define DAEMON		(1ULL << __DAEMON)
> +#define STATUS		(1ULL << __STATUS)
> +#define STATS		(1ULL << __STATS)
> +#define TOPOLOGY	(1ULL << __TOPOLOGY)
> +#define CONFIG		(1ULL << __CONFIG)
> +#define BLACKLIST	(1ULL << __BLACKLIST)
> +#define DEVICES	(1ULL << __DEVICES)
> +#define RAW		(1ULL << __RAW)
> +#define COUNT		(1ULL << __COUNT)
> +#define WILDCARDS	(1ULL << __WILDCARDS)
> +#define QUIT		(1ULL << __QUIT)
> +#define SHUTDOWN	(1ULL << __SHUTDOWN)
>  #define GETPRSTATUS	(1ULL << __GETPRSTATUS)
>  #define SETPRSTATUS	(1ULL << __SETPRSTATUS)
>  #define UNSETPRSTATUS	(1ULL << __UNSETPRSTATUS)
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

