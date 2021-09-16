Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FE2C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 00:14:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6DF0961247
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 00:14:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6DF0961247
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1631751267;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dxRsCKSMjIh19H/Tv6joZhbu4O1zJFtBGWCFSaVQE0w=;
	b=Spylwu/qWObBjsFQOv+h+JadLpQkvqxWGsi8xXz/fjhHu5OgupbkR8OzDCm1tvkAQdtJrI
	V98YuAz/VSNY0eanT9RlXx11u1po19mEFuXwCgeuXwzyn7Js3j1fCuEs7gJ1NsLNM+rhwv
	SGr4VuJyJahRjiTXutxA0bpjY56VOsI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-s0HIzzOPMhim3Ajtj2Y55Q-1; Wed, 15 Sep 2021 20:14:26 -0400
X-MC-Unique: s0HIzzOPMhim3Ajtj2Y55Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66F531006AA6;
	Thu, 16 Sep 2021 00:14:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4591F5D9CA;
	Thu, 16 Sep 2021 00:14:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A8985180142F;
	Thu, 16 Sep 2021 00:14:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G0Deof017682 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Sep 2021 20:13:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0126F6A902; Thu, 16 Sep 2021 00:13:40 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABFF85453A;
	Thu, 16 Sep 2021 00:13:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 18G0DULi006902; 
	Wed, 15 Sep 2021 19:13:31 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 18G0DTvV006901;
	Wed, 15 Sep 2021 19:13:29 -0500
Date: Wed, 15 Sep 2021 19:13:29 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210916001329.GZ3087@octiron.msp.redhat.com>
References: <20210910114120.13665-1-mwilck@suse.com>
	<20210910114120.13665-15-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210910114120.13665-15-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com,
	Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [dm-devel] [PATCH 14/35] multipathd: add "force_reconfigure"
	option
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

On Fri, Sep 10, 2021 at 01:40:59PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since e3270f7 ("multipathd: use weaker "force_reload" at startup"),
> (multipath-tools 0.7.0), we only reload those maps that must be
> reloaded during startup. "multipath reconfigure", OTOH, reloads
> every map, which may take a long time on systems with lots of
> storage devices, as every DM_DEVICE_RELOAD ioctl involves a
> suspend/resume cycle.
> 
> The logic we use during startup is actually very robust and catches
> all cases in which a reload is necessary. "reconfigure" operations
> are often done because of configuration changes, and usually don't
> require a full reload of every map.
> 
> This patch changes the default behavior of "multipath reconfigure"
> to "weak" reload, like we do on startup since e3270f7. The behavior
> can be changed by setting the configuration option
> "force_reconfigure yes" before starting the reconfigure operation.
> "multipath -r" is also affected, but "multipath -D -r" is not.
> 
> It would have been nice to have introduced a new cli command
> "reconfigure force" instead, but the way "reconfigure" is
> implemented, that would have required a major rewrite of the code.

This looks o.k. But I don't think it would be that hard to add a new
multipathd command to reconfigure all the devices.  My personal
preference would be to leave force_reconfigure off by default, so that
we keep the same behavior, and add a command to force a full reconfig.
I'll try to work up a patch with my idea that can apply on top of this.

