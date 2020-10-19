Return-Path: <SRS0=29P4=D2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD12C433E7
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 21:07:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 39B2622282
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 21:07:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MGxjQhl2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39B2622282
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603141666;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fvmyqEl9JzPP1U9gXSJuQDuDDlbMPf0fecRaVpqsy3A=;
	b=MGxjQhl2KPDchFByuNo3SL3MiMwUpe43j5qvU813IVpoqU7TNaWq6FLVlsUPhJK3bxILfA
	0itL47M1dnxBxITIZ/bA5AqmG8j9U0sbtUYFvu8hTJsp0nJCkd3PfXwAHoRxfI3nj/O6fh
	hJ5oDBkZXQu+v4uY1ja8ox85U2UfwRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-bzj_bpznPfOC_fIjEaLrBQ-1; Mon, 19 Oct 2020 17:07:44 -0400
X-MC-Unique: bzj_bpznPfOC_fIjEaLrBQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 113D9802B6B;
	Mon, 19 Oct 2020 21:07:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A6D45C1A3;
	Mon, 19 Oct 2020 21:07:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7A3461826D35;
	Mon, 19 Oct 2020 21:07:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09JL7Wop002387 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Oct 2020 17:07:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CF48661983; Mon, 19 Oct 2020 21:07:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79AF860C05;
	Mon, 19 Oct 2020 21:07:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09JL7RNJ014453; 
	Mon, 19 Oct 2020 16:07:28 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09JL7RsE014452;
	Mon, 19 Oct 2020 16:07:27 -0500
Date: Mon, 19 Oct 2020 16:07:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201019210726.GH3384@octiron.msp.redhat.com>
References: <20201016104501.8700-1-mwilck@suse.com>
	<20201016104501.8700-27-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201016104501.8700-27-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 26/29] libmultipath: simplify dlog()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 12:44:58PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> By checking the log level in condlog() directly, we can simplify
> dlog(). Also, it's now possible to limit the log level at compile
> time by setting MAX_VERBOSITY, enabling the compiler to optimize
> away log messages with higher loglevel.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/debug.c     | 30 +++++++++++++-----------------
>  libmultipath/debug.h     | 19 +++++++++++++++----
>  libmultipath/devmapper.c |  4 +++-
>  tests/test-log.c         |  4 ++--
>  tests/test-log.h         |  3 ++-
>  5 files changed, 35 insertions(+), 25 deletions(-)
> 
> diff --git a/libmultipath/debug.c b/libmultipath/debug.c
> index f9b7755..429f269 100644
> --- a/libmultipath/debug.c
> +++ b/libmultipath/debug.c
> @@ -18,29 +18,25 @@
>  int logsink;
>  int libmp_verbosity = DEFAULT_VERBOSITY;
>  
> -void dlog (int sink, int prio, const char * fmt, ...)
> +void dlog(int prio, const char * fmt, ...)
>  {
>  	va_list ap;
>  
>  	va_start(ap, fmt);
> +	if (logsink != LOGSINK_SYSLOG) {
> +		if (logsink == LOGSINK_STDERR_WITH_TIME) {
> +			time_t t = time(NULL);
> +			struct tm *tb = localtime(&t);
> +			char buff[16];
>  
> -	if (prio <= libmp_verbosity) {
> -		if (sink != LOGSINK_SYSLOG) {
> -			if (sink == LOGSINK_STDERR_WITH_TIME) {
> -				time_t t = time(NULL);
> -				struct tm *tb = localtime(&t);
> -				char buff[16];
> -
> -				strftime(buff, sizeof(buff),
> -					 "%b %d %H:%M:%S", tb);
> -				buff[sizeof(buff)-1] = '\0';
> -
> -				fprintf(stderr, "%s | ", buff);
> -			}
> -			vfprintf(stderr, fmt, ap);
> +			strftime(buff, sizeof(buff),
> +				 "%b %d %H:%M:%S", tb);
> +			buff[sizeof(buff)-1] = '\0';
> +			fprintf(stderr, "%s | ", buff);
>  		}
> -		else
> -			log_safe(prio + 3, fmt, ap);
> +		vfprintf(stderr, fmt, ap);
>  	}
> +	else
> +		log_safe(prio + 3, fmt, ap);
>  	va_end(ap);
>  }
> diff --git a/libmultipath/debug.h b/libmultipath/debug.h
> index 91ba02b..705a5d7 100644
> --- a/libmultipath/debug.h
> +++ b/libmultipath/debug.h
> @@ -1,5 +1,7 @@
> -void dlog (int sink, int prio, const char * fmt, ...)
> -	__attribute__((format(printf, 3, 4)));
> +#ifndef _DEBUG_H
> +#define _DEBUG_H
> +void dlog (int prio, const char *fmt, ...)
> +	__attribute__((format(printf, 2, 3)));
>  
>  
>  #include <pthread.h>
> @@ -10,8 +12,9 @@ void dlog (int sink, int prio, const char * fmt, ...)
>  extern int logsink;
>  extern int libmp_verbosity;
>  
> -#define condlog(prio, fmt, args...) \
> -	dlog(logsink, prio, fmt "\n", ##args)
> +#ifndef MAX_VERBOSITY
> +#define MAX_VERBOSITY 4
> +#endif
>  
>  enum {
>  	LOGSINK_STDERR_WITH_TIME = 0,
> @@ -19,3 +22,11 @@ enum {
>  	LOGSINK_SYSLOG = 1,
>  };
>  
> +#define condlog(prio, fmt, args...)					\
> +	do {								\
> +		int __p = (prio);					\
> +									\
> +		if (__p <= MAX_VERBOSITY && __p <= libmp_verbosity)	\
> +			dlog(__p, fmt "\n", ##args);			\
> +	} while (0)
> +#endif /* _DEBUG_H */
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 78112a9..cf2f27c 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -274,7 +274,9 @@ static int dm_tgt_prereq (unsigned int *ver)
>  
>  static void _init_versions(void)
>  {
> -	dlog(logsink, 3, VERSION_STRING);
> +	/* Can't use condlog here because of how VERSION_STRING is defined */
> +	if (3 <= libmp_verbosity)
> +		dlog(3, VERSION_STRING);
>  	init_dm_library_version();
>  	init_dm_drv_version();
>  	init_dm_mpath_version();
> diff --git a/tests/test-log.c b/tests/test-log.c
> index 051491e..42ebad0 100644
> --- a/tests/test-log.c
> +++ b/tests/test-log.c
> @@ -6,8 +6,8 @@
>  #include "log.h"
>  #include "test-log.h"
>  
> -__attribute__((format(printf, 3, 0)))
> -void __wrap_dlog (int sink, int prio, const char * fmt, ...)
> +__attribute__((format(printf, 2, 0)))
> +void __wrap_dlog (int prio, const char * fmt, ...)
>  {
>  	char buff[MAX_MSG_SIZE];
>  	va_list ap;
> diff --git a/tests/test-log.h b/tests/test-log.h
> index 2c878c6..6d22cd2 100644
> --- a/tests/test-log.h
> +++ b/tests/test-log.h
> @@ -1,7 +1,8 @@
>  #ifndef _TEST_LOG_H
>  #define _TEST_LOG_H
>  
> -void __wrap_dlog (int sink, int prio, const char * fmt, ...);
> +__attribute__((format(printf, 2, 0)))
> +void __wrap_dlog (int prio, const char * fmt, ...);
>  void expect_condlog(int prio, char *string);
>  
>  #endif
> -- 
> 2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

