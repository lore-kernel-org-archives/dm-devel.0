Return-Path: <SRS0=29P4=D2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84DAC433DF
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 17:22:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4AC142224D
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 17:22:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PVp+0MRW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AC142224D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603128168;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CEboWN30agwo9a96bRQHh9h4Yy9oNpakxOXS8fRgPgM=;
	b=PVp+0MRWg7p734CJHU2QhwThbV9sO3ZHwkK/6RDcuJbcRV/rx2l2fIRDblHN6DfdwuJ5/J
	+6h0UrRbb/vUrKVELVyvy/SfiKL2ZMEOwLiojabkVou11a+7QUhL3uwWl73XG1yi3T8gNR
	UIsDL4HkVlTXhjd+Jt6Gt3cgtqvPhEk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-UkFri1_GOWSR1KHJNf4M4Q-1; Mon, 19 Oct 2020 13:22:46 -0400
X-MC-Unique: UkFri1_GOWSR1KHJNf4M4Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1047710066FC;
	Mon, 19 Oct 2020 17:22:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A517B1000239;
	Mon, 19 Oct 2020 17:22:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C100318199F8;
	Mon, 19 Oct 2020 17:22:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09JHMcQd012337 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Oct 2020 13:22:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7ECB875139; Mon, 19 Oct 2020 17:22:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D6E655793;
	Mon, 19 Oct 2020 17:22:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09JHMU61013329; 
	Mon, 19 Oct 2020 12:22:31 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09JHMU6q013328;
	Mon, 19 Oct 2020 12:22:30 -0500
Date: Mon, 19 Oct 2020 12:22:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201019172230.GA3384@octiron.msp.redhat.com>
References: <20201016104329.8337-1-mwilck@suse.com>
	<20201016104329.8337-18-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201016104329.8337-18-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 17/21] libmultipath: add udev and logsink
	symbols
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 16, 2020 at 12:43:25PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> With these symbols added, applications using libmultipath don't
> need to define global variables "udev" and "logsink" any more.
> This comes at the cost of having to call an init function.
> Currently, libmultipath_init() does nothing but initialize
> "udev".
> 
> The linker's symbol lookup order still allows applications to use
> their own "logsink" and "udev" variables, which will take precendence
> over libmultipath's internal ones. In this case, calling
> libmultipath_init() can be skipped, but like before,
> udev should be initialized (using udev_new()) before making any
> libmultipath calls.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.c             | 41 +++++++++++++++++++++++++++
>  libmultipath/config.h             | 46 ++++++++++++++++++++++++++++++-
>  libmultipath/debug.c              |  2 ++
>  libmultipath/libmultipath.version |  8 ++++++
>  4 files changed, 96 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 01b77df..f74417c 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -27,6 +27,47 @@
>  #include "mpath_cmd.h"
>  #include "propsel.h"
>  
> +/*
> + * We don't support re-initialization after
> + * libmultipath_exit().
> + */
> +static bool libmultipath_exit_called;
> +static pthread_once_t _init_once = PTHREAD_ONCE_INIT;
> +static pthread_once_t _exit_once = PTHREAD_ONCE_INIT;
> +struct udev *udev;
> +
> +static void _udev_init(void)
> +{
> +	if (udev)
> +		udev_ref(udev);
> +	else
> +		udev = udev_new();
> +	if (!udev)
> +		condlog(0, "%s: failed to initialize udev", __func__);
> +}
> +
> +static bool _is_libmultipath_initialized(void)
> +{
> +	return !libmultipath_exit_called && !!udev;
> +}
> +
> +int libmultipath_init(void)
> +{
> +	pthread_once(&_init_once, _udev_init);
> +	return !_is_libmultipath_initialized();
> +}
> +
> +static void _libmultipath_exit(void)
> +{
> +	libmultipath_exit_called = true;
> +	udev_unref(udev);
> +}
> +
> +void libmultipath_exit(void)
> +{
> +	pthread_once(&_exit_once, _libmultipath_exit);
> +}
> +
>  static struct config __internal_config;
>  struct config *libmp_get_multipath_config(void)
>  {
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 0329de2..f478df7 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -233,7 +233,51 @@ struct config {
>  	char *enable_foreign;
>  };
>  
> -extern struct udev * udev;
> +/**
> + * extern variable: udev
> + *
> + * A &struct udev instance used by libmultipath. libmultipath expects
> + * a valid, initialized &struct udev in this variable.
> + * An application can define this variable itself, in which case
> + * the applications's instance will take precedence.
> + * The application can initialize and destroy this variable by
> + * calling libmultipath_init() and libmultipath_exit(), respectively,
> + * whether or not it defines the variable itself.
> + * An application can initialize udev with udev_new() before calling
> + * libmultipath_init(), e.g. if it has to make libudev calls before
> + * libmultipath calls. If an application wants to keep using the
> + * udev variable after calling libmultipath_exit(), it should have taken
> + * an additional reference on it beforehand. This is the case e.g.
> + * after initiazing udev with udev_new().
> + */
> +extern struct udev *udev;
> +
> +/**
> + * libmultipath_init() - library initialization
> + *
> + * This function initializes libmultipath data structures.
> + * It is light-weight; some other initializations, like device-mapper
> + * initialization, are done lazily when the respective functionality
> + * is required.
> + *
> + * Clean up by libmultipath_exit() when the program terminates.
> + * It is an error to call libmultipath_init() after libmultipath_exit().
> + * Return: 0 on success, 1 on failure.
> + */
> +int libmultipath_init(void);
> +
> +/**
> + * libmultipath_exit() - library un-initialization
> + *
> + * This function un-initializes libmultipath data structures.
> + * It is recommended to call this function at program exit.
> + *
> + * Calls to libmultipath_init() after libmultipath_exit() will fail
> + * (in other words, libmultipath can't be re-initialized).
> + * Any other libmultipath calls after libmultipath_exit() may cause
> + * undefined behavior.
> + */
> +void libmultipath_exit(void);
>  
>  int find_hwe (const struct _vector *hwtable,
>  	      const char * vendor, const char * product, const char *revision,
> diff --git a/libmultipath/debug.c b/libmultipath/debug.c
> index 4128cb9..b3a1de9 100644
> --- a/libmultipath/debug.c
> +++ b/libmultipath/debug.c
> @@ -15,6 +15,8 @@
>  #include "defaults.h"
>  #include "debug.h"
>  
> +int logsink;
> +
>  void dlog (int sink, int prio, const char * fmt, ...)
>  {
>  	va_list ap;
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 3e780fc..0c300c8 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -261,3 +261,11 @@ global:
>  	init_config;
>  	uninit_config;
>  } LIBMULTIPATH_2.1.0;
> +
> +LIBMULTIPATH_2.3.0 {
> +global:
> +	udev;
> +	logsink;
> +	libmultipath_init;
> +	libmultipath_exit;
> +} LIBMULTIPATH_2.2.0;
> -- 
> 2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

