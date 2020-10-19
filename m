Return-Path: <SRS0=29P4=D2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113DEC433E7
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 18:56:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6A348223BF
	for <dm-devel@archiver.kernel.org>; Mon, 19 Oct 2020 18:56:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U70f/OIj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A348223BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603133801;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YQ/YEdtGbOh4DwZ4L1/VCpu8c8C5kxiF4U/4W5ibtKg=;
	b=U70f/OIjxXhiENdttbKIumKs4m+bliZCE9DohwlUsLE0goOhMPki/hHD/SSE7AtKCqA0rp
	lK2RcqbuZ42d5VKajYEb04WmgoS7ZlXR/m0zv5Qs/Yi66lqEPuiG860/Ay0md+K+t8pe3o
	hg3ZF0IrZGFUWOaOV1h/A3VCgz1HpZ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-EtjK4iEFMFmmeY2MxSzZ-w-1; Mon, 19 Oct 2020 14:56:36 -0400
X-MC-Unique: EtjK4iEFMFmmeY2MxSzZ-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D36D91005E5D;
	Mon, 19 Oct 2020 18:56:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF7915C1A3;
	Mon, 19 Oct 2020 18:56:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C2503181A06B;
	Mon, 19 Oct 2020 18:56:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09JIuObY020869 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Oct 2020 14:56:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BB7AA5D9EF; Mon, 19 Oct 2020 18:56:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5603B5D9D2;
	Mon, 19 Oct 2020 18:56:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09JIuIGG013639; 
	Mon, 19 Oct 2020 13:56:18 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09JIuH3W013638;
	Mon, 19 Oct 2020 13:56:17 -0500
Date: Mon, 19 Oct 2020 13:56:17 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201019185617.GC3384@octiron.msp.redhat.com>
References: <20201016104501.8700-1-mwilck@suse.com>
	<20201016104501.8700-8-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201016104501.8700-8-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 07/29] multipathd: move conf destruction
 into separate function
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

On Fri, Oct 16, 2020 at 12:44:39PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Also removing the comment about dlog() and dm_write_log().
> dlog() can cope with get_multipath_config() returning NULL,
> and dm_write_log() hasn't accessed the configuration for a while.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 8b9df55..722ef69 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2892,6 +2892,16 @@ set_oom_adj (void)
>  	condlog(0, "couldn't adjust oom score");
>  }
>  
> +static void cleanup_conf(void) {
> +	struct config *conf;
> +
> +	conf = rcu_dereference(multipath_conf);
> +	if (!conf)
> +		return;
> +	rcu_assign_pointer(multipath_conf, NULL);
> +	call_rcu(&conf->rcu, rcu_free_config);
> +}
> +
>  static void cleanup_maps(struct vectors *vecs)
>  {
>  	int queue_without_daemon, i;
> @@ -3196,15 +3206,7 @@ child (__attribute__((unused)) void *param)
>  
>  	if (logsink == 1)
>  		log_thread_stop();
> -
> -	/*
> -	 * Freeing config must be done after condlog() and dm_lib_exit(),
> -	 * because logging functions like dlog() and dm_write_log()
> -	 * reference the config.
> -	 */
> -	conf = rcu_dereference(multipath_conf);
> -	rcu_assign_pointer(multipath_conf, NULL);
> -	call_rcu(&conf->rcu, rcu_free_config);
> +	cleanup_conf();
>  #ifdef _DEBUG_
>  	dbg_free_final(NULL);
>  #endif
> -- 
> 2.28.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