But the code itself looks fine, and if we don't agree on my patch, I can
always just change the default for the RHEL version, at least until the
next major release, so

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.c      |  1 +
>  libmultipath/config.h      |  1 +
>  libmultipath/configure.c   | 19 ++++++++++++++++++-
>  libmultipath/defaults.h    |  1 +
>  libmultipath/dict.c        |  4 ++++
>  multipath/multipath.8      |  6 ++++--
>  multipath/multipath.conf.5 | 17 +++++++++++++++++
>  multipathd/main.c          | 18 +++++-------------
>  multipathd/multipathd.8    |  6 ++++--
>  9 files changed, 55 insertions(+), 18 deletions(-)
> 
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 30046a1..a1ef4c3 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -869,6 +869,7 @@ int _init_config (const char *file, struct config *conf)
>  	conf->ghost_delay = DEFAULT_GHOST_DELAY;
>  	conf->all_tg_pt = DEFAULT_ALL_TG_PT;
>  	conf->recheck_wwid = DEFAULT_RECHECK_WWID;
> +	conf->force_reconfigure = DEFAULT_FORCE_RECONFIGURE;
>  	/*
>  	 * preload default hwtable
>  	 */
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 933fe0d..4617177 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -189,6 +189,7 @@ struct config {
>  	int skip_delegate;
>  	unsigned int sequence_nr;
>  	int recheck_wwid;
> +	int force_reconfigure;
>  
>  	char * multipath_dir;
>  	char * selector;
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 7edb355..262657e 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -1093,12 +1093,27 @@ out:
>  	return ret;
>  }
>  
> +static const char* reconfigure_str(int force)
> +{
> +	switch(force) {
> +	case FORCE_RELOAD_NONE:
> +		return "new";
> +	case FORCE_RELOAD_WEAK:
> +		return "changed";
> +	case FORCE_RELOAD_YES:
> +		return "all";
> +	default:
> +		return "<undefined>";
> +	}
> +}
> +
>  /*
>   * The force_reload parameter determines how coalesce_paths treats existing maps.
>   * FORCE_RELOAD_NONE: existing maps aren't touched at all
>   * FORCE_RELOAD_YES: all maps are rebuilt from scratch and (re)loaded in DM
>   * FORCE_RELOAD_WEAK: existing maps are compared to the current conf and only
> - * reloaded in DM if there's a difference. This is useful during startup.
> + * reloaded in DM if there's a difference. This is normally sufficient.
> + * This is controlled by the "force_reconfigure" config option.
>   */
>  int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
>  		    int force_reload, enum mpath_cmds cmd)
> @@ -1117,6 +1132,8 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
>  	int allow_queueing;
>  	struct bitfield *size_mismatch_seen;
>  
> +	condlog(2, "%s: reloading %s maps", __func__,
> +		reconfigure_str(force_reload));
>  	/* ignore refwwid if it's empty */
>  	if (refwwid && !strlen(refwwid))
>  		refwwid = NULL;
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index c27946c..eab08a0 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -56,6 +56,7 @@
>  #define DEFAULT_RECHECK_WWID RECHECK_WWID_OFF
>  /* Enable no foreign libraries by default */
>  #define DEFAULT_ENABLE_FOREIGN "NONE"
> +#define DEFAULT_FORCE_RECONFIGURE YN_NO
>  
>  #define CHECKINT_UNDEF		UINT_MAX
>  #define DEFAULT_CHECKINT	5
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 7a72738..fee08cf 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -299,6 +299,9 @@ declare_def_snprint(verbosity, print_int)
>  declare_def_handler(reassign_maps, set_yes_no)
>  declare_def_snprint(reassign_maps, print_yes_no)
>  
> +declare_def_handler(force_reconfigure, set_yes_no)
> +declare_def_snprint(force_reconfigure, print_yes_no)
> +
>  declare_def_handler(multipath_dir, set_str)
>  declare_def_snprint(multipath_dir, print_str)
>  
> @@ -1713,6 +1716,7 @@ init_keywords(vector keywords)
>  	install_keyword("polling_interval", &checkint_handler, &snprint_def_checkint);
>  	install_keyword("max_polling_interval", &def_max_checkint_handler, &snprint_def_max_checkint);
>  	install_keyword("reassign_maps", &def_reassign_maps_handler, &snprint_def_reassign_maps);
> +	install_keyword("force_reconfigure", &def_force_reconfigure_handler, &snprint_def_force_reconfigure);
>  	install_keyword("multipath_dir", &def_multipath_dir_handler, &snprint_def_multipath_dir);
>  	install_keyword("path_selector", &def_selector_handler, &snprint_def_selector);
>  	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_pgpolicy);
> diff --git a/multipath/multipath.8 b/multipath/multipath.8
> index 17df59f..b3980c0 100644
> --- a/multipath/multipath.8
> +++ b/multipath/multipath.8
> @@ -264,9 +264,11 @@ Force new maps to use the specified policy, overriding the configuration in
>  .
>  .TP
>  .B \-r
> -Force a reload of all existing multipath maps. This command is delegated to
> +Reload existing multipath maps. This command is delegated to
>  the multipathd daemon if it's running. In this case, other command line
> -switches of the \fImultipath\fR command have no effect.
> +switches of the \fImultipath\fR command have no effect, and multipathd
> +executes a \fIreconfigure\fR command. See the \fIforce_reconfigure\fR option
> +in \fBmultipath.conf(5)\fR.
>  .
>  .TP
>  .BI \-R " retries"
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 42a15ff..814de66 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -34,6 +34,7 @@ or \fBmultipathd show config\fR command.
>  .SH SYNTAX
>  .\" ----------------------------------------------------------------------------
>  .
> +.
>  The configuration file contains entries of the form:
>  .RS
>  .nf
> @@ -165,6 +166,22 @@ The default is: \fB4 * polling_interval\fR
>  .
>  .
>  .TP
> +.B force_reconfigure
> +This controls what happens when \fBmultipathd reconfigure\fR or
> +\fBmultipath -r\fR is executed. If set to \fIyes\fR, all multipath
> +maps will be reloaded, regardless if this is necessary or not, which
> +may take a lot of time on large systems. This used to be the default
> +on previous versions of multipath-tools. If set to \fIno\fR,
> +only those maps will be reloaded for which some parameters
> +have changed that are relevant for the device-mapper configuration of the map.
> +This is the behavior during \fImultipathd\fR startup.
> +.RS
> +.TP
> +The default is: \fBno\fR
> +.RE
> +.
> +.
> +.TP
>  .B reassign_maps
>  Enable reassigning of device-mapper maps. With this option multipathd
>  will remap existing device-mapper maps to always point to multipath
> diff --git a/multipathd/main.c b/multipathd/main.c
> index bda51c9..6d7c8c9 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2594,14 +2594,13 @@ checkerloop (void *ap)
>  }
>  
>  int
> -configure (struct vectors * vecs)
> +configure (struct vectors *vecs, bool force)
>  {
>  	struct multipath * mpp;
>  	struct path * pp;
>  	vector mpvec;
>  	int i, ret;
>  	struct config *conf;
> -	static int force_reload = FORCE_RELOAD_WEAK;
>  
>  	if (!vecs->pathvec && !(vecs->pathvec = vector_alloc())) {
>  		condlog(0, "couldn't allocate path vec in configure");
> @@ -2649,15 +2648,9 @@ configure (struct vectors * vecs)
>  	if (should_exit())
>  		goto fail;
>  
> -	/*
> -	 * create new set of maps & push changed ones into dm
> -	 * In the first call, use FORCE_RELOAD_WEAK to avoid making
> -	 * superfluous ACT_RELOAD ioctls. Later calls are done
> -	 * with FORCE_RELOAD_YES.
> -	 */
> -	ret = coalesce_paths(vecs, mpvec, NULL, force_reload, CMD_NONE);
> -	if (force_reload == FORCE_RELOAD_WEAK)
> -		force_reload = FORCE_RELOAD_YES;
> +	ret = coalesce_paths(vecs, mpvec, NULL,
> +			     force ? FORCE_RELOAD_YES : FORCE_RELOAD_WEAK,
> +			     CMD_NONE);
>  	if (ret != CP_OK) {
>  		condlog(0, "configure failed while coalescing paths");
>  		goto fail;
> @@ -2769,8 +2762,7 @@ reconfigure (struct vectors * vecs)
>  	rcu_assign_pointer(multipath_conf, conf);
>  	call_rcu(&old->rcu, rcu_free_config);
>  
> -	configure(vecs);
> -
> +	configure(vecs, conf->force_reconfigure == YN_YES);
>  
>  	return 0;
>  }
> diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
> index 048a838..b52a617 100644
> --- a/multipathd/multipathd.8
> +++ b/multipathd/multipathd.8
> @@ -195,8 +195,10 @@ group index, starting with 1.
>  .
>  .TP
>  .B reconfigure
> -Reconfigures the multipaths. This should be triggered automatically after anyi
> -hotplug event.
> +Reconfigure the multipaths. This is only necessary after applying configuration
> +changes, as multipathd sets up new devices automatically. See the
> +\fIforce_reconfigure\fR option in \fBmultipath.conf(5)\fR. Note that multipathd
> +can't process most commands while reconfiguring.
>  .
>  .TP
>  .B suspend map|multipath $map
> -- 
> 2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

