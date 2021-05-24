Return-Path: <SRS0=3FFM=KT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6194DC2B9F7
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 16:04:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0354161132
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 16:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0354161132
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1621872270;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FC7EGrXm5YnitAfpJLWZedOkC+fuxzfySIWaeueH8WE=;
	b=g0peqzi0BxV0bq9fffiM/gkXcQIy5OwsUyDHdxqKb6qT/IQ3fobrPVuN4BqHnARifKzTSA
	txVXQFDS/SWf427qeDsjTrDKOjwEXMSjglspHnGqRf1xlJfX4YjyUZzVmWevAoqdxy+BBJ
	+LFdgI8MgtdvlMKK+GNGLtdnuQxq3Fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-pY-tK7RbNzeRukoFPGgnEg-1; Mon, 24 May 2021 12:04:26 -0400
X-MC-Unique: pY-tK7RbNzeRukoFPGgnEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6546A101371C;
	Mon, 24 May 2021 16:04:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FD0119C79;
	Mon, 24 May 2021 16:04:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 45AA81801029;
	Mon, 24 May 2021 16:04:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14OG3wu9032614 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 May 2021 12:03:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BA99C5D9FC; Mon, 24 May 2021 16:03:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C6C55D9C0;
	Mon, 24 May 2021 16:03:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14OG3rnX024844; 
	Mon, 24 May 2021 11:03:53 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14OG3rWL024843;
	Mon, 24 May 2021 11:03:53 -0500
Date: Mon, 24 May 2021 11:03:53 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <20210524160353.GU25887@octiron.msp.redhat.com>
References: <20210522191736.62042-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20210522191736.62042-1-xose.vazquez@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: Remove trailing/leading
	whitespaces
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

On Sat, May 22, 2021 at 09:17:36PM +0200, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

If no one objects, I'm fine with this going in. But if anyone has
objections to a whitespace only patch, I'm o.k. with this not going in
as well.

-Ben

> ---
>  Makefile.inc              | 2 +-
>  libmultipath/configure.c  | 2 +-
>  libmultipath/devmapper.c  | 4 ++--
>  libmultipath/sysfs.c      | 2 +-
>  multipath/multipath.8     | 2 +-
>  multipathd/cli_handlers.c | 2 +-
>  multipathd/main.c         | 2 +-
>  7 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index 91100a20..d0ec9b44 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -101,7 +101,7 @@ OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
>  WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
>  		  -Werror=implicit-function-declaration -Werror=format-security \
>  		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS)
> -CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2 
> +CPPFLAGS	:= -Wp,-D_FORTIFY_SOURCE=2
>  CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
>  		   -DBIN_DIR=\"$(bindir)\" -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\" \
>  		   -MMD -MP
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 6ca1f4bb..a6ae3359 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -397,7 +397,7 @@ int setup_map(struct multipath *mpp, char *params, int params_size,
>  		start_io_err_stat_thread(vecs);
>  
>  	n_paths = VECTOR_SIZE(mpp->paths);
> -        /*
> +	/*
>  	 * assign paths to path groups -- start with no groups and all paths
>  	 * in mpp->paths
>  	 */
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 095cbc0c..98ec2a58 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -598,8 +598,8 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
>  		return r;
>  
>  	/* If the resume failed, dm will leave the device suspended, and
> - 	 * drop the new table, so doing a second resume will try using
> - 	 * the original table */
> +	 * drop the new table, so doing a second resume will try using
> +	 * the original table */
>  	if (dm_is_suspended(mpp->alias))
>  		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush, 1,
>  			     udev_flags, 0);
> diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
> index 7a2af1ea..9ff145f2 100644
> --- a/libmultipath/sysfs.c
> +++ b/libmultipath/sysfs.c
> @@ -358,7 +358,7 @@ bool sysfs_is_multipathed(struct path *pp, bool set_wwid)
>  					strchop(pp->wwid);
>  				}
>  			}
> -                } else if (nr < 0)
> +		} else if (nr < 0)
>  			condlog(1, "%s: error reading from %s: %m",
>  				__func__, pathbuf);
>  
> diff --git a/multipath/multipath.8 b/multipath/multipath.8
> index 5b29a5d9..17df59f5 100644
> --- a/multipath/multipath.8
> +++ b/multipath/multipath.8
> @@ -225,7 +225,7 @@ Dry run, do not create or update devmaps.
>  .TP
>  .B \-e
>  Enable all foreign libraries. This overrides the
> -.I enable_foreign 
> +.I enable_foreign
>  option from \fBmultipath.conf(5)\fR.
>  .
>  .TP
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 59d44b45..d70e1dbc 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1215,7 +1215,7 @@ cli_reconfigure(void * v, char ** reply, int * len, void * data)
>  
>  	condlog(2, "reconfigure (operator)");
>  
> -	rc = set_config_state(DAEMON_CONFIGURE); 
> +	rc = set_config_state(DAEMON_CONFIGURE);
>  	if (rc == ETIMEDOUT) {
>  		condlog(2, "timeout starting reconfiguration");
>  		return 1;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 2251e02c..bdd629e7 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2014,7 +2014,7 @@ static int check_path_reinstate_state(struct path * pp) {
>  
>  		/* If path became failed again or continue failed, should reset
>  		 * path san_path_err_forget_rate and path dis_reinstate_time to
> -		 * start a new stable check. 
> +		 * start a new stable check.
>  		 */
>  		if ((pp->state != PATH_UP) && (pp->state != PATH_GHOST) &&
>  			(pp->state != PATH_DELAYED)) {
> -- 
> 2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

