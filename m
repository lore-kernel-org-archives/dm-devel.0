Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB06C4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 02:42:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0A25F23405
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 02:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A25F23405
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608172955;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0HFyHReZiku1ge2YxxOBFn4J8mKBiCXId1p7XipIZa4=;
	b=dfTkfnOJKybDSF2aHO269AR9v1DAe/PJtqdy+4AtzuJMCn6JQhXbd3Uz5C1e5slmtshk4L
	4eNzMpurRsw68rXZ78ETlVpEn1HDqjmVKhtnYlFRPmSEOjEMLzuJfHq0NigWfePUtCtovr
	pTzGO8cVGSE2WMutjlCZHsXkSSvfeHQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-ocUQACIHO2i85Z66poFWig-1; Wed, 16 Dec 2020 21:42:33 -0500
X-MC-Unique: ocUQACIHO2i85Z66poFWig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67D4C800D53;
	Thu, 17 Dec 2020 02:42:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4623B19CB0;
	Thu, 17 Dec 2020 02:42:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C08FB180954D;
	Thu, 17 Dec 2020 02:42:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BH2eDgM006842 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 21:40:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B4E60100238C; Thu, 17 Dec 2020 02:40:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0BE31002382;
	Thu, 17 Dec 2020 02:40:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BH2e8e5027946; 
	Wed, 16 Dec 2020 20:40:08 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BH2e7Nf027945;
	Wed, 16 Dec 2020 20:40:07 -0600
Date: Wed, 16 Dec 2020 20:40:07 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201217024007.GU3103@octiron.msp.redhat.com>
References: <20201216181708.22224-1-mwilck@suse.com>
	<20201216181708.22224-21-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201216181708.22224-21-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 20/29] multipath: use atexit() for cleanup
	handlers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 16, 2020 at 07:16:59PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/main.c | 37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 9ae46ed..1949a1c 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -452,13 +452,19 @@ static bool released_to_systemd(void)
>  	return ret;
>  }
>  
> +static struct vectors vecs;
> +static void cleanup_vecs(void)
> +{
> +	free_multipathvec(vecs.mpvec, KEEP_PATHS);
> +	free_pathvec(vecs.pathvec, FREE_PATHS);
> +}
> +
>  static int
>  configure (struct config *conf, enum mpath_cmds cmd,
>  	   enum devtypes dev_type, char *devpath)
>  {
>  	vector curmp = NULL;
>  	vector pathvec = NULL;
> -	struct vectors vecs;
>  	int r = RTVL_FAIL, rc;
>  	int di_flag = 0;
>  	char * refwwid = NULL;
> @@ -469,6 +475,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
>  	 */
>  	curmp = vector_alloc();
>  	pathvec = vector_alloc();
> +	atexit(cleanup_vecs);
>  
>  	if (!curmp || !pathvec) {
>  		condlog(0, "can not allocate memory");
> @@ -580,9 +587,6 @@ out:
>  	if (refwwid)
>  		FREE(refwwid);
>  
> -	free_multipathvec(curmp, KEEP_PATHS);
> -	free_pathvec(pathvec, FREE_PATHS);
> -
>  	return r;
>  }
>  
> @@ -808,9 +812,13 @@ main (int argc, char *argv[])
>  	bool enable_foreign = false;
>  
>  	libmultipath_init();
> +	if (atexit(dm_lib_exit) || atexit(libmultipath_exit))
> +		condlog(1, "failed to register cleanup handler for libmultipath: %m");
>  	logsink = 0;
>  	if (init_config(DEFAULT_CONFIGFILE))
>  		exit(RTVL_FAIL);
> +	if (atexit(uninit_config))
> +		condlog(1, "failed to register cleanup handler for config: %m");
>  	conf = get_multipath_config();
>  	conf->retrigger_tries = 0;
>  	conf->force_sync = 1;
> @@ -887,7 +895,7 @@ main (int argc, char *argv[])
>  			break;
>  		case 't':
>  			r = dump_config(conf, NULL, NULL) ? RTVL_FAIL : RTVL_OK;
> -			goto out_free_config;
> +			goto out;
>  		case 'T':
>  			cmd = CMD_DUMP_CONFIG;
>  			break;
> @@ -1048,26 +1056,13 @@ main (int argc, char *argv[])
>  		condlog(3, "restart multipath configuration process");
>  
>  out:
> -	dm_lib_exit();
> -
> -	cleanup_foreign();
> -	cleanup_prio();
> -	cleanup_checkers();
> +	put_multipath_config(conf);
> +	if (dev)
> +		FREE(dev);
>  
>  	if (dev_type == DEV_UEVENT)
>  		closelog();
>  
> -out_free_config:
> -	/*
> -	 * Freeing config must be done after dm_lib_exit(), because
> -	 * the logging function (dm_write_log()), which is called there,
> -	 * references the config.
> -	 */
> -	put_multipath_config(conf);
> -	uninit_config();
> -	libmultipath_exit();
> -	if (dev)
> -		FREE(dev);
>  #ifdef _DEBUG_
>  	dbg_free_final(NULL);
>  #endif
> -- 
> 2.29.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

